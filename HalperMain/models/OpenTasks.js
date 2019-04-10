const OpenTask = require('../models/OpenTask')
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

var OpenTasks = bookshelf.Collection.extend({
    model: OpenTask
});

module.exports = OpenTasks;