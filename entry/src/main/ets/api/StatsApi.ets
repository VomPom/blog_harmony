import { Category } from "../model/Category";
import { Tag } from "../model/Tag";
import { request } from "./baseApi";
import { Post, PostSummaryList } from "../model/Post";
import { Pages } from "../model/Page";

export const loadTags = (): Promise<Tag[]> => request<Tag[]>(`api/tags.json`)

export const loadCategories = (): Promise<Category[]> => request<Category[]>(`api/categories.json`)

export const loadAllPost = (): Promise<Post[]> => request<Post[]>(`api/search.json`)

export const loadTagPage = (slug: string): Promise<Pages> => request<Pages>(`api/tags/${slug}.json`)

export const loadTagList = (api: string): Promise<PostSummaryList> => request<PostSummaryList>(`${api}`)

export const loadCategoryPage = (slug: string): Promise<Pages> => request<Pages>(`api/categories/${slug}.json`)

export const loadCategoryList = (api: string): Promise<PostSummaryList> => request<PostSummaryList>(`${api}`)