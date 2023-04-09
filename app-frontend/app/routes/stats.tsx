import { FC, useMemo } from "react";
import { useQuery } from "react-query";
import axios from "axios";
import { GroupedNodeStat, NodeGroup, NodeStat, ServerStats } from "~/types/nodeStats";
import NodeStatsWidget from "~/widgets/NodeStatWidget";
import { BsChevronRight } from "react-icons/bs";
import { Link } from "@remix-run/react";

const defaultServerStats: ServerStats = {
	web: [],
	app: [],
	db: [],
	file: [],
	lb: [],
	nat: [],
	bastion: [],
};

const useMemoizedGroupedNoteStats = (data: NodeStat[] | undefined) =>
	useMemo(() => {
		if (!data) return Object.entries(defaultServerStats);
		return Object.entries(
			data.reduce<ServerStats>((accum, curr) => {
				switch (true) {
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
	}, [data]) as GroupedNodeStat;

const StatsRoute: FC = () => {
	const { data } = useQuery(["node-health"], () => axios.get<NodeStat[]>("http://15.220.241.217/all-health").then((res) => res.data), {
		refetchInterval: 1000,
	});
	const groupedNoteStats = useMemoizedGroupedNoteStats(data);

	return (
		<>
			<div className="flex gap-x-2 items-center text-sm mx-8 px-2 mb-3 pb-2 font-medium">
				<Link to="/" className="text-primary">
					Home
				</Link>
				<BsChevronRight className="w-2.5 h-2.5" />
				<span>Server Stats</span>
			</div>
			<div className="flex flex-wrap gap-4 mx-8 mb-8">
				{groupedNoteStats.map(([nodeGroup, nodeStats]) => (
					<NodeStatsWidget key={nodeGroup} nodeStats={nodeStats} nodeGroup={nodeGroup} />
				))}
			</div>
		</>
	);
};

export default StatsRoute;
