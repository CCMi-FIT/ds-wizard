-- -h localhost -U postgres -d elixir-dswizard
-- vim: syntax=pgsql:

drop table "User" cascade;
create table "User" (
	user_id serial primary key,
	email text,
	password_hash text,
	name text,
        affiliation text,
	registration_confirmed boolean DEFAULT 'f'
);
alter table "User" owner to elixir;

