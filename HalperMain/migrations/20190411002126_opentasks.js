
exports.up = function(knex, Promise) {
    return Promise.all([
        knex.schema.createTable('opentasks', table => {
            table.increment('tid').primary().references('taskcreation')
        })
      ])
};

exports.down = function(knex, Promise) {
    return Promise.all([
        knex.schema.dropTable('opentasks')
      ])
};
