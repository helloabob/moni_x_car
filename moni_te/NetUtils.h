//
//  NetUtils.h
//  moni_te
//
//  Created by mac0001 on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    CarTypeNormal=1,    //BEAST
    CarTypeAIR,         //GECKO
    CarTypeV3,          //TURBO
    CarTypeBoard,       //SEAL
    CarTypeTP,          //TP
}CarType;
@protocol NetUtilsDelegate <NSObject>
-(BOOL)didReceiveData:(NSData *)data;
-(void)didNotReceive;
@end
@interface NetUtils : NSObject
+ (instancetype)sharedInstance;
@property(nonatomic,assign)id delegate;
-(void)sendData:(NSData *)data withDelegate:(id)delegate;
-(void)closeSocket;
-(void)initSocket;
@end
