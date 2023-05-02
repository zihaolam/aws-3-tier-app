import type { LinksFunction } from "@remix-run/node";
import { Links, LiveReload, Meta, Outlet, Scripts, ScrollRestoration, useLoaderData } from "@remix-run/react";
import stylesheet from "~/tailwind.css";
import { QueryClient, QueryClientProvider } from "react-query";
import { Navbar, BreadCrumbs } from "./shared-widgets";
import { FC } from "react";

export const links: LinksFunction = () => [{ rel: "stylesheet", href: stylesheet }];

export const loader = () => {
	return {
		private_ip: process.env.PRIVATE_IP!,
		instance_name: process.env.INSTANCE_NAME!,
	};
};

const NodeMetaData: FC<{ instance_name: string; private_ip: string }> = ({ instance_name, private_ip }) => (
	<div className="px-8 text-xs flex justify-end gap-x-1 pt-2 text-gray-500 font-semibold">
		<span>Served by</span>
		<span className="text-primary font-medium">{instance_name}</span>
		<span>at</span>
		<span className="text-primary">{private_ip}</span>
	</div>
);

const queryClient = new QueryClient();
export default function App() {
	const data = useLoaderData<typeof loader>();
	return (
		<html lang="en">
			<head>
				<meta charSet="utf-8" />
				<meta name="viewport" content="width=device-width,initial-scale=1" />
				<Meta />
				<Links />
			</head>
			<body>
				<QueryClientProvider client={queryClient}>
					<div className="flex flex-col min-h-screen h-screen">
						<Navbar />
						<div className="flex-1 flex flex-col">
							<NodeMetaData instance_name={data.instance_name} private_ip={data.private_ip} />
							<BreadCrumbs />
							<div className="mt-3 flex-1">
								<Outlet />
							</div>
						</div>
					</div>
					<ScrollRestoration />
					<Scripts />
					<LiveReload />
				</QueryClientProvider>
			</body>
		</html>
	);
}
