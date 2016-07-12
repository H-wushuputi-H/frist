//
//  ViewController.h
//  sfsd
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <AVFoundation/AVFoundation.h>



@interface ViewController : UIViewController

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;   // 下载任务
@property (nonatomic, strong) NSURLSession *session;    // 网络
@property (nonatomic, strong) NSData *downloadData; // 下载的数据
@property(nonatomic, strong) AVAudioPlayer * player; // 将player写入属性，用模拟器start项目时必须用属性，否则是没有声音的 player是为了下载完成后播放音乐


@end

