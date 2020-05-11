drop table equipment_routing if exists;
drop table equipment_gateway if exists;

create table equipment_gateway (
     -- hsqldb 
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    hostname varchar(80) not null,
    ipAddr varchar(50) not null,
    port integer not null,
    gatewayType integer default 1 not null,

    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null

);

create index equipment_gateway_hostname on equipment_gateway (hostname);

create table equipment_routing (
     -- hsqldb 
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    equipmentId bigint not null,
    customerId integer,
    gatewayId bigint not null,

    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null,

    FOREIGN KEY (gatewayId) REFERENCES equipment_gateway(id) ON DELETE CASCADE
    
);


create index equipment_routing_customerId on equipment_routing (customerId);
create index equipment_routing_equipmentId on equipment_routing (equipmentId);
create index equipment_routing_gatewayId on equipment_routing (gatewayId);

