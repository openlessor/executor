CREATE TABLE inventory (
  id serial,
  tenantId uuid not null,
  name varchar not null,
  description varchar not null,
  quantity int not null default 0
);

ALTER TABLE inventory ADD COLUMN tenantId uuid not null;
