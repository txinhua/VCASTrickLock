//
//  PasswordUIValidation.h
//  PassWordLockDemo
//
//  Created by VcaiTech on 16/9/28.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassWordCanvas.h"

typedef NS_ENUM(NSInteger, VCAsTrickLock) {
    VCAsTrickLockVerify  = 0,
    VCAsTrickLockSet     = 1,
    VCAsTrickLockClose   = 2,
    VCAsTrickLockForget  = 3,
    VCAsTrickLockAlert   = 4,
};

typedef NS_ENUM(NSInteger, VCAsPass) {
    VCAsPassNone    = 0,
    VCAsPassSet     = 1,
    VCAsPassForget  = 2
};

typedef void (^Failure)();
typedef void (^Success)();
typedef void (^ValidationBack)(BOOL isSucess,VCAsTrickLock type);
typedef BOOL (^Validation)(NSString *str);

extern NSString *const LocalPass;
extern NSString *const IsforgetPassWord;




@interface PasswordUIValidation : NSObject<PasswordInputCompleteProtocol>
{
    int  errorTimesLeave;
    NSString  *localTempPass;
}


@property(nonatomic,copy)Failure failure;
@property(nonatomic,copy)Success success;
@property(nonatomic,copy)Validation validation;
@property(nonatomic,retain)PassWordCanvas *view;
@property(nonatomic,assign)VCAsTrickLock vcAsTrickLockType;
@property(nonatomic,assign)NSInteger lockPassSetTimes;

-(instancetype)initWithPasswordCanvas:(PassWordCanvas *)passCanvas;

+(VCAsPass)passStatus;

@end
