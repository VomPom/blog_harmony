/**
 * Created by @juliswang on 2025/04/21 22:16
 *
 * @Description 内容 item 容器
 */
@Component
export struct ContentWithBorder {
  borderSize: number = 5
  @BuilderParam content: () => void

  build() {
    Column() {
      this.content()
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r("app.color.content_bg"))
    .margin({ bottom: 10 })
    .padding({ top: 5, left: 5 })
    .width('100%')
    .padding(5)
    .borderColor(Color.Gray)
    .borderRadius(this.borderSize)
  }
}