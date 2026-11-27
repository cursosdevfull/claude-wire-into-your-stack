const test = require('node:test');
const assert = require('node:assert');
const request = require('supertest');
const app = require('../server');
const store = require('../db/store');

const API_KEY = 'test-key';

test.beforeEach(() => store.reset());

test('GET /roles returns an array', async () => {
  const res = await request(app).get('/roles').set('x-api-key', API_KEY);
  assert.equal(res.status, 200);
  assert.ok(Array.isArray(res.body));
});

test('GET /roles/:id returns 404 for a missing role', async () => {
  const res = await request(app).get('/roles/999').set('x-api-key', API_KEY);
  assert.equal(res.status, 404);
  assert.deepEqual(res.body, { error: 'Role not found' });
});

test('GET /roles without x-api-key returns 401', async () => {
  const res = await request(app).get('/roles');
  assert.equal(res.status, 401);
  assert.deepEqual(res.body, { error: 'API key is required' });
});
