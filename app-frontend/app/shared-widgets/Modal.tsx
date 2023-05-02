import { useEffect, type FC, type ReactNode, useRef } from "react";
import { FiX } from "react-icons/fi";

interface ModalProps {
	open: () => void;
	close: () => void;
	isOpen: boolean;
	children: ReactNode;
	title?: string;
}

const Modal: FC<ModalProps> = ({ open, close, isOpen, children, title = "" }) => {
	const escapeKeyHandler = useRef<(e: KeyboardEvent) => void>((e: KeyboardEvent) => e.key === "Escape" && close());
	useEffect(() => {
		document.addEventListener("keyup", escapeKeyHandler.current);
		return () => document.removeEventListener("keyup", escapeKeyHandler.current);
	}, []);

	return (
		<div className={`fixed bg-opacity-50 bg-secondary h-screen w-screen top-0 left-0 flex items-center justify-center ${isOpen ? "" : "hidden"}`}>
			<div className="min-w-[400px] bg-white rounded">
				<div className="flex justify-between border-b p-2">
					<span className="text-sm font-medium">{title}</span>
					<FiX className="w-4 h-4 text-gray-500" onClick={close} />
				</div>
				<div className="p-2">{children}</div>
			</div>
		</div>
	);
};

export default Modal;
