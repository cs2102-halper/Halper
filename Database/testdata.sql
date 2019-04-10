
INSERT INTO accounts VALUES (default, lower('TSUWEIQUAN@GMAIL.COM'), 'password');
INSERT INTO accounts VALUES (default, lower('rajdeep@GMAIL.COM'), 'passwordraj');
INSERT INTO accounts VALUES (default, lower('usera@GMAIL.COM'), 'password');
INSERT INTO accounts VALUES (default, lower('userb@GMAIL.COM'),  'password');
INSERT INTO accounts VALUES (default, lower('userc@GMAIL.COM'),  'password');
INSERT INTO accounts VALUES (default, lower('userd@GMAIL.COM'), 'password');
INSERT INTO accounts VALUES (default, lower('userf@GMAIL.COM'), 'password');
INSERT INTO accounts VALUES (default, lower('userg@GMAIL.COM'),  'password');

insert into hasadditionaldetails values (2, 'rajdeep', 'm', 'sg', 85693215, 'Pasir Ris St 12 Blk 108 # 02-73');

INSERT INTO categories VALUES (default, 'General Housekeeping');
INSERT INTO categories VALUES (default, 'Studies');
INSERT INTO categories VALUES (default, 'Technical Support');
INSERT INTO categories VALUES (default, 'Delivery');
INSERT INTO categories VALUES (default, 'Cooking');
INSERT INTO categories VALUES (default, 'Shopping');
INSERT INTO categories VALUES (default, 'Plumbing');
INSERT INTO categories VALUES (default, 'Painting');
INSERT INTO categories VALUES (default, 'Car Wash');
INSERT INTO categories VALUES (default, 'Reparing');
INSERT INTO categories VALUES (default, 'Aircorn Chemical Wash');
INSERT INTO categories VALUES (default, 'Others');
INSERT INTO categories VALUES (default, 'Classes');
INSERT INTO categories VALUES (default, 'Chauffer');


begin transaction;
set transaction isolation level serializable;
	-- aid numeric, title text, price numeric(5,2), manpower numeric, description text, timerequired numeric, opentime numeric
	select taskCreationToOpenTask(1, 'Repair computer', 99.12, 3, 'This task require you to fix a mac book laptop computer', 3, 48);
commit;

begin transaction;
set transaction isolation level serializable;
	-- aid numeric, title text, price numeric(5,2), manpower numeric, description text, timerequired numeric, opentime numeric
	select taskCreationToOpenTask(2, 'Delivery', 50, 3, 'Deliver Mac', 1, 3);
commit;

--update taskcreation set price = 12 where tid = 1;

--begin transaction;
--set transaction isolation level serializable;
--	select openToCancelled(1, 'Wrong task created!');
--commit;

insert into bidsrecords values (1, 2, default, 5);
insert into bidsrecords values (1, 3, default, 4.99);
insert into bidsrecords values (1, 4, default, 3);
insert into bidsrecords values (1, 4, default, 4);
insert into bidsrecords values (1, 4, default, 100);
insert into bidsrecords values (1, 5, default, 100);
insert into bidsrecords values (1, 6, default, 3.99);

insert into bidsrecords values (2, 4, default, 4);
insert into bidsrecords values (2, 4, default, 100);
insert into bidsrecords values (2, 5, default, 30);
insert into bidsrecords values (2, 6, default, 3.99);



--	select withdrawBid(1,4);



begin transaction;
set transaction isolation level serializable;
	-- replace all static value with queried data
	select openToInprogress(1);
commit;

begin transaction;
set transaction isolation level serializable;
	-- replace all static value with queried data
	select openToInprogress(2);
commit;

--begin transaction;
--set transaction isolation level serializable;
---- replace all static value with queried data
---- tid, array of aid whom are attach to the work
--	select openToInprogressManual(1, '{2,3,4}');
--commit;

--begin transaction;
--set transaction isolation level serializable;
--	-- replace all static value with the queried data.
--	select inprogressToCancelled(1, 'Cancellation due to halper did not turned up');
--commit;

begin transaction;
set transaction isolation level serializable;
	-- replace all static value with the queried data.
	select inprogressToComplete(1);
commit;

begin transaction;
set transaction isolation level serializable;
	-- replace all static value with the queried data.
	select inprogressToComplete(2);
commit;

insert into reviews values (1, 1, 4, 'good job', 6);
insert into reviews values (1, 1, 5, 'good job', 6);
insert into reviews values (1, 1, 6, 'good job', 6);
insert into reviews values (1, 3, 2, 'good job', 6); -- 3 not associated with task, will not be included into the table
insert into reviews values (1, 2, 3, 'good job', 6); -- 3 not associated with task, will not be included into the table 
insert into reviews values (2, 1, 3, 'good job', 6); -- 2 not assigned to 1 or 2, will not be included into the table

insert into reviews values (2, 2, 4, 'good job', 6);
insert into reviews values (2, 2, 5, 'good job', 6);
insert into reviews values (2, 2, 6, 'good job', 6);
insert into reviews values (2, 2, 8, 'good job', 6);

