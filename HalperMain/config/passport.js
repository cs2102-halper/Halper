// config/passport.js

// load all the things we need
var LocalStrategy   = require('passport-local').Strategy;

// load up the account model
var Accounts        = require('../models/Accounts');
var Account         = require('../models/Account');
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

// expose this function to our app using module.exports
module.exports = function(passport) {

    // =========================================================================
    // passport session setup ==================================================
    // =========================================================================
    // required for persistent login sessions
    // passport needs ability to serialize and unserialize users out of session

    // used to serialize the user for the session
    passport.serializeUser(function(user, done) {
        done(null, user.email);
        // done(null, user.get('email'));
    });

    // used to deserialize the user
    passport.deserializeUser(function(email, done) {
        new Account({email: email}).fetch().then(function(user) {
            done(null, user);
          });
    });

    // =========================================================================
    // LOCAL SIGNUP ============================================================
    // =========================================================================
    // we are using named strategies since we have one for login and one for signup
    // by default, if there was no name, it would just be called 'local'

    passport.use('local-signup', new LocalStrategy({
        // by default, local strategy uses username and password
        usernameField : 'email',
        passwordField : 'password',
        passReqToCallback : true // allows us to pass back the entire request to the callback
    },
    function(req, username, password, done) {

        // asynchronous
        // Accounts.findOne wont fire unless data is sent back
        process.nextTick(function() {

        // find a user whose username is the same as the forms username
        // we are checking to see if the user trying to login already exists

            new Account({email: username.toLowerCase()})
            .fetch()
            .then(function(user) {
               if (user) {
                 return done(null, false,
                   req.flash('signupMessage', 'Email is already associated with an account.'));
               } else {
                    Account.forge({
                        email: username.toLowerCase(),
                        password: password,
                        points: '0',
                        lid: '0'
                    }).save().then(function(account) {
                        return done(null, account);
                    })
               }
            })

        });

    }));

    // =========================================================================
    // LOCAL LOGIN =============================================================
    // =========================================================================
    // we are using named strategies since we have one for login and one for signup
    // by default, if there was no name, it would just be called 'local'

    passport.use('local-login', new LocalStrategy({
        // by default, local strategy uses username and password
        usernameField : 'email',
        passwordField : 'password',
        passReqToCallback : true // allows us to pass back the entire request to the callback
    },
    function(req, username, password, done) { // callback with email and password from our form

          new Account({email: username.toLowerCase()})
          .fetch()
          .then(function(user) {
             if (!user) {
               return done(null, false,
                 req.flash('loginMessage', 'No account associated with email.'));
             }
             user = user.toJSON();
             console.log(user);
            //  var isValid = new Account();
             if (user.password != password) {
               return done(null, false,
                 req.flash('loginMessage', 'Oops! Wrong password.'));
             }
             return done(null, user);
          })
          .catch(function(err) {
             return done(err);
          });

    }));

};