export default class RandomColor {
  /**
   * 获取随机十六进制颜色
   * @returns 格式如 #RRGGBB 的随机颜色字符串
   */
  static get(): string {
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i++) {
      color += letters.charAt(Math.floor(Math.random() * letters.length));
    }
    return color;
  }
}
