//
//  HZLog.m
//  HZKit
//
//  Created by HertzWang on 2018/8/13.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZLog.h"

#include <stdarg.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <xlocale.h>
#include <time.h>
#include <sys/time.h>
#include <mach/mach.h>
#include <libkern/OSAtomic.h>

// Enable HZLOG_ADD_SEQUENCE_NUMBERS to add sequences numbers to the front of each
// log entry.  This is a useful tool for debugging various problems.  For example,
// sequence numbers make it easy to see if the log viewer is messing up its table
// view updates.

#if ! defined(HZLOG_ADD_SEQUENCE_NUMBERS)
#define HZLOG_ADD_SEQUENCE_NUMBERS 0
#endif

NSString *const kHZLogFileName = @"HZLog.log";
NSString *const kHZLogEnabledKey = @"hzlogEnabled";
NSString *const kHZLogLoggingToFileKey = @"hzlogLoggingToFile";
NSString *const kHZLogLoggingToStdErrKey = @"hzlogLoggingToStdErr";
NSString *const kHZLogShowViewerKey = @"hzlogShowViewer";

@interface HZLog ()

// private properties
@property (copy, readonly) NSString * pathToLogFile;

// forward declarations
- (void)setupFromPreferences;

@end


@implementation HZLog

@synthesize enabled         = _enabled;
@synthesize loggingToStdErr = _loggingToStdErr;
@synthesize optionsMask     = _optionsMask;
@synthesize showViewer      = _showViewer;
@synthesize logEntries      = _logEntries;

+ (instancetype)log
{
    static HZLog *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZLog alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_logEntries = [[NSMutableArray alloc] init];
        self->_pendingEntries = [[NSMutableArray alloc] init];
        
        self->_enabled = NO;
        self->_logFile = -1;
        self->_logFileLength = -1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
        [self setupFromPreferences];
    }
    return self;
}

/**
 Returns the path to the log file.
 Because iOS doesn't support a Logs directory, we put the log file into the Caches directory.  That's a reasonable place for it. We don't want the OS deleting it willynilly (like it might for the temporary directory), but neither do we want it being backed up.

 @return path to the log file
 */
- (NSString *)pathToLogFile
{
    NSString *logDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    assert(logDirPath != nil);
    
    return [logDirPath stringByAppendingPathComponent:kHZLogFileName];
}

/**
 Sets up the object based on the current user defaults.
 */
