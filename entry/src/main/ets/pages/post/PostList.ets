import { LoadState, PageLoading } from "../../ui/widget/PageLoading"
import { PullToRefresh, PullToRefreshV2 } from '@ohos/pulltorefresh'
import { Post } from "../../model/Post";
import PostSummaryItem from "../../ui/PostSummaryItem";
import { log } from "../../componet/Log";
import Toolbar from "../../ui/widget/Toolbar";
import { VRouter } from "../../componet/VRouter";
import { PostsRepository } from "../../componet/repository/PostsRepository";
import { BusinessError } from "@kit.BasicServicesKit";
import { ToastUtils } from "../../componet/utils/ToastUtils";
import TimeUtils from "../../componet/utils/TimeUtils";

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
  @State title: string = '博客文章'
  private maxPages: number = 0
  private currentPage: number = 1 // generate api index start from 1, not 0.
  private scroller: Scroller = new Scroller();
  private repository: PostsRepository = new PostsRepository()

  aboutToAppear(): void {
    this.loadPostPages()
    this.updateTitle()
  }

  build() {
    Column() {
      Toolbar({ title: this.title, showBack: false })
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
            this.repository.setUpdateTime()
            this.updateTitle()
            return this.loadPostPages(true);
          },
          onLoadMore: () => {
            log('load more...')
            return new Promise<string>((resolve, reject) => {
              if (!this.hasMore) {
                resolve('no more...')
                return
              }
              this.repository.loadPosts(++this.currentPage).then((postSummaryList) => {
                if (postSummaryList != null) {
                  this.posts = this.posts.concat(postSummaryList.posts)
                  resolve('success...');
                } else {
                  this.hasMore = false;
                  resolve('no more...')
                }
              }).catch((e: BusinessError) => {
                this.hasMore = false;
                resolve('no more data...' + e.message)
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
      ForEach(this.posts, (item: Post, index: number) => {
        ListItem() {
          PostSummaryItem({ data: item, index: index + 1 })
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

  loadPostPages(forceUpdate: boolean = false): Promise<string> {
    return new Promise((resolve, reject) => {
      this.posts.length = 0
      this.loadState = LoadState.LOADING
      this.repository.loadPostPages(forceUpdate).then((data) => {
        this.maxPages = data.pages.length
        this.currentPage = 1
        this.hasMore = this.maxPages > this.currentPage
        this.repository.loadPosts(this.currentPage, forceUpdate)
          .then((postSummaryList) => {
            resolve('刷新成功')
            this.loadState = LoadState.SUCCESS
            if (postSummaryList != null) {
              this.posts = this.posts.concat(postSummaryList.posts)
            } else {
              this.hasMore = false;
            }
          })
          .catch((e: BusinessError) => {
            ToastUtils.show(e.message)
            reject(e)
          })
      }).catch((e: BusinessError) => {
        ToastUtils.show(e.message)
        reject(e)
      })
    })
  }

  updateTitle() {
    this.title = `博客文章(${TimeUtils.calTimeDifference(this.repository.getUpdateTime())}更新)`
  }
}