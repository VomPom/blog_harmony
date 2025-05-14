import { Tag } from "../../model/Tag"
import { Category } from "../../model/Category"
import TagItem from "../../ui/TagItem"
import { Pages } from "../../model/Page"
import { ContentWithBorder } from "../../ui/ContentWithBorder"
import { ContentWithToolbar } from "../../ui/ContentPage"
import CategoryItem from "../../ui/CaregoryItem"
import { StatsRepository } from "../../componet/repository/StatsRepository"
import { log } from "../../componet/Log"
import { LoadState } from "../../ui/widget/PageLoading"
import { Post } from "../../model/Post"
import { calLetter, calLetters } from "../../componet/utils/StatsUtils"
import { VRouter } from "../../componet/VRouter"
import { PostItemScene } from "../../ui/PostSummaryItem"

/**
 * Created by @juliswang on 2025/04/21 22:36
 *
 * @Description 数据统计页面
 */
@Preview
@Component
export default struct Stats {
  @State tags: Tag[] = []
  @State categories: Category[] = []
  @State allPosts: Post[] = []
  @State postPage: Pages = new Pages()
  @State forceRefresh: boolean = false
  @State loadState: LoadState = LoadState.LOADING
  repository: StatsRepository = new StatsRepository()

  aboutToAppear(): void {
    this.loadData()
  }

  build() {
    ContentWithToolbar({
      title: '统计',
      showBack: false,
      subIconSrc: $r('app.media.ic_refresh',),
      onSubIconClick: () => {
        this.forceRefresh = true
        this.loadData()
      }
    }) {
      this.Summary()
      this.Category()
      this.Tags()
    }
  }

  @Builder
  Summary() {
    Row() {
      StatsLabel({
        count: this.postPage.count,
        state: this.loadState,
        label: "篇",
        click: () => {
          VRouter.jumpPostListByType(this.allPosts, PostItemScene.ALL_POST)
        }
      })

      StatsLabel({
        count: calLetters(this.allPosts), label: "字数", click: () => {
          let sortedData = this.allPosts.slice().sort((a: Post, b: Post) => calLetter(b) - calLetter(a))
          VRouter.jumpPostListByType(sortedData, PostItemScene.CHARACTER)
        }
      })
      StatsLabel({ count: this.categories.length, state: this.loadState, label: "分类" })
      StatsLabel({ count: this.tags.length, state: this.loadState, label: "标签" })
    }
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  Category() {
    ContentWithBorder() {
      this.Title('#分类')
      Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
        ForEach(this.categories.sort((a: Category, b: Category) => (b.count ?? 0) - (a.count ?? 0)),
          (item: Category) => {
            FlowItem() {
              CategoryItem({ data: item, contentSize: 15 })
                .margin({ right: 5, bottom: 10 })
            }
          })
      }
    }
  }

  @Builder
  Tags() {
    ContentWithBorder() {
      this.Title('#标签')
      Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
        ForEach(this.tags, (item: Tag) => {
          FlowItem() {
            TagItem({ data: item, showCount: true })
              .margin({ right: 5, bottom: 5 })
          }
        })
      }
    }
  }

  @Builder
  Title(title: string) {
    Text(title)
      .fontColor($r('app.color.light_color'))
      .fontSize(18)
      .fontWeight(500)
      .margin({ bottom: 10 })
  }

  loadData() {
    this.loadState = LoadState.LOADING
    this.repository.getTags(this.forceRefresh).then((data) => {
      this.tags = [...data]
      this.loadState = LoadState.SUCCESS
    }).catch((err: object) => {
      log(`[getTags] err, err:${err}`)
    })

    this.repository.getCategories(this.forceRefresh).then((data) => {
      this.categories = [...data]
      this.loadState = LoadState.SUCCESS
    }).catch((err: object) => {
      log(`[getCategories] err, err:${err}`)
    })

    this.repository.getPostPage(this.forceRefresh).then((data) => {
      this.postPage = data
      this.loadState = LoadState.SUCCESS
    }).catch((err: object) => {
      log(`[getPostsPage] err, err:${err}`)
    })

    this.repository.getAllPosts(this.forceRefresh).then((data) => {
      this.allPosts = data
      this.loadState = LoadState.SUCCESS
    }).catch((err: object) => {
      log(`[getPostsPage] err, err:${err}`)
    })
  }
}


@Component
struct StatsLabel {
  @Prop count: number
  @Prop label: string
  @Prop state: LoadState
  click: () => void = () => {
  }

  build() {
    Column() {
      Column() {
        if (this.state == LoadState.LOADING) {
          Image($r('app.media.ic_refresh'))
            .width(15)
            .height(15)
        } else {
          Text(this.count.toString())
            .fontColor($r("app.color.text_content"))
            .fontSize(15)
        }
      }
      .height(15)

      Text(this.label)
        .fontColor($r("app.color.title_desc"))
        .fontSize(12)
    }
    .layoutWeight(1)
    .margin({ bottom: 20 })
    .onClick(this.click)
  }
}