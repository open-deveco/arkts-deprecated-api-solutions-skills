import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

class WindowManager {
  private windowClass: window.Window | null = null;

  async init(context: common.UIAbilityContext) {
    this.windowClass = await window.getLastWindow(context);

    this.windowClass.on('windowSizeChange', () => {
      console.log('Window size changed');
    });
  }
}

@Entry
@Component
struct GetContextReplacement {
  private windowManager: WindowManager = new WindowManager();

  async aboutToAppear() {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await this.windowManager.init(context);
  }

  build() {
    Column() {
      Text('GetContext 替代方案示例')
        .fontSize(24)
    }
    .width('100%')
    .height('100%')
  }
}
