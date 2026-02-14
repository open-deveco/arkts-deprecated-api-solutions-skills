@Entry
@Component
struct SideBarContainerAPIDemo {
  @State currentBreakpoint: string = 'sm';

  build() {
    Column() {
      if (this.currentBreakpoint === 'lg' || this.currentBreakpoint === 'xl') {
        Row() {
          Column() {
            Text('侧边栏')
              .fontSize(20)
              .padding(20)
          }
          .width(200)
          .height('100%')
          .backgroundColor('#F5F5F5')

          Column() {
            Text('主内容区域')
              .fontSize(24)
          }
          .layoutWeight(1)
          .height('100%')
        }
      } else {
        Column() {
          Text('主内容区域')
            .fontSize(24)
        }
        .width('100%')
        .height('100%')
      }
    }
  }
}
