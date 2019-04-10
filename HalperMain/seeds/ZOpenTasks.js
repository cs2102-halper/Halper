
exports.seed = function(knex, Promise) {
    // Deletes ALL existing entries
    return knex('opentasks').del()
      .then(function () {
        // Inserts seed entries
        return knex('opentasks').insert([
          {tid: '1'},
          {tid: '2'},
          {tid: '3'}
        ]);
      });
  };
  