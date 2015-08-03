//
//  ExitViewController.h
//  moni_te
//
//  Created by wangbo on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "BaseViewController.h"
@interface ExitAlertView : UIBaseImageView
@property(nonatomic,assign)id delegate;
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
@end
@protocol ExitAlertViewDelegate <NSObject>
-(void)popUp;
@end
@interface ExitViewController : BaseViewController
@property(nonatomic,assign)BOOL isExit;
@end