- (void)setupFromPreferences
{
    NSUserDefaults *    userDefaults;
    BOOL                shouldBeEnabled;
    BOOL                shouldLogToFile;
    int                 junk;
    struct stat         sb;
    NSUInteger          newOptionsMask;
    
    // This is always called either on the main thread or before initialisation is
    // complete and, as such, does not need to be synchronised.
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Master enabled property
    
    shouldBeEnabled = [userDefaults boolForKey:kHZLogEnabledKey];
    if (shouldBeEnabled != self->_enabled) {
        [self willChangeValueForKey:@"enabled"];
        self->_enabled = shouldBeEnabled;
        [self didChangeValueForKey:@"enabled"];
    }
    
    // loggingToFile property
    
    shouldLogToFile  = [userDefaults boolForKey:kHZLogLoggingToFileKey];
    if ( ! self->_enabled ) {
        shouldLogToFile = NO;
    }
    if ( shouldLogToFile != (self->_logFile != -1) ) {
        off_t       newLength;
        
        // shouldLogToFile is different from the current logging to file setup,
        // so we have to change things.
        
        [self willChangeValueForKey:@"loggingToFile"];
        newLength = self->_logFileLength;
        if (shouldLogToFile) {
            
            // We should be logging to a file but are not.  Open the log file and
            // get its length from newLength.  Note that the only other code that looks
            // at _logFile is also running on the main thread, so we don't have to worry
            // about synchronisation here.
            
            assert(self->_logFile == -1);
            self->_logFile = open([self.pathToLogFile fileSystemRepresentation], O_RDWR | O_CREAT | O_APPEND, DEFFILEMODE);
            assert(self->_logFile != -1);
            
            if (self->_logFile != -1) {
                junk = fstat(self->_logFile, &sb);
                assert(junk == 0);
                
                newLength = sb.st_size;
                assert(newLength >= 0);
            }
        } else {
            
            // We are logging to a file and shouldn't be.  Close down the log file.
            
            assert(self->_logFile != -1);
            junk = close(self->_logFile);
            assert(junk == -1);
            self->_logFile = -1;
            
            newLength = -1;
        }
        
        // Update the newLength property.
        
        if (newLength != self->_logFileLength) {
            [self willChangeValueForKey:@"logFileLength"];
            self->_logFileLength = newLength;
            [self didChangeValueForKey:@"logFileLength"];
        }
        
        // Finally, trigger KVO observers.
        
        [self didChangeValueForKey:@"loggingToFile"];
    }
    
    // loggingToStdErr property
    
    shouldBeEnabled = [userDefaults boolForKey:kHZLogLoggingToStdErrKey];
    if ( ! self->_enabled ) {
        shouldBeEnabled = NO;
    }
    if (shouldBeEnabled != self->_loggingToStdErr) {
        [self willChangeValueForKey:@"loggingToStdErr"];
        self->_loggingToStdErr = shouldBeEnabled;
        [self didChangeValueForKey:@"loggingToStdErr"];
    }
    
    // optionsMask property
    
    newOptionsMask = 0;
    for (int i = 0; i < 32; i++) {
        newOptionsMask |= [userDefaults boolForKey:[NSString stringWithFormat:HZ_LOG_OPTION, i]] << i;
    }
    if (newOptionsMask != self->_optionsMask) {
        [self willChangeValueForKey:@"optionsMask"];
        self->_optionsMask = newOptionsMask;
        [self didChangeValueForKey:@"optionsMask"];
    }
    
    // showViewer property
    
    shouldBeEnabled = [userDefaults boolForKey:kHZLogShowViewerKey];
    if (shouldBeEnabled != self->_showViewer) {
        [self willChangeValueForKey:@"showViewer"];
        self->_showViewer = shouldBeEnabled;
        [self didChangeValueForKey:@"showViewer"];
    }
}

- (BOOL)isLoggingToFile
// See comment in header.
//
// Note that this is for public consumption only.  Internally we just look at
// _logFile.
{
    return (self->_logFile != -1);
}

#pragma mark - Log entry generation

- (void)logWithFormat:(NSString *)format arguments:(va_list)argList
// See comment in header.
{
    NSString *  formattedArgs;
    NSString *  newEntry;
    
    // Can be called on any thread.
    
    if (self->_enabled) {
        BOOL            success;
        struct timeval  now;
        struct tm       localNow;
        char            sequenceNumberStr[32];
        char            dateTimeStr[32];
        
        // Create the log entry.  Note that the log entry header is formatted to look like the
        // result of NSLog.
        
        formattedArgs = [[NSString alloc] initWithFormat:format arguments:argList];
        assert(formattedArgs != nil);
        
        success = gettimeofday(&now, NULL) == 0;
        if (success) {
            success = localtime_r(&now.tv_sec, &localNow) != NULL;
        }
        if (success) {
            success = strftime_l(dateTimeStr, sizeof(dateTimeStr), "%Y-%m-%d %H:%M:%S", &localNow, NULL) != 0;
        }
        if ( ! success ) {
            strlcpy(dateTimeStr, "?", sizeof(dateTimeStr));
        }
        
#if HZLOG_ADD_SEQUENCE_NUMBERS
        static uint64_t sLastSequenceNumber;
        snprintf(sequenceNumberStr, sizeof(sequenceNumberStr), "%llu ", (unsigned long long) OSAtomicAdd64(1, (int64_t *) &sLastSequenceNumber));
#else
        sequenceNumberStr[0] = 0;
#endif
        
        newEntry = [NSString stringWithFormat:@"%s%s.%03d %s[%d:%x] %@", sequenceNumberStr, dateTimeStr, (int) (now.tv_usec / 1000), getprogname(), (int) getpid(), (unsigned int) mach_thread_self(), formattedArgs];
        assert(newEntry != nil);
        
        // Add the log entry to the list of new entries and, if this is the first
        // element in the list, tell the main thread about it.
        
        @synchronized (self) {
            [self->_pendingEntries addObject:newEntry];
            if ([self->_pendingEntries count] == 1) {
                [self performSelectorOnMainThread:@selector(flush) withObject:nil waitUntilDone:NO];
            }
        }
        
        if (self.isLoggingToStdErr) {
            fprintf(stderr, "%s\n", [newEntry UTF8String]);
        }
    }
}

