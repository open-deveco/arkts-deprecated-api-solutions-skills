# onDidScroll API 迁移指南

## 问题描述

在 HarmonyOS API 12+ 版本中，`Scroll` 组件的 `onScroll` 事件已被标记为弃用（deprecated）。继续使用该 API 会在编译时产生警告信息。

## 弃用 API

```typescript
// ❌ 已弃用
Scroll() {
  // 内容
}
.onScroll((xOffset: number, yOffset: number) => {
  // 处理滚动事件
})
```

**弃用时间：** API 12  
**替代 API：** `onDidScroll`  
**系统能力：** SystemCapability.ArkUI.ArkUI.Full

## 推荐替代方案

使用 `onDidScroll` 事件替代 `onScroll`：

```typescript
// ✅ 推荐使用
Scroll() {
  // 内容
}
.onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
  // 处理滚动事件
})
```

## 主要变化

| 特性 | onScroll (已弃用) | onDidScroll (推荐) |
|------|-------------------|-------------------|
| 参数1 | xOffset: number | scrollOffset: number |
| 参数2 | yOffset: number | scrollState: ScrollState |
| 滚动状态 | 不提供 | 提供 ScrollState 枚举 |
| 触发时机 | 滚动过程中 | 滚动发生时 |

## ScrollState 枚举

`ScrollState` 提供了更详细的滚动状态信息：

```typescript
enum ScrollState {
  Idle = 0,    // 空闲状态
  Scroll = 1,   // 滚动状态
  Fling = 2     // 惯性滑动状态
}
```

## 迁移步骤

### 1. 修改事件处理器参数

```typescript
// 修改前
.onScroll((xOffset: number, yOffset: number) => {
  this.scrollOffset = yOffset;
})

// 修改后
.onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
  this.scrollOffset = scrollOffset;
})
```

### 2. 处理滚动状态（可选）

```typescript
.onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
  this.scrollOffset = scrollOffset;
  this.scrollState = scrollState;
  
  if (scrollState === ScrollState.Fling) {
    console.info('正在惯性滑动');
  }
})
```

### 3. 标记未使用的参数

如果不需要使用 `scrollState` 参数，使用下划线前缀标记：

```typescript
.onDidScroll((scrollOffset: number, _scrollState: ScrollState) => {
  this.scrollOffset = scrollOffset;
})
```

## 完整示例

```typescript
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct ScrollExample {
  @State scrollOffset: number = 0;
  @State scrollState: string = 'Idle';

  build() {
    Column() {
      Text(`滚动偏移: ${this.scrollOffset}`)
        .fontSize(16)
        .margin({ bottom: 8 })
      
      Text(`滚动状态: ${this.scrollState}`)
        .fontSize(16)
        .margin({ bottom: 16 })
      
      Scroll() {
        Column() {
          ForEach(Array.from({ length: 50 }), (_: Object, index: number) => {
            Text(`Item ${index + 1}`)
              .fontSize(16)
              .padding(12)
              .margin({ bottom: 8 })
              .backgroundColor('#F5F5F5')
              .borderRadius(4)
          }, (_: Object, index: number) => `${index}`)
        }
        .width('100%')
      }
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        this.scrollOffset = scrollOffset;
        this.scrollState = this.getScrollStateName(scrollState);
        hilog.info(0xFF00, 'ScrollExample', 'offset: %{public}d, state: %{public}d', scrollOffset, scrollState);
      })
      .onReachStart(() => {
        hilog.info(0xFF00, 'ScrollExample', 'Reached start');
      })
      .onReachEnd(() => {
        hilog.info(0xFF00, 'ScrollExample', 'Reached end');
      })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }

  private getScrollStateName(state: ScrollState): string {
    switch (state) {
      case ScrollState.Idle:
        return 'Idle';
      case ScrollState.Scroll:
        return 'Scroll';
      case ScrollState.Fling:
        return 'Fling';
      default:
        return 'Unknown';
    }
  }
}
```

