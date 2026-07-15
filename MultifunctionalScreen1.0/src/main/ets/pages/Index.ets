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

import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'Index';

@Entry
@ComponentV2
struct Index {
  // 导航控制器
  pathInfos: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathInfos) {
      Column() {
        // 标题区
        Text('多功能弹幕')
          .fontSize($r('app.float.title_font_size'))
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.float.title_margin_top'), bottom: $r('app.float.title_margin_bottom') })

        // 功能按钮区
        Column({ space: 20 }) {
          // 手持弹幕按钮
          this.FunctionButton('手持弹幕', () => {
            hilog.info(0x0000, TAG, 'Button clicked: HandheldBarrage');
            try {
              this.pathInfos.pushPathByName('HandheldBarrage', null);
              hilog.info(0x0000, TAG, 'Navigation push successful');
            } catch (error) {
              hilog.error(0x0000, TAG, 'Navigation push failed: %{public}s', JSON.stringify(error));
            }
          })

          // 滚动图像按钮
          this.FunctionButton('滚动图像', () => {
            this.pathInfos.pushPathByName('ScrollingImage', null);
          })

          // 倒计时弹幕按钮
          this.FunctionButton('倒计时弹幕', () => {
            this.pathInfos.pushPathByName('CountdownBarrage', null);
          })

          // 电子时钟按钮
          this.FunctionButton('电子时钟', () => {
            this.pathInfos.pushPathByName('ElectronicClock', null);
          })

          // 在线骰子按钮
          this.FunctionButton('在线骰子', () => {
            this.pathInfos.pushPathByName('OnlineDice', null);
          })
        }
        .width('100%')
        .padding({ left: $r('app.float.side_padding'), right: $r('app.float.side_padding') })
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [
          ['#0A59F7', 0.0],
          ['#013C9C', 1.0]
        ]
      })
    }
    .mode(NavigationMode.Stack)
    .hideToolBar(true)
  }

  // 功能按钮组件
  @Builder
  FunctionButton(title: string, onClick: () => void) {
    Button(title)
      .width('100%')
      .height($r('app.float.button_height'))
      .fontSize($r('app.float.button_font_size'))
      .fontWeight(FontWeight.Medium)
      .fontColor('#0A59F7')
      .backgroundColor('#FFFFFF')
      .borderRadius($r('app.float.button_border_radius'))
      .onClick(onClick)
  }
}
