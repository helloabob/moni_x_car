//
//  BaseViewController.m
//  moni_te
//
//  Created by wangbo on 5/30/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "BaseViewController.h"
#import "ExitViewController.h"
#import "SettingControlView.h"
#import "MBProgressHUD.h"

static int old_y;

@interface BaseViewController (){
    UIView *bottomToolbar;
    UIBaseButton *baseButton;
//    UIView *maskView;
    SettingControlView *scv;
    UIImageView *blackArea;
    UITextView *_tv;
}

@end

@implementation BaseViewController
-(void)dealloc{
    self.dict=nil;
    self.keyArray=nil;
    self.offsetXArray = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *viewBack=[[[UIView alloc]initWithFrame:CGRectMake(0, IsIOS7System?20:0, screenWidth, screenHeight-20)]autorelease];
    [self.view addSubview:viewBack];
//    _backImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, IsIOS7System?20:0, 320, IsiPhone5?548:460)]autorelease];
    _backImageView=[[[UIImageView alloc]initWithFrame:viewBack.bounds]autorelease];
    _backImageView.image=[UIImage imageNamed:@"BlueBackImage"];
    [viewBack addSubview:_backImageView];
    
//    _contentView=[[[UIView alloc]initWithFrame:_backImageView.frame]autorelease];
//    [self.view addSubview:_contentView];
    _contentView=[[[UIView alloc]initWithFrame:_backImageView.bounds]autorelease];
    [viewBack addSubview:_contentView];
    
    bottomToolbar=[[[UIView alloc]initWithFrame:CGRectMake(4, _backImageView.bounds.size.height-34, screenWidth-8, 30)]autorelease];
    [viewBack addSubview:bottomToolbar];
    
    UIImageView *toolbarcenter=[[[UIImageView alloc]initWithFrame:CGRectMake(bottomToolbar.bounds.size.width/2-115, 0, 230, 30)]autorelease];
    toolbarcenter.image=[UIImage imageNamed:@"toolbarcenter"];
    [bottomToolbar addSubview:toolbarcenter];
    
    baseButton=[[[UIBaseButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)]autorelease];
    baseButton.offImageName=@"toolbarexit_off";
    baseButton.onImageName=@"toolbarexit_on";
    [baseButton addTarget:self action:@selector(onExit) forControlEvents:UIControlEventTouchUpInside];
    [baseButton renderImage];
    [bottomToolbar addSubview:baseButton];
    
    UIButton *btn=[[[UIButton alloc]initWithFrame:CGRectMake(bottomToolbar.bounds.size.width-80, 0, 80, 30)]autorelease];
    [btn setImage:[UIImage imageNamed:@"toolbarlanguage_off"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"toolbarlanguage_on"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(changeLanguage) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolbar addSubview:btn];
    
    
//    maskView=[[UIView alloc]initWithFrame:_backImageView.bounds];
    
    scv=[[[SettingControlView alloc]initWithFrame:CGRectMake(10, self.contentView.bounds.size.height-100-50, screenWidth-20, 100)]autorelease];
    scv.hidden=YES;
    old_y=scv.center.y;
    [scv addTarget:self actionRead:@selector(onRead) actionSet:@selector(onSet)];
    [self.contentView addSubview:scv];
    
    blackArea=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, screenWidth-20, 115)] autorelease];
    blackArea.image=[[UIImage imageNamed:@"blackarea"] stretchableImageWithLeftCapWidth:100 topCapHeight:100];
    blackArea.hidden=YES;
    blackArea.userInteractionEnabled=YES;
    UITextView *tv = [[[UITextView alloc] initWithFrame:CGRectMake(10, 10, blackArea.bounds.size.width-20, 95)]autorelease];
    [blackArea addSubview:tv];
    tv.backgroundColor=[UIColor clearColor];
    tv.textColor =[UIColor whiteColor];
    tv.font = [UIFont systemFontOfSize:14];
    tv.showsVerticalScrollIndicator=YES;
    tv.userInteractionEnabled=YES;
    tv.scrollEnabled=YES;
    tv.delegate= self;
    [self.contentView addSubview:blackArea];
    _tv = tv;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    /*2期*/
    _pbvWidth = screenWidth/320.0*100.0;
    self.offsetXArray = @[@1, @(6+_pbvWidth), @(11+_pbvWidth*2), @((screenWidth-10-2*_pbvWidth-5)/2), @((screenWidth-10-2*_pbvWidth-5)/2+_pbvWidth+5)];
    
}
-(void)didEndBackground:(NSNotification *)notif{
    [[NetUtils sharedInstance] closeSocket];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
-(void)setHelpMsg:(NSString *)str{
    _tv.text =str;
//    _tv.text =[str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
//    if (_isConnected==NO) {
//        [[NetUtils sharedInstance] initSocket];
//        _isConnected = YES;
//    }
}
-(void)changeSettingY:(int)y{
    scv.center=CGPointMake(scv.center.x, old_y+y);
}
-(void)showAlert{
    NSString *title=[Global language]==1?@"提示":@"Warning";
    NSString *body=[Global language]==1?@"是否继续?":@"Continue?";
    NSString *strYes=[Global language]==1?@"确定":@"Yes";
    NSString *strNo=[Global language]==1?@"取消":@"No";
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:body delegate:self cancelButtonTitle:strYes otherButtonTitles:strNo, nil];
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"alert_ok");
        [self returnToDefault];
    }else{
    }
}
-(void)returnToDefault{
    [self onSet];
}
-(BOOL)didReceiveData:(NSData *)data{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    return YES;
}
-(void)didNotReceive{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}
-(void)onRead{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}
-(void)onSet{
    
}
-(void)onExit{
    ExitViewController *vc=[[[ExitViewController alloc]init]autorelease];
    vc.isExit=YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
-(void)sendSetData:(NSData *)data {
    NSMutableData *m_data = [NSMutableData dataWithData:data];
    [m_data appendData:data];
    [[NetUtils sharedInstance] sendData:m_data withDelegate:nil];
}
-(void)changeLanguage{
//    Global set
    ExitViewController *vc=[[[ExitViewController alloc]init]autorelease];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)renderImage{
    [baseButton renderImage];
    [scv renderImage];
    for (id view in self.contentView.subviews) {
        if ([view respondsToSelector:@selector(renderImage)]) {
            [view renderImage];
        }
    }
}
-(void)setBlackAreaHidden:(BOOL)BlackAreaHidden{
    blackArea.hidden=BlackAreaHidden;
    [self.contentView bringSubviewToFront:blackArea];
}
-(void)setSettingControlViewHidden:(BOOL)SettingControlViewHidden{
    scv.hidden=SettingControlViewHidden;
    [self.contentView bringSubviewToFront:scv];
}
-(void)setBottomBarHidden:(BOOL)BottomBarHidden{
    bottomToolbar.hidden=BottomBarHidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
