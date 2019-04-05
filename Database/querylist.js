/* SQL Query */

// var sql_update_account = 'UPDATE' table_name
// SET column1 = value1, column2 = value2...., columnN = valueN
// WHERE [condition];

var sql_update = 'UPDATE';
var sql_set = 'SET';
var sql_where = 'WHERE';
var sql_current_date = 'current_date'; // auto get current_date on db side
var sql_timestamp = 'now()';

// sql table names 
var sql_tablename_accounts = 'accounts';
var sql_tablename_levelinfo = 'levelinfo';
var sql_tablename_hasadditionaldetails = 'hasadditionaldetails';
var sql_tablename_taskcreation = 'taskcreation';
var sql_tablename_cancelledtasks = 'cancelledtasks';
var sql_tablename_opentasks = 'opentasks';
var sql_tablename_inprogresstasks = 'inprogresstasks';
var sql_tablename_completedtasks = 'completedtasks';
var sql_tablename_reviewscreator = 'reviewscreator';
var sql_tablename_reviewshelper = 'reviewshelper';
var sql_tablename_modifies = 'modifies';
var sql_tablename_cancels = 'cancels';
var sql_tablename_bidsrecords = 'bidsrecords';
var sql_tablename_withdrawbids = 'withdrawbids';
var sql_tablename_categories = 'categories';
var sql_tablename_subscribe = 'subscribe';
var sql_tablename_belongsto = 'belongsto';
var sql_tablename_isassignedto = 'isassignedto';


// SQL queries
var sql_insert_accounts = 'INSERT INTO accounts VALUES';
var sql_query_all_accounts = 'SELECT * FROM accounts';

var sql_insert_levelinfo= 'INSERT INTO levelinfo VALUES';
var sql_query_all_levelinfo = 'SELECT * FROM levelinfo';

var sql_insert_hasadditionaldetails = 'INSERT INTO hasadditionaldetails VALUES';
var sql_query_all_hasadditionaldetails = 'SELECT * FROM hasadditionaldetails';

var sql_insert_taskcreation = 'INSERT INTO taskcreation VALUES';
var sql_query_all_taskcreation = 'SELECT * FROM taskcreation';

var sql_insert_cancelledtasks = 'INSERT INTO cancelledtasks VALUES';
var sql_query_all_cancelledtasks= 'SELECT * FROM cancelledtasks';

var sql_insert_opentasks = 'INSERT INTO opentasks VALUES';
var sql_query_all_opentasks= 'SELECT * FROM opentasks';

var sql_insert_inprogresstasks = 'INSERT INTO inprogresstasks VALUES';
var sql_query_all_inprogresstasks = 'SELECT * FROM inprogresstasks';

var sql_insert_completedtasks = 'INSERT INTO completedtasks VALUES';
var sql_query_all_completedtasks = 'SELECT * FROM completedtasks';

var sql_insert_reviewscreator = 'INSERT INTO reviewscreator VALUES';
var sql_query_all_reviewscreator = 'SELECT * FROM reviewscreator';

var sql_insert_reviewshelper = 'INSERT INTO reviewshelper VALUES';
var sql_query_all_reviewshelper = 'SELECT * FROM reviewshelper';

var sql_insert_modifies = 'INSERT INTO modifies VALUES';
var sql_query_all_modifies = 'SELECT * FROM modifies';

var sql_insert_cancels = 'INSERT INTO cancels VALUES';
var sql_query_all_cancels = 'SELECT * FROM cancels';

var sql_insert_bidsrecords = 'INSERT INTO bidsrecords VALUES';
var sql_query_all_bidsrecords = 'SELECT * FROM bidsrecords';

var sql_insert_withdrawbids = 'INSERT INTO withdrawbids VALUES';
var sql_query_all_withdrawbids = 'SELECT * FROM withdrawbids';

var sql_insert_categories = 'INSERT INTO categories VALUES';
var sql_query_all_categories = 'SELECT * FROM categories';

var sql_insert_subscribe = 'INSERT INTO subscribe VALUES';
var sql_query_all_subscribe = 'SELECT * FROM subscribe';

var sql_insert_belongsto = 'INSERT INTO belongsto VALUES';
var sql_query_all_belongsto = 'SELECT * FROM belongsto';

var sql_insert_isassignedto = 'INSERT INTO isassignedto VALUES';
var sql_query_all_isassignedto = 'SELECT * FROM isassignedto';
