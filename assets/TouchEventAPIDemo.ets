@Entry
@Component
struct TouchEventAPIDemo {
  @State pressureInfo: string = '压力信息';
  @State tiltInfo: string = '倾斜信息';
  @State toolType: string = 'Unknown';

  build() {
    Column({ space: 20 }) {
      Text('TouchEvent API 演示')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)

      Text(`压力: ${this.pressureInfo}`)
        .fontSize(16)

      Text(`倾斜: ${this.tiltInfo}`)
        .fontSize(16)

      Text(`设备: ${this.toolType}`)
        .fontSize(16)
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}
