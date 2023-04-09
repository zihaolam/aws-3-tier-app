import { type V2_MetaFunction } from "@remix-run/react";

export const meta: V2_MetaFunction = () => {
	return [{ title: "Localzone 3T Dashboard" }];
};

export default function Index() {
	return <div className="flex bg-gray-500"></div>;
}