> [查看完整示例](../assets/ScrollDidScrollReplacement.ets)

## 配套事件

`onDidScroll` 可以与其他滚动事件配合使用：

```typescript
Scroll() {
  // 内容
}
.onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
  // 滚动发生时
})
.onReachStart(() => {
  // 到达起始位置
})
.onReachEnd(() => {
  // 到达结束位置
})
.onScrollEdge((side: Edge) => {
  // 到达边缘
})
.onScrollStart(() => {
  // 滚动开始
})
.onScrollStop(() => {
  // 滚动停止
})
```

## 使用场景

### 1. 基础滚动监听

```typescript
@State scrollOffset: number = 0;

Scroll() {
  // 内容
}
.onDidScroll((scrollOffset: number, _scrollState: ScrollState) => {
  this.scrollOffset = scrollOffset;
})
```

### 2. 滚动状态感知

```typescript
@State isScrolling: boolean = false;

Scroll() {
  // 内容
}
.onDidScroll((_scrollOffset: number, scrollState: ScrollState) => {
  this.isScrolling = scrollState !== ScrollState.Idle;
})
```

### 3. 惯性滑动检测

```typescript
Scroll() {
  // 内容
}
.onDidScroll((_scrollOffset: number, scrollState: ScrollState) => {
  if (scrollState === ScrollState.Fling) {
    console.info('用户正在进行惯性滑动');
  }
})
```

### 4. 性能优化

```typescript
Scroll() {
  // 内容
}
.onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
  // 只在滚动状态下更新 UI
  if (scrollState === ScrollState.Scroll) {
    this.updateUI(scrollOffset);
  }
})
```

## 注意事项

1. **参数变化**：第一个参数从 `xOffset` 变为 `scrollOffset`，表示滚动偏移量

2. **新增状态参数**：第二个参数 `scrollState` 提供滚动状态信息

3. **未使用参数**：如果不需要 `scrollState`，使用 `_scrollState` 标记以避免警告

4. **状态枚举**：使用 `ScrollState` 枚举判断滚动状态，而不是魔法数字

5. **性能考虑**：避免在滚动回调中执行耗时操作

## 相关 API 参考

- `Scroll` 组件：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/arkui-ts/ts-container-scroll)
- `ScrollState` 枚举：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/arkui-ts/ts-appendix-enums-0000001774121174)
- `Edge` 枚举：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/arkui-ts/ts-appendix-enums-0000001774121174)

## 迁移检查清单

- [ ] 将 `onScroll` 替换为 `onDidScroll`
- [ ] 修改第一个参数名为 `scrollOffset`
- [ ] 添加第二个参数 `scrollState: ScrollState`
- [ ] 处理 `ScrollState` 枚举值
- [ ] 标记未使用的参数（如 `_scrollState`）
- [ ] 测试滚动功能是否正常
- [ ] 验证编译警告是否消失

## 常见问题

### Q: `scrollOffset` 和之前的 `yOffset` 有什么区别？

A: `scrollOffset` 是滚动偏移量的统一表示，垂直滚动时相当于之前的 `yOffset`，水平滚动时相当于 `xOffset`。

### Q: 如何判断是垂直滚动还是水平滚动？

A: 通过 `Scroll` 组件的 `scrollable` 属性设置滚动方向，`scrollOffset` 会根据方向自动适配。

### Q: `ScrollState.Fling` 是什么状态？

A: `Fling` 表示用户快速滑动后，内容在惯性作用下继续滑动的状态。

### Q: 可以同时使用 `onDidScroll` 和 `onScroll` 吗？

A: 不建议同时使用，`onScroll` 已被弃用，应该完全迁移到 `onDidScroll`。

### Q: 如何在滚动时优化性能？

A: 
1. 使用 `ScrollState` 判断是否需要更新 UI
2. 避免在回调中执行复杂计算
3. 考虑使用 `debounce` 或 `throttle` 限制更新频率
