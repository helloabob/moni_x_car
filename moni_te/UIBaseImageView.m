//
//  UIBaseImageView.m
//  moni_te
//
//  Created by wangbo on 5/30/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "UIBaseImageView.h"

@implementation UIBaseImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
        
    }
    return self;
}
-(void)renderImage{self.image=[UIImage imageNamed:LocalizableString(self.commonImageName)];
    for (id sub in self.subviews) {
        if ([sub respondsToSelector:@selector(renderImage)]) {
            [sub renderImage];
        }
    }
}

//-(void)setCurrentImageIndex:(int)currentImageIndex{
//    self.image=[UIImage imageNamed:self.arrayImageNames[currentImageIndex]];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
