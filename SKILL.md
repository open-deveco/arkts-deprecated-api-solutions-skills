---
name: "harmonyos_deprecated_api_solutions"
description: "Provides solutions and replacements for deprecated HarmonyOS APIs (e.g., global animateTo, router). Invoke when user asks about deprecated APIs or upgrading legacy code."
---

# Deprecated API Solutions

This skill provides guidance on migrating from deprecated or discouraged APIs to their modern HarmonyOS equivalents (e.g., moving from global APIs to `UIContext` based APIs).

## Covered APIs

| API | Deprecated/Legacy Usage | Modern Replacement |
|-----|-------------------------|-------------------|
| `setOrCreate` | `AppStorage.setOrCreate` (Global) | `LocalStorage` or `AppStorage` with caution, prefer `UIContext` for context |
| `animateTo` | Global `animateTo(...)` | `this.getUIContext().animateTo(...)` |
| `getUIContext` | N/A | The core accessor for scoped APIs |
| `generateRandomSync` | `crypto` (Legacy) | `cryptoFramework` |
| `decodeToString` | `string` utilities | `util.TextDecoder` |
| `showToast` | `promptAction.showToast` (Global) | `this.getUIContext().getPromptAction().showToast(...)` |
| `getHostContext` | Global context access | `this.getUIContext().getHostContext()` |
| `getContext` | `getContext(this)` | `this.getUIContext().getHostContext()` with context parameter |
| `px2vp` | Global `px2vp` | `this.getUIContext().px2vp(...)` |
| `getRouter` | `@ohos.router` | `this.getUIContext().getRouter()` |
| `back` | `router.back()` | `this.getUIContext().getRouter().back()` |
| `pushUrl` | `router.pushUrl()` | `this.getUIContext().getRouter().pushUrl()` |
| `matchMediaSync` | `mediaquery.matchMediaSync(condition: string)` | `this.getUIContext().getMediaQuery().matchMediaSync(condition: string)` |
| `display.getDefaultDisplay` | `window.getDefaultDisplay()` | `display.getDefaultDisplaySync()` from `@kit.ArkGraphics` |
| `Scroll.onScroll` | `Scroll.onScroll((xOffset, yOffset) => void)` | `Scroll.onScroll((xOffset: number, yOffset: number) => void)` |
| `window.getLastWindow` | Async/await pattern | Callback pattern: `window.getLastWindow(context, (err, win) => { ... })` |
| `setWindowLayoutFullScreen` | Callback pattern | Promise pattern: `await win.setWindowLayoutFullScreen(true)` |
| `setWindowSystemBarProperties` | Callback pattern | Promise pattern: `await win.setWindowSystemBarProperties({...})` |
| `getTitleButtonRect` | Return type `window.Rect` | Return type `window.TitleButtonRect` |
| `AvoidArea` | Missing `visible` property | Add `visible: false` to AvoidArea initialization |
| `WindowMode` | Removed from API | Use boolean flag or custom state instead |
| `this` in standalone functions | Invalid usage | Pass context as parameter: `function foo(context: Context)` |
| `connect` | Legacy connection | `UIAbilityContext.connectServiceExtensionAbility` |
| `fileio` | `@ohos.fileio` | `@ohos.file.fs` |
| `backgroundTaskManager` | Old API 9 interfaces | `@ohos.resourceschedule.backgroundTaskManager` (New APIs) |
| `notification` | `@ohos.notification` | `@ohos.notificationManager` |
| `http` | `@ohos.net.http` | `@hms.collaboration.rcp` (Recommended) |
| `featureAbility` | FA Model Context | `UIAbilityContext` (Stage Model) |
| `FaultLogger` | `@ohos.faultLogger` | `@ohos.hiviewdfx.hiAppEvent` |
| `console` | `console.log` | `@ohos.hilog` (Recommended) |
| `window` | Global `window.getTopWindow` | `windowStage.getMainWindow` |
| `camera.Camera` | Old camera API | `camera.CameraManager` + `camera.Session` |
| `getSupportedOutputCapability` | Missing sceneMode parameter | Add `camera.SceneMode.NORMAL_VIDEO` parameter |
| `CameraInput.release()` | Non-existent method | Use `CameraInput.close()` instead |
| `imagePacker.packing()` | Deprecated method | Use `imagePacker.packToFile()` instead |
| `XComponent` import from `@kit.ArkUI` | Wrong import path | Use global XComponent without import |
| `globalThis` | Global context access | Use `UIContext`, `AppStorage`, or `LocalStorage` |
| `AppStorage.watch()` | Manual watch method | Use `@StorageLink` or `@StorageProp` decorators |
| `Configuration.densityDpi` | Screen density property | Use `display.getDefaultDisplaySync()` or `WindowProperties` |
| `TouchEvent` | Old API (touchPoint, pressure, tiltX/tiltY) | Use `event.touches`, `event.source` |
| `SideBarContainer` | Old API with boolean parameter | Use conditional layout instead |
| `SwiperItem` | Deprecated component | Use direct child components |

