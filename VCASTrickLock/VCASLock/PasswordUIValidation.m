//
//  PasswordUIValidation.m
//  PassWordLockDemo
//
//  Created by VcaiTech on 16/9/28.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "PasswordUIValidation.h"

NSString *const LocalPassInputErrorTimes = @"fn_entry_times";
NSString *const LocalPass = @"fn_lock_pass";

@implementation PasswordUIValidation

-(instancetype)initWithPasswordCanvas:(PassWordCanvas *)passCanvas{
    self = [super init];
    if (self) {
        _view = passCanvas;
        _view.errorTipContent.text=@"";
        _view.tipContent.text=@"请输入密码";
        
        _view.delegate = self;
        errorTimesLeave = [self errorEntryTimeLeft];
    }
    return self;
}

-(void)resetUI{
    [_view clearInput];
}


//MARK: PasswordInputCompleteProtocol
-(void)passwordInputComplete:(PassWordCanvas *) passwordContainerView input:(NSString *)input{
    
    if (_isSetLockPass||_isForgetLockPass) {
        
        if (_lockPassSetTimes==1) {
            
            localTempPass = [input copy];
            
            [passwordContainerView nextPasswordInput];
            
            passwordContainerView.tipContent.text=_isForgetLockPass?@"请输入新密码":@"请再次输入密码";
            
            _lockPassSetTimes++;
            
        }else{
            
            if ([localTempPass isEqualToString:input]) {
                [[NSUserDefaults standardUserDefaults]setObject:localTempPass forKey:LocalPass];
                if (self.success) {
                    self.success();
                }
            }else{//两次输入的密码不一致
                passwordContainerView.errorTipContent.text=@"两次输入的密码不一致";
                [passwordContainerView wrongPassword];
                
            }
        }
        
    }else if (_isAlertLockPass){
        
        if (_lockPassSetTimes==1) {
            BOOL model = NO;
            if (self.validation) {
                model = self.validation(input);
            }
            if (model) {
                [passwordContainerView nextPasswordInput];
                passwordContainerView.tipContent.text = @"请输入新密码";
                _lockPassSetTimes++;
            }else{
                errorTimesLeave--;
                if (errorTimesLeave>0) {
                    NSNumber *leftTimes =[NSNumber numberWithInt:errorTimesLeave];
                    [[NSUserDefaults standardUserDefaults]setObject:leftTimes forKey:LocalPassInputErrorTimes];
                    passwordContainerView.errorTipContent.text=[NSString stringWithFormat:@"还可以尝试%d次",errorTimesLeave];
                    [passwordContainerView wrongPassword];
                }else{
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LocalPass];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LocalPassInputErrorTimes];
                    if (self.failure) {
                        self.failure();
                    }
                }
            }
        }else if (_lockPassSetTimes==2){
                localTempPass = [input copy];
                [passwordContainerView nextPasswordInput];
                passwordContainerView.tipContent.text = @"请再次输入新密码";
                _lockPassSetTimes++;
        }else{
                if ([localTempPass isEqualToString:input]) {
                    [[NSUserDefaults standardUserDefaults]setObject:localTempPass forKey:LocalPass];
                    if (self.success) {
                        self.success();
                    }
                }else{//两次输入的密码不一致
                 passwordContainerView.errorTipContent.text=@"两次输入的密码不一致";
                    [passwordContainerView wrongPassword];
                }
        }
    }else{
        
        BOOL model = NO;
        if (self.validation) {
            model = self.validation(input);
        }
        if (model&&self.success) {
            self.success();
        }else{
            errorTimesLeave--;
            if (errorTimesLeave>0) {
                NSNumber *leftTimes =[NSNumber numberWithInt:errorTimesLeave];
                [[NSUserDefaults standardUserDefaults]setObject:leftTimes forKey:LocalPassInputErrorTimes];
                passwordContainerView.errorTipContent.text=[NSString stringWithFormat:@"还可以尝试%d次",errorTimesLeave];
                [passwordContainerView wrongPassword];
            }else{
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:LocalPass];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:LocalPassInputErrorTimes];
                if (self.failure) {
                    self.failure();
                }
            }
        }
        
    }
    
}

-(int)errorEntryTimeLeft{
    NSNumber *times = [[NSUserDefaults standardUserDefaults]objectForKey:LocalPassInputErrorTimes];
    if (!times) {
        return 5;
    }else{
        return [times intValue];
    }
    
}


-(void)touchAuthenticationComplete:(PassWordCanvas *) passwordContainerView success:(BOOL)success error:(NSError *)error{
}

@end
