# 北京邮电大学数字电路与逻辑设计课程FPGA实验代码（Verilog）
## [第10周：](https://github.com/Deskearth/FPGA_Course/tree/master/Week10)       
1. 实现带异步置位、复位功能的上升沿触发JK触发器     
2. 实现74HC595-8位移存器 
## [第11周：](https://github.com/Deskearth/FPGA_Course/tree/master/Week11)
1.  用JK触发器实现8421码十进制计数器
2.  设计一个24秒倒计时器
## [第12周：](https://github.com/Deskearth/FPGA_Course/tree/master/Week12)
1. 设计一个汽车尾灯自动控制系统
> 要求：根据汽车行驶状态自动控制汽车尾灯

      直行：尾灯不亮

      右转：右侧尾灯亮而且按秒闪烁，左侧尾灯不亮

      左转：左侧尾灯亮而且按秒闪烁，右侧尾灯不亮

      临时停车或故障：两侧尾灯同时闪烁

      倒车显示(可选)
## [第13周：](https://github.com/Deskearth/FPGA_Course/tree/master/Week13)
1. 按键计数器
> 要求：可实现加减功能

## [数字系统设计实验（题目四——猜拳游戏的设计与实现）](https://github.com/Deskearth/BUTP_FPGA_Course/tree/master/Experiment)
测试芯片型号:EPM1270T144C5

### 题目要求
* 基本功能
	1. 甲乙双方各用三个按键模拟“石头”、“剪刀”、“布”；
	2. 裁判用BTN3表示“准备”，BTN4表示“开”；
	3. 每局比赛开始前裁判先宣布“准备”，点阵显示全灭，然后甲乙双方分别选择出拳方式（以最后一次选择为准）；
	4. 裁判按“开”以后，用点阵的左右三列同时显示甲乙双方的猜拳选择，并用两个数码管显示甲乙的猜拳比分；
	5. 猜拳游戏为五局三胜制。若甲乙双方出拳一致，则比分保持不变，双方重新出拳；
	6. 比赛结束后，用8×8点阵显示获胜方；
	7. 用拨码开关作为复位键，复位后游戏重新开始。
* 自拟功能
	1. 点阵显示开机动画、结束动画；
	2. 为游戏增加音效；
	3. 在LCD1602液晶屏幕上显示甲乙双方的猜拳比分；
	4. 在欢迎界面可通过拨码开关选择双人对战或单人对战模式，在单人对战模式下系统通过生成的伪随机数随机出拳，玩家通过按键出拳，规则与双人对战模式相同；

### 结构框图
![结构框图](https://github.com/Deskearth/BUTP_FPGA_Course/blob/master/pic/structure.png)
