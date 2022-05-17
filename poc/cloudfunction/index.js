const functions = require('@google-cloud/functions-framework');
const escapeHtml = require('escape-html');

// HTTP Cloud Function.
functions.http('helloHttp', (req, res) => {
  res.send(`Hello ${escapeHtml(req.query.name || req.body.name || 'World')}!`);
});
