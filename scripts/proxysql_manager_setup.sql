INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'10.0.3.10',3306);
INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (1,'10.0.4.10',3306);
INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (2,'10.0.5.10',3306);

INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^SELECT.*', 1, 0);
INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^SELECT.*FOR UPDATE', 0, 1);

UPDATE global_variables SET variable_value='proxysql'
WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='ProxySQLPa55'
WHERE variable_name='mysql-monitor_password';

INSERT INTO mysql_users (username,password) VALUES ('sbuser','sbpass');

LOAD MYSQL SERVERS TO RUNTIME;
LOAD MYSQL QUERY RULES TO RUNTIME;
LOAD MYSQL VARIABLES TO RUNTIME;
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;
SAVE MYSQL USERS TO DISK;

SELECT * FROM monitor.mysql_server_connect_log ORDER BY time_start_us DESC LIMIT 6;

SELECT * FROM monitor.mysql_server_ping_log ORDER BY time_start_us DESC LIMIT 6;