import { loadPostPages, loadPostSummaryList } from "../../api/PostApi"
import { LoadState, PageLoading } from "../../ui/widget/PageLoading"
import { PullToRefresh } from '@ohos/pulltorefresh'
import { Post } from "../../model/Post";
import PostSummaryItem from "../../ui/PostSummaryItem";
import { log } from "../../componet/Log";
import Toolbar from "../../ui/widget/Toolbar";
import { VRouter } from "../../componet/VRouter";

/**
 * Created by @juliswang on 2025/04/21 22:26
 *
 * @Description
 */
@Preview
@Component
export default struct Blog {
  @State posts: Post[] = [];
  @State loadState: LoadState = LoadState.LOADING
  @State hasMore: boolean = true
  private maxPages: number = 0
  private currentPage: number = 1 // generate api index start from 1, not 0.
  private scroller: Scroller = new Scroller();
  showTabBarListener?: (showTabBar: boolean) => void

  aboutToAppear(): void {
    this.loadPostPages()
  }

  build() {
    Column() {
      Toolbar({ title: '博客文章', showBack: false })
      PageLoading({
        loadState: this.loadState,
        onReload: () => {
          log('on reload....')
        }
      }) {
        PullToRefresh({
          data: $posts,
          scroller: this.scroller,
          customList: () => {
            this.postList();
          },
          onRefresh: () => {
            return new Promise<string>((resolve, reject) => {
              this.loadPostPages()
            });
          },
          onLoadMore: () => {
            log('load more...')
            return new Promise<string>((resolve, reject) => {
              if (!this.hasMore) {
                resolve('no more...')
                return
              }
              loadPostSummaryList(++this.currentPage).then((postSummaryList) => {
                if (postSummaryList != null) {
                  this.posts = this.posts.concat(postSummaryList.posts)
                  resolve('success...');
                } else {
                  this.hasMore = false;
                  resolve('no more...')
                }
              })
            });
          }
        })
      }
    }
  }

  @Builder
  private postList() {
    List({ scroller: this.scroller }) {
      ForEach(this.posts, (item: Post) => {
        ListItem() {
          PostSummaryItem({ data: item })
            .onClick(() => {
              VRouter.jumpPost(item)
            })
        }
      })
    }
    .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
      if (this.loadState == LoadState.LOADING) {
        return
      }
      this.showTabBarListener?.(scrollOffset < 0)
    })
    .scrollBar(BarState.Off)
    .width('95%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .alignListItem(ListItemAlign.Center)
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }

  async loadPostPages() {
    this.posts.length = 0
    this.loadState = LoadState.LOADING
    loadPostPages().then((data) => {
      this.loadState = LoadState.SUCCESS
      this.maxPages = data.pages.length
      this.currentPage = 1
      this.hasMore = this.maxPages > this.currentPage
      loadPostSummaryList(this.currentPage).then((postSummaryList) => {
        if (postSummaryList != null) {
          this.posts = this.posts.concat(postSummaryList.posts)
        } else {
          this.hasMore = false;
        }
      })
    }).catch()
  }
}