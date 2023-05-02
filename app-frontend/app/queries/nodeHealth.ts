import axios from "axios";
import { useMemo } from "react";
import { useQuery } from "react-query";
import { GroupedNodeStat, NodeStat, ServerStats } from "~/types/nodeStats";

const useQueryNodeHealth = () => {
	const query = useQuery(["node-health"], () => axios.get<NodeStat[]>("http://15.220.241.25/all-health").then((res) => res.data), {
		refetchInterval: 1000,
	});
	const defaultServerStats: ServerStats = {
		web: [],
		app: [],
		db: [],
		file: [],
		lb: [],
		nat: [],
		bastion: [],
	};

	const groupedNodeStat = useMemo(() => {
		if (!query.data) return Object.entries(defaultServerStats);
		return Object.entries(
			query.data.reduce<ServerStats>((accum, curr) => {
				switch (true) {
					case Object.prototype.toString.call(curr.node_name) !== "[object String]":
						return accum;
					case curr.node_name.includes("appserver"):
						return { ...accum, app: [...accum.app, curr] };
					case curr.node_name.includes("webserver"):
						return { ...accum, web: [...accum.web, curr] };
					case curr.node_name.includes("dbserver"):
						return { ...accum, db: [...accum.db, curr] };
					case curr.node_name.includes("load_balancer"):
						return { ...accum, lb: [...accum.lb, curr] };
					case curr.node_name.includes("bastion"):
						return { ...accum, bastion: [...accum.bastion, curr] };
					case curr.node_name.includes("file"):
						return { ...accum, file: [...accum.file, curr] };
					case curr.node_name.includes("natgateway"):
						return { ...accum, nat: [...accum.nat, curr] };
					default:
						return accum;
				}
			}, defaultServerStats)
		);
	}, [query.data]) as GroupedNodeStat;

	return { query, groupedNodeStat };
};

export { useQueryNodeHealth };
