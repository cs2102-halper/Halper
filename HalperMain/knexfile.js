// Update with your config settings.
require('dotenv').config()

module.exports = {
  client: 'postgresql',
  connection: process.env.DATABASE_URL,
  useNullAsDefault: true,
  pool: {
    min: 0,
    max: 10
  }
};