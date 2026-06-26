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



@ComponentV2
export struct ClockFullScreen {
  @Local currentTime: string = '';
  private timer: number = -1;

  aboutToAppear(): void {
    this.updateTime();
    this.timer = setInterval(() => {
      this.updateTime();
    }, 1000);
  }

  aboutToDisappear(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  updateTime(): void {
    const now = new Date();
    const hours = now.getHours();
    const minutes = now.getMinutes();
    const seconds = now.getSeconds();
    this.currentTime = `${this.formatNumber(hours)}:${this.formatNumber(minutes)}:${this.formatNumber(seconds)}`;
  }

  formatNumber(num: number): string {
    return num < 10 ? `0${num}` : `${num}`;
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.currentTime)
          .fontSize($r('app.float.clock_fullscreen_font_size'))
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#000000')
    }
    .title('全屏时钟')
    .width('100%')
    .height('100%')
    .backButtonIcon($r('app.media.chevron_left'))
    // 注释掉横屏设置，避免平板设备兼容性问题
    // .preferredOrientation(window.Orientation.LANDSCAPE)
    .backgroundColor('#000000')
  }
}

@Builder
export function ClockFullScreenBuilder() {
  ClockFullScreen();
}
