# 系统能力迁移指南

本指南涵盖了文件系统、后台任务、通知管理、窗口管理、相机管理以及 Ability 模型等核心系统能力的迁移方案。

## 1. 文件系统 (`fileio` -> `fs`)

**弃用说明:**
`@ohos.fileio` 模块已不再推荐使用，请迁移至 `@ohos.file.fs`。新模块提供了更统一、更清晰的 API 设计。

**旧写法 (`fileio`):**
```typescript
import fileio from '@ohos.fileio';
// 使用 fd 进行操作
```

**现代写法 (`fs`):**
```typescript
import { fileIo as fs } from '@kit.CoreFileKit';
// 使用 fs.open, fs.read, fs.write, fs.close
```
> [查看完整示例](../assets/FileMigration.ets)

## 2. 后台任务 (`backgroundTaskManager`)

**变更说明:**
API 9 及之前的旧接口（如 `requestSuspendDelay`）已废弃。请使用同名模块 `@ohos.resourceschedule.backgroundTaskManager` 中的新接口。

**旧写法:**
```typescript
import backgroundTaskManager from '@ohos.backgroundTaskManager';
// 旧的 requestSuspendDelay 签名
```

**现代写法:**
使用新的接口签名申请长时任务或短时任务。

```typescript
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { wantAgent } from '@kit.AbilityKit';

// 申请长时任务
backgroundTaskManager.startBackgroundRunning(context, list, wantAgentInfo);
```
> [查看完整示例](../assets/BackgroundMigration.ets)

## 3. 窗口管理 (`window`)

**弃用说明：**
全局的 `window.getTopWindow()` 等方法已不推荐在 Stage 模型中使用。应通过 `windowStage` 或 `UIContext` 获取窗口实例。

**旧写法：**
```typescript
import window from '@ohos.window';
window.getTopWindow((err, data) => { ... });
```

**现代写法：**
在 `EntryAbility` 的 `onWindowStageCreate` 中获取，或使用 `this.context`。

```typescript
onWindowStageCreate(windowStage: window.WindowStage) {
  windowStage.getMainWindow((err, windowClass) => {
    // ...
  });
}
```

**window.getLastWindow 回调模式：**
```typescript
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct WindowExample {
  @State windowWidth: number = 0;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        console.error('获取窗口信息失败:', err);
        return;
      }
      
      const properties = win.getWindowProperties();
      this.windowWidth = properties.windowRect.width;
      
      win.on('windowSizeChange', (size: window.Size) => {
        this.windowWidth = size.width;
      });
    });
  }
}
```
> [查看完整示例](../assets/WindowMigration.ets)

**窗口方法 Promise 模式：**
```typescript
private async setWindowFullScreen(win: window.Window) {
  try {
    await win.setWindowLayoutFullScreen(true);
    await win.setWindowSystemBarProperties({
      statusBarColor: '#00000000',
      navigationBarColor: '#00000000',
      isStatusBarLightIcon: false,
      isNavigationBarLightIcon: false
    });
    this.isFullScreen = true;
  } catch (err) {
    console.error('设置全屏失败:', err);
  }
}
```

**简单示例：**
```typescript
@Entry
@Component
struct WindowMethodExample {
  @State isFullScreen: boolean = false;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        console.error('获取窗口失败:', err);
        return;
      }
      this.setWindowFullScreen(win);
    });
  }

  private async setWindowFullScreen(win: window.Window) {
    try {
      await win.setWindowLayoutFullScreen(true);
      this.isFullScreen = true;
    } catch (err) {
      console.error('设置全屏失败:', err);
    }
  }

  build() {
    Text(`全屏状态: ${this.isFullScreen}`)
  }
}
```

**详细代码示例：**
- [WindowMethodMigration.ets](../assets/WindowMethodMigration.ets) - 完整的窗口方法 Promise 模式示例，包含设置/取消全屏功能

## 4. 显示信息 (`display`)

**弃用说明：**
`window.getDefaultDisplay()` 已不存在。应使用 `display.getDefaultDisplaySync()` 从 `@kit.ArkGraphics` 模块获取显示信息。

**旧写法：**
```typescript
import window from '@ohos.window';
window.getDefaultDisplay((err, data) => {
  console.info(`Width: ${data.width}`);
});
```

**现代写法：**
```typescript
import { display } from '@kit.ArkGraphics';

try {
  const defaultDisplay = display.getDefaultDisplaySync();
  console.info(`Width: ${defaultDisplay.width}`);
  console.info(`Orientation: ${defaultDisplay.orientation}`);
} catch (err) {
  console.error('获取显示信息失败:', err);
}
```
> [查看完整示例](../assets/DisplayReplacement.ets)

**折叠状态监听 (`foldStatusChange` -> `availableAreaChange`)：**

**弃用说明：**
`display.on('foldStatusChange')` 事件已弃用。应使用 `display.on('availableAreaChange')` 事件来监听折叠设备的状态变化。

**旧写法：**
```typescript
import display from '@ohos.display';

const defaultDisplay = display.getDefaultDisplaySync();
defaultDisplay.on('foldStatusChange', (data: display.FoldStatus) => {
  console.info(`Fold status: ${data}`);
});
```

