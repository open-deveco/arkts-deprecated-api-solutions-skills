# KeyEvent ctrlKey 错误

## 错误描述

在 `onKeyEvent` 事件中，`KeyEvent` 对象的 `ctrlKey` 属性不存在。尝试访问 `event.ctrlKey` 会导致编译错误。

## 错误示例

```typescript
@Entry
@Component
struct KeyEventError {
  @State message: string = '按 Ctrl+S 保存';

  build() {
    Column() {
      Text(this.message)
    }
    .onKeyEvent((event: KeyEvent) => {
      if (event.ctrlKey && event.keyCode === KeyCode.KEYCODE_S) {
        this.message = '已保存！';
      }
    })
  }
}
```

**错误信息：**
```
Property 'ctrlKey' does not exist on type 'KeyEvent'
```

## 解决方案

### 方案一：使用 keyboardShortcut API

使用 `keyboardShortcut` API 来定义键盘快捷键，这是推荐的方式。

```typescript
@Entry
@Component
struct KeyboardShortcutSolution {
  @State message: string = '按 Ctrl+S 保存';

  build() {
    Column() {
      Text(this.message)
    }
    .keyboardShortcut('s', [ModifierKey.CTRL], () => {
      this.message = '已保存！';
    })
  }
}
```

### 方案二：使用 modifierState 属性

如果必须使用 `onKeyEvent`，可以使用 `modifierState` 属性来检查修饰键状态。

```typescript
@Entry
@Component
struct ModifierStateSolution {
  @State message: string = '按 Ctrl+S 保存';

  build() {
    Column() {
      Text(this.message)
    }
    .onKeyEvent((event: KeyEvent) => {
      if ((event.modifierState & ModifierKey.MODIFIER_CTRL) !== 0 && 
          event.keyCode === KeyCode.KEYCODE_S) {
        this.message = '已保存！';
      }
    })
  }
}
```

## 简单示例

```typescript
@Entry
@Component
struct KeyboardShortcutExample {
  @State message: string = '按 Ctrl+S 保存';

  build() {
    Column() {
      Text('键盘快捷键示例')
        .fontSize(20)
        .margin({ bottom: 16 })
      
      Text(this.message)
        .fontSize(16)
        .fontColor('#333333')
    }
    .padding(16)
    .keyboardShortcut([{
      keys: ['Ctrl', 'S'],
      action: () => {
        this.message = '已保存！';
      }
    }])
  }
}
```

## 详细代码示例

- [KeyEventCtrlKeyError.ets](../assets/KeyEventCtrlKeyError.ets) - 完整的 KeyEvent ctrlKey 错误修复示例，包含 keyboardShortcut API 使用

## keyboardShortcut API 说明

### 基本语法

```typescript
.keyboardShortcut(value: string | FunctionKey, keys: Array<ModifierKey>, action?: () => void)
```

### 常用快捷键组合

```typescript
// Ctrl+S - 保存
.keyboardShortcut('s', [ModifierKey.CTRL], () => {
  // 保存逻辑
})

// Ctrl+C - 复制
.keyboardShortcut('c', [ModifierKey.CTRL], () => {
  // 复制逻辑
})

// Ctrl+V - 粘贴
.keyboardShortcut('v', [ModifierKey.CTRL], () => {
  // 粘贴逻辑
})

// Ctrl+Z - 撤销
.keyboardShortcut('z', [ModifierKey.CTRL], () => {
  // 撤销逻辑
})

// Ctrl+A - 全选
.keyboardShortcut('a', [ModifierKey.CTRL], () => {
  // 全选逻辑
})

// Ctrl+F - 查找
.keyboardShortcut('f', [ModifierKey.CTRL], () => {
  // 查找逻辑
})

// F5 - 刷新
.keyboardShortcut(FunctionKey.F5, [], () => {
  // 刷新逻辑
})
```

## 最佳实践

1. **使用 keyboardShortcut API**：优先使用 `keyboardShortcut` API 而不是 `onKeyEvent`
2. **提供视觉提示**：在 UI 中显示可用的快捷键
3. **避免冲突**：避免使用系统保留的快捷键
4. **跨平台考虑**：考虑不同平台的快捷键差异（如 Mac 的 Command 键）
5. **提供替代方案**：确保用户可以通过其他方式完成相同操作

## 常见错误

```typescript
// ❌ 错误：使用不存在的 ctrlKey 属性
.onKeyEvent((event: KeyEvent) => {
  if (event.ctrlKey && event.keyCode === KeyCode.KEYCODE_S) {
    // ...
  }
})

// ❌ 错误：使用不存在的 shiftKey 属性
.onKeyEvent((event: KeyEvent) => {
  if (event.shiftKey && event.keyCode === KeyCode.KEYCODE_S) {
    // ...
  }
})

// ❌ 错误：使用字符串形式的快捷键
.keyboardShortcut('Ctrl+S', () => {
  // ...
})

// ✅ 正确：使用 keyboardShortcut API
.keyboardShortcut('s', [ModifierKey.CTRL], () => {
  // ...
})

// ✅ 正确：使用 modifierState 属性
.onKeyEvent((event: KeyEvent) => {
  if ((event.modifierState & ModifierKey.MODIFIER_CTRL) !== 0 && 
      event.keyCode === KeyCode.KEYCODE_S) {
    // ...
  }
})
```
