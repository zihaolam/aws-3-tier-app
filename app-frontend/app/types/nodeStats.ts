export interface ServerStats {
	db: NodeStat[];
	web: NodeStat[];
	app: NodeStat[];
	lb: NodeStat[];
	file: NodeStat[];
	nat: NodeStat[];
	bastion: NodeStat[];
}

export type NodeGroup = keyof ServerStats;

export type NodeType =
	| "dbserver-1"
	| "dbserver-2"
	| "dbserver-3"
	| "db_load_balancer"
	| "webserver-1"
	| "webserver-2"
	| "web_load_balancer"
	| "app_load_balancer"
	| "appserver-1"
	| "appserver-2"
	| "file-server-1"
	| "file-server-2"
	| "bastionhost-server"
	| "natgateway-server";

export interface NodeStat {
	private_ip: string;
	utilization: {
		cpu: number;
		memory: number;
	};
	node_name: NodeType;
}

export type GroupedNodeStat = [NodeGroup, NodeStat[]][];

export interface BenchmarkResults {
	timeStarted: number;
	timeEnded: number;
	numberOfExecutions: number;
	timeTakenInMS: number;
	apiServedBy: "10.0.3.100" | "10.0.4.100";
	dbServedBy: "ip-10-0-3-10" | "ip-10-0-4-10" | "ip-10-0-5-10";
}
