var express = require('express');
var router = express.Router();

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

/* SQL Query */
var sql_query = 'INSERT INTO accounts VALUES';

// GET
router.get('/', function(req, res, next) {
	res.render('insert', { title: 'Modifying Database' });
});

// POST
router.post('/', function(req, res, next) {
	// Retrieve Information
	var email  = req.body.email;
	var username    = req.body.username;
	var password = req.body.password;
	
	// Construct Specific SQL Query
 	var insert_query = sql_query + "( DEFAULT, lower('" + email + "'), lower('" + username + "'),'" + password + "')";
	
	pool.query(insert_query, (err, data) => {
		res.redirect('/select')
	});
});

module.exports = router;
