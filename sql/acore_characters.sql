create table account_data
(
    accountId int unsigned     default '0' not null comment 'Account Identifier',
    type      tinyint unsigned default '0' not null,
    time      int unsigned     default '0' not null,
    data      blob                         not null,
    primary key (accountId, type)
);

create table account_instance_times
(
    accountId   int unsigned                not null,
    instanceId  int unsigned    default '0' not null,
    releaseTime bigint unsigned default '0' not null,
    primary key (accountId, instanceId)
);

create table account_tutorial
(
    accountId int unsigned default '0' not null comment 'Account Identifier'
        primary key,
    tut0      int unsigned default '0' not null,
    tut1      int unsigned default '0' not null,
    tut2      int unsigned default '0' not null,
    tut3      int unsigned default '0' not null,
    tut4      int unsigned default '0' not null,
    tut5      int unsigned default '0' not null,
    tut6      int unsigned default '0' not null,
    tut7      int unsigned default '0' not null
)
    comment 'Player System';

create table active_arena_season
(
    season_id    tinyint unsigned not null,
    season_state tinyint unsigned not null comment 'Supported 2 states: 0 - disabled; 1 - in progress.'
);

create table addons
(
    name varchar(120) default ''  not null
        primary key,
    crc  int unsigned default '0' not null
)
    comment 'Addons';

create table arena_team
(
    arenaTeamId     int unsigned      default '0' not null
        primary key,
    name            varchar(24)                   not null,
    captainGuid     int unsigned      default '0' not null,
    type            tinyint unsigned  default '0' not null,
    rating          smallint unsigned default '0' not null,
    seasonGames     smallint unsigned default '0' not null,
    seasonWins      smallint unsigned default '0' not null,
    weekGames       smallint unsigned default '0' not null,
    weekWins        smallint unsigned default '0' not null,
    `rank`          int unsigned      default '0' not null,
    backgroundColor int unsigned      default '0' not null,
    emblemStyle     tinyint unsigned  default '0' not null,
    emblemColor     int unsigned      default '0' not null,
    borderStyle     tinyint unsigned  default '0' not null,
    borderColor     int unsigned      default '0' not null
);

create table arena_team_member
(
    arenaTeamId    int unsigned      default '0' not null,
    guid           int unsigned      default '0' not null,
    weekGames      smallint unsigned default '0' not null,
    weekWins       smallint unsigned default '0' not null,
    seasonGames    smallint unsigned default '0' not null,
    seasonWins     smallint unsigned default '0' not null,
    personalRating smallint          default 0   not null,
    primary key (arenaTeamId, guid)
);

create table auctionhouse
(
    id          int unsigned     default '0' not null
        primary key,
    houseid     tinyint unsigned default '7' not null,
    itemguid    int unsigned     default '0' not null,
    itemowner   int unsigned     default '0' not null,
    buyoutprice int unsigned     default '0' not null,
    time        int unsigned     default '0' not null,
    buyguid     int unsigned     default '0' not null,
    lastbid     int unsigned     default '0' not null,
    startbid    int unsigned     default '0' not null,
    deposit     int unsigned     default '0' not null,
    constraint item_guid
        unique (itemguid)
);

create table banned_addons
(
    Id        int unsigned auto_increment
        primary key,
    Name      varchar(255)                           not null,
    Version   varchar(255) default ''                not null,
    Timestamp timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint idx_name_ver
        unique (Name, Version)
);

create table battleground_deserters
(
    guid     int unsigned     not null comment 'characters.guid',
    type     tinyint unsigned not null comment 'type of the desertion',
    datetime datetime         not null comment 'datetime of the desertion'
);

create table bugreport
(
    id       int unsigned auto_increment comment 'Identifier'
        primary key,
    type     longtext          not null,
    content  longtext          not null,
    State    tinyint default 1 not null,
    Assignee varchar(255)      null,
    Comment  longtext          null
)
    comment 'Debug System';

create table calendar_events
(
    id          bigint unsigned  default '0' not null
        primary key,
    creator     int unsigned     default '0' not null,
    title       varchar(255)     default ''  not null,
    description varchar(255)     default ''  not null,
    type        tinyint unsigned default '4' not null,
    dungeon     int              default -1  not null,
    eventtime   int unsigned     default '0' not null,
    flags       int unsigned     default '0' not null,
    time2       int unsigned     default '0' not null
);

create table calendar_invites
(
    id         bigint unsigned  default '0' not null
        primary key,
    event      bigint unsigned  default '0' not null,
    invitee    int unsigned     default '0' not null,
    sender     int unsigned     default '0' not null,
    status     tinyint unsigned default '0' not null,
    statustime int unsigned     default '0' not null,
    `rank`     tinyint unsigned default '0' not null,
    text       varchar(255)     default ''  not null
);

create table channels
(
    channelId int unsigned auto_increment
        primary key,
    name      varchar(128)                 not null,
    team      int unsigned                 not null,
    announce  tinyint unsigned default '1' not null,
    ownership tinyint unsigned default '1' not null,
    password  varchar(32)                  null,
    lastUsed  int unsigned                 not null
)
    comment 'Channel System';

create table channels_bans
(
    channelId  int unsigned not null,
    playerGUID int unsigned not null,
    banTime    int unsigned not null,
    primary key (channelId, playerGUID)
);

create table channels_rights
(
    name         varchar(128)            not null
        primary key,
    flags        int unsigned            not null,
    speakdelay   int unsigned            not null,
    joinmessage  varchar(255) default '' not null,
    delaymessage varchar(255) default '' not null,
    moderators   text                    null
);

create table character_account_data
(
    guid int unsigned     default '0' not null,
    type tinyint unsigned default '0' not null,
    time int unsigned     default '0' not null,
    data blob                         not null,
    primary key (guid, type)
);

create table character_achievement
(
    guid        int unsigned             not null,
    achievement smallint unsigned        not null,
    date        int unsigned default '0' not null,
    primary key (guid, achievement)
);

create table character_achievement_offline_updates
(
    guid        int unsigned     not null comment 'Character''s GUID',
    update_type tinyint unsigned not null comment 'Supported types: 1 - COMPLETE_ACHIEVEMENT; 2 - UPDATE_CRITERIA',
    arg1        int unsigned     not null comment 'For type 1: achievement ID; for type 2: ACHIEVEMENT_CRITERIA_TYPE',
    arg2        int unsigned     null comment 'For type 2: miscValue1 for updating achievement criteria',
    arg3        int unsigned     null comment 'For type 2: miscValue2 for updating achievement criteria'
)
    comment 'Stores updates to character achievements when the character was offline';

