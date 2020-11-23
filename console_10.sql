create type taste as enum ('spicy', 'salty', 'sweet', 'sour', 'bitter');

create table ingredients
(
    "id"        serial not null
        constraint ingredients_pk
            primary key,
    name        varchar(50),
    degree      smallint,
    type        text,
    description text,
    picture     bytea
);

comment on column ingredients.type is 'По ER здесь должен быть enum';

alter table ingredients
    owner to postgres;

create table "сocktails"
(
    "id"        serial      not null
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

alter table "сocktails"
    owner to postgres;

create table cocktails_ingridients
(
    cocktail_id   integer
        constraint cocktail_id
            references "сocktails",
    ingridient_id integer
        constraint ingridient_id
            references ingredients,
    volume        smallint
);

alter table cocktails_ingridients
    owner to postgres;

create table tools
(
    "id"        serial not null
        constraint tools_pk
            primary key,
    name        varchar(50),
    description text,
    picture     bytea
);

alter table tools
    owner to postgres;

create table cocktails_tools
(
    cocktail_id integer
        constraint cocktail_id
            references "сocktails",
    tool_id     integer
        constraint tool_id
            references tools
);

alter table cocktails_tools
    owner to postgres;


--drop trigger calculatevolume on cocktails;
--drop function calculatevolume();

create function calculatevolume() returns trigger
    language plpgsql
as
$$
declare
    ing record;
    deg record;
    maxdeg int;
    maxid int;
begin
    new.volume:=0;
    FOR ing IN
        SELECT volume FROM cocktails_ingridients WHERE cocktail_id = new.id
    LOOP
        new.volume = new.volume + ing.volume;
    end loop;
    new.degree:=0;
    maxdeg = 0;
    maxid = 0;
    FOR deg IN
        SELECT ingredients.id, degree, ci.volume FROM ingredients join cocktails_ingridients ci on ingredients.id = ci.ingridient_id where ci.cocktail_id = new.id
    LOOP
        if (deg.degree > maxdeg) then maxdeg=deg.degree; maxid = deg.id; end if;
        new.degree = new.degree + deg.degree * deg.volume / new.volume;
    end loop;
    new.basis_id = maxid;
    return new;
end;
$$;

alter function calculatevolume() owner to postgres;

create trigger calculatevolume
    before insert or update
    on cocktails
    for each row
    execute procedure calculatevolume();


--insert into cocktails (name, degree) values ('pzdc', 15);
--insert into cocktails_ingridients values (5, 1, 100);
--insert into ingredients values (3, 'try');
--update cocktails set receipt = 'на глаз';