import { FC } from "react";

const Navbar: FC = () => {
	return (
		<div className="w-screen h-12 flex items-center px-8 border-b border-secondary border-opacity-10 shadow-sm">
			<img src="/aws_logo_dark.png" className="h-5 mr-4" alt="" />
			<span className="text-gray-700 text-sm font-semibold">Localzone 3-Tier HA Web App</span>
		</div>
	);
};

export default Navbar;
