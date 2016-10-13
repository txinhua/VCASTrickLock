//
//  VcAsLockViewController.h
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPasswordUIValidation.h"

@interface VcAsLockViewController : UIViewController
@property(nonatomic,copy)ValidationBack callBack;
@property(nonatomic,assign)VCAsTrickLock vcAsTrickLockType;

@end
