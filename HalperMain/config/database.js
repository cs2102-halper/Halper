const Sequelize = require('sequelize');

module.exports =  new Sequelize('Halper', 'postgres', 'postgres', {
  host: 'localhost',
  dialect: 'postgres',
  operatorsAliases: false,
  omitNull: true,

  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  },
});