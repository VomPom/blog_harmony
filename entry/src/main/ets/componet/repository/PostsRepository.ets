import { loadPostPages, loadPostSummaryList } from '../../api/PostApi';
import { Pages } from '../../model/Page';
import { PostSummaryList } from '../../model/Post';
import { BaseRepository, P } from './BaseRepository';

const PREFERENCES_NAME = 'vm_posts'
const KEY_PAGES = 'key_pages'
const KEY_PAGE_I = 'key_page'

/**
 * Copyright (C) @2025 THL A29 Limited. All rights reserved.
 *
 * Created by @juliswang on 2025/04/26 11:10
 *
 * @Description 用于存储文章相关的数据
 */
export class PostsRepository extends BaseRepository {
  /**
   * 加载文章 pages
   * @returns
   */
  loadPostPages(): P<Pages> {
    return new Promise((resolve, reject) => {
      this.requestData<Pages, void>(KEY_PAGES, false, loadPostPages, undefined).then((data) => {
        resolve(data)
      }).catch(reject)
    })
  }

  /**
   * 获取对应page 的所有文章
   * @param page
   * @returns
   */
  loadPosts(page: number): P<PostSummaryList> {
    return new Promise((resolve, reject) => {
      const saveKey = `${KEY_PAGE_I}_${page}`
      this.requestData<PostSummaryList, number>(saveKey, false, loadPostSummaryList, page).then((data) => {
        resolve(data)
      }).catch(reject)
    })
  }


  preferencesName(): string {
    return PREFERENCES_NAME
  }
}