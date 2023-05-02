import axios from "axios";
import { UseQueryOptions, useQuery } from "react-query";
import { BenchmarkResults } from "~/types/nodeStats";
import { Post } from "~/types/post";

const useQueryPosts = (options?: UseQueryOptions<Post[], unknown, Post[], string[]>) =>
	useQuery(["posts"], () => axios.get<Post[]>("http://15.220.241.48/post/").then((res) => res.data), options);

const generateSpamPostsPromises = (numberOfExecutions: number) =>
	new Array(numberOfExecutions).fill(0).map(() => axios.get<Post[]>("http://15.220.241.48/post/").then((res) => res.data));

const useExecuteBenchmarkPosts = (
	options?: UseQueryOptions<BenchmarkResults, unknown, BenchmarkResults, string[]> & { numberOfExecutions?: number }
) =>
	useQuery(
		["posts"],
		async () => {
			const timeStarted = Date.now();
			console.log(generateSpamPostsPromises(options?.numberOfExecutions || 1));
			const response = await Promise.all(generateSpamPostsPromises(options?.numberOfExecutions || 1));
			const timeEnded = Date.now();

			return {
				timeStarted,
				timeEnded,
				timeTakenInMS: timeEnded - timeStarted,
				numberOfExecutions: options?.numberOfExecutions || 1,
				dbServedBy: response[0][0]["@@hostname"],
				apiServedBy: response[0][0].backend_ip,
			};
		},
		options
	);

export { useQueryPosts, useExecuteBenchmarkPosts };
