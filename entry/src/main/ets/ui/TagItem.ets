import { VRouter } from "../componet/VRouter"
import { Tag } from "../model/Tag"

/**
 * Created by @juliswang on 2025/04/21 22:56
 *
 * @Description Tag UI
 */
@Preview
@Component
export default struct TagItem {
  data: Tag = new Tag()
  showCount: boolean = false

  build() {
    Row() {
      Image($r("app.media.ic_post_tag"))
        .width(15)
        .height(15)
      Text(this.data.name)
        .fontColor($r("app.color.text_content"))
        .fontSize(12)
        .padding({
          top: 2,
          bottom: 2
        })
      if (this.showCount) {
        Text(`(${this.data.count})`)
          .fontColor($r("app.color.text_content"))
          .fontSize(8)
          .padding({
            top: 2,
            bottom: 3
          })
      }
    }
    .padding({
      right: 5,
    })
    .alignItems(VerticalAlign.Bottom)
    .borderRadius(5)
    .backgroundColor($r("app.color.tag_bg"))
    .onClick(() => {
      VRouter.jumpTag(this.data)
    })
  }
}