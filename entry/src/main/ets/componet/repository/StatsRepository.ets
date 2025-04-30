/**
 * Copyright (C) @2025 THL A29 Limited. All rights reserved.
 *
 * Created by @juliswang on 2025/04/26 11:10
 *
 * @Description
 */
import preferences from '@ohos.data.preferences';
import { loadPostPages } from '../../api/PostApi';
import { loadCategories, loadTags } from '../../api/StatsApi';
import { Category } from '../../model/Category';
import { Pages } from '../../model/Page';
import { Tag } from '../../model/Tag';
import { log } from '../Log';

const PREFERENCES_NAME = 'vm_stats'
const KEY_TAGS = 'key_tags'
const KEY_POSTS = 'key_posts'
const KEY_CATG = 'key_categories'

type P<T> = Promise<T>

export class StatsRepository {
  getTags = (isRefresh: boolean): P<Tag[]> => this.getData<Tag[]>(KEY_TAGS, isRefresh, loadTags)
  getCategories = (isRefresh: boolean): P<Category[]> => this.getData<Category[]>(KEY_CATG, isRefresh, loadCategories)
  getPostPage = (isRefresh: boolean): P<Pages> => this.getData<Pages>(KEY_POSTS, isRefresh, loadPostPages)

  private getData<T>(key: string, isRefresh: boolean, netMethod: () => P<T>): P<T> {
    return new Promise((resolve, reject) => {
      this.getPreferences().then((p) => {
        let saveData = p.getSync(key, "")
        if (saveData == "" || isRefresh) {
          if (isRefresh) {
            log('load data by force fresh.')
          }
          if (saveData == "") {
            log('load data by empty data.')
          }
          netMethod()
            .then(async (data) => {
              p.putSync(key, JSON.stringify(data))
              p.flushSync()
              resolve(data as T)
            })
            .catch(reject)
        } else {
          resolve(JSON.parse(saveData as string) as T)
        }
      })
        .catch(reject)
    })
  }

  getPreferences() {
    let context = getContext(this);
    return preferences.getPreferences(context, PREFERENCES_NAME)
  }
}