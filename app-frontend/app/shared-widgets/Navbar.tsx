import { Link } from "@remix-run/react";
import { FC } from "react";
import { SiAmazonec2 } from "react-icons/si";
import { ImStatsBars2 } from "react-icons/im";

const Navbar: FC = () => {
	return (
		<div className="w-screen py-3 flex items-center px-8 border-b border-secondary border-opacity-10 shadow-sm justify-between">
			<Link to="/" className="flex items-center gap-x-4">
				<img src="/aws_logo_dark.png" className="h-5" alt="" />
				<span className="text-gray-700 text-sm font-semibold">The High Available Blog Website</span>
			</Link>
			<div className="flex items-center gap-x-1">
				<Link to="/benchmark" className="flex items-center gap-x-1 border border-primary rounded px-2 py-1 text-primary">
					<ImStatsBars2 />
					<span className="text-sm">Benchmark</span>
				</Link>
				<Link to="/stats" className="flex items-center gap-x-1 border border-primary rounded px-2 py-1 text-primary">
					<SiAmazonec2 />
					<span className="text-sm">View Stats</span>
				</Link>
			</div>
		</div>
	);
};

export default Navbar;