create index idx_guid
    on character_achievement_offline_updates (guid);

create table character_achievement_progress
(
    guid     int unsigned             not null,
    criteria smallint unsigned        not null,
    counter  int unsigned             not null,
    date     int unsigned default '0' not null,
    primary key (guid, criteria)
);

create table character_action
(
    guid   int unsigned     default '0' not null,
    spec   tinyint unsigned default '0' not null,
    button tinyint unsigned default '0' not null,
    action int unsigned     default '0' not null,
    type   tinyint unsigned default '0' not null,
    primary key (guid, spec, button)
);

create table character_arena_stats
(
    guid             int unsigned      default '0' not null,
    slot             tinyint unsigned  default '0' not null,
    matchMakerRating smallint unsigned default '0' not null,
    maxMMR           smallint                      not null,
    primary key (guid, slot)
);

create table character_aura
(
    guid            int unsigned     default '0' not null comment 'Global Unique Identifier',
    casterGuid      bigint unsigned  default '0' not null comment 'Full Global Unique Identifier',
    itemGuid        bigint unsigned  default '0' not null,
    spell           int unsigned     default '0' not null,
    effectMask      tinyint unsigned default '0' not null,
    recalculateMask tinyint unsigned default '0' not null,
    stackCount      tinyint unsigned default '1' not null,
    amount0         int              default 0   not null,
    amount1         int              default 0   not null,
    amount2         int              default 0   not null,
    base_amount0    int              default 0   not null,
    base_amount1    int              default 0   not null,
    base_amount2    int              default 0   not null,
    maxDuration     int              default 0   not null,
    remainTime      int              default 0   not null,
    remainCharges   tinyint unsigned default '0' not null,
    primary key (guid, casterGuid, itemGuid, spell, effectMask)
)
    comment 'Player System';

create table character_banned
(
    guid      int unsigned     default '0' not null comment 'Global Unique Identifier',
    bandate   int unsigned     default '0' not null,
    unbandate int unsigned     default '0' not null,
    bannedby  varchar(50)                  not null,
    banreason varchar(255)                 not null,
    active    tinyint unsigned default '1' not null,
    primary key (guid, bandate)
)
    comment 'Ban List';

create table character_battleground_random
(
    guid int unsigned default '0' not null
        primary key
);

create table character_brew_of_the_month
(
    guid        int unsigned             not null
        primary key,
    lastEventId int unsigned default '0' not null
);

create table character_declinedname
(
    guid          int unsigned default '0' not null comment 'Global Unique Identifier'
        primary key,
    genitive      varchar(15)  default ''  not null,
    dative        varchar(15)  default ''  not null,
    accusative    varchar(15)  default ''  not null,
    instrumental  varchar(15)  default ''  not null,
    prepositional varchar(15)  default ''  not null
);

create table character_entry_point
(
    guid       int unsigned default '0' not null comment 'Global Unique Identifier'
        primary key,
    joinX      float        default 0   not null,
    joinY      float        default 0   not null,
    joinZ      float        default 0   not null,
    joinO      float        default 0   not null,
    joinMapId  int unsigned default '0' not null comment 'Map Identifier',
    taxiPath0  int unsigned default '0' not null,
    taxiPath1  int unsigned default '0' not null,
    mountSpell int unsigned default '0' not null
)
    comment 'Player System';

create table character_equipmentsets
(
    guid        int              default 0   not null,
    setguid     bigint auto_increment
        primary key,
    setindex    tinyint unsigned default '0' not null,
    name        varchar(31)                  not null,
    iconname    varchar(100)                 not null,
    ignore_mask int unsigned     default '0' not null,
    item0       int unsigned     default '0' not null,
    item1       int unsigned     default '0' not null,
    item2       int unsigned     default '0' not null,
    item3       int unsigned     default '0' not null,
    item4       int unsigned     default '0' not null,
    item5       int unsigned     default '0' not null,
    item6       int unsigned     default '0' not null,
    item7       int unsigned     default '0' not null,
    item8       int unsigned     default '0' not null,
    item9       int unsigned     default '0' not null,
    item10      int unsigned     default '0' not null,
    item11      int unsigned     default '0' not null,
    item12      int unsigned     default '0' not null,
    item13      int unsigned     default '0' not null,
    item14      int unsigned     default '0' not null,
    item15      int unsigned     default '0' not null,
    item16      int unsigned     default '0' not null,
    item17      int unsigned     default '0' not null,
    item18      int unsigned     default '0' not null,
    constraint idx_set
        unique (guid, setguid, setindex)
);

create index Idx_setindex
    on character_equipmentsets (setindex);

create table character_gifts
(
    guid      int unsigned default '0' not null,
    item_guid int unsigned default '0' not null
        primary key,
    entry     int unsigned default '0' not null,
    flags     int unsigned default '0' not null
);

create index idx_guid
    on character_gifts (guid);

create table character_glyphs
(
    guid        int unsigned                  not null,
    talentGroup tinyint unsigned  default '0' not null,
    glyph1      smallint unsigned default '0' null,
    glyph2      smallint unsigned default '0' null,
    glyph3      smallint unsigned default '0' null,
    glyph4      smallint unsigned default '0' null,
    glyph5      smallint unsigned default '0' null,
    glyph6      smallint unsigned default '0' null,
    primary key (guid, talentGroup)
);

create table character_homebind
(
    guid   int unsigned      default '0' not null comment 'Global Unique Identifier'
        primary key,
    mapId  smallint unsigned default '0' not null comment 'Map Identifier',
    zoneId smallint unsigned default '0' not null comment 'Zone Identifier',
    posX   float             default 0   not null,
    posY   float             default 0   not null,
    posZ   float             default 0   not null
)
    comment 'Player System';

create table character_instance
(
    guid      int unsigned     default '0' not null,
    instance  int unsigned     default '0' not null,
    permanent tinyint unsigned default '0' not null,
    extended  tinyint unsigned             not null,
    primary key (guid, instance)
);

create index instance
    on character_instance (instance);

create table character_inventory
(
    guid int unsigned     default '0' not null comment 'Global Unique Identifier',
    bag  int unsigned     default '0' not null,
    slot tinyint unsigned default '0' not null,
    item int unsigned     default '0' not null comment 'Item Global Unique Identifier'
        primary key,
    constraint guid
        unique (guid, bag, slot)
)
    comment 'Player System';

