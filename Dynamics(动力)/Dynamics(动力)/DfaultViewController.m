//
//  DfaultViewController.m
//  Dynamics(动力)
//
//  Created by MokZF on 2017/11/20.
//  Copyright © 2017年 MokZF. All rights reserved.
//

#import "DfaultViewController.h"
#import "ViewController.h"

@interface DfaultViewController ()

@end

@implementation DfaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lab = [UILabel new];
    lab.text = @"点击屏幕";
    lab.frame = CGRectMake(90, 90, 90, 90);
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ViewController *vc = [ViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
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
