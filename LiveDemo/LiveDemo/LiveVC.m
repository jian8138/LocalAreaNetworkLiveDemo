//
//  LiveVC.m
//  LiveDemo
//
//  Created by Jian on 2017/1/6.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "LiveVC.h"
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "LFLiveKit.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kRGBA(r, g, b, A)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:A/1.0]

@interface LiveVC ()<LFLiveSessionDelegate>

@property (nonatomic) UIButton* beautyBtn;

@property (nonatomic) UIButton* cameraBtn;

@property (nonatomic) UIButton* closeBtn;

@property (nonatomic) UILabel* stateLb;

@property (nonatomic) UIButton* startLiveBtn;

@property (nonatomic) UIView* livingView;

#pragma mark - Important
//关键 第三方 LFLiveKit.h session
@property (nonatomic) LFLiveSession* session;
//记录IP地址
@property (nonatomic) NSString* rtmpUrl;

@end

@implementation LiveVC

#pragma mark - Lazy

-(UIView *)livingView
{
    if (!_livingView)
    {
        _livingView = [[UIView alloc] init];
        _livingView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_livingView];
        [_livingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _livingView;
}

-(UIButton *)beautyBtn
{
    if (!_beautyBtn)
    {
        _beautyBtn = [[UIButton alloc] init];
        [_beautyBtn setBackgroundColor:kRGBA(1, 1, 1, .25)];
        [_beautyBtn setTitle:@"智能美颜已经开启" forState:UIControlStateNormal];
        [_beautyBtn setTitle:@"智能美颜已经关闭" forState:UIControlStateSelected];
        [_beautyBtn addTarget:self action:@selector(beautyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _beautyBtn.layer.cornerRadius = 15;
        _beautyBtn.clipsToBounds = YES;
        [self.view addSubview:_beautyBtn];
        [_beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30);
            make.top.equalTo(30);
            make.height.equalTo(30);
            make.width.equalTo(180);
        }];
    }
    return _beautyBtn;
}

-(UIButton *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"search_close_40x40_"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.beautyBtn.mas_centerY);
            make.size.equalTo(40);
            make.right.equalTo(-20);
        }];
    }
    return _closeBtn;
}

-(UIButton *)cameraBtn
{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"camera_change_40x40"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cameraBtn];
        [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.closeBtn.mas_centerY);
            make.size.equalTo(40);
            make.right.equalTo(self.closeBtn.mas_left).offset(-20);
        }];
    }
    return _cameraBtn;
}

-(UILabel *)stateLb
{
    if (!_stateLb)
    {
        _stateLb = [[UILabel alloc] init];
        _stateLb.textColor = [UIColor whiteColor];
        _stateLb.text = @"状态:未知";
        _stateLb.backgroundColor = kRGBA(1, 1, 1, .25);
        _stateLb.numberOfLines = 0;
        [self.view addSubview:_stateLb];
        [_stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.beautyBtn.mas_bottom).offset(30);
            make.width.lessThanOrEqualTo(kScreenW * .7);
        }];
    }
    return _stateLb;
}

-(UIButton *)startLiveBtn
{
    if(!_startLiveBtn)
    {
        _startLiveBtn = [[UIButton alloc] init];
        [_startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startLiveBtn setTitle:@"关闭直播" forState:UIControlStateSelected];
        _startLiveBtn.layer.cornerRadius = 45/2.0;
        _startLiveBtn.layer.masksToBounds = YES;
        [_startLiveBtn addTarget:self action:@selector(startLiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_startLiveBtn setBackgroundColor:kRGBA(216, 41, 116, 1)];
        [self.view addSubview:_startLiveBtn];
        [_startLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kScreenW * .8);
            make.height.equalTo(45);
            make.centerX.equalTo(0);
            make.bottom.equalTo(-60);
        }];
    }
    return _startLiveBtn;
}

#pragma mark - Important
//关键 第三方 LFLiveKit.h session
-(LFLiveSession *)session
{
    if (!_session)
    {
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        // 第一步：实例化 _session ，类似于 原生的 管道流
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        // 设置视频显示的view
        _session.preView = self.livingView;
        // 设置代理
        _session.delegate = self;
        // 默认开启后置摄像头
        _session.captureDevicePosition = AVCaptureDevicePositionBack;
        // 默认开启
        _session.running = YES;
    }
    return _session;
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self livingView];
    [self beautyBtn];
    [self closeBtn];
    [self cameraBtn];
    [self stateLb];
    [self startLiveBtn];
    [self session];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"liveRoom dealloc");
}
// 开启直播
-(void)startLiveBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    // 第二步：开始直播
    if (sender.selected) {
        // 直播流
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        // 电脑端VLC填写地址：rtmp://localhost:1935/rtmplive/room
        // 电脑端先开启 nginx, 终端输入 nginx，集成iOS基于RTMP的视频推流看网址：http://www.jianshu.com/p/8ea016b2720e
        // 下方填写电脑的IP地址, 1935为端口号
        stream.url = @"rtmp://169.254.59.89:1935/rtmplive/room";
        self.rtmpUrl = stream.url;
        [self.session startLive:stream];
        NSLog(@"开始直播");
    }else{ // 结束直播
        [self.session stopLive];
        self.stateLb.text = [NSString stringWithFormat:@"状态: 直播被关闭\nRTMP: %@", self.rtmpUrl];
        NSLog(@"结束直播");
    }
}

// 右上角关闭按钮
-(void)closeBtnClick:(UIButton*)sender
{
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 切换摄像头
-(void)cameraBtnClick:(UIButton*)sender
{
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    NSLog(@"切换前置/后置摄像头");
}
//美颜效果
-(void)beautyBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    // 默认是开启了美颜功能的
    self.session.beautyFace = !self.session.beautyFace;
}
#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
// 第三步：代理方法回调，查看状态
// 直播流代理方法
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    self.stateLb.text = [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.rtmpUrl];
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
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
