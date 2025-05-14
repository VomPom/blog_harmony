import { router } from "@kit.ArkUI";
import { Category } from "../model/Category";
import { Post } from "../model/Post";
import { Tag } from "../model/Tag";
import { PostItemScene } from "../ui/PostSummaryItem";

export class VRouter {
  jump(url: string, params: object) {
    router.pushUrl({ url: url, params: params })
  }

  static jumpPost(data: Post) {
    router.pushUrl({ url: 'pages/post/PostDetail', params: { data: data } })
  }

  static jumpPostListByType(data: Tag | Category | Post[], scene: PostItemScene = PostItemScene.DEFAULT) {
    let obj = data as object
    let params: object = new Object({ scene: scene })
    if (obj['api']) {
      if (obj['api'].includes('api/tags')) {
        params['tag'] = data
      } else if (obj['api'].includes('api/categories')) {
        params['category'] = data
      }
    } else {
      params['posts'] = data
    }
    router.pushUrl({ url: "pages/post/PostTypeList", params: params })
  }

  static getParams(): Object {
    return router.getParams()
  }
}