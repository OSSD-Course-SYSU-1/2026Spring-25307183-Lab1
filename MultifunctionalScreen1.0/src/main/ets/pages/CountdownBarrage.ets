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

// 时间选项接口
interface TimeOption {
  label: string;
  seconds: number;
}

// 倒计时设置类
export class CountdownSettings {
  totalSeconds: number = 0;
  
  constructor(totalSeconds: number) {
    this.totalSeconds = totalSeconds;
  }
}

@ComponentV2
export struct CountdownBarrage {
  // 初始时间（秒）
  @Local totalSeconds: number = 5;
  // 时间显示字符串
  @Local timeDisplay: string = '0:00:05';
  // 是否显示时间选择弹窗
  @Local showTimeSelector: boolean = false;
  // 是否显示自定义输入框
  @Local showCustomInput: boolean = false;
  // 自定义输入的小时
  @Local customHours: string = '0';
  // 自定义输入的分钟
  @Local customMinutes: string = '00';
  // 自定义输入的秒
  @Local customSeconds: string = '00';
  // 预览倒计时
  @Local previewSeconds: number = 5;
  // 预览定时器
  private previewTimer: number = -1;
  
  // 导航控制器
  pathInfos: NavPathStack = new NavPathStack();
  
  // 时间选项
  private timeOptions: TimeOption[] = [
    {label: '5s', seconds: 5},
    {label: '10s', seconds: 10},
    {label: '20s', seconds: 20},
    {label: '30s', seconds: 30},
    {label: '60s', seconds: 60},
    {label: '自定义', seconds: -1}
  ];

  aboutToAppear(): void {
    this.updateTimeDisplay();
    this.startPreviewTimer();
  }

  aboutToDisappear(): void {
    if (this.previewTimer !== -1) {
      clearInterval(this.previewTimer);
    }
  }

  // 更新时间显示
  updateTimeDisplay(): void {
    this.timeDisplay = this.formatTime(this.totalSeconds);
  }

  // 格式化时间（秒转为 H:MM:SS）
  formatTime(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    return `${hours}:${this.padZero(minutes)}:${this.padZero(secs)}`;
  }

  // 补零
  padZero(num: number): string {
    return num < 10 ? `0${num}` : `${num}`;
  }

  // 启动预览定时器
  startPreviewTimer(): void {
    this.previewTimer = setInterval(() => {
      if (this.previewSeconds > 0) {
        this.previewSeconds--;
      } else {
        this.previewSeconds = this.totalSeconds;
      }
    }, 1000);
  }

  // 选择时间选项
  selectTimeOption(seconds: number): void {
    if (seconds === -1) {
      // 自定义
      this.showCustomInput = true;
    } else {
      this.totalSeconds = seconds;
      this.previewSeconds = seconds;
      this.updateTimeDisplay();
      this.showTimeSelector = false;
    }
  }

