//
//  MCExpressionConvertor.m
//  Expression
//
//  Created by zhmch0329 on 15/11/3.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

#import "MCExpressionConvertor.h"

@implementation MCExpressionConvertor {
    NSMutableDictionary *_expressionDictionary;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _expressionDictionary = [[NSMutableDictionary alloc] init];
        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"txt"];
        NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSArray *array = [string componentsSeparatedByString:@"\r\n"];
        for (NSString *lineString in array) {
            NSArray *lineArray = [lineString componentsSeparatedByString:@","];
            [_expressionDictionary setObject:[lineArray firstObject] forKey:[lineArray lastObject]];
        }
    }
    return self;
}

+ (instancetype)sharedInstance {
    static MCExpressionConvertor *expressionConvertor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expressionConvertor = [[MCExpressionConvertor alloc] init];
    });
    return expressionConvertor;
}

- (NSString *)expressionConvertFromString:(NSString *)string {
    NSError *error = NULL;
    NSString * regex = @"\\[[^\\]]+\\]";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
    for (NSInteger i = matches.count - 1; i >= 0; i --) {
        NSRange resultRange = [matches[i] range];
        NSString *resultString = [string substringWithRange:resultRange];
        [mutableString replaceCharactersInRange:resultRange withString:[self htmlImgWithWord:resultString]];
    }
    
    return mutableString;
}

- (NSString *)htmlImgWithWord:(NSString *)word {
    NSString *imageName = [_expressionDictionary objectForKey:word];
    NSString *htmlString = [NSString stringWithFormat:@"<img src='%@' height=20 width=20/>", imageName];
    return htmlString;
}

@end
