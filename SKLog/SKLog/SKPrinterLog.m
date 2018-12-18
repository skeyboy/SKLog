//
//  SKPrinterLog.m
//  SKLog
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 sk. All rights reserved.
//

#import "SKPrinterLog.h"
#import "SKLog.h"
@interface SKPrinterLog()<SKLog>
@end
@implementation SKPrinterLog
+ (SKPrinterLog *)printer{
    static dispatch_once_t onceToken;
   static SKPrinterLog * printerLog;
    dispatch_once(&onceToken, ^{
        printerLog = [[[self class] alloc] init];
    });
    return printerLog;
}
- (void)log:(LogType) logType
        tag:(NSString *) tag
       info:(id) info{
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
    NSLog(@"%@ : %@ => %@\n",log, tag, info);
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

@end
