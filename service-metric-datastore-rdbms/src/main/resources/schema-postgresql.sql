create table service_metric (
    -- postgresql     

    customerId int,
    equipmentId bigint not null,
    clientMac bigint not null,
    dataType int not null,
    createdTimestamp bigint not null,
    
    details bytea,
    
    primary key (customerId, equipmentId, clientMac, dataType, createdTimestamp)
  
);

create index service_metric_customerId on service_metric (customerId);
create index service_metric_customerEquipmentDatatype on service_metric (customerId, equipmentId, dataType);


