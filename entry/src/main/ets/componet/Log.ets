import { hilog } from "@kit.PerformanceAnalysisKit";

export function log(msg: string, tag: string = '') {
  hilog.debug(0, tag, msg)
}