- (void)logWithFormat:(NSString *)format, ...
// See comment in header.
{
    va_list     argList;
    
    // Can be called on any thread.
    
    if (self->_enabled) {
        va_start(argList, format);
        [self logWithFormat:format arguments:argList];
        va_end(argList);
    }
}

- (void)logOption:(NSUInteger)option withFormat:(NSString *)format arguments:(va_list)argList
// See comment in header.
{
    if ( self->_enabled && (self->_optionsMask & (1 << option)) ) {
        [self logWithFormat:format arguments:argList];
    }
}

- (void)logOption:(NSUInteger)option withFormat:(NSString *)format, ...
// See comment in header.
{
    va_list     argList;
    
    if ( self->_enabled && (self->_optionsMask & (1 << option)) ) {
        va_start(argList, format);
        [self logWithFormat:format arguments:argList];
        va_end(argList);
    }
}

- (NSData *)dataForLogEntries:(NSArray *)entries
// Flattens the supplied array of log entries to a data object containing
// LF terminated UTF-8 strings.
{
    NSMutableData *     result;
    
    result = [NSMutableData dataWithCapacity:[entries count] * 80];
    assert(result != nil);
    
    for (NSString * entry in entries) {
        NSData *        entryData;
        
        assert([entry isKindOfClass:[NSString class]]);
        
        entryData = [entry dataUsingEncoding:NSUTF8StringEncoding];
        assert(entryData != nil);
        
        [result appendData:entryData];
        [result appendBytes:"\n" length:1];
    }
    return result;
}

