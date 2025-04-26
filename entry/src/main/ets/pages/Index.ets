import OHPermission from '../componet/OHPermission'
import Blog from './post/PostList'
import Mine from './mine/Mine'
import Stats from './stats/Stats'

@Preview
@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State showTabBar: boolean = true
  private tabController: TabsController = new TabsController()
  @State isPermissionGrant: boolean = false

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
                // this.showTabBar = showTabBar
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
        Image(this.currentIndex === index ? `/images/main_page_index${index}_pre.png` :
          `/images/main_page_index${index}_nor.png`)
          .width(29.714)
          .height(26)
          .objectFit(ImageFit.Fill)
          .margin({ bottom: 3 })
      }
      .backgroundColor(Color.Transparent)
      .justifyContent(FlexAlign.Center)
      .width(42)
      .height(40)
    }
    .backgroundColor("#f4f4f4")
    .width("100%")
    .height("100%")
  }
}