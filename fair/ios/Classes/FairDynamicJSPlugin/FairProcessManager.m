/*
 * Copyright (C) 2005-present, 58.com.  All rights reserved.
 * Use of this source code is governed by a BSD type license that can be
 * found in the LICENSE file.
 */

/*  Fair整个流程管理类 */

#import "FairProcessManager.h"
#import "FairDartBridge.h"
#import "FairJSBridge.h"

@interface FairProcessManager()<FairDartBridgeExecuteJS>


@end

@implementation FairProcessManager


+ (FairProcessManager *)sharedInstance {
    
    static FairProcessManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FairProcessManager alloc] init];
    });
    return sharedInstance;
}

/// 开始Fair的整个流程
- (void)startFairProcessWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    // 设置和dart的通信
    [[FairDartBridge sharedInstance] setDartChannelWithRegistrar:registrar];
    
    // 设置dart调用js的delegate
    [FairDartBridge sharedInstance].delegate = self;
    
    // 设置native调用js的delegate
    [FairJSBridge sharedInstance].delegate = self;
}

#pragma mark - protocol FairDartBridgeExecuteJS

/// 同步执行JS
- (JSValue *)executeJSFunctionSync:(NSString *)functionName params:(NSArray *)params {
    return [[FairJSBridge sharedInstance] invokeJSFunctionSync:functionName params:params];
}

/// 异步执行JS
- (void)executeJSFunctionAsync:(NSString *)functionName params:(NSArray *)params callback:(FairCallback)callback {
    [[FairJSBridge sharedInstance] invokeJSFunctionAsync:functionName params:params callback:callback];
}

/// Dart 注入到 JS
- (void)injectionJSScriptWtihJSScript:(NSString *)JSScript callback:(FairCallback)callback
{
    FairLog(@"%@", JSScript);
    // 异步注入到JSContext里
    [[FairJSBridge sharedInstance] evaluateScriptWithJSScriptAsync:JSScript callback:callback];
}

/// 释放JS页面
- (void)disposePage:(NSString *)pageName
{
    [[FairJSBridge sharedInstance] disposePage:pageName];
}

#pragma mark - FairJSExportDelegate

/// JS 异步调用 Dart
- (void)FairExecuteDartFunctionAsync:(NSString *)data callback:(JSValue *)callback
{
    [[FairDartBridge sharedInstance] sendMessageToDart:data callback:^(id result, NSError *error) {
        [[FairJSBridge sharedInstance] invokeJSFunction:callback param:result];
    }];
}


/// JS 同步调用 Dart
- (void)FairExecuteDartFunctionSync:(NSString *)data callback:(JSValue *)callback
{
    [[FairDartBridge sharedInstance] sendMessageToDart:data callback:nil];
}

@end
