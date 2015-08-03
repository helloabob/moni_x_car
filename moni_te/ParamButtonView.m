//
//  ParamButtonView.m
//  moni_te
//
//  Created by mac0001 on 6/4/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "ParamButtonView.h"

@implementation ParamButtonView{
    UIImageView *titleImageView;
    NSString *_titleImageName;
    UILabel *lblValue;
    NSTimer *_timer;
//    int lbl_width;
    CGRect _rect;
    CGAffineTransform _transform;
    id _delegate;
    NSString *_name;
//    NSArray *keys;
//    NSArray *values;
    unsigned char _precode;
    int defaultIndex;
    UIView *_mask;
}
-(void)dealloc{
    self.keys=nil;
    self.values=nil;
    self.valueString=nil;
    self.modes=nil;
    self.desc=nil;
    [super dealloc];
}
-(int)getDefaultIndex{
    return defaultIndex;
}
-(void)setIndex:(int)index{
    if (_keys==nil) {
        return;
    }
    _index=index;
    self.valueString=_values[index];
}
-(void)returnToDefault{
    self.index=defaultIndex;
}
-(void)config:(NSDictionary *)dict withName:(NSString *)name{
    _name=[[NSString alloc]initWithString:name];
    NSDictionary *info=dict[name];
    if (info[@"PreCode"]==nil) {
        return;
    }
    if (info[@"desc"]) {
        self.desc = info[@"desc"];
    }
    _precode=(unsigned char)strtoul([info[@"PreCode"] UTF8String], 0, 16);
//    if ([name isEqualToString:@"voltagecutoff"]) {
//        NSMutableArray *keyArray = [NSMutableArray array];
//        [keyArray addObject:[NSString stringWithFormat:@"%d",0]];
//        [keyArray addObject:[NSString stringWithFormat:@"%d",1]];
//        for (int i = 30; i < 112; i++) {
//            [keyArray addObject:[NSString stringWithFormat:@"%d", i]];
//        }
//        _keys = [[NSArray alloc] initWithArray:keyArray];
//    } else {
//        _keys=[[NSArray alloc]initWithArray:[Global convertStringToArray:info forKey:@"KeysRange"]];
//    }
    _keys=[[NSArray alloc]initWithArray:[Global convertStringToArray:info forKey:@"KeysRange"]];
    if (info[@"Modes"]!=nil) {
        _modes=[[NSString alloc]initWithString:info[@"Modes"]];
    }
    _index=[info[@"DefaultKey"]intValue];
    defaultIndex=[info[@"DefaultKey"]intValue];
    NSMutableArray *array=[NSMutableArray array];
    if ([name isEqualToString:@"voltagecutoff"]) {
        array[0]=@"disable";
        array[1]=@"AUTO";
//        version 1
//        for (int i = 0; i < 110; i++) {
//            float f = i;
//            f = f/10.0 + 0.2;
//            array[i+2] = [NSString stringWithFormat:@"%.1fV",f];
//        }
        
//        versoin 2
        for (int i=0; i<82; i++) {
            float f=i;
            f=i/10.0+3.0;
            array[i+2]=[NSString stringWithFormat:@"%.1fV",f];
        }
    }else if([name isEqualToString:@"switchpoint1"]){
        for (int i=0; i<99; i++) {
            array[i]=[NSString stringWithFormat:@"%d%%",i+1];
        }
    }else if([name isEqualToString:@"dragbrake"]){
        for (int i=0; i<101; i++) {
            array[i]=[NSString stringWithFormat:@"%d%%",i];
        }
    }else if([name isEqualToString:@"switchpoint2"]){
        for (int i=0; i<99; i++) {
            array[i]=[NSString stringWithFormat:@"%d%%",i+1];
        }
    }else if([name isEqualToString:@"boosttiming"]){
        for (int i=0; i<65; i++) {
            array[i]=[NSString stringWithFormat:@"%ddeg",i];
        }
    }else if([name isEqualToString:@"startrpm1"]){
        for (int i=0; i<69; i++) {
            array[i]=[NSString stringWithFormat:@"%drpm",i*500+1000];
        }
    }else if([name isEqualToString:@"endrpm"]){
        for (int i=0; i<115; i++) {
            array[i]=[NSString stringWithFormat:@"%drpm",i*500+3000];
        }
    }else if([name isEqualToString:@"turbotiming"]){
        for (int i=0; i<65; i++) {
            array[i]=[NSString stringWithFormat:@"%d",i];
        }
    }else if([name isEqualToString:@"turbodelay"]){
        array[0]=@"Instant";
        for (int i=1; i<11; i++) {
            float f=i;
            array[i]=[NSString stringWithFormat:@"%.2fS",f*0.05];
        }
        for (int i=1; i<6; i++) {
            float f=i;
            array[i+10]=[NSString stringWithFormat:@"%.2fS",f*0.1+0.5];
        }
//        for (int i=1; i<21; i++) {
//            float f=i;
//            array[i]=[NSString stringWithFormat:@"%f",f*0.05];
//        }
    }else if([name isEqualToString:@"startrpm2"]){
        for (int i=0; i<43; i++) {
            array[i]=[NSString stringWithFormat:@"%drpm",i*1000+8000];
        }
    }else if([name isEqualToString:@"turboslopeon"]){
        for (int i=0; i<10; i++) {
            array[i]=[NSString stringWithFormat:@"%ddeg/0.1S",i*3+3];
        }
        array[10]=@"Instant";
    }else if([name isEqualToString:@"turboslopeoff"]){
        for (int i=0; i<5; i++) {
            array[i]=[NSString stringWithFormat:@"%ddeg/0.1S",i*6+6];
        }
        array[5]=@"Instant";
    }else if([name isEqualToString:@"motmaxrpm"]){
        for (int i=0; i<256; i++) {
            array[i]=[NSString stringWithFormat:@"%d",i*1000];
        }
    }else{
        array=[NSMutableArray arrayWithArray:[Global convertStringToArray:info forKey:@"ValuesRange"]];
    }
    _values=[[NSArray alloc]initWithArray:array];
}
-(void)setKeyWithResponseBytes:(unsigned char *)bytes{
    if (_keys==nil) {
        return;
    }
    int new_index=-1;
    for (int i=0;i<_keys.count;i++) {
        int some_key = [_keys[i] intValue];
        if (some_key==bytes[self.tag-1000]) {
            new_index=i;
            break;
        }
    }
    if (new_index==-1) {
        new_index=defaultIndex;
    }
    self.index=new_index;
}
-(void)changeToMode:(int)mode{
    if ([_modes rangeOfString:[NSString stringWithFormat:@"%d",mode]].length==0) {
        _mask.hidden=NO;
    }else{
        _mask.hidden=YES;
    }
}
-(NSData *)postedDataWithMode:(int)mode{
    if (_keys==nil) {
        return nil;
    }
    if (_precode==0xff) {
        return nil;
    }
    if (mode!=-1) {
        if (_modes==nil) {
            return nil;
        }
        if ([_modes rangeOfString:[NSString stringWithFormat:@"%d",mode]].length==0) {
            return nil;
        }
    }
    unsigned char ret[2]={_precode,[_keys[_index]intValue]};
    return [NSData dataWithBytes:ret length:2];
}
- (id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _delegate=delegate;
        _titleImageName=[[NSString alloc] initWithString:imageName];
        
        UIImageView *imageView=[[[UIImageView alloc]initWithFrame:self.bounds]autorelease];
        imageView.image=[UIImage imageNamed:@"paramicon"];
        [self addSubview:imageView];
        
        titleImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(17, 13, frame.size.width-34, 14)]autorelease];
        titleImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:titleImageView];
        
        UIView *innerView=[[[UIView alloc]initWithFrame:CGRectMake(10, 35, self.bounds.size.width-20, 25)]autorelease];
        [self addSubview:innerView];
        innerView.layer.masksToBounds=YES;
        
        lblValue=[[[UILabel alloc]initWithFrame:innerView.bounds]autorelease];
        lblValue.textColor=[UIColor whiteColor];
        lblValue.textAlignment=NSTextAlignmentCenter;
        lblValue.font=[UIFont systemFontOfSize:12];
        lblValue.backgroundColor=[UIColor clearColor];
