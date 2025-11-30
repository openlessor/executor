DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
  id serial,
  premise_id uuid not null,
  name varchar not null,
  description varchar not null,
  quantity int not null default 0,
  FOREIGN KEY (premise_id) REFERENCES premise(id)
);

INSERT INTO inventory (premise_id, name, description, quantity) VALUES ((SELECT id FROM premise LIMIT 1), 'Test Inventory Item 1', 'This is a test inventory item', 1);

DROP TABLE IF EXISTS inventory_period_map;
CREATE TABLE inventory_period_map (
  inventory_id integer not null,
  period_id integer not null
);

INSERT INTO inventory_period_map VALUES (1, (SELECT id FROM period LIMIT 1));
