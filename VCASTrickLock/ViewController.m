//
//  ViewController.m
//  VCASTrickLock
//
//  Created by VcaiTech on 2016/10/12.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "ViewController.h"
#import "VcAsLockViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)doSetOption:(id)sender {
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"VcAsLock" bundle:[NSBundle mainBundle]];
    
    VcAsLockViewController *vcLockView = [storyBoard instantiateViewControllerWithIdentifier:@"VcAsLockViewC"];
    
    if (vcLockView) {
        
        vcLockView.vcAsTrickLockType = VCAsTrickLockClose;
        
        vcLockView.callBack = ^(BOOL isSuccess,VCAsTrickLock vcAsTrickLockType){
        
        };
        
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vcLockView];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
