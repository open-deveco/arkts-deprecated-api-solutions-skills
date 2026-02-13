# 网络能力迁移指南

本指南主要关注 HTTP 请求能力的现代化迁移。虽然 `@ohos.net.http` 依然可用，但 HarmonyOS 推荐在高性能或复杂场景下使用 Remote Communication Kit (`rcp`)。

## HTTP 客户端 (`http` -> `rcp`)

**现状:**
`@ohos.net.http` 是基础的 HTTP 请求模块。
`@hms.collaboration.rcp` (Remote Communication Kit) 是新一代通信套件，提供更好的性能、更丰富的功能（如细粒度的会话管理、拦截器等）。

**旧写法 (`http`):**
```typescript
import http from '@ohos.net.http';

let httpRequest = http.createHttp();
httpRequest.request('https://example.com', (err, data) => {
  // ...
});
```

**现代写法 (`rcp`):**
```typescript
import { rcp } from '@kit.RemoteCommunicationKit';

const session = rcp.createSession();
const request = new rcp.Request('https://example.com');
const response = await session.fetch(request);
```
> [查看完整示例](../assets/NetworkMigration.ets)
