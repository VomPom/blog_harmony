import { Post } from "../../model/Post";
import { log } from "../Log";

/**
 * 计算所有的文章字数(只计算汉字)
 * @param allPost
 */
export function calLetters(allPost: Post[]): number {
  return allPost.reduce((total, post) => {
    let cnt = countChineseChars(post.content);
    log(`字数统计 [${cnt}]-> ${post.title}`)
    return total + cnt;
  }, 0);
}

export function calLetter(post: Post): number {
  return countChineseChars(post.content);
}

function countChineseChars(str: string | undefined): number {
  if (!str) {
    return 0;
  } // 处理 undefined 或空字符串
  const chineseRegex = /[\u4e00-\u9fa5]/g; // 匹配汉字的正则表达式
  const matches = str.match(chineseRegex);
  return matches ? matches.length : 0;
}