create index idx_guid
    on character_inventory (guid);

create table character_pet
(
    id             int unsigned      default '0'   not null
        primary key,
    entry          int unsigned      default '0'   not null,
    owner          int unsigned      default '0'   not null,
    modelid        int unsigned      default '0'   null,
    CreatedBySpell int unsigned      default '0'   null,
    PetType        tinyint unsigned  default '0'   not null,
    level          smallint unsigned default '1'   not null,
    exp            int unsigned      default '0'   not null,
    Reactstate     tinyint unsigned  default '0'   not null,
    name           varchar(21)       default 'Pet' not null,
    renamed        tinyint unsigned  default '0'   not null,
    slot           tinyint unsigned  default '0'   not null,
    curhealth      int unsigned      default '1'   not null,
    curmana        int unsigned      default '0'   not null,
    curhappiness   int unsigned      default '0'   not null,
    savetime       int unsigned      default '0'   not null,
    abdata         text                            null
)
    comment 'Pet System';

create index idx_slot
    on character_pet (slot);

create index owner
    on character_pet (owner);

create table character_pet_declinedname
(
    id            int unsigned default '0' not null
        primary key,
    owner         int unsigned default '0' not null,
    genitive      varchar(12)  default ''  not null,
    dative        varchar(12)  default ''  not null,
    accusative    varchar(12)  default ''  not null,
    instrumental  varchar(12)  default ''  not null,
    prepositional varchar(12)  default ''  not null
);

create index owner_key
    on character_pet_declinedname (owner);

create table character_queststatus
(
    guid        int unsigned      default '0' not null comment 'Global Unique Identifier',
    quest       int unsigned      default '0' not null comment 'Quest Identifier',
    status      tinyint unsigned  default '0' not null,
    explored    tinyint unsigned  default '0' not null,
    timer       int unsigned      default '0' not null,
    mobcount1   smallint unsigned default '0' not null,
    mobcount2   smallint unsigned default '0' not null,
    mobcount3   smallint unsigned default '0' not null,
    mobcount4   smallint unsigned default '0' not null,
    itemcount1  smallint unsigned default '0' not null,
    itemcount2  smallint unsigned default '0' not null,
    itemcount3  smallint unsigned default '0' not null,
    itemcount4  smallint unsigned default '0' not null,
    itemcount5  smallint unsigned default '0' not null,
    itemcount6  smallint unsigned default '0' not null,
    playercount smallint unsigned default '0' not null,
    primary key (guid, quest)
)
    comment 'Player System';

create table character_queststatus_daily
(
    guid  int unsigned default '0' not null comment 'Global Unique Identifier',
    quest int unsigned default '0' not null comment 'Quest Identifier',
    time  int unsigned default '0' not null,
    primary key (guid, quest)
)
    comment 'Player System';

create index idx_guid
    on character_queststatus_daily (guid);

create table character_queststatus_monthly
(
    guid  int unsigned default '0' not null comment 'Global Unique Identifier',
    quest int unsigned default '0' not null comment 'Quest Identifier',
    primary key (guid, quest)
)
    comment 'Player System';

create index idx_guid
    on character_queststatus_monthly (guid);

create table character_queststatus_rewarded
(
    guid   int unsigned     default '0' not null comment 'Global Unique Identifier',
    quest  int unsigned     default '0' not null comment 'Quest Identifier',
    active tinyint unsigned default '1' not null,
    primary key (guid, quest)
)
    comment 'Player System';

create table character_queststatus_seasonal
(
    guid  int unsigned default '0' not null comment 'Global Unique Identifier',
    quest int unsigned default '0' not null comment 'Quest Identifier',
    event int unsigned default '0' not null comment 'Event Identifier',
    primary key (guid, quest)
)
    comment 'Player System';

create index idx_guid
    on character_queststatus_seasonal (guid);

create table character_queststatus_weekly
(
    guid  int unsigned default '0' not null comment 'Global Unique Identifier',
    quest int unsigned default '0' not null comment 'Quest Identifier',
    primary key (guid, quest)
)
    comment 'Player System';

create index idx_guid
    on character_queststatus_weekly (guid);

create table character_reputation
(
    guid     int unsigned      default '0' not null comment 'Global Unique Identifier',
    faction  smallint unsigned default '0' not null,
    standing int               default 0   not null,
    flags    smallint unsigned default '0' not null,
    primary key (guid, faction)
)
    comment 'Player System';

create table character_settings
(
    guid   int unsigned not null,
    source varchar(40)  not null,
    data   text         null,
    primary key (guid, source)
)
    comment 'Player Settings';

create table character_skills
(
    guid  int unsigned      not null comment 'Global Unique Identifier',
    skill smallint unsigned not null,
    value smallint unsigned not null,
    max   smallint unsigned not null,
    primary key (guid, skill)
)
    comment 'Player System';

create table character_social
(
    guid   int unsigned     default '0' not null comment 'Character Global Unique Identifier',
    friend int unsigned     default '0' not null comment 'Friend Global Unique Identifier',
    flags  tinyint unsigned default '0' not null comment 'Friend Flags',
    note   varchar(48)      default ''  not null comment 'Friend Note',
    primary key (guid, friend, flags)
)
    comment 'Player System';

create index friend
    on character_social (friend);

create table character_spell
(
    guid     int unsigned     default '0' not null comment 'Global Unique Identifier',
    spell    int unsigned     default '0' not null comment 'Spell Identifier',
    specMask tinyint unsigned default '1' not null,
    primary key (guid, spell)
)
    comment 'Player System';

create table character_spell_cooldown
(
    guid     int unsigned     default '0' not null comment 'Global Unique Identifier, Low part',
    spell    int unsigned     default '0' not null comment 'Spell Identifier',
    category int unsigned     default '0' null,
    item     int unsigned     default '0' not null comment 'Item Identifier',
    time     int unsigned     default '0' not null,
    needSend tinyint unsigned default '1' not null,
    primary key (guid, spell)
);

