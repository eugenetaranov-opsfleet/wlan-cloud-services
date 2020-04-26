drop table profile if exists;

create table profile (
     -- hsqldb 
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    customerId int,
    sampleStr varchar(50),
    details varbinary(65535),
    
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null
  
);

create index profile_customerId on profile (customerId);