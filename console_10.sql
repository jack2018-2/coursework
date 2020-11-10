create type taste as enum ('spicy', 'salty', 'sweet', 'sour', 'bitter');

create table ingredients
(
    "Id"        serial not null
        constraint ingredients_pk
            primary key,
    name        varchar(30),
    degree      smallint,
    type        text,
    description text,
    picture     bytea
);

comment on column ingredients.type is 'По ER здесь должен быть enum';

alter table ingredients
    owner to postgres;

create table "Cocktails"
(
    "Id"        serial      not null
        constraint cocktails_pk
            primary key,
    name        varchar(40) not null,
    description text,
    degree      smallint,
    picture     bytea,
    volume      smallint,
    receipt     text,
    taste       taste,
    "group"     text,
    basis_id    integer
        constraint basis_id
            references ingredients
);

alter table "Cocktails"
    owner to postgres;

create table cocktails_ingridients
(
    cocktail_id   integer
        constraint cocktail_id
            references "Cocktails",
    ingridient_id integer
        constraint ingridient_id
            references ingredients,
    volume        smallint
);

alter table cocktails_ingridients
    owner to postgres;

create table tools
(
    "Id"        serial not null
        constraint tools_pk
            primary key,
    name        varchar(30),
    description text,
    picture     bytea
);

alter table tools
    owner to postgres;

create table cocktails_tools
(
    cocktail_id integer
        constraint cocktail_id
            references "Cocktails",
    tool_id     integer
        constraint tool_id
            references tools
);

alter table cocktails_tools
    owner to postgres;

