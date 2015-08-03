//
//  UIBaseButton.h
//  moni_te
//
//  Created by wangbo on 5/30/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBaseButton : UIButton
@property(nonatomic,retain)NSString *offImageName;
@property(nonatomic,retain)NSString *onImageName;
@property(nonatomic,retain)NSString *offBackImageName;
@property(nonatomic,retain)NSString *onBackImageName;
-(void)renderImage;
@end
