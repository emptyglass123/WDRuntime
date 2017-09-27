//
//  WDPersonModel.h
//  RuntimeDemo
//
//  Created by 朱辉 on 2017/8/15.
//  Copyright © 2017年 WD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WDBaseModle.h"
@protocol personDelegate <NSObject>

- (void)protocolMethod1;


@end
@interface WDPersonModel :WDBaseModle
{

    NSString *des;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) id<personDelegate> pdelegate ;





- (void)study;

+ (void)study2;


- (void)meth1;
- (void)meth2;


@end
