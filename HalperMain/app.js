const express = require('express');
const exphbs = require('express-handlebars');
const bodyParser = require('body-parser');
const path = require('path');
const passport    = require('passport');
const flash       = require('connect-flash');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const KnexSessionStore = require('connect-session-knex')(session);
const app = express();
const Knex = require('knex');
const knex = Knex({
    client: 'pg',
    connection: {
        host: 'localhost',
        user: 'postgres',
        password: 'postgres',
        database: 'Halper'
    }
});
const store = new KnexSessionStore({
    knex: knex,
    tablename: 'sessions' // optional. Defaults to 'sessions'
});

require('./config/passport')(passport); // pass passport for configuration

app.use(morgan('dev'));         // log every request to the console
app.use(cookieParser());        // read cookies (needed for auth)

// Handlebars
app.engine('handlebars', exphbs({ defaultLayout: 'main' }));
app.set('view engine', 'handlebars');

// required for passport
app.use(session({
    store: store,
    secret: 'HALPMEHALPYOU',
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 30 * 24 * 60 * 60 * 1000 } // 30 days
  }));
app.use(passport.initialize());
app.use(passport.session()); // persistent login sessions
app.use(flash()); // use connect-flash for flash messages stored in session

// Body Parser
app.use(bodyParser.urlencoded({ extended: false }));

// Set static folder
app.use(express.static(path.join(__dirname, 'public')));

// Index route
app.get('/', (req, res) => res.render('index', { layout: 'landing' }));

// Task routes
app.use('/tasks', require('./routes/tasks'));

// Load account routes
require('./routes/accounts')(app, passport);

const PORT = process.env.PORT || 3000;

app.listen(PORT, console.log(`Server launched, listening to port: ${PORT}`));