## Usage

### Detailed Migration Guides
- [getContext Migration](./reference/getcontext_migration.md)
- [Application Framework Migration (featureAbility, window, FaultLogger, hilog)](./reference/framework_migration.md)
- [UI Context Migration (animateTo, router, prompt, matchMediaSync, scroll)](./reference/ui_context_migration.md)
- [System Capabilities Migration (fileio, backgroundTask, window, display, notification)](./reference/system_migration.md)
- [Network Migration (http -> rcp)](./reference/network_migration.md)
- [Utility & Crypto Migration (generateRandomSync, decodeToString)](./reference/utility_migration.md)
- [State Management Migration (AppStorage)](./reference/state_migration.md)
- [Service Connection Migration (connect)](./reference/service_migration.md)
- [Camera API Migration (CameraManager, Session, PhotoOutput)](./reference/camera_migration.md)
- [globalThis Migration](./reference/globalthis_migration.md)
- [AppStorage watch Migration](./reference/appstorage_watch_migration.md)
- [Configuration densityDpi Migration](./reference/configuration_density_migration.md)
- [KeyEvent CtrlKey Migration](./reference/keyevent_ctrlkey_errors.md)
- [TouchEvent API Changes](./reference/touch_event_api_changes.md)
- [SideBarContainer API Changes](./reference/sidebarcontainer_api_changes.md)

### Code Examples
- [getContext Replacement](./assets/GetContextReplacement.ets)
- [Ability Migration](./assets/AbilityMigration.ets)
- [Animation Replacement](./assets/AnimationReplacement.ets)
- [Background Migration](./assets/BackgroundMigration.ets)
- [Camera Migration](./assets/CameraMigration.ets)
- [Display Replacement](./assets/DisplayReplacement.ets)
- [File Migration](./assets/FileMigration.ets)
- [Host Context Replacement](./assets/HostContextReplacement.ets)
- [Log Migration](./assets/LogMigration.ets)
- [Media Query Replacement](./assets/MediaQueryReplacement.ets)
- [Network Migration](./assets/NetworkMigration.ets)
- [Notification Migration](./assets/NotificationMigration.ets)
- [Prompt Replacement](./assets/PromptReplacement.ets)
- [Router Replacement](./assets/RouterReplacement.ets)
- [Screen Utils Replacement](./assets/ScreenUtilsReplacement.ets)
- [Scroll Event Replacement](./assets/ScrollEventReplacement.ets)
- [Service Connection Replacement](./assets/ServiceConnectionReplacement.ets)
- [State Management Replacement](./assets/StateManagementReplacement.ets)
- [Util Replacement](./assets/UtilReplacement.ets)
- [Window Migration](./assets/WindowMigration.ets)
- [Window Method Migration](./assets/WindowMethodMigration.ets)
- [AvoidArea Migration](./assets/AvoidAreaMigration.ets)
- [Standalone Function Context](./assets/StandaloneFunctionContext.ets)
- [GlobalThis Replacement](./assets/GlobalThisReplacement.ets)
- [AppStorage Watch Replacement](./assets/AppStorageWatchReplacement.ets)
- [Configuration Density Replacement](./assets/ConfigurationDensityReplacement.ets)
- [KeyEvent CtrlKey Replacement](./assets/KeyEventCtrlKeyError.ets)
- [TouchEvent API Demo](./assets/TouchEventAPIDemo.ets)
- [SideBarContainer API Demo](./assets/SideBarContainerAPIDemo.ets)

Refer to the documentation links above for detailed steps.
