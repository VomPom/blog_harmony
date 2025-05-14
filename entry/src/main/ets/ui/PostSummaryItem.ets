import TimeUtils from "../componet/utils/TimeUtils";

import { Post } from "../model/Post";
import { Tag } from "../model/Tag";
import { Category } from "../model/Category";
import TagItem from "./TagItem";
import CategoryItem from "./CaregoryItem";
import { webview } from "@kit.ArkWeb";
import { calLetter } from "../componet/utils/StatsUtils";

/**
 * Created by @juliswang on 2025/04/21 22:25
 *
 * @Description 内容简要
 */
export enum PostItemScene {
  DEFAULT = 0, // 默认展示所有数据
  ALL_POST = 1, // 展示所有信息
  CHARACTER = 2 // 展示统计字数
}

@Preview
@Component
export default struct PostSummaryItem {
  index: number = 0
  scene: PostItemScene = PostItemScene.DEFAULT
  data: Post = {
    "title": "Android屏幕刷新机制",
    "slug": "Android屏幕刷新机制",
    "date": "2025-02-24T02:49:00.000Z",
    "updated": "2025-04-02T08:49:45.597Z",
    "comments": true,
    "content": '<p>最近在研究 Android 屏幕显示与渲染相关的内容，平时经常看到这些类 <code>ViewRootImpl</code>、<code>Choreographer</code>、<code>Surface</code> 、 <code>SurfaceFlinger</code>等，知道它们都用于屏幕渲染相关，但对它们细节了解较少，相关的文章也比较多，不需要自己完全重新再编写一份，于是对相关内容进行一个总结,<br>主要来源：<a href=\\"https://juejin.cn/post/6863756420380196877\\">《Android屏幕刷新机制—VSyncChoreographer 全面理解》</a>，这篇博客是我认为是目前看到过最好的一篇，文章由浅入深比较好理解。不过文章里面图片链接资源已经失效，为以后复习相关知识点，在此将其整理删除冗余内容，并对图片资源进行更新。</p>\\n<h2 id=\\"一、背景和疑问\\"><a href=\\"#一、背景和疑问\\" class=\\"headerlink\\" title=\\"一、背景和疑问\\"></a><strong>一、背景和疑问</strong></h2><p>在Android中，当我们谈到 <strong>布局优化</strong>、<strong>卡顿优化</strong> 时，通常都知道 需要减少布局层级、减少主线程耗时操作，这样可以减少<strong>丢帧</strong>。如果丢帧比较严重，那么界面可能会有明显的卡顿感。我们知道 通常手机刷新是每秒60次，即每隔16.6ms刷新一次。 问题来了：</p>\\n<ol>\\n<li><strong>丢帧</strong>(掉帧) ，是说 这一帧延迟显示 还是丢弃不再显示 ？</li>\\n<li>布局层级较多&#x2F;主线程耗时 是如何造成 丢帧的呢？</li>\\n<li>16.6ms刷新一次 是啥意思？是每16.6ms都走一次 measure&#x2F;layout&#x2F;draw ？</li>\\n<li>measure&#x2F;layout&#x2F;draw 走完，界面就立刻刷新了吗?</li>\\n<li>如果界面没动静止了，还会刷新吗？</li>\\n<li>可能你知道<strong>VSYNC</strong>，这个具体指啥？在屏幕刷新中如何工作的？</li>\\n<li>可能你还听过屏幕刷新使用 <strong>双缓存</strong>、<strong>三缓存</strong>，这又是啥意思呢？</li>\\n<li>可能你还听过神秘的<strong>Choreographer</strong>，这又是干啥的？</li>\\n</ol>\\n<h2 id=\\"二、显示系统基础知识\\"><a href=\\"#二、显示系统基础知识\\" class=\\"headerlink\\" title=\\"二、显示系统基础知识\\"></a><strong>二、显示系统基础知识</strong></h2><p>在一个典型的显示系统中，一般包括CPU、GPU、Display三个部分， CPU负责计算帧数据，把计算好的数据交给GPU，GPU会对图形数据进行渲染，渲染好后放到buffer(图像缓冲区)里存起来，然后Display（屏幕或显示器）负责把buffer里的数据呈现到屏幕上。如下图：</p>\\n<p><img src=\\"/img/0nq54q5jtq.jpeg\\" alt=\\"GPU-Buffer\\"></p>\\n<p>单缓存，从缓存映射到屏幕。</p>\\n<h3 id=\\"2-1-基础概念\\"><a href=\\"#2-1-基础概念\\" class=\\"headerlink\\" title=\\"2.1 基础概念\\"></a><strong>2.1 基础概念</strong></h3><ul>\\n<li><strong>屏幕刷新频率</strong> 一秒内屏幕刷新的次数（一秒内显示了多少帧的图像），单位 Hz（赫兹），如常见的 60 Hz。<strong>刷新频率取决于硬件的固定参数</strong>（不会变的）。</li>\\n<li><strong>逐行扫描</strong> 显示器并',
    "url": "2025/02/24/Android屏幕刷新机制/",
    "excerpt": "",
    "cover": null,
    "images": [],
    "categories": [{
      "name": "技术文章",
      "slug": "technology",
      "api": "api/categories/technology.json"
    }
    ],
    "tags": [
      {
        "name": "安卓",
        "slug": "Android",
        "api": "api/tags/Android.json"
      }
    ],
    "api": "api/posts/2025/02/24/Android屏幕刷新机制.json",
  }

