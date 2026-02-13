# UIContext 迁移指南

在较新的 HarmonyOS 版本中，依赖 UI 上下文的全局 API（如 `animateTo`、`router`、`promptAction`）已不推荐使用，建议改用通过 `UIContext` 访问的实例 API。这确保了在多窗口或多实例场景下上下文处理的正确性。

## 1. 动画 (`animateTo`)

**旧写法：**
```typescript
animateTo({ duration: 1000 }, () => {
  this.width = 200;
});
```

**现代写法：**
```typescript
this.getUIContext().animateTo({ duration: 1000 }, () => {
  this.width = 200;
});
```
> [查看完整示例](../assets/AnimationReplacement.ets)

## 2. 路由 (`getRouter`, `pushUrl`, `back`)

**旧写法：**
```typescript
import router from '@ohos.router';
router.pushUrl({ url: 'pages/Detail' });
router.back();
```

**现代写法：**
```typescript
const router = this.getUIContext().getRouter();
router.pushUrl({ url: 'pages/Detail' });
router.back();
```
> [查看完整示例](../assets/RouterReplacement.ets)

## 3. 提示 (`showToast`)

**旧写法：**
```typescript
import promptAction from '@ohos.promptAction';
promptAction.showToast({ message: 'Hello' });
```

**现代写法：**
```typescript
this.getUIContext().getPromptAction().showToast({ message: 'Hello' });
```
> [查看完整示例](../assets/PromptReplacement.ets)

## 4. 屏幕工具 (`px2vp`)

**旧写法：**
```typescript
let vp = px2vp(100);
```

**现代写法：**
```typescript
let vp = this.getUIContext().px2vp(100);
```
> [查看完整示例](../assets/ScreenUtilsReplacement.ets)

## 5. 宿主上下文 (`getHostContext`)

**旧写法：**
通过全局或导入访问 Context。

**现代写法：**
```typescript
let context = this.getUIContext().getHostContext();
```
> [查看完整示例](../assets/HostContextReplacement.ets)

## 6. 媒体查询 (`matchMediaSync`)

**弃用说明：**
`mediaquery.matchMediaSync(condition: string)` 已在 API 18 中弃用。建议使用 `this.getUIContext().getMediaQuery().matchMediaSync()`。

**旧写法：**
```typescript
import mediaquery from '@ohos.mediaquery';

@Entry
@Component
struct MyComponent {
  private listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(min-width: 600vp)');
  
  aboutToAppear() {
    this.listener.on('change', (result) => {
      console.info(`Matches: ${result.matches}`);
    });
  }
}
```

**现代写法：**
```typescript
import { mediaquery } from '@kit.ArkUI';

@Entry
@Component
struct MyComponent {
  private listener: mediaquery.MediaQueryListener | null = null;
  
  aboutToAppear() {
    this.listener = this.getUIContext().getMediaQuery().matchMediaSync('(min-width: 600vp)');
    if (this.listener) {
      this.listener.on('change', (result) => {
        console.info(`Matches: ${result.matches}`);
      });
    }
  }
}
```
> [查看完整示例](../assets/MediaQueryReplacement.ets)

## 7. 滚动事件

**弃用说明：**
`Scroll.onScroll((xOffset, yOffset) => void)` API 已在 API 12 中弃用。建议使用 `onWillScroll` 替代。

**弃用时间：** API 12  
**替代 API：** `onWillScroll`  
**系统能力：** SystemCapability.ArkUI.ArkUI.Full

**旧写法：**
```typescript
Scroll() {
  Column() {
    Text('Content')
  }
}
.onScroll((xOffset: number, yOffset: number) => {
  console.info(`Scroll: ${xOffset}, ${yOffset}`);
})
```

**现代写法：**
```typescript
Scroll() {
  Column() {
    Text('Content')
  }
}
.onWillScroll((xOffset: number, yOffset: number) => {
  console.info(`Scroll: ${xOffset}, ${yOffset}`);
})
.onReachStart(() => {
  console.info('Scroll reached start');
})
.onReachEnd(() => {
  console.info('Scroll reached end');
})
.onScrollEdge((side: Edge) => {
  console.info(`Scroll edge: ${side}`);
})
```

**简单示例：**
```typescript
@Entry
@Component
struct ScrollExample {
  @State scrollOffset: number = 0;

  build() {
    Column() {
      Text(`滚动偏移: ${this.scrollOffset}`)
        .margin({ bottom: 16 })
      
      Scroll() {
        Column() {
          ForEach(Array.from({ length: 50 }), (_: Object, index: number) => {
            Text(`Item ${index + 1}`)
              .padding(12)
              .margin({ bottom: 8 })
          }, (_: Object, index: number) => `${index}`)
        }
      }
      .onWillScroll((_xOffset: number, yOffset: number) => {
        this.scrollOffset = yOffset;
      })
      .onReachStart(() => {
        console.info('Scroll reached start');
      })
      .onReachEnd(() => {
        console.info('Scroll reached end');
      })
    }
    .padding(16)
  }
}
```

**状态管理建议：**
对于需要持久化滚动位置的场景，推荐使用 `@StorageLink` 与 `AppStorage` 配合，而不是依赖 `onWillScroll` 事件。

```typescript
@Entry
@Component
struct ScrollWithState {
  @StorageLink('scrollOffset') scrollOffset: number = 0;

  build() {
    Scroll() {
      Column() {
        Text(`Offset: ${this.scrollOffset}`)
      }
    }
  }
}
```
> [查看完整示例](../assets/ScrollEventReplacement.ets)
