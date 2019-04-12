
exports.up = function(knex, Promise) {
    return Promise.all([
        knex.schema.createTable('taskcreation', table => {
            table.increments('tid').primary()
            table.integer('aid').notNullable().references('aid').inTable('accounts')
            table.text('title').notNullable()
            table.timestamp('timerecord').notNullable().defaultTo('now()');
            table.decimal('price', 5, 2).notNullable()
            table.integer('manpower').notNullable()
            table.text('description').notNullable()
            table.decimal('timerequired', 2, 0).notNullable()
            table.decimal('opentime', 2, 0).notNullable()
        })
      ])
};

exports.down = function(knex, Promise) {
    return Promise.all([
        knex.schema.dropTable('taskcreation')
      ])
};