**现代写法：**
```typescript
import { display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const defaultDisplay = display.getDefaultDisplaySync();
defaultDisplay.on('availableAreaChange', (data) => {
  const foldStatus = data.width < 600 ? '折叠态' : '展开态';
  hilog.info(0xFF00, 'FoldStatus', 'Status: %{public}s', foldStatus);
});
```

**简单示例：**
```typescript
@Entry
@Component
struct FoldStatusExample {
  @State foldStatus: string = '未知';
  @State availableAreaWidth: number = 0;

  aboutToAppear() {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      this.availableAreaWidth = defaultDisplay.width;
      
      defaultDisplay.on('availableAreaChange', (data) => {
        this.availableAreaWidth = data.width;
        this.foldStatus = data.width < 600 ? '折叠态' : '展开态';
      });
    } catch (err) {
      console.error('Failed to get display:', err);
    }
  }

  build() {
    Column() {
      Text(`状态: ${this.foldStatus}`)
      Text(`可用区域宽度: ${this.availableAreaWidth}`)
    }
  }
}
```

**详细代码示例：**
- [FoldStatusReplacement.ets](../assets/FoldStatusReplacement.ets) - 完整的折叠状态监听示例，包含事件监听和清理

## 5. Ability 模型 (`featureAbility` -> `UIAbility`)

**弃用说明:**
`@ohos.ability.featureAbility` 是 FA 模型的遗留产物。在 Stage 模型中，必须使用 `UIAbility` 和 `UIAbilityContext`。

**旧写法 (FA):**
```typescript
import featureAbility from '@ohos.ability.featureAbility';
let context = featureAbility.getContext();
```

**现代写法 (Stage):**
```typescript
import { UIAbility } from '@kit.AbilityKit';
// 在 UIAbility 中
let context = this.context;
// 在 UI 组件中
let context = getContext(this) as common.UIAbilityContext;
```
> [查看完整示例](../assets/AbilityMigration.ets)

## 6. 通知管理 (`notification` -> `notificationManager`)

**弃用说明:**
旧的 `@ohos.notification` 模块已被 `@ohos.notificationManager` 取代。

**现代写法:**
```typescript
import { notificationManager } from '@kit.NotificationKit';

let request: notificationManager.NotificationRequest = {
  id: 1,
  content: {
    contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: 'Title',
      text: 'Text',
    }
  }
};
notificationManager.publish(request);
```
> [查看完整示例](../assets/NotificationMigration.ets)

## 7. 相机管理 (`CameraKit`)

**弃用说明:**
旧版 `camera.Camera` 类已不存在。新版使用 `camera.CameraManager` 和 `camera.Session` 来管理相机。

**旧写法：**
```typescript
import { camera } from '@kit.MediaKit';

const cameraManager = camera.getCameraManager(context);
const cameraController = await cameraManager.createCamera(cameraId);
await cameraController.start();
```

**现代写法：**
```typescript
import { camera } from '@kit.CameraKit';

const cameraManager = camera.getCameraManager(context);
const cameraInput = cameraManager.createCameraInput(cameraDevice);
await cameraInput.open();

const captureSession = cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO);
captureSession.beginConfig();
captureSession.addInput(cameraInput);
await captureSession.commitConfig();
await captureSession.start();
```

**getSupportedOutputCapability 需要添加 sceneMode 参数：**
```typescript
// 旧写法（错误）
const profiles = cameraManager.getSupportedOutputCapability(cameraDevice);

// 现代写法
const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO);
```

**CameraInput 使用 close() 而不是 release()：**
```typescript
// 错误写法
this.cameraInput.release();

// 现代写法
this.cameraInput.close();
```

**imagePacker 使用 packToFile 而不是 packing：**
```typescript
// 旧写法
const arrayBuffer = await imagePacker.packing(pixelMap, packOption);

// 现代写法
imagePacker.packToFile(pixelMap, file.fd, packOption, (err) => {
  if (err) {
    console.error('保存照片失败:', err);
  }
});
```

