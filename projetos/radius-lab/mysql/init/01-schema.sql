CREATE TABLE IF NOT EXISTS radcheck (
  id int(11) unsigned NOT NULL auto_increment,
  username varchar(64) NOT NULL DEFAULT '',
  attribute varchar(64) NOT NULL DEFAULT '',
  op char(2) NOT NULL DEFAULT '==',
  value varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY username (username(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS radreply (
  id int(11) unsigned NOT NULL auto_increment,
  username varchar(64) NOT NULL DEFAULT '',
  attribute varchar(64) NOT NULL DEFAULT '',
  op char(2) NOT NULL DEFAULT '=',
  value varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY username (username(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS radgroupcheck (
  id int(11) unsigned NOT NULL auto_increment,
  groupname varchar(64) NOT NULL DEFAULT '',
  attribute varchar(64) NOT NULL DEFAULT '',
  op char(2) NOT NULL DEFAULT '==',
  value varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY groupname (groupname(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS radgroupreply (
  id int(11) unsigned NOT NULL auto_increment,
  groupname varchar(64) NOT NULL DEFAULT '',
  attribute varchar(64) NOT NULL DEFAULT '',
  op char(2) NOT NULL DEFAULT '=',
  value varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY groupname (groupname(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS radusergroup (
  id int(11) unsigned NOT NULL auto_increment,
  username varchar(64) NOT NULL DEFAULT '',
  groupname varchar(64) NOT NULL DEFAULT '',
  priority int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  KEY username (username(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS nas (
  id int(10) NOT NULL auto_increment,
  nasname varchar(128) NOT NULL,
  shortname varchar(32),
  type varchar(30) DEFAULT 'other',
  ports int(5),
  secret varchar(60) DEFAULT 'secret' NOT NULL,
  server varchar(64),
  community varchar(50),
  description varchar(200) DEFAULT 'RADIUS Client',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS radacct (
  radacctid bigint(21) NOT NULL auto_increment,
  acctsessionid varchar(64) NOT NULL DEFAULT '',
  acctuniqueid varchar(32) NOT NULL DEFAULT '',
  username varchar(64) NOT NULL DEFAULT '',
  groupname varchar(64) NOT NULL DEFAULT '',
  realm varchar(64) DEFAULT '',
  nasipaddress varchar(15) NOT NULL DEFAULT '',
  nasportid varchar(32),
  nasporttype varchar(32),
  acctstarttime datetime NULL DEFAULT NULL,
  acctupdatetime datetime NULL DEFAULT NULL,
  acctstoptime datetime NULL DEFAULT NULL,
  acctinterval int(12),
  acctsessiontime int(12) unsigned,
  acctauthentic varchar(32),
  connectinfo_start varchar(50),
  connectinfo_stop varchar(50),
  acctinputoctets bigint(20),
  acctoutputoctets bigint(20),
  calledstationid varchar(50) NOT NULL DEFAULT '',
  callingstationid varchar(50) NOT NULL DEFAULT '',
  acctterminatecause varchar(32) NOT NULL DEFAULT '',
  servicetype varchar(32),
  framedprotocol varchar(32),
  framedipaddress varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (radacctid),
  UNIQUE KEY acctuniqueid (acctuniqueid),
  KEY username (username),
  KEY framedipaddress (framedipaddress),
  KEY acctsessionid (acctsessionid),
  KEY acctsessiontime (acctsessiontime),
  KEY acctstarttime (acctstarttime),
  KEY acctstoptime (acctstoptime),
  KEY nasipaddress (nasipaddress)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
