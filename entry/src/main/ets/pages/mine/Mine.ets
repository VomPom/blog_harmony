import { ContentWithBorder } from "../../ui/ContentWithBorder"
import Toolbar from "../../ui/widget/Toolbar"
import { bundleManager, common, ConfigurationConstant } from "@kit.AbilityKit"
import TimeUtils from "../../componet/utils/TimeUtils"
import { ToastUtils } from "../../componet/utils/ToastUtils"
import AppConfig from "../../componet/config/AppConfig"
import { ConfigRepository } from "../../componet/repository/ConfigRepository"
import { ColorModeManager } from "../../componet/ColorModeManager"

interface GeneratedObjectLiteralInterface_1 {
  "action": string;
  "entities": string[];
  "uri": string;
  "type": string;
}

@Preview
@Component
export default struct Mine {
  @State bundleInfo?: bundleManager.BundleInfo = undefined
  @StorageLink('isDarkTheme') isDarkTheme: boolean = false

  aboutToAppear(): void {
    bundleManager.getBundleInfoForSelf(0x00000000).then((data) => {
      this.bundleInfo = data
    })
    this.isDarkTheme = ConfigRepository.getInstance().isDark()
  }

  build() {
    Column() {
      Toolbar({ title: '我', showBack: false, showSub: false })
      this.Blog()
      this.Settings()
      this.About()
    }
    .width('95%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  Blog() {
    Row() {
      Image(AppConfig.AVATAR)
        .alt($r('app.media.bg_transparent'))
        .shadow({
          radius: 5,
          offsetY: 0,
          offsetX: 0,
          color: $r('app.color.avatar_shadow')
        })
        .borderRadius(999)
        .width(80)
        .height(80)
        .margin({
          left: 5,
          right: 10
        })
        .padding(2)
        .onClick(() => {
          this.jumpToWeb(AppConfig.BLOG_URL)
        })

      Column() {
        Text(AppConfig.BLOG_NAME)
          .fontSize(18)
          .fontColor($r("app.color.text_content"))
        Text(AppConfig.BLOG_DESC)
          .fontSize(12)
          .fontColor($r("app.color.title_desc"))
      }.alignItems(HorizontalAlign.Start)
    }.margin({
      bottom: 15
    })
  }

  @Builder
  Settings() {
    InfoPanel({ title: "设置" }) {
      SettingItem({
        title: '夜间模式',
        icon: $r('app.media.ic_theme')
      }) {
        Toggle({ type: ToggleType.Switch, isOn: this.isDarkTheme })
          .onChange((selected: boolean) => {
            this.isDarkTheme = selected
            ConfigRepository.getInstance().saveIsDark(selected)
            ColorModeManager.getInstance().toggle(selected)
          })
      }
    }
  }

  @Builder
  About() {
    InfoPanel({ title: "关于" }) {
      InfoItem({ title: '应用名称', data: $r('app.string.app_name') })
      InfoItem({ title: '应用版本', data: this.bundleInfo?.versionName })
      InfoItem({ title: '安装时间', data: TimeUtils.format2(this.bundleInfo?.installTime ?? 0) })
      InfoItem({ title: '更新时间', data: TimeUtils.format2(this.bundleInfo?.updateTime ?? 0) })
    }
  }

  async jumpToWeb(url: string) {
    let want: GeneratedObjectLiteralInterface_1 = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: url,
      type: "text/plain"
    }
    let context = getContext(this) as common.UIAbilityContext;
    await context.startAbility(want)
  }
}


@Component
struct SettingItem {
  @Prop title: string
  @Prop icon: Resource
  @BuilderParam content: () => void = this.empty

  @LocalBuilder
  empty(): void {
  };

  build() {
    Row() {
      Row() {
        Image(this.icon)
          .width(15)
          .height(15)
          .margin({
            right: 5
          })
        Text(this.title)
          .fontSize(15)
          .fontColor($r("app.color.text_content"))
      }

      this.content()
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
  }
}

@Component
struct InfoItem {
  @Prop title: string
  @Prop data: string | Resource

  build() {
    Row() {
      Text(this.title)
        .fontSize(15)
        .fontColor($r("app.color.text_content"))
      Text(this.data)
        .fontSize(13)
        .fontColor($r("app.color.text_content"))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .margin({
      bottom: 10
    })
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
        .fontColor($r('app.color.light_color'))
        .fontWeight(800)
        .fontSize(15)
        .margin({
          bottom: 10
        })
      Column() {
        this.content()
      }
      .alignItems(HorizontalAlign.Start)
      .margin({
        left: 5,
        bottom: 10
      })
    }
  }
}