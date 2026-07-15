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

// 骰子位置接口
interface DicePosition {
  x: number;
  y: number;
  rotation: number;
}

@ComponentV2
export struct OnlineDice {
  // 骰子数量（默认1个）
  @Local diceCount: number = 1;
  // 投掷次数（默认1次）
  @Local throwCount: number = 1;
  // 骰子点数数组
  @Local diceValues: number[] = [1];
  // 是否正在摇动
  @Local isShaking: boolean = false;
  // 骰子位置数组（用于动画）
  @Local dicePositions: DicePosition[] = [{x: 0, y: 0, rotation: 0}];
  
  // 导航控制器
  pathInfos: NavPathStack = new NavPathStack();
  
  // 定时器ID
  private shakeTimer: number = -1;

  aboutToDisappear() {
    // 清除定时器
    if (this.shakeTimer !== -1) {
      clearInterval(this.shakeTimer);
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 控制区域
        Column({ space: 20 }) {
          // 骰子数量控制
          Row() {
            Text('骰子数量')
              .fontSize($r('app.float.medium_font_size'))
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
            
            Blank()
            
            // 加减控制器
            Row({ space: 12 }) {
              // 减号按钮
              Button() {
                Text('-')
                  .fontSize($r('app.float.large_font_size'))
                  .fontColor(Color.White)
              }
              .width($r('app.float.dice_control_button_size'))
              .height($r('app.float.dice_control_button_size'))
              .borderRadius($r('app.float.dice_control_button_radius'))
              .backgroundColor('#333333')
              .onClick(() => {
                if (this.diceCount > 1) {
                  this.diceCount--;
                  this.updateDiceArray();
                }
              })
              
              // 数量显示
              Text(this.diceCount.toString())
                .fontSize(20)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
                .width($r('app.float.dice_control_text_width'))
                .textAlign(TextAlign.Center)
              
              // 加号按钮
              Button() {
                Text('+')
                  .fontSize($r('app.float.large_font_size'))
                  .fontColor(Color.White)
              }
              .width($r('app.float.dice_control_button_size'))
              .height($r('app.float.dice_control_button_size'))
              .borderRadius($r('app.float.dice_control_button_radius'))
              .backgroundColor('#333333')
              .onClick(() => {
                if (this.diceCount < 6) {
                  this.diceCount++;
                  this.updateDiceArray();
                }
              })
            }
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_control_padding'), right: $r('app.float.dice_control_padding') })
          
          // 投掷次数控制
          Row() {
            Text('投掷次数')
              .fontSize($r('app.float.medium_font_size'))
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
            
            Blank()
            
            // 加减控制器
            Row({ space: 12 }) {
              // 减号按钮
              Button() {
                Text('-')
                  .fontSize($r('app.float.large_font_size'))
                  .fontColor(Color.White)
              }
              .width($r('app.float.dice_control_button_size'))
              .height($r('app.float.dice_control_button_size'))
              .borderRadius($r('app.float.dice_control_button_radius'))
              .backgroundColor('#333333')
              .onClick(() => {
                if (this.throwCount > 1) {
                  this.throwCount--;
                }
              })
              
              // 次数显示
              Text(this.throwCount.toString())
                .fontSize(20)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
                .width($r('app.float.dice_control_text_width'))
                .textAlign(TextAlign.Center)
              
              // 加号按钮
              Button() {
                Text('+')
                  .fontSize($r('app.float.large_font_size'))
                  .fontColor(Color.White)
              }
              .width($r('app.float.dice_control_button_size'))
              .height($r('app.float.dice_control_button_size'))
              .borderRadius($r('app.float.dice_control_button_radius'))
              .backgroundColor('#333333')
              .onClick(() => {
                if (this.throwCount < 10) {
                  this.throwCount++;
                }
              })
            }
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_control_padding'), right: $r('app.float.dice_control_padding') })
        }
        .width('100%')
        .margin({ top: $r('app.float.dice_margin_top_small') })
        
        // 骰子盘区域
        Column() {
          Stack() {
            // 盘子背景
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor('#1A1A1A')
              .borderRadius($r('app.float.dice_tray_border_radius'))
              .border({ width: 2, color: '#333333' })
            
            // 骰子显示区域
            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              ForEach(this.diceValues, (value: number, index: number) => {
                this.DiceFace(value, index)
              }, (value: number, index: number) => `${index}_${value}`)
            }
            .width('90%')
            .height('90%')
          }
        }
        .width('90%')
        .height($r('app.float.dice_tray_height'))
        .margin({ top: $r('app.float.dice_margin_top_medium') })
        .justifyContent(FlexAlign.Center)
        
        // 摇一摇按钮
        Button('摇一摇')
          .width('80%')
          .height($r('app.float.dice_shake_button_height'))
          .fontSize($r('app.float.large_font_size'))
          .fontColor(Color.White)
          .backgroundColor('#0A59F7')
          .borderRadius($r('app.float.dice_shake_button_radius'))
          .margin({ top: $r('app.float.dice_margin_top_medium') })
          .enabled(!this.isShaking)
          .onClick(() => {
            this.startShaking();
          })
        
        // 显示结果
        if (!this.isShaking && this.diceValues.length > 0) {
          Text(`总点数: ${this.diceValues.reduce((sum, val) => sum + val, 0)}`)
            .fontSize($r('app.float.font_size_18'))
            .fontColor(Color.White)
            .margin({ top: $r('app.float.dice_margin_top_small') })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
    .title('在线骰子')
    .width('100%')
    .height('100%')
    .onReady((context: NavDestinationContext) => {
      this.pathInfos = context.pathStack;
    })
  }
  
  // 骰子面组件
  @Builder
  DiceFace(value: number, index: number) {
    Column() {
      Stack() {
        // 骰子背景
        Column()
          .width($r('app.float.dice_size'))
          .height($r('app.float.dice_size'))
          .backgroundColor(Color.White)
          .borderRadius(8)
        
        // 骰子点数
        this.DiceDots(value)
      }
      .rotate({ angle: this.dicePositions[index]?.rotation || 0 })
      .translate({ 
        x: this.dicePositions[index]?.x || 0, 
        y: this.dicePositions[index]?.y || 0 
      })
    }
    .width($r('app.float.dice_container_size'))
    .height($r('app.float.dice_container_size'))
    .margin($r('app.float.dice_margin'))
  }
  
  // 骰子点数绘制
  @Builder
  DiceDots(value: number) {
    Stack() {
      // 根据点数绘制圆点
      if (value === 1) {
        Column()
          .width($r('app.float.dice_dot_size_large'))
          .height($r('app.float.dice_dot_size_large'))
          .backgroundColor('#000000')
          .borderRadius($r('app.float.dice_dot_radius_large'))
      } else if (value === 2) {
        Column() {
          Column()
            .width($r('app.float.dice_dot_size_small'))
            .height($r('app.float.dice_dot_size_small'))
            .backgroundColor('#000000')
            .borderRadius($r('app.float.dice_dot_radius_small'))
            .margin({ bottom: $r('app.float.dice_dot_margin_large') })
          
          Column()
            .width($r('app.float.dice_dot_size_small'))
            .height($r('app.float.dice_dot_size_small'))
            .backgroundColor('#000000')
            .borderRadius($r('app.float.dice_dot_radius_small'))
            .margin({ top: $r('app.float.dice_dot_margin_large') })
        }
        .width(60)
        .height(60)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
      } else if (value === 3) {
        Column() {
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
          
          Column()
            .width($r('app.float.dice_dot_size_small'))
            .height($r('app.float.dice_dot_size_small'))
            .backgroundColor('#000000')
            .borderRadius($r('app.float.dice_dot_radius_small'))
          
          Row() {
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
        }
        .width(60)
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
      } else if (value === 4) {
        Column() {
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
          
          Blank()
          
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
        }
        .width(60)
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
      } else if (value === 5) {
        Column() {
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
          
          Column()
            .width($r('app.float.dice_dot_size_small'))
            .height($r('app.float.dice_dot_size_small'))
            .backgroundColor('#000000')
            .borderRadius($r('app.float.dice_dot_radius_small'))
          
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
        }
        .width(60)
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
      } else if (value === 6) {
        Column() {
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
          
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
          
          Row() {
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
            Blank()
            Column()
              .width(8)
              .height(8)
              .backgroundColor('#000000')
              .borderRadius($r('app.float.dice_dot_radius_small'))
          }
          .width('100%')
          .padding({ left: $r('app.float.dice_dot_padding'), right: $r('app.float.dice_dot_padding') })
        }
        .width(60)
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .width(60)
    .height(60)
  }
  
  // 更新骰子数组
  private updateDiceArray() {
    this.diceValues = [];
    this.dicePositions = [];
    for (let i = 0; i < this.diceCount; i++) {
      this.diceValues.push(1);
      this.dicePositions.push({x: 0, y: 0, rotation: 0});
    }
  }
  
  // 开始摇动
  private startShaking() {
    this.isShaking = true;
    let count = 0;
    const maxCount = 20; // 摇动次数
    
    this.shakeTimer = setInterval(() => {
      // 随机生成骰子值
      for (let i = 0; i < this.diceValues.length; i++) {
        this.diceValues[i] = Math.floor(Math.random() * 6) + 1;
        // 随机位置和旋转
        this.dicePositions[i] = {
          x: (Math.random() - 0.5) * 40,
          y: (Math.random() - 0.5) * 40,
          rotation: Math.random() * 360
        };
      }
      
      count++;
      if (count >= maxCount) {
        clearInterval(this.shakeTimer);
        this.shakeTimer = -1;
        this.isShaking = false;
        // 重置位置
        for (let i = 0; i < this.dicePositions.length; i++) {
          this.dicePositions[i] = {x: 0, y: 0, rotation: 0};
        }
      }
    }, 100);
  }
}

@Builder
export function OnlineDiceBuilder() {
  OnlineDice();
}
