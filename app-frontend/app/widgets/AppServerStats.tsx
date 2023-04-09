import axios from "axios";
import { FC } from "react";
import { useQuery } from "react-query";
import type { NodeStats } from "~/types/nodeStats";

const getNodeStats = (nodeIp: string) => axios<NodeStats>(nodeIp).then((res) => res.data);

const AppServerStats: FC = () => {
	const { data } = useQuery(
		["nodeStats"],
		() => Promise.all([getNodeStats("http://15.220.241.217/health"), getNodeStats("http://15.220.241.217/health")])
		// { refetchInterval: 300 }
	);

	const node1 = data?.[0];
	const node2 = data?.[1];
	return (
		<div className="flex-1 gap-x-4 mx-8 mt-2 px-2 pt-1 pb-2 border border-secondary rounded border-opacity-20 text-sm">
			<div className="font-medium text-base mb-2 underline">App Servers</div>
			<div className="flex gap-x-4">
				<div className="flex flex-col flex-1 px-2 py-1 bg-gray-300 rounded">
					<span className="font-semibold">Node 1</span>
					<span className="text-xs grid grid-cols-2">
						<span>Private IP: </span>
						{node1?.private_ip}
					</span>
					<span className="text-xs grid grid-cols-2">
						<span>CPU Utilization: </span>
						{node1?.utilization.cpu}%
					</span>
					<span className="text-xs grid grid-cols-2">
						<span>Memory Utilization: </span>
						{node1?.utilization.memory.toFixed(2)}%
					</span>
				</div>
				<div className="flex flex-col flex-1 px-2 py-1 bg-gray-300 rounded">
					<span className="font-semibold">Node 2</span>
					<span className="text-xs grid grid-cols-2">
						<span>Private IP: </span>
						{node2?.private_ip}
					</span>
					<span className="text-xs grid grid-cols-2">
						<span>CPU Utilization: </span>
						{node2?.utilization.cpu}%
					</span>
					<span className="text-xs grid grid-cols-2">
						<span>Memory Utilization: </span>
						{node2?.utilization.memory.toFixed(2)}%
					</span>
				</div>
			</div>
		</div>
	);
};

export default AppServerStats;