create table character_stats
(
    guid              int unsigned default '0' not null comment 'Global Unique Identifier, Low part'
        primary key,
    maxhealth         int unsigned default '0' not null,
    maxpower1         int unsigned default '0' not null,
    maxpower2         int unsigned default '0' not null,
    maxpower3         int unsigned default '0' not null,
    maxpower4         int unsigned default '0' not null,
    maxpower5         int unsigned default '0' not null,
    maxpower6         int unsigned default '0' not null,
    maxpower7         int unsigned default '0' not null,
    strength          int unsigned default '0' not null,
    agility           int unsigned default '0' not null,
    stamina           int unsigned default '0' not null,
    intellect         int unsigned default '0' not null,
    spirit            int unsigned default '0' not null,
    armor             int unsigned default '0' not null,
    resHoly           int unsigned default '0' not null,
    resFire           int unsigned default '0' not null,
    resNature         int unsigned default '0' not null,
    resFrost          int unsigned default '0' not null,
    resShadow         int unsigned default '0' not null,
    resArcane         int unsigned default '0' not null,
    blockPct          float        default 0   not null,
    dodgePct          float        default 0   not null,
    parryPct          float        default 0   not null,
    critPct           float        default 0   not null,
    rangedCritPct     float        default 0   not null,
    spellCritPct      float        default 0   not null,
    attackPower       int unsigned default '0' not null,
    rangedAttackPower int unsigned default '0' not null,
    spellPower        int unsigned default '0' not null,
    resilience        int unsigned default '0' not null,
    check ((`blockPct` >= 0) and (`dodgePct` >= 0) and (`parryPct` >= 0) and (`critPct` >= 0) and
           (`rangedCritPct` >= 0) and (`spellCritPct` >= 0))
);

create table character_talent
(
    guid     int unsigned                 not null,
    spell    int unsigned                 not null,
    specMask tinyint unsigned default '0' not null,
    primary key (guid, spell)
);

create table characters
(
    guid                  int unsigned      default '0'               not null comment 'Global Unique Identifier'
        primary key,
    account               int unsigned      default '0'               not null comment 'Account Identifier',
    name                  varchar(12) collate utf8mb4_bin             not null,
    race                  tinyint unsigned  default '0'               not null,
    class                 tinyint unsigned  default '0'               not null,
    gender                tinyint unsigned  default '0'               not null,
    level                 tinyint unsigned  default '0'               not null,
    xp                    int unsigned      default '0'               not null,
    money                 int unsigned      default '0'               not null,
    skin                  tinyint unsigned  default '0'               not null,
    face                  tinyint unsigned  default '0'               not null,
    hairStyle             tinyint unsigned  default '0'               not null,
    hairColor             tinyint unsigned  default '0'               not null,
    facialStyle           tinyint unsigned  default '0'               not null,
    bankSlots             tinyint unsigned  default '0'               not null,
    restState             tinyint unsigned  default '0'               not null,
    playerFlags           int unsigned      default '0'               not null,
    position_x            float             default 0                 not null,
    position_y            float             default 0                 not null,
    position_z            float             default 0                 not null,
    map                   smallint unsigned default '0'               not null comment 'Map Identifier',
    instance_id           int unsigned      default '0'               not null,
    instance_mode_mask    tinyint unsigned  default '0'               not null,
    orientation           float             default 0                 not null,
    taximask              text                                        not null,
    online                tinyint unsigned  default '0'               not null,
    cinematic             tinyint unsigned  default '0'               not null,
    totaltime             int unsigned      default '0'               not null,
    leveltime             int unsigned      default '0'               not null,
    logout_time           int unsigned      default '0'               not null,
    is_logout_resting     tinyint unsigned  default '0'               not null,
    rest_bonus            float             default 0                 not null,
    resettalents_cost     int unsigned      default '0'               not null,
    resettalents_time     int unsigned      default '0'               not null,
    trans_x               float             default 0                 not null,
    trans_y               float             default 0                 not null,
    trans_z               float             default 0                 not null,
    trans_o               float             default 0                 not null,
    transguid             int               default 0                 null,
    extra_flags           smallint unsigned default '0'               not null,
    stable_slots          tinyint unsigned  default '0'               not null,
    at_login              smallint unsigned default '0'               not null,
    zone                  smallint unsigned default '0'               not null,
    death_expire_time     int unsigned      default '0'               not null,
    taxi_path             text                                        null,
    arenaPoints           int unsigned      default '0'               not null,
    totalHonorPoints      int unsigned      default '0'               not null,
    todayHonorPoints      int unsigned      default '0'               not null,
    yesterdayHonorPoints  int unsigned      default '0'               not null,
    totalKills            int unsigned      default '0'               not null,
    todayKills            smallint unsigned default '0'               not null,
    yesterdayKills        smallint unsigned default '0'               not null,
    chosenTitle           int unsigned      default '0'               not null,
    knownCurrencies       bigint unsigned   default '0'               not null,
    watchedFaction        int unsigned      default '0'               not null,
    drunk                 tinyint unsigned  default '0'               not null,
    health                int unsigned      default '0'               not null,
    power1                int unsigned      default '0'               not null,
    power2                int unsigned      default '0'               not null,
    power3                int unsigned      default '0'               not null,
    power4                int unsigned      default '0'               not null,
    power5                int unsigned      default '0'               not null,
    power6                int unsigned      default '0'               not null,
    power7                int unsigned      default '0'               not null,
    latency               int unsigned      default '0'               null,
    talentGroupsCount     tinyint unsigned  default '1'               not null,
    activeTalentGroup     tinyint unsigned  default '0'               not null,
    exploredZones         longtext                                    null,
    equipmentCache        longtext                                    null,
    ammoId                int unsigned      default '0'               not null,
    knownTitles           longtext                                    null,
    actionBars            tinyint unsigned  default '0'               not null,
    grantableLevels       tinyint unsigned  default '0'               not null,
    `order`               tinyint                                     null,
    creation_date         timestamp         default CURRENT_TIMESTAMP not null,
    deleteInfos_Account   int unsigned                                null,
    deleteInfos_Name      varchar(12)                                 null,
    deleteDate            int unsigned                                null,
    innTriggerId          int unsigned                                not null,
    extraBonusTalentCount int               default 0                 not null
)
    comment 'Player System';

create index idx_account
    on characters (account);

create index idx_name
    on characters (name);

create index idx_online
    on characters (online);

