//
//  PassWordInputView.h
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassWordInputView;

@protocol PasswordInputViewTappedProtocol <NSObject>
-(void)passwordInputView:(PassWordInputView *) passwordInputView tappedString:(NSString *)tappedString;
@end


@interface PassWordInputView : UIView

@property(nonatomic,strong,readonly)IBInspectable NSString *numberString;
@property(nonatomic,strong,readonly)IBInspectable NSString *charestString;

@property(nonatomic,weak)id<PasswordInputViewTappedProtocol>delegate;
@property(nonatomic,strong)UILabel  *label;
@property(nonatomic,strong)UILabel  *charestLabel;
@property(nonatomic,strong)UIView   *circleView;


@end
