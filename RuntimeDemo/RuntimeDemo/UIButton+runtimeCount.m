//
//  UIButton+runtimeCount.m
//  RuntimeDemo
//
//  Created by 朱辉 on 2017/8/16.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "UIButton+runtimeCount.h"
#import <objc/runtime.h>
#import "WDTool.h"
@implementation UIButton (runtimeCount)
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        
        SEL oriSEL = @selector(sendAction:to:forEvent:);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        SEL cusSEL = @selector(mySendAction:to:forEvent:);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
        if (addSucc) {
            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            method_exchangeImplementations(oriMethod, cusMethod);
        }
        
    });
}

// 方法交换
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {

    [[WDTool sharedManager] addCount];
    [self mySendAction:action to:target forEvent:event];
}


@end
