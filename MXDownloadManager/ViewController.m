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
@property (weak, nonatomic) IBOutlet UILabel *task1_progress;
@property (weak, nonatomic) IBOutlet UILabel *task1_speed;
@property (weak, nonatomic) IBOutlet UILabel *task1_size;

@property (weak, nonatomic) IBOutlet UILabel *task2_progress;

@property (weak, nonatomic) IBOutlet UILabel *task2_speed;
@property (weak, nonatomic) IBOutlet UILabel *task2_size;

@end

@implementation ViewController
{
    NSTimer *_timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (IBAction)startDownloadTask1:(id)sender {
     NSString *urlStr1 = @"http://api.joyoung.com:8089/ia/upload1/2016/03/12/ca27d18ee8ba11e5809d005056897df9.zip";
    
    [[MXDownloadManager sharedDataCenter] addDownloadTaskToList:urlStr1 taskName:@"task_one" taskIdentifier:@"task_first"];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCheckTaskStatus) userInfo:nil repeats:YES];
        [_timer fire];
    }
}


- (IBAction)startDownloadTask2:(id)sender {
    NSString *urlStr2 = @"http://apitest.joyoung.com:8089/ia/upload1/2015/12/24/ios.zip";
    
    [[MXDownloadManager sharedDataCenter] addDownloadTaskToList:urlStr2 taskName:@"task_two" taskIdentifier:@"task_second"];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCheckTaskStatus) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

- (void)timeCheckTaskStatus
{
    MXDownloadModel *task1Model = [[MXDownloadManager sharedDataCenter] askForTaskStatusWithTaskIdentifier:@"task_first"];
    if (task1Model) {
        _task1_progress.text = [NSString stringWithFormat:@"已下载： %.1f%%",task1Model.taskProgress*100];
        _task1_speed.text = [NSString stringWithFormat:@"下载速度：%@",task1Model.taskSpeed];
        _task1_size.text = [NSString stringWithFormat:@"任务大小：%@",task1Model.taskSize];
    }
    
    MXDownloadModel *task2Model = [[MXDownloadManager sharedDataCenter] askForTaskStatusWithTaskIdentifier:@"task_second"];
    if (task2Model) {
        _task2_progress.text = [NSString stringWithFormat:@"已下载： %.1f%%",task2Model.taskProgress*100];
        _task2_speed.text = [NSString stringWithFormat:@"下载速度：%@",task2Model.taskSpeed];
        _task2_size.text = [NSString stringWithFormat:@"任务大小：%@",task2Model.taskSize];
    }
    
}

@end
