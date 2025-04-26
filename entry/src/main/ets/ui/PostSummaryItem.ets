import TimeUtils from "../componet/utils/TimeUtils";

import { Post } from "../model/Post";
import { Tag } from "../model/Tag";
import { Category } from "../model/Category";
import TagItem from "./TagItem";
import CategoryItem from "./CaregoryItem";

/**
 * Created by @juliswang on 2025/04/21 22:25
 *
 * @Description 内容简要
 */
@Preview
@Component
export default struct PostSummaryItem {
  data: Post = new Post()

  build() {
    Stack() {
      Column() {
        Text(this.data.title)
          .fontSize(15)
          .fontWeight(500)
          .fontColor($r('app.color.post_text'))
          .margin({
            top: 3
          })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank().height(3)
        this.TimeAndCategories()
        Blank().height(5)
        this.Tags()
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(5)
    .margin({ bottom: 10 })
    .borderColor(Color.Gray)
    .borderRadius(5)
    .backgroundColor($r("app.color.content_bg"))
    .alignContent(Alignment.Start)
  }

  @Builder
  TimeAndCategories() {
    Row() {
      Text(TimeUtils.format1(this.data.date))
        .fontSize(12)
        .fontWeight(500)
        .fontColor($r("app.color.post_time"))

      Column() {
        ForEach(this.data.categories, (category: Category) => {
          CategoryItem({ data: category })
        })
      }
    }
  }

  @Builder
  Tags() {
    Row() {
      ForEach(this.data.tags, (tag: Tag) => {
        TagItem({ data: tag })
          .margin({ right: 5 })
      })
    }.margin({
      bottom: 5
    })
  }
}