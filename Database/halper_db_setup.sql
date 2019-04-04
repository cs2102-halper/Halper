DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table levelinfo (
	lid			serial				,
	points		integer		not null,
	levelname	text				,
	primary key (lid)
);

INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '10', 'Level 1');
INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '20', 'Level 2');
INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '30', 'Level 3');
INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '40', 'Level 4');
INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '50', 'Level 5');
INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '60', 'Level 6');
INSERT INTO levelinfo(lid, points, levelname) VALUES(DEFAULT, '70', 'Level 7');

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
	tid 			integer					,
	aid 			integer 		not null,
	date 			date			not null,
	price			numeric(3,2)	not null,
	manpower		integer			not null,
	description 	text			not null,
	timeRequired	numeric(2,2) 	not null,
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
	date			date 			not null
);

create table reviewscreator (
	tid			integer										,
	aid			integer										,
	reviewMsg	text										,
	reviewRat   numeric(1, 0)	default 0 					,
	primary key	(tid, aid)									,
	foreign key (tid)		references completedtasks(tid)	,
	foreign key (aid)		references accounts(aid)
);

create table reviewshelper (
	tid			integer										,
	aid			integer										,	
	reviewMsg	text										,
	reviewRat   numeric(1, 0)	default 0 					,
	primary key	(tid, aid)									,
	foreign key (tid)		references completedtasks(tid)	,
	foreign key (aid)		references accounts(aid)
);

create table date (
	date 		timestamp,
	Primary key (date)
);

create table modifies (
	tid 		integer 	not null,
	aid 		integer 	not null,
	date 		timestamp 	not null,
	foreign key (tid) 		references taskcreation,
	foreign key (aid) 		references accounts,
	foreign key (date) 		references date
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
	time		timestamp		not null				,
	primary key (bid),
	foreign key (tid) 			references taskcreation	,
	foreign key (aid)			references accounts
);

create table withdrawbids (
	aid			integer		not null				,
	bid			integer		not null				,
	date		timestamp	not null				,
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


-- Failed attempt. posted on IVLE
 --Trigger for a case when account created, random aid generated is duplicate.
 --We will rerun the insertion with a new aid generated until the insertion is good.
create or replace function checkAccountsAidProcedure()
returns trigger as 
$$
	begin
		if(new.aid <> old.aid) then
			RAISE NOTICE 'aid distinct, return new';
			return new;
		else 
			RAISE NOTICE 'duplicate aid found, new aid generated and re-inserted';
			new.aid := random()*100000;
            return new;     
		end if;
	end;
$$
language plpgsql;

create trigger checkAccountsAidTrigger
before 
insert or update
on accounts
for each row
execute procedure checkAccountsAidProcedure();


