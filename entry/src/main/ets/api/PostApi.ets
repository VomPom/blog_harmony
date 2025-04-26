import { Pages } from "../model/Page";
import { Post, PostSummaryList } from "../model/Post";
import { request } from "./baseApi";


export const loadPostPages = (): Promise<Pages> => request(`api/posts.json`)

export const loadPostSummaryList =
  (page: number): Promise<PostSummaryList> => request<PostSummaryList>(`api/posts/page.${page}.json`);

export const loadPostDetail = (path: string): Promise<Post> => request<Post>(path);
