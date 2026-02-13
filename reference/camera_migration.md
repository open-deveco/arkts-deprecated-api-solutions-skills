# 相机 API 迁移指南

本指南涵盖了 HarmonyOS 相机 API 的迁移方案，包括从旧版 API 迁移到新版 CameraKit API。

## 1. CameraManager API 变更

**弃用说明：**
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
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的相机初始化和管理示例

## 2. getSupportedOutputCapability 需要添加 sceneMode 参数

**弃用说明：**
`getSupportedOutputCapability(cameraDevice)` 方法已弃用，必须添加 `sceneMode` 参数。

**旧写法：**
```typescript
const profiles = cameraManager.getSupportedOutputCapability(cameraDevice);
const previewProfiles = profiles.previewProfiles;
```

**现代写法：**
```typescript
const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO);
const previewProfiles = profiles.previewProfiles;
```

**简单示例：**
```typescript
import { camera } from '@kit.CameraKit';

function getPreviewProfiles(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice): camera.Profile[] {
  const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO);
  return profiles.previewProfiles;
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的相机配置文件获取示例

## 3. CameraInput 没有 release() 方法

**变更说明：**
`camera.CameraInput` 类没有 `release()` 方法，应该使用 `close()` 方法来关闭相机输入。

**错误写法：**
```typescript
if (this.cameraInput) {
  this.cameraInput.release();
  this.cameraInput = null;
}
```

**现代写法：**
```typescript
if (this.cameraInput) {
  this.cameraInput.close();
  this.cameraInput = null;
}
```

**简单示例：**
```typescript
import { camera } from '@kit.CameraKit';

@Entry
@Component
struct CameraReleaseExample {
  private cameraInput: camera.CameraInput | null = null;

  async releaseCamera() {
    if (this.cameraInput) {
      this.cameraInput.close();
      this.cameraInput = null;
    }
  }

  build() {
    Button('Release Camera')
      .onClick(() => {
        this.releaseCamera();
      })
  }
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的相机资源释放示例

## 4. imagePacker.packing 弃用

**弃用说明：**
`imagePacker.packing()` 方法已弃用，应使用 `imagePacker.packToFile()` 方法直接保存到文件。

**旧写法：**
```typescript
const imagePacker = image.createImagePacker();
const packOption: image.PackingOption = {
  format: 'image/jpeg',
  quality: 100
};
const arrayBuffer = await imagePacker.packing(pixelMap, packOption);
```

**现代写法：**
```typescript
import { fileIo } from '@kit.CoreFileKit';

const imagePacker = image.createImagePacker();
const packOption: image.PackingOption = {
  format: 'image/jpeg',
  quality: 100
};

const path = context.cacheDir + '/photo.jpg';
const file = fileIo.openSync(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);

imagePacker.packToFile(pixelMap, file.fd, packOption, (err) => {
  if (err) {
    console.error('保存照片失败:', err);
  } else {
    console.log('照片已保存');
  }
  fileIo.closeSync(file.fd);
});
```

**简单示例：**
```typescript
import image from '@ohos.multimedia.image';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';

async function savePhoto(pixelMap: image.PixelMap, context: common.UIAbilityContext) {
  const imagePacker = image.createImagePacker();
  const packOption: image.PackingOption = {
    format: 'image/jpeg',
    quality: 100
  };
  
  const path = context.cacheDir + '/photo.jpg';
  const file = fileIo.openSync(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
  
  imagePacker.packToFile(pixelMap, file.fd, packOption, (err) => {
    if (err) {
      console.error('保存照片失败:', err);
    } else {
      console.log('照片已保存');
    }
    fileIo.closeSync(file.fd);
  });
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的照片保存示例

## 5. XComponent 导入路径变更

**变更说明：**
`XComponent`、`XComponentController`、`XComponentType` 等组件不再从 `@kit.ArkUI` 导出，而是作为全局组件使用。

**旧写法（错误）：**
```typescript
import { XComponent, XComponentController, XComponentType } from '@kit.ArkUI';
```

**现代写法：**
```typescript
// 不需要导入，直接使用全局组件
XComponent({
  id: 'cameraPreview',
  type: XComponentType.SURFACE
})
```

**简单示例：**
```typescript
@Entry
@Component
struct XComponentExample {
  private surfaceId: string = '';

  build() {
    Column() {
      XComponent({
        id: 'cameraPreview',
        type: XComponentType.SURFACE
      })
        .onLoad((event) => {
          this.surfaceId = (event as Record<string, Object>).surfaceId as string;
          console.log('Surface ID:', this.surfaceId);
        })
        .width('100%')
        .height('100%')
    }
  }
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的 XComponent 使用示例

## 6. 相机预览输出配置

**变更说明：**
创建预览输出时，需要使用 `PreviewProfile` 和 `surfaceId`，而不是直接传递配置对象。

**现代写法：**
```typescript
import { camera } from '@kit.CameraKit';

const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO);
const previewProfile = profiles.previewProfiles[0];

const previewOutput = cameraManager.createPreviewOutput(previewProfile, surfaceId);
```

**简单示例：**
```typescript
import { camera } from '@kit.CameraKit';

async function setupPreview(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice, surfaceId: string) {
  const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO);
  const previewProfile = profiles.previewProfiles[0];
  
  const previewOutput = cameraManager.createPreviewOutput(previewProfile, surfaceId);
  return previewOutput;
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的相机预览配置示例

## 7. 相机拍照输出配置

**变更说明：**
创建拍照输出时，需要使用 `PhotoProfile`，而不是直接传递配置对象。

**现代写法：**
```typescript
import { camera } from '@kit.CameraKit';

const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_PHOTO);
const photoProfile = profiles.photoProfiles[0];

const photoOutput = cameraManager.createPhotoOutput(photoProfile);
```

**简单示例：**
```typescript
import { camera } from '@kit.CameraKit';

async function setupPhotoOutput(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice) {
  const profiles = cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_PHOTO);
  const photoProfile = profiles.photoProfiles[0];
  
  const photoOutput = cameraManager.createPhotoOutput(photoProfile);
  return photoOutput;
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的相机拍照配置示例

## 8. Session 类型问题

**变更说明：**
`camera.Session` 是基础类型，实际使用时应该使用 `camera.Session` 类型，而不是尝试使用不存在的 `camera.CaptureSession`。

**现代写法：**
```typescript
import { camera } from '@kit.CameraKit';

private captureSession: camera.Session | null = null;

this.captureSession = cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO);
this.captureSession.beginConfig();
this.captureSession.addInput(cameraInput);
this.captureSession.addOutput(previewOutput);
await this.captureSession.commitConfig();
```

**简单示例：**
```typescript
import { camera } from '@kit.CameraKit';

@Entry
@Component
struct SessionExample {
  private captureSession: camera.Session | null = null;

  async createSession(cameraManager: camera.CameraManager, cameraInput: camera.CameraInput, previewOutput: camera.PreviewOutput) {
    this.captureSession = cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO);
    this.captureSession.beginConfig();
    this.captureSession.addInput(cameraInput);
    this.captureSession.addOutput(previewOutput);
    await this.captureSession.commitConfig();
    await this.captureSession.start();
  }

  build() {
    Text('Session created')
  }
}
```

**详细代码示例：**
- [CameraMigration.ets](../assets/CameraMigration.ets) - 完整的 Session 使用示例
