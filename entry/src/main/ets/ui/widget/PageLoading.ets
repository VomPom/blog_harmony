export enum LoadState {
  LOADING,
  SUCCESS,
  FAIL,
  EMPTY
}

@Component
export struct PageLoading {
  @Prop loadState: LoadState;
  onReload?: () => void;
  @BuilderParam content: () => void;

  build() {
    Stack() {
      if (this.loadState === LoadState.LOADING) {
        LoadingProgress()
          .width(50)
          .height(50)
          .color($r("app.color.main"))
      } else if (this.loadState === LoadState.SUCCESS) {
        this.content();
      } else if (this.loadState === LoadState.FAIL) {
        Stack() {
          Text("加载失败，点击重试")
        }
        .width('100%')
        .height('100%')
        .onClick(() => {
          if (this.onReload) {
            this.onReload();
          }
        })
      } else {
        Stack() {
          Text("这里什么都没有")
        }
        .width('100%')
        .height('100%')
        .onClick(() => {
          if (this.onReload) {
            this.onReload();
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
