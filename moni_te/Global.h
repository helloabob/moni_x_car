//
//  Global.h
//  moni_te
//
//  Created by wangbo on 5/31/14.
//  Copyright (c) 2014 wb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject
+(BOOL)setLanguage:(int)lang;
+(int)language;
+(int)promode;
+(void)setPromode:(int)p;
+(NSArray *)convertStringToArray:(NSDictionary *)dict forKey:(NSString *)key;
+(NSString *)valueForKey:(unsigned char)key AtDictionary:(NSDictionary *)dic;
+(unsigned char)dataFromDict:(NSDictionary *)dic AtIndex:(int)index;
@end
