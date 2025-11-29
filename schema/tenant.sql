CREATE TABLE tenant (
  id uuid not null default uuidv4(),
  name varchar not null,
  description varchar not null
);

INSERT INTO tenant (name, description) VALUES ('Example Tenant', 'An example tenant');
