import AppServerStats from "~/widgets/AppServerStats";
import { FC } from "react";
import WebServerStats from "~/widgets/WebServerStats";

const StatsRoute: FC = () => {
	return (
		<div>
			<AppServerStats />
			<WebServerStats />
		</div>
	);
};

export default StatsRoute;
