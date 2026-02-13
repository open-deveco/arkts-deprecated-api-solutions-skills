# 状态管理迁移

## `AppStorage.setOrCreate`

**背景：**
`AppStorage` 是全局的。过度使用它来存储 UI 状态会导致问题或性能瓶颈。
通常 `AppStorage` 被用来全局存储 `context`，这现在最好通过 `getUIContext()` 来处理。

**现代方法：**
1. 使用 `LocalStorage` 进行独立的 Ability/Page 状态管理。
2. 使用 `getUIContext()` 来传递 context，而不是将其存储在 AppStorage 中。

**示例 (Context):**

旧写法：
```typescript
AppStorage.setOrCreate('context', this.context);
```

现代写法：
直接在组件中访问 `this.getUIContext()`。

**示例 (State):**

旧写法：
```typescript
AppStorage.setOrCreate('PropA', 47);
@StorageLink('PropA') storageLink: number = 1;
```

现代写法 (V2):
使用 `@ObservedV2` 和 `AppStorageV2`（如果可用）或 `LocalStorage`。

```typescript
// LocalStorage construction
let para: Record<string, number> = { 'PropA': 47 };
let storage = new LocalStorage(para);

@Entry(storage)
@Component
struct StateManagementReplacement {
  @LocalStorageLink('PropA') storageLink: number = 1;
  // ...
}
```
> [查看完整示例](../assets/StateManagementReplacement.ets)
