//
//  UITabView.m
//  moni_te
//
//  Created by wangbo on 6/7/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "UITabView.h"

@implementation UITabView{
    UIView *tabMenuBar;
    UIView *panel;
    NSArray *menuArray;
    int currentTabIndex;
    BOOL canPan;
}

-(void)dealloc{
    [menuArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        panel=[[[UIView alloc]initWithFrame:CGRectMake(0, 38, frame.size.width, frame.size.height-38)]autorelease];
        [self addSubview:panel];
        
        menuArray=[[NSArray alloc]initWithObjects:@"firmware",@"general",@"default", nil];
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        [pan release];
        canPan=YES;
    }
    return self;
}
-(void)pan:(UIPanGestureRecognizer *)gest{
//    CGPoint pt=[gest locationInView:self];
    if (!canPan) {
        return;
    }
    CGPoint pt2=[gest translationInView:self];
    if (pt2.x>50) {
        //previous
        if (currentTabIndex>0) {
            int tag=currentTabIndex-1+2000;
            [self tabClicked:(UIButton *)[tabMenuBar viewWithTag:tag]];
            canPan=NO;
            [self performSelector:@selector(resetCanPan) withObject:nil afterDelay:0.3];
        }
    }else if(pt2.x<-50){
        //next
        if (currentTabIndex<_numberOfTabs-2) {
            int tag=currentTabIndex+1+2000;
            [self tabClicked:(UIButton *)[tabMenuBar viewWithTag:tag]];
            canPan=NO;
            [self performSelector:@selector(resetCanPan) withObject:nil afterDelay:0.3];
        }
    }
//    NSLog(@"pt2:%@",NSStringFromCGPoint(pt2));
}
-(void)resetCanPan{
    canPan=YES;
}
-(void)setNumberOfTabs:(int)numberOfTabs{
    _numberOfTabs=numberOfTabs;
    
    if (numberOfTabs==8) {
        menuArray=[[NSArray alloc]initWithObjects:@"firmware",@"general",@"throttle",@"brake",@"boost",@"turbo",@"data",@"default", nil];
    }
    
    tabMenuBar=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40*numberOfTabs, 38)]autorelease];
    [self addSubview:tabMenuBar];
    
    for (int i=0; i<numberOfTabs; i++) {
        UIBaseButton *btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(i*40, 0, 39, 38)]autorelease];
        btn.offImageName=[NSString stringWithFormat:@"%@_off",menuArray[i]];
        btn.onImageName=[NSString stringWithFormat:@"%@_on",menuArray[i]];
        btn.offBackImageName=@"header_off";
        btn.onBackImageName=@"header_on";
        btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        btn.imageEdgeInsets=UIEdgeInsetsMake(2, 4, 4, 4);
        btn.tag=2000+i;
        [btn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabMenuBar addSubview:btn];
        if (i<numberOfTabs-1) {
            UIImageView *split=[[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 0, 1, 38)]autorelease];
            split.image=[UIImage imageNamed:@"header_split"];
            [tabMenuBar addSubview:split];
        }
        
        
        UIView *view=[[[UIView alloc]initWithFrame:panel.bounds]autorelease];
        view.tag=2000+i;
        view.hidden=YES;
        [panel addSubview:view];
        
        if (i==0) {
//            btn.selected=YES;
            [self tabClicked:btn];
        }
    }
    tabMenuBar.center=CGPointMake(self.bounds.size.width/2, 19);
    [self renderImage];
    
}
-(UIView *)viewForIndex:(int)index{
    int tag=index+2000;
    return [panel viewWithTag:tag];
}
-(void)tabClicked:(UIButton *)sender{
    BOOL canContinue=YES;
    if (_delegate&&[_delegate respondsToSelector:@selector(tabDidClicked:)]) {
        canContinue=[_delegate tabDidClicked:sender.tag-2000];
    }
    if (canContinue==NO) {
        return;
    }
    currentTabIndex=sender.tag-2000;
    for (UIButton *btn in tabMenuBar.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected=NO;
        }
    }
    sender.selected=YES;
    for (UIView *view in panel.subviews) {
        if (view.tag==sender.tag) {
            view.hidden=NO;
        }else{
            view.hidden=YES;
        }
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(viewDidChanged:)]) {
        [_delegate viewDidChanged:sender.tag-2000];
    }
}
-(void)renderImage{
    for (id view in tabMenuBar.subviews) {
        if ([view respondsToSelector:@selector(renderImage)]) {
            [view renderImage];
        }
    }
    for (UIView *view in panel.subviews) {
        for (id sub in view.subviews) {
            if ([sub respondsToSelector:@selector(renderImage)]) {
                [sub renderImage];
            }
        }
    }
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
