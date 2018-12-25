//
//  ViewController.m
//  SKLog
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 sk. All rights reserved.
//

#import "ViewController.h"
#import "SKLog.h"
#import "SKPrinterLog.h"
#import "SKFileLog.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    id<SKLog> log = [[SKPrinterLog alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    for (int i=0; i<= 1000000; i++) {
        
        @autoreleasepool {
            dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                NSString * tag = [NSString stringWithFormat:@"%s",__func__];
                [log debug:tag withInfo:@{}];
                [log info:@{} withTag: tag];
                [log warn:tag withInfo:@{}];
                SKFileLog * fileLog = [SKFileLog share];
                [fileLog debug:tag withInfo:@{}];
                [fileLog info:@{} withTag: tag];
                [fileLog warn:tag withInfo:@{}];
            });
            
           
        }
        
    }
}


@end