//        lbl_width=lblValue.bounds.size.width;
        _rect = lblValue.frame;
        _transform = lblValue.transform;
        [innerView addSubview:lblValue];
        
        [self renderImage];
        
        UIButton *btn=[[[UIButton alloc]initWithFrame:self.bounds]autorelease];
        btn.backgroundColor=[UIColor clearColor];
        [btn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _mask=[[[UIView alloc]initWithFrame:self.bounds]autorelease];
        _mask.backgroundColor=[UIColor lightGrayColor];
        _mask.layer.cornerRadius=5;
        _mask.alpha=0.3;
        _mask.hidden=YES;
        [self addSubview:_mask];
    }
    return self;
}
-(void)btnTapped{
    if (_delegate&&[_delegate respondsToSelector:@selector(viewDidTapped:)]) {
        [_delegate viewDidTapped:self];
    }
}
-(void)setValueString:(NSString *)valueString{
//    if (lblValue.text==valueString) {
//        return;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^(){
    [lblValue.layer removeAllAnimations];
    lblValue.transform = _transform;
        lblValue.text=valueString;
        CGSize textSize = [lblValue.text sizeWithFont:lblValue.font];
        
        if (textSize.width > _rect.size.width) {
            
//            CGRect lframe = lblValue.frame;
            CGRect lframe = _rect;
            lframe.size.width = textSize.width;
            lblValue.frame = lframe;
            
            float offset = textSize.width - _rect.size.width;
//            CATransition *animation = [CATransaction animation];
//            animation.type = kCATransitionFromLeft;
            
            [UIView animateWithDuration:3.0
                                  delay:0
                                options:UIViewAnimationOptionRepeat //动画重复的主开关
             |UIViewAnimationOptionAutoreverse //动画重复自动反向，需要和上面这个一起用
             |UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                             animations:^{
                                 lblValue.transform = CGAffineTransformMakeTranslation(-offset, 0);
                             }
                             completion:^(BOOL finished) {
                                 
                             }
             ];
        }else{
            lblValue.textAlignment=NSTextAlignmentCenter;
        }
//    });
}

-(void)renderImage{
    titleImageView.image=[UIImage imageNamed:LocalizableString(_titleImageName)];
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
