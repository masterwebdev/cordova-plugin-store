#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AVStore : CDVPlugin

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (void) initdirs:(CDVInvokedUrlCommand*)command;
- (void) savefile:(CDVInvokedUrlCommand*)command;
- (void) readfile:(CDVInvokedUrlCommand*)command;
- (void) storefile:(CDVInvokedUrlCommand*)command;
- (void) loadfile:(CDVInvokedUrlCommand*)command;



@end
