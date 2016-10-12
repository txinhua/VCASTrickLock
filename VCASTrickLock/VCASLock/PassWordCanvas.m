//
//  PassWordCanvas.m
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "PassWordCanvas.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface PassWordCanvas ()<PasswordInputViewTappedProtocol>
{
    LAContext *touchIDContext;
@private
    NSMutableString  *inputString;
    
}
@end

@implementation PassWordCanvas

@dynamic isTouchAuthenticationAvailable;


-(void)clearInput{
    
    inputString = [NSMutableString stringWithString:@""];
    self.passwordDotView.inputDotCount = inputString.length;
    
}

-(void)inputString:(NSString *)inputStr{
    inputString = [NSMutableString stringWithString:inputStr];
    self.passwordDotView.inputDotCount = inputString.length;
    [self checkInputComplete];
    
}


-(void)setTintColor:(UIColor *)tintColor{
    if (!_isVibrancyEffect) {
        
        [_deleteButton setTitleColor:tintColor forState:UIControlStateNormal|UIControlStateHighlighted] ;
        
        _passwordDotView.strokeColor = tintColor;
        
        _touchAuthenticationButton.tintColor = tintColor;
        
    }
    
}

-(void)checkInputComplete{
    if (inputString.length == _passwordDotView.totalDotCount) {
        if (_delegate&&[_delegate respondsToSelector:@selector(passwordInputComplete: input:)]) {
            [_delegate passwordInputComplete:self input:inputString];
        }
    }
}

-(void)setHighlightedColor:(UIColor *)highlightedColor{
    _highlightedColor = highlightedColor;
    if (!_isVibrancyEffect) {
        self.passwordDotView.fillColor = highlightedColor;
    }
}

-(BOOL)isIsTouchAuthenticationAvailable{
    
    return [touchIDContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

-(void)setTouchAuthenticationEnabled:(BOOL)touchAuthenticationEnabled {
    
    _touchAuthenticationEnabled = touchAuthenticationEnabled;
    BOOL enable = (self.isTouchAuthenticationAvailable && touchAuthenticationEnabled);
    _touchAuthenticationButton.alpha = enable ? 1.0 : 0.0;
    _touchAuthenticationButton.userInteractionEnabled = enable;
}


-(void)setIsVibrancyEffect:(BOOL)isVibrancyEffect{
    
    _isVibrancyEffect  = isVibrancyEffect;
    
    [self configureVibrancyEffect];
    
}


-(void)configureVibrancyEffect{
    
    UIColor *whiteColor  = [UIColor whiteColor];
    UIColor *clearColor = [UIColor clearColor];
    //delete button title color
    UIColor *titleColor;
    //dot view stroke color
    UIColor *strokeColor;
    //dot view fill color
    UIColor *fillColor;
    //input view background color
    UIColor *circleBackgroundColor;
    UIColor *highlightBackgroundColor;
    UIColor *borderColor;
    //input view text color
    UIColor *textColor;
    UIColor *highlightTextColor;
    
    if (_isVibrancyEffect){
        //delete button
        titleColor = whiteColor;
        //dot view
        strokeColor = whiteColor;
        fillColor = whiteColor;
        //input view
        circleBackgroundColor = clearColor;
        highlightBackgroundColor = whiteColor;
        borderColor = clearColor;
        textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
        highlightTextColor = whiteColor;
    } else {
        //delete button
        titleColor = self.tintColor;
        //dot view
        strokeColor = self.tintColor;
        
        fillColor = _highlightedColor;
        //input view
        circleBackgroundColor = whiteColor;
        highlightBackgroundColor = _highlightedColor;
        borderColor = self.tintColor;
        textColor = self.tintColor;
        highlightTextColor = _highlightedColor;
    }
    
    [_deleteButton setTitleColor:titleColor forState:UIControlStateNormal];
    _passwordDotView.strokeColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0];
    _passwordDotView.fillColor = [UIColor blackColor];
    _touchAuthenticationButton.tintColor = strokeColor;
    
}

//MARK: IBAction
-(IBAction)deleteInputString:(id)sender{
    
    if(inputString.length > 0){
        [inputString deleteCharactersInRange:NSMakeRange(inputString.length-1, 1)];
    }
    NSLog(@"%@",inputString);
    self.passwordDotView.inputDotCount = inputString.length;
    
    
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self clearInput];
    
    self.backgroundColor = [UIColor whiteColor];
    for (PassWordInputView *pa in self.passwordInputViews) {
        [pa setDelegate:self];
    }
    
    [_deleteButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    [_deleteButton.titleLabel setMinimumScaleFactor:0.5];
    
    _touchAuthenticationEnabled = NO;
    
    self.isVibrancyEffect = YES;
}

-(void)wrongPassword{
    
    [self.passwordDotView shakeAnimationWithCompletion:^{
        [self clearInput];
    }];
    
}

-(void)nextPasswordInput{
    
    [self.passwordDotView shakeRightAnimationWithCompletion:^{
        [self clearInput];
    }];
}


-(void)passwordInputView:(PassWordInputView *) passwordInputView tappedString:(NSString *)tappedString{
    
    if (inputString.length < _passwordDotView.totalDotCount) {
        [inputString appendString:tappedString];
    }
    
    self.passwordDotView.inputDotCount = inputString.length;
    
    [self checkInputComplete];
}
@end
