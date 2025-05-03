import { Post } from "../../model/Post";
import Toolbar from "../../ui/widget/Toolbar";
import router from "@ohos.router";
import { loadPostDetail } from "../../api/PostApi";
import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';
import { webview } from "@kit.ArkWeb";

/**
 * Created by @juliswang on 2025/04/21 22:26
 *
 * @Description 文章内容详情页面  todo:: better ui show content.
 */
@Preview
@Entry
@Component
struct PostDetail {
  @State post: Post = {
    "title": "Android屏幕刷新机制",
    "slug": "Android屏幕刷新机制",
    "date": "2025-02-24T02:49:00.000Z",
    "updated": "2025-04-02T08:49:45.597Z",
    "comments": true,
    "url": "2025/02/24/Android屏幕刷新机制/",
    "excerpt": "",
    "cover": null,
    "images": [],
    "categories": [{
      "name": "技术文章",
      "slug": "technology",
      "api": "api/categories/technology.json"
    }
    ],
    "tags": [
      {
        "name": "安卓",
        "slug": "Android",
        "api": "api/tags/Android.json"
      }
    ],
    "api": "api/posts/2025/02/24/Android屏幕刷新机制.json",
  }
  private postSummary: Post = this.post
  private webController: webview.WebviewController = new webview.WebviewController();
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  async aboutToAppear() {
    // todo:: make a custom router with params transit.
    this.postSummary = (router.getParams() as object)['data'] as Post
  }

  build() {
    Column() {
      Toolbar({ title: this.postSummary.title })
      // todo:: optimize content

      Web({ src: '', controller: this.webController })
        .onControllerAttached(() => {
          this.webController.loadData(this.postSummary.content, 'text/html', "UTF-8", 'about:blank',
            'about:blank')
        })
        .width('100%')
        .height('100%')
        .zoomAccess(false)
        .nestedScroll({
          scrollForward: NestedScrollMode.SELF_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
        .layoutMode(WebLayoutMode.FIT_CONTENT)
    }
  }
}