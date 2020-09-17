//
//  HZLog.h
//  HZKit
//
//  Created by HertzWang on 2018/8/13.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

/*
 // TODO: 日志的便捷使用，生成文件上传等
 Apple Link: https://developer.apple.com/library/content/samplecode/MVCNetworking/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010443-Intro-DontLinkElementID_2
 */
#import <Foundation/Foundation.h>

extern NSString *const kHZLogFileName;

// User Default                 Property
// ------------                 --------
// kHZLogEnabledKey             enabled
// kHZLogLoggingToFileKey       loggingToFile
// kHZLogLoggingToStdErrKey     loggingToStdErr
// hzlogOption0..31             optionsMask
extern NSString *const kHZLogEnabledKey;
extern NSString *const kHZLogLoggingToFileKey;
extern NSString *const kHZLogLoggingToStdErrKey;
extern NSString *const kHZLogShowViewerKey;

#define HZ_LOG_OPTION @"hzlogOption%d"

@interface HZLog : NSObject
{
    BOOL            _enabled;           // main thread write, any thread read
    int             _logFile;           // main thread write, any thread read
    off_t           _logFileLength;     // main thread only, only valid if _logFile != -1
    BOOL            _loggingToStdErr;   // main thread write, any thread read
    NSUInteger      _optionsMask;       // main thread write, any thread read
    BOOL            _showViewer;        // main thread only
    NSMutableArray *_logEntries;        // main thread only
    NSMutableArray *_pendingEntries;    // any thread, protected by @synchronize (self)
}

#pragma mark - Preferences
@property (assign, readonly, getter=isEnabled) BOOL         enabled;            // any thread, observable, always changed by main thread
@property (assign, readonly, getter=isLoggingToFile) BOOL   loggingToFile;      // any thread, observable, always changed by main thread
@property (assign, readonly, getter=isLoggingToStdErr) BOOL loggingToStdErr;    // any thread, observable, always changed by main thread
@property (assign, readonly) NSUInteger                     optionsMask;        // any thread, observable, always changed by main thread

@property (assign, readonly) BOOL                           showViewer;         // main thread, observable, always changed by main thread

/**
 Any thread, returns the singleton logging object.

 @return singleton logging object
 */
+ (instancetype)log;

/**
 Main thread only, flushes any pending log entries to the logEntries array and also, if appropriate, to the log file or stderr.
 */
- (void)flush;

/**
 Main thread only, empties the logEntries array and, if appropriate, the log file.  Not much we can do about stderr (-:
 */
- (void)clear;


#pragma mark - Log entry generation

// Some things to note:
//
// o The -logOptions:xxx methods only log if the specified bit is set in
//   optionsMask (that is, (optionsMask & (1 << option)) is not zero).
//
// o The format string is as implemented by +[NSString stringWithFormat:].

- (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);                             // any thread
- (void)logWithFormat:(NSString *)format arguments:(va_list)argList;                                // any thread
- (void)logOption:(NSUInteger)option withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);   // any thread
- (void)logOption:(NSUInteger)option withFormat:(NSString *)format arguments:(va_list)argList;      // any thread

// In memory log entries

// New entries are added to the end of this array and, as there's an upper limit
// number of entries that will be held in memory, ald entries are removed from
// the beginning.

@property (retain, readonly) NSMutableArray *               logEntries;         // observable, always changed by main thread

#pragma mark - In file log entries
/**
 Main thread only, returns an un-opened stream.  If lengthPtr is not NULL then, on return *lengthPtr contains the number of bytes in that stream that are guaranteed to be valid.
 This can only be called on the main thread but the resulting stream can be passed to any thread for processing.

 @param lengthPtr contains the number of bytes in that stream
 @return un-opened stream
 */
- (NSInputStream *)streamForLogValidToLength:(off_t *)lengthPtr;

@end
