import { ContentWithBorder } from "../../ui/ContentWithBorder"
import Toolbar from "../../ui/widget/Toolbar"
import { bundleManager, common } from "@kit.AbilityKit"
import TimeUtils from "../../componet/utils/TimeUtils"
import { ToastUtils } from "../../componet/utils/ToastUtils"

interface GeneratedObjectLiteralInterface_1 {
  // uncomment line below if wish to implicitly query only in the specific bundle.
  // bundleName: "com.example.myapplication",
  "action": string;

  // entities can be omitted.
  "entities": string[];
  "uri": string;
  "type": string;
}

@Preview
@Component
export default struct Mine {
  @State bundleInfo?: bundleManager.BundleInfo = undefined

  aboutToAppear(): void {
    bundleManager.getBundleInfoForSelf(0x00000000).then((data) => {
      this.bundleInfo = data
    })
  }

  build() {
    Column() {
      Toolbar({ title: '我', showBack: false })
      this.Settings()
      this.About()
    }
    .width('95%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r("app.color.page_bg"))
  }

  @Builder
  Settings() {
    InfoPanel({ title: "设置" }) {
      SettingItem({
        title: '夜间模式'
      }) {
        Toggle({ type: ToggleType.Switch, isOn: true })
          .onChange((value: boolean) => {
            ToastUtils.show("切换夜间模式：" + value)
          })
      }
    }
  }

  @Builder
  About() {
    InfoPanel({ title: "关于" }) {
      InfoItem({ title: '应用名称', data: this.bundleInfo?.name })
      InfoItem({ title: '应用版本', data: this.bundleInfo?.vendor })
      InfoItem({ title: '应用版本', data: this.bundleInfo?.versionName })
      InfoItem({ title: '首次安装时间', data: TimeUtils.format2(this.bundleInfo?.installTime ?? 0) })
      InfoItem({ title: '应用更新时间', data: TimeUtils.format2(this.bundleInfo?.updateTime ?? 0) })
      Button('Github')
        .onClick(async () => {
          await this.jumpToWeb()
        })
        .width(65)
        .height(30)
        .margin({ top: 5 })
        .backgroundColor("#b99f9f9f")
    }
  }

  async jumpToWeb() {
    let want: GeneratedObjectLiteralInterface_1 = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: 'https://www.github.com/vompom',
      type: "text/plain"
    }
    let context = getContext(this) as common.UIAbilityContext;
    await context.startAbility(want)
  }
}


@Component
struct SettingItem {
  @Prop title: string
  @BuilderParam content: () => void = this.empty

  @LocalBuilder
  empty(): void {
  };

  build() {
    Row() {
      Text(this.title)
        .fontSize(15)
        .fontColor($r('app.color.post_text'))
      this.content()
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
  }
}

@Component
struct InfoItem {
  @Prop title: string
  @Prop data: string

  build() {
    Row() {
      Text(this.title)
        .fontSize(15)
        .fontColor($r('app.color.post_text'))
      Text(this.data)
        .fontSize(13)
        .fontColor($r('app.color.post_text'))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
  }
}


@Component
struct InfoPanel {
  @Prop title: string
  @BuilderParam content: () => void = this.empty

  @LocalBuilder
  empty(): void {
  };

  build() {
    ContentWithBorder() {
      Text(this.title)
        .fontColor($r('app.color.title_text'))
        .fontSize(15)
        .margin({
          bottom: 5
        })
      Column() {
        this.content()
      }
      .alignItems(HorizontalAlign.Start)
      .margin({
        left: 5,
        bottom: 5
      })
    }
  }
}