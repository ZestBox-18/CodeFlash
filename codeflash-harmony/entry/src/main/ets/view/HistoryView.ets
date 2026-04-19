import { HistoryItem } from '../model/History';
import { pasteboard } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

@ComponentV2
export struct HistoryView {
  @Param historyList: HistoryItem[] = [];
  
  @Event onDelete: (id: number) => void = () => {};
  @Event onClear: () => void = () => {};

  build() {
    Column() {
      // Header
      Row() {
        Text('传输历史')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
        
        Blank()
        
        if (this.historyList.length > 0) {
          Row() {
            SymbolGlyph($r('sys.symbol.trash'))
              .fontSize(16)
              .fontColor([$r('app.color.text_secondary')])
              .margin({ right: 4 })
            Text('清空')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
          }
          .onClick(() => {
            promptAction.showDialog({
              title: '清空历史',
              message: '确定要清空所有传输记录吗？',
              buttons: [
                { text: '取消', color: '#666666' },
                { text: '清空', color: '#FF4D4F' }
              ]
            }).then((resp) => {
              if (resp.index === 1) {
                this.onClear();
              }
            });
          })
          .padding({ top: 8, bottom: 8, left: 12, right: 12 })
          .backgroundColor($r('app.color.action_bg'))
          .borderRadius(20)
        }
      }
      .width('100%')
      .padding({ top: 16, bottom: 16, left: 20, right: 20 })
      .backgroundColor($r('app.color.page_background'))

      if (this.historyList.length === 0) {
        Column() {
          SymbolGlyph($r('sys.symbol.clock'))
            .fontSize(48)
            .fontColor([$r('app.color.text_secondary')])
            .margin({ bottom: 12 })
          Text('暂无传输记录')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .padding({ top: 60, bottom: 60 })
        .justifyContent(FlexAlign.Center)
      } else {
        Column({ space: 12 }) {
          ForEach(this.historyList, (item: HistoryItem) => {
            this.HistoryItemBuilder(item)
          }, (item: HistoryItem) => JSON.stringify(item.id))
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 24 })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder HistoryItemBuilder(item: HistoryItem) {
    Column() {
      // Header: Icon + Info
      Row() {
        // Icon Container
        Stack() {
          Circle({ width: 36, height: 36 })
            .fill(item.type === 'push' 
              ? $r('app.color.icon_bg_push')
              : $r('app.color.icon_bg_pull'))
          SymbolGlyph(item.type === 'push' ? $r('sys.symbol.arrow_up') : $r('sys.symbol.arrow_down'))
            .fontSize(20)
            .fontColor([item.type === 'push' ? '#2FB04A' : '#0A59F7'])
        }
        .margin({ right: 12 })

        // Info
        Column({ space: 4 }) {
          Text(item.type === 'push' ? `发送至 ${item.device}` : `来自 ${item.device}`)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
          Text(this.formatTime(item.timestamp))
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // Content
      Text(item.content)
        .fontSize(15)
        .fontColor($r('app.color.text_content'))
        .maxLines(4)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ top: 12, bottom: 16 })
        .lineHeight(24)
        .copyOption(CopyOptions.LocalDevice)

      // Divider
      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(0.5)
        .margin({ bottom: 12 })

      // Footer Actions
      Row() {
        // Delete Button
        Row() {
          SymbolGlyph($r('sys.symbol.trash'))
            .fontSize(16)
            .fontColor([$r('app.color.text_secondary')])
            .margin({ right: 4 })
          Text('删除')
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
        }
        .padding({ top: 6, bottom: 6, right: 12 })
        .onClick(() => {
          this.onDelete(item.id);
        })

        Blank()

        // Copy Button
        Button() {
          Row() {
            SymbolGlyph($r('sys.symbol.square_and_cut'))
              .fontSize(16)
              .fontColor([Color.White])
              .margin({ right: 6 })
            Text('复制')
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
          }
        }
        .height(32)
        .backgroundColor('#2FB04A')
        .padding({ left: 16, right: 16 })
        .borderRadius(16)
        .onClick(() => {
          try {
            const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, item.content);
            const systemPasteboard = pasteboard.getSystemPasteboard();
            systemPasteboard.setData(pasteData).then(() => {
              promptAction.showToast({ message: '已复制到剪贴板' });
            }).catch((err: object) => {
              promptAction.showToast({ message: '复制失败' });
            });
          } catch (e) {
            promptAction.showToast({ message: '复制出错' });
          }
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .padding(16)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .transition(TransitionEffect.OPACITY.combine(TransitionEffect.translate({ y: 20 })).animation({ duration: 300 }))
  }

  formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const now = new Date();
    // 简单的相对时间
    const diff = now.getTime() - timestamp;
    if (diff < 60000) return '刚刚';
    if (diff < 3600000) return `${Math.floor(diff / 60000)}分钟前`;
    if (date.toDateString() === now.toDateString()) {
      return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
    }
    return `${date.getMonth() + 1}/${date.getDate()}`;
  }
}