- (void)flush
// See comment in header.
{
    NSArray *       entriesToAdd;
    NSIndexSet *    indexSet;
    int             junk;
    struct stat     sb;
    
    assert([NSThread isMainThread]);
    
    // Steal the entries from the _pendingEntries array.
    
    @synchronized (self) {
        entriesToAdd = [self->_pendingEntries copy];
        [self->_pendingEntries removeAllObjects];
    }
    
    // We might have no pending log entries (because of someone calling us directly,
    // rather than the logging code calling us via -performSelectorOnMainThread:xxx),
    // so we only do the rest of this code if we actually got some log entries.
    
    if ([entriesToAdd count] != 0) {
        
        // Add the entries to the in-memory log.
        
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self->_logEntries count], [entriesToAdd count])];
        assert(indexSet != nil);
        
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"logEntries"];
        [self->_logEntries addObjectsFromArray:entriesToAdd];
        [self  didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"logEntries"];
        
        // If we've hit the limit of the in-memory log, prune it now.  We do this after adding
        // the new entries so that if there are more than 100 new entries we still clip correctly.
        
        if ([self->_logEntries count] > 100) {
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self->_logEntries count] - 100)];
            assert(indexSet != nil);
            
            [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"logEntries"];
            [self->_logEntries removeObjectsAtIndexes:indexSet];
            [self  didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"logEntries"];
        }
        
        // If we're logging to a file, add the entries to the on-disk log.
        
        if (self->_logFile != -1) {
            int                 err;
            NSData *            dataToWrite;
            NSUInteger          bytesToWrite;
            NSUInteger          bytesWrittenSoFar;
            const char *        buf;
            
            err = 0;
            
            // Flatten the array of strings into a single blob of UTF-8 data.
            
            dataToWrite = [self dataForLogEntries:entriesToAdd];
            assert(dataToWrite != nil);
            
            // Write that data to the file.
            
            bytesToWrite = [dataToWrite length];
            bytesWrittenSoFar = 0;
            buf = [dataToWrite bytes];
            do {
                ssize_t     bytesWritten;
                
                if (bytesWrittenSoFar == bytesToWrite) {
                    break;
                }
                bytesWritten = write(self->_logFile, &buf[bytesWrittenSoFar], bytesToWrite - bytesWrittenSoFar);
                if (bytesWritten > 0) {
                    bytesWrittenSoFar += bytesWritten;
                } else {
                    assert(bytesWritten != 0);
                    err = errno;
                    
                    if (err == EINTR) {
                        err = 0;
                    } else {
                        break;
                    }
                }
            } while (YES);
            
            // I have no idea what to do with an error at this point.  Right now, I'm just
            // going to ignore it in production code.
            
            assert(err == 0);
            
            // Once we've written out the entire buffer, update the log file length.
            // We do this at the end to ensure that the client sees only complete
            // log records.  Also, we get the length from the file rather than keeping
            // track of it ourself so that things can't possibly get too far out of
            // sync.
            
            junk = fstat(self->_logFile, &sb);
            assert(junk == 0);
            
            self->_logFileLength = sb.st_size;
            assert(self->_logFileLength >= 0);
        }
    }
}

- (void)clear
// See comment in header.
{
    assert([NSThread isMainThread]);
    
    // First truncate the log file (if any).
    
    if (self->_logFile != -1) {
        int     junk;
        
        junk = ftruncate(self->_logFile, 0);
        assert(junk == 0);
        
        self->_logFileLength = 0;
    }
    
    // Next nix any in-memory log entries.
    
    if ([self->_logEntries count] != 0) {
        NSIndexSet *    indexSet;
        
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self->_logEntries count])];
        assert(indexSet != 0);
        
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"logEntries"];
        [self->_logEntries removeAllObjects];
        [self  didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"logEntries"];
    }
}

- (NSInputStream *)streamForLogValidToLength:(off_t *)lengthPtr
// See comment in header.
{
    NSInputStream * result;
    NSString *      path;
    
    // It's important that this be called on the main thread so that it's coordinated
    // with the the preferences re-read code that might be closing or opening the log
    // file.
    
    assert([NSThread isMainThread]);
    
    // Flush the log to ensure that any in-memory entries are pushed to disk before
    // we get the log file length.
    
    [self flush];
    
    if (self->_logFile == -1) {
        NSData *    logData;
        
        // There is no log file.  Just return a memory-based stream containing our
        // in-memory log entries.
        
        logData = [self dataForLogEntries:self.logEntries];
        assert(logData != nil);
        
        result = [NSInputStream inputStreamWithData:logData];
        if (result != nil) {
            if (lengthPtr != NULL) {
                *lengthPtr = [logData length];
            }
        }
    } else {
        // There is a log file, so return a file stream for that.
        
        path = self.pathToLogFile;
        assert(path != nil);
        
        result = [NSInputStream inputStreamWithFileAtPath:path];
        
        if (result != nil) {
            if (lengthPtr != NULL) {
                assert(self->_logFileLength >= 0);
                *lengthPtr = self->_logFileLength;
            }
        }
    }
    
    return result;
}

#pragma mark - Notification

/**
 This simply calls -setupFromPreferences to re-read our preferences.

 @param note NSUserDefaultsDidChangeNotification notification
 */
- (void)preferencesChanged:(NSNotification *)note
{
    #pragma unused(note)
    assert([NSThread isMainThread]);
    [self setupFromPreferences];
}

@end
