const Task = require('../models/Task')
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

var Tasks = bookshelf.Collection.extend({
    model: Task
});

module.exports = Tasks;