# 后台服务连接

## `connect`

**现代写法：**
使用 `UIAbilityContext` 中的 `connectServiceExtensionAbility`。

```typescript
let connection = context.connectServiceExtensionAbility(want, {
  onConnect: (element, remote) => { /* ... */ },
  onDisconnect: (element) => { /* ... */ },
  onFailed: (code) => { /* ... */ }
});
```
> [查看完整示例](../assets/ServiceConnectionReplacement.ets)
