import { Link } from "@remix-run/react";
import { FC, useMemo, useRef, useState } from "react";
import { BsChevronRight } from "react-icons/bs";
import { ipMapping, nodeNameMapping, serverTypeMapping } from "~/constants/nodeMapping";
import { useQueryNodeHealth } from "~/queries/nodeHealth";
import { BenchmarkResults, NodeGroup, NodeStat } from "~/types/nodeStats";
import * as Highcharts from "highcharts";
import HighchartsReact from "highcharts-react-official";
import { useExecuteBenchmarkPosts, useQueryPosts } from "~/queries/posts";
import { BiStop } from "react-icons/bi";
import { ImSpinner3 } from "react-icons/im";

const NodeStatChart: FC<{ nodeStat: NodeStat }> = ({ nodeStat }) => {
	const cpuUtilizationLineDataStore = useRef<[string, number][]>([]);

	const cpuUtilizationOptions: Highcharts.Options = useMemo(() => {
		const dateNow = new Date();
		cpuUtilizationLineDataStore.current.push([dateNow.toLocaleTimeString(), nodeStat.utilization.cpu]);

		if (cpuUtilizationLineDataStore.current.length > 10) cpuUtilizationLineDataStore.current = cpuUtilizationLineDataStore.current.slice(-10);

		return {
			title: {
				text: `${nodeNameMapping[nodeStat.node_name]} CPU Utilization (%)`,
				style: { fontSize: "12", fontWeight: "500" },
			},
			xAxis: {
				type: "category",
				dateTimeLabelFormats: {
					hour: "%H:%M:%S",
					day: "%H:%M",
				},
				labels: { enabled: false },
			},
			yAxis: { type: "linear" },
			legend: { enabled: false },
			series: [{ type: "line", data: cpuUtilizationLineDataStore.current, color: "#EC7211" }],
		};
	}, [nodeStat]);

	const chartComponentRef = useRef<HighchartsReact.RefObject>(null);
	return (
		<div className="h-48 border border-gray-150 rounded py-1">
			<HighchartsReact
				highcharts={Highcharts}
				options={cpuUtilizationOptions}
				ref={chartComponentRef}
				containerProps={{
					style: {
						height: "100%",
						width: "300px",
					},
				}}
			/>
		</div>
	);
};

const defaultCumulativeStats = {
	totalApiCalls: 0,
	totalTimeTaken: 0,
};
const BenchmarkPrompt = () => {
	const [isQueryingEnabled, setQueryingEnabled] = useState<boolean>(false);
	const [executionPrompt, setExecutionPrompt] = useState<BenchmarkResults[]>([]);
	const [numberOfExecutions, setNumberOfExecutions] = useState<number>(1);
	const [cumulativeStats, setCumulativeStats] = useState<{ totalApiCalls: number; totalTimeTaken: number }>(defaultCumulativeStats);

	const promptRef = useRef<HTMLDivElement>(null);

	const { isFetching } = useExecuteBenchmarkPosts({
		enabled: isQueryingEnabled,
		numberOfExecutions,
		refetchInterval: 1,
		onSuccess: (data) => {
			setExecutionPrompt((prev) => {
				const newExecutionPrompt = [...prev, data];
				if (prev.length > 30) return [...prev.slice(-30)];
				return newExecutionPrompt;
			});
			setCumulativeStats((prev) => ({ totalTimeTaken: data.timeTakenInMS + prev.totalTimeTaken, totalApiCalls: prev.totalApiCalls + 1 }));
			if (!promptRef.current) return;
			promptRef.current.scroll({ top: promptRef.current.scrollHeight, behavior: "smooth" });
		},
	});

	return (
		<>
			<div className="flex mx-8 items-center gap-x-1 mb-2">
				<button
					className={`flex items-center gap-x-1 border rounded px-2 py-1 ${
						isQueryingEnabled ? "bg-red-500 text-white" : "border-primary text-primary"
					} text-sm`}
					onClick={() => setQueryingEnabled((prev) => !prev)}
				>
					{isQueryingEnabled ? (
						<>
							<BiStop className="w-6 h-6" />
							Stop
						</>
					) : (
						"Execute Benchmark"
					)}
				</button>
				{isQueryingEnabled && (
					<>
						<ImSpinner3 className="animate-spin" />
						<span className="text-xs font-light">Executing</span>
					</>
				)}
				{cumulativeStats.totalApiCalls !== 0 && !isQueryingEnabled && (
					<button
						className={`flex items-center gap-x-1 border rounded px-2 py-1 text-sm border-gray-500 text-gray-500`}
						onClick={() => setCumulativeStats(defaultCumulativeStats)}
					>
						Reset
					</button>
				)}
			</div>
			<div className="border border-gray-150 mx-8 rounded">
				<div className="h-72 max-h-72 overflow-y-scroll border-b border-gray-200" ref={promptRef}>
					{executionPrompt.map((executionResult) => (
						<div className="text-sm px-2 py-1" key={executionResult.timeStarted + executionResult.timeEnded}>
							Read executions completed in <span className="text-green-500">{executionResult.timeTakenInMS}ms</span>, backend served by:{" "}
							<span className="text-purple-500">{ipMapping[executionResult.apiServedBy]}</span>, db served by:{" "}
							<span className="text-pink-500">{ipMapping[executionResult.dbServedBy]}</span>
						</div>
					))}
				</div>
				<div className="py-1 px-2 text-sm bg-gray-100">
					Total API Calls: {cumulativeStats.totalApiCalls}, Total Time Taken: {cumulativeStats.totalTimeTaken}ms, Average Query Time:{" "}
					{cumulativeStats.totalApiCalls !== 0 && cumulativeStats.totalTimeTaken !== 0
						? (cumulativeStats.totalTimeTaken / cumulativeStats.totalApiCalls).toFixed(2)
						: "0"}
					ms
				</div>
			</div>
		</>
	);
};

const BenchmarkPage: FC = () => {
	const { groupedNodeStat } = useQueryNodeHealth();
	return (
		<>
			<div className="flex gap-x-2 items-center text-sm mx-8 px-2 mb-3 pb-2 font-medium">
				<Link to="/benchmark" className="text-primary">
					Home
				</Link>
				<BsChevronRight className="w-2.5 h-2.5" />
				<span>Benchmark</span>
			</div>
			<div className="flex flex-wrap gap-2 mx-8 mb-8">
				{groupedNodeStat
					.filter(([nodeGroup, nodeStats]) => nodeGroup === "db" || nodeGroup === "app")
					.map(([nodeGroup, nodeStats]) => nodeStats.map((nodeStat) => <NodeStatChart nodeStat={nodeStat} key={nodeStat.node_name} />))}
			</div>
			<BenchmarkPrompt />
		</>
	);
};

export default BenchmarkPage;