  build() {
    Stack() {
      Column() {
        this.Title()
        Blank().height(3)
        if (this.scene === PostItemScene.DEFAULT) {
          this.TimeAndCategories()
          Blank().height(5)
          this.Summary()
          Blank().height(5)
          this.Tags()
        }
      }
      .alignItems(HorizontalAlign.Start)
    }
    .shadow({
      radius: 1,
      offsetY: 0,
      offsetX: 0,
      color: "#bfbfbf"
    })
    .width('95%')
    .padding(5)
    .margin({
      bottom: 8,
      top: 3
    })
    .borderColor(Color.Gray)
    .borderRadius(5)
    .backgroundColor($r("app.color.content_bg"))
    .alignContent(Alignment.Start)
  }

  @Builder
  Title() {
    if (this.scene === PostItemScene.CHARACTER) {
      Text(`[${calLetter(this.data)}字]`)
        .fontSize(10)
    }
    Text(this.data.title)
      .fontSize(16)
      .fontWeight(500)
      .fontColor($r("app.color.text_content"))
      .margin({
        top: 3
      })
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }

  @Builder
  TimeAndCategories() {
    Row() {
      Stack() {
        Text(`[${this.index}]`)
          .fontSize(10)
          .fontWeight(500)
          .fontColor($r("app.color.text_content"))
      }
      .alignContent(Alignment.Center)
      .borderRadius(5)
      .width(22)
      .height(12)
      .margin({ right: 2 })
      .backgroundColor($r('app.color.tag_bg'))

      Text(TimeUtils.format1(this.data.date))
        .fontSize(12)
        .fontWeight(500)
        .fontColor($r("app.color.post_time"))

      Column() {
        ForEach(this.data.categories, (category: Category) => {
          CategoryItem({ data: category })
        })
      }
    }
  }

  @Builder
  Summary() {
    Text(this.data.content?.replace(/<[^>]*>/g, '').substring(0, 500))
      .maxLines(5)
      .fontSize(13)
      .borderRadius(5)
      .padding({
        left: 5,
        right: 5,
        top: 8,
        bottom: 8
      })
      .backgroundColor($r('app.color.summary_bg'))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin({
        top: 3,
        bottom: 3,
      })

  }

  @Builder
  Tags() {
    Row() {
      ForEach(this.data.tags, (tag: Tag) => {
        TagItem({ data: tag })
          .margin({ right: 5 })
      })
    }.margin({
      bottom: 5
    })
  }
}