
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('accounts').del()
    .then(function () {
      // Inserts seed entries
      return knex('accounts').insert([
        {email: 'email1@gmail.com', password: 'password1', points: '0', lid: '0'},
        {email: 'email2@gmail.com', password: 'password2', points: '0', lid: '0'},
        {email: 'email3@gmail.com', password: 'password3', points: '0', lid: '0'}
      ]);
    });
};
