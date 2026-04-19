/**
 * Copyright (C), 2026-03-14
 * @author ZestBox
 * @date 2026-03-14
 * @version 1.0
 * @description: 常见问题页面
 */

import { hdsMaterial, HdsNavDestination, ScrollEffectType } from "@kit.UIDesignKit";
import { LengthMetrics } from "@kit.ArkUI";

@ComponentV2
export struct FAQ {
  @Local expandedIndex: number = -1;

  build() {
    HdsNavDestination() {
      Scroll() {
        Column() {
          this.FAQItem(0, '为什么手机无法发现电脑？', '1. 请确保手机和电脑在同一个 Wi-Fi 网络下。\n2. 检查电脑端的防火墙是否允许 CodeFlash 访问网络。\n3. 如果还是无法发现，请尝试在手机上重新点击“扫描”图标。')
          this.FAQItem(1, '自动推送功能没有生效？', '1. 请检查是否已经授权 CodeFlash 读取剪贴板权限。\n2. 确保在设置中开启了“自动推送”开关。\n3. 部分系统限制了后台读取剪贴板，请尝试保持应用在前端运行。')
          this.FAQItem(2, '为什么同步会有延迟？', '1. 网络延迟可能导致同步变慢，请确保 Wi-Fi 信号良好。\n2. 如果连接不稳定，请尝试重新启动电脑端的 CodeFlash 桌面应用。')
          this.FAQItem(3, '可以同步图片或文件吗？', '目前的版本主要专注于文本内容的同步，未来版本会考虑支持图片和文件的同步。')
          this.FAQItem(4, '支持多少台设备同时连接？', '目前手机端支持连接一台电脑（支持实时切换局域网中的电脑），电脑端可以接收多台手机的同步推送。')
          this.FAQItem(5, '数据传输安全吗？', 'CodeFlash 的数据传输仅在局域网内进行，不会上传到云端服务器，保障了数据的私密性和安全性。')
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
      content: { title: { mainTitle: "常见问题" } }
    })
  }

  @Builder
  FAQItem(index: number, question: string, answer: string) {
    Column() {
      Row() {
        Text(question)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        SymbolGlyph(this.expandedIndex === index ? $r('sys.symbol.chevron_up') : $r('sys.symbol.chevron_down'))
          .fontSize(16)
          .fontColor([$r('app.color.text_secondary')])
      }
      .width('100%')
      .padding(16)
      .onClick(() => {
        animateTo({ duration: 300, curve: Curve.FastOutSlowIn }, () => {
          this.expandedIndex = this.expandedIndex === index ? -1 : index;
        })
      })

      if (this.expandedIndex === index) {
        Column() {
          Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })
          Text(answer)
            .fontSize(14)
            .lineHeight(22)
            .fontColor($r('app.color.text_secondary'))
            .padding(16)
            .width('100%')
        }
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.combine(TransitionEffect.scale({ y: 0 })),
          TransitionEffect.OPACITY.combine(TransitionEffect.scale({ y: 0 }))
        ))
      }
    }
    .width('100%')
    .margin({ bottom: 12 })
    .backgroundColor($r('app.color.block_background'))
    .borderRadius(16)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .clip(true)
  }
}
