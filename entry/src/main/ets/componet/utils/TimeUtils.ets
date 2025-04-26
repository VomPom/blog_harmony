export default class TimeUtils {
  /**
   * time format transfer.
   * eg.
   * 2025-02-24T02:49:00.000Z to 2025年03月30日
   *
   * @param dateString
   * @returns
   */
  static format1(dateStr: string, useUTC: boolean = false): string {
    const date = new Date(dateStr)
    const year = useUTC ? date.getUTCFullYear() : date.getFullYear();
    const month = (useUTC ? date.getUTCMonth() : date.getMonth()) + 1;
    const day = useUTC ? date.getUTCDate() : date.getDate();

    // 补零处理
    const pad = (num: number) => num.toString().padStart(2, '0');

    return `${year}年${pad(month)}月${pad(day)}日`;
  }

  /**
   * time format transfer.
   * eg.
   * 2025-02-24T02:49:00.000Z to 2025年03月30日
   *
   * @param dateString
   * @returns
   */
  static format2(timestamp: number): string {
    const date = new Date(timestamp);

    // 提取各时间部分
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份补零
    const day = String(date.getDate()).padStart(2, '0'); // 日期补零
    const hours = String(date.getHours()).padStart(2, '0'); // 小时补零
    const minutes = String(date.getMinutes()).padStart(2, '0'); // 分钟补零
    const seconds = String(date.getSeconds()).padStart(2, '0'); // 秒补零

    // 组合成目标格式
    return `${year}.${month}.${day} ${hours}:${minutes}:${seconds}`;
  }
}
