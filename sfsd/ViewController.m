//
//  ViewController.m
//  sfsd
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"



@interface ViewController ()<NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
////        if (status == AFNetworkReachabilityStatusNotReachable) {
////            [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
////                // 把暂停下载的时候的数据存储到全局变量中
////                NSLog(@"%lu", resumeData.length);
////                self.downloadData = resumeData;
////            }];
////
////        }
//    }];
//    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (IBAction)startAction:(id)sender {
    if (self.downloadTask) {
        NSLog(@"继续下载");
        NSLog(@"%lu", self.downloadData.length);
        // 把存储的下载数据给通过网络传递给服务器继续下载
        self.downloadTask = [self.session downloadTaskWithResumeData:self.downloadData];
    }else{
        NSLog(@"开始下载");
        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://pianke.file.alimmdn.com/upload/20160628/0fc1f8b2288a91cde68808126e1fe121.MP3"]];
    }
    
    // 开始任务
    [self.downloadTask resume];
}
- (IBAction)stopAction:(id)sender {
    NSLog(@"暂停下载");
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        // 把暂停下载的时候的数据存储到全局变量中
        NSLog(@"%lu", resumeData.length);
        self.downloadData = resumeData;
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"已下载");
    
    // 存储到本地
    NSURL * url=[NSURL fileURLWithPath:@"/Users/jiayuanfa/Desktop/music.mp3"];
    NSFileManager * manager=[NSFileManager defaultManager];
    [manager moveItemAtURL:location toURL:url error:nil];
    
    // 播放音乐
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData * data=[manager contentsAtPath:@"/Users/jiayuanfa/Desktop/music.mp3"];
        self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [self.player play];
    });
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    NSLog(@"%@", error);
}

#pragma mark - 监听下载 进度条等等
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    double downloadProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    if (downloadProgress == 0) {
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                // 把暂停下载的时候的数据存储到全局变量中
                NSLog(@"%lu", resumeData.length);
                self.downloadData = resumeData;
            }];

        }
    }
    NSLog(@"%f", downloadProgress);
}

@end
