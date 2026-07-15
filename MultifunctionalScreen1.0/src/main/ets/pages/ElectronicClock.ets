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
export struct ElectronicClock {
  @Local currentTime: string = '';
  @Local hours: number = 0;
  @Local minutes: number = 0;
  @Local seconds: number = 0;
  private timer: number = -1;
  pathInfos: NavPathStack = new NavPathStack();

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
    this.hours = now.getHours();
    this.minutes = now.getMinutes();
    this.seconds = now.getSeconds();
    this.currentTime = `${this.formatNumber(this.hours)}:${this.formatNumber(this.minutes)}:${this.formatNumber(this.seconds)}`;
  }

  formatNumber(num: number): string {
    return num < 10 ? `0${num}` : `${num}`;
  }

  build() {
    NavDestination() {
      Column() {
        // 钟表盘
        Stack() {
          Canvas(this.getCanvasContext())
            .width($r('app.float.clock_canvas_size'))
            .height($r('app.float.clock_canvas_size'))
            .onReady(() => {
              this.drawClock();
            })
        }
        .width($r('app.float.clock_canvas_size'))
        .height($r('app.float.clock_canvas_size'))
        .margin({ top: $r('app.float.clock_top_margin_large') })

        // 数字时间显示
        Text(this.currentTime)
          .fontSize($r('app.float.clock_font_size'))
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.float.clock_top_margin_medium') })

        // 全屏显示按钮
        Button('全屏显示')
          .height($r('app.float.clock_button_height'))
          .width($r('app.float.clock_button_width'))
          .fontSize($r('app.float.font_size_18'))
          .backgroundColor('#0A59F7')
          .margin({ top: $r('app.float.clock_top_margin_medium') })
          .onClick(() => {
            this.pathInfos.pushPathByName('ClockFullScreen', null);
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#F1F3F5')
    }
    .title('电子时钟')
    .width('100%')
    .height('100%')
    .onReady((context: NavDestinationContext) => {
      this.pathInfos = context.pathStack;
    })
  }

  private getCanvasContext(): CanvasRenderingContext2D {
    return new CanvasRenderingContext2D(new RenderingContextSettings(true));
  }

  private drawClock(): void {
    const ctx = this.getCanvasContext();
    const canvasSize = 300; // 使用固定值，因为资源引用有问题
    const centerX = canvasSize / 2;
    const centerY = canvasSize / 2;
    const radius = canvasSize * 0.4667; // 140/300 = 0.4667

    // 清空画布
    ctx.clearRect(0, 0, canvasSize, canvasSize);

    // 绘制表盘外圈
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = canvasSize * 0.0133; // 4/300 = 0.0133
    ctx.stroke();

    // 绘制表盘内圈
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius - canvasSize * 0.0333, 0, 2 * Math.PI); // 10/300 = 0.0333
    ctx.strokeStyle = '#E5E5EA';
    ctx.lineWidth = canvasSize * 0.0067; // 2/300 = 0.0067
    ctx.stroke();

    // 绘制刻度
    for (let i = 0; i < 60; i++) {
      const angle = (i * 6 - 90) * Math.PI / 180;
      const innerRadius = i % 5 === 0 ? radius - canvasSize * 0.0833 : radius - canvasSize * 0.06; // 25/300=0.0833, 18/300=0.06
      const outerRadius = radius - canvasSize * 0.04; // 12/300=0.04

      ctx.beginPath();
      ctx.moveTo(
        centerX + innerRadius * Math.cos(angle),
        centerY + innerRadius * Math.sin(angle)
      );
      ctx.lineTo(
        centerX + outerRadius * Math.cos(angle),
        centerY + outerRadius * Math.sin(angle)
      );
      ctx.strokeStyle = i % 5 === 0 ? '#000000' : '#999999';
      ctx.lineWidth = i % 5 === 0 ? canvasSize * 0.01 : canvasSize * 0.0033; // 3/300=0.01, 1/300=0.0033
      ctx.stroke();
    }

    // 绘制数字
    ctx.font = `${canvasSize * 0.0667}px sans-serif`; // 20/300=0.0667
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    for (let i = 1; i <= 12; i++) {
      const angle = (i * 30 - 90) * Math.PI / 180;
      const x = centerX + (radius - canvasSize * 0.15) * Math.cos(angle); // 45/300=0.15
      const y = centerY + (radius - canvasSize * 0.15) * Math.sin(angle);
      ctx.fillText(i.toString(), x, y);
    }

    // 绘制时针
    const hourAngle = ((this.hours % 12) * 30 + this.minutes * 0.5 - 90) * Math.PI / 180;
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(
      centerX + canvasSize * 0.2 * Math.cos(hourAngle), // 60/300=0.2
      centerY + canvasSize * 0.2 * Math.sin(hourAngle)
    );
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = canvasSize * 0.02; // 6/300=0.02
    ctx.lineCap = 'round';
    ctx.stroke();

    // 绘制分针
    const minuteAngle = (this.minutes * 6 + this.seconds * 0.1 - 90) * Math.PI / 180;
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(
      centerX + canvasSize * 0.3 * Math.cos(minuteAngle), // 90/300=0.3
      centerY + canvasSize * 0.3 * Math.sin(minuteAngle)
    );
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = canvasSize * 0.0133; // 4/300=0.0133
    ctx.lineCap = 'round';
    ctx.stroke();

    // 绘制秒针
    const secondAngle = (this.seconds * 6 - 90) * Math.PI / 180;
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(
      centerX + canvasSize * 0.3333 * Math.cos(secondAngle), // 100/300=0.3333
      centerY + canvasSize * 0.3333 * Math.sin(secondAngle)
    );
    ctx.strokeStyle = '#FF0000';
    ctx.lineWidth = canvasSize * 0.0067; // 2/300=0.0067
    ctx.lineCap = 'round';
    ctx.stroke();

    // 绘制中心点
    ctx.beginPath();
    ctx.arc(centerX, centerY, canvasSize * 0.02, 0, 2 * Math.PI); // 6/300=0.02
    ctx.fillStyle = '#000000';
    ctx.fill();
  }
}

@Builder
export function ElectronicClockBuilder() {
  ElectronicClock();
}
