DROP TABLE customer_info IF EXISTS;

CREATE TABLE customer_info (
     -- hsqldb
     id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

    email varchar(320),
    name varchar(100),

    details varbinary(65535),

    createdTimestamp bigint NOT NULL,
    lastModifiedTimestamp bigint NOT NULL

);

CREATE UNIQUE INDEX idx_customer_info_email on customer_info (email);

