import { FC, useMemo } from "react";
import { useQuery } from "react-query";
import axios from "axios";
import { GroupedNodeStat, NodeGroup, NodeStat, ServerStats } from "~/types/nodeStats";
import NodeStatsWidget from "~/widgets/stats/NodeStatWidget";
import { BsChevronRight } from "react-icons/bs";
import { Link } from "@remix-run/react";
import { type V2_MetaFunction } from "@remix-run/react";
import { useQueryNodeHealth } from "~/queries/nodeHealth";

export const meta: V2_MetaFunction = () => {
	return [{ title: "Localzone 3T Dashboard" }];
};

const StatsRoute: FC = () => {
	const {
		query: { data },
		groupedNodeStat,
	} = useQueryNodeHealth();

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
				{groupedNodeStat.map(([nodeGroup, nodeStats]) => (
					<NodeStatsWidget key={nodeGroup} nodeStats={nodeStats} nodeGroup={nodeGroup} />
				))}
			</div>
		</>
	);
};

export default StatsRoute;
