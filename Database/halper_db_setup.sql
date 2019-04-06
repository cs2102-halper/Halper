DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table levelinfo (
	lid			serial				,
	points		integer		not null,
	levelname	text				,
	primary key (lid)
);

INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 10, 'Level 1');
--INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 20, 'Level 2');
--INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 30, 'Level 3');
--INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 40, 'Level 4');
--INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 50, 'Level 5');
--INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 60, 'Level 6');
--INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, 70, 'Level 7');

create table accounts (
	aid			serial		,
	email		text		unique		not null,
	username	text		unique		not null,
	password	text		not null			,
	points		integer		default 0			,
	lid			integer		default 1			,
	primary key (aid)							,
	foreign key (lid) 		references levelinfo
);


INSERT INTO accounts VALUES (default, lower('TSUWEIQUAN@GMAIL.COM'), lower('USERDHBSD123dasf'), 'password');
INSERT INTO accounts VALUES (default, lower('rajdeep@GMAIL.COM'), lower('usernameraj'), 'passwordraj', 54);
INSERT INTO accounts VALUES (default, lower('usera@GMAIL.COM'), lower('usera'), 'password');
INSERT INTO accounts VALUES (default, lower('userb@GMAIL.COM'), lower('userb'), 'password', 54);
INSERT INTO accounts VALUES (default, lower('userc@GMAIL.COM'), lower('userc'), 'password', 12);
INSERT INTO accounts VALUES (default, lower('userd@GMAIL.COM'), lower('userd'), 'password', 33);
INSERT INTO accounts VALUES (default, lower('userf@GMAIL.COM'), lower('usere'), 'password', 11);
INSERT INTO accounts VALUES (default, lower('userg@GMAIL.COM'), lower('userf'), 'password', 10);
--INSERT INTO accounts VALUES (12345, lower('quan@GMAIL.COM'), lower('user'), 'password');

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

create table reviewscreator (
	tid			integer										,
	aid			integer										,
	reviewMsg	text										,
	reviewRating   numeric(1, 0)	default 0 					,
	primary key	(tid, aid)									,
	foreign key (tid)		references completedtasks(tid)	,
	foreign key (aid)		references accounts(aid)
);

create table reviewshelper (
	tid			integer										,
	aid			integer										,	
	reviewMsg	text										,
	reviewRating   numeric(1, 0)	default 0 					,
	primary key	(tid, aid)									,
	foreign key (tid)		references completedtasks(tid)	,
	foreign key (aid)		references accounts(aid)
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

-- test data
insert into taskcreation values (1, 1,'cleaning' ,current_date,99.99, 1, 'Need help to wash car', 1);
insert into modifies values (1 , 1, default);

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
		if not exists (select 1 from levelinfo l where new.points <= l.points)
		then
			previousMaxPoints := (select max (l2.points) from levelinfo l2);
			loopStart := previousMaxPoints;
			previousCount := (select count(l3.points) from levelinfo l3);
			for counter in loopStart + 10 .. new.points by 10 loop
				insert into  levelinfo values (default, previousMaxpoints + 10, concat ('Level ',cast(previousCount + 1 as text)));
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

-- test data
update accounts set points = 60 where aid = 1; 

/*
 * Trigger to update account points after review
 */

create or replace function pointsUpdate()
returns trigger as 
$$
	begin
		-- greatest for in case we want to have -ve rating in the future
		update accounts set points = greatest(points + new.reviewRating, 0) where aid = new.aid;
		return null;
	end;
$$
language plpgsql;

create trigger levelTrigger
after update of reviewRating on reviewscreator
for each row
execute procedure pointsUpdate(); 

create trigger levelTrigger
after insert on reviewshelper
for each row
execute procedure pointsUpdate(); 

-- test data
insert into completedtasks values (1, default);
insert into reviewshelper values (1,1, 'hello', 9);
