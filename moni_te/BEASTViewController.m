//
//  BEASTViewController.m
//  moni_te
//
//  Created by wangbo on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "BEASTViewController.h"
#import "SettingControlView.h"
#import "ParamButtonView.h"
#import "TSLocateView.h"

static int g_tag;
static ParamButtonView *g_pbv;
static unsigned char result[11];

@interface BEASTViewController (){
    UIImageView *logo;
    TSLocateView *locateView;
}

@end

@implementation BEASTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)didReceiveData:(NSData *)data{
//    NSLog(@"dt:%@",data);
    if (data.length < 13) {
        return YES;
    }
    unsigned char *tmp=data.bytes;
    result[0]=tmp[0];
    result[1]=tmp[2];
    result[2]=tmp[3];
    result[3]=tmp[4];
    result[4]=tmp[5];
    result[5]=tmp[6];
    result[6]=tmp[7];
    result[7]=tmp[8];
    result[8]=tmp[10];
    result[9]=tmp[11];
    result[10]=tmp[12];
    
    ParamButtonView *pbv=nil;
    for (int i=0; i<10; i++) {
        pbv=(ParamButtonView *)[self.contentView viewWithTag:(i+1)];
        pbv.valueString=[Global valueForKey:result[i] AtDictionary:self.dict[self.keyArray[i]]];
    }
    [super didReceiveData:nil];
    return YES;
}
-(void)onRead{
    [super onRead];
    unsigned char a=0xd8;
    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
}
-(void)onSet{
    int send_length=10;
    unsigned char addons[send_length];
    addons[0]=0xec;
    addons[1]=0xe2;
    addons[2]=0xe3;
    addons[3]=0xe4;
    addons[4]=0xe5;
    addons[5]=0xe6;
    addons[6]=0xe7;
    addons[7]=0xe8;
    addons[8]=0xea;
    addons[9]=0xeb;
//    addons[10]=0xa1;
    
    
    
    unsigned char ret[send_length*2];
    for (int i=0; i<send_length; i++) {
        ret[i*2]=addons[i];
        ret[i*2+1]=result[i];
    }
//    ret[send_length*2]=0xd4;
    
//    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:ret length:send_length*2] withDelegate:nil];
    [self sendSetData:[NSData dataWithBytes:ret length:send_length*2]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    unsigned char a=0xd8;
//    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
    [self onRead];
    self.isConnected = YES;
    self.keyArray=@[@"CutOffVoltage",@"RunningMode",@"PercentageBraking",@"PercentageDragBrake",@"MotorTiming",@"InitialAcceleration",@"ThrottleLimit",@"ThrottlePercentReverse",@"NeutralRange",@"MotorRotation"];
    self.dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beast" ofType:@"plist"]];
    
    self.backImageView.image=[UIImage imageNamed:@"FlashBackImage"];
    self.SettingControlViewHidden=NO;
    
//    UIBaseButton *btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(250, 3, 39, 38)]autorelease];
//    btn.offImageName=[NSString stringWithFormat:@"%@_off",@"default"];
//    btn.onImageName=[NSString stringWithFormat:@"%@_on",@"default"];
//    btn.offBackImageName=@"header_off";
//    btn.onBackImageName=@"header_on";
//    btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    btn.imageEdgeInsets=UIEdgeInsetsMake(2, 4, 4, 4);
//    btn.tag=2000;
//    [btn renderImage];
//    [btn addTarget:self action:@selector(showdefault) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:btn];
    
    ParamButtonView *pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[1] intValue], 30, self.pbvWidth, 65) withImageName:@"runningmode" withDelegate:self]autorelease];
    pbv.tag=2;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[0] intValue], 100, self.pbvWidth, 65) withImageName:@"mt" withDelegate:self]autorelease];
    pbv.tag=5;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"Normal";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[1] intValue], 100, self.pbvWidth, 65) withImageName:@"ic" withDelegate:self]autorelease];
    pbv.tag=6;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"High";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[2] intValue], 100, self.pbvWidth, 65) withImageName:@"mr" withDelegate:self]autorelease];
    pbv.tag=10;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"Normal";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[0] intValue], 170, self.pbvWidth, 65) withImageName:@"tpr" withDelegate:self]autorelease];
    pbv.tag=8;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"60%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[1] intValue], 170, self.pbvWidth, 65) withImageName:@"tl" withDelegate:self]autorelease];
    pbv.tag=7;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"50%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[2] intValue], 170, self.pbvWidth, 65) withImageName:@"nr" withDelegate:self]autorelease];
    pbv.tag=9;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"4%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[0] intValue], 240, self.pbvWidth, 65) withImageName:@"pb" withDelegate:self]autorelease];
    pbv.tag=3;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"50%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[1] intValue], 240, self.pbvWidth, 65) withImageName:@"pdb" withDelegate:self]autorelease];
    pbv.tag=4;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"0%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake(5+[self.offsetXArray[2] intValue], 240, self.pbvWidth, 65) withImageName:@"cov" withDelegate:self]autorelease];
    pbv.tag=1;
    [self.contentView addSubview:pbv];
    pbv.valueString=@"3.0V/Cell";
}

- (void)showdefault{
    [self showAlert];
}

-(void)returnToDefault{
    UIView *view=self.contentView;
    for (ParamButtonView *pbv in view.subviews) {
        if(![pbv isKindOfClass:[ParamButtonView class]])continue;
        NSDictionary *tmp=nil;
        tmp=self.dict[self.keyArray[pbv.tag-1]];
        NSArray *values=[Global convertStringToArray:tmp forKey:@"ValuesRange"];
        int defaultKey=[tmp[@"DefaultKey"] intValue];
        pbv.valueString=values[defaultKey];
        result[pbv.tag-1]=[Global dataFromDict:tmp AtIndex:defaultKey];
    }
    [super returnToDefault];
}

-(void)viewDidTapped:(ParamButtonView *)sender{
    
    if (g_tag==sender.tag) {
        return;
    }
    
    NSDictionary *tmp=nil;
    tmp=self.dict[self.keyArray[sender.tag-1]];
    if (tmp==nil) {
        return;
    }
    NSArray *array=[Global convertStringToArray:tmp forKey:@"ValuesRange"];
    
    if (g_pbv!=nil) {
        [locateView hidePicker];
        locateView=nil;
    }
    g_pbv=sender;
    g_tag=sender.tag;
    locateView = [[TSLocateView alloc] initWithTitle:@"" delegate:self];
    locateView.provinces=array;
    locateView.defaultIndex=[tmp[@"DefaultKey"]intValue];
    [locateView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
    }else {
        TSLocateView *tv=(TSLocateView *)actionSheet;
        NSDictionary *tmp=nil;
        tmp=self.dict[self.keyArray[g_tag-1]];
        g_pbv.valueString=tv.provinces[tv.selectedIndex];
        result[g_tag-1]=[Global dataFromDict:tmp AtIndex:tv.selectedIndex];
    }
    g_pbv=nil;
    g_tag=0;
}
-(void)enter{
    [logo removeFromSuperview];
    self.backImageView.image=[UIImage imageNamed:@"FlashBackImage"];
    
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
