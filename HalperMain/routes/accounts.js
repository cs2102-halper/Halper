//routes/accounts.js
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
        if(req.isAuthenticated()) res.render('profile', {user : req.user})
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
        successRedirect : '/profile', // redirect to the secure profile section
        failureRedirect : '/signup', // redirect back to the signup page if there is an error
        failureFlash : true, // allow flash messages
        session: false
    }));

    // =====================================
    // PROFILE SECTION =====================
    // =====================================
    // we will want this protected so you have to be logged in to visit
    // we will use route middleware to verify this (the isLoggedIn function)
    app.get('/profile', isLoggedIn, function(req, res) {
        res.render('profile', {
            user : req.user // get the user out of session and pass to template
        });
        console.log(req.user.id)
        console.log(req.user.username)
        console.log(req.user.password)
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

    var aid = 1; // place holder until passport is set up

        knex('taskcreation').insert({
        aid: aid,
        title: title,
        manpower: manpower,
        price: price,
        description: description,
        timerequired: timerequired,
        opentime: opentime
    }).then(function(result) {
        if(result) res.redirect('/tasks');
    });

    });
};


// route middleware to make sure a user is logged in
function isLoggedIn(req, res, next) {

    // if user is authenticated in the session, carry on 
    if (req.isAuthenticated())
        return next();

    // if they aren't redirect them to the home page
    res.redirect('/');
}