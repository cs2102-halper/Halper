
INSERT INTO accounts VALUES (default, lower('TSUWEIQUAN@GMAIL.COM'), lower('USERDHBSD123dasf'), 'password');
INSERT INTO accounts VALUES (default, lower('rajdeep@GMAIL.COM'), lower('usernameraj'), 'passwordraj');
INSERT INTO accounts VALUES (default, lower('usera@GMAIL.COM'), lower('usera'), 'password');
INSERT INTO accounts VALUES (default, lower('userb@GMAIL.COM'), lower('userb'), 'password');
INSERT INTO accounts VALUES (default, lower('userc@GMAIL.COM'), lower('userc'), 'password');
INSERT INTO accounts VALUES (default, lower('userd@GMAIL.COM'), lower('userd'), 'password');
INSERT INTO accounts VALUES (default, lower('userf@GMAIL.COM'), lower('usere'), 'password');
INSERT INTO accounts VALUES (default, lower('userg@GMAIL.COM'), lower('userf'), 'password');


-- Every task creation should be a transaction
-- this is because we need to enter into the openTask table.
-- Template to create a new task
begin transaction;
set transaction isolation level serializable;
	with newtid as ( 
		insert into taskcreation values (default, 1, 'cleaning', default, 99.99, 2, 'Need help to wash car', 1, default) returning tid
	)
	insert into opentasks(tid) select * from newtid;
commit;

-- test task, modifies and time table insertion
update taskcreation set price = 12 where tid = 1;

--/*transaction to move opentask into cancelledtasks
-- * when creator click cancel task, this will execute
-- * --replace all static value with the queried data.
-- */
--begin transaction;
--set transaction isolation level serializable;
--	insert into cancelledtasks values(1, 'my mother have to go hospital');
--	delete from opentasks where tid = 1;
--commit;

/*-- Transaction to move open task to inprogress task
-- This will be auto run when the count down ends.
-- REQUIRED the specific opentasks row data.
-- replace all static value with the queried data
*/
insert into bidsrecords values (1, 2, default, 5);
insert into bidsrecords values (1, 3, default, 4.99);
insert into bidsrecords values (1, 4, default, 3);
insert into bidsrecords values (1, 4, default, 4);
insert into bidsrecords values (1, 4, default, 100);
insert into bidsrecords values (1, 5, default, 100);
insert into bidsrecords values (1, 6, default, 3.99);
-- replace all static value with the queried data

begin transaction;
set transaction isolation level serializable;
	select openToInprogress(1);
commit;

/*	Transaction to move inprogresstask to completetask
 *  when creator page click complete task button, this set of transaction will run.
 *  REQUIRED the specific opentasks row data.
 */ 
begin transaction;
set transaction isolation level serializable;
	-- replace all static value with the queried data.
	insert into completedtasks values(1);
	delete from inprogresstasks where tid = 1;
commit;

--/* transaction to move inprogress into cancelledtasks
-- * when creator click cancel task, this will execute
-- */ 
--begin transaction;
--set transaction isolation level serializable;
--	-- replace all static value with the queried data.
--	insert into cancelledtasks values(1, 'my mother have to go hospital');
--	delete from inprogresstasks where tid = 1;
--commit;

-- test reviews, accounts and levelinfo insertion
--insert into completedtasks values (1, default);

-- test for trigger to check if review touple is valid i.e. aid's is acciociated with tid
insert into reviews values (1, 1, 4, 'good job', 6);
insert into reviews values (1, 3, 2, 'good job', 6); -- 3 not associated with task 
insert into reviews values (1, 2, 3, 'good job', 6); -- 3 not associated with task 
insert into reviews values (2, 1, 3, 'good job', 6); -- 2 not assigned to 1 or 2

-- trigger for in between tasks (before insert)
-- do function for manually pick of bidders