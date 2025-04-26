import { ToastUtils } from "../componet/utils/ToastUtils"
import Toolbar from "./widget/Toolbar"

@Component
export struct ContentWithToolbar {
  @BuilderParam content: () => void
  title: string = ''
  showBack: boolean = true
  showSub: boolean = true
  subIconSrc: string | PixelMap | Resource = $r("app.media.ic_toolbar_more")
  onSubIconClick: () => void = unDevTip

  build() {
    Column() {
      Toolbar({
        title: this.title,
        showBack: this.showBack,
        showSub: this.showSub,
        subIconSrc: this.subIconSrc,
        onSubIconClick: this.onSubIconClick
      })
      this.content()
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r("app.color.page_bg"))
    .align(Alignment.Top)
    .height('100%')
    .width('95%')
  }
}

const unDevTip = () => {
  ToastUtils.show("功能正在开发中...")
}