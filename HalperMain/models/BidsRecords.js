const BidsRecord = require('../models/BidsRecord')
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

var BidRecords = bookshelf.Collection.extend({
    model: BidsRecord
  });

module.exports = BidRecords;