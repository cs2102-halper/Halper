
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('accounts').del()
    .then(function () {
      // Inserts seed entries
      return knex('accounts').insert([
        {email: 'email1@gmail.com', password: 'password1', points: '0', lid: '0'},
        {email: 'email2@gmail.com', password: 'password2', points: '0', lid: '0'},
        {email: 'email3@gmail.com', password: 'password3', points: '0', lid: '0'},
        {email: 'email4@gmail.com', password: 'password4', points: '0', lid: '0'},
        {email: 'email5@gmail.com', password: 'password5', points: '0', lid: '0'},
        {email: 'email6@gmail.com', password: 'password6', points: '0', lid: '0'},
        {email: 'email7@gmail.com', password: 'password7', points: '0', lid: '0'}
      ]);
    });
};
