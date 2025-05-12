import router from '@ohos.router'
import { ToastUtils } from '../../componet/utils/ToastUtils'
import WindowManager from '../../componet/WindowManager'

@Preview
@Component
export default struct Toolbar {
  @Prop title: string = ''
  showBack: boolean = true
  showSub: boolean = true
  subIconSrc: string | PixelMap | Resource = $r("app.media.ic_toolbar_more")
  onSubIconClick: () => void = unDevTip
  private backSrc: string | PixelMap | Resource = $r("app.media.ic_toolbar_back")
  private subTitle: string = "更多"

  build() {
    Column() {
      Row() {
        if (this.showBack) {
          Image(this.backSrc)
            .width(22)
            .height(22)
            .margin({ left: 15 })
            .onClick(() => {
              router.back()
            })
        }
        Text(this.title)
          .fontColor($r("app.color.title_text"))
          .fontSize(15)
          .margin({ left: 15 })
          .maxLines(1)
          .ellipsisMode(EllipsisMode.END)
          .fontWeight(500)

        if (this.showSub) {
          if (this.subIconSrc === null) {
            Text(this.subTitle)
              .fontColor(Color.Black)
              .fontSize(16)
              .margin({ right: 15 })
              .fontWeight(400)
              .onClick(this.onSubIconClick)
          } else {
            Image(this.subIconSrc)
              .width(25)
              .height(25)
              .margin({ right: 15 })
              .onClick(this.onSubIconClick)
          }
        }
      }
      .height(53)
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .zIndex(999)
    .padding({ top: WindowManager.statusBarHeight })
  }
}

const unDevTip = () => {
  ToastUtils.show("功能正在开发中...")
}