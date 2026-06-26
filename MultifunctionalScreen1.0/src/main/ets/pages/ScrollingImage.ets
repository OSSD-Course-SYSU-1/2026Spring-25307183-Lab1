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
export struct ScrollingImage {
  build() {
    NavDestination() {
      Column() {
        Text('滚动图像')
          .fontSize($r('app.float.title_font_size'))
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: $r('app.float.margin_bottom_medium') })

        Text('功能开发中...')
          .fontSize($r('app.float.font_size_18'))
          .fontColor('#99000000')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#F1F3F5')
    }
    .title('滚动图像')
    .width('100%')
    .height('100%')
  }
}

@Builder
export function ScrollingImageBuilder() {
  ScrollingImage();
}
