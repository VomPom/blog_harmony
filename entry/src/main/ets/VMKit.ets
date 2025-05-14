import { common } from "@kit.AbilityKit";
import { MMKV } from "@tencent/mmkv";
import { ColorModeManager } from "./componet/ColorModeManager";
import { GlobalContext } from "./componet/GlobalContext";

/**
 * Created by @juliswang on 2025/05/13 21:40
 *
 * @Description
 */
export class VMKit {
  static init(context: common.UIAbilityContext) {
    GlobalContext.init(context)
    VMKit.initMMKV(context)
    ColorModeManager.getInstance().init()
  }

  private static initMMKV(context: common.UIAbilityContext) {
    let appCtx = context.getApplicationContext();
    let mmkvRootDir = MMKV.initialize(appCtx);
    console.info('mmkv rootDir: ', mmkvRootDir);
  }
}