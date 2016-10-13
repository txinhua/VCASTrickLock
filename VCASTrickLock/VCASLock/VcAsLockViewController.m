//
//  VcAsLockViewController.m
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "VcAsLockViewController.h"

@interface VcAsLockViewController (){
    @private
    MyPasswordUIValidation *_passwordUIValidation;
}

@property(nonatomic,weak)IBOutlet PassWordCanvas *passwordCanvas;

@end



@implementation VcAsLockViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _passwordUIValidation = [[MyPasswordUIValidation alloc]initWithPasswordCanvas:self.passwordCanvas];
    __weak VcAsLockViewController *weakSelf = self;
    _passwordUIValidation.vcAsTrickLockType = _vcAsTrickLockType;
    if (_vcAsTrickLockType==VCAsTrickLockSet) {
        
        self.title = @"设置密码";
        _passwordUIValidation.lockPassSetTimes = 1;
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
        
    }else if(_vcAsTrickLockType==VCAsTrickLockAlert){
        
        self.title = @"修改密码";
        
        _passwordUIValidation.lockPassSetTimes = 1;
        _passwordUIValidation.view.tipContent.text=@"请输入旧密码";
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
        
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"忘记密码" style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassword)];
        
    }else if(_vcAsTrickLockType==VCAsTrickLockForget){
        self.title = @"重置密码";
        _passwordUIValidation.lockPassSetTimes = 1;
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
    }else if(_vcAsTrickLockType==VCAsTrickLockClose){
        
        NSBundle*bundle =[NSBundle mainBundle];
        
        NSDictionary*info =[bundle infoDictionary];
        
        NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
        
        self.title = [NSString stringWithFormat:@"关闭%@密码锁",prodName];
        
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelfController)];
        
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"忘记密码" style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassword)];
        
        //密码验证失败时才会调用
        _passwordUIValidation.failure = ^{
            [weakSelf forgetPassword];
        };
        
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
        
        [weakSelf vaSucess];
        
    };
    
    // Do any additional setup after loading the view.
}

-(void)vaSucess{
    
    assert(_callBack);
    if (_vcAsTrickLockType==VCAsTrickLockClose) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:LocalPass];
    }
    _callBack(YES,_vcAsTrickLockType);
    
}

-(void)dismissSelfController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)forgetPassword{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LocalPass];
    //重新登录账户后需要记住是否需要再次弹出修改的操作
    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:IsforgetPassWord];
    //依据系统自身的功能切换到相应的页面
    assert(_callBack);
    _callBack(NO,_vcAsTrickLockType);
    
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
