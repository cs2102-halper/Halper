DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table sessions (
    sid            varchar(255)    not null,
    sess        json            not null,
    expired        timestamptz        not null,
    primary key (sid)
);

create table levelinfo (
	lid			serial				,
	points		integer		not null,
	levelname	text				,
	primary key (lid)
);

-- level 0 is from points 0 - 9, level 1 from 10 - 19 etc.
INSERT INTO levelinfo(lid, points, levelname) VALUES(0, 0, 'Level 0');

-- update er 
create table accounts (
	aid			serial		,
	email		text		unique		not null,
	password	text		not null			,
	points		integer		default 0			,
	lid			integer		default 0			,
	primary key (aid)							,
	foreign key (lid) 		references levelinfo
);

create table hasadditionaldetails (
	aid			integer				,
	name		varchar(30)			,
	gender		char(1)				,
	countrycode	varchar(5)			,
	mobile		integer				,
	address		varchar(60)			,
	primary key (aid, name)			,
	foreign key (aid)		references accounts 
	on delete cascade
);

create table taskcreation (
	tid 			serial					,
	aid 			integer 		not null,
	title 			text 			not null,	
	timeRecord			timestamp default current_timestamp not null,
	price			numeric(5,2)	not null,
	manpower		integer	default 1 not null,
	description 	text				not null,
	timeRequired	numeric(2) 	default 1 not null,
	openTime		numeric(2)		default 24 not null,
	primary key (tid)						,
	foreign key (aid) references accounts(aid),
	check (timeRequired > 0),
	check (price > 0),
	check (manpower > 0),
	check (openTime > 0)
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
	timeRecord			time default current_timestamp 			not null
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
	timeRecord 		time,
	primary key (timeRecord)
);

create table modifies (
	tid 		integer 	not null,
	aid 		integer 	not null,
	timeRecord 		time default current_timestamp not null,
	foreign key (tid) 		references taskcreation,
	foreign key (aid) 		references accounts,
	foreign key (timeRecord) 		references time
);

create table cancels (
	tid 		integer 	not null,
	aid 		integer 	not null,
	date 		date 	default current_date	not null,
	foreign key (tid) 		references taskcreation,
	foreign key (aid) 		references accounts
);

create table bidsrecords (
	tid			integer 		not null				,
	aid			integer 		not null				,
	bid			serial	 		not null				,
	price		numeric(5,2) 	not null				,
	timeRecord		time	default current_timestamp	not null,
	primary key (bid)									,
	foreign key (tid) 			references taskcreation	,
	foreign key (aid)			references accounts,
	check(price > 0)
);

