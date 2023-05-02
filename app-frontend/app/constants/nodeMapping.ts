import { NodeGroup } from "~/types/nodeStats";

const serverTypeMapping: { [nodeGroup in NodeGroup]: string } = {
	app: "App Servers",
	web: "Web Servers",
	lb: "Load Balancers",
	db: "DB Servers",
	nat: "Nat Gateway Server",
	bastion: "Bastion Host Server",
	file: "File Servers",
};

const nodeNameMapping = {
	"dbserver-1": "MySQL Master Node",
	"dbserver-2": "MySQL Read Replica 1",
	"dbserver-3": "MySQL Read Replica 2",
	db_load_balancer: "ProxySQL Node",
	"webserver-1": "Webserver 1",
	"webserver-2": "Webserver 2",
	"appserver-1": "Appserver 1",
	"appserver-2": "Appserver 2",
	"file-server-1": "Fileserver 1",
	"file-server-2": "Fileserver 2",
	"bastionhost-server": "Bastion Host",
	"natgateway-server": "Nat Gateway Server",
	web_load_balancer: "Web Load Balancer",
	app_load_balancer: "App Load Balancer",
	"web_load_balancer-1": "Web Load Balancer 1",
	"web_load_balancer-2": "Web Load Balancer 2",
	"app_load_balancer-1": "App Load Balancer 1",
	"app_load_balancer-2": "App Load Balancer 2",
};

const ipMapping = {
	"10.0.4.100": "Appserver 2",
	"10.0.3.100": "Appserver 1",
	"ip-10-0-3-10": "MySQL Master Node",
	"ip-10-0-4-10": "MySQL Read Replica 1",
	"ip-10-0-5-10": "MySQL Read Replica 2",
};

export { nodeNameMapping, serverTypeMapping, ipMapping };
