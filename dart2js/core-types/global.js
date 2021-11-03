/*
 * Copyright (C) 2005-present, 58.com.  All rights reserved.
 * Use of this source code is governed by a BSD type license that can be
 * found in the LICENSE file.
 */

if (!this.global) {
  this.global = this; // iOS下JSCore没有注入global作为全局变量
}

const __modules__ = {};
function defineModule(modId, func, deps) {
  const imports = {};
  const __global__ = this;
  __modules__[modId] = {
    init: func,
    inited: false,
    deps,
    run: function (mod) {
      if (!this.inited) {
        this.deps.forEach((d) =>
          typeof d == "number"
            ? runModule(d, { exports: imports })
            : runModule(d[0], { exports: imports }, d[1])
        );
        this.inited = true;
      }
      this.init.call(__global__, { imports, exports: mod.exports });
    },
  };
}

function runModule(id, mod, alias) {
  if (alias) {
    mod.exports[alias] = {};
    __modules__[id].run({ exports: mod.exports[alias] });
  } else {
    __modules__[id].run(mod);
  }
}

function runCallback(func, deps) {
  const imports = {};
  const __global__ = this;
  deps.map((d) =>
    typeof d == "number"
      ? runModule(d, { exports: imports })
      : runModule(d[0], { exports: imports }, d[1])
  );
  return func.call(__global__, { imports });
}

function inherit(cls, sup) {
  var oldProto = cls.prototype;
  cls.prototype = Object.create(Object.create(sup.prototype));
  Object.assign(cls.prototype, oldProto);
  cls.prototype.constructor = cls;
  cls.prototype.$superSubstitution = cls.prototype.__proto__;
}

function convertObjectLiteralToSetOrMap(obj) {
  let isSet = Object.prototype.toString.call(obj) == "[object Array]";
  if (!isSet) {
    function convertToMap(obj_) {
      const t = Object.prototype.toString.call(obj_);
      if (t == "[object Array]") {
        return obj_.map((item) => convertToMap(item));
      } else if (t == "[object Object]") {
        let keys = Object.getOwnPropertyNames(obj_);
        let res = new Map();
        keys.forEach((k) => res.set(k, convertToMap(obj_[k])));
        return res;
      } else {
        return obj_;
      }
    }
    return convertToMap(obj);
  } else {
    let res = new Set();
    obj.forEach((item) => res.add(item));
    return res;
  }
}

Object.prototype.ctor = function () {};
Object.__inner__ = function () {};
