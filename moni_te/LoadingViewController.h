//
//  LoadingViewController.h
//  moni_te
//
//  Created by wangbo on 5/31/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "BaseViewController.h"

@interface ConnectionFailedAlertView : UIBaseImageView
@property(nonatomic,assign)id delegate;
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
@end
@protocol ConnectionFailedAlertViewDelegate <NSObject>
-(void)reconnect;
@end

@interface LoadingViewController : BaseViewController
@end
