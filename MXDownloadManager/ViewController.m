//
//  ViewController.m
//  MXDownloadManager
//
//  Created by 谢鹏翔 on 16/3/14.
//  Copyright © 2016年 谢鹏翔. All rights reserved.
//

#import "ViewController.h"
#import "MXDownloadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *urlStr1 = @"http://api.joyoung.com:8089/ia/upload1/2016/03/12/ca27d18ee8ba11e5809d005056897df9.zip";
    
    NSString *urlStr2 = @"http://apitest.joyoung.com:8089/ia/upload1/2015/12/24/ios.zip";
    
    [[MXDownloadManager sharedDataCenter] addDownloadTaskToList:urlStr1 taskName:@"task_one" taskIdentifier:@"task_first"];
    
    [[MXDownloadManager sharedDataCenter] addDownloadTaskToList:urlStr2 taskName:@"task_two" taskIdentifier:@"task_second"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
