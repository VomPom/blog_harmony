import { Tag } from '../../model/Tag'
import { router } from '@kit.ArkUI'
import Toolbar from '../../ui/widget/Toolbar'
import { loadCategoryList, loadCategoryPage, loadTagList, loadTagPage } from '../../api/StatsApi'
import { Post, PostSummaryList } from '../../model/Post'
import PostSummaryItem from '../../ui/PostSummaryItem'
import { LoadState, PageLoading } from '../../ui/widget/PageLoading'
import { Category } from '../../model/Category'
import { ToastUtils } from '../../componet/utils/ToastUtils'
import { Page } from '../../model/Page'

/**
 * Created by @juliswang on 2025/04/23 21:26
 *
 * @Description 展示对应 Tag 或者分类目录文章
 */
@Preview
@Entry
@Component
struct TagCatgDetail {
  @State data: Tag | Category = new Tag()
  @State posts: Post[] = [];
  @State loadState: LoadState = LoadState.LOADING
  scroller: Scroller = new Scroller();

  async aboutToAppear() {
    // todo:: make a custom router with params transit.
    this.data = (router.getParams() as object)['data'] as Tag
    this.loadTagPages()
  }

  build() {
    Column() {
      Toolbar({ title: this.data.name })
      PageLoading({
        loadState: this.loadState,
        onReload: () => {
          this.loadTagPages()
        }
      }) {
        this.PostList()
      }
    }
    .backgroundColor($r("app.color.page_bg"))
  }

  @Builder
  private PostList() {
    List({ scroller: this.scroller }) {
      ForEach(this.posts, (item: Post) => {
        ListItem() {
          PostSummaryItem({ data: item })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/post/PostDetail',
                params: { data: item }
              })
            })
        }
      })
    }
    .scrollBar(BarState.Off)
    .width('95%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .alignListItem(ListItemAlign.Center)
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }

  async loadTagPages() {
    if (this.isTag()) {
      loadTagPage(this.data.slug)
        .then((data) => {
          this.loadPages(data.pages, loadTagList)
        })
    } else if (this.isCategory()) {
      loadCategoryPage(this.data.slug)
        .then((data) => {
          this.loadPages(data.pages, loadCategoryList)
        })
    } else {
      ToastUtils.show(`unknown type api:${this.data.api}`)
    }
  }

  /**
   * 根据下发的 Page 请求不同的数据
   * @param pages
   * @param request   请求能力
   */
  loadPages(pages: Page[], request: (data: string) => Promise<PostSummaryList>) {
    pages.forEach((page) => {
      request(page.api).then((data) => {
        if (this.loadState == LoadState.LOADING) {
          this.loadState = LoadState.SUCCESS
        }
        this.posts = this.posts.concat(data.posts)
      })
    })
  }

  isTag = () => this.data.api.includes('api/tags')
  isCategory = () => this.data.api.includes('api/categories')
}