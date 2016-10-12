//
//  MyPasswordUIValidation.m
//  PassWordLockDemo
//
//  Created by VcaiTech on 16/9/29.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "MyPasswordUIValidation.h"

@implementation MyPasswordUIValidation
-(instancetype)initWithPasswordCanvas:(PassWordCanvas *)passCanvas{
    self = [super initWithPasswordCanvas:passCanvas];
    if(self){
        [self setValidation:^(NSString * str){
            return [MyPasswordModel match:str];
        }];
    }
    return self;
}

-(void)touchAuthenticationComplete:(PassWordCanvas *)passwordContainerView success:(BOOL)success error:(NSError *)error{
    
    if (success){
        
        MyPasswordModel *dummyModel = [[MyPasswordModel alloc]init];
        if (self.success) {
            self.success(dummyModel);
        }
        
    } else {
        
        [passwordContainerView clearInput];
    }

}
@end


@implementation MyPasswordModel

+(BOOL)match:(NSString *)password{
  
    NSString *input =[[NSUserDefaults standardUserDefaults]objectForKey:LocalPass];
    if (input) {
        return [input isEqualToString:password];
    }else{
        return NO;
    }
}

@end
