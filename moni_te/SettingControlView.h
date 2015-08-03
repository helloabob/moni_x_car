//
//  SettingControlView.h
//  moni_te
//
//  Created by wangbo on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "UIBaseImageView.h"

@interface SettingControlView : UIBaseImageView
-(void)addTarget:(id)target actionRead:(SEL)aread actionSet:(SEL)aset;
@end
