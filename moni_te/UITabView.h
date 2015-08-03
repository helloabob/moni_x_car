//
//  UITabView.h
//  moni_te
//
//  Created by wangbo on 6/7/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITabViewDelegate <NSObject>
-(BOOL)tabDidClicked:(int)index;
-(void)viewDidChanged:(int)index;
@end

@interface UITabView : UIView
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)int numberOfTabs;
-(UIView *)viewForIndex:(int)index;
@end