create table corpse
(
    guid        int unsigned      default '0' not null comment 'Character Global Unique Identifier'
        primary key,
    posX        float             default 0   not null,
    posY        float             default 0   not null,
    posZ        float             default 0   not null,
    orientation float             default 0   not null,
    mapId       smallint unsigned default '0' not null comment 'Map Identifier',
    phaseMask   int unsigned      default '1' not null,
    displayId   int unsigned      default '0' not null,
    itemCache   text                          not null,
    bytes1      int unsigned      default '0' not null,
    bytes2      int unsigned      default '0' not null,
    guildId     int unsigned      default '0' not null,
    flags       tinyint unsigned  default '0' not null,
    dynFlags    tinyint unsigned  default '0' not null,
    time        int unsigned      default '0' not null,
    corpseType  tinyint unsigned  default '0' not null,
    instanceId  int unsigned      default '0' not null comment 'Instance Identifier'
)
    comment 'Death System';

create index idx_instance
    on corpse (instanceId);

create index idx_time
    on corpse (time);

create index idx_type
    on corpse (corpseType);

create table creature_respawn
(
    guid        int unsigned      default '0' not null comment 'Global Unique Identifier',
    respawnTime int unsigned      default '0' not null,
    mapId       smallint unsigned default '0' not null,
    instanceId  int unsigned      default '0' not null comment 'Instance Identifier',
    primary key (guid, instanceId)
)
    comment 'Grid Loading System';

create index idx_instance
    on creature_respawn (instanceId);

create table game_event_condition_save
(
    eventEntry   tinyint unsigned         not null,
    condition_id int unsigned default '0' not null,
    done         float        default 0   null,
    primary key (eventEntry, condition_id)
);

create table game_event_save
(
    eventEntry tinyint unsigned             not null
        primary key,
    state      tinyint unsigned default '1' not null,
    next_start int unsigned     default '0' not null
);

create table gameobject_respawn
(
    guid        int unsigned      default '0' not null comment 'Global Unique Identifier',
    respawnTime int unsigned      default '0' not null,
    mapId       smallint unsigned default '0' not null,
    instanceId  int unsigned      default '0' not null comment 'Instance Identifier',
    primary key (guid, instanceId)
)
    comment 'Grid Loading System';

create index idx_instance
    on gameobject_respawn (instanceId);

create table gm_subsurvey
(
    surveyId      int unsigned auto_increment,
    questionId    int unsigned default '0' not null,
    answer        int unsigned default '0' not null,
    answerComment text                     not null,
    primary key (surveyId, questionId)
)
    comment 'Player System';

create table gm_survey
(
    surveyId   int unsigned auto_increment
        primary key,
    guid       int unsigned default '0' not null,
    mainSurvey int unsigned default '0' not null,
    comment    longtext                 not null,
    createTime int unsigned default '0' not null,
    maxMMR     smallint                 not null
)
    comment 'Player System';

create table gm_ticket
(
    id               int unsigned auto_increment
        primary key,
    type             tinyint unsigned  default '0' not null comment '0 open, 1 closed, 2 character deleted',
    playerGuid       int unsigned      default '0' not null comment 'Global Unique Identifier of ticket creator',
    name             varchar(12)                   not null comment 'Name of ticket creator',
    description      text                          not null,
    createTime       int unsigned      default '0' not null,
    mapId            smallint unsigned default '0' not null,
    posX             float             default 0   not null,
    posY             float             default 0   not null,
    posZ             float             default 0   not null,
    lastModifiedTime int unsigned      default '0' not null,
    closedBy         int               default 0   not null comment '-1 Closed by Console, >0 GUID of GM',
    assignedTo       int unsigned      default '0' not null comment 'GUID of admin to whom ticket is assigned',
    comment          text                          not null,
    response         text                          not null,
    completed        tinyint unsigned  default '0' not null,
    escalated        tinyint unsigned  default '0' not null,
    viewed           tinyint unsigned  default '0' not null,
    needMoreHelp     tinyint unsigned  default '0' not null,
    resolvedBy       int               default 0   not null comment '-1 Resolved by Console, >0 GUID of GM'
)
    comment 'Player System';

create table group_member
(
    guid        int unsigned                 not null,
    memberGuid  int unsigned                 not null
        primary key,
    memberFlags tinyint unsigned default '0' not null,
    subgroup    tinyint unsigned default '0' not null,
    roles       tinyint unsigned default '0' not null
)
    comment 'Groups';

create table `groups`
(
    guid             int unsigned                 not null
        primary key,
    leaderGuid       int unsigned                 not null,
    lootMethod       tinyint unsigned             not null,
    looterGuid       int unsigned                 not null,
    lootThreshold    tinyint unsigned             not null,
    icon1            bigint unsigned              not null,
    icon2            bigint unsigned              not null,
    icon3            bigint unsigned              not null,
    icon4            bigint unsigned              not null,
    icon5            bigint unsigned              not null,
    icon6            bigint unsigned              not null,
    icon7            bigint unsigned              not null,
    icon8            bigint unsigned              not null,
    groupType        tinyint unsigned             not null,
    difficulty       tinyint unsigned default '0' not null,
    raidDifficulty   tinyint unsigned default '0' not null,
    masterLooterGuid int unsigned                 not null
)
    comment 'Groups';

create index leaderGuid
    on `groups` (leaderGuid);

create table guild
(
    guildid         int unsigned     default '0' not null
        primary key,
    name            varchar(24)      default ''  not null,
    leaderguid      int unsigned     default '0' not null,
    EmblemStyle     tinyint unsigned default '0' not null,
    EmblemColor     tinyint unsigned default '0' not null,
    BorderStyle     tinyint unsigned default '0' not null,
    BorderColor     tinyint unsigned default '0' not null,
    BackgroundColor tinyint unsigned default '0' not null,
    info            varchar(500)     default ''  not null,
    motd            varchar(128)     default ''  not null,
    createdate      int unsigned     default '0' not null,
    BankMoney       bigint unsigned  default '0' not null
)
    comment 'Guild System';

create table guild_bank_eventlog
(
    guildid        int unsigned      default '0' not null comment 'Guild Identificator',
    LogGuid        int unsigned      default '0' not null comment 'Log record identificator - auxiliary column',
    TabId          tinyint unsigned  default '0' not null comment 'Guild bank TabId',
    EventType      tinyint unsigned  default '0' not null comment 'Event type',
    PlayerGuid     int unsigned      default '0' not null,
    ItemOrMoney    int unsigned      default '0' not null,
    ItemStackCount smallint unsigned default '0' not null,
    DestTabId      tinyint unsigned  default '0' not null comment 'Destination Tab Id',
    TimeStamp      int unsigned      default '0' not null comment 'Event UNIX time',
    primary key (guildid, LogGuid, TabId)
);

create index Idx_LogGuid
    on guild_bank_eventlog (LogGuid);

