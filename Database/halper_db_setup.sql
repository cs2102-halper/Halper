DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create extension citext;

create table levelinfo (
	lid			integer				,
	points		integer		not null,
	levelname	text				,
	primary key (lid)
);

create table accounts (
	aid			integer							,
	email		citext		unique		not null,
	username	text		unique		not null,
	password	text		not null			,
	points		integer		default 0			,
	lid			integer		not null			,
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





