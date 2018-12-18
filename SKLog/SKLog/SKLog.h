//
//  SKLog.h
//  SKLog
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 sk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LogType) {
    LogTypeInfo,
    LogTypeDebug,
    LogTypeWarn,
    LogTypeError
};

NS_ASSUME_NONNULL_BEGIN

@protocol SKLog <NSObject>
@optional
- (void)log:(LogType) logType tag:(NSString *) tag info:(id) info;
- (void)debug:(NSString *) tag withInfo:( id )  info;
- (void)warn:(NSString *) tag withInfo:(id) info;
- (void)info:(id) info withTag:(NSString *) tag;
@end

NS_ASSUME_NONNULL_END
