//
//  PassWordInputView.m
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "PassWordInputView.h"

@interface PassWordInputView ()
{
    BOOL touchUpFlag;
    BOOL isAnimating;
    
@private
    UIButton *button;
    UIColor  *backColor;
    UIColor  *circleBackgroundColor;
    UIColor  *highlightBackgroundColor;
    UIColor  *textColor;
    UIColor  *subtextColor;
    
}
@end


@implementation PassWordInputView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initVar];
    }
    return self;
}


-(void)initVar{
    
    _circleView = [[UIView alloc]init];
    
    button =[[UIButton alloc]init];
    
    _label =[[UILabel alloc]init];
    
    _charestLabel = [[UILabel alloc]init];
    
    backColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
    circleBackgroundColor = [UIColor whiteColor];
    highlightBackgroundColor= [UIColor colorWithRed:226/255.0 green:227/255.0 blue:228/255.0 alpha:1.0];
    textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];;
    subtextColor= [UIColor colorWithRed:172/255.0 green:172/255.0 blue:173/255.0 alpha:1.0];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateUI];
}

-(void)updateUI{
    
    CGFloat const width  = self.frame.size.width;
    CGFloat const height = self.frame.size.height;
    
    _label.text = _numberString;
    _label.textColor = textColor;
    _label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    _charestLabel.text=_charestString;
    _charestLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    _charestLabel.textColor = subtextColor;
    
    NSArray *midStrs =@[@"2",@"5",@"8"];
    if ([midStrs containsObject: _numberString] ) {
        _circleView.frame =CGRectMake(1, 1,width-2,height-1);
    }else{
        _circleView.frame =CGRectMake(0, 1,width,height-1);
    }
    _label.frame = CGRectMake(1, (height-24)*0.5-2, width-2, 24);
    _charestLabel.frame = CGRectMake(1, (height-24)*0.5+18, width-2, 16);
    [button setFrame:CGRectMake(0, 0, width, height)];
    
    //update circle view
    _circleView.backgroundColor = circleBackgroundColor;
    //update mask
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
    //update color
    self.backgroundColor = backColor;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self configureSubviews];
}

-(void)configureSubviews{
    
    [self addSubview:_circleView];
    //configure label
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    _charestLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_charestLabel];
    //configure button
    [self addSubview:button];
    [button setExclusiveTouch:YES];
    [button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel|UIControlEventTouchDragExit];
    
}



#pragma mark - MARK: Animation

-(void)touchDownAction{
    
    _circleView.backgroundColor = highlightBackgroundColor;
    
}

-(void)touchUpAction{
    
    _circleView.backgroundColor = circleBackgroundColor;
    
}

-(void)touchDownAnimation{
    
    isAnimating = YES;
    
    [self tappedAnimation:^{
        
        [self touchDownAction];
        
    } completion:^(BOOL finished) {
        
        if (touchUpFlag){
            [self touchUpAnimation];
        } else {
            isAnimating = NO;
        }
        
    }];
    
}

-(void)touchUpAnimation{
    
    isAnimating = YES;
    
    [self tappedAnimation:^{
        
        [self touchUpAction];
        
    } completion:^(BOOL finished) {
        
        isAnimating = NO;
        
    }];
    
}

-(void)tappedAnimation:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}


-(void)touchDown{
    
    //delegate callback
    if (_delegate&&[_delegate respondsToSelector:@selector(passwordInputView:tappedString:)]) {
        
        [_delegate passwordInputView:self tappedString:_numberString];
        
    }
    //now touch down, so set touch up flag --> false
    touchUpFlag = NO;
    
    [self touchDownAnimation];
    
}

-(void)touchUp{
    
    //now touch up, so set touch up flag --> true
    touchUpFlag = YES;
    //only show touch up animation when touch down animation finished
    if (!isAnimating) {
        
        [self touchUpAnimation];
        
    }
    
}



@end
