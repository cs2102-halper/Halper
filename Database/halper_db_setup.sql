DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table levelinfo (
	lid			integer				,
	points		integer		not null,
	levelname	text				,
	primary key (lid)
);

INSERT INTO levelinfo VALUES ('1', '10', 'Level 1');
INSERT INTO levelinfo VALUES ('2', '20', 'Level 2');
INSERT INTO levelinfo VALUES ('3', '30', 'Level 3');
INSERT INTO levelinfo VALUES ('4', '40', 'Level 4');
INSERT INTO levelinfo VALUES ('5', '50', 'Level 5');
INSERT INTO levelinfo VALUES ('6', '60', 'Level 6');
INSERT INTO levelinfo VALUES ('7', '70', 'Level 7');
INSERT INTO levelinfo VALUES ('8', '80', 'Level 8');
INSERT INTO levelinfo VALUES ('9', '90', 'Level 9');
INSERT INTO levelinfo VALUES ('10', '100', 'Level 10');

create table accounts (
	aid			integer		,
	email		text		unique		not null,
	username	text		unique		not null,
	password	text		not null			,
	points		integer		default 0			,
	lid			integer		default 1			,
	primary key (aid)							,
	foreign key (lid) 		references levelinfo
);


INSERT INTO accounts VALUES (12345, lower('TSUWEIQUAN@GMAIL.COM'), lower('USERDHBSD123dasf'), 'password');
INSERT INTO accounts VALUES (random()*100000, lower('rajdeep@GMAIL.COM'), lower('usernameraj'), 'passwordraj', 54);
INSERT INTO accounts VALUES (random()*100000, lower('usera@GMAIL.COM'), lower('usera'), 'password');
INSERT INTO accounts VALUES (random()*100000, lower('userb@GMAIL.COM'), lower('userb'), 'password', 54);
INSERT INTO accounts VALUES (random()*100000, lower('userc@GMAIL.COM'), lower('userc'), 'password', 12);
INSERT INTO accounts VALUES (random()*100000, lower('userd@GMAIL.COM'), lower('userd'), 'password', 33);
INSERT INTO accounts VALUES (random()*100000, lower('userf@GMAIL.COM'), lower('usere'), 'password', 11);
INSERT INTO accounts VALUES (random()*100000, lower('userg@GMAIL.COM'), lower('userf'), 'password', 10);

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

insert into hasadditionaldetails values('Tsu Wei Quan', 'M', 'SG', 96259561, 'Simei street 1, Blk 111, #03-696', 12345);

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

create table creatorreviews (
	tid			integer										,
	aid			integer										,
	content		text										,
	primary key	(tid, aid)									,
	foreign key (tid)		references completedtasks(tid)	,
	foreign key (aid)		references accounts(aid)
);

create table helperreviews (
	tid			integer										,
	aid			integer										,	
	content		text										,
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
-- --Trigger for a case when account created, random aid generated is duplicate.
-- --We will rerun the insertion with a new aid generated until the insertion is good.
--create or replace function checkAccountsAidProcedure()
--returns trigger as 
--$$
--	declare newAidGen integer;
--	begin
--		if(new.aid <> old.aid) then
--			RAISE NOTICE 'aid distinct, return new';
--			return new;
--		else 
--			RAISE NOTICE 'new aid generated';
--			return (8, new.email, new.username, new.password, new.points, new.lid);
--		end if;
--	end;
--$$
--language plpgsql;
--
--create trigger checkAccountsAidTrigger
--before 
--insert or update
--on accounts
--for each statement
--execute procedure checkAccountsAidProcedure();


