CREATE TABLE premise (
  id uuid primary key not null default uuidv4(),
  name varchar not null,
  description varchar not null
);

INSERT INTO premise (name, description) VALUES ('Example Premise', 'An example premise');
