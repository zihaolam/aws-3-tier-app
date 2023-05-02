export interface Post {
	id: number;
	content: string;
	"@@hostname"?: string;
	backend_ip?: string;
	created_by: string;
	title: string;
}
