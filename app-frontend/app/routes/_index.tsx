import { type V2_MetaFunction } from "@remix-run/react";
import axios from "axios";
import { FC, useMemo, useState } from "react";
import { useForm } from "react-hook-form";
import { useMutation, useQuery } from "react-query";
import images from "~/mocks/images";
import Modal from "~/shared-widgets/Modal";
import { Post } from "~/types/post";
import { CgSpinnerAlt } from "react-icons/cg";
import { useQueryPosts } from "~/queries/posts";

export const meta: V2_MetaFunction = () => {
	return [{ title: "Localzone 3T Dashboard" }];
};

const PostItem: FC<{ post: Post }> = ({ post }) => {
	return (
		<div className="mb-1">
			<div className="p-2 border border-gray-400 rounded border-opacity-20 shadow-sm">
				<div className="font-semibold text-md">{post.title}</div>
				<div className="mt-0.5 text-sm font-light">{post.content}</div>
			</div>
		</div>
	);
};

interface CreatePostFormValues {
	content: string;
	title: string;
	created_by: string;
}

const defaultValues = {
	content: "",
	title: "",
	created_by: "",
};

const Loading: FC = () => {
	return (
		<div className="w-full h-64 flex items-center justify-center">
			<CgSpinnerAlt className="w-8 h-8 animate-spin" />
		</div>
	);
};

export default function Index() {
	const { data, isLoading } = useQueryPosts();
	const [isModalOpen, setModalOpen] = useState<boolean>(false);
	const { register, handleSubmit } = useForm({ defaultValues });
	const { mutate: createPost } = useMutation(
		(data: CreatePostFormValues) => axios.post<Post>("http://15.220.241.25/post/", data).then((res) => res.data),
		{ onSuccess: () => setModalOpen(false) }
	);
	const onSubmit = handleSubmit((data) => createPost(data));

	return (
		<div className="flex h-full flex-col px-8">
			<div className="flex gap-x-4">
				<div className="font-semibold text-lg relative">
					Latest Posts
					<div className="h-0.5 bg-primary w-12"></div>
				</div>
				<button
					onClick={() => setModalOpen(true)}
					className="flex items-center border border-secondary border-opacity-50 rounded px-2 py-0.5 text-secondary text-sm"
				>
					Create Post
				</button>
			</div>
			<Modal title="Create Post" open={() => setModalOpen(true)} close={() => setModalOpen(false)} isOpen={isModalOpen}>
				<form onSubmit={onSubmit} className="flex flex-col gap-y-1.5">
					<input
						className="w-full outline-none border-gray-200 border rounded px-2 py-1 text-xs"
						placeholder="Title"
						{...register("title", { required: true })}
					/>
					<textarea
						className="w-full outline-none border-gray-200 border rounded px-2 py-1 text-xs"
						{...register("content", { required: true })}
						rows={3}
						placeholder="Content"
					/>
					<input
						className="w-full outline-none border-gray-200 border rounded px-2 py-1 text-xs"
						{...register("created_by", { required: true })}
						placeholder="Author Name"
					/>
					<div className="flex justify-end">
						<button
							type="submit"
							className="flex items-center border border-primary border-opacity-50 rounded px-2 py-0.5 text-primary text-sm"
						>
							Submit
						</button>
					</div>
				</form>
			</Modal>

			<div className="flex flex-col gap-y-1 mt-5">
				{!isLoading ? data?.slice(0, 5).map((post) => <PostItem key={post.id} post={post} />) : <Loading />}
			</div>
		</div>
	);
}
