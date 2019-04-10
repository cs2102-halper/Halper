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

var OpenTask = bookshelf.Model.extend({
  tableName: 'opentasks',
  idAttribute: 'tid',
  hasTimestamps: false
});

module.exports = OpenTask;