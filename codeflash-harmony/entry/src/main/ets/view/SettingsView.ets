import { ConfigurationConstant, common, Want } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { pasteboard } from '@kit.BasicServicesKit';
import { CommonConstants } from '../constants/CommonConstants';
import { RouterUrlConstants } from '../constants/RouterUrlConstants';

@ComponentV2
export struct SettingsView {
  @Consumer(CommonConstants.PAGE_INFOS) pageInfos: NavPathStack = new NavPathStack();
  @Local bottomRectHeight: number = 0;
  @Param currentMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @Param manualMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @Param appName: string = 'CodeFlash';
  @Param appVersion: string = 'v1.0.0';
  @Event onModeChange: (mode: number) => void = () => {};
  @Event onClose: () => void = () => {};
  @Event onLinkClick: (title: string) => void = () => {};

  private readonly qqGroupId: string = '1034066735';
  private context = getContext(this) as common.UIAbilityContext;

  private copyToClipboard(text: string): void {
    try {
      const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
      const systemPasteboard = pasteboard.getSystemPasteboard();
      systemPasteboard.setData(pasteData).then(() => {
        promptAction.showToast({ message: `已复制：${text}` });
      }).catch(() => {
        promptAction.showToast({ message: '复制失败' });
      });
    } catch (e) {
      promptAction.showToast({ message: '复制出错' });
    }
  }

  private joinQQGroup(): void {
    const uri = `mqqapi://card/show_pslcard?src_type=internal&version=1&uin=${this.qqGroupId}&card_type=group&source=qrcode`;
    try {
      this.context.startAbility({ uri }).catch(() => {
        this.copyToClipboard(this.qqGroupId);
        promptAction.showToast({ message: `未能打开 QQ，已复制群号：${this.qqGroupId}` });
      });
    } catch (e) {
      this.copyToClipboard(this.qqGroupId);
      promptAction.showToast({ message: `未能打开 QQ，已复制群号：${this.qqGroupId}` });
    }
  }

  private isFollowSystem(): boolean {
    return this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  }

  private effectiveManualMode(): number {
    return this.isFollowSystem() ? this.manualMode : this.currentMode;
  }

  private modeIcon(): Resource {
    if (this.isFollowSystem()) {
      return $r('sys.symbol.circle_filled_and_circle');
    }

    return this.effectiveManualMode() === ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      ? $r('sys.symbol.moon_1')
      : $r('sys.symbol.sun_min');
  }
  aboutToAppear(): void {
    this.bottomRectHeight = AppStorage.get(CommonConstants.AVOID_RECT_HEIGHT_BOTTOM) || 0;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Column() {
            Image($r('app.media.startIcon'))
              .width(150)
              .height(150)
              .borderRadius(24)
              .margin({ bottom: 12 })

            Text(this.appName)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            Text(this.appVersion)
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .padding({ top: 8, bottom: 20 })

          Text('外观')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 8, top: 4 })
            .width('100%')

          Column() {
            Row() {
              SymbolGlyph(this.modeIcon())
                .fontSize(20)
                .fontColor([$r('app.color.text_primary')])
                .margin({ right: 12 })

              Text('跟随系统')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))

              Blank()

              Toggle({ type: ToggleType.Switch, isOn: this.isFollowSystem() })
                .selectedColor('#2FB04A')
                .switchPointColor('#FFFFFF')
                .onChange((isOn: boolean) => {
                  if (isOn) {
                    this.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
                    return;
                  }
                  this.onModeChange(this.manualMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK
                    ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK
                    : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
                })
            }
            .width('100%')
            .height(56)
            .padding({ left: 16, right: 16 })

