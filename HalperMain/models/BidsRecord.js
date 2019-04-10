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
  
  var BidsRecord = bookshelf.Model.extend({
    tableName: 'bidsrecords',
    idAttribute: 'bid',
    hasTimestamps: false
  });
  
  module.exports = BidsRecord;
  