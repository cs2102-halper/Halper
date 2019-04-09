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

var Task = bookshelf.Model.extend({
  tableName: 'taskcreation',
  idAttribute: 'tid',
  hasTimestamps: false
});

module.exports = Task;