/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ["./app/**/*.{js,jsx,ts,tsx}"],
	theme: {
		extend: {
			colors: {
				primary: "#EC7211",
				secondary: "#222F3E",
			},
			fontSize: {
				xxs: ["0.625rem", "0.75rem"],
			},
		},
	},
	plugins: [],
};
