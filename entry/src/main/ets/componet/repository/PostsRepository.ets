import { loadPostPages, loadPostSummaryList } from '../../api/PostApi';
import { Pages } from '../../model/Page';
import { PostSummaryList } from '../../model/Post';
import { BaseRepository, P } from './BaseRepository';

const KEY_PAGES = 'key_pages'
const KEY_PAGE_I = 'key_page'
const KEY_UPDATE_T = 'key_update_time'

/**
 * Created by @juliswang on 2025/04/26 11:10
 *
 * @Description 用于存储文章相关的数据
 */
export class PostsRepository extends BaseRepository {
  /**
   * 加载文章 pages
   * @returns
   */
  loadPostPages =
    (refresh: boolean = false): P<Pages> => this.requestDataWithoutParms<Pages>(KEY_PAGES, refresh, loadPostPages)
  /**
   * 获取对应page 的所有文章
   * @param page
   * @returns
   */
  loadPosts = (page: number, fresh: boolean = false): P<PostSummaryList> =>
  this.requestData<PostSummaryList, number>(`${KEY_PAGE_I}_${page}`, fresh, loadPostSummaryList, page)

  setUpdateTime() {
    const value = new Date().getTime()
    this.saveData<number>(KEY_UPDATE_T, value)
  }

  getUpdateTime = () => this.loadData<number>(KEY_UPDATE_T, 0)
}