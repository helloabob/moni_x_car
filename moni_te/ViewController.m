//
//  ViewController.m
//  moni_te
//
//  Created by wangbo on 5/29/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"

NSString  *host2=@"192.168.0.101";
//NSString *host2=@"192.168.1.11";
int port2=8008;

@interface ViewController (){
    AsyncUdpSocket *socket;
    CarType state;
    BOOL canActive;
}

@end

@implementation ViewController

-(void)dealloc{
    socket.delegate=nil;
    [socket close];
    [socket release];
    kRemoveNotif(UIApplicationDidEnterBackgroundNotification);
    kRemoveNotif(UIApplicationDidBecomeActiveNotification);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    socket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    [socket bindToPort:8008 error:nil];
    [socket receiveWithTimeout:-1 tag:1];
    canActive=NO;
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, 220, 40)];
    btn.layer.cornerRadius=10;
    [btn setTitle:@"DEV_NOR_CAR" forState:UIControlStateNormal];
    btn.tag=CarTypeNormal;
    btn.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 150, 220, 40)];
    btn.layer.cornerRadius=10;
    [btn setTitle:@"DEV_AIR_CAR" forState:UIControlStateNormal];
    btn.tag=CarTypeAIR;
    btn.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 250, 220, 40)];
    btn.layer.cornerRadius=10;
    [btn setTitle:@"DEV_BOARD" forState:UIControlStateNormal];
    btn.tag=CarTypeBoard;
    btn.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 350, 220, 40)];
    btn.layer.cornerRadius=10;
    [btn setTitle:@"DEV_V3_CAR" forState:UIControlStateNormal];
    btn.tag=CarTypeV3;
    btn.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    kAddObserver(@selector(didEnterBackground), UIApplicationDidEnterBackgroundNotification);
    kAddObserver(@selector(didBecomeActive), UIApplicationDidBecomeActiveNotification);
}

-(void)didEnterBackground{
    canActive=YES;
//    socket.delegate=nil;
    [socket close];
    [socket release];
    socket=nil;
}
-(void)didBecomeActive{
    if (canActive==NO) {
        return;
    }
    socket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    [socket bindToPort:port2 error:nil];
    [socket receiveWithTimeout:-1 tag:1];
    canActive=NO;
}

-(void)test:(UIButton *)btn{
    state=btn.tag;
    unsigned char a=0xd5;
    NSData *data=[NSData dataWithBytes:&a length:1];
    [socket sendData:data toHost:host2 port:port2 withTimeout:5 tag:1];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"data:%@",data);
    unsigned char *dt=data.bytes;
    if (state==CarTypeNormal) {
        if (data.length==1&&dt[0]==0x2b) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:state];
        }else if(data.length==13){
            [socket sendData:[self genTest1:data] toHost:host port:port withTimeout:5 tag:state];
        }
    }else if (state==CarTypeAIR) {
        if (data.length==1&&dt[0]==0x2c) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:state];
        }else if(data.length==9){
            [socket sendData:[self genTest2:data] toHost:host port:port withTimeout:5 tag:state];
        }
    }else if (state==CarTypeV3) {
        if (data.length==1&&dt[0]==0x2a) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:state];
        }else if(data.length==33){
            [socket sendData:[self genTest3:data] toHost:host port:port withTimeout:5 tag:state];
        }
    }else if (state==CarTypeBoard) {
        if (data.length==1&&dt[0]==0x2d) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:state];
        }else if(data.length==8){
            [socket sendData:[self genTest4:data] toHost:host port:port withTimeout:5 tag:state];
        }
    }
    
    return NO;
}

-(NSData *)genTest4:(NSData *)data{
    unsigned char addons[8];
    addons[0]=0xe2;
    addons[1]=0xe3;
    addons[2]=0xe4;
    addons[3]=0xea;
    addons[4]=0xe9;
    addons[5]=0xe5;
    addons[6]=0xe6;
    addons[7]=0xe8;
    return [self saveData:data withConfig:addons];
}

-(NSData *)genTest3:(NSData *)data{
    unsigned char addons[29];
    addons[0]=0xa4;
    addons[1]=0xe8;
    addons[2]=0xec;
    addons[3]=0xef;
    addons[4]=0xe7;
    addons[5]=0xea;
    addons[6]=0xe6;
    addons[7]=0xeb;
    addons[8]=0xe9;
    addons[9]=0xe4;
    addons[10]=0xe3;
    addons[11]=0xed;
    addons[12]=0xee;
    addons[13]=0xa6;
    addons[14]=0xa7;
    addons[15]=0xe1;
    addons[16]=0xe5;
    addons[17]=0xa3;
    addons[18]=0xa8;
    addons[19]=0xa9;
    addons[20]=0xaa;
    addons[21]=0xa1;
    addons[22]=0xab;
    addons[23]=0xa2;
    addons[24]=0xac;
    addons[25]=0xad;
    addons[26]=0xa5;
    addons[27]=0xe0;
    addons[28]=0xe2;
//    addons[27]=0xff;  //unknwon
//    addons[28]=0xff;  //unknwon
//    addons[29]=0xe0;
//    addons[30]=0xe2;
//    addons[31]=0xff;  //unknwon
//    addons[32]=0xff;  //unknwon
    NSMutableData *dd=[NSMutableData data];
    unsigned char *tmp=data.bytes;
    [dd appendBytes:&tmp[0] length:27];
    [dd appendBytes:&tmp[29] length:2];
    return [self saveData:dd withConfig:addons];
}

-(NSData *)genTest2:(NSData *)data{
    unsigned char addons[9];
    addons[0]=0xe2;
    addons[1]=0xe3;
    addons[2]=0xe4;
    addons[3]=0xea;
    addons[4]=0xe9;
    addons[5]=0xe5;
    addons[6]=0xe6;
    addons[7]=0xe8;
    addons[8]=0xe7;
    return [self saveData:data withConfig:addons];
}

-(NSData *)genTest1:(NSData *)data{
    unsigned char addons[11];
    addons[0]=0xec;
    addons[1]=0xe2;
    addons[2]=0xe3;
    addons[3]=0xe4;
    addons[4]=0xe5;
    addons[5]=0xe6;
    addons[6]=0xe7;
    addons[7]=0xe8;
    addons[8]=0xea;
    addons[9]=0xeb;
    addons[10]=0xa1;
    NSMutableData *dd=[NSMutableData data];
    unsigned char *tmp=data.bytes;
    [dd appendBytes:&tmp[0] length:1];
    [dd appendBytes:&tmp[2] length:7];
    [dd appendBytes:&tmp[10] length:3];
    return [self saveData:dd withConfig:addons];
}

-(NSData *)saveData:(NSData *)data withConfig:(unsigned char *)addons{
    NSMutableData *result=[NSMutableData data];
    unsigned char *tmp=data.bytes;
    for (int i=0; i<data.length; i++) {
        [result appendBytes:&addons[i] length:1];
        [result appendBytes:&tmp[i] length:1];
    }
    NSLog(@"send:%@",result);
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
