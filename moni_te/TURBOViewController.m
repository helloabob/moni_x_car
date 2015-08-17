//
//  TURBOViewController.m
//  moni_te
//
//  Created by mac0001 on 6/10/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "TURBOViewController.h"

#import "ParamButtonView.h"
#import "TSLocateView.h"


static int g_tag;
static ParamButtonView *g_pbv;
//static unsigned char result[33];

@interface TURBOViewController (){
    TSLocateView *locateView;
    UITabView *tabView;
    int currentTabIndex;
    int modeIndex;
    UITextView *testField;
    
}

@end

@implementation TURBOViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didNotReceive{
    if (self.receiveCount == 1) {
        [self updateParamValue];
    }else {
        [super didReceiveData:nil];
    }
}
-(BOOL)didReceiveData:(NSData *)data{
    if (self.receiveCount == 0) {
        [self.bufferData appendData:data];
        self.receiveCount = 1;
        [self performSelector:@selector(sendDelay) withObject:nil afterDelay:0.2];
        return YES;
    }else if (self.receiveCount == 1){
        [self.bufferData appendData:data];
        [self updateParamValue];
    }
    self.receiveCount = 2;
    return YES;
}
- (void)sendDelay{
    unsigned char a=0xd8;
    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
}
- (void)updateParamValue {
    if (self.bufferData.length < 33) {
        return;
    }
    unsigned char *tmp=self.bufferData.bytes;
    for (int i=1; i<7; i++) {
        UIView *view=[tabView viewForIndex:i];
        for (ParamButtonView *pbv in view.subviews) {
            if ([pbv isKindOfClass:[ParamButtonView class]]&&pbv.tag>=1000&&pbv.tag<2000) {
                [pbv setKeyWithResponseBytes:tmp];
            }
        }
    }
    [super didReceiveData:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bufferData = [NSMutableData data];
    self.receiveCount = 0;
    
    [self onRead];
//    unsigned char a=0xd8;
//    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
    //    remove BEC Voltage Output
    //    self.keyArray=@[@"BrakeType",@"BatteryType",@"CutOffVoltageThreshold",@"LowVoltageCutOffType",@"StartUpStrength",@"MotorTiming",@"SBECVoltageOutput",@"MotorRotation"];
    self.keyArray=@[@"BrakeType",@"BatteryType",@"CutOffVoltageThreshold",@"LowVoltageCutOffType",@"StartUpStrength",@"MotorTiming",@"MotorRotation"];
    self.dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"turbo" ofType:@"plist"]];
    
