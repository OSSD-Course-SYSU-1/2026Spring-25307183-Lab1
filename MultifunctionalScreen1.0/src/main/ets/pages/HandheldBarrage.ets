/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Settings } from '../model/Settings';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'HandheldBarrage';

@ComponentV2
export struct HandheldBarrage {
  @Local content: string = '欢迎学习鸿蒙开发';
  @Local fontSize: number = 88;
  @Local fontWeight: FontWeight = FontWeight.Regular;
  @Local selectedIndex: number = 0;
  @Local showSheet: boolean = false;
  @Local colorIndex: number = 0;
  @Local fontSizeFlag: string = '小';
  fontWeights: FontWeight[] = [FontWeight.Regular, FontWeight.Medium, FontWeight.Bold];
  colors: string[] = ['#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF'];
  pathInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    hilog.info(0x0000, TAG, 'aboutToAppear: Starting');
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          // 预览区
          Column() {
            Text('预览')
              .fontSize(14)
              .fontColor('#99000000')
              .fontWeight(FontWeight.Medium)
              .margin({ left: 28 })

            // 弹幕预览框 - 使用TextOverflow.MARQUEE实现跑马灯滚动
            Column() {
              Row() {
                Text(this.content)
                  .textOverflow({ overflow: TextOverflow.MARQUEE })
                  .marqueeOptions({
                    start: true
                  })
                  .fontSize(this.fontSize / 1.8)
                  .fontColor(this.colorIndex === 4 ? '#FF0000' : this.colors[this.colorIndex])
                  .fontWeight(this.fontWeight)
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
            }
            .width('100%')
            .height(199)
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [
                ['#013C9C', 0.0],
                ['#3066E4', 0.5],
                ['#43A1F4', 1.0]
              ]
            })
            .borderRadius(16)
            .padding({ top: 24, right: 16, bottom: 24, left: 16 })
          }
          .width('100%')
          .margin({ top: 28 })
          .alignItems(HorizontalAlign.Start)

          // 操作区
          Column() {
            // 弹幕内容区
            Column() {
              Text('弹幕内容')
                .fontSize(14)
                .fontColor('#99000000')
                .fontWeight(FontWeight.Medium)
                .margin({ left: 12 })

              TextArea({ text: this.content })
                .backgroundColor(Color.White)
                .maxLength(50)
                .showCounter(true, {
                  thresholdPercentage: 1,
                  highlightBorder: true
                })
                .height(72)
                .padding({ top: 8, right: 16, bottom: 8, left: 16 })
                .margin({ top: 8 })
                .borderRadius(16)
                .onChange((value: string) => {
                  this.content = value;
                })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 28, bottom: 28 })

            // 显示设置区
            Column() {
              Text('显示设置')
                .fontSize(14)
                .fontColor('#99000000')
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 8, left: 12 })

              Column() {
                // 字体大小调节
                Column() {
                  Row() {
                    Text('字体大小')
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)

                    Text(this.fontSizeFlag)
                      .fontSize(14)
                  }
                  .width('100%')
                  .height(48)
                  .justifyContent(FlexAlign.SpaceBetween)

                  Slider({
                    value: this.fontSize,
                    min: 88,
                    max: 248,
                    step: 80,
                    style: SliderStyle.InSet
                  })
                    .width('calc(100% + 12vp)')
                    .height(40)
                    .blockColor(Color.White)
                    .trackColor('#F1F3F5')
                    .selectedColor('#0A59F7')
                    .showSteps(true)
                    .onChange((value: number) => {
                      this.fontSize = value;
                      if (this.fontSize === 88) {
                        this.fontSizeFlag = '小';
                      } else if (this.fontSize === 248) {
                        this.fontSizeFlag = '大';
                      } else {
                        this.fontSizeFlag = '中';
                      }
                    })
                }

                // 字体粗细选择
                Row() {
                  Text('字体粗细')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)

                  Blank()

                  Select([
                    { value: 'Regular' },
                    { value: 'Medium' },
                    { value: 'Bold' }
                  ])
                    .value(this.fontWeight.toString())
                    .selected(this.selectedIndex)
                    .backgroundColor('#FFFFFF')
                    .borderWidth(0)
                    .onSelect((index: number) => {
                      this.fontWeight = this.fontWeights[index];
                      this.selectedIndex = index;
                    })
                }
                .width('100%')
                .height(48)
                .margin({ top: 16 })

                // 颜色选择
                Column() {
                  Text('字体颜色')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .width('100%')

                  Row() {
                    ForEach(this.colors, (color: string, index: number) => {
                      Column() {
                        if (index === 4) {
                          // 渐变色
                          Column()
                            .width(40)
                            .height(40)
                            .borderRadius(4)
                            .linearGradient({
                              angle: 135,
                              colors: [
                                ['#FF0000', 0.0],
                                ['#00FF00', 0.5],
                                ['#0000FF', 1.0]
                              ]
                            })
                            .border({
                              width: this.colorIndex === index ? 2 : 1,
                              color: this.colorIndex === index ? '#0A59F7' : '#E5E5EA'
                            })
                        } else {
                          Column()
                            .width(40)
                            .height(40)
                            .backgroundColor(color)
                            .borderRadius(4)
                            .border({
                              width: this.colorIndex === index ? 2 : 1,
                              color: this.colorIndex === index ? '#0A59F7' : '#E5E5EA'
                            })
                        }
                      }
                      .width(40)
                      .height(40)
                      .onClick(() => {
                        this.colorIndex = index;
                      })
                    }, (color: string) => color)
                  }
                  .width('100%')
                  .height(50)
                  .margin({ top: 8 })
                  .justifyContent(FlexAlign.SpaceBetween)
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
                .margin({ top: 16 })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(16)
              .padding(16)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            // 显示弹幕按钮
            Button('显示弹幕')
              .height(48)
              .backgroundColor('#0A59F7')
              .width('100%')
              .margin({ top: 28, bottom: 28 })
              .onClick(() => {
                // 创建设置对象
                const settings = new Settings(
                  this.content,
                  this.fontSize,
                  this.fontWeight,
                  '#000000',
                  this.colorIndex === 4 ? '#FF0000' : this.colors[this.colorIndex]
                );
                // 导航到全屏显示页面
                this.pathInfos.pushPathByName('HandheldFullScreen', settings);
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
        .width('100%')
        .background('#F1F3F5')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
    }
    .title('手持弹幕')
    .width('100%')
    .height('100%')
    .onReady((context: NavDestinationContext) => {
      hilog.info(0x0000, TAG, 'onReady: NavDestination ready');
      this.pathInfos = context.pathStack;
    })
  }
}

@Builder
export function HandheldBarrageBuilder() {
  HandheldBarrage();
}
