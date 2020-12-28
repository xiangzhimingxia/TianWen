//
//  CXAudioPlayer.h
//  chuxinketing
//
//  流式音频播放 -- ZW

#import <Foundation/Foundation.h>
#import "FSAudioStream.h"

#define kAudioPlayer [CXAudioPlayer sharedInstance]

@class CXAudioPlayer;

@protocol CXAudioPlayerDelegate <NSObject>

@optional

//音频播放完成
- (void)audioPlayerDidPlayMusicCompleted;

//音频播放器播放状态变化
- (void)audioPlayer:(CXAudioPlayer *)player stateChangeWithState:(FSAudioStreamState)state;

@end

@interface CXAudioPlayer : NSObject

/** 代理 */
@property (nonatomic, weak) id<CXAudioPlayerDelegate> delegate;
/** 播放地址 */
@property (nonatomic, copy) NSString *playUrlStr;
/** 播放视图，用于视频播放 */
//@property (nonatomic, strong) UIView *playView;
/** 播放状态 */
@property (nonatomic, readonly) FSAudioStreamState state;
/** 播放进度 */
@property (nonatomic, assign) float progress;
/** AudioStream 播放器 */
@property (nonatomic, strong) FSAudioStream *audioStream;

+ (instancetype)sharedInstance;
/** 播放 */
- (void)play;
/** 暂停 */
- (void)pause;
/** 恢复播放 */
- (void)resume;
/** 停止播放 */
- (void)stop;

@end
