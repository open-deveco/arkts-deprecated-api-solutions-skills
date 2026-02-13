# Configuration densityDpi 属性弃用迁移指南

## 弃用说明

`Configuration.densityDpi` 属性在较新的 HarmonyOS 版本中已被移除。该属性用于获取屏幕密度，现在应该使用其他方式获取屏幕信息。

## 错误示例

```typescript
const config = this.getUIContext().getHostContext().config;
const densityDpi = config.densityDpi;
```

**错误信息：**
```
Property 'densityDpi' does not exist on type 'Configuration'.
```

## 解决方案

### 方案1：使用 WindowProperties（推荐）

通过窗口属性获取屏幕密度相关信息。

```typescript
const windowClass = this.getUIContext().getHostContext().getMainWindowSync();
const windowProperties = windowClass.getWindowProperties();
const windowRect = windowProperties.windowRect;
const density = windowProperties.density;
```

### 方案2：使用 Display API

使用 `@ohos.display` 模块获取显示信息。

```typescript
import { display } from '@kit.ArkUI';

const displayInfo = display.getDefaultDisplaySync();
const density = displayInfo.densityDPI;
const densityPixels = displayInfo.widthPixels;
```

### 方案3：使用 px2vp 进行转换

如果需要将像素值转换为 vp 值，使用 UIContext 的 `px2vp` 方法。

```typescript
const pxValue = 100;
const vpValue = this.getUIContext().px2vp(pxValue);
```

## 详细说明

`Configuration.densityDpi` 被移除的原因：

1. **API 规范化**：屏幕密度信息统一由 `Display` 模块和 `WindowProperties` 提供
2. **多窗口支持**：在多窗口场景下，每个窗口可能有不同的密度
3. **类型安全**：新的 API 提供了更完整的类型定义

## 属性对照表

| 旧属性 | 新 API | 说明 |
|--------|--------|------|
| `config.densityDpi` | `displayInfo.densityDPI` | 屏幕密度（每英寸像素数） |
| `config.screenDensity` | `windowProperties.density` | 屏幕密度缩放因子 |
| `config.screenWidth` | `windowProperties.windowRect.width` | 窗口宽度 |
| `config.screenHeight` | `windowProperties.windowRect.height` | 窗口高度 |
| `config.screenWidth` | `displayInfo.width` | 屏幕宽度 |
| `config.screenHeight` | `displayInfo.height` | 屏幕高度 |

## 简单示例

```typescript
import { display } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct ConfigurationDensityExample {
  @State densityInfo: string = '';

  aboutToAppear() {
    this.updateDensityInfo();
  }

  updateDensityInfo() {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      const uiAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const windowClass = uiAbilityContext.getMainWindowSync();
      const windowProperties = windowClass.getWindowProperties();

      this.densityInfo = [
        `屏幕密度: ${displayInfo.densityDPI} DPI`,
        `屏幕宽度: ${displayInfo.width} px`,
        `屏幕高度: ${displayInfo.height} px`,
        `窗口宽度: ${windowProperties.windowRect.width} px`,
        `窗口高度: ${windowProperties.windowRect.height} px`
      ].join('\n');
    } catch (err) {
      console.error(`Failed to get density info: ${JSON.stringify(err)}`);
    }
  }

  build() {
    Column() {
      Text('Configuration densityDpi 替代方案示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)

      Text(this.densityInfo)
        .fontSize(14)
        .fontColor('#666666')
        .padding(15)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin(20)

      Button('更新密度信息')
        .onClick(() => {
          this.updateDensityInfo();
        })
        .margin(20)
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}
```

## 详细代码示例

> [ConfigurationDensityReplacement.ets](../assets/ConfigurationDensityReplacement.ets) - 完整的 Configuration densityDpi 属性弃用示例和替代方案
