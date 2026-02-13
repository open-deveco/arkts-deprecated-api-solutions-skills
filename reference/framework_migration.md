# 应用框架迁移指南

本指南涵盖了从 FA 模型 (`featureAbility`) 到 Stage 模型 (`UIAbility`) 的迁移，以及日志系统和故障管理的现代化方案。

## 1. Ability 模型 (`featureAbility` -> `UIAbility`)

**弃用说明:**
FA 模型中的 `featureAbility`、`particleAbility` 等接口在 Stage 模型中已不可用。Stage 模型提供了更规范的 `UIAbility` 生命周期和 `Context` 管理。

**旧写法 (FA):**
```typescript
import featureAbility from '@ohos.ability.featureAbility';

// 获取 context
let context = featureAbility.getContext();
// 启动 Ability
featureAbility.startAbility({
  want: {
    bundleName: "com.example.app",
    abilityName: "com.example.app.EntryAbility"
  }
});
```

**现代写法 (Stage):**
```typescript
import { UIAbility, Want, common } from '@kit.AbilityKit';

// 在 UIAbility 类中
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // this.context 是 UIAbilityContext
    this.context.startAbility(want);
  }
}

// 在 UI 组件中
@Component
struct MyComponent {
  build() {
    Button('Start')
      .onClick(() => {
        let context = getContext(this) as common.UIAbilityContext;
        let want: Want = {
          bundleName: 'com.example.app',
          abilityName: 'EntryAbility'
        };
        context.startAbility(want);
      })
  }
}
```
> [查看完整示例](../assets/AbilityMigration.ets)

## 2. 故障日志 (`FaultLogger` -> `hiAppEvent`)

**弃用说明:**
`@ohos.faultLogger` 模块的部分查询接口已不再推荐使用。推荐使用 `@ohos.hiviewdfx.hiAppEvent` 来订阅应用的崩溃 (`APP_CRASH`) 和卡死 (`APP_FREEZE`) 事件，实现更主动的监控。

**旧写法:**
```typescript
import faultLogger from '@ohos.faultLogger';
let logs = await faultLogger.query(faultLogger.FaultType.JS_CRASH);
```

**现代写法:**
```typescript
import { hiAppEvent } from '@kit.PerformanceAnalysisKit';

hiAppEvent.addWatcher({
  name: "crashWatcher",
  appEventFilters: [
    {
      domain: hiAppEvent.domain.OS,
      names: [hiAppEvent.event.APP_CRASH, hiAppEvent.event.APP_FREEZE]
    }
  ],
  onReceive: (domain, appEventGroups) => {
    // 处理崩溃事件
    console.info(`Received crash event: ${JSON.stringify(appEventGroups)}`);
  }
});
```

## 3. 日志打印 (`console` -> `hilog`)

**建议:**
虽然 `console.log` 依然可用，但 `hilog` 提供了更规范的日志分级、标签过滤和性能优化，是生产环境的最佳实践。

**现代写法:**
```typescript
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG = 'MyApp';

hilog.info(DOMAIN, TAG, 'This is an info log: %{public}s', 'Value');
```
> [查看完整示例](../assets/LogMigration.ets)