create table categories (
	cid			serial		,
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
			insert into time values (new.timeRecord);
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
 * Trigger to check if review touple is valid i.e. aid's is acciociated with tid
 */
create or replace function checkReview()
returns trigger as 
$$
	begin
		if (exists (select 1 from isassignedto i where i.tid = new.tid and i.aid = new.acceptingReviewAid)
		and exists (select 1 from taskCreation t where t.tid = new.tid and t.aid = new.givingReviewAid))
		or
		(exists (select 1 from isassignedto i where i.tid = new.tid and i.aid = new.givingReviewAid)
		and exists (select 1 from taskCreation t where t.tid = new.tid and t.aid = new.acceptingReviewAid))
		then return new;
		else return null;
		end if;
	end;
$$
language plpgsql;

create trigger checkReviewTrigger
before insert on reviews
for each row
execute procedure checkReview(); 

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

/* 
 * Standard procedure to move taskCreation table into openTask
 * */
create or replace function taskCreationToOpenTask(aid numeric, title text, price numeric(5,2), manpower numeric, description text, timerequired numeric, opentime numeric) 
returns void as 
$$
begin
	with newtid as ( 
		-- tid, aid, title, timeRecord, price, manpower, description, timerequired, opentime
		insert into taskcreation values (default, aid, title, default, price, manpower, description, timerequired, opentime) returning tid
	)
	insert into opentasks(tid) select * from newtid;
end;
$$
language plpgsql;


/*
 * Trigger to check that bid is valid i.e. price for bid is <= task price
 */
create or replace function priceCheck()
returns trigger as 
$$
	begin
		if (new.price <= (select t.price from taskcreation t where t.tid = new.tid)) then 
			return new;
		else 
			return null;
		end if;
	end;
$$
language plpgsql;

create trigger bidRecordsTrigger2
before insert or update on bidsrecords
for each row
execute procedure priceCheck(); 

/*
 * Trigger to check for exixting bid record for that aid relating to the task
 * If have -> update
 * Else -> continue
 * Trigger also checks if task is still open -> only open tasks are available for bidding
 */
create or replace function duplicateCheck()
returns trigger as 
$$
	begin
		if (exists(select 1 from opentasks o where o.tid = new.tid)) then 
			if (exists(select 1 from bidsrecords b where b.aid = new.aid and b.tid = new.tid)) then 
				update bidsrecords set price = new.price where aid = new.aid and tid = new.tid;
				return null;
			else 
				return new;
			end if;
		else return null;
		end if;
	end;
$$
language plpgsql;

create trigger bidRecordsTrigger1
before insert on bidsrecords
for each row
execute procedure duplicateCheck(); 

/*
 * Trigger to update cancels table after a task has been cancelled
 */
create or replace function cancelsUpdate()
returns trigger as 
$$
	declare aid numeric := (select t.aid from taskcreation t where t.tid = new.tid);
	begin
		insert into cancels values (new.tid, aid, default);
		return null;
	end;
$$
language plpgsql;

create trigger cancelsTrigger
after insert on cancelledtasks
for each row
execute procedure cancelsUpdate(); 


/* 
 * Standard procedure to check for open task deadlines and assign winning bids
 * using function openToInprogress(tid);
 */
create or replace function taskOpenTimeDeadline() returns void as 
$$
	declare tid1 numeric;
	declare diff numeric;
	
	begin
		for tid1 in select t.tid from (opentasks o natural join taskcreation k) as t loop
				diff := (select extract(EPOCH from (select now()::timestamp))) - (select extract (EPOCH from (select t1.timeRecord from taskcreation t1 where t1.tid = tid1)) );
				if(  diff > (select t2.openTime from taskcreation t2 where t2.tid = tid1)*60*60) then 
					perform openToInprogress(tid1);
				end if;
		end loop;
	end;
$$
language plpgsql;

/*
 * Standard procedure to move opentask to inprogress task (Automatically)
 * Will not execute once manually assigned i.e. task is not open anymore
 */
create or replace function openToInprogress(tid1 numeric)
returns void as 
$$
	declare manpower numeric := (select t.manpower from taskcreation t where t.tid = tid1);
	declare aid numeric;
	begin		
		if (exists(select 1 from opentasks o where o.tid = tid1)) then
			if ((select count(*) from (select b.aid from bidsrecords b where b.tid = tid1) as bidders) >= manpower) then
			
				for aid in select b.aid from bidsrecords b where b.tid = tid1 order by b.price asc limit manpower loop
					insert into isAssignedto values (tid1, aid);					
				end loop;
				insert into inprogresstasks values (tid1);
				delete from opentasks where tid = tid1;
			else 
				/*change from in-progress task to canclled task*/
				select inprogressToCancelled(tid1, 'bidders < task manpower');
			end if;
		end if;
	end;
$$
language plpgsql;

/*
 * Standard procedure to move opentask to inprogresstask (Manual Assign)
 * Task must be open i.e. it must bot have been automatically assigned
 */
create or replace function openToInprogressManual(tid1 numeric, aidArray int[])
returns void as 
$$
	declare manpower numeric := (select manpower from taskcreation where tid = tid1);
	declare aidArrayLen integer := array_length(aidArray, 1);  
	declare aidArrayIndex integer := 1;
	begin
		if (exists(select 1 from opentasks o where o.tid = tid1)) then 
			if manpower = aidArrayLen then 
				WHILE aidArrayIndex <= aidArrayLen loop 
				   	insert into isAssignedto values (tid1, aidArray[aidArrayIndex]);
					aidArrayIndex = aidArrayIndex + 1;  
				end loop;
			insert into inprogresstasks values (tid1);
			delete from opentasks where tid = tid1;
			end if;
		end if;
	end;
$$
language plpgsql;

/* 
 * Standard procedure to move opentask to cancelledtask
 */
create or replace function openToCancelled(tid1 numeric, reason text) returns void as 
$$
begin
	if (exists(select 1 from opentasks o where o.tid = tid1)) then 
		insert into cancelledtasks values(tid1, reason);
		delete from opentasks where tid = tid1;
	end if;
end;
$$
language plpgsql;

/* 
 * Standard procedure to move inprogresstask to cancelledtask
 */
create or replace function inprogressToCancelled(tid1 numeric, reason text) returns void as 
$$
begin
	if (exists(select 1 from inprogresstasks i where i.tid = tid1)) then 
		insert into cancelledtasks values(tid1, reason);
		delete from inprogresstasks where tid = tid1;
	end if;
end;
$$
language plpgsql;

/* 
 * Standard procedure to move inprogresstask to completedtask
 */
create or replace function inprogressToComplete(tid1 numeric) returns void as 
$$
begin
	if (exists(select 1 from inprogresstasks i where i.tid = tid1)) then 
		insert into completedtasks values(tid1);
		delete from inprogresstasks where tid = tid1;
	end if;
end;
$$
language plpgsql;

/* 
 * Standard procedure to withdraw bids
 */
create or replace function withdrawBid(tid1 numeric, aid1 numeric) returns void as 
$$
declare bid1 numeric := (select bid from bidsrecords where tid = tid1 and aid = aid1); 
	begin
		if (exists(select 1 from opentasks o where o.tid = tid1)) then
			if (exists(select 1 from bidsrecords b where b.aid = aid1 and b.tid = tid1)) then 	
				delete from bidsrecords b1 where b1.bid = bid1;
			end if;
		end if;
	end;
$$
language plpgsql;



/*
 * Default Categories
 */
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