  // 确认自定义时间
  confirmCustomTime(): void {
    const hours = parseInt(this.customHours) || 0;
    const minutes = parseInt(this.customMinutes) || 0;
    const seconds = parseInt(this.customSeconds) || 0;
    
    // 计算总秒数
    let total = hours * 3600 + minutes * 60 + seconds;
    
    // 限制最大24小时
    const maxSeconds = 24 * 3600;
    if (total > maxSeconds) {
      total = maxSeconds;
    }
    
    if (total > 0) {
      this.totalSeconds = total;
      this.previewSeconds = total;
      this.updateTimeDisplay();
    }
    
    this.showCustomInput = false;
    this.showTimeSelector = false;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          // 1. 预览区
          Column() {
            Text('预览')
              .fontSize($r('app.float.small_font_size'))
              .fontColor('#99000000')
              .fontWeight(FontWeight.Medium)
              .margin({ left: 28 })

            // 倒计时展示框
            Column() {
              Text(this.formatTime(this.previewSeconds))
                .fontSize($r('app.float.countdown_large_font_size'))
                .fontColor(this.previewSeconds <= 10 ? '#FF0000' : '#FFFFFF')
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .height($r('app.float.preview_height'))
            .backgroundColor('#000000')
            .borderRadius(16)
            .justifyContent(FlexAlign.Center)
            .margin({ top: 8 })
          }
          .width('100%')
          .margin({ top: 28 })
          .alignItems(HorizontalAlign.Start)

          // 2. 操作区
          Column() {
            // 弹幕内容区
            Column() {
              Text('弹幕内容')
                .fontSize($r('app.float.small_font_size'))
                .fontColor('#99000000')
                .fontWeight(FontWeight.Medium)
                .margin({ left: 12 })

              // 初始时间按钮
              Column() {
                Row() {
                  Text('初始时间')
                    .fontSize($r('app.float.medium_font_size'))
                    .fontWeight(FontWeight.Medium)
                  
                  Blank()
                  
                  Text(this.timeDisplay)
                    .fontSize($r('app.float.medium_font_size'))
                    .fontColor('#99000000')
                }
                .width('100%')
                .height($r('app.float.button_height'))
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  this.showTimeSelector = true;
                })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(16)
              .margin({ top: 8 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({
              top: 28,
              bottom: 28
            })

            // 显示弹幕按钮
            Button('显示弹幕')
              .height($r('app.float.button_height_small'))
              .backgroundColor('#0A59F7')
              .width('100%')
              .onClick(() => {
                const settings = new CountdownSettings(this.totalSeconds);
                this.pathInfos.pushPathByName('CountdownFullScreen', settings);
              })
          }
          .padding({
            left: 16,
            right: 16
          })
        }
        .width('100%')
        .background('#F1F3F5')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .bindSheet(this.showTimeSelector, this.TimeSelectorSheet(), {
        height: this.showCustomInput ? $r('app.float.countdown_sheet_height_custom') : $r('app.float.countdown_sheet_height'),
        backgroundColor: Color.White,
        dragBar: false,
        onAppear: () => {
          this.showTimeSelector = true;
        },
        onDisappear: () => {
          this.showTimeSelector = false;
        }
      })
    }
    .title('倒计时弹幕')
    .width('100%')
    .height('100%')
    .onReady((context: NavDestinationContext) => {
      this.pathInfos = context.pathStack;
    })
  }

  // 时间选择弹窗
  @Builder
  TimeSelectorSheet() {
    Column() {
      if (!this.showCustomInput) {
        // 时间选项列表
        Column({ space: 0 }) {
          ForEach(this.timeOptions, (option: TimeOption, index: number) => {
            Row() {
              Text(option.label)
                .fontSize($r('app.float.font_size_18'))
                .fontColor('#000000')
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')
            .height($r('app.float.list_item_height'))
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.selectTimeOption(option.seconds);
            })
            
            if (index < this.timeOptions.length - 1) {
              Divider()
                .width('90%')
                .color('#E5E5EA')
            }
          }, (option: TimeOption) => option.label)
        }
        .width('100%')
      } else {
        // 自定义输入界面
        Column() {
          Text('自定义时间')
            .fontSize($r('app.float.font_size_18'))
            .fontColor('#000000')
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 20 })

          // 时间输入框（H:MM:SS）
          Row({ space: 8 }) {
            // 小时
            TextInput({ text: this.customHours })
              .width($r('app.float.text_input_width'))
              .height($r('app.float.text_input_height'))
              .fontSize($r('app.float.large_font_size'))
              .textAlign(TextAlign.Center)
              .type(InputType.Number)
              .onChange((value: string) => {
                const num = parseInt(value) || 0;
                this.customHours = num > 23 ? '23' : `${num}`;
              })
            
            Text(':')
              .fontSize(24)
              .fontColor('#000000')
            
            // 分钟
            TextInput({ text: this.customMinutes })
              .width($r('app.float.text_input_width'))
              .height($r('app.float.text_input_height'))
              .fontSize($r('app.float.large_font_size'))
              .textAlign(TextAlign.Center)
              .type(InputType.Number)
              .onChange((value: string) => {
                const num = parseInt(value) || 0;
                this.customMinutes = num > 59 ? '59' : this.padZero(num);
              })
            
            Text(':')
              .fontSize(24)
              .fontColor('#000000')
            
            // 秒
            TextInput({ text: this.customSeconds })
              .width($r('app.float.text_input_width'))
              .height($r('app.float.text_input_height'))
              .fontSize($r('app.float.large_font_size'))
              .textAlign(TextAlign.Center)
              .type(InputType.Number)
              .onChange((value: string) => {
                const num = parseInt(value) || 0;
                this.customSeconds = num > 59 ? '59' : this.padZero(num);
              })
          }
          .justifyContent(FlexAlign.Center)

          // 确认和取消按钮
          Row({ space: 20 }) {
            Button('取消')
              .width($r('app.float.button_width_medium'))
              .height($r('app.float.button_height_small'))
              .backgroundColor('#F1F3F5')
              .fontColor('#000000')
              .onClick(() => {
                this.showCustomInput = false;
              })
            
            Button('确认')
              .width($r('app.float.button_width_medium'))
              .height($r('app.float.button_height_small'))
              .backgroundColor('#0A59F7')
              .onClick(() => {
                this.confirmCustomTime();
              })
          }
          .margin({ top: 30 })
        }
        .width('100%')
        .padding(20)
      }
    }
    .width('100%')
  }
}

@Builder
export function CountdownBarrageBuilder() {
  CountdownBarrage();
}