            if (!this.isFollowSystem()) {
              Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })

              Row() {
                Text('颜色模式')
                  .fontSize(16)
                  .fontColor($r('app.color.text_primary'))

                Blank()

                Row() {
                  Stack() {
                    SymbolGlyph($r('sys.symbol.sun_min'))
                      .fontSize(18)
                      .fontColor([this.effectiveManualMode() === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? '#2FB04A' : $r('app.color.text_secondary')])
                  }
                  .padding(10)
                  .borderRadius(12)
                  .backgroundColor(this.effectiveManualMode() === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.color.action_bg') : Color.Transparent)
                  .onClick(() => {
                    this.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
                  })

                  Stack() {
                    SymbolGlyph($r('sys.symbol.moon_1'))
                      .fontSize(18)
                      .fontColor([this.effectiveManualMode() === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? '#2FB04A' : $r('app.color.text_secondary')])
                  }
                  .padding(10)
                  .borderRadius(12)
                  .backgroundColor(this.effectiveManualMode() === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('app.color.action_bg') : Color.Transparent)
                  .margin({ left: 8 })
                  .onClick(() => {
                    this.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
                  })
                }
              }
              .width('100%')
              .height(56)
              .padding({ left: 16, right: 16 })
            }
          }
          .backgroundColor($r('app.color.block_background'))
          .borderRadius(16)
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .clip(true)

          Text('帮助与反馈')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 8, top: 24 })
            .width('100%')

          Column() {
            this.LinkItem('使用说明', $r('sys.symbol.doc_text'))
            Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })
            this.LinkItem('常见问题', $r('sys.symbol.questionmark_circle'))
            Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })
            this.LinkItem('给个好评', $r('sys.symbol.hand_thumbsup_fill'))
            Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })
            this.LinkItem('投喂作者', $r('sys.symbol.gift_fill'))
          }
          .backgroundColor($r('app.color.block_background'))
          .borderRadius(16)
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .clip(true)

          Text('关于')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 8, top: 24 })
            .width('100%')
          
          Column() {
            this.AboutItem('联系邮箱', 'zestbox@163.com', $r('sys.symbol.envelope'))

            Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })

            this.AboutItem('QQ群聊', this.qqGroupId, $r('sys.symbol.person_3'), '#2F80ED', () => {
              this.joinQQGroup();
            })
            Divider().color($r('app.color.divider_color')).strokeWidth(0.5).padding({ left: 16, right: 16 })

            this.AboutItem('电脑端', 'https://codeflash.zestbox.cn/', $r('sys.symbol.pc'))
          }
          .backgroundColor($r('app.color.block_background'))
          .borderRadius(16)
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .clip(true)

          Text('粤ICP备2024282649号-2A')
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 24 })
            .width('100%')
            .textAlign(TextAlign.Center)
            .onClick(() => {
              const want: Want = {
                action: 'ohos.want.action.viewData',
                entities: ['entity.system.browsable'],
                uri: 'http://beian.miit.gov.cn/'
              };
              this.context.startAbility(want);
            })

        }
        .width('100%')
        .padding({ bottom: 120 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .padding({ left: 16, right: 16, top: 16 ,bottom:this.bottomRectHeight})
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder ModeItem(text: string, mode: number) {
    Row() {
      Text(text)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
      
      Blank()
      
      if (this.currentMode === mode) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .fontSize(18)
          .fontColor(['#2FB04A'])
          .fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
    .height(48)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.Transparent)
    .onClick(() => {
      this.onModeChange(mode);
    })
  }

  @Builder LinkItem(text: string, icon: Resource, iconColor: ResourceColor = '#2FB04A') {
    Row() {
      SymbolGlyph(icon)
        .fontSize(20)
        .fontColor([iconColor])
        .margin({ right: 12 })
      
      Text(text)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
      
      Blank()
      
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(14)
        .fontColor([$r('app.color.text_secondary')])
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.Transparent)
      .onClick(() => {
        if (text == '投喂作者') {
          this.pageInfos.pushPath({ name: RouterUrlConstants.SPONSORSHIP })
          return
        }
        if (text == '使用说明') {
          this.pageInfos.pushPath({ name: RouterUrlConstants.USER_GUIDE })
          return
        }
        if (text == '常见问题') {
          this.pageInfos.pushPath({ name: RouterUrlConstants.FAQ })
          return
        }
        this.onLinkClick(text);

      })
  }

  @Builder AboutItem(label: string, value: string, icon: Resource, valueColor: ResourceColor = $r('app.color.text_secondary'), onValueClick?: () => void) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(20)
        .fontColor(['#2FB04A'])
        .margin({ right: 12 })

      Text(label)
        .fontSize(15)
        .fontColor($r('app.color.text_primary'))

      Blank()

      Text(value)
        .fontSize(14)
        .fontColor(valueColor)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .gesture(
          LongPressGesture()
            .onAction(() => {
              this.copyToClipboard(value);
            })
        )
        .onClick(() => {
          if (onValueClick) {
            onValueClick();
          }
        })
    }
    .width('100%')
    .padding({ top: 12, bottom: 12, left: 16, right: 16 })
  }
}
