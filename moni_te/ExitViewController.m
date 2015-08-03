//
//  ExitViewController.m
//  moni_te
//
//  Created by wangbo on 6/1/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "ExitViewController.h"

@implementation ExitAlertView
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.commonImageName=@"quitalert";
        self.delegate=delegate;
        
        UIBaseButton *btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(25, 95, 67, 21)]autorelease];
        btn.offImageName=@"buttonpos_off";
        btn.onImageName=@"buttonpos_on";
        [btn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn=[[[UIBaseButton alloc]initWithFrame:CGRectMake(115, 95, 67, 21)]autorelease];
        btn.offImageName=@"buttonneg_off";
        btn.onImageName=@"buttonneg_on";
        [btn addTarget:self action:@selector(popUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    return self;
}
-(void)popUp{if([_delegate respondsToSelector:@selector(popUp)])[_delegate popUp];}
-(void)quit{abort();}
@end

@interface ExitViewController ()

@end

@implementation ExitViewController

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
    self.BottomBarHidden=YES;
    if (_isExit==YES) {
        ExitAlertView *eav=[[[ExitAlertView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width/2-103, self.contentView.bounds.size.height/2-70, 207, 140) withDelegate:self]autorelease];
        [eav renderImage];
        [self.contentView addSubview:eav];
    }else{
        self.backImageView.image=[UIImage imageNamed:@"FlashBackImage"];
        UIButton *btn=[[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 95, 95)]autorelease];
        [btn setImage:[UIImage imageNamed:@"buttonen"] forState:UIControlStateNormal];
        btn.center=CGPointMake(self.contentView.bounds.size.width/2, self.contentView.bounds.size.height/2-15-47);
        [self.contentView addSubview:btn];
        btn.tag=2;
        [btn addTarget:self action:@selector(change_lang:) forControlEvents:UIControlEventTouchUpInside];
        btn=[[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 95, 95)]autorelease];
        [btn setImage:[UIImage imageNamed:@"buttoncn"] forState:UIControlStateNormal];
        btn.center=CGPointMake(self.contentView.bounds.size.width/2, self.contentView.bounds.size.height/2+15+47);
        [self.contentView addSubview:btn];
        btn.tag=1;
        [btn addTarget:self action:@selector(change_lang:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)change_lang:(UIButton *)sender{
    BOOL fg=[Global setLanguage:sender.tag];
    if (fg) {
        for (id vc in self.navigationController.viewControllers) {
            if ([vc respondsToSelector:@selector(renderImage)]) {
                [vc renderImage];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)popUp{
    [self.navigationController popViewControllerAnimated:NO];
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
