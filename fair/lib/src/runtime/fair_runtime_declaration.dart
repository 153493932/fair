/*
 * Copyright (C) 2005-present, 58.com.  All rights reserved.
 * Use of this source code is governed by a BSD type license that can be
 * found in the LICENSE file.
 */

/// js-native 数据格式
class FairMessage {
  static final String METHOD = 'method';
  static final String VARIABLE = 'variable';
  static final String ALL_BIND_DATA = 'getAllBindData';
  static final String EVALUATE = 'evaluate';
  static final String FUNC_NAME = 'funcName';
  static final String ARGS = 'args';
  static final String LOAD_JS = 'loadJsFile';
  static final String RELEASE_JS = 'releaseJS';
  static final String PATH = 'path';
  static final String PAGE_NAME = 'pageName';

  FairMessage(this.pageName, this.type, this.args);

  /// 页面名称
  String pageName;

  ///type调用类型 variable,method等
  String type;

  //存放不同类型的数据
  dynamic args;

  Map from() {
    return {'pageName': pageName, 'type': type, 'args': args};
  }
}

abstract class IRuntime {
  /// 初始化
  void init(bool isDebug);

  /// 释放资源
  void release(String pageName);

  /// 获取JS侧版本号
  Future<String> version();

  /// 添加脚本文件
  Future<dynamic> addScript(String pageName,String script, dynamic props);

  /// 异步方法调用
  /// pageName 页面名称
  /// funcName js侧方法名称
  /// parameters 方法参数
  Future<String> invokeMethod(
      String pageName, String funcName, List<dynamic> parameters);

  /// 同步方法调用
  /// pageName 页面名称
  /// funcName js侧方法名称
  /// parameters 方法参数
  String invokeMethodSync(
      String pageName, String funcName, List<dynamic> parameters);

  /// 异步读取变量，key可以指定读取的内容，如果不指定返回所有变量；返回值为空间域变量Json
  /// eg:
  /// {
  ///    "pageName": "helloWorld",
  ///    "type": "variable",
  ///    "args": {
  ///        "num": 10,
  ///        "string": "12580",
  ///        "object": {
  ///            "array": ["1", "2", "3"],
  ///            "num": 123
  ///        }
  ///    }
  ///}
  Future<String> variables(
      String pageName, Map<dynamic, dynamic> variableNames);

  /// 同步读取变量，返回值为空间域变量Json
  String variablesSync(String pageName, Map<dynamic, dynamic> variableNames);

  /// 执行指定脚本语句；script为脚本语句
  Future<dynamic> executeScript(String pageName, String script);

  /// 同步执行脚本语句
  Map<String, dynamic> executeScriptSync(String pageName, String script);

  ///获取指定页面的所有变量和方法
  dynamic getBindVariableAndFuncSync(String pageName);

  void bindCallback(String key, RuntimeCallback callback);
  Future<Map> getBindVariableAndFunc(String pageName);
}

typedef RuntimeCallback = void Function(dynamic);
