//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 朱辉 on 2017/8/15.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "WDPersonModel.h"
#import "WDTool.h"

@interface ViewController ()<personDelegate>
@property (nonatomic, strong) WDPersonModel *ppp ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ppp = [[WDPersonModel alloc] init];



    WDPersonModel *pm = [[WDPersonModel alloc] init];
    pm.pdelegate = self;
    [pm study];
    
    [self test1];// 获取WDPersonModel类属性列表
    [self test2];// 获取WDPersonModel类的方法列表
    [self test3];// 获取// 获取类方法成员变量
    [self test4];// 获取协议列表
    [self test5];// 获取// 获取类方法类方法
    [self test6];// 获取WDPersonModel类实例方法
    [self test7];// 添加方法
    [self test8];// 动态交换两个方法的实现
    [self test9];// 拦截并替换方法
    [self test10];// 进行模型-->字典的转换'
    [self test10];// 进行模型-->字典的转换
    
    // 1.0 soursetree  添加备注
    // 2.0 soursetree  添加备注
    // 3.0 soursetree  添加备注
    // 4.0 soursetree  添加备注


}

// 获取WDPersonModel类属性列表
- (void)test1
{
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([WDPersonModel class], &count);
    for (unsigned int i = 0; i< count; i ++) {
        
        const char *pName = property_getName(propertys[i]);
        NSLog(@"pName== %@",[NSString stringWithUTF8String:pName]);
        
    }
    free(propertys);
}

// 获取WDPersonModel类的方法列表
- (void)test2
{

    unsigned int count = 0;
    Method *methods = class_copyMethodList([WDPersonModel class], &count);
    for (unsigned int i = 0 ; i < count ; i ++) {
        
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSLog(@"方法名:%@",NSStringFromSelector(sel));
    }
    
    free(methods);
}

// 获取成员变量
- (void)test3
{
    unsigned int count = 0;
    Ivar  *ivars = class_copyIvarList([WDPersonModel class], &count);
    
    for (unsigned int i = 0; i < count ; i ++) {
        
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSLog(@"成员变量:%s",name);
    }
    free(ivars);
}

// 获取协议列表  获取的是当前遵守的协议,不是协议方法
- (void)test4
{
    unsigned int count = 0;

    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"协议列表---->%@", [NSString stringWithUTF8String:protocolName]);
    }

    free(protocolList);
}


// 获取类方法
- (void)test5
{
    Class personClass = object_getClass([WDPersonModel class]);
    SEL sel = @selector(study2);
    Method method = class_getInstanceMethod(personClass, sel);
    Method meth = class_getClassMethod([personClass class], sel);

}


// 获取示例方法
- (void)test6
{
    WDPersonModel *pp = [[WDPersonModel alloc] init];
    
    SEL sel = @selector(study);
    Method meth = class_getInstanceMethod([pp class], sel);
    
    SEL selr = method_getName(meth);
    NSLog(@"方法名:%@",NSStringFromSelector(selr));

}


// 添加方法
- (void)test7
{
    
    BOOL addSucc = class_addMethod([self.ppp class], @selector(addRuntimeMethod)  , (IMP)guessRuntimeMethod, "v@:");

    if (addSucc) {
        
        NSLog(@"动态添加方法成功");
        if ([self.ppp respondsToSelector:@selector(addRuntimeMethod)]) {
            
            [self.ppp performSelector:@selector(addRuntimeMethod)];

        }
    
    }
    
}

void guessRuntimeMethod(id self,SEL _cmd){
    
    WDPersonModel *mode = (WDPersonModel *)self;
    
    NSLog(@"运行时添加方法的实现 WDPersonModel.name= %@",mode.name);
    
}

- (void) addRuntimeMethod
{

}



// 动态交换两个方法的实现
- (void)test8
{
    Method m1 = class_getInstanceMethod([self.ppp class], @selector(meth1));
    Method m2 = class_getInstanceMethod([self.ppp class], @selector(meth2));
    method_exchangeImplementations(m1, m2);

    [self.ppp meth1];
    [self.ppp meth2];


}


// 拦截并替换方法
- (void)test9
{
    WDTool *tool = [[WDTool alloc] init];
    
    Class PersionClass = object_getClass(self.ppp);
    Class toolClass = object_getClass(tool);

    ////源方法的SEL和Method
    
    SEL oriSEL = @selector(study);
    Method oriMethod = class_getInstanceMethod(PersionClass, oriSEL);
    
    ////交换方法的SEL和Method
    
    SEL cusSEL = @selector(toolMeth1);
    Method cusMethod = class_getInstanceMethod(toolClass, cusSEL);
    
    ////先尝试給源方法添加实现，这里是为了避免源方法没有实现的情况
    
    BOOL addSucc = class_addMethod(PersionClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        // 添加成功：将源方法的实现替换到交换方法的实现
        class_replaceMethod(toolClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        
    }else {
        //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    

    
    [self.ppp study];

 

}
    

// 进行模型-->字典的转换
- (void)test10
{
    self.ppp.name = @"bejing";
    self.ppp.sex = @"男";
    self.ppp.age = 100;
    
    NSDictionary *dic = [self.ppp dictionaryFromModel];
    NSLog(@"self.ppp --> dictionaryFromModel%@",dic);
}

// 在原有方法上进行扩展(特别是针对系统和第三方方法)
- (void)test11
{
    // 在UIButton的类别中,利用runtime拦截UIButton的点击事件,并注入自定义的代码
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];


}

- (void)ButtonClick
{
    NSLog(@"按钮被点击了");
}
- (void) protocolMethod1
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
