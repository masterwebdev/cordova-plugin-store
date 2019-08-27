#import "AVStore.h"

#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>


#import "CDVJpegHeaderWriter.h"
#import "UIImage+CropScaleOrientation.h"
#import <ImageIO/CGImageProperties.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageDestination.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <objc/message.h>


#ifndef __CORDOVA_4_0_0
#import <Cordova/NSData+Base64.h>
#endif

@implementation AVStore

- (void)initdirs:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@""];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)truncate:(CDVInvokedUrlCommand*)command
{
    //[self.commandDelegate runInBackground:^{
    
    NSString* filename = [command.arguments objectAtIndex:0];
    NSString* data = [command.arguments objectAtIndex:1];
    int count = [data intValue];
    
    NSError *error;
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
    if (fileHandle){
            
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        
        //NSLog(@"TRUNCATE DATA OLD %luu", [str length]);
            
        if([str length]>count){
                
            NSString *outstr = [str substringWithRange:NSMakeRange([str length] - count, count)];
            
            //NSLog(@"TRUNCATE DATA NEW %luu", [outstr length]);
                
            [outstr writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
                
        }

    }
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:filename];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    //}];
    
}

- (void)savefile:(CDVInvokedUrlCommand*)command
{
    //[self.commandDelegate runInBackground:^{
        
        NSString* filename = [command.arguments objectAtIndex:0];
        NSString* data = [command.arguments objectAtIndex:1]; //[NSString stringWithFormat:@"%@%@", @"", [command.arguments objectAtIndex:1]];
        NSString* apnd = [command.arguments objectAtIndex:2];
    
    //NSLog(@"WRITE DATA %@", data);
        
        NSError *error;
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
        
        if([apnd isEqualToString:@"true"]){
            //NSLog(@"APPEND TO %@", filename);
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            
            if (fileHandle){
                
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
                [fileHandle closeFile];
                
            }
            else{
                [data writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
            }
        }else{
            //NSLog(@"WRITE TO %@", filename);
            //NSLog(@"WRITE DATA %@", data);
            [data writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];

        }
     
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:filename];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    //}];

}

- (void)readfile:(CDVInvokedUrlCommand*)command
{
    //[self.commandDelegate runInBackground:^{
        NSString* filename = [command.arguments objectAtIndex:0];
        
        NSError *error;
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
        
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        
        if(str == nil){
            str=@"";
        }
        
        //NSLog(@"READ FROM %@", str);
        
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:str];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    //}];
    
}

- (void)storefile:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString* path = [command.arguments objectAtIndex:0];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path))
        {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, nil, nil);
        }
        
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:path];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
    
}

- (void)startbeep:(CDVInvokedUrlCommand*)command
{
    [self scheduleLoopInSeconds:11.0];
}

- (void)scheduleLoopInSeconds:(NSTimeInterval)delayInSeconds
{

	[self playbeep];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(popTime, queue, ^{
        [self scheduleLoopInSeconds:delayInSeconds];//set next iteration
    });

}

AVAudioPlayer *audioPlayer;

- (void)playbeep{
	NSLog(@"BEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEP");


    NSString* path1 = [[NSBundle mainBundle]
                      pathForResource:@"t2" ofType:@"wav"];

    NSURL* url = [NSURL fileURLWithPath:path1];


    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url error:NULL];

    audioPlayer.volume        = 1.0;
    audioPlayer.numberOfLoops = 1;

    [audioPlayer play];
}

@end