create index Idx_PlayerGuid
    on guild_bank_eventlog (PlayerGuid);

create index guildid_key
    on guild_bank_eventlog (guildid);

create table guild_bank_item
(
    guildid   int unsigned     default '0' not null,
    TabId     tinyint unsigned default '0' not null,
    SlotId    tinyint unsigned default '0' not null,
    item_guid int unsigned     default '0' not null,
    primary key (guildid, TabId, SlotId)
);

create index Idx_item_guid
    on guild_bank_item (item_guid);

create index guildid_key
    on guild_bank_item (guildid);

create table guild_bank_right
(
    guildid    int unsigned     default '0' not null,
    TabId      tinyint unsigned default '0' not null,
    rid        tinyint unsigned default '0' not null,
    gbright    tinyint unsigned default '0' not null,
    SlotPerDay int unsigned     default '0' not null,
    primary key (guildid, TabId, rid)
);

create index guildid_key
    on guild_bank_right (guildid);

create table guild_bank_tab
(
    guildid int unsigned     default '0' not null,
    TabId   tinyint unsigned default '0' not null,
    TabName varchar(16)      default ''  not null,
    TabIcon varchar(100)     default ''  not null,
    TabText varchar(500)                 null,
    primary key (guildid, TabId)
);

create index guildid_key
    on guild_bank_tab (guildid);

create table guild_eventlog
(
    guildid     int unsigned     not null comment 'Guild Identificator',
    LogGuid     int unsigned     not null comment 'Log record identificator - auxiliary column',
    EventType   tinyint unsigned not null comment 'Event type',
    PlayerGuid1 int unsigned     not null comment 'Player 1',
    PlayerGuid2 int unsigned     not null comment 'Player 2',
    NewRank     tinyint unsigned not null comment 'New rank(in case promotion/demotion)',
    TimeStamp   int unsigned     not null comment 'Event UNIX time',
    primary key (guildid, LogGuid)
)
    comment 'Guild Eventlog';

create index Idx_LogGuid
    on guild_eventlog (LogGuid);

create index Idx_PlayerGuid1
    on guild_eventlog (PlayerGuid1);

create index Idx_PlayerGuid2
    on guild_eventlog (PlayerGuid2);

create table guild_member
(
    guildid int unsigned           not null comment 'Guild Identificator',
    guid    int unsigned           not null,
    `rank`  tinyint unsigned       not null,
    pnote   varchar(31) default '' not null,
    offnote varchar(31) default '' not null,
    constraint guid_key
        unique (guid)
)
    comment 'Guild System';

create index guildid_key
    on guild_member (guildid);

create index guildid_rank_key
    on guild_member (guildid, `rank`);

create table guild_member_withdraw
(
    guid  int unsigned             not null
        primary key,
    tab0  int unsigned default '0' not null,
    tab1  int unsigned default '0' not null,
    tab2  int unsigned default '0' not null,
    tab3  int unsigned default '0' not null,
    tab4  int unsigned default '0' not null,
    tab5  int unsigned default '0' not null,
    money int unsigned default '0' not null
)
    comment 'Guild Member Daily Withdraws';

create table guild_rank
(
    guildid         int unsigned default '0' not null,
    rid             tinyint unsigned         not null,
    rname           varchar(20)  default ''  not null,
    rights          int unsigned default '0' null,
    BankMoneyPerDay int unsigned default '0' not null,
    primary key (guildid, rid)
)
    comment 'Guild System';

create index Idx_rid
    on guild_rank (rid);

create table instance
(
    id                  int unsigned      default '0' not null
        primary key,
    map                 smallint unsigned default '0' not null,
    resettime           int unsigned      default '0' not null,
    difficulty          tinyint unsigned  default '0' not null,
    completedEncounters int unsigned      default '0' not null,
    data                tinytext                      not null
);

create index difficulty
    on instance (difficulty);

create index map
    on instance (map);

create index resettime
    on instance (resettime);

create table instance_reset
(
    mapid      smallint unsigned default '0' not null,
    difficulty tinyint unsigned  default '0' not null,
    resettime  int unsigned      default '0' not null,
    primary key (mapid, difficulty)
);

create index difficulty
    on instance_reset (difficulty);

create table instance_saved_go_state_data
(
    id    int unsigned                 not null comment 'instance.id',
    guid  int unsigned                 not null comment 'gameobject.guid',
    state tinyint unsigned default '0' null comment 'gameobject.state',
    primary key (id, guid)
);

create table item_instance
(
    guid             int unsigned      default '0' not null
        primary key,
    itemEntry        int unsigned      default '0' null,
    owner_guid       int unsigned      default '0' not null,
    creatorGuid      int unsigned      default '0' not null,
    giftCreatorGuid  int unsigned      default '0' not null,
    count            int unsigned      default '1' not null,
    duration         int               default 0   not null,
    charges          tinytext                      null,
    flags            int unsigned      default '0' null,
    enchantments     text                          not null,
    randomPropertyId smallint          default 0   not null,
    durability       smallint unsigned default '0' not null,
    playedTime       int unsigned      default '0' not null,
    text             text                          null
)
    comment 'Item System';

create index idx_owner_guid
    on item_instance (owner_guid);

create table item_loot_storage
(
    containerGUID     int unsigned             not null,
    itemid            int unsigned             not null,
    count             int unsigned             not null,
    item_index        int unsigned default '0' not null,
    randomPropertyId  int                      not null,
    randomSuffix      int unsigned             not null,
    follow_loot_rules tinyint unsigned         not null,
    freeforall        tinyint unsigned         not null,
    is_blocked        tinyint unsigned         not null,
    is_counted        tinyint unsigned         not null,
    is_underthreshold tinyint unsigned         not null,
    needs_quest       tinyint unsigned         not null,
    conditionLootId   int          default 0   not null
);

create table item_refund_instance
(
    item_guid        int unsigned                  not null comment 'Item GUID',
    player_guid      int unsigned                  not null comment 'Player GUID',
    paidMoney        int unsigned      default '0' not null,
    paidExtendedCost smallint unsigned default '0' not null,
    primary key (item_guid, player_guid)
)
    comment 'Item Refund System';

create table item_soulbound_trade_data
(
    itemGuid       int unsigned not null comment 'Item GUID'
        primary key,
    allowedPlayers text         not null comment 'Space separated GUID list of players who can receive this item in trade'
)
    comment 'Item Refund System';