//    self.backImageView.image=[UIImage imageNamed:@"FlashBackImage"];
    self.BlackAreaHidden=NO;
    
    tabView=[[[UITabView alloc]initWithFrame:CGRectMake(4, 3, self.contentView.bounds.size.width-8, self.contentView.bounds.size.height-6)]autorelease];
    tabView.delegate=self;
    [self.contentView addSubview:tabView];
    tabView.numberOfTabs=8;
    
    int contentCenterY=self.contentView.bounds.size.height/2;
    
    /*tab 1*/
    UIView *view=[tabView viewForIndex:0];
    ParamButtonView *pbv1=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], contentCenterY-60, self.pbvWidth, 65) withImageName:@"device" withDelegate:self]autorelease];
    pbv1.tag=500;
    pbv1.desc = @{@"en":@"TO SHOW THE DEVICE INFORMATION",@"cn":@"显示设备信息"};
    [view addSubview:pbv1];
    pbv1.valueString=@"CAR ESC";
    pbv1=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], contentCenterY-60, self.pbvWidth, 65) withImageName:@"hardware" withDelegate:self]autorelease];
    pbv1.tag=501;
    pbv1.desc = @{@"en":@"TO SHOW THE DEVICE INFORMATION",@"cn":@"显示设备信息"};
    [view addSubview:pbv1];
    pbv1.valueString=@"TURBO";
    pbv1=[[[ParamButtonView alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], contentCenterY-60, self.pbvWidth, 65) withImageName:@"software" withDelegate:self]autorelease];
    pbv1.tag=502;
    pbv1.desc = @{@"en":@"TO SHOW THE DEVICE INFORMATION",@"cn":@"显示设备信息"};
    [view addSubview:pbv1];
    pbv1.valueString=@"V1.1";
    
    /*tab 2*/
    self.offset_y = 130;
    view=[tabView viewForIndex:1];
    ParamButtonView2 *pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"promode" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"modes"];
    pbv.paramReadOnly=YES;
    pbv.tag=10001;
    [view addSubview:pbv];
    modeIndex=[Global promode];
    pbv.valueString=pbv.values[modeIndex];
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"runmode" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"runmode"];
    pbv.tag=1000;
    [view addSubview:pbv];
    pbv.valueString=@"Forword/Brake";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"voltagecutoff" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"voltagecutoff"];
    pbv.tag=1002;
    [view addSubview:pbv];
    pbv.valueString=@"Auto";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"escheatprotect" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"escheatprotect"];
    pbv.tag=1003;
    [view addSubview:pbv];
    pbv.valueString=@"105 Degree Celsius";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"mr" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"motorrotation"];
    pbv.tag=1004;
    [view addSubview:pbv];
    pbv.valueString=@"reverse";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"becout" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"becout"];
    pbv.tag=1031;
    [view addSubview:pbv];
    pbv.valueString=@"6.0V";
    
    /*tab 3*/
    self.offset_y = 130;
    view=[tabView viewForIndex:2];
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[3] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"punchrate1" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"punchrate1"];
    pbv.tag=1006;
    [view addSubview:pbv];
    pbv.valueString=@"15";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[4] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"punchrate2" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"punchrate2"];
    pbv.tag=1007;
    [view addSubview:pbv];
    pbv.valueString=@"15";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"threversespd" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"threversespd"];
    pbv.tag=1001;
    [view addSubview:pbv];
    pbv.valueString=@"25%";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"switchpoint1" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"switchpoint1"];
    pbv.tag=1005;
    [view addSubview:pbv];
    pbv.valueString=@"50%";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"thcurve" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"thcurve"];
    pbv.tag=1008;
    [view addSubview:pbv];
    pbv.valueString=@"Linear";
    
    /*tab 4*/
    self.offset_y = 130;
    view=[tabView viewForIndex:3];
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"initialbrake" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"initialbrake"];
    pbv.tag=1011;
    [view addSubview:pbv];
    pbv.valueString=@"Equal Drag Brake";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"dragbrake" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"dragbrake"];
    pbv.tag=1009;
    [view addSubview:pbv];
    pbv.valueString=@"10%";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"brakestrength" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"brakestrength"];
    pbv.tag=1010;
    [view addSubview:pbv];
    pbv.valueString=@"75%";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"brakerate1" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"brakerate1"];
    pbv.tag=1013;
    [view addSubview:pbv];
    pbv.valueString=@"20";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"switchpoint2" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"switchpoint2"];
    pbv.tag=1012;
    [view addSubview:pbv];
    pbv.valueString=@"50%";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"brakerate2" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"brakerate2"];
    pbv.tag=1014;
    [view addSubview:pbv];
    pbv.valueString=@"20";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"brakecurve" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"brakecurve"];
    pbv.tag=1015;
    [view addSubview:pbv];
    pbv.valueString=@"Linear";
    
    /*tab 5*/
    self.offset_y = 130;
    view=[tabView viewForIndex:4];
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[3] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"boosttiming" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"boosttiming"];
    pbv.tag=1016;
    [view addSubview:pbv];
    pbv.valueString=@"0deg";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[4] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"startrpm" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"startrpm1"];
    pbv.tag=1017;
    [view addSubview:pbv];
    pbv.valueString=@"15000";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"endrpm" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"endrpm"];
    pbv.tag=1018;
    [view addSubview:pbv];
    pbv.valueString=@"25000";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"stability" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"stability"];
    pbv.tag=1020;
    [view addSubview:pbv];
    pbv.valueString=@"Yes";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"slope" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"slope"];
    pbv.tag=1019;
    [view addSubview:pbv];
    pbv.valueString=@"Linear";
    
    /*tab 6*/
    self.offset_y = 130;
    view=[tabView viewForIndex:5];
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"turbotiming" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"turbotiming"];
    pbv.tag=1021;
    [view addSubview:pbv];
    pbv.valueString=@"10deg";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"activationmethod" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"activationmethod"];
    pbv.tag=1022;
    [view addSubview:pbv];
    pbv.valueString=@"Full TH";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"turbodelay" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"turbodelay"];
    pbv.tag=1023;
    [view addSubview:pbv];
    pbv.valueString=@"3";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"startrpm" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"startrpm2"];
    pbv.tag=1024;
    [view addSubview:pbv];
    pbv.valueString=@"20000rpm";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"turboslopeon" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"turboslopeon"];
    pbv.tag=1025;
    [view addSubview:pbv];
    pbv.valueString=@"15deg/0.1S";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"turboslopeoff" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"turboslopeoff"];
    pbv.tag=1026;
    [view addSubview:pbv];
    pbv.valueString=@"24deg/0.1S";
    
    /*tab 7*/
    self.offset_y = 130;
    view=[tabView viewForIndex:6];
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"battminvoltage" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"battminvoltage"];
    pbv.tag=1027;
    pbv.paramReadOnly=YES;
    [view addSubview:pbv];
    pbv.valueString=@"unknown";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[0] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"escmaxtemp" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"escmaxtemp"];
    pbv.tag=1028;
    pbv.paramReadOnly=YES;
    [view addSubview:pbv];
    pbv.valueString=@"unknown";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[1] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"motmaxtemp" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"motmaxtemp"];
    pbv.tag=1029;
    pbv.paramReadOnly=YES;
    [view addSubview:pbv];
    pbv.valueString=@"unknown";
    
    self.offset_y += self.padding_y;
    pbv=[[[ParamButtonView2 alloc]initWithFrame:CGRectMake([self.offsetXArray[2] intValue], self.offset_y, self.pbvWidth, 65) withImageName:@"motmaxrpm" withDelegate:self]autorelease];
    [pbv config:self.dict withName:@"motmaxrpm"];
    pbv.tag=1030;
    pbv.paramReadOnly=YES;
    [view addSubview:pbv];
    pbv.valueString=@"unknown";
    
    self.SettingControlViewHidden=NO;
    self.BlackAreaHidden=NO;
    
    [self changeMode:modeIndex];
    
