import { Category } from "./Category";
import { Tag } from "./Tag";

export class Post {
  title: string = '';
  slug: string = '';
  date: string = '';
  updated: string = '';
  comments: boolean = false;
  url: string = '';
  excerpt: string = '';
  content?: string | undefined = '';
  cover?: string | null = '';
  images: string[] = [];
  categories: Category[] = [];
  tags: Tag[] = [];
  api: string = '';
}

export class Info {
  type: string = '';
}

export class PostSummaryList {
  index: number = 0;
  total: number = 0;
  posts: Post[] = [];
  info: Info = new Info();
}