create table lag_reports
(
    reportId   int unsigned auto_increment
        primary key,
    guid       int unsigned      default '0' not null,
    lagType    tinyint unsigned  default '0' not null,
    mapId      smallint unsigned default '0' not null,
    posX       float             default 0   not null,
    posY       float             default 0   not null,
    posZ       float             default 0   not null,
    latency    int unsigned      default '0' not null,
    createTime int unsigned      default '0' not null
)
    comment 'Player System';

create table lfg_data
(
    guid    int unsigned     default '0' not null comment 'Global Unique Identifier'
        primary key,
    dungeon int unsigned     default '0' not null,
    state   tinyint unsigned default '0' not null
)
    comment 'LFG Data';

create table log_arena_fights
(
    fight_id         int unsigned      not null
        primary key,
    time             datetime          not null,
    type             tinyint unsigned  not null,
    duration         int unsigned      not null,
    winner           int unsigned      not null,
    loser            int unsigned      not null,
    winner_tr        smallint unsigned not null,
    winner_mmr       smallint unsigned not null,
    winner_tr_change smallint          not null,
    loser_tr         smallint unsigned not null,
    loser_mmr        smallint unsigned not null,
    loser_tr_change  smallint          not null,
    currOnline       int unsigned      not null
);

create table log_arena_memberstats
(
    fight_id  int unsigned     not null,
    member_id tinyint unsigned not null,
    name      char(20)         not null,
    guid      int unsigned     not null,
    team      int unsigned     not null,
    account   int unsigned     not null,
    ip        char(15)         not null,
    damage    int unsigned     not null,
    heal      int unsigned     not null,
    kblows    int unsigned     not null,
    primary key (fight_id, member_id)
);

create table log_encounter
(
    time        datetime          not null,
    map         smallint unsigned not null,
    difficulty  tinyint unsigned  not null,
    creditType  tinyint unsigned  not null,
    creditEntry int unsigned      not null,
    playersInfo text              not null
);

create table log_money
(
    sender_acc    int unsigned    not null,
    sender_guid   int unsigned    not null,
    sender_name   text            not null,
    sender_ip     text            not null,
    receiver_acc  int unsigned    not null,
    receiver_name text            not null,
    money         bigint unsigned not null,
    topic         text            not null,
    date          datetime        not null,
    type          tinyint         not null comment '1=COD,2=AH,3=GB DEPOSIT,4=GB WITHDRAW,5=MAIL,6=TRADE'
);

create table mail
(
    id             int unsigned      default '0' not null comment 'Identifier'
        primary key,
    messageType    tinyint unsigned  default '0' not null,
    stationery     tinyint           default 41  not null,
    mailTemplateId smallint unsigned default '0' not null,
    sender         int unsigned      default '0' not null comment 'Character Global Unique Identifier',
    receiver       int unsigned      default '0' not null comment 'Character Global Unique Identifier',
    subject        longtext                      null,
    body           longtext                      null,
    has_items      tinyint unsigned  default '0' not null,
    expire_time    int unsigned      default '0' not null,
    deliver_time   int unsigned      default '0' not null,
    money          int unsigned      default '0' not null,
    cod            int unsigned      default '0' not null,
    checked        tinyint unsigned  default '0' not null
)
    comment 'Mail System';

create index idx_receiver
    on mail (receiver);

create table mail_items
(
    mail_id   int unsigned default '0' not null,
    item_guid int unsigned default '0' not null
        primary key,
    receiver  int unsigned default '0' not null comment 'Character Global Unique Identifier'
);

create index idx_mail_id
    on mail_items (mail_id);

create index idx_receiver
    on mail_items (receiver);

create table mail_server_template
(
    id      int unsigned auto_increment
        primary key,
    moneyA  int unsigned     default '0' not null,
    moneyH  int unsigned     default '0' not null,
    subject text                         not null,
    body    text                         not null,
    active  tinyint unsigned default '1' not null
);

create table mail_server_character
(
    guid   int unsigned not null,
    mailId int unsigned not null,
    primary key (guid, mailId),
    constraint fk_mail_server_character
        foreign key (mailId) references mail_server_template (id)
            on delete cascade
);

create table mail_server_template_conditions
(
    id             int unsigned auto_increment
        primary key,
    templateID     int unsigned                                                                                                 not null,
    conditionType  enum ('Level', 'PlayTime', 'Quest', 'Achievement', 'Reputation', 'Faction', 'Race', 'Class', 'AccountFlags') not null,
    conditionValue int unsigned                                                                                                 not null,
    conditionState int unsigned default '0'                                                                                     not null,
    constraint fk_mail_template_conditions
        foreign key (templateID) references mail_server_template (id)
            on delete cascade
);

create table mail_server_template_items
(
    id         int unsigned auto_increment
        primary key,
    templateID int unsigned               not null,
    faction    enum ('Alliance', 'Horde') not null,
    item       int unsigned               not null,
    itemCount  int unsigned               not null,
    constraint fk_mail_template
        foreign key (templateID) references mail_server_template (id)
            on delete cascade
);

create table mod_custom_pets_learned
(
    player_guid  int unsigned                       not null comment 'GUID del personaje',
    pet_id       int unsigned                       not null comment 'ID de la mascota en mod_custom_pets',
    learned_date datetime default CURRENT_TIMESTAMP not null comment 'Fecha de aprendizaje',
    primary key (player_guid, pet_id)
)
    comment 'Mascotas custom aprendidas por cada personaje' charset = utf8mb4;

create table mod_gathering_mastery_progress
(
    player_guid int           not null,
    item_entry  int           not null,
    count       int default 0 not null comment 'Total acumulado del item',
    primary key (player_guid, item_entry)
)
    charset = utf8mb4;

create index idx_player
    on mod_gathering_mastery_progress (player_guid);

create table mod_gathering_mastery_unlocked
(
    player_guid     int           not null,
    rule_id         int           not null,
    times_triggered int default 0 not null comment 'Veces que se dispar├│ (>1 solo si repeatable=1)',
    primary key (player_guid, rule_id)
)
    charset = utf8mb4;

create index idx_player
    on mod_gathering_mastery_unlocked (player_guid);

create table mod_multi_spec_glyphs
(
    guid      int unsigned             not null,
    spec_slot tinyint unsigned         not null,
    slot_idx  tinyint unsigned         not null,
    glyph_id  int unsigned default '0' not null,
    primary key (guid, spec_slot, slot_idx)
)
    comment 'mod-multi-spec: glyphs por slot de especializaci├│n' charset = utf8mb4;

