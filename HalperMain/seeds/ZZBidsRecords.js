
exports.seed = function(knex, Promise) {
    // Deletes ALL existing entries
    return knex('bidsrecords').del()
      .then(function () {
        // Inserts seed entries
        return knex('bidsrecords').insert([
          {tid: '1', aid: '2', price: '70'},
          {tid: '2', aid: '3', price: '22'},
          {tid: '2', aid: '4', price: '33.50'},
          {tid: '2', aid: '5', price: '100'},
          {tid: '2', aid: '6', price: '12.99'},
          {tid: '2', aid: '7', price: '30.00'},
        ]);
      });
  };
  