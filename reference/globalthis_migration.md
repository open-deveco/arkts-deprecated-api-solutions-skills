# globalThis 弃用迁移指南

## 弃用说明

`globalThis` 在 ArkTS 中已被弃用，不再推荐使用。全局变量的访问应该通过更规范的方式实现，如 `AppStorage`、`LocalStorage` 或组件的 `Context`。

## 错误示例

```typescript
const context = globalThis.getContext();
const promptAction = context.getApplicationContext().getPromptAction();
promptAction.showToast({ message: 'Hello' });
```

**错误信息：**
```
The signature '(component?: Object): Context' of 'globalThis.getContext' is deprecated.
"globalThis" is not supported (arkts-no-globalthis)
```

## 解决方案

### 方案1：使用 UIContext（推荐）

在组件内部，使用 `getUIContext()` 获取 UI 上下文，然后访问需要的服务。

```typescript
@Entry
@Component
struct MyComponent {
  showToast() {
    this.getUIContext().getPromptAction().showToast({
      message: 'Hello',
      duration: 2000
    });
  }

  build() {
    Button('Show Toast')
      .onClick(() => {
        this.showToast();
      })
  }
}
```

### 方案2：使用 AppStorage

对于需要在组件间共享的数据，使用 `AppStorage` 进行状态管理。

```typescript
// 设置
AppStorage.setOrCreate('message', 'Hello World');

// 获取
const message = AppStorage.get<string>('message');

// 在组件中使用
@Component
struct MyComponent {
  @StorageLink('message') message: string = '';

  build() {
    Text(this.message)
  }
}
```

### 方案3：使用 LocalStorage

对于页面级别的状态管理，使用 `LocalStorage`。

```typescript
// 创建 LocalStorage 实例
const localStorage = new LocalStorage();

// 设置
localStorage.setOrCreate('key', 'value');

// 获取
const value = localStorage.get<string>('key');

// 在页面中使用
@Entry
@Component
struct MyPage {
  @LocalStorageLink('key') value: string = '';

  build() {
    Text(this.value)
  }
}
```

### 方案4：使用 Context 参数

在回调或事件处理中，通过参数传递 Context。

```typescript
function showToast(context: UIContext, message: string) {
  context.getPromptAction().showToast({
    message: message,
    duration: 2000
  });
}

@Entry
@Component
struct MyComponent {
  build() {
    Button('Show Toast')
      .onClick(() => {
        showToast(this.getUIContext(), 'Hello');
      })
  }
}
```

## 详细说明

弃用 `globalThis` 的原因：

1. **类型安全**：`globalThis` 缺乏类型约束，容易导致运行时错误
2. **多实例支持**：在多窗口或多实例场景下，`globalThis` 无法正确区分
3. **状态管理规范**：ArkTS 提供了更规范的状态管理机制（AppStorage、LocalStorage）
4. **组件隔离**：每个组件应该有自己的上下文，而不是依赖全局变量

## 简单示例

```typescript
@Entry
@Component
struct GlobalThisReplacement {
  @State message: string = 'Hello World';

  showMessage() {
    // 使用 UIContext 而不是 globalThis
    this.getUIContext().getPromptAction().showToast({
      message: this.message,
      duration: 2000
    });
  }

  build() {
    Column() {
      Text('globalThis 替代方案示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)

      Button('显示消息')
        .onClick(() => {
          this.showMessage();
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

> [GlobalThisReplacement.ets](../assets/GlobalThisReplacement.ets) - 完整的 globalThis 弃用示例和替代方案
