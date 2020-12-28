//
//  LVRecordTool.h
//  RecordAndPlayVoice
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class LVRecordTool;
@protocol LVRecordToolDelegate <NSObject>

@optional
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no;
- (void)recordToolDidFinishPlay:(LVRecordTool *)recordTool;

-(void)getBackFinishFileURL:(NSURL *)fileUrl AndRecordTimeStr:(NSString *)timeStr;

@end

@interface LVRecordTool : NSObject

/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;

//录音文件地址
@property (nonatomic, copy) NSString *recordFileStr; //用lame库框架转为mp3音频时必须用这个

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;


/** 更新图片的代理 */
@property (nonatomic, assign) id<LVRecordToolDelegate> delegate;


@end
