
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('taskcreation').del()
    .then(function () {
      // Inserts seed entries
      return knex('taskcreation').insert([
        {aid: 1, title: 'Title1', price: '100', manpower: '5', description: 'generic task description', timerequired: '5', opentime: '10'},
        {aid: 2, title: 'Title2', price: '100', manpower: '5', description: 'generic task description', timerequired: '5', opentime: '10'},
        {aid: 3, title: 'Title3', price: '100', manpower: '5', description: 'generic task description', timerequired: '5', opentime: '10'}
      ]);
    });
};
