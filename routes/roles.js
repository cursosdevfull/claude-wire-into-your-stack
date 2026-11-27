const express = require('express');
const store = require('../db/store');

const router = express.Router();

// GET /roles — list all roles.
router.get('/', (req, res) => {
  res.json(store.listRoles());
});

// GET /roles/:id — fetch one role, or 404 if it doesn't exist.
router.get('/:id', (req, res) => {
  const role = store.getRoleById(Number(req.params.id));
  if (!role) {
    return res.status(404).json({ error: 'Role not found' });
  }
  return res.json(role);
});

module.exports = router;
