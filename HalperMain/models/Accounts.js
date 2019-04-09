const Account = require('../models/Account')
var knex = require('knex')({
    client: 'postgresql',
    connection: {
      host     : 'localhost',
      user     : 'postgres',
      password : 'postgres',
      database : 'Halper',
      charset  : 'utf8'
    }
  });
var bookshelf = require('bookshelf')(knex);

var Accounts = bookshelf.Collection.extend({
    model: Account
  });

module.exports = Accounts;