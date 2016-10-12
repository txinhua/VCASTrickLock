//
//  PassWordCanvas.h
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassWordDotView.h"
#import "PassWordInputView.h"

@class PassWordCanvas;

@protocol PasswordInputCompleteProtocol <NSObject>

-(void)passwordInputComplete:(PassWordCanvas*)passwordContainerView input:(NSString *)input;

-(void)touchAuthenticationComplete:(PassWordCanvas *) passwordContainerView success:(BOOL)success error:(NSError *)error;

@end

@interface PassWordCanvas : UIView
@property(nonatomic,weak)IBOutlet UILabel *tipContent;
@property(nonatomic,weak)IBOutlet UILabel *errorTipContent;
@property(nonatomic,strong)IBOutletCollection(PassWordInputView) NSArray *passwordInputViews;
@property(nonatomic,weak)IBOutlet PassWordDotView *passwordDotView;
@property(nonatomic,weak)IBOutlet UIButton *deleteButton;
@property(nonatomic,weak)IBOutlet UIButton * touchAuthenticationButton;

@property(nonatomic,weak)id<PasswordInputCompleteProtocol> delegate;

@property(nonatomic,assign)BOOL isVibrancyEffect;

@property(nonatomic,copy)UIColor *highlightedColor;

@property(nonatomic,assign)BOOL isTouchAuthenticationAvailable;

@property(nonatomic,assign)BOOL touchAuthenticationEnabled;

-(void)clearInput;
-(void)wrongPassword;
-(void)nextPasswordInput;

@end
