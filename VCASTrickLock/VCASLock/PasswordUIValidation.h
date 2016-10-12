//
//  PasswordUIValidation.h
//  PassWordLockDemo
//
//  Created by VcaiTech on 16/9/28.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassWordCanvas.h"

typedef void (^Failure)();
typedef void (^Success)();
typedef BOOL (^Validation)(NSString *str);

extern NSString *const LocalPass;

@interface PasswordUIValidation : NSObject<PasswordInputCompleteProtocol>
{
    int  errorTimesLeave;
    NSString  *localTempPass;
}


@property(nonatomic,copy)Failure failure;
@property(nonatomic,copy)Success success;
@property(nonatomic,copy)Validation validation;
@property(nonatomic,retain)PassWordCanvas *view;
@property(nonatomic,assign)BOOL isSetLockPass;
@property(nonatomic,assign)BOOL isAlertLockPass;
@property(nonatomic,assign)BOOL isForgetLockPass;
@property(nonatomic,assign)NSInteger lockPassSetTimes;

-(instancetype)initWithPasswordCanvas:(PassWordCanvas *)passCanvas;

@end
