# HarmonyOS 废弃 API 迁移解决方案Skills

> 专为 AI 辅助开发 HarmonyOS 应用设计的已废弃 API 迁移指南和现代替代方案

## 📖 项目背景

在使用 AI 模型（如Claude、Gemini、GLM 等）开发 HarmonyOS 应用时，我们发现了一个问题：

- **AI 模型经常生成 API 11+ 之后已被弃用的 API**
- **AI 模型不了解 HarmonyOS API 的演进历史**，生成的代码使用了过时的 API
- **需要开发者反复手动将旧 API 迁移到新 API**，严重影响开发效率

例如，AI 经常生成：
- 全局 `animateTo()` 而不是 `this.getUIContext().animateTo()`
- 全局 `router.pushUrl()` 而不是 `this.getUIContext().getRouter().pushUrl()`
- `@ohos.fileio` 而不是 `@ohos.file.fs`
- `@ohos.notification` 而不是 `@ohos.notificationManager`
- `featureAbility` 而不是 `UIAbilityContext`
- 等等...

为了解决这个问题，我们开发了这个 **废弃 API 迁移解决方案Skills**，旨在：

✅ **提高 AI 开发效率** - 让 AI 模型能够自动使用现代 API  
✅ **减少迁移工作** - 避免反复将旧 API 迁移到新 API  
✅ **提供迁移指南** - 每个 API 都配有详细的迁移步骤和代码示例  

## 🎯 项目目标

本Skills收集并整理了 **51+ 个废弃的 HarmonyOS API**，每个 API 都包含：

- 📝 旧 API 的用法说明
- ✅ 现代替代 API 的用法
- 🔄 详细的迁移步骤
- 💡 最佳实践建议
- 📚 完整的代码示例

## 📦 内容概览

### API 分类

| API 类别 | 数量 | 说明 |
|---------|------|------|
| **UI 上下文 API** | 8+ | animateTo、router、prompt、matchMediaSync 等 |
| **系统能力 API** | 10+ | fileio、backgroundTask、window、display、notification 等 |
| **应用框架 API** | 6+ | featureAbility、window、FaultLogger、hilog 等 |
| **网络 API** | 2+ | http、rcp 等 |
| **工具类 API** | 5+ | crypto、util、globalThis 等 |
| **状态管理 API** | 3+ | AppStorage、LocalStorage 等 |
| **相机 API** | 4+ | Camera、CameraManager、Session 等 |
| **其他 API** | 13+ | 服务连接、滚动事件、配置等 |

### 主要迁移场景

- ✅ **全局 API → UIContext API** - 从全局 API 迁移到基于 UIContext 的作用域 API
- ✅ **旧模块 → 新模块** - 从旧模块迁移到新模块（如 fileio → file.fs）
- ✅ **回调模式 → Promise 模式** - 从回调模式迁移到 Promise/async-await
- ✅ **FA 模型 → Stage 模型** - 从 Feature Ability 模型迁移到 Stage 模型
- ✅ **旧接口 → 新接口** - 从旧接口迁移到新接口（如 Camera → CameraManager）

## 🚀 使用方法

### 作为 AI Skill 使用

本仓库设计为 AI 开发工具的 Skill，可以直接被 AI 模型调用：

1. **配置 Skill**：将本仓库添加到你的 AI 开发工具（如 Cursor）的 Skills 目录
2. **自动识别**：AI 模型在生成代码时会自动使用现代 API
3. **减少迁移**：AI 生成的代码将直接使用 API 11+ 的现代 API，无需后续迁移

### 手动查阅

你也可以直接查阅迁移指南和代码示例：

- 📚 **迁移指南**：查看 `reference/` 目录下的详细迁移文档
- 💻 **代码示例**：查看 `assets/` 目录下的完整迁移示例

## 📁 目录结构

```
deprecated_api_solutions/
├── README.md                 # 本文件
├── SKILL.md                  # Skill 配置文件
├── assets/                   # 代码示例目录
│   ├── AnimationReplacement.ets
│   ├── RouterReplacement.ets
│   ├── FileMigration.ets
│   └── ... (28+ 个示例文件)
└── reference/                # 迁移指南目录
    ├── ui_context_migration.md
    ├── system_migration.md
    ├── framework_migration.md
    └── ... (15+ 个迁移文档)
```

## 💡 使用示例

### 问题场景

AI 生成代码时经常使用废弃的 API：

```typescript
// ❌ AI 经常生成的废弃代码
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct MyComponent {
  navigateToDetail() {
    router.pushUrl({ url: 'pages/Detail' });
  }
  
  showMessage() {
    promptAction.showToast({ message: 'Hello' });
  }
  
  animate() {
    animateTo({ duration: 1000 }, () => {
      // animation
    });
  }
}
```

### 解决方案

参考本仓库的迁移指南，AI 可以生成使用现代 API 的代码：

```typescript
// ✅ 使用现代 API 的正确代码
@Entry
@Component
struct MyComponent {
  navigateToDetail() {
    const router = this.getUIContext().getRouter();
    router.pushUrl({ url: 'pages/Detail' });
  }
  
  showMessage() {
    this.getUIContext().getPromptAction().showToast({ message: 'Hello' });
  }
  
  animate() {
    this.getUIContext().animateTo({ duration: 1000 }, () => {
      // animation
    });
  }
}
```

## 📋 已覆盖的 API

### UI 上下文相关

| 旧 API | 新 API |
|--------|--------|
| 全局 `animateTo()` | `this.getUIContext().animateTo()` |
| `@ohos.router` | `this.getUIContext().getRouter()` |
| `promptAction.showToast()` | `this.getUIContext().getPromptAction().showToast()` |
| 全局 `px2vp()` | `this.getUIContext().px2vp()` |
| `mediaquery.matchMediaSync()` | `this.getUIContext().getMediaQuery().matchMediaSync()` |

### 系统能力相关

| 旧 API | 新 API |
|--------|--------|
| `@ohos.fileio` | `@ohos.file.fs` |
| `@ohos.notification` | `@ohos.notificationManager` |
| `@ohos.faultLogger` | `@ohos.hiviewdfx.hiAppEvent` |
| `console.log` | `@ohos.hilog` |
| `window.getDefaultDisplay()` | `display.getDefaultDisplaySync()` |

### 应用框架相关

| 旧 API | 新 API |
|--------|--------|
| `featureAbility` | `UIAbilityContext` |
| `window.getTopWindow()` | `windowStage.getMainWindow()` |
| `connect()` | `UIAbilityContext.connectServiceExtensionAbility()` |

### 相机相关

| 旧 API | 新 API |
|--------|--------|
| `camera.Camera` | `camera.CameraManager` + `camera.Session` |
| `CameraInput.release()` | `CameraInput.close()` |
| `imagePacker.packing()` | `imagePacker.packToFile()` |

### 状态管理相关

| 旧 API | 新 API |
|--------|--------|
| `AppStorage.watch()` | `@StorageLink` / `@StorageProp` |
| `globalThis` | `UIContext` / `AppStorage` / `LocalStorage` |

查看 [SKILL.md](./SKILL.md) 获取完整的 API 列表。


## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

如果你发现了新的废弃 API，或者有更好的迁移方案，欢迎贡献：

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingMigration`)
3. 提交你的更改 (`git commit -m 'Add some AmazingMigration'`)
4. 推送到分支 (`git push origin feature/AmazingMigration`)
5. 开启一个 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情


---

**让 AI 开发 HarmonyOS 应用更高效！** 🚀

