import OHPermission from '../componet/OHPermission'
import Blog from './post/PostList'
import Mine from './mine/Mine'
import Stats from './stats/Stats'
import WindowManager from '../componet/WindowManager'

@Preview
@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State showTabBar: boolean = true
  private tabController: TabsController = new TabsController()
  @State isPermissionGrant: boolean = false
  @StorageLink('isDarkTheme') isDarkTheme: boolean = false

  aboutToAppear(): void {
    OHPermission.requestPermission(getContext(this), ['ohos.permission.INTERNET'])
      .then((v) => {
        this.isPermissionGrant = true;
      })
      .catch(() => {
        this.isPermissionGrant = false;
      })
  }

  build() {
    Column() {
      if (this.isPermissionGrant) {
        Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
          TabContent() {
            Blog({
              showTabBarListener: (showTabBar: boolean) => {
                this.showTabBar = showTabBar
              }
            })
          }
          .tabBar(this.createTabMenu(0))

          TabContent() {
            Stats()
          }
          .tabBar(this.createTabMenu(1))

          TabContent() {
            Mine()
          }
          .tabBar(this.createTabMenu(2))
        }
        .width("100%")
        .height("100%")
        .layoutWeight(1)
        .barHeight(this.showTabBar ? 50 : 0)
        .padding({ bottom: WindowManager.navBarHeight })
        .backgroundColor($r("app.color.page_bg"))
        .vertical(false)
        .onChange((index: number) => {
          this.currentIndex = index
        })
      } else {
        Text("无网络请求权限")
          .width('100%')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
    }
  }

  @Builder
  createTabMenu(index: number) {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Image(this.gotIcon(this.currentIndex === index, index))
          .width(30)
          .height(26)
          .objectFit(ImageFit.Fill)
          .margin({ bottom: 3 })
      }
      .backgroundColor(Color.Transparent)
      .justifyContent(FlexAlign.Center)
      .width(42)
      .height(40)
    }
    .backgroundColor($r('app.color.tab_bg'))
    .width("100%")
    .height("100%")
  }

  private gotIcon(isSelected: boolean, index: number): Resource {
    const darkRes = $r(`app.media.ic_tab_${index + 1}_dark`)
    const lightRes = $r(`app.media.ic_tab_${index + 1}_light`)
    let result: Resource
    if (isSelected) {
      result = this.isDarkTheme ? lightRes : darkRes
    } else {
      result = this.isDarkTheme ? darkRes : lightRes
    }
    return result
  }
}