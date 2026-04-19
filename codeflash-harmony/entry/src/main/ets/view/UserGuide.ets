/**
 * Copyright (C), 2026-03-14
 * @author ZestBox
 * @date 2026-03-14
 * @version 1.0
 * @description: 使用说明页面
 */

import { hdsMaterial, HdsNavDestination, ScrollEffectType } from "@kit.UIDesignKit";
import { LengthMetrics } from "@kit.ArkUI";

@ComponentV2
export struct UserGuide {
  build() {
    HdsNavDestination() {
      Scroll() {
        Column() {
          this.SectionTitle('快速入门')
          this.GuideCard('1. 电脑端准备', '在你的电脑上下载并运行 CodeFlash 桌面端 https://codeflash.zestbox.cn/。确保手机和电脑连接在同一个局域网（同一个 Wi-Fi）下。', $r('sys.symbol.pc'))
          this.GuideCard('2. 自动连接', '打开手机端 CodeFlash，应用会自动扫描局域网内的电脑。发现设备后会自动尝试连接。', $r('sys.symbol.airplayaudio'))
          this.GuideCard('3. 手动连接', '如果无法自动连接，可以点击首页的“扫描”图标，手动选择发现的设备。', $r('sys.symbol.plus_circle'))

          this.SectionTitle('核心功能')
          this.GuideCard('双向同步', '点击首页的“推送”将手机剪贴板内容发送到电脑；点击“拉取”将电脑剪贴板内容同步到手机。', $r('sys.symbol.swap'))
          this.GuideCard('自动推送', '开启自动推送功能后，当你在手机上复制文本时，CodeFlash 会自动将其发送到已连接的电脑。', $r('sys.symbol.bolt_fill'))
          this.GuideCard('历史记录', '首页下方会保存最近的同步记录，点击记录可以重新复制或删除。', $r('sys.symbol.clock_arrow_2_circlepath'))

          this.SectionTitle('注意事项')
          this.GuideCard('权限说明', '为了实现自动推送，应用需要读取剪贴板权限，请在弹出申请时点击允许。', $r('sys.symbol.lock_shield'))
          this.GuideCard('后台运行', '为了保持连接稳定，建议将应用加入后台白名单，避免系统自动清理。', $r('sys.symbol.gearshape'))
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 40 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r('app.color.page_background'))
    }
    .titleBar({
      padding: {
        start: LengthMetrics.vp(20),
        end: LengthMetrics.vp(2)
      },
      style: {
        // 设置导航组件标题栏样式
        // 标题栏动态模糊样式，包括是否使能滚动动态模糊，动态模糊类型，动态模糊生效的滚动距离等
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: ScrollEffectType.IMMERSIVE_GRADIENT_BLUR,
          blurEffectiveStartOffset: LengthMetrics.vp(0),
          blurEffectiveEndOffset: LengthMetrics.vp(20)
        },
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
        },
        originalStyle: {
          // 内容区滚动前初始样式设置
          backgroundStyle: {
            // 标题栏背板样式设置
            backgroundColor: $r('app.color.title_bar_bg'),
          },
          contentStyle: {
            // 标题栏内容区样式设置，包括标题区域，菜单区域，返回按钮区域
            titleStyle: {
              mainTitleColor: $r('app.color.text_primary'),
              subTitleColor: $r('app.color.text_secondary')
            },
            menuStyle: {
              backgroundColor: $r('app.color.action_bg'),
              iconColor: $r('app.color.text_primary')
            },
            backIconStyle: {
              backgroundColor: $r('app.color.action_bg'),
              iconColor: $r('app.color.text_primary')
            }
          }
        },
        scrollEffectStyle: {
          // 内容区滚动超过blurEffectiveEndOffset后样式设置
          backgroundStyle: {
            backgroundColor: $r('app.color.title_bar_bg'),
          },
          contentStyle: {
            titleStyle: {
              mainTitleColor: $r('app.color.text_primary'),
              subTitleColor: $r('app.color.text_secondary'),
            },
            menuStyle: {
              backgroundColor: $r('app.color.action_bg'),
              textColor:  $r('app.color.text_secondary')
            },
            backIconStyle: {
              backgroundColor: $r('app.color.action_bg'),
              iconColor: $r('app.color.text_primary')
            }
          }
        }
      },
      content: { title: { mainTitle: "使用说明" } }
    })
  }

  @Builder
  SectionTitle(title: string) {
    Text(title)
      .fontSize(14)
      .fontColor($r('app.color.text_secondary'))
      .margin({ top: 24, bottom: 8, left: 4 })
      .width('100%')
  }

  @Builder
  GuideCard(title: string, content: string, icon: Resource) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(24)
        .fontColor([$r('app.color.brand')])
        .margin({ right: 16, top: 4 })
        .alignSelf(ItemAlign.Start)

      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 4 })

        Text(content)
          .fontSize(14)
          .lineHeight(20)
          .fontColor($r('app.color.text_secondary'))
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .margin({ bottom: 12 })
    .backgroundColor($r('app.color.block_background'))
    .borderRadius(16)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }
}
