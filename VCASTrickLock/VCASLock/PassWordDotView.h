//
//  PassWordDotView.h
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordDotView : UIView

@property(nonatomic,assign)NSInteger inputDotCount;
@property(nonatomic,assign)NSInteger totalDotCount;
@property(nonatomic,retain)UIColor *strokeColor ;
@property(nonatomic,retain)UIColor * fillColor ;
@property(nonatomic,assign)BOOL isFull ;

-(void)shakeAnimationWithCompletion:(void (^)(void))completion;

-(void)shakeRightAnimationWithCompletion:(void (^)(void))completion;

@end
