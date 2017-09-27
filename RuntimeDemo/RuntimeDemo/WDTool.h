//
//  WDTool.h
//  RuntimeDemo
//
//  Created by 朱辉 on 2017/8/15.
//  Copyright © 2017年 WD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDTool : NSObject

+ (instancetype)sharedManager;


- (void)toolMeth1;
- (void)addCount;

@end
