import { FC } from "react";
import type { NodeGroup, NodeStat } from "~/types/nodeStats";
import { SiAmazonec2 } from "react-icons/si";

const serverTypeMapping: { [nodeGroup in NodeGroup]: string } = {
    app: "App Servers",
    web: "Web Servers",
    lb: "Load Balancers",
    db: "DB Servers",
    nat: "Nat Gateway Server",
    bastion: "Bastion Host Server",
    file: "File Servers",
};

const NodeDetails: FC<{ nodeStat: NodeStat }> = ({ nodeStat }) => (
    <div className="flex flex-col px-2 py-1 bg-gray-100 border border-gray-200 border-opacity-30 rounded w-56 relative">
        <span className="font-medium mb-1 capitalize flex text-sm items-center gap-x-1">
            <SiAmazonec2 className="text-primary" />
            {nodeStat.node_name}
        </span>
        <span className="text-xs grid grid-cols-4 ml-1">
            <span className="col-span-3">- CPU Utilization: </span>
            <span
                className={`font-medium ${
                    nodeStat.utilization.cpu < 80
                        ? "text-green-600"
                        : "text-red-600"
                }`}
            >
                {nodeStat.utilization.cpu}%
            </span>
        </span>
        <span className="text-xs grid grid-cols-4 ml-1">
            <span className="col-span-3">- Memory Utilization: </span>
            <span
                className={`font-medium ${
                    nodeStat.utilization.memory < 80
                        ? "text-green-600"
                        : "text-red-600"
                }`}
            >
                {nodeStat.utilization.memory.toFixed(2)}%
            </span>
        </span>
        <span className="text-xxs mt-5 text-gray-500 font-medium mb-1">
            Private IP: {nodeStat.private_ip}
        </span>
    </div>
);

const NodeStatWidget: FC<{ nodeGroup: NodeGroup; nodeStats: NodeStat[] }> = ({
    nodeGroup,
    nodeStats,
}) => {
    return (
        <div className="flex-1 px-2 pt-1 pb-2 border border-gray-400 rounded border-opacity-20 shadow-sm text-sm">
            <div className="font-medium text-base mb-2">
                {serverTypeMapping[nodeGroup]}
            </div>
            <div className="flex gap-4 flex-wrap">
                {nodeStats.map((nodeStat) => (
                    <NodeDetails key={nodeStat.node_name} nodeStat={nodeStat} />
                ))}
            </div>
        </div>
    );
};

export default NodeStatWidget;