**简单示例：**
```typescript
import { camera } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct CameraExample {
  private cameraManager: camera.CameraManager | null = null;
  private cameraInput: camera.CameraInput | null = null;
  private captureSession: camera.Session | null = null;

  async aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.cameraManager = camera.getCameraManager(context);
    
    const cameras = this.cameraManager.getSupportedCameras();
    if (cameras.length > 0) {
      await this.initCamera(cameras[0]);
    }
  }

  async initCamera(cameraDevice: camera.CameraDevice) {
    this.cameraInput = this.cameraManager!.createCameraInput(cameraDevice);
    await this.cameraInput.open();
    
    this.captureSession = this.cameraManager!.createSession(camera.SceneMode.NORMAL_VIDEO);
    this.captureSession.beginConfig();
    this.captureSession.addInput(this.cameraInput);
    await this.captureSession.commitConfig();
    await this.captureSession.start();
  }

  build() {
    Text('Camera initialized')
  }
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的相机初始化、预览和拍照示例
- [Camera API Migration Guide](./camera_migration.md) - 详细的相机API迁移指南

## 8. 设置数据项 (`settings`)

**弃用说明:**
部分 `settings` 常量（如 `DATE_FORMAT`, `AUTO_GAIN_TIME`）已在 API 10+ 中废弃或不再维护。

**建议:**
使用 `SystemCapability.Applications.Settings.Core` 下的新常量，或通过 `I18n` 模块处理日期格式化。

## 9. 避让区域 (`AvoidArea`)

**变更说明:**
`window.AvoidArea` 类型现在需要包含 `visible` 属性，用于指示避让区域是否可见。

**旧写法:**
```typescript
@State avoidArea: window.AvoidArea = {
  topRect: { left: 0, top: 0, width: 0, height: 0 },
  bottomRect: { left: 0, top: 0, width: 0, height: 0 },
  leftRect: { left: 0, top: 0, width: 0, height: 0 },
  rightRect: { left: 0, top: 0, width: 0, height: 0 }
};
```

**现代写法:**
```typescript
@State avoidArea: window.AvoidArea = {
  topRect: { left: 0, top: 0, width: 0, height: 0 },
  bottomRect: { left: 0, top: 0, width: 0, height: 0 },
  leftRect: { left: 0, top: 0, width: 0, height: 0 },
  rightRect: { left: 0, top: 0, width: 0, height: 0 },
  visible: false
};
```

**简单示例：**
```typescript
@Entry
@Component
struct AvoidAreaExample {
  @State avoidArea: window.AvoidArea = {
    topRect: { left: 0, top: 0, width: 0, height: 0 },
    bottomRect: { left: 0, top: 0, width: 0, height: 0 },
    leftRect: { left: 0, top: 0, width: 0, height: 0 },
    rightRect: { left: 0, top: 0, width: 0, height: 0 },
    visible: false
  };

  build() {
    Text(`顶部高度: ${this.avoidArea.topRect.height}`)
  }
}
```

**详细代码示例：**
- [AvoidAreaMigration.ets](../assets/AvoidAreaMigration.ets) - 完整的 AvoidArea 类型使用示例，包含系统避让区域和导航栏避让区域

## 10. 独立函数中的上下文使用

**变更说明:**
在独立函数（非类方法）中不能直接使用 `this`，需要将上下文作为参数传递。

**旧写法（错误）:**
```typescript
async function getAvoidArea() {
  const win = await window.getLastWindow(this.getUIContext().getHostContext());
  return win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
}
```

**现代写法:**
```typescript
async function getAvoidArea(context: common.UIAbilityContext): Promise<window.AvoidArea> {
  return new Promise((resolve, reject) => {
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        reject(err);
        return;
      }
      const avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      resolve(avoidArea);
    });
  });
}
```

**简单示例：**
```typescript
@Entry
@Component
struct Example {
  @State avoidAreaHeight: number = 0;

  async aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    try {
      const avoidArea = await getAvoidArea(context);
      this.avoidAreaHeight = avoidArea.topRect.height;
    } catch (err) {
      console.error('获取避让区域失败:', err);
    }
  }

  build() {
    Text(`避让区域高度: ${this.avoidAreaHeight}`)
  }
}
```

**详细代码示例：**
- [StandaloneFunctionContext.ets](../assets/StandaloneFunctionContext.ets) - 完整的独立函数上下文传递示例，包含多个独立函数的使用

## 11. 标题栏按钮区域类型 (`getTitleButtonRect`)

**变更说明:**
`window.getTitleButtonRect()` 方法返回的是 `window.TitleButtonRect` 类型，而不是 `window.Rect` 类型。

**错误写法:**
```typescript
async function getTitleButtonRect(context: common.UIAbilityContext): Promise<window.Rect> {
  return new Promise((resolve, reject) => {
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        reject(new Error(err.message));
        return;
      }
      const titleButtonRect = win.getTitleButtonRect();
      resolve(titleButtonRect);
    });
  });
}
```

**现代写法:**
```typescript
async function getTitleButtonRect(context: common.UIAbilityContext): Promise<window.TitleButtonRect> {
  return new Promise((resolve, reject) => {
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        reject(new Error(err.message));
        return;
      }
      const titleButtonRect = win.getTitleButtonRect();
      resolve(titleButtonRect);
    });
  });
}
```

**简单示例：**
```typescript
@Entry
@Component
struct TitleButtonRectExample {
  @State titleBarHeight: number = 0;

  async aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        console.error('获取窗口失败:', err);
        return;
      }
      const titleButtonRect = win.getTitleButtonRect();
      this.titleBarHeight = titleButtonRect.height;
    });
  }

  build() {
    Text(`标题栏高度: ${this.titleBarHeight}`)
  }
}
```

**详细代码示例：**
- [StandaloneFunctionContext.ets](../assets/StandaloneFunctionContext.ets) - 完整的 TitleButtonRect 类型使用示例，包含错误处理
- [TitleButtonRect Type Error](../ArkTS_error_solution/reference/title_button_rect_type_errors.md) - TitleButtonRect 类型错误的详细说明
