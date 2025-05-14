import { Tag } from '../../model/Tag'
import { router } from '@kit.ArkUI'
import Toolbar from '../../ui/widget/Toolbar'
import { loadCategoryList, loadCategoryPage, loadTagList, loadTagPage } from '../../api/StatsApi'
import { Post, PostSummaryList } from '../../model/Post'
import PostSummaryItem, { PostItemScene } from '../../ui/PostSummaryItem'
import { LoadState, PageLoading } from '../../ui/widget/PageLoading'
import { Category } from '../../model/Category'
import { Page } from '../../model/Page'
import { VRouter } from '../../componet/VRouter'

/**
 * Created by @juliswang on 2025/04/23 21:26
 *
 * @Description 展示对应 Tag 或者分类目录文章
 */
@Preview
@Entry
@Component
struct PostTypeList {
  @State tag: Tag = new Tag()
  @State category: Category = new Category()
  @State posts: Post[] = []
  @State scene: PostItemScene = PostItemScene.ALL_POST
  @State _posts: Post[] = [];
  @State _title: string = ''
  @State _loadState: LoadState = LoadState.LOADING
  scroller: Scroller = new Scroller();

  async aboutToAppear() {

    this.tag = (router.getParams() as object)['tag'] as Tag
    this.posts = (router.getParams() as object)['posts'] as Post[]
    this.scene = (router.getParams() as object)['scene'] as PostItemScene
    this.category = (router.getParams() as object)['category'] as Category
    this.loadTagPages()
    this.updateTitle()
  }

  build() {
    Column() {
      Toolbar({ title: this._title })
      PageLoading({
        loadState: this._loadState,
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
      ForEach(this._posts, (item: Post, index: number) => {
        ListItem() {
          PostSummaryItem({ data: item, index: index + 1, scene: this.scene })
            .onClick(() => {
              VRouter.jumpPost(item)
            })
        }
      })
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .alignListItem(ListItemAlign.Center)
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }

  async loadTagPages() {
    if (this.tag) {
      loadTagPage(this.tag.slug)
        .then((data) => {
          this.loadPages(data.pages, loadTagList)
        })
    } else if (this.category) {
      loadCategoryPage(this.category.slug)
        .then((data) => {
          this.loadPages(data.pages, loadCategoryList)
        })
    } else {
      this._posts = this.posts
      this._loadState = LoadState.SUCCESS
    }
  }

  updateTitle() {
    if (this.tag) {
      this._title = (this.tag).name
    } else if (this.category) {
      this._title = (this.category).name
    } else {
      if (this.scene === PostItemScene.ALL_POST) {
        this._title = '所有文章'
      } else if (this.scene === PostItemScene.CHARACTER) {
        this._title = '字数统计'
      }
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
        if (this._loadState == LoadState.LOADING) {
          this._loadState = LoadState.SUCCESS
        }
        this._posts = this._posts.concat(data.posts)
      })
    })
  }
}