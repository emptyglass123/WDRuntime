//
//  WDTool.m
//  RuntimeDemo
//
//  Created by 朱辉 on 2017/8/15.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "WDTool.h"

@interface WDTool ()

@property (nonatomic, assign) NSInteger count;


@end
@implementation WDTool


- (void)toolMeth1
{
    NSLog(@"toolMeth1");

}

+ (instancetype)sharedManager {
    static WDTool *_sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sInstance = [[WDTool alloc] init];
    });
    
    return _sInstance;
}


- (void)addCount
{
    _count += 1;
    
    NSLog(@"点击次数------%ld", _count);
}



@end
