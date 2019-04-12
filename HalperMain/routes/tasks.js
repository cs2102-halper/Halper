const express = require('express');
const router = express.Router();
const Tasks = require('../models/Tasks')
const Task = require('../models/Task')
const OpenTask = require('../models/OpenTask')
const BidsRecords = require('../models/BidsRecords')
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

// Get open task list
router.get('/', (req, res) => 
  knex.raw('select * from taskcreation natural join opentasks').then(function(opentasks) {
    res.render('tasks', {tasks: opentasks.rows});
  })
);

// Get open task detail
router.get('/details/:tid', function(req, res) {
  knex.raw('select COALESCE(min(price), 0) as min from bidsrecords where tid = ?',[req.params.tid]).then(function(lowestBidPrice) {
    knex.raw('select * from taskcreation where tid = ?', [req.params.tid]).then(function(tasks) {
      knex.raw('select count(*) from bidsrecords b where b.tid = ?', [req.params.tid]).then(function(numBidders) {
        res.render('taskdetails', {tasks: tasks.rows, lowestBidPrice: lowestBidPrice.rows, numBidders: numBidders.rows});
      })
    })
  })
})

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