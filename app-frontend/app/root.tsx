import type { LinksFunction } from "@remix-run/node";
import { Links, LiveReload, Meta, Outlet, Scripts, ScrollRestoration } from "@remix-run/react";
import stylesheet from "~/tailwind.css";
import { QueryClient, QueryClientProvider } from "react-query";
import Navbar from "./shared-widgets/Navbar";

export const links: LinksFunction = () => [{ rel: "stylesheet", href: stylesheet }];

const queryClient = new QueryClient();
export default function App() {
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
					<div className="flex flex-col">
						<Navbar />
						<div className="mt-4">
							<Outlet />
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
