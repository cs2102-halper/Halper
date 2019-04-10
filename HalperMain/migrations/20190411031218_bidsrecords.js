
exports.up = function(knex, Promise) {
    return Promise.all([
        knex.schema.createTable('bidsrecords', table => {
            table.integer('tid').notNullable().references('taskcreation')
            table.integer('aid').notNullable().references('accounts')
            table.increment('bid').primary()
            table.decimal('price', 5, 2).notNullable();
            table.timestamp('time').defaultTo(knex.fn.now()).notNullable();
        })
      ])
};

exports.down = function(knex, Promise) {
    return Promise.all([
        knex.schema.dropTable('bidsrecords')
      ])
};
