var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
  res.render('acceptHalp', { title: 'Accept Halp' });
});

module.exports = router;
