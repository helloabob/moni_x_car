//
//  NetUtils.m
//  moni_te
//
//  Created by mac0001 on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "NetUtils.h"
#import "AsyncUdpSocket.h"

@interface NetUtils()
@property(nonatomic,retain)NSData *mdata;
@property(nonatomic,retain)NSString *host2;
@end
@implementation NetUtils{
    AsyncUdpSocket *socket;
    CarType type;
    int threadshold;
    int resend_count;
    int port2;
    BOOL inProgress;
}
+ (instancetype)sharedInstance{
    static NetUtils *sharedNetUtilsInstance = nil;
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        sharedNetUtilsInstance = [[self alloc] init];
    });
    return sharedNetUtilsInstance;
}
-(void)initSocket{
    if (socket == nil) {
//        socket=[[AsyncUdpSocket alloc]initWithDelegate:self];
        socket = [[AsyncUdpSocket alloc] initIPv4];
        socket.delegate = self;
        [socket bindToPort:8008 error:nil];
        threadshold=2;
        port2=8008;
//        self.host2=@"192.168.1.11";
        self.host2=@"192.168.0.105";
//        self.host2=@"131.252.85.70";
        inProgress = NO;
    }
    
}
-(void)closeSocket{
    if (socket!=nil) {
        [socket close];
        socket = nil;
    }
}
-(void)sendData:(NSData *)data withDelegate:(id)delegate{
    NSLog(@"try to send");
    [self initSocket];
    if (inProgress==YES) {
        NSLog(@"inProgress_over");
        return;
    }
    NSLog(@"sent:%@ and len:%d and tag:%d",data,data.length, 1);
    _delegate=delegate;
    self.mdata=[NSData dataWithBytes:data.bytes length:data.length];
    resend_count=0;
//    current_tag = global_tag;
    [socket sendData:data toHost:_host2 port:port2 withTimeout:1 tag:1];
    if (delegate!=nil) {
        inProgress = YES;
        [socket receiveWithTimeout:3 tag:1];
    }
}

/**/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceive");
    inProgress = NO;
    if (_delegate==nil) {
        [self closeSocket];
        return;
    }
//    if (resend_count<threadshold) {
//        resend_count++;
//        [socket sendData:_mdata toHost:_host2 port:port2 withTimeout:1 tag:1];
//        [socket receiveWithTimeout:2 tag:1];
//        return;
//    }
    if (_delegate&&[_delegate respondsToSelector:@selector(didNotReceive)]) {
        [_delegate didNotReceive];
    }
    [self closeSocket];
}
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    inProgress = NO;
    NSLog(@"recv:%@",data);
//    NSLog(@"rec:%@ and tag:%ld and global_tag:%d",data,tag,global_tag);
    if (_delegate&&[_delegate respondsToSelector:@selector(didReceiveData:)]) {
        NSData *dt = [NSData dataWithData:data];
        [self closeSocket];
        NSLog(@"recv2:%@",dt);
        return [_delegate didReceiveData:dt];
    }
    return YES;
    
    unsigned char *dt=data.bytes;
    if (type==CarTypeNormal) {
        if (data.length==1&&dt[0]==0x2b) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:type];
        }else if(data.length==13){
            [socket sendData:[self genTest1:data] toHost:host port:port withTimeout:5 tag:type];
        }
    }else if (type==CarTypeAIR) {
        if (data.length==1&&dt[0]==0x2c) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:type];
        }else if(data.length==9){
            [socket sendData:[self genTest2:data] toHost:host port:port withTimeout:5 tag:type];
        }
    }else if (type==CarTypeV3) {
        if (data.length==1&&dt[0]==0x2a) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:type];
        }else if(data.length==33){
            [socket sendData:[self genTest3:data] toHost:host port:port withTimeout:5 tag:type];
        }
    }else if (type==CarTypeBoard) {
        if (data.length==1&&dt[0]==0x2d) {
            unsigned char a=0xd8;
            NSData *data=[NSData dataWithBytes:&a length:1];
            [socket sendData:data toHost:host port:port withTimeout:5 tag:type];
        }else if(data.length==8){
            [socket sendData:[self genTest4:data] toHost:host port:port withTimeout:5 tag:type];
        }
    }
    return YES;
}

-(NSData *)genTest4:(NSData *)data{
    unsigned char addons[33];
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
@end
