//routes/accounts.js
const Tasks = require('../models/Tasks')
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

module.exports = function(app, passport) {

    app.get('/account', function(req, res) {
        // render the page and pass in any flash data if it exists
        if(req.isAuthenticated()) {
            var userID = req.user.id;
            knex.raw('select * from accounts where aid = ?', [userID]).then(function(data){
                var userDetails = data.rows;
                res.render('profile', {
                    user : userDetails // get the user out of session and pass to template
                });
            })
        } 
        else res.render('login-index', { message: req.flash('loginMessage') }); 
    });

    // =====================================
    // LOGIN ===============================
    // =====================================
    // show the login form
    app.get('/login', function(req, res) {
        // render the page and pass in any flash data if it exists
        res.render('login', { message: req.flash('loginMessage') }); 
    });

    // process the login form
    app.post('/login', passport.authenticate('local-login', {
        successRedirect : '/profile', // redirect to the secure profile section
        failureRedirect : '/login', // redirect back to the signup page if there is an error
        failureFlash : true // allow flash messages
    }));

    // =====================================
    // SIGNUP ==============================
    // =====================================
    // show the signup form
    app.get('/signup', function(req, res) {
        // render the page and pass in any flash data if it exists
        res.render('signup', { message: req.flash('signupMessage') });
    });

    // process the signup form
    app.post('/signup', passport.authenticate('local-signup', {
        successRedirect : '/login', // redirect to the secure profile section
        failureRedirect : '/signup', // redirect back to the signup page if there is an error
        failureFlash : true, // allow flash messages
        session: false
    }));
+
    app.post('/login', passport.authenticate('local-signup'),
        function(req, res) {
        req.flash('loginMessage', 'Account successfully created, please log in!');
        res.redirect('/login');
    });

    // =====================================
    // PROFILE SECTION =====================
    // =====================================
    // we will want this protected so you have to be logged in to visit
    // we will use route middleware to verify this (the isLoggedIn function)
    app.get('/profile', isLoggedIn, function(req, res) {
        var userID = req.user.id;
        knex.raw('select * from accounts where aid = ?', [userID]).then(function(data){
            var userDetails = data.rows;
            res.render('profile', {
                user : userDetails // get the user out of session and pass to template
            });
        })
    });

    // =====================================
    // LOGOUT ==============================
    // =====================================
    app.get('/logout', function(req, res) {
        req.logout();
        res.redirect('/');
    });

    // Display add task form
    app.get('/add', isLoggedIn, function(req, res) {
        res.render('add');
    });

    // Add a task
    app.post('/add', isLoggedIn, function(req, res) {
    let { title, manpower, price, description, timerequired, opentime } = req.body;
    let errors = [];
    var aid = req.user.id;

    // Validate Fields
    if(!title) {
        errors.push({ text: 'Please include a title' });
    }
    if(!manpower) {
        errors.push({ text: 'Please specify number of manpower' });
    }
    if(!price) {
        errors.push({ text: 'Please add a price to pay' });
    }
    if(!description) {
        errors.push({ text: 'Please provide a description' });
    }
    if(!timerequired) {
        errors.push({ text: 'Please provide a task duration' });
    }
    if(!opentime) {
        errors.push({ text: 'Please provide a duration for task availability' });
    }

    // Check for errors
    if(errors.length > 0) {
        res.render('add', {
        errors,
        title, 
        manpower, 
        price, 
        description, 
        timerequired,
        opentime
        });
    }

        knex.transaction(trx => {
            trx.raw('select taskCreationToOpenTask(?, ?, ?, ?, ?, ?, ?)', [aid, title, price, manpower, description, timerequired, opentime])
            .then(trx.commit)
            .catch(trx.rollback)
            .then(function(result) {
            if(result) res.redirect('/tasks');})
        })

    });

    // View account specific all task
    app.get('/alltasks', isLoggedIn, (req, res) => 
        Tasks.query('where', 'aid', '=', req.user.id).fetch().then(function(collection) {
            alltasks = collection.serialize();
            console.log(alltasks);
            res.render('tasks', {tasks: alltasks});
        })
    );

    // View account specific open task
    app.get('/opentasks', isLoggedIn, (req, res) => {
        var aid = req.user.id;
        knex.raw('select * from taskcreation natural join opentasks where taskcreation.aid = ?', [aid]).then(function(opentasks) {
            opentasks = opentasks.rows;
            res.render('tasks', {tasks: opentasks});
        })
        }
    );

    // View account specific task in progress
    app.get('/taskinprogress', isLoggedIn, (req, res) => {
        var aid = req.user.id;
        knex.raw('select * from taskcreation natural join inprogresstasks where taskcreation.aid = ?', [aid]).then(function(inprogresstask) {
            inprogresstask = inprogresstask.rows;
            res.render('tasks', {tasks: inprogresstask});
        })
        }
    );

    // View account specific completed task
    app.get('/completedtasks', isLoggedIn, (req, res) => {
        var aid = req.user.id;
        knex.raw('select * from (select c.tid from completedtasks c) as k natural join taskcreation t where t.aid = ?', [aid]).then(function(completedtasks) {
            completedtasks = completedtasks.rows;
            console.log(completedtasks)
            res.render('completedtasks', {tasks: completedtasks});
        })
        }
    );

    // Get completed task detail (You can view your reviews here)
    app.get('/tasks/completed/:tid', function(req, res) {
        knex.raw('select COALESCE(min(price), 0) as min from bidsrecords where tid = ?',[req.params.tid]).then(function(lowestBidPrice) {
        knex.raw('select * from taskcreation where tid = ?', [req.params.tid]).then(function(tasks) {
            knex.raw('select count(*) from bidsrecords b where b.tid = ?', [req.params.tid]).then(function(numBidders) {
                knex.raw('select * from reviews where tid = ?', [req.params.tid]).then(function(reviews){
                    console.log([req.params.tid])
                    res.render('completed', {tasks: tasks.rows, lowestBidPrice: lowestBidPrice.rows, numBidders: numBidders.rows, reviews: reviews.rows});
                })
            })
        })
        })
    })

    // Post bid function
    app.post('/bid', isLoggedIn, (req, res) => {
         let { tid, bid } = req.body;
         knex.raw('insert into bidsrecords(tid, aid, price) values (' + tid + ', ' + req.user.id + ', ' + bid + ')').then(function(result){
            if(result) res.redirect('/tasks/details/' + tid)
         }).catch(function(err){
            if(err) {
                req.flash('error', 'Invalid bid: ' + bid);
                req.flash('remedy', 'Please return to task and replace your bid!')
                res.render('taskdetails', { message1: req.flash('error'), message2: req.flash('remedy') }); 
            }
         })
        }
    );

    // View the tasks you have completed as Halper
    app.get('/toreview', isLoggedIn, (req, res) => {
        var aid = req.user.id;
        knex.raw('select * from completedtasks natural join isassignedto where aid = ?', [aid]).then(function(tasks) {
            console.log(tasks.rows)
                res.render('reviewtasks', {tasks: tasks.rows});
        }
    );
    });

    // Get completed task detail (You can view your reviews here)
    app.get('/tasks/toreview/:tid', function(req, res) {
        knex.raw('select COALESCE(min(price), 0) as min from bidsrecords where tid = ?',[req.params.tid]).then(function(lowestBidPrice) {
        knex.raw('select * from taskcreation where tid = ?', [req.params.tid]).then(function(tasks) {
            knex.raw('select count(*) from bidsrecords b where b.tid = ?', [req.params.tid]).then(function(numBidders) {
                knex.raw('select * from reviews where tid = ?', [req.params.tid]).then(function(reviews){
                    res.render('review', {tasks: tasks.rows, lowestBidPrice: lowestBidPrice.rows, numBidders: numBidders.rows, reviews: reviews.rows});
                })
            })
        })
        })
    })

    // Post bid function
    app.post('/review', isLoggedIn, (req, res) => {
        let { tid, review } = req.body;
        console.log(review)
        knex.raw('insert into reviews(tid, givingreviewaid, acceptingreviewaid, reviewmsg, reviewrating) values(' + tid + ', ' + req.user.id + ', 1, ' + review + ', 5)').then(function(result){
            console.log(result)
            if(result) res.redirect('/tasks/toreview/' + tid)
        }).catch(function(err){
            console.log(err)    
            if(err) {
                req.flash('error', 'Invalid review: ' + review);
                req.flash('remedy', 'Please review your review')
                res.render('review', { message1: req.flash('error'), message2: req.flash('remedy') }); 
            }
        })
        }
    );

};

// route middleware to make sure a user is logged in
function isLoggedIn(req, res, next) {

    // if user is authenticated in the session, carry on 
    if (req.isAuthenticated())
        return next();

    // if they aren't redirect them to the home page
    res.redirect('/');
}

function intervalFunc() {
    console.log('Checking if task open time is reached');

    knex.transaction(trx => {
        trx.raw('select taskOpenTimeDeadline()')
        .then(trx.commit)
        .catch(trx.rollback)
    })
  }
  
  setInterval(intervalFunc, 1500);