//
//  WDPersonModel.m
//  RuntimeDemo
//
//  Created by 朱辉 on 2017/8/15.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "WDPersonModel.h"

@implementation WDPersonModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}
- (void)study
{
    NSLog(@"study");
    if (self.pdelegate && [self.pdelegate respondsToSelector:@selector(protocolMethod1)]) {
        [self.pdelegate protocolMethod1];
    }
}


+ (void)study2
{

}

- (void)meth1
{
    NSLog(@"meth1");

}
- (void)meth2
{
    NSLog(@"meth2");

}





@end
