var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

/* --- V7: Using dotenv     --- */
require('dotenv').config();

/* --- V2: Adding Web Pages --- */
var aboutRouter = require('./routes/about');
var loginRouter = require('./routes/login');
var auctionRouter = require('./routes/auction');
var reviewRouter = require('./routes/review');
var myprofileRouter = require('./routes/myprofile');
var accepthalpRouter = require('./routes/accepthalp');
var tableRouter = require('./routes/table');
var loopsRouter = require('./routes/loops');
var selectRouter = require('./routes/select');
var formsRouter = require('./routes/forms');
var insertRouter = require('./routes/insert');
/* ---------------------------- */

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/', indexRouter);
app.use('/users', usersRouter);

/* --- V2: Adding Web Pages --- */
app.use('/about', aboutRouter);
app.use('/login', loginRouter);
app.use('/auction', auctionRouter);
app.use('/review', reviewRouter);
app.use('/myprofile', myprofileRouter);
app.use('/accepthalp', accepthalpRouter);
app.use('/table', tableRouter);
app.use('/loops', loopsRouter);
app.use('/select', selectRouter);
app.use('/forms', formsRouter);
/* ---------------------------- */

/* --- V6: Modify Database  --- */
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use('/insert', insertRouter);
/* ---------------------------- */

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
