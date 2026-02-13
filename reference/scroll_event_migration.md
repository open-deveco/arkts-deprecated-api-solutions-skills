# Scroll 事件 API 迁移指南

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

## 推荐替代方案

使用 `onWillScroll` 事件替代 `onScroll`：

```typescript
// ✅ 推荐使用
private scroller: Scroller = new Scroller();

Scroll(this.scroller) {
  // 内容
}
.scrollable(ScrollDirection.Vertical)
.scrollBar(BarState.Auto)
.onWillScroll((xOffset: number, yOffset: number) => {
  // 处理滚动事件
})
```

## 主要变化

| 特性 | onScroll (已弃用) | onWillScroll (推荐) |
|------|-------------------|-------------------|
| 触发时机 | 滚动过程中 | 滚动开始前 |
| 性能 | 可能频繁触发 | 性能更优 |
| Scroller 参数 | 不需要 | 需要传入 Scroller 实例 |
| 配置要求 | 无 | 建议配合 scrollable 和 scrollBar 使用 |

## 迁移步骤

### 1. 添加 Scroller 实例

```typescript
@Component
struct MyComponent {
  private scroller: Scroller = new Scroller();
  
  build() {
    // ...
  }
}
```

### 2. 修改 Scroll 组件

```typescript
// 修改前
Scroll() {
  // 内容
}

// 修改后
Scroll(this.scroller) {
  // 内容
}
```

### 3. 替换事件处理器

```typescript
// 修改前
.onScroll((xOffset: number, yOffset: number) => {
  this.scrollOffset = yOffset;
})

// 修改后
.onWillScroll((xOffset: number, yOffset: number) => {
  this.scrollOffset = yOffset;
})
```

### 4. 添加必要的配置

```typescript
Scroll(this.scroller) {
  // 内容
}
.scrollable(ScrollDirection.Vertical)  // 设置滚动方向
.scrollBar(BarState.Auto)            // 设置滚动条显示
.onWillScroll((xOffset: number, yOffset: number) => {
  // 处理滚动事件
})
```

## 完整示例

```typescript
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct ScrollExample {
  @State scrollOffset: number = 0;
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      Text(`滚动偏移: ${this.scrollOffset}`)
        .fontSize(16)
        .margin({ bottom: 16 })
      
      Scroll(this.scroller) {
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
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .onWillScroll((_xOffset: number, yOffset: number) => {
        this.scrollOffset = yOffset;
        hilog.info(0xFF00, 'ScrollExample', 'Scroll offset: %{public}d', yOffset);
      })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}
```

## 注意事项

1. **Scroller 实例必须作为参数传入**：`Scroll(this.scroller)` 而不是 `Scroll()`

2. **建议添加 scrollable 配置**：明确指定滚动方向，如 `ScrollDirection.Vertical`

3. **建议添加 scrollBar 配置**：控制滚动条显示，如 `BarState.Auto`

4. **事件参数保持一致**：`onWillScroll` 的回调参数与 `onScroll` 相同，都是 `(xOffset: number, yOffset: number)`

5. **状态保存场景**：在连续性场景（如折叠屏切换）中，使用 `onWillScroll` 配合 `AppStorage` 可以更好地保持滚动位置

## 相关 API 参考

- `Scroll` 组件：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/arkui-ts/ts-container-scroll)
- `Scroller` 类：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/arkui-ts/ts-basic-components-scroller)
- `ScrollDirection` 枚举：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/arkui-ts/ts-appendix-enums-0000001774121174)

## 迁移检查清单

- [ ] 添加 `Scroller` 实例变量
- [ ] 将 `Scroller` 实例传入 `Scroll` 组件
- [ ] 将 `onScroll` 替换为 `onWillScroll`
- [ ] 添加 `scrollable` 配置
- [ ] 添加 `scrollBar` 配置
- [ ] 测试滚动功能是否正常
- [ ] 验证编译警告是否消失
