-- The different period types that can be used.
CREATE TYPE period_enum AS ENUM ('second', 'minute', 'hour', 'day', 'week', 'month', 'year');

-- A period creates the unit of time that an inventory may be rented for
-- We can set the minimum and maximum period, price per period type...
-- These periods can be named and used with many different inventories.
CREATE TABLE period (
    id serial not null,
    label varchar not null,
    -- XXX: Should min/max_value be in a different table?
    min_value int not null,
    max_value int not null,
    period_type period_enum not null,
    -- This is the price in cents
    price bigint not null
);

-- Example period Monthly with min/max of 1 month $100/month
INSERT INTO period (label, min_value, max_value, period_type, price) VALUES ('Monthly', 1, 1, 'month', 10000);
