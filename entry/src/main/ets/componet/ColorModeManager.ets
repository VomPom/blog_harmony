import { common, ConfigurationConstant } from "@kit.AbilityKit";
import { GlobalContext } from "./GlobalContext";
import { log } from "./Log";
import { ConfigRepository } from "./repository/ConfigRepository";

/**
 * Copyright (C) @2025 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Created by @juliswang on 2025/04/29 22:47
 *
 * @Description 夜览模式相关处理
 */
export class ColorModeManager {
  private static instance: ColorModeManager

  static getInstance(): ColorModeManager {
    if (ColorModeManager.instance === undefined) {
      ColorModeManager.instance = new ColorModeManager();
    }
    return ColorModeManager.instance;
  }

  isDark(): boolean {
    return ConfigRepository.getInstance().isDark()
  }

  init() {
    this.toggle(this.isDark())
  }

  toggle(isDark: boolean) {
    let colorMode = isDark ?
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK :
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT

    log('use color mode:' + colorMode.toString())
    GlobalContext.getContext().getApplicationContext().setColorMode(colorMode);
  }
}