//    testField = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, 320, 230)];
//    testField.textColor = [UIColor blackColor];
//    testField.backgroundColor = [UIColor whiteColor];
//    testField.delegate = self;
//    [self.contentView addSubview:testField];
    
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
////        return NO;
//    }
//    return YES;
//}
-(void)viewDidTapped:(ParamButtonView *)sender{
    if (sender.tag<1000) {
        [self setHelpMsg:[sender.desc objectForKey:[Global language]==1?@"cn":@"en"]];
        return;
    }
    if (g_tag==sender.tag) {
        return;
    }
    if (g_pbv!=nil) {
        [locateView hidePicker];
        locateView=nil;
    }
    g_pbv=sender;
    g_tag=sender.tag;
//    NSDictionary *tmp=nil;
//    tmp=self.dict[self.keyArray[sender.tag-1000]];
//    if (tmp==nil) {
//        return;
//    }
//    NSArray *array=[Global convertStringToArray:tmp forKey:@"ValuesRange"];
    
    [self setHelpMsg:[sender.desc objectForKey:[Global language]==1?@"cn":@"en"]];
    
    locateView = [[TSLocateView alloc] initWithTitle:@"" delegate:self];
    locateView.provinces=sender.values;
    locateView.defaultIndex=sender.getDefaultIndex;
    [locateView showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
    }else {
//        TSLocateView *tv=(TSLocateView *)actionSheet;
//        NSDictionary *tmp=nil;
//        tmp=self.dict[self.keyArray[g_tag-1000]];
//        g_pbv.valueString=tv.provinces[tv.selectedIndex];
        g_pbv.index=locateView.selectedIndex;
        if (g_tag==10001) {
            modeIndex=locateView.selectedIndex;
            [Global setPromode:modeIndex];
            [self changeMode:modeIndex];
        }
//        result[g_tag-1000]=[Global dataFromDict:tmp AtIndex:tv.selectedIndex];
    }
//    [actionSheet release];
//    locateView=nil;
    g_pbv=nil;
    g_tag=0;
}
-(void)changeMode:(int)mode{
    for (int i=1; i<7; i++) {
        UIView *view=[tabView viewForIndex:i];
        for (ParamButtonView *pbv in view.subviews) {
            if ([pbv isKindOfClass:[ParamButtonView class]]&&pbv.tag>=1000&pbv.tag<=10000) {
                [pbv changeToMode:mode];
            }
        }
    }
}
-(void)onRead{
    [super onRead];
    self.receiveCount = 0;
    self.bufferData.length = 0;
    unsigned char a=0xd8;
    [[NetUtils sharedInstance] sendData:[NSData dataWithBytes:&a length:1] withDelegate:self];
    self.isConnected = YES;
}
-(void)onSet{
//    int send_length=7;
//    unsigned char addons[send_length];
//    addons[0]=0xe2;
//    addons[1]=0xe3;
//    addons[2]=0xe4;
//    addons[3]=0xea;
//    addons[4]=0xe9;
//    addons[5]=0xe5;
//    addons[6]=0xe8;
//    unsigned char ret[send_length*2];
//    for (int i=0; i<send_length; i++) {
//        ret[i*2]=addons[i];
//        ret[i*2+1]=result[i];
//    }
    NSMutableData *data=[NSMutableData data];
    for (int i=1; i<7; i++) {
        UIView *view=[tabView viewForIndex:i];
        for (ParamButtonView *pbv in view.subviews) {
            if ([pbv isKindOfClass:[ParamButtonView class]]&&pbv.paramReadOnly==NO) {
                [data appendData:[pbv postedDataWithMode:modeIndex]];
            }
        }
    }
    
//    unsigned char tmp = 0xd4;
//    [data appendBytes:&tmp length:1];
    
//    [[NetUtils sharedInstance] sendData:data withDelegate:nil];
    [self sendSetData:data];
}
-(void)viewDidChanged:(int)index{
    currentTabIndex=index;
    if (index==0) {
        self.SettingControlViewHidden=YES;
    }else{
        self.SettingControlViewHidden=NO;
    }
}
-(BOOL)tabDidClicked:(int)index{
    if (index==7) {
        [self showAlert];
        return NO;
    }else if(index==3){
        [self changeSettingY:20];
    }else{
        [self changeSettingY:0];
    }
    return YES;
}
-(void)returnToDefault{
    for (int i=1; i<7; i++) {
        UIView *view=[tabView viewForIndex:i];
        for (ParamButtonView *pbv in view.subviews) {
            if ([pbv isKindOfClass:[ParamButtonView class]]&&pbv.tag>=1000&&pbv.tag<2000) {
                [pbv returnToDefault];
            }
        }
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