create table mod_multi_spec_player
(
    guid        int unsigned                 not null
        primary key,
    active_slot tinyint unsigned default '0' not null,
    migrated    tinyint unsigned default '0' not null
)
    comment 'mod-multi-spec: estado activo por personaje' charset = utf8mb4;

create table mod_multi_spec_talents
(
    guid      int unsigned                 not null,
    spec_slot tinyint unsigned             not null,
    talent_id int unsigned                 not null,
    spec_rank tinyint unsigned default '0' not null,
    primary key (guid, spec_slot, talent_id)
)
    comment 'mod-multi-spec: talentos por slot de especializaci├│n' charset = utf8mb4;

create table pet_aura
(
    guid            int unsigned     default '0' not null comment 'Global Unique Identifier',
    casterGuid      bigint unsigned  default '0' not null comment 'Full Global Unique Identifier',
    spell           int unsigned     default '0' not null,
    effectMask      tinyint unsigned default '0' not null,
    recalculateMask tinyint unsigned default '0' not null,
    stackCount      tinyint unsigned default '1' not null,
    amount0         int                          null,
    amount1         int                          null,
    amount2         int                          null,
    base_amount0    int                          null,
    base_amount1    int                          null,
    base_amount2    int                          null,
    maxDuration     int              default 0   not null,
    remainTime      int              default 0   not null,
    remainCharges   tinyint unsigned default '0' not null,
    primary key (guid, casterGuid, spell, effectMask)
)
    comment 'Pet System';

create table pet_spell
(
    guid   int unsigned     default '0' not null comment 'Global Unique Identifier',
    spell  int unsigned     default '0' not null comment 'Spell Identifier',
    active tinyint unsigned default '0' not null,
    primary key (guid, spell)
)
    comment 'Pet System';

create table pet_spell_cooldown
(
    guid     int unsigned default '0' not null comment 'Global Unique Identifier, Low part',
    spell    int unsigned default '0' not null comment 'Spell Identifier',
    category int unsigned default '0' null,
    time     int unsigned default '0' not null,
    primary key (guid, spell)
);

create table petition
(
    ownerguid    int unsigned                 not null,
    petitionguid int unsigned     default '0' null,
    petition_id  int unsigned     default '0' not null,
    name         varchar(24)                  not null,
    type         tinyint unsigned default '0' not null,
    primary key (ownerguid, type),
    constraint index_ownerguid_petitionguid
        unique (ownerguid, petitionguid)
)
    comment 'Guild System';

create index idx_petition_id
    on petition (petition_id);

create table petition_sign
(
    ownerguid      int unsigned                 not null,
    petitionguid   int unsigned     default '0' not null,
    petition_id    int unsigned     default '0' not null,
    playerguid     int unsigned     default '0' not null,
    player_account int unsigned     default '0' not null,
    type           tinyint unsigned default '0' not null,
    primary key (petitionguid, playerguid)
)
    comment 'Guild System';

create index Idx_ownerguid
    on petition_sign (ownerguid);

create index Idx_playerguid
    on petition_sign (playerguid);

create index idx_petition_id_player
    on petition_sign (petition_id, playerguid);

create table pool_quest_save
(
    pool_id  int unsigned default '0' not null,
    quest_id int unsigned default '0' not null,
    primary key (pool_id, quest_id)
);

create table profanity_name
(
    name varchar(12) collate utf8mb4_bin not null
        primary key
);

create table pvpstats_battlegrounds
(
    id             bigint unsigned auto_increment
        primary key,
    winner_faction tinyint          not null,
    bracket_id     tinyint unsigned not null,
    type           tinyint unsigned not null,
    date           datetime         not null
);

create table pvpstats_players
(
    battleground_id       bigint unsigned          not null,
    character_guid        int unsigned             not null,
    winner                bit                      not null,
    score_killing_blows   int unsigned             null,
    score_deaths          int unsigned             null,
    score_honorable_kills int unsigned             null,
    score_bonus_honor     int unsigned             null,
    score_damage_done     int unsigned             null,
    score_healing_done    int unsigned             null,
    attr_1                int unsigned default '0' null,
    attr_2                int unsigned default '0' null,
    attr_3                int unsigned default '0' null,
    attr_4                int unsigned default '0' null,
    attr_5                int unsigned default '0' null,
    primary key (battleground_id, character_guid)
);

create table quest_tracker
(
    id                  int unsigned default '0' not null,
    character_guid      int unsigned default '0' not null,
    quest_accept_time   datetime                 not null,
    quest_complete_time datetime                 null,
    quest_abandon_time  datetime                 null,
    completed_by_gm     tinyint      default 0   not null,
    core_hash           varchar(120) default '0' not null,
    core_revision       varchar(120) default '0' not null,
    constraint idx_latest_quest_for_character
        unique (id asc, character_guid asc, quest_accept_time desc)
);

create table recovery_item
(
    Id         int unsigned auto_increment
        primary key,
    Guid       int unsigned default '0' not null,
    ItemEntry  int unsigned default '0' null,
    Count      int unsigned default '0' not null,
    DeleteDate int unsigned             null
);

create index idx_guid
    on recovery_item (Guid);

create table reserved_name
(
    name varchar(12) collate utf8mb4_bin not null
        primary key
)
    comment 'Player Reserved Names';

create table spam_reports
(
    ID                  int unsigned auto_increment
        primary key,
    SpamType            tinyint unsigned         not null comment '0 = mail, 1 = chat, 2 = calendar',
    SpammerGuid         int unsigned default '0' not null,
    Unk1                int unsigned default '0' null,
    MailIdOrMessageType int unsigned default '0' null,
    ChannelId           int unsigned             null comment 'Only used if SpamType = 1',
    SecondsSinceMessage int unsigned             null comment 'Only used if SpamType = 1',
    Description         longtext                 null,
    Time                int                      null comment 'Time of report'
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

create table warden_action
(
    wardenId smallint unsigned not null
        primary key,
    action   tinyint unsigned  null
);

create table world_state
(
    Id   int unsigned not null comment 'Internal save ID'
        primary key,
    Data longtext     null
)
    comment 'WorldState save system' charset = utf8mb4;

create table worldstates
(
    entry   int unsigned default '0' not null
        primary key,
    value   int unsigned default '0' not null,
    comment tinytext                 null
)
    comment 'Variable Saves';

