import { display } from '@kit.ArkUI';

interface CreaseRect {
  width: number;
  height: number;
  top: number;
  left: number;
}

@Entry
@Component
struct CreaseRegionExample {
  @State creaseArea: CreaseRect | null = null;
  @State isCreaseVisible: boolean = false;

  aboutToAppear() {
    this.getCreaseRegion();
    display.on('foldStatusChange', () => {
      this.getCreaseRegion();
    });
  }

  getCreaseRegion() {
    let isFoldable = display.isFoldable();
    if (!isFoldable) {
      this.creaseArea = null;
      return;
    }

    let creaseRegion = display.getCurrentFoldCreaseRegion();
    if (creaseRegion && creaseRegion.creaseRects && creaseRegion.creaseRects.length > 0) {
      let rect = creaseRegion.creaseRects[0];
      this.creaseArea = {
        width: rect.width,
        height: rect.height,
        top: rect.top,
        left: rect.left
      };
      this.isCreaseVisible = true;
    } else {
      this.creaseArea = null;
      this.isCreaseVisible = false;
    }
  }

  build() {
    Column() {
      Text('折痕区域示例')
        .fontSize(24)
        .margin({ bottom: 20 })

      if (this.creaseArea) {
        Text(`折痕区域: ${this.creaseArea.width}x${this.creaseArea.height}`)
        Text(`位置: x=${this.creaseArea.left}, y=${this.creaseArea.top}`)
      } else {
        Text('当前无折痕区域')
      }
    }
    .width('100%')
    .padding(20)
  }
}
