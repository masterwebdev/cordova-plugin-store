#import "AVStore.h"

#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

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
    [self.commandDelegate runInBackground:^{
        
        NSString* filename = [command.arguments objectAtIndex:0];
        NSString* data = [command.arguments objectAtIndex:1]; //[NSString stringWithFormat:@"%@%@", @"", [command.arguments objectAtIndex:1]];
        NSString* apnd = [command.arguments objectAtIndex:2];
    
    	//NSLog(@"WRITE DATA %@", data);
        
        NSError *error;
        //NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    
        NSString *filePath = filename;
    
    	//NSLog(@"WRITE PATH %@", filePath);
        
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
    }];

}

- (void)savefile64:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        
        NSString* filename = [command.arguments objectAtIndex:0];
        NSString* data = [command.arguments objectAtIndex:1]; //[NSString stringWithFormat:@"%@%@", @"", [command.arguments objectAtIndex:1]];
        NSString* apnd = [command.arguments objectAtIndex:2];
    
        //NSLog(@"WRITE DATA %@", data);
        
        NSError *error;
        //NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];

        //NSData *nsdata = [NSData dataFromBase64String:data];  
        NSData *nsdata = [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];

        [nsdata writeToFile:filename options:NSDataWritingAtomic error:&error];

        
        /*NSData *plainData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
        NSLog(@"sfxlog WRITE path %@", filePath);
        //NSLog(@"sfxlog WRITE data %@", base64String);
        
        if([apnd isEqualToString:@"true"]){
            //NSLog(@"APPEND TO %@", filename);
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            
            if (fileHandle){

                 NSLog(@"sfxlog WRITE try 1");
                
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:[base64String dataUsingEncoding:NSUTF8StringEncoding]];
                [fileHandle closeFile];

                NSLog(@"sfxlog WRITE try 2");
                
            }
            else{
                NSLog(@"sfxlog WRITE try 3");
                [base64String writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
            }
        }else{
            //NSLog(@"WRITE TO %@", filename);
            //NSLog(@"WRITE DATA %@", data);
           //NSLog(@"sfxlog WRITE success 4");
            //[data writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
            //NSLog(@"sfxlog WRITE success 5");


                NSLog(@"sfxlog WRITE try 4");
                //[data writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];

                [nsdata writeToFile:filePath options:NSDataWritingAtomic error:&error];


        }*/
     
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:filename];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}

- (void)readfile:(CDVInvokedUrlCommand*)command
{
        NSError *error;
    
        /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
           NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath1 = [documentsDirectory stringByAppendingPathComponent:@"NoCloud/map.json"];*/
    
    NSString* filename = [command.arguments objectAtIndex:0];

    NSData * dataFromFile = [[NSData alloc]initWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:&error];
    NSString *base64String;
    base64String = [dataFromFile base64EncodedStringWithOptions:0];

    
    /*NSData * dataFromFile = [NSData dataWithContentsOfFile:filename];
    NSString *base64String;
    base64String = [dataFromFile base64EncodedStringWithOptions:kNilOptions];*/
    
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:base64String];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    //}];
    
}

- (void)readfileplain:(CDVInvokedUrlCommand*)command
{
        NSError *error;
    
        /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
           NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath1 = [documentsDirectory stringByAppendingPathComponent:@"NoCloud/map.json"];*/
    
    NSString* filename = [command.arguments objectAtIndex:0];

    
     NSData * dataFromFile = [NSData dataWithContentsOfFile:filename];
    NSString *base64String;
    base64String = [dataFromFile base64EncodedStringWithOptions:kNilOptions];
    
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:base64String];
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    //}];
    
}

- (void)readfile2:(CDVInvokedUrlCommand*)command
{
    //[self.commandDelegate runInBackground:^{
       // NSString* filename = [command.arguments objectAtIndex:0];
    
    	//NSLog(@"READ FROM %@", filename);
        
        NSError *error;
        
        
    
    
        
        //NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    
    	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
   		NSString *documentsDirectory = [paths objectAtIndex:0];
    	NSString *filePath1 = [documentsDirectory stringByAppendingPathComponent:@"NoCloud/map.json"];
    
    	//NSLog(@"READ FROMXXX %@", filePath1);
    
    	//NSString *filePath1=@"/var/mobile/Containers/Data/Application/ABBF75EB-0520-4FAC-81F2-A7A63141014E/Library/NoCloud/map.json";
        
        NSString *str = [NSString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:&error];
    
    	//NSLog(@"STR %@", str);
        
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

- (void)loadfile:(CDVInvokedUrlCommand*)command
{
    //[self.commandDelegate runInBackground:^{


    NSLog(@"READ FROM %@", @"111");

    NSString* filename = [command.arguments objectAtIndex:0];

    NSLog(@"READ FROM %@", filename);

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

@end

