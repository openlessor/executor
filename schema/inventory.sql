CREATE TABLE inventory (
  id serial,
  name varchar not null,
  description varchar not null,
  quantity int not null default 0
)
