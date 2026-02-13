# 工具与加密迁移

## 1. 随机数生成 (`generateRandomSync`)

**旧写法：**
使用 `@ohos.security.crypto`（已弃用部分）或其他非标准库。

**现代写法：**
使用 `@ohos.security.cryptoFramework`。

```typescript
import cryptoFramework from '@ohos.security.cryptoFramework';

let rand = cryptoFramework.createRandom();
let blob = rand.generateRandomSync(16);
```
> [查看完整示例](../assets/UtilReplacement.ets)

## 2. 字符串解码 (`decodeToString`)

**旧写法：**
手动解码或使用已弃用的 API。

**现代写法：**
使用 `@ohos.util`。

```typescript
import util from '@ohos.util';

let textDecoder = util.TextDecoder.create('utf-8');
let str = textDecoder.decodeToString(new Uint8Array([...] ));
```
> [查看完整示例](../assets/UtilReplacement.ets)
