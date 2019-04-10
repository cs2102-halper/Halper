const express = require('express');
const router = express.Router();
const Tasks = require('../models/Tasks')
const Task = require('../models/Task')
var knex = require('knex')({
  client: 'postgresql',
  connection: {
    host     : 'localhost',
    user     : 'postgres',
    password : 'postgres',
    database : 'Halper',
    charset  : 'utf8'
  }
});

// Get task list
router.get('/', (req, res) => 
    Tasks.forge().fetch().then(function(collection) {
      alltasks = collection.serialize();
      console.log(alltasks);
      res.render('tasks', {tasks: alltasks});
    })
);

// // Display add task form
// router.get('/add', (req, res) => res.render('add'));

// // Add a task
// router.post('/add', (req, res) => {
//   let { title, manpower, price, description, timerequired, opentime } = req.body;
//   let errors = [];

//   // Validate Fields
//   if(!title) {
//     errors.push({ text: 'Please include a title' });
//   }
//   if(!manpower) {
//     errors.push({ text: 'Please specify number of manpower' });
//   }
//   if(!price) {
//     errors.push({ text: 'Please add a price to pay' });
//   }
//   if(!description) {
//     errors.push({ text: 'Please provide a description' });
//   }
//   if(!timerequired) {
//     errors.push({ text: 'Please provide a task duration' });
//   }
//   if(!opentime) {
//     errors.push({ text: 'Please provide a duration for task availability' });
//   }

//   // Check for errors
//   if(errors.length > 0) {
//     res.render('add', {
//       errors,
//       title, 
//       manpower, 
//       price, 
//       description, 
//       timerequired,
//       opentime
//     });
//   }

//   var aid = 1; // place holder until passport is set up

//     knex('taskcreation').insert({
//       aid: aid,
//       title: title,
//       manpower: manpower,
//       price: price,
//       description: description,
//       timerequired: timerequired,
//       opentime: opentime
//   }).then(function(result) {
//     if(result) res.redirect('/tasks');
//   });

// });

// Search for tasks
router.get('/search', (req, res) => {
  let { term } = req.query;

  // Make lowercase
  term = term.toLowerCase();

  Tasks.query('where', 'title', 'ilike', '%' + term + '%').fetch().then(function(collection) {
    alltasks = collection.serialize();
    console.log(alltasks);
    res.render('tasks', {tasks: alltasks})
  });

});

module.exports = router;