//
//  WaterView.m
//  Car_iOS
//
//  Created by zhmch0329 on 14-8-20.
//  Copyright (c) 2014年 zhmch0329. All rights reserved.
//

#import "WaterView.h"

#define EXT_ARC_STORKE_WIDTH 10

@interface WaterView ()
{
    NSTimer *_timer;
    
    float a; // 控制水高度（sin函数的最大值）
    float b; // 控制水的流动速度（sin函数偏移量）
    
    BOOL addition;
    
    float radius;
}
@end

@implementation WaterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        radius = MIN(frame.size.width, frame.size.height)/2;
        frame.size = CGSizeMake(2 * radius, 2 * radius);
        self.frame = frame;
        
        a = 1.5;
        b = 0;
        addition = NO;
        
        _waterColor = [UIColor whiteColor];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)animateWave
{
    if (addition) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    if (a<=1) {
        addition = YES;
    }
    
    if (a>=1.5) {
        addition = NO;
    }
    
    b+=0.1;
    
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [_timer invalidate];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, EXT_ARC_STORKE_WIDTH - 4);
    CGContextSetStrokeColorWithColor(context, _waterColor.CGColor);
    CGRect ellipseInRect = CGRectMake(EXT_ARC_STORKE_WIDTH/2, EXT_ARC_STORKE_WIDTH/2, rect.size.width - EXT_ARC_STORKE_WIDTH, rect.size.height - EXT_ARC_STORKE_WIDTH);
    CGContextStrokeEllipseInRect(context, ellipseInRect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    //画水
    CGContextSetFillColorWithColor(context, [_waterColor CGColor]);
    
    CGPathAddArc(path, NULL, radius, radius, radius - EXT_ARC_STORKE_WIDTH, 0, M_PI, 0);
    
    float y = radius;
    CGPathMoveToPoint(path, NULL, EXT_ARC_STORKE_WIDTH, radius);
    for(float x = EXT_ARC_STORKE_WIDTH; x <= 2 * radius - EXT_ARC_STORKE_WIDTH; x ++){
        y = a * sin(x / radius * M_PI + radius/20 * b / M_PI) * (radius/10) + radius;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, 2 * radius - EXT_ARC_STORKE_WIDTH, radius);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
}


@end
