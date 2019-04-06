DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table levelinfo (
	lid			serial				,
	points		integer		not null,
	levelname	text				,
	primary key (lid)
);

-- level 0 is from points 0 - 9, level 1 from 10 - 19 etc.
INSERT INTO levelinfo(lid, points, levelname) VALUES(0, 0, 'Level 0');

create table accounts (
	aid			serial		,
	email		text		unique		not null,
	username	text		unique		not null,
	password	text		not null			,
	points		integer		default 0			,
	lid			integer		default 0			,
	primary key (aid)							,
	foreign key (lid) 		references levelinfo
);




create table hasadditionaldetails (
	name		varchar(30)			,
	gender		char(1)				,
	countrycode	varchar(5)			,
	mobile		integer				,
	address		varchar(60)			,
	aid			integer		not null,
	primary key (aid, name)			,
	foreign key (aid)		references accounts 
	on delete cascade
);

create table taskcreation (
	tid 			serial					,
	aid 			integer 		not null,
	title 			text 			not null,	
	date 			date	default current_date	not null,
	price			numeric(5,2)	not null,
	manpower		integer			not null,
	description 	text			not null,
	timeRequired	numeric(2) 	not null,
	primary key (tid)						,
	foreign key (aid) references accounts(aid)
);


create table cancelledtasks (
	tid				integer			
	primary key references taskcreation
	on delete cascade						,
	reason			text 			not null
);

create table opentasks (
	tid				integer					
	primary key references taskcreation
	on delete cascade						
);

create table inprogresstasks (
	tid				integer					
	primary key references taskcreation
	on delete cascade						
);

create table completedtasks (
	tid				integer					
	primary key references taskcreation
	on delete cascade						,
	date			date default current_date 			not null
);

create table reviews (
	tid			integer										,
	givingReviewAid			integer							,
	acceptingReviewAid			integer						,
	reviewMsg	text										,
	reviewRating   numeric(1, 0)	default 0 				,
	primary key	(tid, givingReviewAid, acceptingReviewAid)				,
	foreign key (tid)		references completedtasks(tid)	,
	foreign key (givingReviewAid)		references accounts(aid),
	foreign key (acceptingReviewAid)		references accounts(aid)	,
	check (givingReviewAid != acceptingReviewAid)							
);

create table time (
	time 		timestamp,
	primary key (time)
);

create table modifies (
	tid 		integer 	not null,
	aid 		integer 	not null,
	time 		timestamp default current_timestamp not null,
	foreign key (tid) 		references taskcreation,
	foreign key (aid) 		references accounts,
	foreign key (time) 		references time
);

create table cancels (
	tid 		integer 	not null,
	aid 		integer 	not null,
	date 		date 		not null,
	foreign key (tid) 		references taskcreation,
	foreign key (aid) 		references accounts
);

create table bidsrecords (
	tid			integer 		not null				,
	aid			integer 		not null				,
	bid			integer 		not null				,
	price		numeric(3,2) 	not null				,
	time		timestamp	default current_timestamp	not null,
	primary key (bid)									,
	foreign key (tid) 			references taskcreation	,
	foreign key (aid)			references accounts
);

create table withdrawbids (
	aid			integer		not null				,
	bid			integer		not null				,
	date		timestamp	default current_timestamp not null,
	primary key (bid)								,
	foreign key (bid) 		references bidsrecords	,
	foreign key (aid) 		references accounts
);

create table categories (
	cid			integer		,
	cateogory	varchar(100),
	primary key (cid)
);

create table subscribe (
	aid			integer						,
	cid			integer						,
	foreign key (aid) references accounts	,
	foreign key (cid) references categories
);

create table belongsto (
	tid			integer 	not null				,
	cid			integer 	not null				,
	foreign key (tid)		references taskcreation	,
	foreign key (cid)		references categories
);

create table isassignedto (
	tid			integer 	not null				,
	aid			integer 	not null				,
	foreign key (tid) 		references taskcreation	,
	foreign key (aid)		references accounts
);


/*
 * Trigger implemented to auto insert timestamp into time table to log down records of same user modifying the same task. 
 */
create or replace function timeTimestamp()
returns trigger as 
$$
		begin
			insert into time values (new.time);
			return new;
		end;
$$
language plpgsql;

create trigger timeTrigger
before insert on modifies
for each row
execute procedure timeTimestamp();

/*
 * Trigger to update account level after update on account points and levelinfo tabel if necessary 
 * Points are not limited to any number of digits in this function 
 * (i.e. for future implementation if ratings(which is enssentially points) given are more than 1 digit)
 */
create or replace function levelUpdate() 
returns trigger as 
$$
	declare previousMaxPoints numeric;
	declare loopStart numeric;
	declare previousCount numeric;
	declare updatedLid numeric;
	begin
		if not exists (select 1 from levelinfo l where new.points/10*10 = l.points)
		then
			previousMaxPoints := (select max (l2.points) from levelinfo l2);
			loopStart := previousMaxPoints;
			previousCount := (select count(l3.points) from levelinfo l3);
			for counter in loopStart + 10 .. new.points by 10 loop
				insert into  levelinfo values (default, previousMaxpoints + 10, concat ('Level ',cast(previousCount as text)));
				previousMaxPoints := (select max (l4.points) from levelinfo l4);
				previousCount := (select count(l5.points) from levelinfo l5);
			end loop;
		end if;
		updatedLid := (select l6.lid from levelinfo l6 where l6.points = new.points/10*10);
		update accounts set lid = updatedLid where aid = new.aid;
		return null;
	end;
$$
language plpgsql;

create trigger levelTrigger
after update of points on accounts
for each row
execute procedure levelUpdate(); 

/*
 * Trigger to update account points after review
 */
create or replace function pointsUpdate()
returns trigger as 
$$
	begin
		-- greatest for in case we want to have -ve rating in the future
		update accounts set points = greatest(points + new.reviewRating, 0) where aid = new.acceptingReviewAid;
		return null;
	end;
$$
language plpgsql;

create trigger reviewTrigger
after insert on reviews
for each row
execute procedure pointsUpdate(); 

/*
 * Trigger to add to modifies on taskcreation update
 */
create or replace function modifiesUpdate()
returns trigger as 
$$
	begin
		insert into modifies values (new.tid, new.aid);
		return new;
	end;
$$
language plpgsql;

create trigger modifiesTrigger
before update on taskcreation
for each row
execute procedure modifiesUpdate(); 

-- test data
-- open task to inprogress task needs to update isassignedto table


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
		insert into taskcreation values (default, 1, 'cleaning' , current_date , 99.99, 1, 'Need help to wash car', 1) returning tid
	)
	insert into opentasks(tid) select * from newtid;
commit;

-- test task, modifies and time table insertion
update taskcreation set price = 12 where tid = 1;

-- test reviews, accounts and levelinfo insertion
insert into isassignedto values (1, 2);
insert into completedtasks values (1, default);

insert into reviews values (1, 1, 2, 'good job', 6);
insert into reviews values (1, 3, 2, 'good job', 6);

--/*
-- * To Do:
-- * 1. Trigger to check if both helper and giver is indeed assigend to the task in order to give review
-- * 2. Transaction open task to inprogress task needs to update isassignedto table
-- * 3. Transaction from in progress task to complete task
-- * 4. Transaction from in progress task to cancelled task
-- * 5. Transaction from open task to cancelled task
-- * 6. Test on cascade delete on task creation
-- * 7. Static function to get highest bids
-- * 
-- * /



