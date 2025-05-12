import Toolbar from "../../ui/widget/Toolbar";
import { Post } from "../../model/Post";
import { webview } from "@kit.ArkWeb";
import { RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';
import { LoadState } from "../../ui/widget/PageLoading";
import AppConfig from "../../componet/config/AppConfig";
import { VRouter } from "../../componet/VRouter";

/**
 * Created by @juliswang on 2025/04/21 22:26
 *
 * @Description 文章内容详情页面
 *
 * todo:: 目前直接使用的文章对应的 url 再进行一次加载，实际可以使用传过来的 html content 直接进行渲染，
 * 不过web 控件渲染出来的样式并不是特别好看，需要优化一波
 *
 *
 */
@Preview
@Entry
@Component
struct PostDetail {
  @State loadState: LoadState = LoadState.LOADING
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
    this.postSummary = (VRouter.getParams() as object)['data'] as Post
  }

  build() {
    Column() {
      Toolbar({ title: this.postSummary.title })
      Stack() {
        Web({ src: '', controller: this.webController })
          .onControllerAttached(() => {
            // todo:: use html content to render without net url load.
            // 下面这种方式能够加载文本化内容，但是样式并不是特别好，需要再处理
            // this.webController.loadData(this.postSummary.content, 'text/html', "UTF-8", 'about:blank', 'about:blank')
            this.webController.loadUrl(AppConfig.BLOG_URL + '/' + this.postSummary.url)
          })
          .onPageBegin(() => {
            this.loadState = LoadState.LOADING
          })
          .onPageVisible(() => {
            this.loadState = LoadState.SUCCESS
          })
          .width('100%')
          .height('100%')
          .zoomAccess(false)
          .nestedScroll({
            scrollForward: NestedScrollMode.SELF_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
          .layoutMode(WebLayoutMode.NONE)
        if (this.loadState == LoadState.LOADING) {
          LoadingProgress()
            .width(50)
            .height(50)
            .color($r("app.color.main"))
        }
      }
    }
  }
}