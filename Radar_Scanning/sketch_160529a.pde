import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

//base config
int mWidth = 600;
int mHeight = 300;
int mWidthHalf = mWidth / 2;
int mHeightHalf = mHeight / 2;
int mBlock = 20;
int mBlockOffset = mWidth / mBlock;

float mMaxDistance = mWidth / 6.0f;


//current angle 
int mAngleNum = 0;
//current distance
int mDistanceNum = 0;

//all distance 
int[] mDistanceArr = new int[182];

void setup() 
{
  size(600, 300);
  frameRate(60);

  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  background(0);
}

void draw()
{
  if ( myPort.available() > 0) { 
    val = myPort.read();        
    if( val == '<')
    {
      mAngleNum = 0;
      mDistanceNum = 0;
      while( ( val = myPort.read() ) != '|' )
      {
        mAngleNum = 10 * mAngleNum + val - '0';
      }
      while( ( val = myPort.read() ) != '>' )
      {
        mDistanceNum = 10 * mDistanceNum + val - '0';
      }
      if( mDistanceNum > 150 )
       {
         mDistanceArr[mAngleNum] = -1;
       }
       else
       {
         mDistanceArr[mAngleNum] = mDistanceNum;
       }
    }
  }

  //draw background line
  drawBg();
  
  //scan angle
  drawScan(mAngleNum);
  
  //distance
  drawBarrier();
  
}

void drawBg()
{
  background(0);
  //print("draw bg");
  stroke(21,113,10, 51);
  //line(0, 0,  300, 300);
  for( int x = 0; x < mBlockOffset; ++x )
  {
    //print("line:" + x * mBlock);
    line(0, x * mBlock, mWidth, x * mBlock );
    line(x*mBlock, 0, x * mBlock, mHeight );
    if( x % 5 == 0 )
    {
      stroke(21,113,10, 250);
      line(0, x * mBlock, mWidth, x * mBlock );
      line(x*mBlock, 0, x * mBlock, mHeight );
      stroke(21,113,10, 51);
    }
    
    
  }
  
  stroke(21,113,10, 200);
  fill(21,113,10, 200);
  arc( mWidthHalf, mHeight, mBlock, mBlock, PI, PI * 2, PIE);
  stroke(21,113,10, 254);
  noFill();
  arc( mWidthHalf, mHeight, mWidth, mWidth, PI, PI * 2, PIE);
  
}


void drawScan( int num )
{  
  println( "angle:" + num );

  noStroke();
  fill(21,113,10, 50);
  arc( mWidthHalf, mHeight, mWidth, mWidth, PI + ( num / 180.0f - 0.1f ) * PI, PI + ( num / 180.0f + 0.1f ) * PI, PIE);

}

void drawBarrier()
{
  //println( "distance:" + num);
  noStroke();
  fill(21,113,10, 254);
  for( int i = 0; i < 181; i ++ )
  { 
    int a, b, distance;
    distance = a = b = mDistanceArr[i];
    
    if( i - 1 >= 0 )
      a = mDistanceArr[ i - 1 ];
    if( i + 1 <= 180 )
      b = mDistanceArr[ i + 1 ];
    if( distance < 5 || distance > mMaxDistance ) continue;
    if( a < 5 || a > mMaxDistance ) a = distance;
    if( b < 5 || b > mMaxDistance ) b = distance;
    
    distance = (a + b + distance) / 3;
    
    if( distance < 5 || distance >= mMaxDistance ) continue;
    //distance = 60 angle = 45;
    //mWidth / 2;
    float scale = mWidthHalf / mMaxDistance;
    
    int tmpDistance = (int)(distance * scale);
    
    
    int px = (int)(mWidthHalf - tmpDistance * cos(i * PI/180));
    int yy = (int)(tmpDistance * sin(i * PI/180));
    int py = 300 - yy;
    println("scale:" + scale + " angle:" + i + " sin():" + sin(i * PI/180) + " distance:" + distance + " tmpDistance:" + tmpDistance + " x:" + px + " yy:" + yy + "  py:" + py);
    
    ellipse(px, py, 30, 30);
  }
  
}
