create table account
(
    id              int unsigned auto_increment comment 'Identifier'
        primary key,
    username        varchar(32)      default ''                not null,
    salt            binary(32)                                 not null,
    verifier        binary(32)                                 not null,
    session_key     binary(40)                                 null,
    totp_secret     varbinary(128)                             null,
    email           varchar(255)     default ''                not null,
    reg_mail        varchar(255)     default ''                not null,
    joindate        timestamp        default CURRENT_TIMESTAMP not null,
    last_ip         varchar(15)      default '127.0.0.1'       not null,
    last_attempt_ip varchar(15)      default '127.0.0.1'       not null,
    failed_logins   int unsigned     default '0'               not null,
    locked          tinyint unsigned default '0'               not null,
    lock_country    varchar(2)       default '00'              not null,
    last_login      timestamp                                  null,
    online          int unsigned     default '0'               not null,
    expansion       tinyint unsigned default '2'               not null,
    Flags           int unsigned     default '0'               not null,
    mutetime        bigint           default 0                 not null,
    mutereason      varchar(255)     default ''                not null,
    muteby          varchar(50)      default ''                not null,
    locale          tinyint unsigned default '0'               not null,
    os              varchar(3)       default ''                not null,
    recruiter       int unsigned     default '0'               not null,
    totaltime       int unsigned     default '0'               not null,
    constraint idx_username
        unique (username)
)
    comment 'Account System';

grant insert, select, update on table account to front_client;

create table account_access
(
    id      int unsigned            not null,
    gmlevel tinyint unsigned        not null,
    RealmID int          default -1 not null,
    comment varchar(255) default '' null,
    primary key (id, RealmID)
);

create table account_banned
(
    id        int unsigned     default '0' not null comment 'Account id',
    bandate   int unsigned     default '0' not null,
    unbandate int unsigned     default '0' not null,
    bannedby  varchar(50)                  not null,
    banreason varchar(255)                 not null,
    active    tinyint unsigned default '1' not null,
    primary key (id, bandate)
)
    comment 'Ban List';

create table account_muted
(
    guid       int unsigned default '0' not null comment 'Global Unique Identifier',
    mutedate   int unsigned default '0' not null,
    mutetime   int unsigned default '0' not null,
    mutedby    varchar(50)              not null,
    mutereason varchar(255)             not null,
    primary key (guid, mutedate)
)
    comment 'mute List';

create table autobroadcast
(
    realmid int              default -1  not null,
    id      tinyint unsigned auto_increment,
    weight  tinyint unsigned default '1' null,
    text    longtext                     not null,
    primary key (id, realmid)
);

create table autobroadcast_locale
(
    realmid int        not null,
    id      int        not null,
    locale  varchar(4) not null,
    text    longtext   not null,
    primary key (realmid, id, locale)
);

create table build_info
(
    build           int         not null
        primary key,
    majorVersion    int         null,
    minorVersion    int         null,
    bugfixVersion   int         null,
    hotfixVersion   char(3)     null,
    winAuthSeed     varchar(32) null,
    win64AuthSeed   varchar(32) null,
    mac64AuthSeed   varchar(32) null,
    winChecksumSeed varchar(40) null,
    macChecksumSeed varchar(40) null
);

create table ip_banned
(
    ip        varchar(15)  default '127.0.0.1' not null,
    bandate   int unsigned                     not null,
    unbandate int unsigned                     not null,
    bannedby  varchar(50)  default '[Console]' not null,
    banreason varchar(255) default 'no reason' not null,
    primary key (ip, bandate)
)
    comment 'Banned IPs';

create table logs
(
    time   int unsigned                 not null,
    realm  int unsigned                 not null,
    type   varchar(250)                 not null,
    level  tinyint unsigned default '0' not null,
    string text                         null
);

create table logs_ip_actions
(
    id             int unsigned auto_increment comment 'Unique Identifier'
        primary key,
    account_id     int unsigned                          not null comment 'Account ID',
    character_guid int unsigned                          not null comment 'Character Guid',
    type           tinyint unsigned                      not null,
    ip             varchar(15) default '127.0.0.1'       not null,
    systemnote     text                                  null comment 'Notes inserted by system',
    unixtime       int unsigned                          not null comment 'Unixtime',
    time           timestamp   default CURRENT_TIMESTAMP not null comment 'Timestamp',
    comment        text                                  null comment 'Allows users to add a comment'
)
    comment 'Used to log ips of individual actions';

