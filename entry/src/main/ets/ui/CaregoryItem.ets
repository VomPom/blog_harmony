import { VRouter } from "../componet/VRouter"
import { Category } from "../model/Category"
import { PostItemScene } from "./PostSummaryItem"

/**
 * Created by @juliswang on 2025/04/21 22:26
 *
 * @Description 目录 item 样式
 */
@Preview
@Component
export default struct CategoryItem {
  data: Category = new Category()
  contentSize: number = 12

  build() {
    Row() {
      Image($r("app.media.ic_folder"))
        .padding({
          left: 5,
          right: 2
        })
        .width(this.contentSize * 1.2)
      Text(this.data.name)
        .fontColor($r("app.color.text_content"))
        .fontSize(this.contentSize)
      if (this.data.count) {
        Text(`(${this.data.count.toString()})`)
          .fontColor($r("app.color.text_content"))
          .fontSize(10)
      }
    }.onClick(() => {
      VRouter.jumpPostListByType(this.data)
    })
  }
}
