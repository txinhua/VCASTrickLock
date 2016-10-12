//
//  VcAsLockViewController.m
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "VcAsLockViewController.h"
#import "PassWordCanvas.h"
#import "MyPasswordUIValidation.h"

@interface VcAsLockViewController (){
    @private
    MyPasswordUIValidation *_passwordUIValidation;
}

@property(nonatomic,weak)IBOutlet PassWordCanvas *passwordCanvas;

@end

NSString *const IsforgetPassWord = @"fn_forget_btn_click";

@implementation VcAsLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordUIValidation = [[MyPasswordUIValidation alloc]initWithPasswordCanvas:self.passwordCanvas];
    __weak VcAsLockViewController *weakSelf = self;
    
    if (_isSetLockPass) {
        
        self.title = @"设置密码";
        _passwordUIValidation.isSetLockPass = _isSetLockPass;
        _passwordUIValidation.lockPassSetTimes = 1;
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
    }else if(_isAlertLockPass){
        
        self.title = @"修改密码";
        
        _passwordUIValidation.isAlertLockPass = _isAlertLockPass;
        
        _passwordUIValidation.lockPassSetTimes = 1;
        _passwordUIValidation.view.tipContent.text=@"请输入旧密码";
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
        
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"忘记密码" style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassword)];
        
    }else if(_isForgetLockPass){
        self.title = @"重置密码";
        _passwordUIValidation.isForgetLockPass = _isForgetLockPass;
        _passwordUIValidation.lockPassSetTimes = 1;
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
    }else{
        
        NSBundle*bundle =[NSBundle mainBundle];
        
        NSDictionary*info =[bundle infoDictionary];
        
        NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
        
        self.title = [NSString stringWithFormat:@"解锁%@",prodName];
        
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"忘记密码" style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassword)];
        
        //密码验证失败时才会调用
        _passwordUIValidation.failure = ^{
            [weakSelf forgetPassword];
        };
    }
    
    //create PasswordUIValidation subclass
    _passwordUIValidation.success = ^{
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:IsforgetPassWord];
        
        [weakSelf dismissSelfController];
    };
    
    // Do any additional setup after loading the view.
}

-(void)dismissSelfController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)forgetPassword{
    
    //重新登录账户后需要记住是否需要再次弹出修改的操作
    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:IsforgetPassWord];
    //依据系统自身的功能切换到相应的页面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
