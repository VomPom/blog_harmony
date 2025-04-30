/**
 * Copyright (C) @2025 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Created by @juliswang on 2025/04/29 22:53
 *
 * @Description 全局 Context 处理
 */
import { common } from "@kit.AbilityKit";

export class GlobalContext {
  private static context: common.UIAbilityContext; //common.UIAbilityContext，上下文

  static init(context: common.UIAbilityContext) {
    GlobalContext.context = context;
  }

  static getContext(): common.UIAbilityContext {
    if (!GlobalContext.context) {
      GlobalContext.context = getContext() as common.UIAbilityContext; //兜底
      throw new Error('check GlobalContext if has initialized.')
    }
    return GlobalContext.context;
  }
}