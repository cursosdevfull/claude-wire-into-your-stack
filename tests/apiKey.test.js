const test = require('node:test');
const assert = require('node:assert');
const request = require('supertest');
const app = require('../server');
const store = require('../db/store');

test.beforeEach(() => store.reset());

test('/users without x-api-key returns 401', async () => {
  const res = await request(app).get('/users');
  assert.equal(res.status, 401);
  assert.deepEqual(res.body, { error: 'API key is required' });
});

test('/users with an empty x-api-key returns 401', async () => {
  const res = await request(app).get('/users').set('x-api-key', '   ');
  assert.equal(res.status, 401);
  assert.deepEqual(res.body, { error: 'API key is required' });
});

test('POST /users without x-api-key returns 401 and creates nothing', async () => {
  const res = await request(app)
    .post('/users')
    .send({ name: 'Grace Hopper', email: 'grace@example.com' });
  assert.equal(res.status, 401);
  assert.equal(store.listUsers().length, 2);
});

test('/users with any x-api-key value is allowed through', async () => {
  const res = await request(app).get('/users').set('x-api-key', 'anything');
  assert.equal(res.status, 200);
});

test('/health does not require an API key', async () => {
  const res = await request(app).get('/health');
  assert.equal(res.status, 200);
});
