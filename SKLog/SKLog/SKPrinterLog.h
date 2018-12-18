//
//  SKPrinterLog.h
//  SKLog
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 sk. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SKLog;
NS_ASSUME_NONNULL_BEGIN

@interface SKPrinterLog : NSObject
+ (SKPrinterLog *) printer;
@end

NS_ASSUME_NONNULL_END
