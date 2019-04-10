
exports.up = function(knex, Promise) {
    return Promise.all([
        knex.schema.createTable('accounts', table => {
            table.increment('aid').primary()
            table.text('email').notNullable()
            table.text('username').notNullable()
            table.text('password').notNullable()
            table.integer('points')
            table.integer('lid')
        })
      ])
};

exports.down = function(knex, Promise) {
    return Promise.all([
        knex.schema.dropTable('accounts')
      ])
};