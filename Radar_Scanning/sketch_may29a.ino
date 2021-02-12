#include<stdio.h>
#include <Servo.h> 
Servo mServo;  //创建一个舵机控制对象

//当前角度
int mAngleNum = 0;
//当前是正向旋转还是反向旋转
char mFront = 0;

//超声波测距引脚
const int mTrigPin = 2; 
const int mEchoPin = 3; 

//当前距离
int mDistance = 0;

//向串口发送数据  发送到processing
void sendStatusToSerial();
//测距
void ranging();
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  mServo.attach(9);  // 该舵机由arduino第九脚控制

  pinMode(mTrigPin, OUTPUT); 
  // 要检测引脚上输入的脉冲宽度，需要先设置为输入状态
  pinMode(mEchoPin, INPUT); 
  
}

void loop() {
  // put your main code here, to run repeatedly:

  //多角度设置
  mServo.write(180 - mAngleNum);
  //超声波测距
  ranging();
  //发数据
  sendStatusToSerial();
  delay(60);
  
  if( mFront == 0 )
  {
    mAngleNum ++;
    if( mAngleNum > 180 )
    { 
      mFront = 1;
    }
  }
  else
  {
    mAngleNum --; 
    if( mAngleNum < 1 )
    {
      mFront = 0;
    }
  }

}

//发送当前状态到串口
void sendStatusToSerial()
{
  char mAngleStr[6];
  char mDistanceStr[6];
  sprintf( mAngleStr, "%d", mAngleNum);
  sprintf( mDistanceStr, "%d", mDistance);
  delayMicroseconds(2); 
  Serial.print( "<" );
  Serial.print(mAngleStr);
  Serial.print("|");
  Serial.print(mDistanceStr);
  Serial.print( ">" );
  Serial.println();
  delayMicroseconds(2); 
}

//测距
void ranging()
{
  // 产生一个10us的高脉冲去触发TrigPin 
  digitalWrite(mTrigPin, LOW); //低高低电平发一个短时间脉冲去TrigPin 
  delayMicroseconds(2); 
  digitalWrite(mTrigPin, HIGH); 
  delayMicroseconds(10); 
  digitalWrite(mTrigPin, LOW); 
  
  mDistance = pulseIn(mEchoPin, HIGH) / 58.0; //将回波时间换算成cm 
  //Serial.println(mDistance); 
//  mDistance = (int(mDistance * 100.0)) / 100.0; //保留两位小数 
//  Serial.print(mDistance); 
//  Serial.print("cm"); 
//  Serial.println(); 

//  
//  digitalWrite(mTrigPin, LOW); 
//  delayMicroseconds(2); 
//  digitalWrite(mTrigPin, HIGH); 
//  delayMicroseconds(10);
//  digitalWrite(mTrigPin, LOW); 
//  // 检测脉冲宽度，并计算出距离
//  mDistance = pulseIn(mEchoPin, HIGH) / 58.00;
//  Serial.print(mDistance); 
//  Serial.print("cm"); 
//  Serial.println();   
}

