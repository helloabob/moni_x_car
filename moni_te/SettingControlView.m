//
//  SettingControlView.m
//  moni_te
//
//  Created by wangbo on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "SettingControlView.h"

@implementation SettingControlView{
    UIBaseButton *read;
    UIBaseButton *set;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.commonImageName=@"settings_control_back";
        
        UIBaseButton *btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(20, 50, 100, 30)]autorelease];
        btn.offImageName=@"settings_control_read_w";
        btn.onImageName=@"settings_control_read_o";
        [self addSubview:btn];
        read=btn;
        btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(160+screenWidth-320, 50, 100, 30)]autorelease];
        btn.offImageName=@"settings_control_send_w";
        btn.onImageName=@"settings_control_send_o";
        [self addSubview:btn];
        set=btn;
        
        [self renderImage];
        
    }
    return self;
}

-(void)addTarget:(id)target actionRead:(SEL)aread actionSet:(SEL)aset{
    [read addTarget:target action:aread forControlEvents:UIControlEventTouchUpInside];
    [set addTarget:target action:aset forControlEvents:UIControlEventTouchUpInside];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
