//
//  MyPasswordUIValidation.h
//  PassWordLockDemo
//
//  Created by VcaiTech on 16/9/29.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "PasswordUIValidation.h"

@interface MyPasswordModel : NSObject
+(BOOL)match:(NSString *)password;
@end

@interface MyPasswordUIValidation : PasswordUIValidation
@end



