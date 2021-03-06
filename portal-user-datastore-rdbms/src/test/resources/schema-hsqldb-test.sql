drop table portal_user if exists;

create table portal_user (
     -- hsqldb 
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    customerId int,
    username varchar(100),
    password varchar(300),
    role int,
    details varbinary(65535),
    
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null
  
);

create index idx_portal_user_customerId on portal_user (customerId);
create unique index portal_user_customerId_username on portal_user (customerId, username);