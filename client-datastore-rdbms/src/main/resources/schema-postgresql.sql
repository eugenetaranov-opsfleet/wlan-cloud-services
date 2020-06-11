create table client (
    -- postgresql     
    macAddress bigint ,

    customerId int,
    details bytea,
    
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null,
  
    primary key (customerId, macAddress)
);

create index idx_client_customerId on client (customerId);

create table client_session (
    -- postgresql     
    macAddress bigint ,

    customerId int,
    equipmentId bigint,
    locationId bigint,
    details bytea,
    
    lastModifiedTimestamp bigint not null,
  
    primary key (customerId, equipmentId, macAddress)
);

create index idx_clientSession_customerId on client_session (customerId);
create index idx_clientSession_locationId on client_session (customerId, locationId);