create table mod_class_balance
(
    class_id    tinyint unsigned not null comment '1=Guerrero 2=Paladín 3=Cazador 4=Pícaro 5=Sacerdote 6=C.Muerte 7=Chamán 8=Mago 9=Brujo 11=Druida'
        primary key,
    phys_dmg    float default 1  not null comment 'Mult. daño físico dado (melee/ranged). 1.2 = +20%',
    spell_dmg   float default 1  not null comment 'Mult. daño de hechizo dado (spells, DoTs). 0.9 = -10%',
    healing     float default 1  not null comment 'Mult. curación hecha. 1.1 = +10%',
    defense     float default 1  not null comment 'Mult. daño recibido (todas las fuentes). 0.85 = 15% menos daño',
    threat_mult float default 1  not null comment 'Mult. amenaza generada en PvE. 1.5 = +50% más aggro (solo afecta a jugadores atacando mobs)'
)
    comment 'Multiplicadores de balance por clase de jugador (mod-class-balance)' charset = utf8mb4;

create table mod_class_balance_spells
(
    spell_id    int unsigned            not null comment 'ID del hechizo en spell_dbc'
        primary key,
    dmg_mult    float        default 1  not null comment 'Mult. de daño del hechizo (spell damage y DoTs). 0.8 = -20%',
    heal_mult   float        default 1  not null comment 'Mult. de curación del hechizo. 1.2 = +20%',
    threat_mult float        default 1  not null comment 'Mult. de amenaza del hechizo en PvE. 2.0 = doble amenaza',
    comment     varchar(128) default '' not null comment 'Descripción opcional (ej: "Golpe de Escudo - Guerrero Prot")'
)
    comment 'Overrides de balance por hechizo específico (mod-class-balance)' charset = utf8mb4;

create table motd
(
    realmid int      not null
        primary key,
    text    longtext null
);

create table motd_localized
(
    realmid int        not null,
    locale  varchar(4) not null,
    text    longtext   null,
    primary key (realmid, locale)
);

create table realmcharacters
(
    realmid  int unsigned     default '0' not null,
    acctid   int unsigned                 not null,
    numchars tinyint unsigned default '0' not null,
    primary key (realmid, acctid)
)
    comment 'Realm Character Tracker';

create index acctid
    on realmcharacters (acctid);

create table realmlist
(
    id                   int unsigned auto_increment
        primary key,
    name                 varchar(32)       default ''              not null,
    address              varchar(255)      default '127.0.0.1'     not null,
    localAddress         varchar(255)      default '127.0.0.1'     not null,
    localSubnetMask      varchar(255)      default '255.255.255.0' not null,
    port                 smallint unsigned default '8085'          not null,
    icon                 tinyint unsigned  default '0'             not null,
    flag                 tinyint unsigned  default '2'             not null,
    timezone             tinyint unsigned  default '0'             not null,
    allowedSecurityLevel tinyint unsigned  default '0'             not null,
    population           float             default 0               not null,
    gamebuild            int unsigned      default '12340'         not null,
    constraint idx_name
        unique (name),
    check (`population` >= 0)
)
    comment 'Realm System';

create table secret_digest
(
    id     int unsigned not null
        primary key,
    digest varchar(100) not null
);

create table updates
(
    name      varchar(200)                                                                           not null comment 'filename with extension of the update.'
        primary key,
    hash      char(40)                                                     default ''                null comment 'sha1 hash of the sql file.',
    state     enum ('RELEASED', 'CUSTOM', 'MODULE', 'ARCHIVED', 'PENDING') default 'RELEASED'        not null comment 'defines if an update is released or archived.',
    timestamp timestamp                                                    default CURRENT_TIMESTAMP not null comment 'timestamp when the query was applied.',
    speed     int unsigned                                                 default '0'               not null comment 'time the query takes to apply in ms.'
)
    comment 'List of all applied updates in this database.';

create table updates_include
(
    path  varchar(200)                                                          not null comment 'directory to include. $ means relative to the source directory.'
        primary key,
    state enum ('RELEASED', 'ARCHIVED', 'CUSTOM', 'PENDING') default 'RELEASED' not null comment 'defines if the directory contains released or archived updates.'
)
    comment 'List of directories where we want to include sql updates.';

create table uptime
(
    realmid    int unsigned                            not null,
    starttime  int unsigned      default '0'           not null,
    uptime     int unsigned      default '0'           not null,
    maxplayers smallint unsigned default '0'           not null,
    revision   varchar(255)      default 'AzerothCore' not null,
    primary key (realmid, starttime)
)
    comment 'Uptime system';

