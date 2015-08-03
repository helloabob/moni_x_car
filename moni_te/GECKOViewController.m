//
//  GECKOViewController.m
//  moni_te
//
//  Created by wangbo on 6/7/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "GECKOViewController.h"
#import "ParamButtonView.h"
#import "TSLocateView.h"


static int g_tag;
static ParamButtonView *g_pbv;
static unsigned char result[9];

@interface GECKOViewController (){
    TSLocateView *locateView;
    UITabView *tabView;
}

@end

@implementation GECKOViewController

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
    if (data.length < 9) {
        return YES;
    }
    
    unsigned char *tmp=data.bytes;
    result[0]=tmp[0];
    result[1]=tmp[1];
    result[2]=tmp[2];
    result[3]=tmp[3];
    result[4]=tmp[6];
    result[5]=tmp[5];
    result[6]=tmp[4];
    result[7]=tmp[7];
    result[8]=tmp[8];
    
    ParamButtonView *pbv=nil;
    for (int i=0; i<9; i++) {
        pbv=(ParamButtonView *)[[tabView viewForIndex:1] viewWithTag:(i+1000)];
        pbv.valueString=[Global valueForKey:result[i] AtDictionary:self.dict[self.keyArray[i]]];
    }
    [super didReceiveData:nil];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    unsigned char a=0xd8;
//    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
    [self onRead];
    self.isConnected = YES;
    self.keyArray=@[@"BrakeType",@"BatteryType",@"CutOffVoltageThreshold",@"LowVoltageCutOffType",@"StartUpStrength",@"MotorTiming",@"SBECVoltageOutput",@"MotorRotation",@"GovernorMode"];
    self.dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gecko" ofType:@"plist"]];
    
    self.backImageView.image=[UIImage imageNamed:@"FlashBackImage"];
    
    tabView=[[[UITabView alloc]initWithFrame:CGRectMake(4, 3, self.contentView.bounds.size.width-8, self.contentView.bounds.size.height-6)]autorelease];
    tabView.delegate=self;
    [self.contentView addSubview:tabView];
    tabView.numberOfTabs=3;
    
    /*tab 1*/
    UIView *view=[tabView viewForIndex:0];
    ParamButtonView *pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], 50, self.pbvWidth, 65) withImageName:@"device" withDelegate:self]autorelease];
    pbv.tag=500;
    [view addSubview:pbv];
    pbv.valueString=@"GECKO PLANE";
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], 120, self.pbvWidth, 65) withImageName:@"hardware" withDelegate:self]autorelease];
    pbv.tag=501;
    [view addSubview:pbv];
    pbv.valueString=@"ZTW GECKO";
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], 190, self.pbvWidth, 65) withImageName:@"software" withDelegate:self]autorelease];
    pbv.tag=502;
    [view addSubview:pbv];
    pbv.valueString=@"V1.01";
    
    /*tab 2*/
    view=[tabView viewForIndex:1];
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], 100-41, self.pbvWidth, 65) withImageName:@"brake" withDelegate:self]autorelease];
    pbv.tag=1000;
    [view addSubview:pbv];
    pbv.valueString=@"Brake Off";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], 100-41, self.pbvWidth, 65) withImageName:@"battery" withDelegate:self]autorelease];
    pbv.tag=1001;
    [view addSubview:pbv];
    pbv.valueString=@"LiPo";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], 100-41, self.pbvWidth, 65) withImageName:@"covt" withDelegate:self]autorelease];
    pbv.tag=1002;
    [view addSubview:pbv];
    pbv.valueString=@"3.0V/60%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], 170-41, self.pbvWidth, 65) withImageName:@"mt" withDelegate:self]autorelease];
    pbv.tag=1005;
    [view addSubview:pbv];
    pbv.valueString=@"Auto";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], 170-41, self.pbvWidth, 65) withImageName:@"svo" withDelegate:self]autorelease];
    pbv.tag=1006;
//    pbv.tag = 1004;
    [view addSubview:pbv];
    pbv.valueString=@"5.0V";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], 170-41, self.pbvWidth, 65) withImageName:@"gm" withDelegate:self]autorelease];
    pbv.tag=1008;
    [view addSubview:pbv];
    pbv.valueString=@"RPM OFF";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], 240-41, self.pbvWidth, 65) withImageName:@"mr" withDelegate:self]autorelease];
    pbv.tag=1007;
    [view addSubview:pbv];
    pbv.valueString=@"Forward";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], 240-41, self.pbvWidth, 65) withImageName:@"sts" withDelegate:self]autorelease];
    pbv.tag=1004;
//    pbv.tag = 1006;
    [view addSubview:pbv];
    pbv.valueString=@"10%";
    
    pbv=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], 240-41, self.pbvWidth, 65) withImageName:@"lvcot" withDelegate:self]autorelease];
    pbv.tag=1003;
    [view addSubview:pbv];
    pbv.valueString=@"Reduce Power";
}
-(void)viewDidTapped:(ParamButtonView *)sender{
    if (sender.tag<1000) {
        return;
    }
    if (g_tag==sender.tag) {
        return;
    }
    
    NSDictionary *tmp=nil;
    tmp=self.dict[self.keyArray[sender.tag-1000]];
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
        tmp=self.dict[self.keyArray[g_tag-1000]];
        g_pbv.valueString=tv.provinces[tv.selectedIndex];
        result[g_tag-1000]=[Global dataFromDict:tmp AtIndex:tv.selectedIndex];
    }
    g_pbv=nil;
    g_tag=0;
}
-(void)onRead{
    [super onRead];
    unsigned char a=0xd8;
    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
}
-(void)onSet{
    unsigned char addons[9];
    addons[0]=0xe2;
    addons[1]=0xe3;
    addons[2]=0xe4;
    addons[3]=0xea;
    addons[4]=0xe6;
    addons[5]=0xe5;
    addons[6]=0xe9;
    addons[7]=0xe8;
    addons[8]=0xe7;
    unsigned char ret[18];
    for (int i=0; i<9; i++) {
        ret[i*2]=addons[i];
        ret[i*2+1]=result[i];
    }
//    ret[18]=0xd4;
//    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:ret length:18] withDelegate:nil];
    [self sendSetData:[NSData dataWithBytes:ret length:18]];
}
-(void)viewDidChanged:(int)index{
    if (index==0) {
        self.SettingControlViewHidden=YES;
    }else{
        self.SettingControlViewHidden=NO;
    }
}
-(BOOL)tabDidClicked:(int)index{
    if (index==2) {
        [self showAlert];
        return NO;
    }
    return YES;
}
-(void)returnToDefault{
    UIView *view=[tabView viewForIndex:1];
    for (ParamButtonView *pbv in view.subviews) {
        NSDictionary *tmp=nil;
        tmp=self.dict[self.keyArray[pbv.tag-1000]];
        NSArray *values=[Global convertStringToArray:tmp forKey:@"ValuesRange"];
        int defaultKey=[tmp[@"DefaultKey"] intValue];
        pbv.valueString=values[defaultKey];
        result[pbv.tag-1000]=[Global dataFromDict:tmp AtIndex:defaultKey];
    }
    [super returnToDefault];
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
