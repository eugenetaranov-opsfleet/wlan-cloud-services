create table firmware_version (
    -- postgresql     
    id BIGSERIAL PRIMARY KEY,

    equipmentType int not null,
    modelId varchar(50),
    versionName varchar(50) unique not null,
    commitTag varchar(20),
    description varchar(100),
    filename varchar(255),
    validationMethod int,
    validationCode varchar(255),
    releaseDate bigint not null,
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null
  
);
CREATE INDEX idx_firmware_version_name_id on firmware_version(versionName);

create table firmware_track(
    id BIGSERIAL PRIMARY KEY,
    
    trackName varchar(300) unique not null,
    maintenanceWindow varchar(1024),
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null
);
insert into firmware_track (trackname, createdtimestamp, lastmodifiedtimestamp, maintenancewindow)
values ('DEFAULT', 1541694284000, 1541694284000, '{"_type":"EmptySchedule","timezone":null}');

create table firmware_track_assignment (
    trackId bigint not null,
    firmwareId bigint not null,
    defaultForTrack boolean default false,
    deprecated boolean default false,
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null,
    
    PRIMARY KEY(trackId, firmwareId),
    FOREIGN KEY(trackId) REFERENCES firmware_track(id) on delete cascade,
    FOREIGN KEY(firmwareId) REFERENCES firmware_version(id) on delete cascade
);

CREATE INDEX idx_firmware_track_id on firmware_track_assignment(trackId);

create table customer_track_assignment (
    trackId bigint not null,
    customerId int not null,
    settings varchar(255),
    createdTimestamp bigint not null,
    lastModifiedTimestamp bigint not null,
    
    PRIMARY KEY(customerId),
    FOREIGN KEY(trackId) REFERENCES firmware_track(id) on delete cascade
);
