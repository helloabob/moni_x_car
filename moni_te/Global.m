//
//  Global.m
//  moni_te
//
//  Created by wangbo on 5/31/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import "Global.h"

//static int __language;

@implementation Global
+(int)promode{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"promode"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"promode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"promode"] intValue];
}
+(void)setPromode:(int)p{
    int global_lang=[self promode];
    if (global_lang!=p) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",p] forKey:@"promode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
+(BOOL)setLanguage:(int)lang{
    int global_lang=[self language];
    if (global_lang!=lang) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",lang] forKey:@"language"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
    return NO;
}
+(int)language{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"language"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"language"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"language"] intValue];
}
+(unsigned char)dataFromDict:(NSDictionary *)dic AtIndex:(int)index{
    NSArray *array=[self convertStringToArray:dic forKey:@"KeysRange"];
    int ret=[array[index] intValue];
    unsigned char a=ret;
    return a;
}
+(NSString *)valueForKey:(unsigned char)key AtDictionary:(NSDictionary *)dic{
    NSArray *array=[self convertStringToArray:dic forKey:@"KeysRange"];
    int index=-1;
    for (int i=0; i<array.count; i++) {
        if ([array[i] intValue]==key) {
            index=i;
            break;
        }
    }
    if (index==-1) {
        index=[dic[@"DefaultKey"] intValue];
    }
    if (index>-1) {
        NSArray *arr=[self convertStringToArray:dic forKey:@"ValuesRange"];
        return arr[index];
    }
    return nil;
}
+(NSArray *)convertStringToArray:(NSDictionary *)dict forKey:(NSString *)key{
    NSString *values=dict[key];
    NSArray *array=nil;
    if ([values rangeOfString:@","].length==0) {
        if ([values rangeOfString:@"-"].length>0) {
            NSArray *arr=[values componentsSeparatedByString:@"-"];
            int start=[arr[0] intValue];
            int end=[arr[1] intValue];
            NSMutableArray *ar=[NSMutableArray array];
            for (int i=start; i<=end; i++) {
                [ar addObject:[NSString stringWithFormat:@"%d",i]];
            }
            array=[NSArray arrayWithArray:ar];
        }else{
            return nil;
        }
    }else{
        array=[values componentsSeparatedByString:@","];
    }
    return array;
}
@end
