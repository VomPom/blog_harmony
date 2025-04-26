/**
 * Copyright (C) @2025 THL A29 Limited. All rights reserved.
 *
 * Created by @juliswang on 2025/04/26 11:10
 *
 * @Description
 */
import preferences from '@ohos.data.preferences';
import { loadTags } from '../../api/StatsApi';
import { Category } from '../../model/Category';
import { Pages } from '../../model/Page';
import { Tag } from '../../model/Tag';

const PREFERENCES_NAME = 'vm_stats'
const KEY_TAGS = 'key_tags'
const KEY_POSTS = 'key_posts'
const KEY_CATG = 'key_categories'

export class StatsRepository {
  getTags(): Promise<Tag[]> {
    return this.getData<Tag[]>(KEY_TAGS)
  }

  getCategories(): Promise<Category[]> {
    return this.getData<Category[]>(KEY_CATG)
  }

  getPosts(): Promise<Pages> {
    return this.getData<Pages>(KEY_POSTS)
  }

  private getData<T>(key: string): Promise<T> {
    return new Promise((resolve, reject) => {
      this.getPreferences().then((p) => {
        let saveData = p.getSync(key, "")
        if (saveData == "") {
          loadTags().then(async (data) => {
            p.put(key, data)
            p.flushSync()
            resolve(data as T)
          })
            .catch(reject)
        } else {
          resolve(JSON.parse(JSON.stringify(saveData)))
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