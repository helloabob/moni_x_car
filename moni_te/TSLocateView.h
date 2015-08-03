//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
//#import "TSLocation.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
//    NSArray *provinces;
    NSArray	*cities;
}
//@property(nonatomic,assign)id delegate;
@property (strong ,nonatomic) NSArray *provinces;
@property(nonatomic,assign) int defaultIndex;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
//@property (strong, nonatomic) TSLocation *locate;
@property (assign, nonatomic) int selectedIndex;

@property (strong, nonatomic) IBOutlet UIImageView *titleView;
@property (retain, nonatomic) IBOutlet UIButton *locateButton;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
-(void)hidePicker;

@end
