//
//  MCExpressionConvertor.h
//  Expression
//
//  Created by zhmch0329 on 15/11/3.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCExpressionConvertor : NSObject

+ (instancetype)sharedInstance;

- (NSString *)expressionConvertFromString:(NSString *)string;

@end
