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
const bcrypt = require('bcrypt-nodejs');

var Account = bookshelf.Model.extend({
  tableName: 'accounts',
  idAttribute: 'aid',
  hasTimestamps: false,
  generateHash: function(password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
  },
  validPassword: function(password) {
    return bcrypt.compareSync(password, 'accounts.password');
  }
});

module.exports = Account;
