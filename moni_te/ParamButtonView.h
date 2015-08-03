//
//  ParamButtonView.h
//  moni_te
//
//  Created by mac0001 on 6/4/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParamButtonView : UIView
- (id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withDelegate:(id)delegate;
@property(nonatomic,retain)NSString *valueString;
-(void)renderImage;
/*TURBO*/
@property(nonatomic,assign)int index;
-(void)config:(NSDictionary *)dict withName:(NSString *)name;
-(void)setKeyWithResponseBytes:(unsigned char *)bytes;
-(NSData *)postedDataWithMode:(int)mode;
@property(nonatomic,retain)NSArray *keys;
@property(nonatomic,retain)NSArray *values;
@property(nonatomic,retain)NSString *modes;
@property(nonatomic,retain)NSDictionary *desc;
@property(nonatomic,assign)BOOL paramReadOnly;
@property(nonatomic,assign,readonly)int getDefaultIndex;
-(void)returnToDefault;
-(void)changeToMode:(int)mode;
@end
