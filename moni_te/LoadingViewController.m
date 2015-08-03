//
//  LoadingViewController.m
//  moni_te
//
//  Created by wangbo on 5/31/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "LoadingViewController.h"
#import "BEASTViewController.h"
#import "GECKOViewController.h"
#import "SEALViewController.h"
#import "TURBOViewController.h"
#import "TPViewController.h"

@implementation ConnectionFailedAlertView
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.commonImageName=@"connectfailalert";
        self.delegate=delegate;
        
        UIBaseButton *btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(25, 95, 67, 21)]autorelease];
        btn.offImageName=@"buttonyes_off";
        btn.onImageName=@"buttonyes_on";
        [btn addTarget:self action:@selector(reconnect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(115, 95, 67, 21)]autorelease];
        btn.offImageName=@"buttonquit_off";
        btn.onImageName=@"buttonquit_on";
        [btn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    return self;
}
-(void)reconnect{if([_delegate respondsToSelector:@selector(reconnect)])[_delegate reconnect];}
-(void)quit{abort();}
@end

@interface LoadingViewController (){
    int state;
    UILabel *lblConnecting;
    ConnectionFailedAlertView *cfav;
    UIImageView *logo;
    CarType carType;
}

@end

@implementation LoadingViewController
-(void)renderImage{
    [super renderImage];
    [cfav renderImage];
    lblConnecting.text=NSLocalizedString(LocalizableString(@"connecting"), nil);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)didReceiveData:(NSData *)data{
    if (data.length==1) {
        if (logo==nil) {
            logo=[[UIImageView alloc]initWithFrame:CGRectMake(50, self.contentView.bounds.size.height/2-48, screenWidth-100, 81)];
        }
        unsigned char a;
        [data getBytes:&a];
        if (a==0x2b) {
            //normal_car BEAST
            carType=CarTypeNormal;
            logo.image=[UIImage imageNamed:@"BEAST"];
        }else if(a==0x2c){
            //BC AIR GECKO
            carType=CarTypeAIR;
            logo.image=[UIImage imageNamed:@"GECKO"];
        }else if(a==0x2a){
            //V3 TURBO
            carType=CarTypeV3;
            logo.image=[UIImage imageNamed:@"TURBO"];
//            carType=CarTypeTP;
//            logo.image=[UIImage imageNamed:@"TP"];
        }else if(a==0x2d){
            //boat SEAL
            carType=CarTypeBoard;
            logo.image=[UIImage imageNamed:@"SEAL"];
        }else if(a==0x29){
            carType=CarTypeTP;
            logo.image=[UIImage imageNamed:@"TP"];
        }
        if (lblConnecting.superview!=nil) {
            [lblConnecting removeFromSuperview];
        }
        if (cfav.superview!=nil) {
            [cfav removeFromSuperview];
        }
        [self.contentView addSubview:logo];
        [self performSelector:@selector(nextPage) withObject:nil afterDelay:1];
//        unsigned char b=0xd8;
//        [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&b length:1] withDelegate:self];
    }else{
        [self showReconnectionAlert];
    }
    return YES;
}
-(void)nextPage{
    NSLog(@"next_page");
    UIViewController *vc=nil;
    NSString *className=nil;
    if (carType==CarTypeNormal) {
        className=@"BEASTViewController";
    }else if(carType==CarTypeAIR){
        className=@"GECKOViewController";
    }else if(carType==CarTypeBoard){
        className=@"SEALViewController";
    }else if(carType==CarTypeV3){
        className=@"TURBOViewController";
    }else if(carType==CarTypeTP){
        className=@"TPViewController";
    }
    vc=[[[NSClassFromString(className) alloc]init]autorelease];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)showReconnectionAlert{
    if (lblConnecting.superview!=nil) {
        [lblConnecting removeFromSuperview];
    }
    if (logo.superview!=nil) {
        [logo removeFromSuperview];
    }
    if (cfav==nil) {
        cfav=[[ConnectionFailedAlertView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width/2-103, self.contentView.bounds.size.height/2-70, 207, 140) withDelegate:self];
    }
    [cfav renderImage];
    [self.contentView addSubview:cfav];
}
-(void)didNotReceive{
    NSLog(@"failed");
    [self showReconnectionAlert];
}
-(void)reconnect{
    if (cfav.superview!=nil) {
        [cfav removeFromSuperview];
    }
    if (logo.superview!=nil) {
        [logo removeFromSuperview];
    }
    [self startConnecting];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (cfav&&cfav.superview!=nil) {
        [cfav removeFromSuperview];
    }
    if (logo&&logo.superview!=nil) {
        [logo removeFromSuperview];
    }
    [self startConnecting];
}
-(void)startConnecting{
    if (lblConnecting==nil) {
        lblConnecting=[[UILabel alloc]initWithFrame:CGRectMake(0, self.contentView.bounds.size.height/2-20, screenWidth, 40)];
        lblConnecting.font=[UIFont boldSystemFontOfSize:16];
        lblConnecting.textAlignment=NSTextAlignmentCenter;
        lblConnecting.textColor=[UIColor whiteColor];
        lblConnecting.backgroundColor=[UIColor clearColor];
    }
    lblConnecting.text=NSLocalizedString(LocalizableString(@"connecting"), nil);
    [self.contentView addSubview:lblConnecting];
    unsigned char a=0xd5;
    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    state=0;
    self.BottomBarHidden=YES;
//    [self performSelector:@selector(onSuccess) withObject:nil afterDelay:1];
}

-(void)quit{
    NSLog(@"aaaaa");
}

-(void)onSuccess{
    BEASTViewController *vc=[[[BEASTViewController alloc]init]autorelease];
    [self.navigationController pushViewController:vc animated:NO];
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
