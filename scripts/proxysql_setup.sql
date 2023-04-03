INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'10.0.3.10',3306);
INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'10.0.4.10',3306);
INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'10.0.5.10',3306);

CREATE USER 'proxysql'@'%' IDENTIFIED WITH mysql_native_password by 'ProxySQLPa55';
GRANT USAGE ON *.* TO 'proxysql'@'%';
CREATE USER 'sbuser'@'10.0.3.11' IDENTIFIED with mysql_native_password BY 'sbpass';
GRANT ALL ON *.* TO 'sbuser'@'10.0.3.11';

UPDATE global_variables SET variable_value='proxysql'
WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='ProxySQLPa55'
WHERE variable_name='mysql-monitor_password';


SELECT * FROM monitor.mysql_server_connect_log ORDER BY time_start_us DESC LIMIT 6;

SELECT * FROM monitor.mysql_server_ping_log ORDER BY time_start_us DESC LIMIT 6;

INSERT INTO mysql_users (username,password) VALUES ('sbuser','sbpass');

LOAD MYSQL SERVERS TO RUNTIME;
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

