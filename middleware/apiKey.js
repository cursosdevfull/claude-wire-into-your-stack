// Rejects requests that don't send an `x-api-key` header.
// Only presence is checked — the key's value is not validated.
function requireApiKey(req, res, next) {
  const apiKey = req.get('x-api-key');
  if (!apiKey || !apiKey.trim()) {
    return res.status(401).json({ error: 'API key is required' });
  }
  return next();
}

module.exports = requireApiKey;
