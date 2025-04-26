import { router } from "@kit.ArkUI";
import { Category } from "../model/Category";
import { Post } from "../model/Post";
import { Tag } from "../model/Tag";

export class VRouter {
  jump(url: string, params: object) {
    router.pushUrl({ url: url, params: params })
  }

  static jumpPost(data: Post) {
    router.pushUrl({ url: "pages/post/TagDetail", params: { data: data } })
  }

  static jumpTag(data: Tag | Category) {
    router.pushUrl({ url: "pages/post/TagCatgDetail", params: { data: data } })
  }
}