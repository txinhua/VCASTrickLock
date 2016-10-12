//
//  PassWordDotView.m
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "PassWordDotView.h"

@interface UIBezierPath (circleWithCenter)

+(instancetype)circleWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth;

+(instancetype)rectangleWithCenter:(CGPoint)center sideLength:(CGFloat)length radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth;
@end

@implementation UIBezierPath (circleWithCenter)

+(instancetype)circleWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    
    [bezierPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2.0 * M_PI clockwise:NO];
    bezierPath.lineWidth = lineWidth;
    
    return bezierPath;
    
}


+(instancetype)rectangleWithCenter:(CGPoint)center sideLength:(CGFloat)length radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    
    CGPoint start1Point = CGPointMake(center.x-length*0.5, center.y-length*0.5);
    CGRect rectangleRect = CGRectMake(start1Point.x, start1Point.y, length, length);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectangleRect cornerRadius:radius];
    
    bezierPath.lineWidth = lineWidth;
    
    return bezierPath;
}

@end

@interface PassWordDotView ()
{
    
    NSInteger shakeCount;
    BOOL direction;
@private
    
    CGFloat radius;
    
    CGFloat spacingRatio;
    
    CGFloat borderWidthRatio;
    
}
@end

IB_DESIGNABLE
@implementation PassWordDotView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _totalDotCount = 4;
    }
    return self;
}
#pragma mark - dotView cycle
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    _isFull = (_inputDotCount == _totalDotCount);
    
    [_strokeColor setStroke];
    
    [_fillColor setFill];
    
    BOOL const isOdd = (_totalDotCount % 2) != 0;
    
    NSArray *positions = [self getDotPositions:isOdd];
    
    CGFloat borderWidth = 1;
    
    [positions enumerateObjectsUsingBlock:^(NSValue  *obj, NSUInteger idx, BOOL * stop) {
        
        CGPoint position = obj.CGPointValue;
        
        UIBezierPath *pathToStroke = [UIBezierPath rectangleWithCenter:position sideLength:radius*2 radius:4 lineWidth:borderWidth];
        [pathToStroke stroke];
        
        if (idx<_inputDotCount) {
            
            UIBezierPath *pathToFill = [UIBezierPath circleWithCenter:position radius:6 lineWidth:borderWidth];
            [pathToFill fill];
        }
    }];
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    borderWidthRatio = 0.2;
    radius = 18;
    spacingRatio = 2;
    self.backgroundColor =[UIColor clearColor];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    //    [self updateRadius];
    [self setNeedsDisplay];
}

-(void)shakeAnimationwithDuration:(NSTimeInterval)duration  animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.01 initialSpringVelocity:0.35 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
    
}

//MARK: Update Radius
-(void)updateRadius{
    
    float const width = self.frame.size.width;
    float const height = self.frame.size.height;
    radius = height / 2 - height / 2 * borderWidthRatio;
    float const spacing = radius * spacingRatio;
    float const count = _totalDotCount;
    float const spaceCount = count - 1;
    if (count * radius * 2 + spaceCount * spacing > width) {
        radius = floor((width / (count + spaceCount)) / 2);
    } else {
        radius = floor(height / 2);
    }
    radius = radius - radius * borderWidthRatio;
}

//MARK: Dots Layout
-(NSArray *)getDotPositions:(BOOL)isOdd{
    
    CGFloat const centerX = self.center.x;
    CGFloat const centerY = self.frame.size.height*0.5;
    //    CGFloat const spacing = radius * spacingRatio;
    CGFloat const spacing = 14;
    CGFloat const middleIndex = isOdd ? (_totalDotCount + 1) / 2 : (_totalDotCount) / 2;
    CGFloat const offSet = isOdd ? 0 : -(radius + spacing / 2);
    NSMutableArray *positions  =[NSMutableArray arrayWithCapacity:_totalDotCount];
    for (int index = 1 ;index<=_totalDotCount;index++) {
        CGFloat  i = middleIndex - index;
        CGFloat positionX = centerX - (radius * 2 + spacing) * i + offSet;
        CGPoint point = CGPointMake(positionX, centerY);
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        [positions addObject:pointValue];
    }
    return positions;
}

-(void)shakeRightAnimationWithCompletion:(void (^)(void))completion{
    
    CGFloat const  centerX = self.center.x;
    CGFloat const  centerY = self.center.y;
    float duration = 0.10;
    CGFloat moveX = centerX*2;
    [self shakeAnimationwithDuration:duration animations:^{
        self.center = CGPointMake(centerX - moveX, centerY) ;
    } completion:^(BOOL finished) {
        
        [self shakeAnimationwithDuration:duration animations:^{
            CGFloat const realCenterX = self.superview.center.x;
            self.center = CGPointMake(realCenterX, centerY);
        } completion:^(BOOL finished) {
            completion();
        }];
        
    }];
    
}

-(void)shakeAnimationWithCompletion:(void (^)(void))completion{
    NSInteger const maxShakeCount = 5;
    
    CGFloat const  centerX = self.center.x;
    CGFloat const  centerY = self.center.y;
    float duration = 0.10;
    CGFloat moveX = 5;
    if (shakeCount == 0 || shakeCount == maxShakeCount) {
        duration *= 0.5;
    } else {
        moveX *= 2;
    }
    [self shakeAnimationwithDuration:duration animations:^{
        if (!direction) {
            self.center = CGPointMake(centerX + moveX, centerY) ;
        } else {
            self.center = CGPointMake(centerX - moveX, centerY) ;
        }
    } completion:^(BOOL finished) {
        if (shakeCount >= maxShakeCount) {
            
            [self shakeAnimationwithDuration:duration animations:^{
                CGFloat const realCenterX = self.superview.center.x;
                self.center = CGPointMake(realCenterX, centerY);
            } completion:^(BOOL finished) {
                direction = false;
                shakeCount = 0;
                completion();
            }];
            
        } else {
            shakeCount += 1;
            direction = !direction;
            [self shakeAnimationWithCompletion:completion];
        }
    }];
    
}


-(void)setInputDotCount:(NSInteger)inputDotCount {
    
    _inputDotCount = inputDotCount;
    
    [self setNeedsDisplay];
}

-(void)setTotalDotCount:(NSInteger)totalDotCount{
    
    _totalDotCount = totalDotCount;
    
    [self setNeedsDisplay];
    
}

-(void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
    
    [self setNeedsDisplay];
}


-(void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}


@end
