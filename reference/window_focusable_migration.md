# setFocusable API 迁移指南

## 问题描述

在 HarmonyOS API 9+ 版本中，`window.Window.setFocusable()` 方法已被标记为弃用（deprecated）。继续使用该 API 会在编译时产生警告信息。

## 弃用 API

```typescript
// ❌ 已弃用 (since API 9)
import window from '@ohos.window';

const win = await window.getLastWindow(context);
win.setFocusable(true);
```

**弃用时间：** API 9  
**起始版本：** API 7  
**系统能力：** SystemCapability.WindowManager.WindowManager.Core

## 推荐替代方案

使用 `setWindowFocusable()` 方法替代 `setFocusable()`：

```typescript
// ✅ 推荐使用
import { window } from '@kit.ArkUI';

const win = await window.getLastWindow(context);
await win.setWindowFocusable(true);
```

## 主要变化

| 特性 | setFocusable (已弃用) | setWindowFocusable (推荐) |
|------|----------------------|-------------------------|
| 命名 | 不够清晰 | 明确表示窗口属性设置 |
| 返回类型 | Promise<void> | Promise<void> |
| 异步处理 | 支持 | 支持 |
| API 版本 | API 7 | API 7 |

## 迁移步骤

### 1. 修改导入语句

```typescript
// 修改前
import window from '@ohos.window';

// 修改后
import { window } from '@kit.ArkUI';
```

### 2. 替换方法调用

```typescript
// 修改前
win.setFocusable(focusable);

// 修改后
await win.setWindowFocusable(focusable);
```

### 3. 添加异常处理

```typescript
try {
  const win = await window.getLastWindow(context);
  await win.setWindowFocusable(focusable);
  console.info('设置窗口可聚焦成功');
} catch (err) {
  console.error('设置窗口可聚焦失败:', err);
}
```

## 完整示例

```typescript
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct WindowFocusableExample {
  @State isFocusable: boolean = true;

  async setWindowFocusable(context: common.UIAbilityContext, focusable: boolean) {
    try {
      const win = await window.getLastWindow(context);
      await win.setWindowFocusable(focusable);
      this.isFocusable = focusable;
      console.info(`设置窗口可聚焦: ${focusable}`);
    } catch (err) {
      console.error('设置窗口可聚焦失败:', err);
    }
  }

  build() {
    Column() {
      Button(this.isFocusable ? '设置为不可聚焦' : '设置为可聚焦')
        .onClick(() => {
          const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          this.setWindowFocusable(context, !this.isFocusable);
        })
    }
  }
}
```

> [查看完整示例](../assets/WindowFocusableMigration.ets)

## 使用场景

### 1. 悬浮窗控制

```typescript
// 创建悬浮窗时设置可聚焦
const floatingWindow = await window.createWindow({
  name: 'floatingWindow',
  windowType: window.WindowType.TYPE_FLOAT,
  ctx: context
});

await floatingWindow.setWindowFocusable(true);
```

### 2. 窗口状态切换

```typescript
// 根据窗口状态动态设置可聚焦性
if (windowMode === WindowMode.FLOATING) {
  await win.setWindowFocusable(true);
} else {
  await win.setWindowFocusable(false);
}
```

### 3. 多窗口管理

```typescript
// 在多窗口场景中控制焦点
async manageWindowFocus(context: common.UIAbilityContext, windowName: string, focusable: boolean) {
  try {
    const win = window.findWindow(windowName);
    if (win) {
      await win.setWindowFocusable(focusable);
    }
  } catch (err) {
    console.error('管理窗口焦点失败:', err);
  }
}
```

## 注意事项

1. **异步方法**：`setWindowFocusable()` 是异步方法，必须使用 `await` 等待结果

2. **异常处理**：建议添加 try-catch 块处理可能的异常

3. **窗口实例**：确保在调用前已获取有效的窗口实例

4. **权限要求**：某些窗口类型（如悬浮窗）可能需要特殊权限

5. **兼容性**：新 API 从 API 7 开始支持，覆盖了旧 API 的所有使用场景

## 相关 API 参考

- `window.Window.setWindowFocusable()`：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/apis-arkui-window-0000001774529169)
- `window.getLastWindow()`：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/apis-arkui-window-0000001774529169)
- `window.createWindow()`：[官方文档](https://developer.harmonyos.com/cn/docs/documentation/reference/apis-arkui-window-0000001774529169)

## 迁移检查清单

- [ ] 修改导入语句为 `import { window } from '@kit.ArkUI'`
- [ ] 将 `setFocusable()` 替换为 `setWindowFocusable()`
- [ ] 添加 `await` 关键字等待异步操作
- [ ] 添加 try-catch 异常处理
- [ ] 测试窗口聚焦功能是否正常
- [ ] 验证编译警告是否消失

## 常见问题

### Q: 为什么要弃用 `setFocusable()`？

A: 为了 API 命名的规范化和一致性，`setWindowFocusable()` 更清晰地表明这是窗口属性设置方法。

### Q: 新 API 有什么性能优势吗？

A: 两个 API 的性能基本相同，主要区别在于命名规范和代码可读性。

### Q: 可以在旧版本 HarmonyOS 中使用新 API 吗？

A: `setWindowFocusable()` 从 API 7 开始支持，覆盖了大多数使用场景。如果需要支持更早版本，需要做版本兼容处理。

### Q: 悬浮窗需要特殊处理吗？

A: 悬浮窗类型（`TYPE_FLOAT`）需要申请 `ohos.permission.SYSTEM_FLOAT_WINDOW` 权限，除此之外使用方式相同。
