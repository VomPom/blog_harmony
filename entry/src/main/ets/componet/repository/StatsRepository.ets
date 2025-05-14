/**
 * Created by @juliswang on 2025/04/26 11:10
 *
 * @Description
 */
import { loadPostPages } from '../../api/PostApi';
import { loadAllPost, loadCategories, loadTags } from '../../api/StatsApi';
import { Category } from '../../model/Category';
import { Pages } from '../../model/Page';
import { Post } from '../../model/Post';
import { Tag } from '../../model/Tag';
import { BaseRepository } from './BaseRepository';

const KEY_TAGS = 'key_tags'
const KEY_POSTS = 'key_post_pages'
const KEY_ALL_POSTS = 'key_all_posts'
const KEY_CATG = 'key_categories'

type P<T> = Promise<T>

export class StatsRepository extends BaseRepository {
  getTags =
    (refresh: boolean): P<Tag[]> => this.requestDataWithoutParms<Tag[]>(KEY_TAGS, refresh, loadTags)
  getPostPage =
    (refresh: boolean): P<Pages> => this.requestDataWithoutParms<Pages>(KEY_POSTS, refresh, loadPostPages)
  getCategories =
    (refresh: boolean): P<Category[]> => this.requestDataWithoutParms<Category[]>(KEY_CATG, refresh, loadCategories)
  getAllPosts =
    (refresh: boolean): P<Post[]> => this.requestDataWithoutParms<Post[]>(KEY_ALL_POSTS, refresh, loadAllPost)

}