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
import { textToSpeech } from '@kit.CoreSpeechKit';
import { window } from '@kit.ArkUI';

const TAG = 'HandheldFullScreen';

@ComponentV2
export struct HandheldFullScreen {
  @Local content: string = '';
  @Local fontSize: number = 88;
  @Local fontWeight: FontWeight = FontWeight.Regular;
  @Local bgColor: string = '#000000';
  @Local fontColor: string = '#FFFFFF';
  @Local isSpeaking: boolean = false;
  pathInfos: NavPathStack = new NavPathStack();
  private ttsEngine: textToSpeech.TextToSpeechEngine | null = null;

  aboutToAppear(): void {
    hilog.info(0x0000, TAG, 'aboutToAppear: Starting');
    this.initTTS();
  }

  aboutToDisappear(): void {
    // 停止并销毁TTS
    if (this.ttsEngine) {
      this.ttsEngine.stop();
      this.ttsEngine = null;
    }
  }

  // 初始化TTS
  initTTS(): void {
    try {
      // 创建TTS引擎
      const initParams: textToSpeech.CreateEngineParams = {
        language: 'zh-CN', // 语种设置为中文
        online: 1, // 模式设置为离线
        person: 13 // 聆小珊女声音色
      };
      textToSpeech.createEngine(initParams, (err: Error, engine: textToSpeech.TextToSpeechEngine) => {
        if (!err) {
          this.ttsEngine = engine;
          hilog.info(0x0000, TAG, 'TTS engine initialized');
        } else {
          hilog.error(0x0000, TAG, `TTS init failed: ${err}`);
        }
      });
    } catch (error) {
      hilog.error(0x0000, TAG, `TTS init failed: ${error}`);
    }
  }

  // 播放/停止语音
  toggleSpeech(): void {
    if (!this.ttsEngine) {
      hilog.error(0x0000, TAG, 'TTS engine not initialized');
      return;
    }

    if (this.isSpeaking) {
      // 停止播放
      this.ttsEngine.stop();
      this.isSpeaking = false;
      hilog.info(0x0000, TAG, 'Speech stopped');
    } else {
      // 开始播放
      try {
        const speakParams: textToSpeech.SpeakParams = {
          requestId: 'tts_request_001'
        };
        this.ttsEngine.speak(this.content, speakParams);
        this.isSpeaking = true;
        hilog.info(0x0000, TAG, `Speaking: ${this.content}`);
      } catch (error) {
        hilog.error(0x0000, TAG, `Speak failed: ${error}`);
      }
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        // 跑马灯弹幕 - 使用TextOverflow.MARQUEE实现滚动
        Column() {
          Text(this.content)
            .textOverflow({ overflow: TextOverflow.MARQUEE })
            .marqueeOptions({
              start: true
            })
            .fontSize(this.fontSize)
            .fontColor(this.fontColor)
            .fontWeight(this.fontWeight)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)

        // 声音播放图标 - 右下角
        Button() {
          Column() {
            if (this.isSpeaking) {
              // 播放中图标
              Image($r('app.media.speaker_wave_3'))
                .width(28)
                .height(28)
            } else {
              // 静音图标 - 使用文字表示
              Text('🔇')
                .fontSize(24)
            }
          }
        }
        .width(56)
        .height(56)
        .backgroundColor('#80000000')
        .borderRadius(28)
        .margin({ right: 24, bottom: 24 })
        .onClick(() => {
          this.toggleSpeech();
        })
      }
      .width('100%')
      .height('100%')
    }
    .title('手持弹幕')
    .width('100%')
    .height('100%')
    .backButtonIcon($r('app.media.chevron_left'))
    .preferredOrientation(window.Orientation.LANDSCAPE)
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [
        ['#013C9C', 0.0],
        ['#3066E4', 0.5],
        ['#43A1F4', 1.0]
      ]
    })
    .onReady((context: NavDestinationContext) => {
      hilog.info(0x0000, TAG, 'onReady: NavDestination ready');
      this.pathInfos = context.pathStack;
      // 从路由参数获取设置
      const params = this.pathInfos.getParamByName('HandheldFullScreen')[0] as Settings;
      if (params) {
        this.content = params.content;
        this.fontSize = params.fontSize;
        this.fontWeight = params.fontWeight;
        this.bgColor = params.backgroundColor;
        this.fontColor = params.fontColor;
        hilog.info(0x0000, TAG, `Settings: content=${this.content}, fontSize=${this.fontSize}`);
      }
    })
  }
}

@Builder
export function HandheldFullScreenBuilder() {
  HandheldFullScreen();
}
