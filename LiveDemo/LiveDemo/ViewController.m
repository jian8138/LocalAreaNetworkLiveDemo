//
//  ViewController.m
//  LiveDemo
//
//  Created by Jian on 2017/1/6.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "ViewController.h"
#import "LiveVC.h"
//#import "UIDevice+SLExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LiveClick:(UIButton *)sender {
    
    [self presentViewController:[LiveVC new] animated:YES completion:nil];
}

@end
