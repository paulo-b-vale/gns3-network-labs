INSERT INTO nas (nasname, shortname, type, secret, description) VALUES
  ('172.28.0.0/24', 'docker-bridge', 'mikrotik', 'lab-radius-secret-2026', 'BRAS-CHR via Docker bridge'),
  ('192.168.150.0/24', 'gns3-lab-network', 'mikrotik', 'lab-radius-secret-2026', 'BRAS-CHR direct lab subnet');

INSERT INTO radgroupreply (groupname, attribute, op, value) VALUES
  ('plano-bronze-10m', 'Mikrotik-Rate-Limit', ':=', '5M/10M'),
  ('plano-bronze-10m', 'Service-Type', ':=', 'Framed-User'),
  ('plano-bronze-10m', 'Framed-Protocol', ':=', 'PPP');

INSERT INTO radgroupreply (groupname, attribute, op, value) VALUES
  ('plano-prata-30m', 'Mikrotik-Rate-Limit', ':=', '15M/30M'),
  ('plano-prata-30m', 'Service-Type', ':=', 'Framed-User'),
  ('plano-prata-30m', 'Framed-Protocol', ':=', 'PPP');

INSERT INTO radgroupreply (groupname, attribute, op, value) VALUES
  ('plano-ouro-100m', 'Mikrotik-Rate-Limit', ':=', '50M/100M'),
  ('plano-ouro-100m', 'Service-Type', ':=', 'Framed-User'),
  ('plano-ouro-100m', 'Framed-Protocol', ':=', 'PPP');

INSERT INTO radgroupreply (groupname, attribute, op, value) VALUES
  ('plano-diamante-300m', 'Mikrotik-Rate-Limit', ':=', '150M/300M'),
  ('plano-diamante-300m', 'Service-Type', ':=', 'Framed-User'),
  ('plano-diamante-300m', 'Framed-Protocol', ':=', 'PPP');

INSERT INTO radgroupreply (groupname, attribute, op, value) VALUES
  ('plano-empresarial-500m', 'Mikrotik-Rate-Limit', ':=', '500M/500M'),
  ('plano-empresarial-500m', 'Service-Type', ':=', 'Framed-User'),
  ('plano-empresarial-500m', 'Framed-Protocol', ':=', 'PPP');

INSERT INTO radcheck (username, attribute, op, value) VALUES ('customer001', 'Cleartext-Password', ':=', 'lab1234');
INSERT INTO radusergroup (username, groupname, priority) VALUES ('customer001', 'plano-prata-30m', 1);

INSERT INTO radcheck (username, attribute, op, value) VALUES ('customer002', 'Cleartext-Password', ':=', 'senha002');
INSERT INTO radusergroup (username, groupname, priority) VALUES ('customer002', 'plano-bronze-10m', 1);

INSERT INTO radcheck (username, attribute, op, value) VALUES ('customer003', 'Cleartext-Password', ':=', 'senha003');
INSERT INTO radusergroup (username, groupname, priority) VALUES ('customer003', 'plano-ouro-100m', 1);

INSERT INTO radcheck (username, attribute, op, value) VALUES ('customer004', 'Cleartext-Password', ':=', 'senha004');
INSERT INTO radusergroup (username, groupname, priority) VALUES ('customer004', 'plano-diamante-300m', 1);

INSERT INTO radcheck (username, attribute, op, value) VALUES ('empresa001', 'Cleartext-Password', ':=', 'senhaempresa');
INSERT INTO radusergroup (username, groupname, priority) VALUES ('empresa001', 'plano-empresarial-500m', 1);
