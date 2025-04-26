import { loadCategories, loadTags } from "../../api/StatsApi"
import { Tag } from "../../model/Tag"
import { Category } from "../../model/Category"
import TagItem from "../../ui/TagItem"
import { loadPostPages } from "../../api/PostApi"
import { Pages } from "../../model/Page"
import { ContentWithBorder } from "../../ui/ContentWithBorder"
import { ContentWithToolbar } from "../../ui/ContentPage"
import CategoryItem from "../../ui/CaregoryItem"
import { StatsRepository } from "../../componet/repository/StatsRepository"
import { ToastUtils } from "../../componet/utils/ToastUtils"

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
  @State postPage: Pages = new Pages()
  repository: StatsRepository = new StatsRepository()

  aboutToAppear(): void {
    this.repository.getTags().then((data) => {
      this.tags = this.tags.concat(data)
    }).catch((err: object) => {
      ToastUtils.show("d")
    })

    this.repository.getCategories().then((data) => {
      this.categories = this.categories.concat(data)
    }).catch((err: object) => {
      ToastUtils.show("d")
    })

    this.repository.getPosts().then((data) => {
      this.postPage = data
    }).catch((err: object) => {
      ToastUtils.show("d")
    })

  }

  build() {
    ContentWithToolbar({
      title: '统计',
      showBack: false,
      subIconSrc: $r('app.media.ic_refresh',),
      onSubIconClick: () => {

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
      StatsLabel({ count: this.postPage.count, label: "篇" })
      // StatsLabel({ count: calLetters(this.allPost), label: "字数" })
      StatsLabel({ count: this.categories.length, label: "分类" })
      StatsLabel({ count: this.tags.length, label: "标签" })
    }
    .justifyContent(FlexAlign.SpaceBetween)
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
      .fontColor($r('app.color.title_text'))
      .fontSize(18)
      .fontWeight(500)
      .margin({ bottom: 10 })
  }

  loadData(useNet: boolean) {
    if (useNet) {
      loadTags().then((data) => {
        this.tags = this.tags.concat(data)
      })
      loadCategories().then((data) => {
        this.categories = this.categories.concat(data)
      })
      loadPostPages().then((data) => {
        this.postPage = data
      })
    } else {

    }
  }
}


@Component
struct StatsLabel {
  @Prop count: number
  @Prop label: string

  build() {
    Column() {
      Text(this.count.toString())
        .fontColor($r('app.color.post_text'))
        .fontSize(15)
      Text(this.label)
        .fontColor($r('app.color.post_desc'))
        .fontSize(12)
    }
    .layoutWeight(1)
    .margin({ bottom: 20 })
  }
}