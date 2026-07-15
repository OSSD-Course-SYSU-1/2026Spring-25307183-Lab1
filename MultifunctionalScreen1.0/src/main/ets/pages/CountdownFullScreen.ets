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

import { vibrator } from '@kit.SensorServiceKit';
import { CountdownSettings } from './CountdownBarrage';

@ComponentV2
export struct CountdownFullScreen {
  // 倒计时秒数
  @Local remainingSeconds: number = 0;
  // 是否开启音效
  @Local soundEnabled: boolean = true;
  // 当前显示的数字（用于动画）
  @Local displayNumber: number = 0;
  // 数字动画透明度
  @Local numberOpacity: number = 0;
  // 数字动画缩放
  @Local numberScale: number = 0.5;
  // 是否进入倒数阶段（<=10s）
  @Local isInCountdownPhase: boolean = false;
  // 倒计时定时器
  private countdownTimer: number = -1;
  // 导航控制器
  pathInfos: NavPathStack = new NavPathStack();
  
  aboutToAppear(): void {
    // 参数获取移到 onReady 回调中
  }

  aboutToDisappear(): void {
    // 清除定时器
    if (this.countdownTimer !== -1) {
      clearInterval(this.countdownTimer);
    }
  }

  // 启动倒计时
  startCountdown(): void {
    this.countdownTimer = setInterval(() => {
      if (this.remainingSeconds > 0) {
        this.remainingSeconds--;
        
        // 当剩余时间<=10秒时，进入倒数阶段
        if (this.remainingSeconds <= 10 && this.remainingSeconds > 0) {
          if (!this.isInCountdownPhase) {
            this.isInCountdownPhase = true;
          }
          // 更新显示数字并触发动画
          this.displayNumber = this.remainingSeconds;
          this.triggerNumberAnimation();
          // 播放音效/振动
          if (this.soundEnabled) {
            this.playCountdownEffect();
          }
        }
      } else {
        // 倒计时结束
        clearInterval(this.countdownTimer);
        this.countdownTimer = -1;
        this.isInCountdownPhase = false;
      }
    }, 1000);
  }

  // 触发数字动画
  triggerNumberAnimation(): void {
    // 重置动画状态
    this.numberOpacity = 0;
    this.numberScale = 0.5;
    
    // 启动闪入动画
    animateTo({
      duration: 300,
      curve: Curve.EaseOut
    }, () => {
      this.numberOpacity = 1;
      this.numberScale = 1;
    });
  }

  // 播放倒数效果（振动）
  playCountdownEffect(): void {
    try {
      // 使用振动作为倒数提示
      vibrator.startVibration({
        type: 'time',
        duration: 100
      }, {
        id: 0,
        usage: 'alarm'
      });
    } catch (error) {
      // 振动失败时不影响倒计时继续
      console.error('Vibration failed:', error);
    }
  }

  // 格式化时间显示
  formatTime(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    
    if (hours > 0) {
      return `${hours}:${this.padZero(minutes)}:${this.padZero(secs)}`;
    } else if (minutes > 0) {
      return `${minutes}:${this.padZero(secs)}`;
    } else {
      return `${secs}`;
    }
  }

  // 补零
  padZero(num: number): string {
    return num < 10 ? `0${num}` : `${num}`;
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          // 倒计时显示
          if (this.isInCountdownPhase && this.remainingSeconds > 0) {
            // 倒数阶段：显示大数字动画
            Text(`${this.displayNumber}`)
              .fontSize($r('app.float.countdown_giant_font_size'))
              .fontColor('#FF0000')
              .fontWeight(FontWeight.Bold)
              .opacity(this.numberOpacity)
              .scale({ x: this.numberScale, y: this.numberScale })
          } else if (this.remainingSeconds > 0) {
            // 正常阶段：显示时间格式
            Text(this.formatTime(this.remainingSeconds))
              .fontSize($r('app.float.countdown_huge_font_size'))
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
          } else {
            // 倒计时结束
            Text('时间到！')
              .fontSize($r('app.float.countdown_fullscreen_font_size_large'))
              .fontColor('#FF0000')
              .fontWeight(FontWeight.Bold)
          }
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        
        // 音效开关按钮（右下角）
        Column() {
          Button() {
            Image($r('app.media.speaker_wave_3'))
              .width($r('app.float.countdown_fullscreen_image_size'))
              .height($r('app.float.countdown_fullscreen_image_size'))
              .fillColor('#FFFFFF')
              .opacity(this.soundEnabled ? 1 : 0.4)
          }
          .width($r('app.float.countdown_fullscreen_button_size'))
          .height($r('app.float.countdown_fullscreen_button_size'))
          .borderRadius($r('app.float.countdown_fullscreen_button_radius'))
          .backgroundColor(this.soundEnabled ? '#0A59F7' : '#666666')
          .onClick(() => {
            this.soundEnabled = !this.soundEnabled;
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.End)
        .padding({ right: $r('app.float.countdown_fullscreen_padding'), bottom: $r('app.float.countdown_fullscreen_padding') })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
    .title('倒计时')
    .width('100%')
    .height('100%')
    .backButtonIcon($r('app.media.chevron_left'))
    // 注释掉横屏设置，避免平板设备兼容性问题
    // .preferredOrientation(window.Orientation.LANDSCAPE)
    .backgroundColor('#000000')
    .onReady((context: NavDestinationContext) => {
      this.pathInfos = context.pathStack;
      // 从路由参数获取总秒数
      const params = this.pathInfos.getParamByName('CountdownFullScreen')[0] as CountdownSettings;
      if (params) {
        this.remainingSeconds = params.totalSeconds;
        // 如果初始时间<=10s，立即进入倒数阶段
        if (this.remainingSeconds <= 10) {
          this.isInCountdownPhase = true;
          this.displayNumber = this.remainingSeconds;
          this.triggerNumberAnimation();
        }
      }
      // 启动倒计时
      this.startCountdown();
    })
  }
}

@Builder
export function CountdownFullScreenBuilder() {
  CountdownFullScreen();
}
