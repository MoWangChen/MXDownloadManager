# MXDownloadManager
多任务下载器（可实时监控任务下载状态，查看指定任务的工作状态，支持短时间的后台下载，暂不支持断点续传）


##介绍:
一个使用简单的任务下载工具，直接向工具单例类添加任务url，并标注任务名字及唯一标识（查询任务状态需要）即可。



###演示效果
<img src="https://github.com/MoWangChen/MXDownloadManager/raw/master/ScreenShot/download.gif" height="568" width="320" />


##用法:

1.将`MXDownload`文件夹拖入到工程中    

2.导入头文件 `#improt "MXDownloadManager.h"`

3.使用单例工具（可使用此方法，同时添加多个任务）
    
     NSString *urlStr1 = @"http://www.download.com/ia/upload1/2016/03/12/ca27d18ee8ba11e5809d005056897df9.zip";
     
    [[MXDownloadManager sharedDataCenter] addDownloadTaskToList:urlStr1 taskName:@"task_one" taskIdentifier:@"task_first"];
    
    NSString *urlStr2 = @"http://www.download.com/ia/upload1/2015/12/24/ios.zip";
    
    [[MXDownloadManager sharedDataCenter] addDownloadTaskToList:urlStr2 taskName:@"task_two" taskIdentifier:@"task_second"];
    
4.查询任务的工作状态（根据任务唯一标识查询）
	
	MXDownloadModel *task1Model = [[MXDownloadManager sharedDataCenter] askForTaskStatusWithTaskIdentifier:@"task_first"];
	
	MXDownloadModel *task2Model = [[MXDownloadManager sharedDataCenter] askForTaskStatusWithTaskIdentifier:@"task_second"];
   ****
    

##具体实例请下载项目,参照`ViewController`

有问题随时issue或者邮箱<xiepengxiang93@sina.com>联系我.