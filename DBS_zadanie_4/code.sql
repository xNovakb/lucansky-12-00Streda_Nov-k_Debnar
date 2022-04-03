CREATE TABLE IF NOT EXISTS users(
	id              SERIAL      PRIMARY KEY,
	username        varchar     NOT NULL UNIQUE,
	email           varchar     NOT NULL UNIQUE,
	password        varchar     NOT NULL,
	created_at      timestamp   NOT NULL,
	last_login      timestamp   NOT NULL,
	hours_played    BIGINT      NOT NULL,
	verified        boolean     NOT NULL
);

CREATE TABLE IF NOT EXISTS chat_room(
	id              SERIAL      PRIMARY KEY,
	name            varchar     NOT NULL,
	is_private      boolean     NOT NULL
    CONSTRAINT name CHECK (name = 'Team' OR name = 'Private' OR name = 'All')
);

CREATE TABLE IF NOT EXISTS message(
	id              SERIAL      PRIMARY KEY,
	room_id         int         NOT NULL        REFERENCES chat_room(id),
	user_id         int         NOT NULL        REFERENCES users(id),
	message         varchar     NOT NULL,
	time_sent       timestamp   NOT NULL,
	CONSTRAINT message CHECK (message != '')
);

CREATE TABLE IF NOT EXISTS participants(
	id              SERIAL      PRIMARY KEY,
	room_id         int         NOT NULL        REFERENCES chat_room(id),
	user_id         int         NOT NULL        REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS ability(
    id              SERIAL      PRIMARY KEY,
    name            varchar     NOT NULL,
    level           int         NOT NULL,
    description     varchar     NOT NULL
    CONSTRAINT level CHECK (level > 0)
);

CREATE TABLE IF NOT EXISTS ability_requirement(
    id              SERIAL      PRIMARY KEY,
    ability_id      int         NOT NULL        REFERENCES ability(id),
    requirement_id  int         NOT NULL        REFERENCES ability(id)
);

CREATE TABLE IF NOT EXISTS role(
	id              SERIAL      PRIMARY KEY,
	name            varchar     NOT NULL,
	ability_id      int         NOT NULL        REFERENCES ability(id),
	attack          int         NOT NULL,
	health          int         NOT NULL ,
	defense         int         NOT NULL
);

CREATE TABLE IF NOT EXISTS level(
    id              SERIAL      PRIMARY KEY,
    level_label     int         NOT NULL,
    xp              BIGINT      NOT NULL
);

CREATE TABLE IF NOT EXISTS character(
	id              SERIAL      PRIMARY KEY,
	user_id         int         NOT NULL        REFERENCES users(id),
	name            varchar     NOT NULL        UNIQUE,
	role_id         int         NOT NULL        REFERENCES role(id),
	level_id        int         NOT NULL        DEFAULT 1,
	xp              BIGINT      NOT NULL        DEFAULT 0,
	money           BIGINT      NOT NULL        DEFAULT 1,
	attack          int         NOT NULL        DEFAULT 50,
	health          int         NOT NULL        DEFAULT 500,
	defense         int         NOT NULL        DEFAULT 50,
	movement_speed  int         NOT NULL        DEFAULT 20,
	intelligence    int         NOT NULL        DEFAULT 10,
	dexterity       int         NOT NULL        DEFAULT 10,
	luck            int         NOT NULL        DEFAULT 10
);

CREATE TABLE IF NOT EXISTS character_statistics(
    id              SERIAL      PRIMARY KEY,
    character_id    int         NOT NULL        REFERENCES character(id),
    killed_enemies  int         NOT NULL        DEFAULT 0
);

CREATE TABLE IF NOT EXISTS inventory(
    id              SERIAL      PRIMARY KEY,
    character_id    int         NOT NULL        REFERENCES character(id)
);

CREATE TABLE IF NOT EXISTS character_ability(
    id              SERIAL      PRIMARY KEY,
    character_id    int         NOT NULL        REFERENCES character(id),
    ability_id      int         NOT NULL        REFERENCES ability(id)
);

CREATE TABLE IF NOT EXISTS bonus(
    id              SERIAL      PRIMARY KEY,
    name            varchar     NOT NULL,
    attack          int         NOT NULL        DEFAULT 0,
    health          int         NOT NULL        DEFAULT 0,
    defense         int         NOT NULL        DEFAULT 0,
    movement_speed  int         NOT NULL        DEFAULT 0,
    intelligence    int         NOT NULL        DEFAULT 0,
    dexterity       int         NOT NULL        DEFAULT 0,
    luck            int         NOT NULL        DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ability_bonus(
    id              SERIAL      PRIMARY KEY,
    ability_id      int         NOT NULL        REFERENCES ability(id),
    bonus_id        int         NOT NULL        REFERENCES bonus(id)
);

CREATE TABLE IF NOT EXISTS friends(
	id              SERIAL      PRIMARY KEY,
	user_id_1       int         NOT NULL        REFERENCES users(id),
	user_id_2       int         NOT NULL        REFERENCES users(id),
	CONSTRAINT user_id_1 CHECK (user_id_1 != user_id_2)
);

CREATE TABLE IF NOT EXISTS request(
	id              SERIAL      PRIMARY KEY,
	user_id         int         NOT NULL        REFERENCES users(id),
	request_from    int         NOT NULL        REFERENCES users(id),
	type_of_request char        NOT NULL,
	CONSTRAINT type_of_request CHECK (type_of_request = 'F' OR type_of_request = 'T')
);

CREATE TABLE IF NOT EXISTS item(
	id              SERIAL      PRIMARY KEY,
	name            varchar     NOT NULL        UNIQUE,
	level           int         NOT NULL        DEFAULT 0,
	description     varchar     NOT NULL,
	CONSTRAINT level CHECK (level > 0)
);

CREATE TABLE IF NOT EXISTS item_bonus(
    id              SERIAL      PRIMARY KEY,
    item_id         int         NOT NULL        REFERENCES item(id),
    bonus_id        int         NOT NULL        REFERENCES bonus(id)
);

CREATE TABLE IF NOT EXISTS inventory_item(
    id              SERIAL      PRIMARY KEY,
    item_id         int         NOT NULL        REFERENCES item(id),
    inventory_id    int         NOT NULL        REFERENCES inventory(id),
    is_equipped     int         NOT NULL
);

CREATE TABLE IF NOT EXISTS map(
    id              SERIAL      PRIMARY KEY,
    floor           int         NOT NULL,
    x               int         NOT NULL,
    y               int         NOT NULL
);

CREATE TABLE IF NOT EXISTS place_location(
    id              SERIAL      PRIMARY KEY,
    map_id          int         NOT NULL        REFERENCES map(id),
    floor           int         NOT NULL,
    x               int         NOT NULL,
    y               int         NOT NULL
);

CREATE TABLE IF NOT EXISTS character_location(
    id              SERIAL PRIMARY KEY,
    map_id          int         NOT NULL        REFERENCES map(id),
    character_id    int         NOT NULL        REFERENCES character(id),
    floor           int         NOT NULL,
    x               int         NOT NULL,
    y               int         NOT NULL
);

CREATE TABLE IF NOT EXISTS item_location(
    id              SERIAL PRIMARY KEY,
    map_id          int NOT NULL        REFERENCES map(id),
    item_id         int NOT NULL        REFERENCES item(id),
    floor           int NOT NULL,
    x               int NOT NULL,
    y               int NOT NULL
);

CREATE TABLE IF NOT EXISTS quest(
	id              SERIAL PRIMARY KEY,
	name            varchar     NOT NULL        UNIQUE,
	required_level  int         NOT NULL        DEFAULT 0,
	xp              int         NOT NULL        DEFAULT 0,
	money           int         NOT NULL        DEFAULT 0,
	place_id        int         NOT NULL        REFERENCES place_location(id),
	item_id         int                         REFERENCES item(id),
	description     varchar,
	CONSTRAINT required_level CHECK (required_level > 0),
	CONSTRAINT money CHECK (money >= 0),
	CONSTRAINT xp CHECK (xp >= 0)
);

CREATE TABLE IF NOT EXISTS enemy(
    id              SERIAL      PRIMARY KEY,
    name            varchar     NOT NULL,
    level           int         NOT NULL,
    level_radius    int         NOT NULL,
    quest_id        int                         REFERENCES quest(id),
    status          varchar     NOT NULL,
    xp              BIGINT      NOT NULL,
    money           BIGINT      NOT NULL,
    attack          int         NOT NULL,
    health          int         NOT NULL,
    defense         int         NOT NULL,
    drop_rate       float       NOT NULL,
	is_boss         boolean     NOT NULL,
	is_final_boss	boolean		NOT NULL
    CONSTRAINT status CHECK (status = 'death' OR status = 'alive')
);

CREATE TABLE IF NOT EXISTS enemy_location(
    id              SERIAL      PRIMARY KEY,
    map_id          int         NOT NULL        REFERENCES map(id),
    enemy_id        int         NOT NULL        REFERENCES enemy(id),
    floor           int         NOT NULL,
    x               int         NOT NULL,
    y               int         NOT NULL
);

CREATE TABLE IF NOT EXISTS required_enemy(
    id              SERIAL      PRIMARY KEY,
    enemy_id        int         NOT NULL        REFERENCES enemy(id),
    required_id     int         NOT NULL        REFERENCES enemy(id)
);

CREATE TABLE IF NOT EXISTS enemy_ability(
    id              SERIAL      PRIMARY KEY,
    enemy_id        int         NOT NULL        REFERENCES enemy(id),
    ability_id      int         NOT NULL        REFERENCES ability(id)
);

CREATE TABLE IF NOT EXISTS character_quest(
	id              SERIAL      PRIMARY KEY,
	character_id    int         NOT NULL        REFERENCES character(id),
	quest_id        int         NOT NULL        REFERENCES quest(id)
);

CREATE TABLE IF NOT EXISTS quest_enemy(
    id              SERIAL     PRIMARY KEY,
    quest_id        int        NOT NULL       REFERENCES quest(id),
    enemy_id        int        NOT NULL       REFERENCES enemy(id),
    amount          int        NOT NULL
);

CREATE TABLE IF NOT EXISTS combat(
    id              SERIAL      PRIMARY KEY,
    character_id    int         NOT NULL        REFERENCES character(id),
    enemy_id        int         NOT NULL        REFERENCES enemy(id)
);

CREATE TABLE IF NOT EXISTS combat_log(
  id                SERIAL PRIMARY KEY,
  combat_id         int         NOT NULL        REFERENCES combat(id),
  character_id      int         NOT NULL        REFERENCES character(id),
  enemy_id          int         NOT NULL        REFERENCES enemy(id),
  place_id          int         NOT NULL        REFERENCES place_location(id),
  ability_id        int         NOT NULL        REFERENCES ability(id),
  curr_time         timestamp   NOT NULL,
  xp                int,
  money             int
);