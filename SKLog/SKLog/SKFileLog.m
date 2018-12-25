//
//  SKFileLog.m
//  SKLog
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 sk. All rights reserved.
//

#import "SKFileLog.h"
#import "SKLog.h"
@interface SKFileLog(){
    dispatch_semaphore_t _semaphore;
    NSDateFormatter * _dateFormatter;
}
@property(strong, nonatomic) NSFileHandle * handle;
@property(assign, nonatomic) BOOL enablePrinter;
    @property(assign, nonatomic) BOOL enableForcePrinter;
@end
@implementation SKFileLog

+ (SKFileLog *)share{
    static dispatch_once_t onceToken;
    static SKFileLog * fileLog;
    dispatch_once(&onceToken, ^{
        fileLog = [[[self class] alloc] init];
    });
    return fileLog;
}
-(void)enablePrinterLog{
    _enablePrinter = YES;
}
-(void)closeEnablePrinterLog{
    _enablePrinter = NO;
}
-(instancetype)init{
    if (self = [super init]) {
        _semaphore = dispatch_semaphore_create(1);
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd-H";
    }
    return self;
}
- (void)log:(LogType)logType tag:(NSString *)tag info:(id)info{
    dispatch_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSString * log = @"debug";
    switch (logType) {
        case LogTypeInfo:
            log = @"info";
            break;
        case LogTypeWarn:
            log = @"warn";
            break;
        case LogTypeDebug:
            
            log = @"debug";
            break;
        case  LogTypeError:
            log = @"error";
            break;
            
        default:
            break;
    }
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@ : %@ => %@\n",log, tag, info);
#else
    if (self.enableForcePrinter) {
        NSLog(@"%@ : %@ => %@\n",log, tag, info);
    }
#endif
   
   
    NSString * content = [NSString stringWithFormat:@"%@ %@ : %@ => %@\n", [NSDate date],log, tag, info];
    NSFileManager * manager = [NSFileManager defaultManager];
    NSDate * date = [NSDate date];
    NSString * path = [@[NSHomeDirectory(), @"Documents",@"SKLog",[_dateFormatter stringFromDate:date]] componentsJoinedByString:@"/"];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        path = [@[path ,@"log.txt"] componentsJoinedByString:@"/"];
        [manager createFileAtPath:path
                         contents:nil attributes:nil];
    }else{
        path = [@[path ,@"log.txt"] componentsJoinedByString:@"/"];
    }
    if (!self.handle) {
         self.handle = [NSFileHandle  fileHandleForUpdatingAtPath:path];
    }
   
    [ self.handle seekToEndOfFile];
    [ self.handle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [ self.handle synchronizeFile];
    dispatch_semaphore_signal(_semaphore);
}
-(void)debug:(NSString *)tag withInfo:(id)info{
    id<SKLog> skLog = self;
    [skLog log: LogTypeDebug tag:tag info:info];
}
- (void)warn:(NSString *)tag withInfo:(id)info{
    [self log:LogTypeWarn tag:tag info:info];
}
- (void)info:(id)info withTag:(NSString *)tag{
    [self log:LogTypeInfo tag:tag info:info];
}


-(void)close{
    if (self.handle) {
        [self.handle closeFile];
    }
}
- (void)dealloc{
    if (self.handle) {
        [self.handle closeFile];
    }
    self.handle = nil;
}
    -(void)forcePrinterLog{
        self.enableForcePrinter = YES;
    }
@end
