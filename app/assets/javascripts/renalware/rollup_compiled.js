function createCommonjsModule(fn, basedir, module) {
  return module = {
    path: basedir,
    exports: {},
    require: function(path, base) {
      return commonjsRequire(path, base === undefined || base === null ? module.path : base);
    }
  }, fn(module, module.exports), module.exports;
}

function commonjsRequire() {
  throw new Error("Dynamic requires are not currently supported by @rollup/plugin-commonjs");
}

var _global = createCommonjsModule(function(module) {
  var global = module.exports = typeof window != "undefined" && window.Math == Math ? window : typeof self != "undefined" && self.Math == Math ? self : Function("return this")();
  if (typeof __g == "number") __g = global;
});

var _core = createCommonjsModule(function(module) {
  var core = module.exports = {
    version: "2.6.11"
  };
  if (typeof __e == "number") __e = core;
});

var _isObject = function(it) {
  return typeof it === "object" ? it !== null : typeof it === "function";
};

var _anObject = function(it) {
  if (!_isObject(it)) throw TypeError(it + " is not an object!");
  return it;
};

var _fails = function(exec) {
  try {
    return !!exec();
  } catch (e) {
    return true;
  }
};

var _descriptors = !_fails(function() {
  return Object.defineProperty({}, "a", {
    get: function() {
      return 7;
    }
  }).a != 7;
});

var document$1 = _global.document;

var is = _isObject(document$1) && _isObject(document$1.createElement);

var _domCreate = function(it) {
  return is ? document$1.createElement(it) : {};
};

var _ie8DomDefine = !_descriptors && !_fails(function() {
  return Object.defineProperty(_domCreate("div"), "a", {
    get: function() {
      return 7;
    }
  }).a != 7;
});

var _toPrimitive = function(it, S) {
  if (!_isObject(it)) return it;
  var fn, val;
  if (S && typeof (fn = it.toString) == "function" && !_isObject(val = fn.call(it))) return val;
  if (typeof (fn = it.valueOf) == "function" && !_isObject(val = fn.call(it))) return val;
  if (!S && typeof (fn = it.toString) == "function" && !_isObject(val = fn.call(it))) return val;
  throw TypeError("Can't convert object to primitive value");
};

var dP = Object.defineProperty;

var f = _descriptors ? Object.defineProperty : function defineProperty(O, P, Attributes) {
  _anObject(O);
  P = _toPrimitive(P, true);
  _anObject(Attributes);
  if (_ie8DomDefine) try {
    return dP(O, P, Attributes);
  } catch (e) {}
  if ("get" in Attributes || "set" in Attributes) throw TypeError("Accessors not supported!");
  if ("value" in Attributes) O[P] = Attributes.value;
  return O;
};

var _objectDp = {
  f: f
};

var _propertyDesc = function(bitmap, value) {
  return {
    enumerable: !(bitmap & 1),
    configurable: !(bitmap & 2),
    writable: !(bitmap & 4),
    value: value
  };
};

var _hide = _descriptors ? function(object, key, value) {
  return _objectDp.f(object, key, _propertyDesc(1, value));
} : function(object, key, value) {
  object[key] = value;
  return object;
};

var hasOwnProperty = {}.hasOwnProperty;

var _has = function(it, key) {
  return hasOwnProperty.call(it, key);
};

var id = 0;

var px = Math.random();

var _uid = function(key) {
  return "Symbol(".concat(key === undefined ? "" : key, ")_", (++id + px).toString(36));
};

var _shared = createCommonjsModule(function(module) {
  var SHARED = "__core-js_shared__";
  var store = _global[SHARED] || (_global[SHARED] = {});
  (module.exports = function(key, value) {
    return store[key] || (store[key] = value !== undefined ? value : {});
  })("versions", []).push({
    version: _core.version,
    mode: "global",
    copyright: "© 2019 Denis Pushkarev (zloirock.ru)"
  });
});

var _functionToString = _shared("native-function-to-string", Function.toString);

var _redefine = createCommonjsModule(function(module) {
  var SRC = _uid("src");
  var TO_STRING = "toString";
  var TPL = ("" + _functionToString).split(TO_STRING);
  _core.inspectSource = function(it) {
    return _functionToString.call(it);
  };
  (module.exports = function(O, key, val, safe) {
    var isFunction = typeof val == "function";
    if (isFunction) _has(val, "name") || _hide(val, "name", key);
    if (O[key] === val) return;
    if (isFunction) _has(val, SRC) || _hide(val, SRC, O[key] ? "" + O[key] : TPL.join(String(key)));
    if (O === _global) {
      O[key] = val;
    } else if (!safe) {
      delete O[key];
      _hide(O, key, val);
    } else if (O[key]) {
      O[key] = val;
    } else {
      _hide(O, key, val);
    }
  })(Function.prototype, TO_STRING, function toString() {
    return typeof this == "function" && this[SRC] || _functionToString.call(this);
  });
});

var _aFunction = function(it) {
  if (typeof it != "function") throw TypeError(it + " is not a function!");
  return it;
};

var _ctx = function(fn, that, length) {
  _aFunction(fn);
  if (that === undefined) return fn;
  switch (length) {
   case 1:
    return function(a) {
      return fn.call(that, a);
    };

   case 2:
    return function(a, b) {
      return fn.call(that, a, b);
    };

   case 3:
    return function(a, b, c) {
      return fn.call(that, a, b, c);
    };
  }
  return function() {
    return fn.apply(that, arguments);
  };
};

var PROTOTYPE = "prototype";

var $export = function(type, name, source) {
  var IS_FORCED = type & $export.F;
  var IS_GLOBAL = type & $export.G;
  var IS_STATIC = type & $export.S;
  var IS_PROTO = type & $export.P;
  var IS_BIND = type & $export.B;
  var target = IS_GLOBAL ? _global : IS_STATIC ? _global[name] || (_global[name] = {}) : (_global[name] || {})[PROTOTYPE];
  var exports = IS_GLOBAL ? _core : _core[name] || (_core[name] = {});
  var expProto = exports[PROTOTYPE] || (exports[PROTOTYPE] = {});
  var key, own, out, exp;
  if (IS_GLOBAL) source = name;
  for (key in source) {
    own = !IS_FORCED && target && target[key] !== undefined;
    out = (own ? target : source)[key];
    exp = IS_BIND && own ? _ctx(out, _global) : IS_PROTO && typeof out == "function" ? _ctx(Function.call, out) : out;
    if (target) _redefine(target, key, out, type & $export.U);
    if (exports[key] != out) _hide(exports, key, exp);
    if (IS_PROTO && expProto[key] != out) expProto[key] = out;
  }
};

_global.core = _core;

$export.F = 1;

$export.G = 2;

$export.S = 4;

$export.P = 8;

$export.B = 16;

$export.W = 32;

$export.U = 64;

$export.R = 128;

var _export = $export;

var toString = {}.toString;

var _cof = function(it) {
  return toString.call(it).slice(8, -1);
};

var _iobject = Object("z").propertyIsEnumerable(0) ? Object : function(it) {
  return _cof(it) == "String" ? it.split("") : Object(it);
};

var _defined = function(it) {
  if (it == undefined) throw TypeError("Can't call method on  " + it);
  return it;
};

var _toObject = function(it) {
  return Object(_defined(it));
};

var ceil = Math.ceil;

var floor = Math.floor;

var _toInteger = function(it) {
  return isNaN(it = +it) ? 0 : (it > 0 ? floor : ceil)(it);
};

var min = Math.min;

var _toLength = function(it) {
  return it > 0 ? min(_toInteger(it), 9007199254740991) : 0;
};

var _isArray = Array.isArray || function isArray(arg) {
  return _cof(arg) == "Array";
};

var _wks = createCommonjsModule(function(module) {
  var store = _shared("wks");
  var Symbol = _global.Symbol;
  var USE_SYMBOL = typeof Symbol == "function";
  var $exports = module.exports = function(name) {
    return store[name] || (store[name] = USE_SYMBOL && Symbol[name] || (USE_SYMBOL ? Symbol : _uid)("Symbol." + name));
  };
  $exports.store = store;
});

var SPECIES = _wks("species");

var _arraySpeciesConstructor = function(original) {
  var C;
  if (_isArray(original)) {
    C = original.constructor;
    if (typeof C == "function" && (C === Array || _isArray(C.prototype))) C = undefined;
    if (_isObject(C)) {
      C = C[SPECIES];
      if (C === null) C = undefined;
    }
  }
  return C === undefined ? Array : C;
};

var _arraySpeciesCreate = function(original, length) {
  return new (_arraySpeciesConstructor(original))(length);
};

var _arrayMethods = function(TYPE, $create) {
  var IS_MAP = TYPE == 1;
  var IS_FILTER = TYPE == 2;
  var IS_SOME = TYPE == 3;
  var IS_EVERY = TYPE == 4;
  var IS_FIND_INDEX = TYPE == 6;
  var NO_HOLES = TYPE == 5 || IS_FIND_INDEX;
  var create = $create || _arraySpeciesCreate;
  return function($this, callbackfn, that) {
    var O = _toObject($this);
    var self = _iobject(O);
    var f = _ctx(callbackfn, that, 3);
    var length = _toLength(self.length);
    var index = 0;
    var result = IS_MAP ? create($this, length) : IS_FILTER ? create($this, 0) : undefined;
    var val, res;
    for (;length > index; index++) if (NO_HOLES || index in self) {
      val = self[index];
      res = f(val, index, O);
      if (TYPE) {
        if (IS_MAP) result[index] = res; else if (res) switch (TYPE) {
         case 3:
          return true;

         case 5:
          return val;

         case 6:
          return index;

         case 2:
          result.push(val);
        } else if (IS_EVERY) return false;
      }
    }
    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : result;
  };
};

var UNSCOPABLES = _wks("unscopables");

var ArrayProto = Array.prototype;

if (ArrayProto[UNSCOPABLES] == undefined) _hide(ArrayProto, UNSCOPABLES, {});

var _addToUnscopables = function(key) {
  ArrayProto[UNSCOPABLES][key] = true;
};

var $find = _arrayMethods(5);

var KEY = "find";

var forced = true;

if (KEY in []) Array(1)[KEY](function() {
  forced = false;
});

_export(_export.P + _export.F * forced, "Array", {
  find: function find(callbackfn) {
    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});

_addToUnscopables(KEY);

var find = _core.Array.find;

var $find$1 = _arrayMethods(6);

var KEY$1 = "findIndex";

var forced$1 = true;

if (KEY$1 in []) Array(1)[KEY$1](function() {
  forced$1 = false;
});

_export(_export.P + _export.F * forced$1, "Array", {
  findIndex: function findIndex(callbackfn) {
    return $find$1(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});

_addToUnscopables(KEY$1);

var findIndex = _core.Array.findIndex;

var _stringAt = function(TO_STRING) {
  return function(that, pos) {
    var s = String(_defined(that));
    var i = _toInteger(pos);
    var l = s.length;
    var a, b;
    if (i < 0 || i >= l) return TO_STRING ? "" : undefined;
    a = s.charCodeAt(i);
    return a < 55296 || a > 56319 || i + 1 === l || (b = s.charCodeAt(i + 1)) < 56320 || b > 57343 ? TO_STRING ? s.charAt(i) : a : TO_STRING ? s.slice(i, i + 2) : (a - 55296 << 10) + (b - 56320) + 65536;
  };
};

var _iterators = {};

var _toIobject = function(it) {
  return _iobject(_defined(it));
};

var max = Math.max;

var min$1 = Math.min;

var _toAbsoluteIndex = function(index, length) {
  index = _toInteger(index);
  return index < 0 ? max(index + length, 0) : min$1(index, length);
};

var _arrayIncludes = function(IS_INCLUDES) {
  return function($this, el, fromIndex) {
    var O = _toIobject($this);
    var length = _toLength(O.length);
    var index = _toAbsoluteIndex(fromIndex, length);
    var value;
    if (IS_INCLUDES && el != el) while (length > index) {
      value = O[index++];
      if (value != value) return true;
    } else for (;length > index; index++) if (IS_INCLUDES || index in O) {
      if (O[index] === el) return IS_INCLUDES || index || 0;
    }
    return !IS_INCLUDES && -1;
  };
};

var shared = _shared("keys");

var _sharedKey = function(key) {
  return shared[key] || (shared[key] = _uid(key));
};

var arrayIndexOf = _arrayIncludes(false);

var IE_PROTO = _sharedKey("IE_PROTO");

var _objectKeysInternal = function(object, names) {
  var O = _toIobject(object);
  var i = 0;
  var result = [];
  var key;
  for (key in O) if (key != IE_PROTO) _has(O, key) && result.push(key);
  while (names.length > i) if (_has(O, key = names[i++])) {
    ~arrayIndexOf(result, key) || result.push(key);
  }
  return result;
};

var _enumBugKeys = "constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,toLocaleString,toString,valueOf".split(",");

var _objectKeys = Object.keys || function keys(O) {
  return _objectKeysInternal(O, _enumBugKeys);
};

var _objectDps = _descriptors ? Object.defineProperties : function defineProperties(O, Properties) {
  _anObject(O);
  var keys = _objectKeys(Properties);
  var length = keys.length;
  var i = 0;
  var P;
  while (length > i) _objectDp.f(O, P = keys[i++], Properties[P]);
  return O;
};

var document$2 = _global.document;

var _html = document$2 && document$2.documentElement;

var IE_PROTO$1 = _sharedKey("IE_PROTO");

var Empty = function() {};

var PROTOTYPE$1 = "prototype";

var createDict = function() {
  var iframe = _domCreate("iframe");
  var i = _enumBugKeys.length;
  var lt = "<";
  var gt = ">";
  var iframeDocument;
  iframe.style.display = "none";
  _html.appendChild(iframe);
  iframe.src = "javascript:";
  iframeDocument = iframe.contentWindow.document;
  iframeDocument.open();
  iframeDocument.write(lt + "script" + gt + "document.F=Object" + lt + "/script" + gt);
  iframeDocument.close();
  createDict = iframeDocument.F;
  while (i--) delete createDict[PROTOTYPE$1][_enumBugKeys[i]];
  return createDict();
};

var _objectCreate = Object.create || function create(O, Properties) {
  var result;
  if (O !== null) {
    Empty[PROTOTYPE$1] = _anObject(O);
    result = new Empty();
    Empty[PROTOTYPE$1] = null;
    result[IE_PROTO$1] = O;
  } else result = createDict();
  return Properties === undefined ? result : _objectDps(result, Properties);
};

var def = _objectDp.f;

var TAG = _wks("toStringTag");

var _setToStringTag = function(it, tag, stat) {
  if (it && !_has(it = stat ? it : it.prototype, TAG)) def(it, TAG, {
    configurable: true,
    value: tag
  });
};

var IteratorPrototype = {};

_hide(IteratorPrototype, _wks("iterator"), function() {
  return this;
});

var _iterCreate = function(Constructor, NAME, next) {
  Constructor.prototype = _objectCreate(IteratorPrototype, {
    next: _propertyDesc(1, next)
  });
  _setToStringTag(Constructor, NAME + " Iterator");
};

var IE_PROTO$2 = _sharedKey("IE_PROTO");

var ObjectProto = Object.prototype;

var _objectGpo = Object.getPrototypeOf || function(O) {
  O = _toObject(O);
  if (_has(O, IE_PROTO$2)) return O[IE_PROTO$2];
  if (typeof O.constructor == "function" && O instanceof O.constructor) {
    return O.constructor.prototype;
  }
  return O instanceof Object ? ObjectProto : null;
};

var ITERATOR = _wks("iterator");

var BUGGY = !([].keys && "next" in [].keys());

var FF_ITERATOR = "@@iterator";

var KEYS = "keys";

var VALUES = "values";

var returnThis = function() {
  return this;
};

var _iterDefine = function(Base, NAME, Constructor, next, DEFAULT, IS_SET, FORCED) {
  _iterCreate(Constructor, NAME, next);
  var getMethod = function(kind) {
    if (!BUGGY && kind in proto) return proto[kind];
    switch (kind) {
     case KEYS:
      return function keys() {
        return new Constructor(this, kind);
      };

     case VALUES:
      return function values() {
        return new Constructor(this, kind);
      };
    }
    return function entries() {
      return new Constructor(this, kind);
    };
  };
  var TAG = NAME + " Iterator";
  var DEF_VALUES = DEFAULT == VALUES;
  var VALUES_BUG = false;
  var proto = Base.prototype;
  var $native = proto[ITERATOR] || proto[FF_ITERATOR] || DEFAULT && proto[DEFAULT];
  var $default = $native || getMethod(DEFAULT);
  var $entries = DEFAULT ? !DEF_VALUES ? $default : getMethod("entries") : undefined;
  var $anyNative = NAME == "Array" ? proto.entries || $native : $native;
  var methods, key, IteratorPrototype;
  if ($anyNative) {
    IteratorPrototype = _objectGpo($anyNative.call(new Base()));
    if (IteratorPrototype !== Object.prototype && IteratorPrototype.next) {
      _setToStringTag(IteratorPrototype, TAG, true);
      if (typeof IteratorPrototype[ITERATOR] != "function") _hide(IteratorPrototype, ITERATOR, returnThis);
    }
  }
  if (DEF_VALUES && $native && $native.name !== VALUES) {
    VALUES_BUG = true;
    $default = function values() {
      return $native.call(this);
    };
  }
  if (BUGGY || VALUES_BUG || !proto[ITERATOR]) {
    _hide(proto, ITERATOR, $default);
  }
  _iterators[NAME] = $default;
  _iterators[TAG] = returnThis;
  if (DEFAULT) {
    methods = {
      values: DEF_VALUES ? $default : getMethod(VALUES),
      keys: IS_SET ? $default : getMethod(KEYS),
      entries: $entries
    };
    if (FORCED) for (key in methods) {
      if (!(key in proto)) _redefine(proto, key, methods[key]);
    } else _export(_export.P + _export.F * (BUGGY || VALUES_BUG), NAME, methods);
  }
  return methods;
};

var $at = _stringAt(true);

_iterDefine(String, "String", function(iterated) {
  this._t = String(iterated);
  this._i = 0;
}, function() {
  var O = this._t;
  var index = this._i;
  var point;
  if (index >= O.length) return {
    value: undefined,
    done: true
  };
  point = $at(O, index);
  this._i += point.length;
  return {
    value: point,
    done: false
  };
});

var _iterCall = function(iterator, fn, value, entries) {
  try {
    return entries ? fn(_anObject(value)[0], value[1]) : fn(value);
  } catch (e) {
    var ret = iterator["return"];
    if (ret !== undefined) _anObject(ret.call(iterator));
    throw e;
  }
};

var ITERATOR$1 = _wks("iterator");

var ArrayProto$1 = Array.prototype;

var _isArrayIter = function(it) {
  return it !== undefined && (_iterators.Array === it || ArrayProto$1[ITERATOR$1] === it);
};

var _createProperty = function(object, index, value) {
  if (index in object) _objectDp.f(object, index, _propertyDesc(0, value)); else object[index] = value;
};

var TAG$1 = _wks("toStringTag");

var ARG = _cof(function() {
  return arguments;
}()) == "Arguments";

var tryGet = function(it, key) {
  try {
    return it[key];
  } catch (e) {}
};

var _classof = function(it) {
  var O, T, B;
  return it === undefined ? "Undefined" : it === null ? "Null" : typeof (T = tryGet(O = Object(it), TAG$1)) == "string" ? T : ARG ? _cof(O) : (B = _cof(O)) == "Object" && typeof O.callee == "function" ? "Arguments" : B;
};

var ITERATOR$2 = _wks("iterator");

var core_getIteratorMethod = _core.getIteratorMethod = function(it) {
  if (it != undefined) return it[ITERATOR$2] || it["@@iterator"] || _iterators[_classof(it)];
};

var ITERATOR$3 = _wks("iterator");

var SAFE_CLOSING = false;

try {
  var riter = [ 7 ][ITERATOR$3]();
  riter["return"] = function() {
    SAFE_CLOSING = true;
  };
  Array.from(riter, function() {
    throw 2;
  });
} catch (e) {}

var _iterDetect = function(exec, skipClosing) {
  if (!skipClosing && !SAFE_CLOSING) return false;
  var safe = false;
  try {
    var arr = [ 7 ];
    var iter = arr[ITERATOR$3]();
    iter.next = function() {
      return {
        done: safe = true
      };
    };
    arr[ITERATOR$3] = function() {
      return iter;
    };
    exec(arr);
  } catch (e) {}
  return safe;
};

_export(_export.S + _export.F * !_iterDetect(function(iter) {
  Array.from(iter);
}), "Array", {
  from: function from(arrayLike) {
    var O = _toObject(arrayLike);
    var C = typeof this == "function" ? this : Array;
    var aLen = arguments.length;
    var mapfn = aLen > 1 ? arguments[1] : undefined;
    var mapping = mapfn !== undefined;
    var index = 0;
    var iterFn = core_getIteratorMethod(O);
    var length, result, step, iterator;
    if (mapping) mapfn = _ctx(mapfn, aLen > 2 ? arguments[2] : undefined, 2);
    if (iterFn != undefined && !(C == Array && _isArrayIter(iterFn))) {
      for (iterator = iterFn.call(O), result = new C(); !(step = iterator.next()).done; index++) {
        _createProperty(result, index, mapping ? _iterCall(iterator, mapfn, [ step.value, index ], true) : step.value);
      }
    } else {
      length = _toLength(O.length);
      for (result = new C(length); length > index; index++) {
        _createProperty(result, index, mapping ? mapfn(O[index], index) : O[index]);
      }
    }
    result.length = index;
    return result;
  }
});

var from_1 = _core.Array.from;

var test = {};

test[_wks("toStringTag")] = "z";

if (test + "" != "[object z]") {
  _redefine(Object.prototype, "toString", function toString() {
    return "[object " + _classof(this) + "]";
  }, true);
}

var _iterStep = function(done, value) {
  return {
    value: value,
    done: !!done
  };
};

var es6_array_iterator = _iterDefine(Array, "Array", function(iterated, kind) {
  this._t = _toIobject(iterated);
  this._i = 0;
  this._k = kind;
}, function() {
  var O = this._t;
  var kind = this._k;
  var index = this._i++;
  if (!O || index >= O.length) {
    this._t = undefined;
    return _iterStep(1);
  }
  if (kind == "keys") return _iterStep(0, index);
  if (kind == "values") return _iterStep(0, O[index]);
  return _iterStep(0, [ index, O[index] ]);
}, "values");

_iterators.Arguments = _iterators.Array;

_addToUnscopables("keys");

_addToUnscopables("values");

_addToUnscopables("entries");

var ITERATOR$4 = _wks("iterator");

var TO_STRING_TAG = _wks("toStringTag");

var ArrayValues = _iterators.Array;

var DOMIterables = {
  CSSRuleList: true,
  CSSStyleDeclaration: false,
  CSSValueList: false,
  ClientRectList: false,
  DOMRectList: false,
  DOMStringList: false,
  DOMTokenList: true,
  DataTransferItemList: false,
  FileList: false,
  HTMLAllCollection: false,
  HTMLCollection: false,
  HTMLFormElement: false,
  HTMLSelectElement: false,
  MediaList: true,
  MimeTypeArray: false,
  NamedNodeMap: false,
  NodeList: true,
  PaintRequestList: false,
  Plugin: false,
  PluginArray: false,
  SVGLengthList: false,
  SVGNumberList: false,
  SVGPathSegList: false,
  SVGPointList: false,
  SVGStringList: false,
  SVGTransformList: false,
  SourceBufferList: false,
  StyleSheetList: true,
  TextTrackCueList: false,
  TextTrackList: false,
  TouchList: false
};

for (var collections = _objectKeys(DOMIterables), i = 0; i < collections.length; i++) {
  var NAME = collections[i];
  var explicit = DOMIterables[NAME];
  var Collection = _global[NAME];
  var proto = Collection && Collection.prototype;
  var key;
  if (proto) {
    if (!proto[ITERATOR$4]) _hide(proto, ITERATOR$4, ArrayValues);
    if (!proto[TO_STRING_TAG]) _hide(proto, TO_STRING_TAG, NAME);
    _iterators[NAME] = ArrayValues;
    if (explicit) for (key in es6_array_iterator) if (!proto[key]) _redefine(proto, key, es6_array_iterator[key], true);
  }
}

var _redefineAll = function(target, src, safe) {
  for (var key in src) _redefine(target, key, src[key], safe);
  return target;
};

var _anInstance = function(it, Constructor, name, forbiddenField) {
  if (!(it instanceof Constructor) || forbiddenField !== undefined && forbiddenField in it) {
    throw TypeError(name + ": incorrect invocation!");
  }
  return it;
};

var _forOf = createCommonjsModule(function(module) {
  var BREAK = {};
  var RETURN = {};
  var exports = module.exports = function(iterable, entries, fn, that, ITERATOR) {
    var iterFn = ITERATOR ? function() {
      return iterable;
    } : core_getIteratorMethod(iterable);
    var f = _ctx(fn, that, entries ? 2 : 1);
    var index = 0;
    var length, step, iterator, result;
    if (typeof iterFn != "function") throw TypeError(iterable + " is not iterable!");
    if (_isArrayIter(iterFn)) for (length = _toLength(iterable.length); length > index; index++) {
      result = entries ? f(_anObject(step = iterable[index])[0], step[1]) : f(iterable[index]);
      if (result === BREAK || result === RETURN) return result;
    } else for (iterator = iterFn.call(iterable); !(step = iterator.next()).done; ) {
      result = _iterCall(iterator, f, step.value, entries);
      if (result === BREAK || result === RETURN) return result;
    }
  };
  exports.BREAK = BREAK;
  exports.RETURN = RETURN;
});

var SPECIES$1 = _wks("species");

var _setSpecies = function(KEY) {
  var C = _global[KEY];
  if (_descriptors && C && !C[SPECIES$1]) _objectDp.f(C, SPECIES$1, {
    configurable: true,
    get: function() {
      return this;
    }
  });
};

var _meta = createCommonjsModule(function(module) {
  var META = _uid("meta");
  var setDesc = _objectDp.f;
  var id = 0;
  var isExtensible = Object.isExtensible || function() {
    return true;
  };
  var FREEZE = !_fails(function() {
    return isExtensible(Object.preventExtensions({}));
  });
  var setMeta = function(it) {
    setDesc(it, META, {
      value: {
        i: "O" + ++id,
        w: {}
      }
    });
  };
  var fastKey = function(it, create) {
    if (!_isObject(it)) return typeof it == "symbol" ? it : (typeof it == "string" ? "S" : "P") + it;
    if (!_has(it, META)) {
      if (!isExtensible(it)) return "F";
      if (!create) return "E";
      setMeta(it);
    }
    return it[META].i;
  };
  var getWeak = function(it, create) {
    if (!_has(it, META)) {
      if (!isExtensible(it)) return true;
      if (!create) return false;
      setMeta(it);
    }
    return it[META].w;
  };
  var onFreeze = function(it) {
    if (FREEZE && meta.NEED && isExtensible(it) && !_has(it, META)) setMeta(it);
    return it;
  };
  var meta = module.exports = {
    KEY: META,
    NEED: false,
    fastKey: fastKey,
    getWeak: getWeak,
    onFreeze: onFreeze
  };
});

var _validateCollection = function(it, TYPE) {
  if (!_isObject(it) || it._t !== TYPE) throw TypeError("Incompatible receiver, " + TYPE + " required!");
  return it;
};

var dP$1 = _objectDp.f;

var fastKey = _meta.fastKey;

var SIZE = _descriptors ? "_s" : "size";

var getEntry = function(that, key) {
  var index = fastKey(key);
  var entry;
  if (index !== "F") return that._i[index];
  for (entry = that._f; entry; entry = entry.n) {
    if (entry.k == key) return entry;
  }
};

var _collectionStrong = {
  getConstructor: function(wrapper, NAME, IS_MAP, ADDER) {
    var C = wrapper(function(that, iterable) {
      _anInstance(that, C, NAME, "_i");
      that._t = NAME;
      that._i = _objectCreate(null);
      that._f = undefined;
      that._l = undefined;
      that[SIZE] = 0;
      if (iterable != undefined) _forOf(iterable, IS_MAP, that[ADDER], that);
    });
    _redefineAll(C.prototype, {
      clear: function clear() {
        for (var that = _validateCollection(this, NAME), data = that._i, entry = that._f; entry; entry = entry.n) {
          entry.r = true;
          if (entry.p) entry.p = entry.p.n = undefined;
          delete data[entry.i];
        }
        that._f = that._l = undefined;
        that[SIZE] = 0;
      },
      delete: function(key) {
        var that = _validateCollection(this, NAME);
        var entry = getEntry(that, key);
        if (entry) {
          var next = entry.n;
          var prev = entry.p;
          delete that._i[entry.i];
          entry.r = true;
          if (prev) prev.n = next;
          if (next) next.p = prev;
          if (that._f == entry) that._f = next;
          if (that._l == entry) that._l = prev;
          that[SIZE]--;
        }
        return !!entry;
      },
      forEach: function forEach(callbackfn) {
        _validateCollection(this, NAME);
        var f = _ctx(callbackfn, arguments.length > 1 ? arguments[1] : undefined, 3);
        var entry;
        while (entry = entry ? entry.n : this._f) {
          f(entry.v, entry.k, this);
          while (entry && entry.r) entry = entry.p;
        }
      },
      has: function has(key) {
        return !!getEntry(_validateCollection(this, NAME), key);
      }
    });
    if (_descriptors) dP$1(C.prototype, "size", {
      get: function() {
        return _validateCollection(this, NAME)[SIZE];
      }
    });
    return C;
  },
  def: function(that, key, value) {
    var entry = getEntry(that, key);
    var prev, index;
    if (entry) {
      entry.v = value;
    } else {
      that._l = entry = {
        i: index = fastKey(key, true),
        k: key,
        v: value,
        p: prev = that._l,
        n: undefined,
        r: false
      };
      if (!that._f) that._f = entry;
      if (prev) prev.n = entry;
      that[SIZE]++;
      if (index !== "F") that._i[index] = entry;
    }
    return that;
  },
  getEntry: getEntry,
  setStrong: function(C, NAME, IS_MAP) {
    _iterDefine(C, NAME, function(iterated, kind) {
      this._t = _validateCollection(iterated, NAME);
      this._k = kind;
      this._l = undefined;
    }, function() {
      var that = this;
      var kind = that._k;
      var entry = that._l;
      while (entry && entry.r) entry = entry.p;
      if (!that._t || !(that._l = entry = entry ? entry.n : that._t._f)) {
        that._t = undefined;
        return _iterStep(1);
      }
      if (kind == "keys") return _iterStep(0, entry.k);
      if (kind == "values") return _iterStep(0, entry.v);
      return _iterStep(0, [ entry.k, entry.v ]);
    }, IS_MAP ? "entries" : "values", !IS_MAP, true);
    _setSpecies(NAME);
  }
};

var f$1 = {}.propertyIsEnumerable;

var _objectPie = {
  f: f$1
};

var gOPD = Object.getOwnPropertyDescriptor;

var f$2 = _descriptors ? gOPD : function getOwnPropertyDescriptor(O, P) {
  O = _toIobject(O);
  P = _toPrimitive(P, true);
  if (_ie8DomDefine) try {
    return gOPD(O, P);
  } catch (e) {}
  if (_has(O, P)) return _propertyDesc(!_objectPie.f.call(O, P), O[P]);
};

var _objectGopd = {
  f: f$2
};

var check = function(O, proto) {
  _anObject(O);
  if (!_isObject(proto) && proto !== null) throw TypeError(proto + ": can't set as prototype!");
};

var _setProto = {
  set: Object.setPrototypeOf || ("__proto__" in {} ? function(test, buggy, set) {
    try {
      set = _ctx(Function.call, _objectGopd.f(Object.prototype, "__proto__").set, 2);
      set(test, []);
      buggy = !(test instanceof Array);
    } catch (e) {
      buggy = true;
    }
    return function setPrototypeOf(O, proto) {
      check(O, proto);
      if (buggy) O.__proto__ = proto; else set(O, proto);
      return O;
    };
  }({}, false) : undefined),
  check: check
};

var setPrototypeOf = _setProto.set;

var _inheritIfRequired = function(that, target, C) {
  var S = target.constructor;
  var P;
  if (S !== C && typeof S == "function" && (P = S.prototype) !== C.prototype && _isObject(P) && setPrototypeOf) {
    setPrototypeOf(that, P);
  }
  return that;
};

var _collection = function(NAME, wrapper, methods, common, IS_MAP, IS_WEAK) {
  var Base = _global[NAME];
  var C = Base;
  var ADDER = IS_MAP ? "set" : "add";
  var proto = C && C.prototype;
  var O = {};
  var fixMethod = function(KEY) {
    var fn = proto[KEY];
    _redefine(proto, KEY, KEY == "delete" ? function(a) {
      return IS_WEAK && !_isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
    } : KEY == "has" ? function has(a) {
      return IS_WEAK && !_isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
    } : KEY == "get" ? function get(a) {
      return IS_WEAK && !_isObject(a) ? undefined : fn.call(this, a === 0 ? 0 : a);
    } : KEY == "add" ? function add(a) {
      fn.call(this, a === 0 ? 0 : a);
      return this;
    } : function set(a, b) {
      fn.call(this, a === 0 ? 0 : a, b);
      return this;
    });
  };
  if (typeof C != "function" || !(IS_WEAK || proto.forEach && !_fails(function() {
    new C().entries().next();
  }))) {
    C = common.getConstructor(wrapper, NAME, IS_MAP, ADDER);
    _redefineAll(C.prototype, methods);
    _meta.NEED = true;
  } else {
    var instance = new C();
    var HASNT_CHAINING = instance[ADDER](IS_WEAK ? {} : -0, 1) != instance;
    var THROWS_ON_PRIMITIVES = _fails(function() {
      instance.has(1);
    });
    var ACCEPT_ITERABLES = _iterDetect(function(iter) {
      new C(iter);
    });
    var BUGGY_ZERO = !IS_WEAK && _fails(function() {
      var $instance = new C();
      var index = 5;
      while (index--) $instance[ADDER](index, index);
      return !$instance.has(-0);
    });
    if (!ACCEPT_ITERABLES) {
      C = wrapper(function(target, iterable) {
        _anInstance(target, C, NAME);
        var that = _inheritIfRequired(new Base(), target, C);
        if (iterable != undefined) _forOf(iterable, IS_MAP, that[ADDER], that);
        return that;
      });
      C.prototype = proto;
      proto.constructor = C;
    }
    if (THROWS_ON_PRIMITIVES || BUGGY_ZERO) {
      fixMethod("delete");
      fixMethod("has");
      IS_MAP && fixMethod("get");
    }
    if (BUGGY_ZERO || HASNT_CHAINING) fixMethod(ADDER);
    if (IS_WEAK && proto.clear) delete proto.clear;
  }
  _setToStringTag(C, NAME);
  O[NAME] = C;
  _export(_export.G + _export.W + _export.F * (C != Base), O);
  if (!IS_WEAK) common.setStrong(C, NAME, IS_MAP);
  return C;
};

var MAP = "Map";

var es6_map = _collection(MAP, function(get) {
  return function Map() {
    return get(this, arguments.length > 0 ? arguments[0] : undefined);
  };
}, {
  get: function get(key) {
    var entry = _collectionStrong.getEntry(_validateCollection(this, MAP), key);
    return entry && entry.v;
  },
  set: function set(key, value) {
    return _collectionStrong.def(_validateCollection(this, MAP), key === 0 ? 0 : key, value);
  }
}, _collectionStrong, true);

var _arrayFromIterable = function(iter, ITERATOR) {
  var result = [];
  _forOf(iter, false, result.push, result, ITERATOR);
  return result;
};

var _collectionToJson = function(NAME) {
  return function toJSON() {
    if (_classof(this) != NAME) throw TypeError(NAME + "#toJSON isn't generic");
    return _arrayFromIterable(this);
  };
};

_export(_export.P + _export.R, "Map", {
  toJSON: _collectionToJson("Map")
});

var _setCollectionOf = function(COLLECTION) {
  _export(_export.S, COLLECTION, {
    of: function of() {
      var length = arguments.length;
      var A = new Array(length);
      while (length--) A[length] = arguments[length];
      return new this(A);
    }
  });
};

_setCollectionOf("Map");

var _setCollectionFrom = function(COLLECTION) {
  _export(_export.S, COLLECTION, {
    from: function from(source) {
      var mapFn = arguments[1];
      var mapping, A, n, cb;
      _aFunction(this);
      mapping = mapFn !== undefined;
      if (mapping) _aFunction(mapFn);
      if (source == undefined) return new this();
      A = [];
      if (mapping) {
        n = 0;
        cb = _ctx(mapFn, arguments[2], 2);
        _forOf(source, false, function(nextItem) {
          A.push(cb(nextItem, n++));
        });
      } else {
        _forOf(source, false, A.push, A);
      }
      return new this(A);
    }
  });
};

_setCollectionFrom("Map");

var map = _core.Map;

var f$3 = Object.getOwnPropertySymbols;

var _objectGops = {
  f: f$3
};

var $assign = Object.assign;

var _objectAssign = !$assign || _fails(function() {
  var A = {};
  var B = {};
  var S = Symbol();
  var K = "abcdefghijklmnopqrst";
  A[S] = 7;
  K.split("").forEach(function(k) {
    B[k] = k;
  });
  return $assign({}, A)[S] != 7 || Object.keys($assign({}, B)).join("") != K;
}) ? function assign(target, source) {
  var T = _toObject(target);
  var aLen = arguments.length;
  var index = 1;
  var getSymbols = _objectGops.f;
  var isEnum = _objectPie.f;
  while (aLen > index) {
    var S = _iobject(arguments[index++]);
    var keys = getSymbols ? _objectKeys(S).concat(getSymbols(S)) : _objectKeys(S);
    var length = keys.length;
    var j = 0;
    var key;
    while (length > j) {
      key = keys[j++];
      if (!_descriptors || isEnum.call(S, key)) T[key] = S[key];
    }
  }
  return T;
} : $assign;

_export(_export.S + _export.F, "Object", {
  assign: _objectAssign
});

var assign = _core.Object.assign;

var SPECIES$2 = _wks("species");

var _speciesConstructor = function(O, D) {
  var C = _anObject(O).constructor;
  var S;
  return C === undefined || (S = _anObject(C)[SPECIES$2]) == undefined ? D : _aFunction(S);
};

var _invoke = function(fn, args, that) {
  var un = that === undefined;
  switch (args.length) {
   case 0:
    return un ? fn() : fn.call(that);

   case 1:
    return un ? fn(args[0]) : fn.call(that, args[0]);

   case 2:
    return un ? fn(args[0], args[1]) : fn.call(that, args[0], args[1]);

   case 3:
    return un ? fn(args[0], args[1], args[2]) : fn.call(that, args[0], args[1], args[2]);

   case 4:
    return un ? fn(args[0], args[1], args[2], args[3]) : fn.call(that, args[0], args[1], args[2], args[3]);
  }
  return fn.apply(that, args);
};

var process = _global.process;

var setTask = _global.setImmediate;

var clearTask = _global.clearImmediate;

var MessageChannel = _global.MessageChannel;

var Dispatch = _global.Dispatch;

var counter = 0;

var queue = {};

var ONREADYSTATECHANGE = "onreadystatechange";

var defer, channel, port;

var run = function() {
  var id = +this;
  if (queue.hasOwnProperty(id)) {
    var fn = queue[id];
    delete queue[id];
    fn();
  }
};

var listener = function(event) {
  run.call(event.data);
};

if (!setTask || !clearTask) {
  setTask = function setImmediate(fn) {
    var args = [];
    var i = 1;
    while (arguments.length > i) args.push(arguments[i++]);
    queue[++counter] = function() {
      _invoke(typeof fn == "function" ? fn : Function(fn), args);
    };
    defer(counter);
    return counter;
  };
  clearTask = function clearImmediate(id) {
    delete queue[id];
  };
  if (_cof(process) == "process") {
    defer = function(id) {
      process.nextTick(_ctx(run, id, 1));
    };
  } else if (Dispatch && Dispatch.now) {
    defer = function(id) {
      Dispatch.now(_ctx(run, id, 1));
    };
  } else if (MessageChannel) {
    channel = new MessageChannel();
    port = channel.port2;
    channel.port1.onmessage = listener;
    defer = _ctx(port.postMessage, port, 1);
  } else if (_global.addEventListener && typeof postMessage == "function" && !_global.importScripts) {
    defer = function(id) {
      _global.postMessage(id + "", "*");
    };
    _global.addEventListener("message", listener, false);
  } else if (ONREADYSTATECHANGE in _domCreate("script")) {
    defer = function(id) {
      _html.appendChild(_domCreate("script"))[ONREADYSTATECHANGE] = function() {
        _html.removeChild(this);
        run.call(id);
      };
    };
  } else {
    defer = function(id) {
      setTimeout(_ctx(run, id, 1), 0);
    };
  }
}

var _task = {
  set: setTask,
  clear: clearTask
};

var macrotask = _task.set;

var Observer = _global.MutationObserver || _global.WebKitMutationObserver;

var process$1 = _global.process;

var Promise$1 = _global.Promise;

var isNode = _cof(process$1) == "process";

var _microtask = function() {
  var head, last, notify;
  var flush = function() {
    var parent, fn;
    if (isNode && (parent = process$1.domain)) parent.exit();
    while (head) {
      fn = head.fn;
      head = head.next;
      try {
        fn();
      } catch (e) {
        if (head) notify(); else last = undefined;
        throw e;
      }
    }
    last = undefined;
    if (parent) parent.enter();
  };
  if (isNode) {
    notify = function() {
      process$1.nextTick(flush);
    };
  } else if (Observer && !(_global.navigator && _global.navigator.standalone)) {
    var toggle = true;
    var node = document.createTextNode("");
    new Observer(flush).observe(node, {
      characterData: true
    });
    notify = function() {
      node.data = toggle = !toggle;
    };
  } else if (Promise$1 && Promise$1.resolve) {
    var promise = Promise$1.resolve(undefined);
    notify = function() {
      promise.then(flush);
    };
  } else {
    notify = function() {
      macrotask.call(_global, flush);
    };
  }
  return function(fn) {
    var task = {
      fn: fn,
      next: undefined
    };
    if (last) last.next = task;
    if (!head) {
      head = task;
      notify();
    }
    last = task;
  };
};

function PromiseCapability(C) {
  var resolve, reject;
  this.promise = new C(function($$resolve, $$reject) {
    if (resolve !== undefined || reject !== undefined) throw TypeError("Bad Promise constructor");
    resolve = $$resolve;
    reject = $$reject;
  });
  this.resolve = _aFunction(resolve);
  this.reject = _aFunction(reject);
}

var f$4 = function(C) {
  return new PromiseCapability(C);
};

var _newPromiseCapability = {
  f: f$4
};

var _perform = function(exec) {
  try {
    return {
      e: false,
      v: exec()
    };
  } catch (e) {
    return {
      e: true,
      v: e
    };
  }
};

var navigator = _global.navigator;

var _userAgent = navigator && navigator.userAgent || "";

var _promiseResolve = function(C, x) {
  _anObject(C);
  if (_isObject(x) && x.constructor === C) return x;
  var promiseCapability = _newPromiseCapability.f(C);
  var resolve = promiseCapability.resolve;
  resolve(x);
  return promiseCapability.promise;
};

var task = _task.set;

var microtask = _microtask();

var PROMISE = "Promise";

var TypeError$1 = _global.TypeError;

var process$2 = _global.process;

var versions = process$2 && process$2.versions;

var v8 = versions && versions.v8 || "";

var $Promise = _global[PROMISE];

var isNode$1 = _classof(process$2) == "process";

var empty = function() {};

var Internal, newGenericPromiseCapability, OwnPromiseCapability, Wrapper;

var newPromiseCapability = newGenericPromiseCapability = _newPromiseCapability.f;

var USE_NATIVE = !!function() {
  try {
    var promise = $Promise.resolve(1);
    var FakePromise = (promise.constructor = {})[_wks("species")] = function(exec) {
      exec(empty, empty);
    };
    return (isNode$1 || typeof PromiseRejectionEvent == "function") && promise.then(empty) instanceof FakePromise && v8.indexOf("6.6") !== 0 && _userAgent.indexOf("Chrome/66") === -1;
  } catch (e) {}
}();

var isThenable = function(it) {
  var then;
  return _isObject(it) && typeof (then = it.then) == "function" ? then : false;
};

var notify = function(promise, isReject) {
  if (promise._n) return;
  promise._n = true;
  var chain = promise._c;
  microtask(function() {
    var value = promise._v;
    var ok = promise._s == 1;
    var i = 0;
    var run = function(reaction) {
      var handler = ok ? reaction.ok : reaction.fail;
      var resolve = reaction.resolve;
      var reject = reaction.reject;
      var domain = reaction.domain;
      var result, then, exited;
      try {
        if (handler) {
          if (!ok) {
            if (promise._h == 2) onHandleUnhandled(promise);
            promise._h = 1;
          }
          if (handler === true) result = value; else {
            if (domain) domain.enter();
            result = handler(value);
            if (domain) {
              domain.exit();
              exited = true;
            }
          }
          if (result === reaction.promise) {
            reject(TypeError$1("Promise-chain cycle"));
          } else if (then = isThenable(result)) {
            then.call(result, resolve, reject);
          } else resolve(result);
        } else reject(value);
      } catch (e) {
        if (domain && !exited) domain.exit();
        reject(e);
      }
    };
    while (chain.length > i) run(chain[i++]);
    promise._c = [];
    promise._n = false;
    if (isReject && !promise._h) onUnhandled(promise);
  });
};

var onUnhandled = function(promise) {
  task.call(_global, function() {
    var value = promise._v;
    var unhandled = isUnhandled(promise);
    var result, handler, console;
    if (unhandled) {
      result = _perform(function() {
        if (isNode$1) {
          process$2.emit("unhandledRejection", value, promise);
        } else if (handler = _global.onunhandledrejection) {
          handler({
            promise: promise,
            reason: value
          });
        } else if ((console = _global.console) && console.error) {
          console.error("Unhandled promise rejection", value);
        }
      });
      promise._h = isNode$1 || isUnhandled(promise) ? 2 : 1;
    }
    promise._a = undefined;
    if (unhandled && result.e) throw result.v;
  });
};

var isUnhandled = function(promise) {
  return promise._h !== 1 && (promise._a || promise._c).length === 0;
};

var onHandleUnhandled = function(promise) {
  task.call(_global, function() {
    var handler;
    if (isNode$1) {
      process$2.emit("rejectionHandled", promise);
    } else if (handler = _global.onrejectionhandled) {
      handler({
        promise: promise,
        reason: promise._v
      });
    }
  });
};

var $reject = function(value) {
  var promise = this;
  if (promise._d) return;
  promise._d = true;
  promise = promise._w || promise;
  promise._v = value;
  promise._s = 2;
  if (!promise._a) promise._a = promise._c.slice();
  notify(promise, true);
};

var $resolve = function(value) {
  var promise = this;
  var then;
  if (promise._d) return;
  promise._d = true;
  promise = promise._w || promise;
  try {
    if (promise === value) throw TypeError$1("Promise can't be resolved itself");
    if (then = isThenable(value)) {
      microtask(function() {
        var wrapper = {
          _w: promise,
          _d: false
        };
        try {
          then.call(value, _ctx($resolve, wrapper, 1), _ctx($reject, wrapper, 1));
        } catch (e) {
          $reject.call(wrapper, e);
        }
      });
    } else {
      promise._v = value;
      promise._s = 1;
      notify(promise, false);
    }
  } catch (e) {
    $reject.call({
      _w: promise,
      _d: false
    }, e);
  }
};

if (!USE_NATIVE) {
  $Promise = function Promise(executor) {
    _anInstance(this, $Promise, PROMISE, "_h");
    _aFunction(executor);
    Internal.call(this);
    try {
      executor(_ctx($resolve, this, 1), _ctx($reject, this, 1));
    } catch (err) {
      $reject.call(this, err);
    }
  };
  Internal = function Promise(executor) {
    this._c = [];
    this._a = undefined;
    this._s = 0;
    this._d = false;
    this._v = undefined;
    this._h = 0;
    this._n = false;
  };
  Internal.prototype = _redefineAll($Promise.prototype, {
    then: function then(onFulfilled, onRejected) {
      var reaction = newPromiseCapability(_speciesConstructor(this, $Promise));
      reaction.ok = typeof onFulfilled == "function" ? onFulfilled : true;
      reaction.fail = typeof onRejected == "function" && onRejected;
      reaction.domain = isNode$1 ? process$2.domain : undefined;
      this._c.push(reaction);
      if (this._a) this._a.push(reaction);
      if (this._s) notify(this, false);
      return reaction.promise;
    },
    catch: function(onRejected) {
      return this.then(undefined, onRejected);
    }
  });
  OwnPromiseCapability = function() {
    var promise = new Internal();
    this.promise = promise;
    this.resolve = _ctx($resolve, promise, 1);
    this.reject = _ctx($reject, promise, 1);
  };
  _newPromiseCapability.f = newPromiseCapability = function(C) {
    return C === $Promise || C === Wrapper ? new OwnPromiseCapability(C) : newGenericPromiseCapability(C);
  };
}

_export(_export.G + _export.W + _export.F * !USE_NATIVE, {
  Promise: $Promise
});

_setToStringTag($Promise, PROMISE);

_setSpecies(PROMISE);

Wrapper = _core[PROMISE];

_export(_export.S + _export.F * !USE_NATIVE, PROMISE, {
  reject: function reject(r) {
    var capability = newPromiseCapability(this);
    var $$reject = capability.reject;
    $$reject(r);
    return capability.promise;
  }
});

_export(_export.S + _export.F * !USE_NATIVE, PROMISE, {
  resolve: function resolve(x) {
    return _promiseResolve(this, x);
  }
});

_export(_export.S + _export.F * !(USE_NATIVE && _iterDetect(function(iter) {
  $Promise.all(iter)["catch"](empty);
})), PROMISE, {
  all: function all(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var resolve = capability.resolve;
    var reject = capability.reject;
    var result = _perform(function() {
      var values = [];
      var index = 0;
      var remaining = 1;
      _forOf(iterable, false, function(promise) {
        var $index = index++;
        var alreadyCalled = false;
        values.push(undefined);
        remaining++;
        C.resolve(promise).then(function(value) {
          if (alreadyCalled) return;
          alreadyCalled = true;
          values[$index] = value;
          --remaining || resolve(values);
        }, reject);
      });
      --remaining || resolve(values);
    });
    if (result.e) reject(result.v);
    return capability.promise;
  },
  race: function race(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var reject = capability.reject;
    var result = _perform(function() {
      _forOf(iterable, false, function(promise) {
        C.resolve(promise).then(capability.resolve, reject);
      });
    });
    if (result.e) reject(result.v);
    return capability.promise;
  }
});

_export(_export.P + _export.R, "Promise", {
  finally: function(onFinally) {
    var C = _speciesConstructor(this, _core.Promise || _global.Promise);
    var isFunction = typeof onFinally == "function";
    return this.then(isFunction ? function(x) {
      return _promiseResolve(C, onFinally()).then(function() {
        return x;
      });
    } : onFinally, isFunction ? function(e) {
      return _promiseResolve(C, onFinally()).then(function() {
        throw e;
      });
    } : onFinally);
  }
});

_export(_export.S, "Promise", {
  try: function(callbackfn) {
    var promiseCapability = _newPromiseCapability.f(this);
    var result = _perform(callbackfn);
    (result.e ? promiseCapability.reject : promiseCapability.resolve)(result.v);
    return promiseCapability.promise;
  }
});

var promise = _core.Promise;

var SET = "Set";

var es6_set = _collection(SET, function(get) {
  return function Set() {
    return get(this, arguments.length > 0 ? arguments[0] : undefined);
  };
}, {
  add: function add(value) {
    return _collectionStrong.def(_validateCollection(this, SET), value = value === 0 ? 0 : value, value);
  }
}, _collectionStrong);

_export(_export.P + _export.R, "Set", {
  toJSON: _collectionToJson("Set")
});

_setCollectionOf("Set");

_setCollectionFrom("Set");

var set = _core.Set;

(function(ElementProto) {
  if (typeof ElementProto.matches !== "function") {
    ElementProto.matches = ElementProto.msMatchesSelector || ElementProto.mozMatchesSelector || ElementProto.webkitMatchesSelector || function matches(selector) {
      var element = this;
      var elements = (element.document || element.ownerDocument).querySelectorAll(selector);
      var index = 0;
      while (elements[index] && elements[index] !== element) {
        ++index;
      }
      return Boolean(elements[index]);
    };
  }
  if (typeof ElementProto.closest !== "function") {
    ElementProto.closest = function closest(selector) {
      var element = this;
      while (element && element.nodeType === 1) {
        if (element.matches(selector)) {
          return element;
        }
        element = element.parentNode;
      }
      return null;
    };
  }
})(window.Element.prototype);

if (window.MutationObserver) {
  var element = document.createElement("div");
  element.innerHTML = "<div><div></div></div>";
  new MutationObserver(function(mutations, observer) {
    observer.disconnect();
    if (mutations[0] && mutations[0].type == "childList" && mutations[0].removedNodes[0].childNodes.length == 0) {
      var prototype = HTMLElement.prototype;
      var descriptor = Object.getOwnPropertyDescriptor(prototype, "innerHTML");
      if (descriptor && descriptor.set) {
        Object.defineProperty(prototype, "innerHTML", {
          set: function(value) {
            while (this.lastChild) this.removeChild(this.lastChild);
            descriptor.set.call(this, value);
          }
        });
      }
    }
  }).observe(element, {
    childList: true,
    subtree: true
  });
  element.innerHTML = "";
}

function finallyConstructor(callback) {
  var constructor = this.constructor;
  return this.then(function(value) {
    return constructor.resolve(callback()).then(function() {
      return value;
    });
  }, function(reason) {
    return constructor.resolve(callback()).then(function() {
      return constructor.reject(reason);
    });
  });
}

function allSettled(arr) {
  var P = this;
  return new P(function(resolve, reject) {
    if (!(arr && typeof arr.length !== "undefined")) {
      return reject(new TypeError(typeof arr + " " + arr + " is not iterable(cannot read property Symbol(Symbol.iterator))"));
    }
    var args = Array.prototype.slice.call(arr);
    if (args.length === 0) return resolve([]);
    var remaining = args.length;
    function res(i, val) {
      if (val && (typeof val === "object" || typeof val === "function")) {
        var then = val.then;
        if (typeof then === "function") {
          then.call(val, function(val) {
            res(i, val);
          }, function(e) {
            args[i] = {
              status: "rejected",
              reason: e
            };
            if (--remaining === 0) {
              resolve(args);
            }
          });
          return;
        }
      }
      args[i] = {
        status: "fulfilled",
        value: val
      };
      if (--remaining === 0) {
        resolve(args);
      }
    }
    for (var i = 0; i < args.length; i++) {
      res(i, args[i]);
    }
  });
}

var setTimeoutFunc = setTimeout;

function isArray(x) {
  return Boolean(x && typeof x.length !== "undefined");
}

function noop() {}

function bind(fn, thisArg) {
  return function() {
    fn.apply(thisArg, arguments);
  };
}

function Promise$2(fn) {
  if (!(this instanceof Promise$2)) throw new TypeError("Promises must be constructed via new");
  if (typeof fn !== "function") throw new TypeError("not a function");
  this._state = 0;
  this._handled = false;
  this._value = undefined;
  this._deferreds = [];
  doResolve(fn, this);
}

function handle(self, deferred) {
  while (self._state === 3) {
    self = self._value;
  }
  if (self._state === 0) {
    self._deferreds.push(deferred);
    return;
  }
  self._handled = true;
  Promise$2._immediateFn(function() {
    var cb = self._state === 1 ? deferred.onFulfilled : deferred.onRejected;
    if (cb === null) {
      (self._state === 1 ? resolve : reject)(deferred.promise, self._value);
      return;
    }
    var ret;
    try {
      ret = cb(self._value);
    } catch (e) {
      reject(deferred.promise, e);
      return;
    }
    resolve(deferred.promise, ret);
  });
}

function resolve(self, newValue) {
  try {
    if (newValue === self) throw new TypeError("A promise cannot be resolved with itself.");
    if (newValue && (typeof newValue === "object" || typeof newValue === "function")) {
      var then = newValue.then;
      if (newValue instanceof Promise$2) {
        self._state = 3;
        self._value = newValue;
        finale(self);
        return;
      } else if (typeof then === "function") {
        doResolve(bind(then, newValue), self);
        return;
      }
    }
    self._state = 1;
    self._value = newValue;
    finale(self);
  } catch (e) {
    reject(self, e);
  }
}

function reject(self, newValue) {
  self._state = 2;
  self._value = newValue;
  finale(self);
}

function finale(self) {
  if (self._state === 2 && self._deferreds.length === 0) {
    Promise$2._immediateFn(function() {
      if (!self._handled) {
        Promise$2._unhandledRejectionFn(self._value);
      }
    });
  }
  for (var i = 0, len = self._deferreds.length; i < len; i++) {
    handle(self, self._deferreds[i]);
  }
  self._deferreds = null;
}

function Handler(onFulfilled, onRejected, promise) {
  this.onFulfilled = typeof onFulfilled === "function" ? onFulfilled : null;
  this.onRejected = typeof onRejected === "function" ? onRejected : null;
  this.promise = promise;
}

function doResolve(fn, self) {
  var done = false;
  try {
    fn(function(value) {
      if (done) return;
      done = true;
      resolve(self, value);
    }, function(reason) {
      if (done) return;
      done = true;
      reject(self, reason);
    });
  } catch (ex) {
    if (done) return;
    done = true;
    reject(self, ex);
  }
}

Promise$2.prototype["catch"] = function(onRejected) {
  return this.then(null, onRejected);
};

Promise$2.prototype.then = function(onFulfilled, onRejected) {
  var prom = new this.constructor(noop);
  handle(this, new Handler(onFulfilled, onRejected, prom));
  return prom;
};

Promise$2.prototype["finally"] = finallyConstructor;

Promise$2.all = function(arr) {
  return new Promise$2(function(resolve, reject) {
    if (!isArray(arr)) {
      return reject(new TypeError("Promise.all accepts an array"));
    }
    var args = Array.prototype.slice.call(arr);
    if (args.length === 0) return resolve([]);
    var remaining = args.length;
    function res(i, val) {
      try {
        if (val && (typeof val === "object" || typeof val === "function")) {
          var then = val.then;
          if (typeof then === "function") {
            then.call(val, function(val) {
              res(i, val);
            }, reject);
            return;
          }
        }
        args[i] = val;
        if (--remaining === 0) {
          resolve(args);
        }
      } catch (ex) {
        reject(ex);
      }
    }
    for (var i = 0; i < args.length; i++) {
      res(i, args[i]);
    }
  });
};

Promise$2.allSettled = allSettled;

Promise$2.resolve = function(value) {
  if (value && typeof value === "object" && value.constructor === Promise$2) {
    return value;
  }
  return new Promise$2(function(resolve) {
    resolve(value);
  });
};

Promise$2.reject = function(value) {
  return new Promise$2(function(resolve, reject) {
    reject(value);
  });
};

Promise$2.race = function(arr) {
  return new Promise$2(function(resolve, reject) {
    if (!isArray(arr)) {
      return reject(new TypeError("Promise.race accepts an array"));
    }
    for (var i = 0, len = arr.length; i < len; i++) {
      Promise$2.resolve(arr[i]).then(resolve, reject);
    }
  });
};

Promise$2._immediateFn = typeof setImmediate === "function" && function(fn) {
  setImmediate(fn);
} || function(fn) {
  setTimeoutFunc(fn, 0);
};

Promise$2._unhandledRejectionFn = function _unhandledRejectionFn(err) {
  if (typeof console !== "undefined" && console) {
    console.warn("Possible Unhandled Promise Rejection:", err);
  }
};

var globalNS = function() {
  if (typeof self !== "undefined") {
    return self;
  }
  if (typeof window !== "undefined") {
    return window;
  }
  if (typeof global !== "undefined") {
    return global;
  }
  throw new Error("unable to locate global object");
}();

if (typeof globalNS["Promise"] !== "function") {
  globalNS["Promise"] = Promise$2;
} else if (!globalNS.Promise.prototype["finally"]) {
  globalNS.Promise.prototype["finally"] = finallyConstructor;
} else if (!globalNS.Promise.allSettled) {
  globalNS.Promise.allSettled = allSettled;
}

var global$1 = typeof globalThis !== "undefined" && globalThis || typeof self !== "undefined" && self || typeof global$1 !== "undefined" && global$1;

var support = {
  searchParams: "URLSearchParams" in global$1,
  iterable: "Symbol" in global$1 && "iterator" in Symbol,
  blob: "FileReader" in global$1 && "Blob" in global$1 && function() {
    try {
      new Blob();
      return true;
    } catch (e) {
      return false;
    }
  }(),
  formData: "FormData" in global$1,
  arrayBuffer: "ArrayBuffer" in global$1
};

function isDataView(obj) {
  return obj && DataView.prototype.isPrototypeOf(obj);
}

if (support.arrayBuffer) {
  var viewClasses = [ "[object Int8Array]", "[object Uint8Array]", "[object Uint8ClampedArray]", "[object Int16Array]", "[object Uint16Array]", "[object Int32Array]", "[object Uint32Array]", "[object Float32Array]", "[object Float64Array]" ];
  var isArrayBufferView = ArrayBuffer.isView || function(obj) {
    return obj && viewClasses.indexOf(Object.prototype.toString.call(obj)) > -1;
  };
}

function normalizeName(name) {
  if (typeof name !== "string") {
    name = String(name);
  }
  if (/[^a-z0-9\-#$%&'*+.^_`|~!]/i.test(name) || name === "") {
    throw new TypeError('Invalid character in header field name: "' + name + '"');
  }
  return name.toLowerCase();
}

function normalizeValue(value) {
  if (typeof value !== "string") {
    value = String(value);
  }
  return value;
}

function iteratorFor(items) {
  var iterator = {
    next: function() {
      var value = items.shift();
      return {
        done: value === undefined,
        value: value
      };
    }
  };
  if (support.iterable) {
    iterator[Symbol.iterator] = function() {
      return iterator;
    };
  }
  return iterator;
}

function Headers(headers) {
  this.map = {};
  if (headers instanceof Headers) {
    headers.forEach(function(value, name) {
      this.append(name, value);
    }, this);
  } else if (Array.isArray(headers)) {
    headers.forEach(function(header) {
      this.append(header[0], header[1]);
    }, this);
  } else if (headers) {
    Object.getOwnPropertyNames(headers).forEach(function(name) {
      this.append(name, headers[name]);
    }, this);
  }
}

Headers.prototype.append = function(name, value) {
  name = normalizeName(name);
  value = normalizeValue(value);
  var oldValue = this.map[name];
  this.map[name] = oldValue ? oldValue + ", " + value : value;
};

Headers.prototype["delete"] = function(name) {
  delete this.map[normalizeName(name)];
};

Headers.prototype.get = function(name) {
  name = normalizeName(name);
  return this.has(name) ? this.map[name] : null;
};

Headers.prototype.has = function(name) {
  return this.map.hasOwnProperty(normalizeName(name));
};

Headers.prototype.set = function(name, value) {
  this.map[normalizeName(name)] = normalizeValue(value);
};

Headers.prototype.forEach = function(callback, thisArg) {
  for (var name in this.map) {
    if (this.map.hasOwnProperty(name)) {
      callback.call(thisArg, this.map[name], name, this);
    }
  }
};

Headers.prototype.keys = function() {
  var items = [];
  this.forEach(function(value, name) {
    items.push(name);
  });
  return iteratorFor(items);
};

Headers.prototype.values = function() {
  var items = [];
  this.forEach(function(value) {
    items.push(value);
  });
  return iteratorFor(items);
};

Headers.prototype.entries = function() {
  var items = [];
  this.forEach(function(value, name) {
    items.push([ name, value ]);
  });
  return iteratorFor(items);
};

if (support.iterable) {
  Headers.prototype[Symbol.iterator] = Headers.prototype.entries;
}

function consumed(body) {
  if (body.bodyUsed) {
    return Promise.reject(new TypeError("Already read"));
  }
  body.bodyUsed = true;
}

function fileReaderReady(reader) {
  return new Promise(function(resolve, reject) {
    reader.onload = function() {
      resolve(reader.result);
    };
    reader.onerror = function() {
      reject(reader.error);
    };
  });
}

function readBlobAsArrayBuffer(blob) {
  var reader = new FileReader();
  var promise = fileReaderReady(reader);
  reader.readAsArrayBuffer(blob);
  return promise;
}

function readBlobAsText(blob) {
  var reader = new FileReader();
  var promise = fileReaderReady(reader);
  reader.readAsText(blob);
  return promise;
}

function readArrayBufferAsText(buf) {
  var view = new Uint8Array(buf);
  var chars = new Array(view.length);
  for (var i = 0; i < view.length; i++) {
    chars[i] = String.fromCharCode(view[i]);
  }
  return chars.join("");
}

function bufferClone(buf) {
  if (buf.slice) {
    return buf.slice(0);
  } else {
    var view = new Uint8Array(buf.byteLength);
    view.set(new Uint8Array(buf));
    return view.buffer;
  }
}

function Body() {
  this.bodyUsed = false;
  this._initBody = function(body) {
    this.bodyUsed = this.bodyUsed;
    this._bodyInit = body;
    if (!body) {
      this._bodyText = "";
    } else if (typeof body === "string") {
      this._bodyText = body;
    } else if (support.blob && Blob.prototype.isPrototypeOf(body)) {
      this._bodyBlob = body;
    } else if (support.formData && FormData.prototype.isPrototypeOf(body)) {
      this._bodyFormData = body;
    } else if (support.searchParams && URLSearchParams.prototype.isPrototypeOf(body)) {
      this._bodyText = body.toString();
    } else if (support.arrayBuffer && support.blob && isDataView(body)) {
      this._bodyArrayBuffer = bufferClone(body.buffer);
      this._bodyInit = new Blob([ this._bodyArrayBuffer ]);
    } else if (support.arrayBuffer && (ArrayBuffer.prototype.isPrototypeOf(body) || isArrayBufferView(body))) {
      this._bodyArrayBuffer = bufferClone(body);
    } else {
      this._bodyText = body = Object.prototype.toString.call(body);
    }
    if (!this.headers.get("content-type")) {
      if (typeof body === "string") {
        this.headers.set("content-type", "text/plain;charset=UTF-8");
      } else if (this._bodyBlob && this._bodyBlob.type) {
        this.headers.set("content-type", this._bodyBlob.type);
      } else if (support.searchParams && URLSearchParams.prototype.isPrototypeOf(body)) {
        this.headers.set("content-type", "application/x-www-form-urlencoded;charset=UTF-8");
      }
    }
  };
  if (support.blob) {
    this.blob = function() {
      var rejected = consumed(this);
      if (rejected) {
        return rejected;
      }
      if (this._bodyBlob) {
        return Promise.resolve(this._bodyBlob);
      } else if (this._bodyArrayBuffer) {
        return Promise.resolve(new Blob([ this._bodyArrayBuffer ]));
      } else if (this._bodyFormData) {
        throw new Error("could not read FormData body as blob");
      } else {
        return Promise.resolve(new Blob([ this._bodyText ]));
      }
    };
    this.arrayBuffer = function() {
      if (this._bodyArrayBuffer) {
        var isConsumed = consumed(this);
        if (isConsumed) {
          return isConsumed;
        }
        if (ArrayBuffer.isView(this._bodyArrayBuffer)) {
          return Promise.resolve(this._bodyArrayBuffer.buffer.slice(this._bodyArrayBuffer.byteOffset, this._bodyArrayBuffer.byteOffset + this._bodyArrayBuffer.byteLength));
        } else {
          return Promise.resolve(this._bodyArrayBuffer);
        }
      } else {
        return this.blob().then(readBlobAsArrayBuffer);
      }
    };
  }
  this.text = function() {
    var rejected = consumed(this);
    if (rejected) {
      return rejected;
    }
    if (this._bodyBlob) {
      return readBlobAsText(this._bodyBlob);
    } else if (this._bodyArrayBuffer) {
      return Promise.resolve(readArrayBufferAsText(this._bodyArrayBuffer));
    } else if (this._bodyFormData) {
      throw new Error("could not read FormData body as text");
    } else {
      return Promise.resolve(this._bodyText);
    }
  };
  if (support.formData) {
    this.formData = function() {
      return this.text().then(decode);
    };
  }
  this.json = function() {
    return this.text().then(JSON.parse);
  };
  return this;
}

var methods = [ "DELETE", "GET", "HEAD", "OPTIONS", "POST", "PUT" ];

function normalizeMethod(method) {
  var upcased = method.toUpperCase();
  return methods.indexOf(upcased) > -1 ? upcased : method;
}

function Request(input, options) {
  if (!(this instanceof Request)) {
    throw new TypeError('Please use the "new" operator, this DOM object constructor cannot be called as a function.');
  }
  options = options || {};
  var body = options.body;
  if (input instanceof Request) {
    if (input.bodyUsed) {
      throw new TypeError("Already read");
    }
    this.url = input.url;
    this.credentials = input.credentials;
    if (!options.headers) {
      this.headers = new Headers(input.headers);
    }
    this.method = input.method;
    this.mode = input.mode;
    this.signal = input.signal;
    if (!body && input._bodyInit != null) {
      body = input._bodyInit;
      input.bodyUsed = true;
    }
  } else {
    this.url = String(input);
  }
  this.credentials = options.credentials || this.credentials || "same-origin";
  if (options.headers || !this.headers) {
    this.headers = new Headers(options.headers);
  }
  this.method = normalizeMethod(options.method || this.method || "GET");
  this.mode = options.mode || this.mode || null;
  this.signal = options.signal || this.signal;
  this.referrer = null;
  if ((this.method === "GET" || this.method === "HEAD") && body) {
    throw new TypeError("Body not allowed for GET or HEAD requests");
  }
  this._initBody(body);
  if (this.method === "GET" || this.method === "HEAD") {
    if (options.cache === "no-store" || options.cache === "no-cache") {
      var reParamSearch = /([?&])_=[^&]*/;
      if (reParamSearch.test(this.url)) {
        this.url = this.url.replace(reParamSearch, "$1_=" + new Date().getTime());
      } else {
        var reQueryString = /\?/;
        this.url += (reQueryString.test(this.url) ? "&" : "?") + "_=" + new Date().getTime();
      }
    }
  }
}

Request.prototype.clone = function() {
  return new Request(this, {
    body: this._bodyInit
  });
};

function decode(body) {
  var form = new FormData();
  body.trim().split("&").forEach(function(bytes) {
    if (bytes) {
      var split = bytes.split("=");
      var name = split.shift().replace(/\+/g, " ");
      var value = split.join("=").replace(/\+/g, " ");
      form.append(decodeURIComponent(name), decodeURIComponent(value));
    }
  });
  return form;
}

function parseHeaders(rawHeaders) {
  var headers = new Headers();
  var preProcessedHeaders = rawHeaders.replace(/\r?\n[\t ]+/g, " ");
  preProcessedHeaders.split("\r").map(function(header) {
    return header.indexOf("\n") === 0 ? header.substr(1, header.length) : header;
  }).forEach(function(line) {
    var parts = line.split(":");
    var key = parts.shift().trim();
    if (key) {
      var value = parts.join(":").trim();
      headers.append(key, value);
    }
  });
  return headers;
}

Body.call(Request.prototype);

function Response(bodyInit, options) {
  if (!(this instanceof Response)) {
    throw new TypeError('Please use the "new" operator, this DOM object constructor cannot be called as a function.');
  }
  if (!options) {
    options = {};
  }
  this.type = "default";
  this.status = options.status === undefined ? 200 : options.status;
  this.ok = this.status >= 200 && this.status < 300;
  this.statusText = options.statusText === undefined ? "" : "" + options.statusText;
  this.headers = new Headers(options.headers);
  this.url = options.url || "";
  this._initBody(bodyInit);
}

Body.call(Response.prototype);

Response.prototype.clone = function() {
  return new Response(this._bodyInit, {
    status: this.status,
    statusText: this.statusText,
    headers: new Headers(this.headers),
    url: this.url
  });
};

Response.error = function() {
  var response = new Response(null, {
    status: 0,
    statusText: ""
  });
  response.type = "error";
  return response;
};

var redirectStatuses = [ 301, 302, 303, 307, 308 ];

Response.redirect = function(url, status) {
  if (redirectStatuses.indexOf(status) === -1) {
    throw new RangeError("Invalid status code");
  }
  return new Response(null, {
    status: status,
    headers: {
      location: url
    }
  });
};

var DOMException = global$1.DOMException;

try {
  new DOMException();
} catch (err) {
  DOMException = function(message, name) {
    this.message = message;
    this.name = name;
    var error = Error(message);
    this.stack = error.stack;
  };
  DOMException.prototype = Object.create(Error.prototype);
  DOMException.prototype.constructor = DOMException;
}

function fetch$1(input, init) {
  return new Promise(function(resolve, reject) {
    var request = new Request(input, init);
    if (request.signal && request.signal.aborted) {
      return reject(new DOMException("Aborted", "AbortError"));
    }
    var xhr = new XMLHttpRequest();
    function abortXhr() {
      xhr.abort();
    }
    xhr.onload = function() {
      var options = {
        status: xhr.status,
        statusText: xhr.statusText,
        headers: parseHeaders(xhr.getAllResponseHeaders() || "")
      };
      options.url = "responseURL" in xhr ? xhr.responseURL : options.headers.get("X-Request-URL");
      var body = "response" in xhr ? xhr.response : xhr.responseText;
      setTimeout(function() {
        resolve(new Response(body, options));
      }, 0);
    };
    xhr.onerror = function() {
      setTimeout(function() {
        reject(new TypeError("Network request failed"));
      }, 0);
    };
    xhr.ontimeout = function() {
      setTimeout(function() {
        reject(new TypeError("Network request failed"));
      }, 0);
    };
    xhr.onabort = function() {
      setTimeout(function() {
        reject(new DOMException("Aborted", "AbortError"));
      }, 0);
    };
    function fixUrl(url) {
      try {
        return url === "" && global$1.location.href ? global$1.location.href : url;
      } catch (e) {
        return url;
      }
    }
    xhr.open(request.method, fixUrl(request.url), true);
    if (request.credentials === "include") {
      xhr.withCredentials = true;
    } else if (request.credentials === "omit") {
      xhr.withCredentials = false;
    }
    if ("responseType" in xhr) {
      if (support.blob) {
        xhr.responseType = "blob";
      } else if (support.arrayBuffer && request.headers.get("Content-Type") && request.headers.get("Content-Type").indexOf("application/octet-stream") !== -1) {
        xhr.responseType = "arraybuffer";
      }
    }
    if (init && typeof init.headers === "object" && !(init.headers instanceof Headers)) {
      Object.getOwnPropertyNames(init.headers).forEach(function(name) {
        xhr.setRequestHeader(name, normalizeValue(init.headers[name]));
      });
    } else {
      request.headers.forEach(function(value, name) {
        xhr.setRequestHeader(name, value);
      });
    }
    if (request.signal) {
      request.signal.addEventListener("abort", abortXhr);
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          request.signal.removeEventListener("abort", abortXhr);
        }
      };
    }
    xhr.send(typeof request._bodyInit === "undefined" ? null : request._bodyInit);
  });
}

fetch$1.polyfill = true;

if (!global$1.fetch) {
  global$1.fetch = fetch$1;
  global$1.Headers = Headers;
  global$1.Request = Request;
  global$1.Response = Response;
}

var EventListener = function() {
  function EventListener(eventTarget, eventName, eventOptions) {
    this.eventTarget = eventTarget;
    this.eventName = eventName;
    this.eventOptions = eventOptions;
    this.unorderedBindings = new Set();
  }
  EventListener.prototype.connect = function() {
    this.eventTarget.addEventListener(this.eventName, this, this.eventOptions);
  };
  EventListener.prototype.disconnect = function() {
    this.eventTarget.removeEventListener(this.eventName, this, this.eventOptions);
  };
  EventListener.prototype.bindingConnected = function(binding) {
    this.unorderedBindings.add(binding);
  };
  EventListener.prototype.bindingDisconnected = function(binding) {
    this.unorderedBindings.delete(binding);
  };
  EventListener.prototype.handleEvent = function(event) {
    var extendedEvent = extendEvent(event);
    for (var _i = 0, _a = this.bindings; _i < _a.length; _i++) {
      var binding = _a[_i];
      if (extendedEvent.immediatePropagationStopped) {
        break;
      } else {
        binding.handleEvent(extendedEvent);
      }
    }
  };
  Object.defineProperty(EventListener.prototype, "bindings", {
    get: function() {
      return Array.from(this.unorderedBindings).sort(function(left, right) {
        var leftIndex = left.index, rightIndex = right.index;
        return leftIndex < rightIndex ? -1 : leftIndex > rightIndex ? 1 : 0;
      });
    },
    enumerable: false,
    configurable: true
  });
  return EventListener;
}();

function extendEvent(event) {
  if ("immediatePropagationStopped" in event) {
    return event;
  } else {
    var stopImmediatePropagation_1 = event.stopImmediatePropagation;
    return Object.assign(event, {
      immediatePropagationStopped: false,
      stopImmediatePropagation: function() {
        this.immediatePropagationStopped = true;
        stopImmediatePropagation_1.call(this);
      }
    });
  }
}

var Dispatcher = function() {
  function Dispatcher(application) {
    this.application = application;
    this.eventListenerMaps = new Map();
    this.started = false;
  }
  Dispatcher.prototype.start = function() {
    if (!this.started) {
      this.started = true;
      this.eventListeners.forEach(function(eventListener) {
        return eventListener.connect();
      });
    }
  };
  Dispatcher.prototype.stop = function() {
    if (this.started) {
      this.started = false;
      this.eventListeners.forEach(function(eventListener) {
        return eventListener.disconnect();
      });
    }
  };
  Object.defineProperty(Dispatcher.prototype, "eventListeners", {
    get: function() {
      return Array.from(this.eventListenerMaps.values()).reduce(function(listeners, map) {
        return listeners.concat(Array.from(map.values()));
      }, []);
    },
    enumerable: false,
    configurable: true
  });
  Dispatcher.prototype.bindingConnected = function(binding) {
    this.fetchEventListenerForBinding(binding).bindingConnected(binding);
  };
  Dispatcher.prototype.bindingDisconnected = function(binding) {
    this.fetchEventListenerForBinding(binding).bindingDisconnected(binding);
  };
  Dispatcher.prototype.handleError = function(error, message, detail) {
    if (detail === void 0) {
      detail = {};
    }
    this.application.handleError(error, "Error " + message, detail);
  };
  Dispatcher.prototype.fetchEventListenerForBinding = function(binding) {
    var eventTarget = binding.eventTarget, eventName = binding.eventName, eventOptions = binding.eventOptions;
    return this.fetchEventListener(eventTarget, eventName, eventOptions);
  };
  Dispatcher.prototype.fetchEventListener = function(eventTarget, eventName, eventOptions) {
    var eventListenerMap = this.fetchEventListenerMapForEventTarget(eventTarget);
    var cacheKey = this.cacheKey(eventName, eventOptions);
    var eventListener = eventListenerMap.get(cacheKey);
    if (!eventListener) {
      eventListener = this.createEventListener(eventTarget, eventName, eventOptions);
      eventListenerMap.set(cacheKey, eventListener);
    }
    return eventListener;
  };
  Dispatcher.prototype.createEventListener = function(eventTarget, eventName, eventOptions) {
    var eventListener = new EventListener(eventTarget, eventName, eventOptions);
    if (this.started) {
      eventListener.connect();
    }
    return eventListener;
  };
  Dispatcher.prototype.fetchEventListenerMapForEventTarget = function(eventTarget) {
    var eventListenerMap = this.eventListenerMaps.get(eventTarget);
    if (!eventListenerMap) {
      eventListenerMap = new Map();
      this.eventListenerMaps.set(eventTarget, eventListenerMap);
    }
    return eventListenerMap;
  };
  Dispatcher.prototype.cacheKey = function(eventName, eventOptions) {
    var parts = [ eventName ];
    Object.keys(eventOptions).sort().forEach(function(key) {
      parts.push("" + (eventOptions[key] ? "" : "!") + key);
    });
    return parts.join(":");
  };
  return Dispatcher;
}();

var descriptorPattern = /^((.+?)(@(window|document))?->)?(.+?)(#([^:]+?))(:(.+))?$/;

function parseActionDescriptorString(descriptorString) {
  var source = descriptorString.trim();
  var matches = source.match(descriptorPattern) || [];
  return {
    eventTarget: parseEventTarget(matches[4]),
    eventName: matches[2],
    eventOptions: matches[9] ? parseEventOptions(matches[9]) : {},
    identifier: matches[5],
    methodName: matches[7]
  };
}

function parseEventTarget(eventTargetName) {
  if (eventTargetName == "window") {
    return window;
  } else if (eventTargetName == "document") {
    return document;
  }
}

function parseEventOptions(eventOptions) {
  return eventOptions.split(":").reduce(function(options, token) {
    var _a;
    return Object.assign(options, (_a = {}, _a[token.replace(/^!/, "")] = !/^!/.test(token), 
    _a));
  }, {});
}

function stringifyEventTarget(eventTarget) {
  if (eventTarget == window) {
    return "window";
  } else if (eventTarget == document) {
    return "document";
  }
}

var Action = function() {
  function Action(element, index, descriptor) {
    this.element = element;
    this.index = index;
    this.eventTarget = descriptor.eventTarget || element;
    this.eventName = descriptor.eventName || getDefaultEventNameForElement(element) || error("missing event name");
    this.eventOptions = descriptor.eventOptions || {};
    this.identifier = descriptor.identifier || error("missing identifier");
    this.methodName = descriptor.methodName || error("missing method name");
  }
  Action.forToken = function(token) {
    return new this(token.element, token.index, parseActionDescriptorString(token.content));
  };
  Action.prototype.toString = function() {
    var eventNameSuffix = this.eventTargetName ? "@" + this.eventTargetName : "";
    return "" + this.eventName + eventNameSuffix + "->" + this.identifier + "#" + this.methodName;
  };
  Object.defineProperty(Action.prototype, "eventTargetName", {
    get: function() {
      return stringifyEventTarget(this.eventTarget);
    },
    enumerable: false,
    configurable: true
  });
  return Action;
}();

var defaultEventNames = {
  a: function(e) {
    return "click";
  },
  button: function(e) {
    return "click";
  },
  form: function(e) {
    return "submit";
  },
  input: function(e) {
    return e.getAttribute("type") == "submit" ? "click" : "input";
  },
  select: function(e) {
    return "change";
  },
  textarea: function(e) {
    return "input";
  }
};

function getDefaultEventNameForElement(element) {
  var tagName = element.tagName.toLowerCase();
  if (tagName in defaultEventNames) {
    return defaultEventNames[tagName](element);
  }
}

function error(message) {
  throw new Error(message);
}

var Binding = function() {
  function Binding(context, action) {
    this.context = context;
    this.action = action;
  }
  Object.defineProperty(Binding.prototype, "index", {
    get: function() {
      return this.action.index;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "eventTarget", {
    get: function() {
      return this.action.eventTarget;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "eventOptions", {
    get: function() {
      return this.action.eventOptions;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "identifier", {
    get: function() {
      return this.context.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Binding.prototype.handleEvent = function(event) {
    if (this.willBeInvokedByEvent(event)) {
      this.invokeWithEvent(event);
    }
  };
  Object.defineProperty(Binding.prototype, "eventName", {
    get: function() {
      return this.action.eventName;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "method", {
    get: function() {
      var method = this.controller[this.methodName];
      if (typeof method == "function") {
        return method;
      }
      throw new Error('Action "' + this.action + '" references undefined method "' + this.methodName + '"');
    },
    enumerable: false,
    configurable: true
  });
  Binding.prototype.invokeWithEvent = function(event) {
    try {
      this.method.call(this.controller, event);
    } catch (error) {
      var _a = this, identifier = _a.identifier, controller = _a.controller, element = _a.element, index = _a.index;
      var detail = {
        identifier: identifier,
        controller: controller,
        element: element,
        index: index,
        event: event
      };
      this.context.handleError(error, 'invoking action "' + this.action + '"', detail);
    }
  };
  Binding.prototype.willBeInvokedByEvent = function(event) {
    var eventTarget = event.target;
    if (this.element === eventTarget) {
      return true;
    } else if (eventTarget instanceof Element && this.element.contains(eventTarget)) {
      return this.scope.containsElement(eventTarget);
    } else {
      return this.scope.containsElement(this.action.element);
    }
  };
  Object.defineProperty(Binding.prototype, "controller", {
    get: function() {
      return this.context.controller;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "methodName", {
    get: function() {
      return this.action.methodName;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "scope", {
    get: function() {
      return this.context.scope;
    },
    enumerable: false,
    configurable: true
  });
  return Binding;
}();

var ElementObserver = function() {
  function ElementObserver(element, delegate) {
    var _this = this;
    this.element = element;
    this.started = false;
    this.delegate = delegate;
    this.elements = new Set();
    this.mutationObserver = new MutationObserver(function(mutations) {
      return _this.processMutations(mutations);
    });
  }
  ElementObserver.prototype.start = function() {
    if (!this.started) {
      this.started = true;
      this.mutationObserver.observe(this.element, {
        attributes: true,
        childList: true,
        subtree: true
      });
      this.refresh();
    }
  };
  ElementObserver.prototype.stop = function() {
    if (this.started) {
      this.mutationObserver.takeRecords();
      this.mutationObserver.disconnect();
      this.started = false;
    }
  };
  ElementObserver.prototype.refresh = function() {
    if (this.started) {
      var matches = new Set(this.matchElementsInTree());
      for (var _i = 0, _a = Array.from(this.elements); _i < _a.length; _i++) {
        var element = _a[_i];
        if (!matches.has(element)) {
          this.removeElement(element);
        }
      }
      for (var _b = 0, _c = Array.from(matches); _b < _c.length; _b++) {
        var element = _c[_b];
        this.addElement(element);
      }
    }
  };
  ElementObserver.prototype.processMutations = function(mutations) {
    if (this.started) {
      for (var _i = 0, mutations_1 = mutations; _i < mutations_1.length; _i++) {
        var mutation = mutations_1[_i];
        this.processMutation(mutation);
      }
    }
  };
  ElementObserver.prototype.processMutation = function(mutation) {
    if (mutation.type == "attributes") {
      this.processAttributeChange(mutation.target, mutation.attributeName);
    } else if (mutation.type == "childList") {
      this.processRemovedNodes(mutation.removedNodes);
      this.processAddedNodes(mutation.addedNodes);
    }
  };
  ElementObserver.prototype.processAttributeChange = function(node, attributeName) {
    var element = node;
    if (this.elements.has(element)) {
      if (this.delegate.elementAttributeChanged && this.matchElement(element)) {
        this.delegate.elementAttributeChanged(element, attributeName);
      } else {
        this.removeElement(element);
      }
    } else if (this.matchElement(element)) {
      this.addElement(element);
    }
  };
  ElementObserver.prototype.processRemovedNodes = function(nodes) {
    for (var _i = 0, _a = Array.from(nodes); _i < _a.length; _i++) {
      var node = _a[_i];
      var element = this.elementFromNode(node);
      if (element) {
        this.processTree(element, this.removeElement);
      }
    }
  };
  ElementObserver.prototype.processAddedNodes = function(nodes) {
    for (var _i = 0, _a = Array.from(nodes); _i < _a.length; _i++) {
      var node = _a[_i];
      var element = this.elementFromNode(node);
      if (element && this.elementIsActive(element)) {
        this.processTree(element, this.addElement);
      }
    }
  };
  ElementObserver.prototype.matchElement = function(element) {
    return this.delegate.matchElement(element);
  };
  ElementObserver.prototype.matchElementsInTree = function(tree) {
    if (tree === void 0) {
      tree = this.element;
    }
    return this.delegate.matchElementsInTree(tree);
  };
  ElementObserver.prototype.processTree = function(tree, processor) {
    for (var _i = 0, _a = this.matchElementsInTree(tree); _i < _a.length; _i++) {
      var element = _a[_i];
      processor.call(this, element);
    }
  };
  ElementObserver.prototype.elementFromNode = function(node) {
    if (node.nodeType == Node.ELEMENT_NODE) {
      return node;
    }
  };
  ElementObserver.prototype.elementIsActive = function(element) {
    if (element.isConnected != this.element.isConnected) {
      return false;
    } else {
      return this.element.contains(element);
    }
  };
  ElementObserver.prototype.addElement = function(element) {
    if (!this.elements.has(element)) {
      if (this.elementIsActive(element)) {
        this.elements.add(element);
        if (this.delegate.elementMatched) {
          this.delegate.elementMatched(element);
        }
      }
    }
  };
  ElementObserver.prototype.removeElement = function(element) {
    if (this.elements.has(element)) {
      this.elements.delete(element);
      if (this.delegate.elementUnmatched) {
        this.delegate.elementUnmatched(element);
      }
    }
  };
  return ElementObserver;
}();

var AttributeObserver = function() {
  function AttributeObserver(element, attributeName, delegate) {
    this.attributeName = attributeName;
    this.delegate = delegate;
    this.elementObserver = new ElementObserver(element, this);
  }
  Object.defineProperty(AttributeObserver.prototype, "element", {
    get: function() {
      return this.elementObserver.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(AttributeObserver.prototype, "selector", {
    get: function() {
      return "[" + this.attributeName + "]";
    },
    enumerable: false,
    configurable: true
  });
  AttributeObserver.prototype.start = function() {
    this.elementObserver.start();
  };
  AttributeObserver.prototype.stop = function() {
    this.elementObserver.stop();
  };
  AttributeObserver.prototype.refresh = function() {
    this.elementObserver.refresh();
  };
  Object.defineProperty(AttributeObserver.prototype, "started", {
    get: function() {
      return this.elementObserver.started;
    },
    enumerable: false,
    configurable: true
  });
  AttributeObserver.prototype.matchElement = function(element) {
    return element.hasAttribute(this.attributeName);
  };
  AttributeObserver.prototype.matchElementsInTree = function(tree) {
    var match = this.matchElement(tree) ? [ tree ] : [];
    var matches = Array.from(tree.querySelectorAll(this.selector));
    return match.concat(matches);
  };
  AttributeObserver.prototype.elementMatched = function(element) {
    if (this.delegate.elementMatchedAttribute) {
      this.delegate.elementMatchedAttribute(element, this.attributeName);
    }
  };
  AttributeObserver.prototype.elementUnmatched = function(element) {
    if (this.delegate.elementUnmatchedAttribute) {
      this.delegate.elementUnmatchedAttribute(element, this.attributeName);
    }
  };
  AttributeObserver.prototype.elementAttributeChanged = function(element, attributeName) {
    if (this.delegate.elementAttributeValueChanged && this.attributeName == attributeName) {
      this.delegate.elementAttributeValueChanged(element, attributeName);
    }
  };
  return AttributeObserver;
}();

var StringMapObserver = function() {
  function StringMapObserver(element, delegate) {
    var _this = this;
    this.element = element;
    this.delegate = delegate;
    this.started = false;
    this.stringMap = new Map();
    this.mutationObserver = new MutationObserver(function(mutations) {
      return _this.processMutations(mutations);
    });
  }
  StringMapObserver.prototype.start = function() {
    if (!this.started) {
      this.started = true;
      this.mutationObserver.observe(this.element, {
        attributes: true
      });
      this.refresh();
    }
  };
  StringMapObserver.prototype.stop = function() {
    if (this.started) {
      this.mutationObserver.takeRecords();
      this.mutationObserver.disconnect();
      this.started = false;
    }
  };
  StringMapObserver.prototype.refresh = function() {
    if (this.started) {
      for (var _i = 0, _a = this.knownAttributeNames; _i < _a.length; _i++) {
        var attributeName = _a[_i];
        this.refreshAttribute(attributeName);
      }
    }
  };
  StringMapObserver.prototype.processMutations = function(mutations) {
    if (this.started) {
      for (var _i = 0, mutations_1 = mutations; _i < mutations_1.length; _i++) {
        var mutation = mutations_1[_i];
        this.processMutation(mutation);
      }
    }
  };
  StringMapObserver.prototype.processMutation = function(mutation) {
    var attributeName = mutation.attributeName;
    if (attributeName) {
      this.refreshAttribute(attributeName);
    }
  };
  StringMapObserver.prototype.refreshAttribute = function(attributeName) {
    var key = this.delegate.getStringMapKeyForAttribute(attributeName);
    if (key != null) {
      if (!this.stringMap.has(attributeName)) {
        this.stringMapKeyAdded(key, attributeName);
      }
      var value = this.element.getAttribute(attributeName);
      if (this.stringMap.get(attributeName) != value) {
        this.stringMapValueChanged(value, key);
      }
      if (value == null) {
        this.stringMap.delete(attributeName);
        this.stringMapKeyRemoved(key, attributeName);
      } else {
        this.stringMap.set(attributeName, value);
      }
    }
  };
  StringMapObserver.prototype.stringMapKeyAdded = function(key, attributeName) {
    if (this.delegate.stringMapKeyAdded) {
      this.delegate.stringMapKeyAdded(key, attributeName);
    }
  };
  StringMapObserver.prototype.stringMapValueChanged = function(value, key) {
    if (this.delegate.stringMapValueChanged) {
      this.delegate.stringMapValueChanged(value, key);
    }
  };
  StringMapObserver.prototype.stringMapKeyRemoved = function(key, attributeName) {
    if (this.delegate.stringMapKeyRemoved) {
      this.delegate.stringMapKeyRemoved(key, attributeName);
    }
  };
  Object.defineProperty(StringMapObserver.prototype, "knownAttributeNames", {
    get: function() {
      return Array.from(new Set(this.currentAttributeNames.concat(this.recordedAttributeNames)));
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(StringMapObserver.prototype, "currentAttributeNames", {
    get: function() {
      return Array.from(this.element.attributes).map(function(attribute) {
        return attribute.name;
      });
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(StringMapObserver.prototype, "recordedAttributeNames", {
    get: function() {
      return Array.from(this.stringMap.keys());
    },
    enumerable: false,
    configurable: true
  });
  return StringMapObserver;
}();

function add(map, key, value) {
  fetch$2(map, key).add(value);
}

function del(map, key, value) {
  fetch$2(map, key).delete(value);
  prune(map, key);
}

function fetch$2(map, key) {
  var values = map.get(key);
  if (!values) {
    values = new Set();
    map.set(key, values);
  }
  return values;
}

function prune(map, key) {
  var values = map.get(key);
  if (values != null && values.size == 0) {
    map.delete(key);
  }
}

var Multimap = function() {
  function Multimap() {
    this.valuesByKey = new Map();
  }
  Object.defineProperty(Multimap.prototype, "values", {
    get: function() {
      var sets = Array.from(this.valuesByKey.values());
      return sets.reduce(function(values, set) {
        return values.concat(Array.from(set));
      }, []);
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Multimap.prototype, "size", {
    get: function() {
      var sets = Array.from(this.valuesByKey.values());
      return sets.reduce(function(size, set) {
        return size + set.size;
      }, 0);
    },
    enumerable: false,
    configurable: true
  });
  Multimap.prototype.add = function(key, value) {
    add(this.valuesByKey, key, value);
  };
  Multimap.prototype.delete = function(key, value) {
    del(this.valuesByKey, key, value);
  };
  Multimap.prototype.has = function(key, value) {
    var values = this.valuesByKey.get(key);
    return values != null && values.has(value);
  };
  Multimap.prototype.hasKey = function(key) {
    return this.valuesByKey.has(key);
  };
  Multimap.prototype.hasValue = function(value) {
    var sets = Array.from(this.valuesByKey.values());
    return sets.some(function(set) {
      return set.has(value);
    });
  };
  Multimap.prototype.getValuesForKey = function(key) {
    var values = this.valuesByKey.get(key);
    return values ? Array.from(values) : [];
  };
  Multimap.prototype.getKeysForValue = function(value) {
    return Array.from(this.valuesByKey).filter(function(_a) {
      var key = _a[0], values = _a[1];
      return values.has(value);
    }).map(function(_a) {
      var key = _a[0], values = _a[1];
      return key;
    });
  };
  return Multimap;
}();

var __extends = window && window.__extends || function() {
  var extendStatics = function(d, b) {
    extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function(d, b) {
      d.__proto__ = b;
    } || function(d, b) {
      for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    };
    return extendStatics(d, b);
  };
  return function(d, b) {
    extendStatics(d, b);
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var IndexedMultimap = function(_super) {
  __extends(IndexedMultimap, _super);
  function IndexedMultimap() {
    var _this = _super.call(this) || this;
    _this.keysByValue = new Map();
    return _this;
  }
  Object.defineProperty(IndexedMultimap.prototype, "values", {
    get: function() {
      return Array.from(this.keysByValue.keys());
    },
    enumerable: false,
    configurable: true
  });
  IndexedMultimap.prototype.add = function(key, value) {
    _super.prototype.add.call(this, key, value);
    add(this.keysByValue, value, key);
  };
  IndexedMultimap.prototype.delete = function(key, value) {
    _super.prototype.delete.call(this, key, value);
    del(this.keysByValue, value, key);
  };
  IndexedMultimap.prototype.hasValue = function(value) {
    return this.keysByValue.has(value);
  };
  IndexedMultimap.prototype.getKeysForValue = function(value) {
    var set = this.keysByValue.get(value);
    return set ? Array.from(set) : [];
  };
  return IndexedMultimap;
}(Multimap);

var TokenListObserver = function() {
  function TokenListObserver(element, attributeName, delegate) {
    this.attributeObserver = new AttributeObserver(element, attributeName, this);
    this.delegate = delegate;
    this.tokensByElement = new Multimap();
  }
  Object.defineProperty(TokenListObserver.prototype, "started", {
    get: function() {
      return this.attributeObserver.started;
    },
    enumerable: false,
    configurable: true
  });
  TokenListObserver.prototype.start = function() {
    this.attributeObserver.start();
  };
  TokenListObserver.prototype.stop = function() {
    this.attributeObserver.stop();
  };
  TokenListObserver.prototype.refresh = function() {
    this.attributeObserver.refresh();
  };
  Object.defineProperty(TokenListObserver.prototype, "element", {
    get: function() {
      return this.attributeObserver.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(TokenListObserver.prototype, "attributeName", {
    get: function() {
      return this.attributeObserver.attributeName;
    },
    enumerable: false,
    configurable: true
  });
  TokenListObserver.prototype.elementMatchedAttribute = function(element) {
    this.tokensMatched(this.readTokensForElement(element));
  };
  TokenListObserver.prototype.elementAttributeValueChanged = function(element) {
    var _a = this.refreshTokensForElement(element), unmatchedTokens = _a[0], matchedTokens = _a[1];
    this.tokensUnmatched(unmatchedTokens);
    this.tokensMatched(matchedTokens);
  };
  TokenListObserver.prototype.elementUnmatchedAttribute = function(element) {
    this.tokensUnmatched(this.tokensByElement.getValuesForKey(element));
  };
  TokenListObserver.prototype.tokensMatched = function(tokens) {
    var _this = this;
    tokens.forEach(function(token) {
      return _this.tokenMatched(token);
    });
  };
  TokenListObserver.prototype.tokensUnmatched = function(tokens) {
    var _this = this;
    tokens.forEach(function(token) {
      return _this.tokenUnmatched(token);
    });
  };
  TokenListObserver.prototype.tokenMatched = function(token) {
    this.delegate.tokenMatched(token);
    this.tokensByElement.add(token.element, token);
  };
  TokenListObserver.prototype.tokenUnmatched = function(token) {
    this.delegate.tokenUnmatched(token);
    this.tokensByElement.delete(token.element, token);
  };
  TokenListObserver.prototype.refreshTokensForElement = function(element) {
    var previousTokens = this.tokensByElement.getValuesForKey(element);
    var currentTokens = this.readTokensForElement(element);
    var firstDifferingIndex = zip(previousTokens, currentTokens).findIndex(function(_a) {
      var previousToken = _a[0], currentToken = _a[1];
      return !tokensAreEqual(previousToken, currentToken);
    });
    if (firstDifferingIndex == -1) {
      return [ [], [] ];
    } else {
      return [ previousTokens.slice(firstDifferingIndex), currentTokens.slice(firstDifferingIndex) ];
    }
  };
  TokenListObserver.prototype.readTokensForElement = function(element) {
    var attributeName = this.attributeName;
    var tokenString = element.getAttribute(attributeName) || "";
    return parseTokenString(tokenString, element, attributeName);
  };
  return TokenListObserver;
}();

function parseTokenString(tokenString, element, attributeName) {
  return tokenString.trim().split(/\s+/).filter(function(content) {
    return content.length;
  }).map(function(content, index) {
    return {
      element: element,
      attributeName: attributeName,
      content: content,
      index: index
    };
  });
}

function zip(left, right) {
  var length = Math.max(left.length, right.length);
  return Array.from({
    length: length
  }, function(_, index) {
    return [ left[index], right[index] ];
  });
}

function tokensAreEqual(left, right) {
  return left && right && left.index == right.index && left.content == right.content;
}

var ValueListObserver = function() {
  function ValueListObserver(element, attributeName, delegate) {
    this.tokenListObserver = new TokenListObserver(element, attributeName, this);
    this.delegate = delegate;
    this.parseResultsByToken = new WeakMap();
    this.valuesByTokenByElement = new WeakMap();
  }
  Object.defineProperty(ValueListObserver.prototype, "started", {
    get: function() {
      return this.tokenListObserver.started;
    },
    enumerable: false,
    configurable: true
  });
  ValueListObserver.prototype.start = function() {
    this.tokenListObserver.start();
  };
  ValueListObserver.prototype.stop = function() {
    this.tokenListObserver.stop();
  };
  ValueListObserver.prototype.refresh = function() {
    this.tokenListObserver.refresh();
  };
  Object.defineProperty(ValueListObserver.prototype, "element", {
    get: function() {
      return this.tokenListObserver.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(ValueListObserver.prototype, "attributeName", {
    get: function() {
      return this.tokenListObserver.attributeName;
    },
    enumerable: false,
    configurable: true
  });
  ValueListObserver.prototype.tokenMatched = function(token) {
    var element = token.element;
    var value = this.fetchParseResultForToken(token).value;
    if (value) {
      this.fetchValuesByTokenForElement(element).set(token, value);
      this.delegate.elementMatchedValue(element, value);
    }
  };
  ValueListObserver.prototype.tokenUnmatched = function(token) {
    var element = token.element;
    var value = this.fetchParseResultForToken(token).value;
    if (value) {
      this.fetchValuesByTokenForElement(element).delete(token);
      this.delegate.elementUnmatchedValue(element, value);
    }
  };
  ValueListObserver.prototype.fetchParseResultForToken = function(token) {
    var parseResult = this.parseResultsByToken.get(token);
    if (!parseResult) {
      parseResult = this.parseToken(token);
      this.parseResultsByToken.set(token, parseResult);
    }
    return parseResult;
  };
  ValueListObserver.prototype.fetchValuesByTokenForElement = function(element) {
    var valuesByToken = this.valuesByTokenByElement.get(element);
    if (!valuesByToken) {
      valuesByToken = new Map();
      this.valuesByTokenByElement.set(element, valuesByToken);
    }
    return valuesByToken;
  };
  ValueListObserver.prototype.parseToken = function(token) {
    try {
      var value = this.delegate.parseValueForToken(token);
      return {
        value: value
      };
    } catch (error) {
      return {
        error: error
      };
    }
  };
  return ValueListObserver;
}();

var BindingObserver = function() {
  function BindingObserver(context, delegate) {
    this.context = context;
    this.delegate = delegate;
    this.bindingsByAction = new Map();
  }
  BindingObserver.prototype.start = function() {
    if (!this.valueListObserver) {
      this.valueListObserver = new ValueListObserver(this.element, this.actionAttribute, this);
      this.valueListObserver.start();
    }
  };
  BindingObserver.prototype.stop = function() {
    if (this.valueListObserver) {
      this.valueListObserver.stop();
      delete this.valueListObserver;
      this.disconnectAllActions();
    }
  };
  Object.defineProperty(BindingObserver.prototype, "element", {
    get: function() {
      return this.context.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "identifier", {
    get: function() {
      return this.context.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "actionAttribute", {
    get: function() {
      return this.schema.actionAttribute;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "schema", {
    get: function() {
      return this.context.schema;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "bindings", {
    get: function() {
      return Array.from(this.bindingsByAction.values());
    },
    enumerable: false,
    configurable: true
  });
  BindingObserver.prototype.connectAction = function(action) {
    var binding = new Binding(this.context, action);
    this.bindingsByAction.set(action, binding);
    this.delegate.bindingConnected(binding);
  };
  BindingObserver.prototype.disconnectAction = function(action) {
    var binding = this.bindingsByAction.get(action);
    if (binding) {
      this.bindingsByAction.delete(action);
      this.delegate.bindingDisconnected(binding);
    }
  };
  BindingObserver.prototype.disconnectAllActions = function() {
    var _this = this;
    this.bindings.forEach(function(binding) {
      return _this.delegate.bindingDisconnected(binding);
    });
    this.bindingsByAction.clear();
  };
  BindingObserver.prototype.parseValueForToken = function(token) {
    var action = Action.forToken(token);
    if (action.identifier == this.identifier) {
      return action;
    }
  };
  BindingObserver.prototype.elementMatchedValue = function(element, action) {
    this.connectAction(action);
  };
  BindingObserver.prototype.elementUnmatchedValue = function(element, action) {
    this.disconnectAction(action);
  };
  return BindingObserver;
}();

var ValueObserver = function() {
  function ValueObserver(context, receiver) {
    this.context = context;
    this.receiver = receiver;
    this.stringMapObserver = new StringMapObserver(this.element, this);
    this.valueDescriptorMap = this.controller.valueDescriptorMap;
    this.invokeChangedCallbacksForDefaultValues();
  }
  ValueObserver.prototype.start = function() {
    this.stringMapObserver.start();
  };
  ValueObserver.prototype.stop = function() {
    this.stringMapObserver.stop();
  };
  Object.defineProperty(ValueObserver.prototype, "element", {
    get: function() {
      return this.context.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(ValueObserver.prototype, "controller", {
    get: function() {
      return this.context.controller;
    },
    enumerable: false,
    configurable: true
  });
  ValueObserver.prototype.getStringMapKeyForAttribute = function(attributeName) {
    if (attributeName in this.valueDescriptorMap) {
      return this.valueDescriptorMap[attributeName].name;
    }
  };
  ValueObserver.prototype.stringMapValueChanged = function(attributeValue, name) {
    this.invokeChangedCallbackForValue(name);
  };
  ValueObserver.prototype.invokeChangedCallbacksForDefaultValues = function() {
    for (var _i = 0, _a = this.valueDescriptors; _i < _a.length; _i++) {
      var _b = _a[_i], key = _b.key, name_1 = _b.name, defaultValue = _b.defaultValue;
      if (defaultValue != undefined && !this.controller.data.has(key)) {
        this.invokeChangedCallbackForValue(name_1);
      }
    }
  };
  ValueObserver.prototype.invokeChangedCallbackForValue = function(name) {
    var methodName = name + "Changed";
    var method = this.receiver[methodName];
    if (typeof method == "function") {
      var value = this.receiver[name];
      method.call(this.receiver, value);
    }
  };
  Object.defineProperty(ValueObserver.prototype, "valueDescriptors", {
    get: function() {
      var valueDescriptorMap = this.valueDescriptorMap;
      return Object.keys(valueDescriptorMap).map(function(key) {
        return valueDescriptorMap[key];
      });
    },
    enumerable: false,
    configurable: true
  });
  return ValueObserver;
}();

var Context = function() {
  function Context(module, scope) {
    this.module = module;
    this.scope = scope;
    this.controller = new module.controllerConstructor(this);
    this.bindingObserver = new BindingObserver(this, this.dispatcher);
    this.valueObserver = new ValueObserver(this, this.controller);
    try {
      this.controller.initialize();
    } catch (error) {
      this.handleError(error, "initializing controller");
    }
  }
  Context.prototype.connect = function() {
    this.bindingObserver.start();
    this.valueObserver.start();
    try {
      this.controller.connect();
    } catch (error) {
      this.handleError(error, "connecting controller");
    }
  };
  Context.prototype.disconnect = function() {
    try {
      this.controller.disconnect();
    } catch (error) {
      this.handleError(error, "disconnecting controller");
    }
    this.valueObserver.stop();
    this.bindingObserver.stop();
  };
  Object.defineProperty(Context.prototype, "application", {
    get: function() {
      return this.module.application;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "identifier", {
    get: function() {
      return this.module.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "schema", {
    get: function() {
      return this.application.schema;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "dispatcher", {
    get: function() {
      return this.application.dispatcher;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "parentElement", {
    get: function() {
      return this.element.parentElement;
    },
    enumerable: false,
    configurable: true
  });
  Context.prototype.handleError = function(error, message, detail) {
    if (detail === void 0) {
      detail = {};
    }
    var _a = this, identifier = _a.identifier, controller = _a.controller, element = _a.element;
    detail = Object.assign({
      identifier: identifier,
      controller: controller,
      element: element
    }, detail);
    this.application.handleError(error, "Error " + message, detail);
  };
  return Context;
}();

function readInheritableStaticArrayValues(constructor, propertyName) {
  var ancestors = getAncestorsForConstructor(constructor);
  return Array.from(ancestors.reduce(function(values, constructor) {
    getOwnStaticArrayValues(constructor, propertyName).forEach(function(name) {
      return values.add(name);
    });
    return values;
  }, new Set()));
}

function readInheritableStaticObjectPairs(constructor, propertyName) {
  var ancestors = getAncestorsForConstructor(constructor);
  return ancestors.reduce(function(pairs, constructor) {
    pairs.push.apply(pairs, getOwnStaticObjectPairs(constructor, propertyName));
    return pairs;
  }, []);
}

function getAncestorsForConstructor(constructor) {
  var ancestors = [];
  while (constructor) {
    ancestors.push(constructor);
    constructor = Object.getPrototypeOf(constructor);
  }
  return ancestors.reverse();
}

function getOwnStaticArrayValues(constructor, propertyName) {
  var definition = constructor[propertyName];
  return Array.isArray(definition) ? definition : [];
}

function getOwnStaticObjectPairs(constructor, propertyName) {
  var definition = constructor[propertyName];
  return definition ? Object.keys(definition).map(function(key) {
    return [ key, definition[key] ];
  }) : [];
}

var __extends$1 = window && window.__extends || function() {
  var extendStatics = function(d, b) {
    extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function(d, b) {
      d.__proto__ = b;
    } || function(d, b) {
      for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    };
    return extendStatics(d, b);
  };
  return function(d, b) {
    extendStatics(d, b);
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __spreadArrays = window && window.__spreadArrays || function() {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, 
  k++) r[k] = a[j];
  return r;
};

function bless(constructor) {
  return shadow(constructor, getBlessedProperties(constructor));
}

function shadow(constructor, properties) {
  var shadowConstructor = extend(constructor);
  var shadowProperties = getShadowProperties(constructor.prototype, properties);
  Object.defineProperties(shadowConstructor.prototype, shadowProperties);
  return shadowConstructor;
}

function getBlessedProperties(constructor) {
  var blessings = readInheritableStaticArrayValues(constructor, "blessings");
  return blessings.reduce(function(blessedProperties, blessing) {
    var properties = blessing(constructor);
    for (var key in properties) {
      var descriptor = blessedProperties[key] || {};
      blessedProperties[key] = Object.assign(descriptor, properties[key]);
    }
    return blessedProperties;
  }, {});
}

function getShadowProperties(prototype, properties) {
  return getOwnKeys(properties).reduce(function(shadowProperties, key) {
    var _a;
    var descriptor = getShadowedDescriptor(prototype, properties, key);
    if (descriptor) {
      Object.assign(shadowProperties, (_a = {}, _a[key] = descriptor, _a));
    }
    return shadowProperties;
  }, {});
}

function getShadowedDescriptor(prototype, properties, key) {
  var shadowingDescriptor = Object.getOwnPropertyDescriptor(prototype, key);
  var shadowedByValue = shadowingDescriptor && "value" in shadowingDescriptor;
  if (!shadowedByValue) {
    var descriptor = Object.getOwnPropertyDescriptor(properties, key).value;
    if (shadowingDescriptor) {
      descriptor.get = shadowingDescriptor.get || descriptor.get;
      descriptor.set = shadowingDescriptor.set || descriptor.set;
    }
    return descriptor;
  }
}

var getOwnKeys = function() {
  if (typeof Object.getOwnPropertySymbols == "function") {
    return function(object) {
      return __spreadArrays(Object.getOwnPropertyNames(object), Object.getOwnPropertySymbols(object));
    };
  } else {
    return Object.getOwnPropertyNames;
  }
}();

var extend = function() {
  function extendWithReflect(constructor) {
    function extended() {
      var _newTarget = this && this instanceof extended ? this.constructor : void 0;
      return Reflect.construct(constructor, arguments, _newTarget);
    }
    extended.prototype = Object.create(constructor.prototype, {
      constructor: {
        value: extended
      }
    });
    Reflect.setPrototypeOf(extended, constructor);
    return extended;
  }
  function testReflectExtension() {
    var a = function() {
      this.a.call(this);
    };
    var b = extendWithReflect(a);
    b.prototype.a = function() {};
    return new b();
  }
  try {
    testReflectExtension();
    return extendWithReflect;
  } catch (error) {
    return function(constructor) {
      return function(_super) {
        __extends$1(extended, _super);
        function extended() {
          return _super !== null && _super.apply(this, arguments) || this;
        }
        return extended;
      }(constructor);
    };
  }
}();

function blessDefinition(definition) {
  return {
    identifier: definition.identifier,
    controllerConstructor: bless(definition.controllerConstructor)
  };
}

var Module = function() {
  function Module(application, definition) {
    this.application = application;
    this.definition = blessDefinition(definition);
    this.contextsByScope = new WeakMap();
    this.connectedContexts = new Set();
  }
  Object.defineProperty(Module.prototype, "identifier", {
    get: function() {
      return this.definition.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Module.prototype, "controllerConstructor", {
    get: function() {
      return this.definition.controllerConstructor;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Module.prototype, "contexts", {
    get: function() {
      return Array.from(this.connectedContexts);
    },
    enumerable: false,
    configurable: true
  });
  Module.prototype.connectContextForScope = function(scope) {
    var context = this.fetchContextForScope(scope);
    this.connectedContexts.add(context);
    context.connect();
  };
  Module.prototype.disconnectContextForScope = function(scope) {
    var context = this.contextsByScope.get(scope);
    if (context) {
      this.connectedContexts.delete(context);
      context.disconnect();
    }
  };
  Module.prototype.fetchContextForScope = function(scope) {
    var context = this.contextsByScope.get(scope);
    if (!context) {
      context = new Context(this, scope);
      this.contextsByScope.set(scope, context);
    }
    return context;
  };
  return Module;
}();

var ClassMap = function() {
  function ClassMap(scope) {
    this.scope = scope;
  }
  ClassMap.prototype.has = function(name) {
    return this.data.has(this.getDataKey(name));
  };
  ClassMap.prototype.get = function(name) {
    return this.data.get(this.getDataKey(name));
  };
  ClassMap.prototype.getAttributeName = function(name) {
    return this.data.getAttributeNameForKey(this.getDataKey(name));
  };
  ClassMap.prototype.getDataKey = function(name) {
    return name + "-class";
  };
  Object.defineProperty(ClassMap.prototype, "data", {
    get: function() {
      return this.scope.data;
    },
    enumerable: false,
    configurable: true
  });
  return ClassMap;
}();

function camelize(value) {
  return value.replace(/(?:[_-])([a-z0-9])/g, function(_, char) {
    return char.toUpperCase();
  });
}

function capitalize(value) {
  return value.charAt(0).toUpperCase() + value.slice(1);
}

function dasherize(value) {
  return value.replace(/([A-Z])/g, function(_, char) {
    return "-" + char.toLowerCase();
  });
}

var DataMap = function() {
  function DataMap(scope) {
    this.scope = scope;
  }
  Object.defineProperty(DataMap.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(DataMap.prototype, "identifier", {
    get: function() {
      return this.scope.identifier;
    },
    enumerable: false,
    configurable: true
  });
  DataMap.prototype.get = function(key) {
    var name = this.getAttributeNameForKey(key);
    return this.element.getAttribute(name);
  };
  DataMap.prototype.set = function(key, value) {
    var name = this.getAttributeNameForKey(key);
    this.element.setAttribute(name, value);
    return this.get(key);
  };
  DataMap.prototype.has = function(key) {
    var name = this.getAttributeNameForKey(key);
    return this.element.hasAttribute(name);
  };
  DataMap.prototype.delete = function(key) {
    if (this.has(key)) {
      var name_1 = this.getAttributeNameForKey(key);
      this.element.removeAttribute(name_1);
      return true;
    } else {
      return false;
    }
  };
  DataMap.prototype.getAttributeNameForKey = function(key) {
    return "data-" + this.identifier + "-" + dasherize(key);
  };
  return DataMap;
}();

var Guide = function() {
  function Guide(logger) {
    this.warnedKeysByObject = new WeakMap();
    this.logger = logger;
  }
  Guide.prototype.warn = function(object, key, message) {
    var warnedKeys = this.warnedKeysByObject.get(object);
    if (!warnedKeys) {
      warnedKeys = new Set();
      this.warnedKeysByObject.set(object, warnedKeys);
    }
    if (!warnedKeys.has(key)) {
      warnedKeys.add(key);
      this.logger.warn(message, object);
    }
  };
  return Guide;
}();

function attributeValueContainsToken(attributeName, token) {
  return "[" + attributeName + '~="' + token + '"]';
}

var __spreadArrays$1 = window && window.__spreadArrays || function() {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, 
  k++) r[k] = a[j];
  return r;
};

var TargetSet = function() {
  function TargetSet(scope) {
    this.scope = scope;
  }
  Object.defineProperty(TargetSet.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(TargetSet.prototype, "identifier", {
    get: function() {
      return this.scope.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(TargetSet.prototype, "schema", {
    get: function() {
      return this.scope.schema;
    },
    enumerable: false,
    configurable: true
  });
  TargetSet.prototype.has = function(targetName) {
    return this.find(targetName) != null;
  };
  TargetSet.prototype.find = function() {
    var _this = this;
    var targetNames = [];
    for (var _i = 0; _i < arguments.length; _i++) {
      targetNames[_i] = arguments[_i];
    }
    return targetNames.reduce(function(target, targetName) {
      return target || _this.findTarget(targetName) || _this.findLegacyTarget(targetName);
    }, undefined);
  };
  TargetSet.prototype.findAll = function() {
    var _this = this;
    var targetNames = [];
    for (var _i = 0; _i < arguments.length; _i++) {
      targetNames[_i] = arguments[_i];
    }
    return targetNames.reduce(function(targets, targetName) {
      return __spreadArrays$1(targets, _this.findAllTargets(targetName), _this.findAllLegacyTargets(targetName));
    }, []);
  };
  TargetSet.prototype.findTarget = function(targetName) {
    var selector = this.getSelectorForTargetName(targetName);
    return this.scope.findElement(selector);
  };
  TargetSet.prototype.findAllTargets = function(targetName) {
    var selector = this.getSelectorForTargetName(targetName);
    return this.scope.findAllElements(selector);
  };
  TargetSet.prototype.getSelectorForTargetName = function(targetName) {
    var attributeName = "data-" + this.identifier + "-target";
    return attributeValueContainsToken(attributeName, targetName);
  };
  TargetSet.prototype.findLegacyTarget = function(targetName) {
    var selector = this.getLegacySelectorForTargetName(targetName);
    return this.deprecate(this.scope.findElement(selector), targetName);
  };
  TargetSet.prototype.findAllLegacyTargets = function(targetName) {
    var _this = this;
    var selector = this.getLegacySelectorForTargetName(targetName);
    return this.scope.findAllElements(selector).map(function(element) {
      return _this.deprecate(element, targetName);
    });
  };
  TargetSet.prototype.getLegacySelectorForTargetName = function(targetName) {
    var targetDescriptor = this.identifier + "." + targetName;
    return attributeValueContainsToken(this.schema.targetAttribute, targetDescriptor);
  };
  TargetSet.prototype.deprecate = function(element, targetName) {
    if (element) {
      var identifier = this.identifier;
      var attributeName = this.schema.targetAttribute;
      this.guide.warn(element, "target:" + targetName, "Please replace " + attributeName + '="' + identifier + "." + targetName + '" with data-' + identifier + '-target="' + targetName + '". ' + ("The " + attributeName + " attribute is deprecated and will be removed in a future version of Stimulus."));
    }
    return element;
  };
  Object.defineProperty(TargetSet.prototype, "guide", {
    get: function() {
      return this.scope.guide;
    },
    enumerable: false,
    configurable: true
  });
  return TargetSet;
}();

var __spreadArrays$2 = window && window.__spreadArrays || function() {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, 
  k++) r[k] = a[j];
  return r;
};

var Scope = function() {
  function Scope(schema, element, identifier, logger) {
    var _this = this;
    this.targets = new TargetSet(this);
    this.classes = new ClassMap(this);
    this.data = new DataMap(this);
    this.containsElement = function(element) {
      return element.closest(_this.controllerSelector) === _this.element;
    };
    this.schema = schema;
    this.element = element;
    this.identifier = identifier;
    this.guide = new Guide(logger);
  }
  Scope.prototype.findElement = function(selector) {
    return this.element.matches(selector) ? this.element : this.queryElements(selector).find(this.containsElement);
  };
  Scope.prototype.findAllElements = function(selector) {
    return __spreadArrays$2(this.element.matches(selector) ? [ this.element ] : [], this.queryElements(selector).filter(this.containsElement));
  };
  Scope.prototype.queryElements = function(selector) {
    return Array.from(this.element.querySelectorAll(selector));
  };
  Object.defineProperty(Scope.prototype, "controllerSelector", {
    get: function() {
      return attributeValueContainsToken(this.schema.controllerAttribute, this.identifier);
    },
    enumerable: false,
    configurable: true
  });
  return Scope;
}();

var ScopeObserver = function() {
  function ScopeObserver(element, schema, delegate) {
    this.element = element;
    this.schema = schema;
    this.delegate = delegate;
    this.valueListObserver = new ValueListObserver(this.element, this.controllerAttribute, this);
    this.scopesByIdentifierByElement = new WeakMap();
    this.scopeReferenceCounts = new WeakMap();
  }
  ScopeObserver.prototype.start = function() {
    this.valueListObserver.start();
  };
  ScopeObserver.prototype.stop = function() {
    this.valueListObserver.stop();
  };
  Object.defineProperty(ScopeObserver.prototype, "controllerAttribute", {
    get: function() {
      return this.schema.controllerAttribute;
    },
    enumerable: false,
    configurable: true
  });
  ScopeObserver.prototype.parseValueForToken = function(token) {
    var element = token.element, identifier = token.content;
    var scopesByIdentifier = this.fetchScopesByIdentifierForElement(element);
    var scope = scopesByIdentifier.get(identifier);
    if (!scope) {
      scope = this.delegate.createScopeForElementAndIdentifier(element, identifier);
      scopesByIdentifier.set(identifier, scope);
    }
    return scope;
  };
  ScopeObserver.prototype.elementMatchedValue = function(element, value) {
    var referenceCount = (this.scopeReferenceCounts.get(value) || 0) + 1;
    this.scopeReferenceCounts.set(value, referenceCount);
    if (referenceCount == 1) {
      this.delegate.scopeConnected(value);
    }
  };
  ScopeObserver.prototype.elementUnmatchedValue = function(element, value) {
    var referenceCount = this.scopeReferenceCounts.get(value);
    if (referenceCount) {
      this.scopeReferenceCounts.set(value, referenceCount - 1);
      if (referenceCount == 1) {
        this.delegate.scopeDisconnected(value);
      }
    }
  };
  ScopeObserver.prototype.fetchScopesByIdentifierForElement = function(element) {
    var scopesByIdentifier = this.scopesByIdentifierByElement.get(element);
    if (!scopesByIdentifier) {
      scopesByIdentifier = new Map();
      this.scopesByIdentifierByElement.set(element, scopesByIdentifier);
    }
    return scopesByIdentifier;
  };
  return ScopeObserver;
}();

var Router = function() {
  function Router(application) {
    this.application = application;
    this.scopeObserver = new ScopeObserver(this.element, this.schema, this);
    this.scopesByIdentifier = new Multimap();
    this.modulesByIdentifier = new Map();
  }
  Object.defineProperty(Router.prototype, "element", {
    get: function() {
      return this.application.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "schema", {
    get: function() {
      return this.application.schema;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "logger", {
    get: function() {
      return this.application.logger;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "controllerAttribute", {
    get: function() {
      return this.schema.controllerAttribute;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "modules", {
    get: function() {
      return Array.from(this.modulesByIdentifier.values());
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "contexts", {
    get: function() {
      return this.modules.reduce(function(contexts, module) {
        return contexts.concat(module.contexts);
      }, []);
    },
    enumerable: false,
    configurable: true
  });
  Router.prototype.start = function() {
    this.scopeObserver.start();
  };
  Router.prototype.stop = function() {
    this.scopeObserver.stop();
  };
  Router.prototype.loadDefinition = function(definition) {
    this.unloadIdentifier(definition.identifier);
    var module = new Module(this.application, definition);
    this.connectModule(module);
  };
  Router.prototype.unloadIdentifier = function(identifier) {
    var module = this.modulesByIdentifier.get(identifier);
    if (module) {
      this.disconnectModule(module);
    }
  };
  Router.prototype.getContextForElementAndIdentifier = function(element, identifier) {
    var module = this.modulesByIdentifier.get(identifier);
    if (module) {
      return module.contexts.find(function(context) {
        return context.element == element;
      });
    }
  };
  Router.prototype.handleError = function(error, message, detail) {
    this.application.handleError(error, message, detail);
  };
  Router.prototype.createScopeForElementAndIdentifier = function(element, identifier) {
    return new Scope(this.schema, element, identifier, this.logger);
  };
  Router.prototype.scopeConnected = function(scope) {
    this.scopesByIdentifier.add(scope.identifier, scope);
    var module = this.modulesByIdentifier.get(scope.identifier);
    if (module) {
      module.connectContextForScope(scope);
    }
  };
  Router.prototype.scopeDisconnected = function(scope) {
    this.scopesByIdentifier.delete(scope.identifier, scope);
    var module = this.modulesByIdentifier.get(scope.identifier);
    if (module) {
      module.disconnectContextForScope(scope);
    }
  };
  Router.prototype.connectModule = function(module) {
    this.modulesByIdentifier.set(module.identifier, module);
    var scopes = this.scopesByIdentifier.getValuesForKey(module.identifier);
    scopes.forEach(function(scope) {
      return module.connectContextForScope(scope);
    });
  };
  Router.prototype.disconnectModule = function(module) {
    this.modulesByIdentifier.delete(module.identifier);
    var scopes = this.scopesByIdentifier.getValuesForKey(module.identifier);
    scopes.forEach(function(scope) {
      return module.disconnectContextForScope(scope);
    });
  };
  return Router;
}();

var defaultSchema = {
  controllerAttribute: "data-controller",
  actionAttribute: "data-action",
  targetAttribute: "data-target"
};

var __awaiter = window && window.__awaiter || function(thisArg, _arguments, P, generator) {
  function adopt(value) {
    return value instanceof P ? value : new P(function(resolve) {
      resolve(value);
    });
  }
  return new (P || (P = Promise))(function(resolve, reject) {
    function fulfilled(value) {
      try {
        step(generator.next(value));
      } catch (e) {
        reject(e);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e) {
        reject(e);
      }
    }
    function step(result) {
      result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected);
    }
    step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
};

var __generator = window && window.__generator || function(thisArg, body) {
  var _ = {
    label: 0,
    sent: function() {
      if (t[0] & 1) throw t[1];
      return t[1];
    },
    trys: [],
    ops: []
  }, f, y, t, g;
  return g = {
    next: verb(0),
    throw: verb(1),
    return: verb(2)
  }, typeof Symbol === "function" && (g[Symbol.iterator] = function() {
    return this;
  }), g;
  function verb(n) {
    return function(v) {
      return step([ n, v ]);
    };
  }
  function step(op) {
    if (f) throw new TypeError("Generator is already executing.");
    while (_) try {
      if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 
      0) : y.next) && !(t = t.call(y, op[1])).done) return t;
      if (y = 0, t) op = [ op[0] & 2, t.value ];
      switch (op[0]) {
       case 0:
       case 1:
        t = op;
        break;

       case 4:
        _.label++;
        return {
          value: op[1],
          done: false
        };

       case 5:
        _.label++;
        y = op[1];
        op = [ 0 ];
        continue;

       case 7:
        op = _.ops.pop();
        _.trys.pop();
        continue;

       default:
        if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) {
          _ = 0;
          continue;
        }
        if (op[0] === 3 && (!t || op[1] > t[0] && op[1] < t[3])) {
          _.label = op[1];
          break;
        }
        if (op[0] === 6 && _.label < t[1]) {
          _.label = t[1];
          t = op;
          break;
        }
        if (t && _.label < t[2]) {
          _.label = t[2];
          _.ops.push(op);
          break;
        }
        if (t[2]) _.ops.pop();
        _.trys.pop();
        continue;
      }
      op = body.call(thisArg, _);
    } catch (e) {
      op = [ 6, e ];
      y = 0;
    } finally {
      f = t = 0;
    }
    if (op[0] & 5) throw op[1];
    return {
      value: op[0] ? op[1] : void 0,
      done: true
    };
  }
};

var __spreadArrays$3 = window && window.__spreadArrays || function() {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, 
  k++) r[k] = a[j];
  return r;
};

var Application = function() {
  function Application(element, schema) {
    if (element === void 0) {
      element = document.documentElement;
    }
    if (schema === void 0) {
      schema = defaultSchema;
    }
    this.logger = console;
    this.element = element;
    this.schema = schema;
    this.dispatcher = new Dispatcher(this);
    this.router = new Router(this);
  }
  Application.start = function(element, schema) {
    var application = new Application(element, schema);
    application.start();
    return application;
  };
  Application.prototype.start = function() {
    return __awaiter(this, void 0, void 0, function() {
      return __generator(this, function(_a) {
        switch (_a.label) {
         case 0:
          return [ 4, domReady() ];

         case 1:
          _a.sent();
          this.dispatcher.start();
          this.router.start();
          return [ 2 ];
        }
      });
    });
  };
  Application.prototype.stop = function() {
    this.dispatcher.stop();
    this.router.stop();
  };
  Application.prototype.register = function(identifier, controllerConstructor) {
    this.load({
      identifier: identifier,
      controllerConstructor: controllerConstructor
    });
  };
  Application.prototype.load = function(head) {
    var _this = this;
    var rest = [];
    for (var _i = 1; _i < arguments.length; _i++) {
      rest[_i - 1] = arguments[_i];
    }
    var definitions = Array.isArray(head) ? head : __spreadArrays$3([ head ], rest);
    definitions.forEach(function(definition) {
      return _this.router.loadDefinition(definition);
    });
  };
  Application.prototype.unload = function(head) {
    var _this = this;
    var rest = [];
    for (var _i = 1; _i < arguments.length; _i++) {
      rest[_i - 1] = arguments[_i];
    }
    var identifiers = Array.isArray(head) ? head : __spreadArrays$3([ head ], rest);
    identifiers.forEach(function(identifier) {
      return _this.router.unloadIdentifier(identifier);
    });
  };
  Object.defineProperty(Application.prototype, "controllers", {
    get: function() {
      return this.router.contexts.map(function(context) {
        return context.controller;
      });
    },
    enumerable: false,
    configurable: true
  });
  Application.prototype.getControllerForElementAndIdentifier = function(element, identifier) {
    var context = this.router.getContextForElementAndIdentifier(element, identifier);
    return context ? context.controller : null;
  };
  Application.prototype.handleError = function(error, message, detail) {
    this.logger.error("%s\n\n%o\n\n%o", message, error, detail);
  };
  return Application;
}();

function domReady() {
  return new Promise(function(resolve) {
    if (document.readyState == "loading") {
      document.addEventListener("DOMContentLoaded", resolve);
    } else {
      resolve();
    }
  });
}

function ClassPropertiesBlessing(constructor) {
  var classes = readInheritableStaticArrayValues(constructor, "classes");
  return classes.reduce(function(properties, classDefinition) {
    return Object.assign(properties, propertiesForClassDefinition(classDefinition));
  }, {});
}

function propertiesForClassDefinition(key) {
  var _a;
  var name = key + "Class";
  return _a = {}, _a[name] = {
    get: function() {
      var classes = this.classes;
      if (classes.has(key)) {
        return classes.get(key);
      } else {
        var attribute = classes.getAttributeName(key);
        throw new Error('Missing attribute "' + attribute + '"');
      }
    }
  }, _a["has" + capitalize(name)] = {
    get: function() {
      return this.classes.has(key);
    }
  }, _a;
}

function TargetPropertiesBlessing(constructor) {
  var targets = readInheritableStaticArrayValues(constructor, "targets");
  return targets.reduce(function(properties, targetDefinition) {
    return Object.assign(properties, propertiesForTargetDefinition(targetDefinition));
  }, {});
}

function propertiesForTargetDefinition(name) {
  var _a;
  return _a = {}, _a[name + "Target"] = {
    get: function() {
      var target = this.targets.find(name);
      if (target) {
        return target;
      } else {
        throw new Error('Missing target element "' + this.identifier + "." + name + '"');
      }
    }
  }, _a[name + "Targets"] = {
    get: function() {
      return this.targets.findAll(name);
    }
  }, _a["has" + capitalize(name) + "Target"] = {
    get: function() {
      return this.targets.has(name);
    }
  }, _a;
}

function ValuePropertiesBlessing(constructor) {
  var valueDefinitionPairs = readInheritableStaticObjectPairs(constructor, "values");
  var propertyDescriptorMap = {
    valueDescriptorMap: {
      get: function() {
        var _this = this;
        return valueDefinitionPairs.reduce(function(result, valueDefinitionPair) {
          var _a;
          var valueDescriptor = parseValueDefinitionPair(valueDefinitionPair);
          var attributeName = _this.data.getAttributeNameForKey(valueDescriptor.key);
          return Object.assign(result, (_a = {}, _a[attributeName] = valueDescriptor, _a));
        }, {});
      }
    }
  };
  return valueDefinitionPairs.reduce(function(properties, valueDefinitionPair) {
    return Object.assign(properties, propertiesForValueDefinitionPair(valueDefinitionPair));
  }, propertyDescriptorMap);
}

function propertiesForValueDefinitionPair(valueDefinitionPair) {
  var _a;
  var definition = parseValueDefinitionPair(valueDefinitionPair);
  var type = definition.type, key = definition.key, name = definition.name;
  var read = readers[type], write = writers[type] || writers.default;
  return _a = {}, _a[name] = {
    get: function() {
      var value = this.data.get(key);
      if (value !== null) {
        return read(value);
      } else {
        return definition.defaultValue;
      }
    },
    set: function(value) {
      if (value === undefined) {
        this.data.delete(key);
      } else {
        this.data.set(key, write(value));
      }
    }
  }, _a["has" + capitalize(name)] = {
    get: function() {
      return this.data.has(key);
    }
  }, _a;
}

function parseValueDefinitionPair(_a) {
  var token = _a[0], typeConstant = _a[1];
  var type = parseValueTypeConstant(typeConstant);
  return valueDescriptorForTokenAndType(token, type);
}

function parseValueTypeConstant(typeConstant) {
  switch (typeConstant) {
   case Array:
    return "array";

   case Boolean:
    return "boolean";

   case Number:
    return "number";

   case Object:
    return "object";

   case String:
    return "string";
  }
  throw new Error('Unknown value type constant "' + typeConstant + '"');
}

function valueDescriptorForTokenAndType(token, type) {
  var key = dasherize(token) + "-value";
  return {
    type: type,
    key: key,
    name: camelize(key),
    get defaultValue() {
      return defaultValuesByType[type];
    }
  };
}

var defaultValuesByType = {
  get array() {
    return [];
  },
  boolean: false,
  number: 0,
  get object() {
    return {};
  },
  string: ""
};

var readers = {
  array: function(value) {
    var array = JSON.parse(value);
    if (!Array.isArray(array)) {
      throw new TypeError("Expected array");
    }
    return array;
  },
  boolean: function(value) {
    return !(value == "0" || value == "false");
  },
  number: function(value) {
    return parseFloat(value);
  },
  object: function(value) {
    var object = JSON.parse(value);
    if (object === null || typeof object != "object" || Array.isArray(object)) {
      throw new TypeError("Expected object");
    }
    return object;
  },
  string: function(value) {
    return value;
  }
};

var writers = {
  default: writeString,
  array: writeJSON,
  object: writeJSON
};

function writeJSON(value) {
  return JSON.stringify(value);
}

function writeString(value) {
  return "" + value;
}

var Controller = function() {
  function Controller(context) {
    this.context = context;
  }
  Object.defineProperty(Controller.prototype, "application", {
    get: function() {
      return this.context.application;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "scope", {
    get: function() {
      return this.context.scope;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "identifier", {
    get: function() {
      return this.scope.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "targets", {
    get: function() {
      return this.scope.targets;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "classes", {
    get: function() {
      return this.scope.classes;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "data", {
    get: function() {
      return this.scope.data;
    },
    enumerable: false,
    configurable: true
  });
  Controller.prototype.initialize = function() {};
  Controller.prototype.connect = function() {};
  Controller.prototype.disconnect = function() {};
  Controller.blessings = [ ClassPropertiesBlessing, TargetPropertiesBlessing, ValuePropertiesBlessing ];
  Controller.targets = [];
  Controller.values = {};
  return Controller;
}();

function _classCallCheck(instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
}

function _defineProperties(target, props) {
  for (var i = 0; i < props.length; i++) {
    var descriptor = props[i];
    descriptor.enumerable = descriptor.enumerable || false;
    descriptor.configurable = true;
    if ("value" in descriptor) descriptor.writable = true;
    Object.defineProperty(target, descriptor.key, descriptor);
  }
}

function _createClass(Constructor, protoProps, staticProps) {
  if (protoProps) _defineProperties(Constructor.prototype, protoProps);
  if (staticProps) _defineProperties(Constructor, staticProps);
  return Constructor;
}

function _defineProperty(obj, key, value) {
  if (key in obj) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
  } else {
    obj[key] = value;
  }
  return obj;
}

function _inherits(subClass, superClass) {
  if (typeof superClass !== "function" && superClass !== null) {
    throw new TypeError("Super expression must either be null or a function");
  }
  subClass.prototype = Object.create(superClass && superClass.prototype, {
    constructor: {
      value: subClass,
      writable: true,
      configurable: true
    }
  });
  if (superClass) _setPrototypeOf(subClass, superClass);
}

function _getPrototypeOf(o) {
  _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) {
    return o.__proto__ || Object.getPrototypeOf(o);
  };
  return _getPrototypeOf(o);
}

function _setPrototypeOf(o, p) {
  _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) {
    o.__proto__ = p;
    return o;
  };
  return _setPrototypeOf(o, p);
}

function _isNativeReflectConstruct() {
  if (typeof Reflect === "undefined" || !Reflect.construct) return false;
  if (Reflect.construct.sham) return false;
  if (typeof Proxy === "function") return true;
  try {
    Date.prototype.toString.call(Reflect.construct(Date, [], function() {}));
    return true;
  } catch (e) {
    return false;
  }
}

function _assertThisInitialized(self) {
  if (self === void 0) {
    throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
  }
  return self;
}

function _possibleConstructorReturn(self, call) {
  if (call && (typeof call === "object" || typeof call === "function")) {
    return call;
  }
  return _assertThisInitialized(self);
}

function _createSuper(Derived) {
  return function() {
    var Super = _getPrototypeOf(Derived), result;
    if (_isNativeReflectConstruct()) {
      var NewTarget = _getPrototypeOf(this).constructor;
      result = Reflect.construct(Super, arguments, NewTarget);
    } else {
      result = Super.apply(this, arguments);
    }
    return _possibleConstructorReturn(this, result);
  };
}

function _toConsumableArray(arr) {
  return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread();
}

function _arrayWithoutHoles(arr) {
  if (Array.isArray(arr)) return _arrayLikeToArray(arr);
}

function _iterableToArray(iter) {
  if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter);
}

function _unsupportedIterableToArray(o, minLen) {
  if (!o) return;
  if (typeof o === "string") return _arrayLikeToArray(o, minLen);
  var n = Object.prototype.toString.call(o).slice(8, -1);
  if (n === "Object" && o.constructor) n = o.constructor.name;
  if (n === "Map" || n === "Set") return Array.from(n);
  if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen);
}

function _arrayLikeToArray(arr, len) {
  if (len == null || len > arr.length) len = arr.length;
  for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i];
  return arr2;
}

function _nonIterableSpread() {
  throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
}

var $ = window.$;

var _default = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "row",
    value: function row(event) {
      event.preventDefault;
      var tbody = event.target.closest("tbody");
      tbody.classList.toggle("toggleable--open");
      $(".mgrid > .row").masonry("layout");
    }
  }, {
    key: "table",
    value: function table(event) {
      event.preventDefault;
      var table = event.target.closest("table");
      var thead = event.target.closest("thead");
      var tbodies = Array.prototype.slice.call(table.querySelectorAll("tbody"));
      var hide = thead.classList.contains("toggleable--open");
      thead.classList.toggle("toggleable--open");
      tbodies.forEach(function(tbody) {
        tbody.classList.toggle("toggleable--open", !hide);
      });
      $(".mgrid > .row").masonry("layout");
    }
  } ]);
  return _default;
}(Controller);

var $$1 = window.$;

var _default$1 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {
      window.initDatepickersIn(".hd-drug-administration");
    }
  }, {
    key: "toggleAdministered",
    value: function toggleAdministered() {
      var checked = event.target.value == "true";
      this.containerTarget.classList.toggle("administered", checked);
      this.containerTarget.classList.toggle("not-administered", !checked);
      this.containerTarget.classList.remove("undecided");
      $$1(".authentication", this.containerTarget).toggle(checked);
      $$1(".authentication", this.containerTarget).toggleClass("disabled-with-faded-overlay", !checked);
      $$1(".reason-why-not-administered", this.containerTarget).toggle(!checked);
      $$1("#btn_save_and_witness_later").toggle(checked);
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$1, "targets", [ "container", "radio" ]);

var Rails = window.Rails;

var _default$2 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "refreshForm",
    value: function refreshForm() {
      Rails.fire(this.formTarget, "submit");
    }
  }, {
    key: "askForPrintFeedback",
    value: function askForPrintFeedback() {
      this.printOptionsTarget.classList.toggle("visuallyhidden");
      this.printFeedbackTarget.classList.toggle("visuallyhidden");
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$2, "targets", [ "form", "printOptions", "printFeedback" ]);

var $$2 = window.$;

var _default$3 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "insert",
    value: function insert(event) {
      var modal = $$2("#snippets-modal");
      var snippetBody = $$2(event.target).parent().closest("tr").find(".body").html();
      var trix = document.querySelector("trix-editor");
      trix.editor.insertHTML(snippetBody);
      $$2(modal).foundation("reveal", "close");
    }
  } ]);
  return _default;
}(Controller);

var $$3 = window.$;

var _default$4 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "initInsertEventNotesIntoTrixEditor",
    value: function initInsertEventNotesIntoTrixEditor(event) {
      event.preventDefault();
      var notes = $$3(event.target).data("notes");
      if (notes && this.trix) {
        this.trix.insertHTML(notes);
      } else {
        alert("There are no notes to insert");
      }
    }
  }, {
    key: "trix",
    get: function get() {
      return this.trixTarget.editor;
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$4, "targets", [ "trix" ]);

var _default$5 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {
      var radio_value = this.providersTarget.querySelector("input:checked").value;
      this.toggleDeliveryDatesVisibility(radio_value);
    }
  }, {
    key: "toggleDeliveryDates",
    value: function toggleDeliveryDates(event) {
      this.toggleDeliveryDatesVisibility(event.target.value);
    }
  }, {
    key: "toggleDeliveryDatesVisibility",
    value: function toggleDeliveryDatesVisibility(radio_value) {
      if (radio_value == "home_delivery") {
        this.homeDeliveryDatesTarget.style.display = "block";
      } else {
        this.homeDeliveryDatesTarget.style.display = "none";
      }
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$5, "targets", [ "homeDeliveryDates", "providers" ]);

var Chartkick = window.Chartkick;

var _default$6 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "redisplay",
    value: function redisplay(event) {
      var json = event.detail[0];
      if (this.chartCreated()) {
        this.chartTarget.getChartObject().updateData(json);
      } else {
        new Chartkick.LineChart("chart1", json, this.chartOptions);
      }
    }
  }, {
    key: "chartCreated",
    value: function chartCreated() {
      return Object.prototype.hasOwnProperty.call(this.chartTarget, "getChartObject");
    }
  }, {
    key: "chartOptions",
    get: function get() {
      return {
        curve: false,
        library: {
          chart: {
            zoomType: "x"
          },
          plotOptions: {
            series: {
              animation: {
                duration: 400
              }
            }
          },
          colors: [ "#005eb8", "#009639", "#434348", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354" ]
        }
      };
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$6, "targets", [ "chart" ]);

var Rails$1 = window.Rails;

var _ = window._;

var _default$7 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    var _this;
    _classCallCheck(this, _default);
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }
    _this = _super.call.apply(_super, [ this ].concat(args));
    _defineProperty(_assertThisInitialized(_this), "checkForSessionExpiryTimeout", null);
    _defineProperty(_assertThisInitialized(_this), "userActivityDetected", false);
    _defineProperty(_assertThisInitialized(_this), "checkAlivePath", null);
    _defineProperty(_assertThisInitialized(_this), "keepAlivePath", null);
    _defineProperty(_assertThisInitialized(_this), "loginPath", null);
    _defineProperty(_assertThisInitialized(_this), "throttledRegisterUserActivity", null);
    _defineProperty(_assertThisInitialized(_this), "sessionTimeoutSeconds", 0);
    _defineProperty(_assertThisInitialized(_this), "defaultSessionTimeoutSeconds", 20 * 60);
    _defineProperty(_assertThisInitialized(_this), "throttlePeriodSeconds", 0);
    _defineProperty(_assertThisInitialized(_this), "defaultThrottlePeriodSeconds", 20);
    return _this;
  }
  _createClass(_default, [ {
    key: "initialize",
    value: function initialize() {
      this.throttlePeriodSeconds = parseInt(this.data.get("register-user-activity-after") || this.defaultThrottlePeriodSeconds);
      this.sessionTimeoutSeconds = parseInt(this.data.get("timeout") || this.defaultSessionTimeoutSeconds);
      this.sessionTimeoutSeconds += 10;
      this.checkAlivePath = this.data.get("check-alive-path");
      this.loginPath = this.data.get("login-path");
      this.keepAlivePath = this.data.get("keep-alive-path");
      this.logSettings();
      this.throttledRegisterUserActivity = _.throttle(this.registerUserActivity.bind(this), this.throttlePeriodSeconds * 1e3, {
        leading: false,
        trailing: true
      });
    }
  }, {
    key: "connect",
    value: function connect() {
      if (this.onLoginPage) {
        this.log("connect: onLoginPage - skipping session time");
      } else {
        this.addHandlersToMonitorUserActivity();
        this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds);
      }
    }
  }, {
    key: "disconnect",
    value: function disconnect() {
      if (!this.onLoginPage) {
        this.removeUserActivityHandlers();
        clearTimeout(this.checkForSessionExpiryTimeout);
      }
    }
  }, {
    key: "sendLogoutMessageToAnyOpenTabs",
    value: function sendLogoutMessageToAnyOpenTabs() {
      window.localStorage.setItem("logout-event", "logout" + Math.random());
    }
  }, {
    key: "registerUserActivity",
    value: function registerUserActivity() {
      this.sendRequestToKeepSessionAlive();
      this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds);
    }
  }, {
    key: "resetCheckForSessionExpiryTimeout",
    value: function resetCheckForSessionExpiryTimeout(intervalSeconds) {
      this.log("resetting session expiry timeout ".concat(intervalSeconds));
      clearTimeout(this.checkForSessionExpiryTimeout);
      this.checkForSessionExpiryTimeout = setTimeout(this.checkForSessionExpiry.bind(this), intervalSeconds * 1e3);
    }
  }, {
    key: "checkForSessionExpiry",
    value: function checkForSessionExpiry() {
      this.sendRequestToTestForSessionExpiry();
      this.resetCheckForSessionExpiryTimeout(this.throttlePeriodSeconds * 2);
    }
  }, {
    key: "sendRequestToKeepSessionAlive",
    value: function sendRequestToKeepSessionAlive() {
      this.ajaxGet(this.keepAlivePath);
    }
  }, {
    key: "sendRequestToTestForSessionExpiry",
    value: function sendRequestToTestForSessionExpiry() {
      this.log("checking for session expiry");
      this.ajaxGet(this.checkAlivePath);
    }
  }, {
    key: "ajaxGet",
    value: function ajaxGet(path) {
      Rails$1.ajax({
        type: "GET",
        url: path,
        dataType: "text",
        error: this.reloadPageIfAjaxRequestWasUnauthorised.bind(this)
      });
    }
  }, {
    key: "reloadPageIfAjaxRequestWasUnauthorised",
    value: function reloadPageIfAjaxRequestWasUnauthorised(responseText, status, xhr) {
      if (xhr.status == 401) {
        window.location.reload();
        this.sendLogoutMessageToAnyOpenTabs();
      }
    }
  }, {
    key: "addHandlersToMonitorUserActivity",
    value: function addHandlersToMonitorUserActivity() {
      document.addEventListener("click", this.throttledRegisterUserActivity.bind(this));
      document.addEventListener("keydown", this.throttledRegisterUserActivity.bind(this));
      window.addEventListener("resize", this.throttledRegisterUserActivity.bind(this));
      window.addEventListener("storage", this.storageChange.bind(this));
    }
  }, {
    key: "removeUserActivityHandlers",
    value: function removeUserActivityHandlers() {
      document.removeEventListener("click", this.throttledRegisterUserActivity.bind(this));
      document.removeEventListener("keydown", this.throttledRegisterUserActivity.bind(this));
      window.removeEventListener("resize", this.throttledRegisterUserActivity.bind(this));
      window.removeEventListener("storage", this.storageChange.bind(this));
    }
  }, {
    key: "logSettings",
    value: function logSettings() {
      if (this.debug) {
        this.log("keepAlivePath ".concat(this.keepAlivePath));
        this.log("checkAlivePath ".concat(this.checkAlivePath));
        this.log("loginPath ".concat(this.loginPath));
        this.log("sessionTimeoutSeconds ".concat(this.sessionTimeoutSeconds));
        this.log("throttlePeriodSeconds ".concat(this.throttlePeriodSeconds));
      }
    }
  }, {
    key: "log",
    value: function log(msg) {
      if (this.debug) {
        console.log(msg);
      }
    }
  }, {
    key: "storageChange",
    value: function storageChange(event) {
      if (event.key == "logout-event") {
        setTimeout(this.sendRequestToTestForSessionExpiry.bind(this), 2e3);
      }
    }
  }, {
    key: "onLoginPage",
    get: function get() {
      return window.location.pathname == this.loginPath;
    }
  }, {
    key: "debug",
    get: function get() {
      return this.data.get("debug") === "true";
    }
  } ]);
  return _default;
}(Controller);

var _default$8 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {
      this.toggleClass = this.data.get("class") || "hidden";
    }
  }, {
    key: "toggle",
    value: function toggle(event) {
      var _this = this;
      event.preventDefault();
      this.toggleableTargets.forEach(function(target) {
        target.classList.toggle(_this.toggleClass);
      });
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$8, "targets", [ "toggleable" ]);

var _default$9 = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {}
  }, {
    key: "initialize",
    value: function initialize() {
      this.activeTabClasses = (this.data.get("activeTab") || "active").split(" ");
      this.showTab();
    }
  }, {
    key: "change",
    value: function change(event) {
      event.preventDefault();
      this.index = this.tabTargets.indexOf(event.currentTarget);
    }
  }, {
    key: "showTab",
    value: function showTab() {
      var _this = this;
      this.tabTargets.forEach(function(tab, index) {
        var panel = _this.panelTargets[index];
        if (index === _this.index) {
          var _tab$classList;
          panel.classList.remove("hidden");
          (_tab$classList = tab.classList).add.apply(_tab$classList, _toConsumableArray(_this.activeTabClasses));
        } else {
          var _tab$classList2;
          panel.classList.add("hidden");
          (_tab$classList2 = tab.classList).remove.apply(_tab$classList2, _toConsumableArray(_this.activeTabClasses));
        }
      });
    }
  }, {
    key: "index",
    get: function get() {
      return parseInt(this.data.get("index") || 0);
    },
    set: function set(value) {
      this.data.set("index", value);
      this.showTab();
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$9, "targets", [ "tab", "panel" ]);

var highchartsMore = createCommonjsModule(function(module) {
  (function(f) {
    module.exports ? (f["default"] = f, module.exports = f) : f("undefined" !== typeof Highcharts ? Highcharts : void 0);
  })(function(f) {
    function E(l, a, c, b) {
      l.hasOwnProperty(a) || (l[a] = b.apply(null, c));
    }
    f = f ? f._modules : {};
    E(f, "parts-more/Pane.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      function c(d, b, n) {
        return Math.sqrt(Math.pow(d - n[0], 2) + Math.pow(b - n[1], 2)) < n[2] / 2;
      }
      var b = a.addEvent, u = a.extend, v = a.merge, w = a.pick, f = a.splat, y = l.CenteredSeriesMixin;
      l.Chart.prototype.collectionsWithUpdate.push("pane");
      a = function() {
        function d(d, b) {
          this.options = this.chart = this.center = this.background = void 0;
          this.coll = "pane";
          this.defaultOptions = {
            center: [ "50%", "50%" ],
            size: "85%",
            innerSize: "0%",
            startAngle: 0
          };
          this.defaultBackgroundOptions = {
            shape: "circle",
            borderWidth: 1,
            borderColor: "#cccccc",
            backgroundColor: {
              linearGradient: {
                x1: 0,
                y1: 0,
                x2: 0,
                y2: 1
              },
              stops: [ [ 0, "#ffffff" ], [ 1, "#e6e6e6" ] ]
            },
            from: -Number.MAX_VALUE,
            innerRadius: 0,
            to: Number.MAX_VALUE,
            outerRadius: "105%"
          };
          this.init(d, b);
        }
        d.prototype.init = function(d, b) {
          this.chart = b;
          this.background = [];
          b.pane.push(this);
          this.setOptions(d);
        };
        d.prototype.setOptions = function(d) {
          this.options = v(this.defaultOptions, this.chart.angular ? {
            background: {}
          } : void 0, d);
        };
        d.prototype.render = function() {
          var d = this.options, b = this.options.background, a = this.chart.renderer;
          this.group || (this.group = a.g("pane-group").attr({
            zIndex: d.zIndex || 0
          }).add());
          this.updateCenter();
          if (b) for (b = f(b), d = Math.max(b.length, this.background.length || 0), a = 0; a < d; a++) b[a] && this.axis ? this.renderBackground(v(this.defaultBackgroundOptions, b[a]), a) : this.background[a] && (this.background[a] = this.background[a].destroy(), 
          this.background.splice(a, 1));
        };
        d.prototype.renderBackground = function(d, b) {
          var a = "animate", n = {
            class: "highcharts-pane " + (d.className || "")
          };
          this.chart.styledMode || u(n, {
            fill: d.backgroundColor,
            stroke: d.borderColor,
            "stroke-width": d.borderWidth
          });
          this.background[b] || (this.background[b] = this.chart.renderer.path().add(this.group), 
          a = "attr");
          this.background[b][a]({
            d: this.axis.getPlotBandPath(d.from, d.to, d)
          }).attr(n);
        };
        d.prototype.updateCenter = function(d) {
          this.center = (d || this.axis || {}).center = y.getCenter.call(this);
        };
        d.prototype.update = function(d, b) {
          v(!0, this.options, d);
          v(!0, this.chart.options.pane, d);
          this.setOptions(this.options);
          this.render();
          this.chart.axes.forEach(function(d) {
            d.pane === this && (d.pane = null, d.update({}, b));
          }, this);
        };
        return d;
      }();
      l.Chart.prototype.getHoverPane = function(d) {
        var b = this, a;
        d && b.pane.forEach(function(n) {
          var m = d.chartX - b.plotLeft, t = d.chartY - b.plotTop;
          c(b.inverted ? t : m, b.inverted ? m : t, n.center) && (a = n);
        });
        return a;
      };
      b(l.Chart, "afterIsInsidePlot", function(d) {
        this.polar && (d.isInsidePlot = this.pane.some(function(b) {
          return c(d.x, d.y, b.center);
        }));
      });
      b(l.Pointer, "beforeGetHoverData", function(d) {
        var b = this.chart;
        b.polar && (b.hoverPane = b.getHoverPane(d), d.filter = function(a) {
          return a.visible && !(!d.shared && a.directTouch) && w(a.options.enableMouseTracking, !0) && (!b.hoverPane || a.xAxis.pane === b.hoverPane);
        });
      });
      b(l.Pointer, "afterGetHoverData", function(d) {
        var b = this.chart;
        d.hoverPoint && d.hoverPoint.plotX && d.hoverPoint.plotY && b.hoverPane && !c(d.hoverPoint.plotX, d.hoverPoint.plotY, b.hoverPane.center) && (d.hoverPoint = void 0);
      });
      l.Pane = a;
      return l.Pane;
    });
    E(f, "parts-more/RadialAxis.js", [ f["parts/Globals.js"], f["parts/Tick.js"], f["parts/Utilities.js"] ], function(l, a, c) {
      var b = c.addEvent, u = c.correctFloat, v = c.defined, w = c.extend, f = c.merge, y = c.pick, d = c.pInt, m = c.relativeLength;
      c = c.wrap;
      var n = l.Axis, t = l.noop, x = n.prototype, A = a.prototype;
      var r = {
        getOffset: t,
        redraw: function() {
          this.isDirty = !1;
        },
        render: function() {
          this.isDirty = !1;
        },
        createLabelCollector: function() {
          return !1;
        },
        setScale: t,
        setCategories: t,
        setTitle: t
      };
      var p = {
        defaultRadialGaugeOptions: {
          labels: {
            align: "center",
            x: 0,
            y: null
          },
          minorGridLineWidth: 0,
          minorTickInterval: "auto",
          minorTickLength: 10,
          minorTickPosition: "inside",
          minorTickWidth: 1,
          tickLength: 10,
          tickPosition: "inside",
          tickWidth: 2,
          title: {
            rotation: 0
          },
          zIndex: 2
        },
        defaultCircularOptions: {
          gridLineWidth: 1,
          labels: {
            align: null,
            distance: 15,
            x: 0,
            y: null,
            style: {
              textOverflow: "none"
            }
          },
          maxPadding: 0,
          minPadding: 0,
          showLastLabel: !1,
          tickLength: 0
        },
        defaultRadialOptions: {
          gridLineInterpolation: "circle",
          gridLineWidth: 1,
          labels: {
            align: "right",
            x: -3,
            y: -2
          },
          showLastLabel: !1,
          title: {
            x: 4,
            text: null,
            rotation: 90
          }
        },
        setOptions: function(h) {
          h = this.options = f(this.defaultOptions, this.defaultPolarOptions, h);
          h.plotBands || (h.plotBands = []);
          l.fireEvent(this, "afterSetOptions");
        },
        getOffset: function() {
          x.getOffset.call(this);
          this.chart.axisOffset[this.side] = 0;
        },
        getLinePath: function(h, g, e) {
          h = this.pane.center;
          var k = this.chart, p = y(g, h[2] / 2 - this.offset);
          "undefined" === typeof e && (e = this.horiz ? 0 : this.center && -this.center[3] / 2);
          e && (p += e);
          this.isCircular || "undefined" !== typeof g ? (g = this.chart.renderer.symbols.arc(this.left + h[0], this.top + h[1], p, p, {
            start: this.startAngleRad,
            end: this.endAngleRad,
            open: !0,
            innerR: 0
          }), g.xBounds = [ this.left + h[0] ], g.yBounds = [ this.top + h[1] - p ]) : (g = this.postTranslate(this.angleRad, p), 
          g = [ "M", this.center[0] + k.plotLeft, this.center[1] + k.plotTop, "L", g.x, g.y ]);
          return g;
        },
        setAxisTranslation: function() {
          x.setAxisTranslation.call(this);
          this.center && (this.transA = this.isCircular ? (this.endAngleRad - this.startAngleRad) / (this.max - this.min || 1) : (this.center[2] - this.center[3]) / 2 / (this.max - this.min || 1), 
          this.minPixelPadding = this.isXAxis ? this.transA * this.minPointOffset : 0);
        },
        beforeSetTickPositions: function() {
          this.autoConnect = this.isCircular && "undefined" === typeof y(this.userMax, this.options.max) && u(this.endAngleRad - this.startAngleRad) === u(2 * Math.PI);
          !this.isCircular && this.chart.inverted && this.max++;
          this.autoConnect && (this.max += this.categories && 1 || this.pointRange || this.closestPointRange || 0);
        },
        setAxisSize: function() {
          x.setAxisSize.call(this);
          if (this.isRadial) {
            this.pane.updateCenter(this);
            var h = this.center = w([], this.pane.center);
            if (this.isCircular) this.sector = this.endAngleRad - this.startAngleRad; else {
              var g = this.postTranslate(this.angleRad, h[3] / 2);
              h[0] = g.x - this.chart.plotLeft;
              h[1] = g.y - this.chart.plotTop;
            }
            this.len = this.width = this.height = (h[2] - h[3]) * y(this.sector, 1) / 2;
          }
        },
        getPosition: function(h, g) {
          h = this.translate(h);
          return this.postTranslate(this.isCircular ? h : this.angleRad, y(this.isCircular ? g : 0 > h ? 0 : h, this.center[2] / 2) - this.offset);
        },
        postTranslate: function(h, g) {
          var e = this.chart, k = this.center;
          h = this.startAngleRad + h;
          return {
            x: e.plotLeft + k[0] + Math.cos(h) * g,
            y: e.plotTop + k[1] + Math.sin(h) * g
          };
        },
        getPlotBandPath: function(h, g, e) {
          var k = this.center, p = this.startAngleRad, C = k[2] / 2, q = [ y(e.outerRadius, "100%"), e.innerRadius, y(e.thickness, 10) ], r = Math.min(this.offset, 0), b = /%$/;
          var a = this.isCircular;
          if ("polygon" === this.options.gridLineInterpolation) q = this.getPlotLinePath({
            value: h
          }).concat(this.getPlotLinePath({
            value: g,
            reverse: !0
          })); else {
            h = Math.max(h, this.min);
            g = Math.min(g, this.max);
            a || (q[0] = this.translate(h), q[1] = this.translate(g));
            q = q.map(function(e) {
              b.test(e) && (e = d(e, 10) * C / 100);
              return e;
            });
            if ("circle" !== e.shape && a) h = p + this.translate(h), g = p + this.translate(g); else {
              h = -Math.PI / 2;
              g = 1.5 * Math.PI;
              var n = !0;
            }
            q[0] -= r;
            q[2] -= r;
            q = this.chart.renderer.symbols.arc(this.left + k[0], this.top + k[1], q[0], q[0], {
              start: Math.min(h, g),
              end: Math.max(h, g),
              innerR: y(q[1], q[0] - q[2]),
              open: n
            });
            a && (a = (g + h) / 2, r = this.left + k[0] + k[2] / 2 * Math.cos(a), q.xBounds = a > -Math.PI / 2 && a < Math.PI / 2 ? [ r, this.chart.plotWidth ] : [ 0, r ], 
            q.yBounds = [ this.top + k[1] + k[2] / 2 * Math.sin(a) ], q.yBounds[0] += a > -Math.PI && 0 > a || a > Math.PI ? -10 : 10);
          }
          return q;
        },
        getCrosshairPosition: function(h, g, e) {
          var k = h.value, p = this.pane.center;
          if (this.isCircular) {
            if (v(k)) h.point && (d = h.point.shapeArgs || {}, d.start && (k = this.chart.inverted ? this.translate(h.point.rectPlotY, !0) : h.point.x)); else {
              var d = h.chartX || 0;
              var q = h.chartY || 0;
              k = this.translate(Math.atan2(q - e, d - g) - this.startAngleRad, !0);
            }
            h = this.getPosition(k);
            d = h.x;
            q = h.y;
          } else v(k) || (d = h.chartX, q = h.chartY), v(d) && v(q) && (e = p[1] + this.chart.plotTop, 
          k = this.translate(Math.min(Math.sqrt(Math.pow(d - g, 2) + Math.pow(q - e, 2)), p[2] / 2) - p[3] / 2, !0));
          return [ k, d || 0, q || 0 ];
        },
        getPlotLinePath: function(h) {
          var g = this, e = g.pane.center, k = g.chart, p = k.inverted, d = h.value, q = h.reverse, r = g.getPosition(d), b = g.pane.options.background ? g.pane.options.background[0] || g.pane.options.background : {}, a = b.innerRadius || "0%", n = b.outerRadius || "100%";
          b = e[0] + k.plotLeft;
          var c = e[1] + k.plotTop, t = r.x, x = r.y, u = g.height;
          r = e[3] / 2;
          var v, l;
          h.isCrosshair && (x = this.getCrosshairPosition(h, b, c), d = x[0], t = x[1], x = x[2]);
          if (g.isCircular) {
            q = Math.sqrt(Math.pow(t - b, 2) + Math.pow(x - c, 2));
            a = "string" === typeof a ? m(a, 1) : a / q;
            n = "string" === typeof n ? m(n, 1) : n / q;
            e && r && (e = r / q, a < e && (a = e), n < e && (n = e));
            var w = [ "M", b + a * (t - b), c - a * (c - x), "L", t - (1 - n) * (t - b), x + (1 - n) * (c - x) ];
          } else (d = g.translate(d)) && (0 > d || d > u) && (d = 0), "circle" === g.options.gridLineInterpolation ? w = g.getLinePath(0, d, r) : (k[p ? "yAxis" : "xAxis"].forEach(function(e) {
            e.pane === g.pane && (v = e);
          }), w = [], e = v.tickPositions, v.autoConnect && (e = e.concat([ e[0] ])), q && (e = [].concat(e).reverse()), 
          d && (d += r), e.forEach(function(e, k) {
            l = v.getPosition(e, d);
            w.push(k ? "L" : "M", l.x, l.y);
          }));
          return w;
        },
        getTitlePosition: function() {
          var h = this.center, g = this.chart, e = this.options.title;
          return {
            x: g.plotLeft + h[0] + (e.x || 0),
            y: g.plotTop + h[1] - {
              high: .5,
              middle: .25,
              low: 0
            }[e.align] * h[2] + (e.y || 0)
          };
        },
        createLabelCollector: function() {
          var h = this;
          return function() {
            if (h.isRadial && h.tickPositions && !0 !== h.options.labels.allowOverlap) return h.tickPositions.map(function(g) {
              return h.ticks[g] && h.ticks[g].label;
            }).filter(function(g) {
              return !!g;
            });
          };
        }
      };
      b(n, "init", function(h) {
        var g = this.chart, e = g.inverted, k = g.angular, d = g.polar, b = this.isXAxis, q = this.coll, a = k && b, n, c = g.options;
        h = h.userOptions.pane || 0;
        h = this.pane = g.pane && g.pane[h];
        if ("colorAxis" === q) this.isRadial = !1; else {
          if (k) {
            if (w(this, a ? r : p), n = !b) this.defaultPolarOptions = this.defaultRadialGaugeOptions;
          } else d && (w(this, p), this.defaultPolarOptions = (n = this.horiz) ? this.defaultCircularOptions : f("xAxis" === q ? this.defaultOptions : this.defaultYAxisOptions, this.defaultRadialOptions), 
          e && "yAxis" === q && (this.defaultPolarOptions.stackLabels = this.defaultYAxisOptions.stackLabels));
          k || d ? (this.isRadial = !0, c.chart.zoomType = null, this.labelCollector || (this.labelCollector = this.createLabelCollector()), 
          this.labelCollector && g.labelCollectors.push(this.labelCollector)) : this.isRadial = !1;
          h && n && (h.axis = this);
          this.isCircular = n;
        }
      });
      b(n, "afterInit", function() {
        var h = this.chart, g = this.options, e = this.pane, k = e && e.options;
        h.angular && this.isXAxis || !e || !h.angular && !h.polar || (this.angleRad = (g.angle || 0) * Math.PI / 180, 
        this.startAngleRad = (k.startAngle - 90) * Math.PI / 180, this.endAngleRad = (y(k.endAngle, k.startAngle + 360) - 90) * Math.PI / 180, 
        this.offset = g.offset || 0);
      });
      b(n, "autoLabelAlign", function(h) {
        this.isRadial && (h.align = void 0, h.preventDefault());
      });
      b(n, "destroy", function() {
        if (this.chart && this.chart.labelCollectors) {
          var h = this.chart.labelCollectors.indexOf(this.labelCollector);
          0 <= h && this.chart.labelCollectors.splice(h, 1);
        }
      });
      b(a, "afterGetPosition", function(h) {
        this.axis.getPosition && w(h.pos, this.axis.getPosition(this.pos));
      });
      b(a, "afterGetLabelPosition", function(h) {
        var g = this.axis, e = this.label, k = e.getBBox(), d = g.options.labels, p = d.y, q = 20, r = d.align, b = (g.translate(this.pos) + g.startAngleRad + Math.PI / 2) / Math.PI * 180 % 360, a = Math.round(b), n = "end", c = 0 > a ? a + 360 : a, x = c, t = 0, u = 0, v = null === d.y ? .3 * -k.height : 0;
        if (g.isRadial) {
          var l = g.getPosition(this.pos, g.center[2] / 2 + m(y(d.distance, -25), g.center[2] / 2, -g.center[2] / 2));
          "auto" === d.rotation ? e.attr({
            rotation: b
          }) : null === p && (p = g.chart.renderer.fontMetrics(e.styles && e.styles.fontSize).b - k.height / 2);
          null === r && (g.isCircular ? (k.width > g.len * g.tickInterval / (g.max - g.min) && (q = 0), 
          r = b > q && b < 180 - q ? "left" : b > 180 + q && b < 360 - q ? "right" : "center") : r = "center", 
          e.attr({
            align: r
          }));
          if ("auto" === r && 2 === g.tickPositions.length && g.isCircular) {
            90 < c && 180 > c ? c = 180 - c : 270 < c && 360 >= c && (c = 540 - c);
            180 < x && 360 >= x && (x = 360 - x);
            if (g.pane.options.startAngle === a || g.pane.options.startAngle === a + 360 || g.pane.options.startAngle === a - 360) n = "start";
            r = -90 <= a && 90 >= a || -360 <= a && -270 >= a || 270 <= a && 360 >= a ? "start" === n ? "right" : "left" : "start" === n ? "left" : "right";
            70 < x && 110 > x && (r = "center");
            15 > c || 180 <= c && 195 > c ? t = .3 * k.height : 15 <= c && 35 >= c ? t = "start" === n ? 0 : .75 * k.height : 195 <= c && 215 >= c ? t = "start" === n ? .75 * k.height : 0 : 35 < c && 90 >= c ? t = "start" === n ? .25 * -k.height : k.height : 215 < c && 270 >= c && (t = "start" === n ? k.height : .25 * -k.height);
            15 > x ? u = "start" === n ? .15 * -k.height : .15 * k.height : 165 < x && 180 >= x && (u = "start" === n ? .15 * k.height : .15 * -k.height);
            e.attr({
              align: r
            });
            e.translate(u, t + v);
          }
          h.pos.x = l.x + d.x;
          h.pos.y = l.y + p;
        }
      });
      c(A, "getMarkPath", function(h, g, e, k, d, p, q) {
        var r = this.axis;
        r.isRadial ? (h = r.getPosition(this.pos, r.center[2] / 2 + k), g = [ "M", g, e, "L", h.x, h.y ]) : g = h.call(this, g, e, k, d, p, q);
        return g;
      });
    });
    E(f, "parts-more/AreaRangeSeries.js", [ f["parts/Globals.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(l, a, c) {
      var b = c.defined, u = c.extend, v = c.isArray, w = c.isNumber, f = c.pick;
      c = c.seriesType;
      var y = l.seriesTypes, d = l.Series.prototype, m = a.prototype;
      c("arearange", "area", {
        lineWidth: 1,
        threshold: null,
        tooltip: {
          pointFormat: '<span style="color:{series.color}">●</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'
        },
        trackByArea: !0,
        dataLabels: {
          align: null,
          verticalAlign: null,
          xLow: 0,
          xHigh: 0,
          yLow: 0,
          yHigh: 0
        }
      }, {
        pointArrayMap: [ "low", "high" ],
        pointValKey: "low",
        deferTranslatePolar: !0,
        toYData: function(d) {
          return [ d.low, d.high ];
        },
        highToXY: function(d) {
          var b = this.chart, a = this.xAxis.postTranslate(d.rectPlotX, this.yAxis.len - d.plotHigh);
          d.plotHighX = a.x - b.plotLeft;
          d.plotHigh = a.y - b.plotTop;
          d.plotLowX = d.plotX;
        },
        translate: function() {
          var d = this, b = d.yAxis, a = !!d.modifyValue;
          y.area.prototype.translate.apply(d);
          d.points.forEach(function(c) {
            var r = c.high, p = c.plotY;
            c.isNull ? c.plotY = null : (c.plotLow = p, c.plotHigh = b.translate(a ? d.modifyValue(r, c) : r, 0, 1, 0, 1), 
            a && (c.yBottom = c.plotHigh));
          });
          this.chart.polar && this.points.forEach(function(b) {
            d.highToXY(b);
            b.tooltipPos = [ (b.plotHighX + b.plotLowX) / 2, (b.plotHigh + b.plotLow) / 2 ];
          });
        },
        getGraphPath: function(d) {
          var b = [], a = [], c, r = y.area.prototype.getGraphPath;
          var p = this.options;
          var h = this.chart.polar && !1 !== p.connectEnds, g = p.connectNulls, e = p.step;
          d = d || this.points;
          for (c = d.length; c--; ) {
            var k = d[c];
            k.isNull || h || g || d[c + 1] && !d[c + 1].isNull || a.push({
              plotX: k.plotX,
              plotY: k.plotY,
              doCurve: !1
            });
            var B = {
              polarPlotY: k.polarPlotY,
              rectPlotX: k.rectPlotX,
              yBottom: k.yBottom,
              plotX: f(k.plotHighX, k.plotX),
              plotY: k.plotHigh,
              isNull: k.isNull
            };
            a.push(B);
            b.push(B);
            k.isNull || h || g || d[c - 1] && !d[c - 1].isNull || a.push({
              plotX: k.plotX,
              plotY: k.plotY,
              doCurve: !1
            });
          }
          d = r.call(this, d);
          e && (!0 === e && (e = "left"), p.step = {
            left: "right",
            center: "center",
            right: "left"
          }[e]);
          b = r.call(this, b);
          a = r.call(this, a);
          p.step = e;
          p = [].concat(d, b);
          this.chart.polar || "M" !== a[0] || (a[0] = "L");
          this.graphPath = p;
          this.areaPath = d.concat(a);
          p.isArea = !0;
          p.xMap = d.xMap;
          this.areaPath.xMap = d.xMap;
          return p;
        },
        drawDataLabels: function() {
          var b = this.points, a = b.length, c, m = [], r = this.options.dataLabels, p, h = this.chart.inverted;
          if (v(r)) {
            if (1 < r.length) {
              var g = r[0];
              var e = r[1];
            } else g = r[0], e = {
              enabled: !1
            };
          } else g = u({}, r), g.x = r.xHigh, g.y = r.yHigh, e = u({}, r), e.x = r.xLow, e.y = r.yLow;
          if (g.enabled || this._hasPointLabels) {
            for (c = a; c--; ) if (p = b[c]) {
              var k = g.inside ? p.plotHigh < p.plotLow : p.plotHigh > p.plotLow;
              p.y = p.high;
              p._plotY = p.plotY;
              p.plotY = p.plotHigh;
              m[c] = p.dataLabel;
              p.dataLabel = p.dataLabelUpper;
              p.below = k;
              h ? g.align || (g.align = k ? "right" : "left") : g.verticalAlign || (g.verticalAlign = k ? "top" : "bottom");
            }
            this.options.dataLabels = g;
            d.drawDataLabels && d.drawDataLabels.apply(this, arguments);
            for (c = a; c--; ) if (p = b[c]) p.dataLabelUpper = p.dataLabel, p.dataLabel = m[c], 
            delete p.dataLabels, p.y = p.low, p.plotY = p._plotY;
          }
          if (e.enabled || this._hasPointLabels) {
            for (c = a; c--; ) if (p = b[c]) k = e.inside ? p.plotHigh < p.plotLow : p.plotHigh > p.plotLow, 
            p.below = !k, h ? e.align || (e.align = k ? "left" : "right") : e.verticalAlign || (e.verticalAlign = k ? "bottom" : "top");
            this.options.dataLabels = e;
            d.drawDataLabels && d.drawDataLabels.apply(this, arguments);
          }
          if (g.enabled) for (c = a; c--; ) if (p = b[c]) p.dataLabels = [ p.dataLabelUpper, p.dataLabel ].filter(function(e) {
            return !!e;
          });
          this.options.dataLabels = r;
        },
        alignDataLabel: function() {
          y.column.prototype.alignDataLabel.apply(this, arguments);
        },
        drawPoints: function() {
          var a = this.points.length, c;
          d.drawPoints.apply(this, arguments);
          for (c = 0; c < a; ) {
            var m = this.points[c];
            m.origProps = {
              plotY: m.plotY,
              plotX: m.plotX,
              isInside: m.isInside,
              negative: m.negative,
              zone: m.zone,
              y: m.y
            };
            m.lowerGraphic = m.graphic;
            m.graphic = m.upperGraphic;
            m.plotY = m.plotHigh;
            b(m.plotHighX) && (m.plotX = m.plotHighX);
            m.y = m.high;
            m.negative = m.high < (this.options.threshold || 0);
            m.zone = this.zones.length && m.getZone();
            this.chart.polar || (m.isInside = m.isTopInside = "undefined" !== typeof m.plotY && 0 <= m.plotY && m.plotY <= this.yAxis.len && 0 <= m.plotX && m.plotX <= this.xAxis.len);
            c++;
          }
          d.drawPoints.apply(this, arguments);
          for (c = 0; c < a; ) m = this.points[c], m.upperGraphic = m.graphic, m.graphic = m.lowerGraphic, 
          u(m, m.origProps), delete m.origProps, c++;
        },
        setStackedPoints: l.noop
      }, {
        setState: function() {
          var d = this.state, a = this.series, c = a.chart.polar;
          b(this.plotHigh) || (this.plotHigh = a.yAxis.toPixels(this.high, !0));
          b(this.plotLow) || (this.plotLow = this.plotY = a.yAxis.toPixels(this.low, !0));
          a.stateMarkerGraphic && (a.lowerStateMarkerGraphic = a.stateMarkerGraphic, a.stateMarkerGraphic = a.upperStateMarkerGraphic);
          this.graphic = this.upperGraphic;
          this.plotY = this.plotHigh;
          c && (this.plotX = this.plotHighX);
          m.setState.apply(this, arguments);
          this.state = d;
          this.plotY = this.plotLow;
          this.graphic = this.lowerGraphic;
          c && (this.plotX = this.plotLowX);
          a.stateMarkerGraphic && (a.upperStateMarkerGraphic = a.stateMarkerGraphic, a.stateMarkerGraphic = a.lowerStateMarkerGraphic, 
          a.lowerStateMarkerGraphic = void 0);
          m.setState.apply(this, arguments);
        },
        haloPath: function() {
          var d = this.series.chart.polar, a = [];
          this.plotY = this.plotLow;
          d && (this.plotX = this.plotLowX);
          this.isInside && (a = m.haloPath.apply(this, arguments));
          this.plotY = this.plotHigh;
          d && (this.plotX = this.plotHighX);
          this.isTopInside && (a = a.concat(m.haloPath.apply(this, arguments)));
          return a;
        },
        destroyElements: function() {
          [ "lowerGraphic", "upperGraphic" ].forEach(function(d) {
            this[d] && (this[d] = this[d].destroy());
          }, this);
          this.graphic = null;
          return m.destroyElements.apply(this, arguments);
        },
        isValid: function() {
          return w(this.low) && w(this.high);
        }
      });
    });
    E(f, "parts-more/AreaSplineRangeSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      a = a.seriesType;
      a("areasplinerange", "arearange", null, {
        getPointSpline: l.seriesTypes.spline.prototype.getPointSpline
      });
    });
    E(f, "parts-more/ColumnRangeSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      var c = a.clamp, b = a.merge, u = a.pick;
      a = a.seriesType;
      var v = l.defaultPlotOptions, w = l.noop, f = l.seriesTypes.column.prototype;
      a("columnrange", "arearange", b(v.column, v.arearange, {
        pointRange: null,
        marker: null,
        states: {
          hover: {
            halo: !1
          }
        }
      }), {
        translate: function() {
          var a = this, d = a.yAxis, b = a.xAxis, n = b.startAngleRad, v, l = a.chart, w = a.xAxis.isRadial, r = Math.max(l.chartWidth, l.chartHeight) + 999, p;
          f.translate.apply(a);
          a.points.forEach(function(h) {
            var g = h.shapeArgs, e = a.options.minPointLength;
            h.plotHigh = p = c(d.translate(h.high, 0, 1, 0, 1), -r, r);
            h.plotLow = c(h.plotY, -r, r);
            var k = p;
            var B = u(h.rectPlotY, h.plotY) - p;
            Math.abs(B) < e ? (e -= B, B += e, k -= e / 2) : 0 > B && (B *= -1, k -= B);
            w ? (v = h.barX + n, h.shapeType = "arc", h.shapeArgs = a.polarArc(k + B, k, v, v + h.pointWidth)) : (g.height = B, 
            g.y = k, h.tooltipPos = l.inverted ? [ d.len + d.pos - l.plotLeft - k - B / 2, b.len + b.pos - l.plotTop - g.x - g.width / 2, B ] : [ b.left - l.plotLeft + g.x + g.width / 2, d.pos - l.plotTop + k + B / 2, B ]);
          });
        },
        directTouch: !0,
        trackerGroups: [ "group", "dataLabelsGroup" ],
        drawGraph: w,
        getSymbol: w,
        crispCol: function() {
          return f.crispCol.apply(this, arguments);
        },
        drawPoints: function() {
          return f.drawPoints.apply(this, arguments);
        },
        drawTracker: function() {
          return f.drawTracker.apply(this, arguments);
        },
        getColumnMetrics: function() {
          return f.getColumnMetrics.apply(this, arguments);
        },
        pointAttribs: function() {
          return f.pointAttribs.apply(this, arguments);
        },
        animate: function() {
          return f.animate.apply(this, arguments);
        },
        polarArc: function() {
          return f.polarArc.apply(this, arguments);
        },
        translate3dPoints: function() {
          return f.translate3dPoints.apply(this, arguments);
        },
        translate3dShapes: function() {
          return f.translate3dShapes.apply(this, arguments);
        }
      }, {
        setState: f.pointClass.prototype.setState
      });
    });
    E(f, "parts-more/ColumnPyramidSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      var c = a.clamp, b = a.pick;
      a = a.seriesType;
      var u = l.seriesTypes.column.prototype;
      a("columnpyramid", "column", {}, {
        translate: function() {
          var a = this, l = a.chart, f = a.options, y = a.dense = 2 > a.closestPointRange * a.xAxis.transA;
          y = a.borderWidth = b(f.borderWidth, y ? 0 : 1);
          var d = a.yAxis, m = f.threshold, n = a.translatedThreshold = d.getThreshold(m), t = b(f.minPointLength, 5), x = a.getColumnMetrics(), A = x.width, r = a.barW = Math.max(A, 1 + 2 * y), p = a.pointXOffset = x.offset;
          l.inverted && (n -= .5);
          f.pointPadding && (r = Math.ceil(r));
          u.translate.apply(a);
          a.points.forEach(function(h) {
            var g = b(h.yBottom, n), e = 999 + Math.abs(g), k = c(h.plotY, -e, d.len + e);
            e = h.plotX + p;
            var B = r / 2, C = Math.min(k, g);
            g = Math.max(k, g) - C;
            var q;
            h.barX = e;
            h.pointWidth = A;
            h.tooltipPos = l.inverted ? [ d.len + d.pos - l.plotLeft - k, a.xAxis.len - e - B, g ] : [ e + B, k + d.pos - l.plotTop, g ];
            k = m + (h.total || h.y);
            "percent" === f.stacking && (k = m + (0 > h.y) ? -100 : 100);
            k = d.toPixels(k, !0);
            var F = (q = l.plotHeight - k - (l.plotHeight - n)) ? B * (C - k) / q : 0;
            var G = q ? B * (C + g - k) / q : 0;
            q = e - F + B;
            F = e + F + B;
            var u = e + G + B;
            G = e - G + B;
            var v = C - t;
            var w = C + g;
            0 > h.y && (v = C, w = C + g + t);
            l.inverted && (u = l.plotWidth - C, q = k - (l.plotWidth - n), F = B * (k - u) / q, 
            G = B * (k - (u - g)) / q, q = e + B + F, F = q - 2 * F, u = e - G + B, G = e + G + B, 
            v = C, w = C + g - t, 0 > h.y && (w = C + g + t));
            h.shapeType = "path";
            h.shapeArgs = {
              x: q,
              y: v,
              width: F - q,
              height: g,
              d: [ "M", q, v, "L", F, v, u, w, G, w, "Z" ]
            };
          });
        }
      });
    });
    E(f, "parts-more/GaugeSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      var c = a.clamp, b = a.isNumber, u = a.merge, v = a.pick, f = a.pInt;
      a = a.seriesType;
      var z = l.Series, y = l.TrackerMixin;
      a("gauge", "line", {
        dataLabels: {
          borderColor: "#cccccc",
          borderRadius: 3,
          borderWidth: 1,
          crop: !1,
          defer: !1,
          enabled: !0,
          verticalAlign: "top",
          y: 15,
          zIndex: 2
        },
        dial: {},
        pivot: {},
        tooltip: {
          headerFormat: ""
        },
        showInLegend: !1
      }, {
        angular: !0,
        directTouch: !0,
        drawGraph: l.noop,
        fixedBox: !0,
        forceDL: !0,
        noSharedTooltip: !0,
        trackerGroups: [ "group", "dataLabelsGroup" ],
        translate: function() {
          var d = this.yAxis, a = this.options, n = d.center;
          this.generatePoints();
          this.points.forEach(function(m) {
            var l = u(a.dial, m.dial), t = f(v(l.radius, "80%")) * n[2] / 200, r = f(v(l.baseLength, "70%")) * t / 100, p = f(v(l.rearLength, "10%")) * t / 100, h = l.baseWidth || 3, g = l.topWidth || 1, e = a.overshoot, k = d.startAngleRad + d.translate(m.y, null, null, null, !0);
            if (b(e) || !1 === a.wrap) e = b(e) ? e / 180 * Math.PI : 0, k = c(k, d.startAngleRad - e, d.endAngleRad + e);
            k = 180 * k / Math.PI;
            m.shapeType = "path";
            m.shapeArgs = {
              d: l.path || [ "M", -p, -h / 2, "L", r, -h / 2, t, -g / 2, t, g / 2, r, h / 2, -p, h / 2, "z" ],
              translateX: n[0],
              translateY: n[1],
              rotation: k
            };
            m.plotX = n[0];
            m.plotY = n[1];
          });
        },
        drawPoints: function() {
          var d = this, a = d.chart, b = d.yAxis.center, c = d.pivot, l = d.options, f = l.pivot, r = a.renderer;
          d.points.forEach(function(b) {
            var h = b.graphic, g = b.shapeArgs, e = g.d, k = u(l.dial, b.dial);
            h ? (h.animate(g), g.d = e) : b.graphic = r[b.shapeType](g).attr({
              rotation: g.rotation,
              zIndex: 1
            }).addClass("highcharts-dial").add(d.group);
            if (!a.styledMode) b.graphic[h ? "animate" : "attr"]({
              stroke: k.borderColor || "none",
              "stroke-width": k.borderWidth || 0,
              fill: k.backgroundColor || "#000000"
            });
          });
          c ? c.animate({
            translateX: b[0],
            translateY: b[1]
          }) : (d.pivot = r.circle(0, 0, v(f.radius, 5)).attr({
            zIndex: 2
          }).addClass("highcharts-pivot").translate(b[0], b[1]).add(d.group), a.styledMode || d.pivot.attr({
            "stroke-width": f.borderWidth || 0,
            stroke: f.borderColor || "#cccccc",
            fill: f.backgroundColor || "#000000"
          }));
        },
        animate: function(d) {
          var a = this;
          d || a.points.forEach(function(d) {
            var b = d.graphic;
            b && (b.attr({
              rotation: 180 * a.yAxis.startAngleRad / Math.PI
            }), b.animate({
              rotation: d.shapeArgs.rotation
            }, a.options.animation));
          });
        },
        render: function() {
          this.group = this.plotGroup("group", "series", this.visible ? "visible" : "hidden", this.options.zIndex, this.chart.seriesGroup);
          z.prototype.render.call(this);
          this.group.clip(this.chart.clipRect);
        },
        setData: function(d, a) {
          z.prototype.setData.call(this, d, !1);
          this.processData();
          this.generatePoints();
          v(a, !0) && this.chart.redraw();
        },
        hasData: function() {
          return !!this.points.length;
        },
        drawTracker: y && y.drawTrackerPoint
      }, {
        setState: function(d) {
          this.state = d;
        }
      });
    });
    E(f, "parts-more/BoxPlotSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      var c = a.pick;
      a = a.seriesType;
      var b = l.noop, u = l.seriesTypes;
      a("boxplot", "column", {
        threshold: null,
        tooltip: {
          pointFormat: '<span style="color:{point.color}">●</span> <b> {series.name}</b><br/>Maximum: {point.high}<br/>Upper quartile: {point.q3}<br/>Median: {point.median}<br/>Lower quartile: {point.q1}<br/>Minimum: {point.low}<br/>'
        },
        whiskerLength: "50%",
        fillColor: "#ffffff",
        lineWidth: 1,
        medianWidth: 2,
        whiskerWidth: 2
      }, {
        pointArrayMap: [ "low", "q1", "median", "q3", "high" ],
        toYData: function(a) {
          return [ a.low, a.q1, a.median, a.q3, a.high ];
        },
        pointValKey: "high",
        pointAttribs: function() {
          return {};
        },
        drawDataLabels: b,
        translate: function() {
          var a = this.yAxis, b = this.pointArrayMap;
          u.column.prototype.translate.apply(this);
          this.points.forEach(function(c) {
            b.forEach(function(b) {
              null !== c[b] && (c[b + "Plot"] = a.translate(c[b], 0, 1, 0, 1));
            });
            c.plotHigh = c.highPlot;
          });
        },
        drawPoints: function() {
          var a = this, b = a.options, l = a.chart, u = l.renderer, d, m, n, f, x, A, r = 0, p, h, g, e, k = !1 !== a.doQuartiles, B, C = a.options.whiskerLength;
          a.points.forEach(function(q) {
            var F = q.graphic, G = F ? "animate" : "attr", K = q.shapeArgs, v = {}, t = {}, H = {}, J = {}, I = q.color || a.color;
            "undefined" !== typeof q.plotY && (p = K.width, h = Math.floor(K.x), g = h + p, 
            e = Math.round(p / 2), d = Math.floor(k ? q.q1Plot : q.lowPlot), m = Math.floor(k ? q.q3Plot : q.lowPlot), 
            n = Math.floor(q.highPlot), f = Math.floor(q.lowPlot), F || (q.graphic = F = u.g("point").add(a.group), 
            q.stem = u.path().addClass("highcharts-boxplot-stem").add(F), C && (q.whiskers = u.path().addClass("highcharts-boxplot-whisker").add(F)), 
            k && (q.box = u.path(void 0).addClass("highcharts-boxplot-box").add(F)), q.medianShape = u.path(void 0).addClass("highcharts-boxplot-median").add(F)), 
            l.styledMode || (t.stroke = q.stemColor || b.stemColor || I, t["stroke-width"] = c(q.stemWidth, b.stemWidth, b.lineWidth), 
            t.dashstyle = q.stemDashStyle || b.stemDashStyle, q.stem.attr(t), C && (H.stroke = q.whiskerColor || b.whiskerColor || I, 
            H["stroke-width"] = c(q.whiskerWidth, b.whiskerWidth, b.lineWidth), q.whiskers.attr(H)), 
            k && (v.fill = q.fillColor || b.fillColor || I, v.stroke = b.lineColor || I, v["stroke-width"] = b.lineWidth || 0, 
            q.box.attr(v)), J.stroke = q.medianColor || b.medianColor || I, J["stroke-width"] = c(q.medianWidth, b.medianWidth, b.lineWidth), 
            q.medianShape.attr(J)), A = q.stem.strokeWidth() % 2 / 2, r = h + e + A, q.stem[G]({
              d: [ "M", r, m, "L", r, n, "M", r, d, "L", r, f ]
            }), k && (A = q.box.strokeWidth() % 2 / 2, d = Math.floor(d) + A, m = Math.floor(m) + A, 
            h += A, g += A, q.box[G]({
              d: [ "M", h, m, "L", h, d, "L", g, d, "L", g, m, "L", h, m, "z" ]
            })), C && (A = q.whiskers.strokeWidth() % 2 / 2, n += A, f += A, B = /%$/.test(C) ? e * parseFloat(C) / 100 : C / 2, 
            q.whiskers[G]({
              d: [ "M", r - B, n, "L", r + B, n, "M", r - B, f, "L", r + B, f ]
            })), x = Math.round(q.medianPlot), A = q.medianShape.strokeWidth() % 2 / 2, x += A, 
            q.medianShape[G]({
              d: [ "M", h, x, "L", g, x ]
            }));
          });
        },
        setStackedPoints: b
      });
    });
    E(f, "parts-more/ErrorBarSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(l, a) {
      a = a.seriesType;
      var c = l.noop, b = l.seriesTypes;
      a("errorbar", "boxplot", {
        color: "#000000",
        grouping: !1,
        linkedTo: ":previous",
        tooltip: {
          pointFormat: '<span style="color:{point.color}">●</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'
        },
        whiskerWidth: null
      }, {
        type: "errorbar",
        pointArrayMap: [ "low", "high" ],
        toYData: function(a) {
          return [ a.low, a.high ];
        },
        pointValKey: "high",
        doQuartiles: !1,
        drawDataLabels: b.arearange ? function() {
          var a = this.pointValKey;
          b.arearange.prototype.drawDataLabels.call(this);
          this.data.forEach(function(b) {
            b.y = b[a];
          });
        } : c,
        getColumnMetrics: function() {
          return this.linkedParent && this.linkedParent.columnMetrics || b.column.prototype.getColumnMetrics.call(this);
        }
      });
    });
    E(f, "parts-more/WaterfallSeries.js", [ f["parts/Globals.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(l, a, c) {
      var b = c.addEvent, u = c.arrayMax, f = c.arrayMin, w = c.correctFloat, z = c.isNumber, y = c.objectEach, d = c.pick;
      c = c.seriesType;
      var m = l.Axis, n = l.Chart, t = l.Series, x = l.StackItem, A = l.seriesTypes;
      b(m, "afterInit", function() {
        this.isXAxis || (this.waterfallStacks = {
          changed: !1
        });
      });
      b(m, "afterBuildStacks", function() {
        this.waterfallStacks.changed = !1;
        delete this.waterfallStacks.alreadyChanged;
      });
      b(n, "beforeRedraw", function() {
        for (var a = this.axes, d = this.series, h = d.length; h--; ) d[h].options.stacking && (a.forEach(function(g) {
          g.isXAxis || (g.waterfallStacks.changed = !0);
        }), h = 0);
      });
      b(m, "afterRender", function() {
        var a = this.options.stackLabels;
        a && a.enabled && this.waterfallStacks && this.renderWaterfallStackTotals();
      });
      m.prototype.renderWaterfallStackTotals = function() {
        var a = this.waterfallStacks, d = this.stackTotalGroup, h = new x(this, this.options.stackLabels, !1, 0, void 0);
        this.dummyStackItem = h;
        y(a, function(g) {
          y(g, function(e) {
            h.total = e.stackTotal;
            e.label && (h.label = e.label);
            x.prototype.render.call(h, d);
            e.label = h.label;
            delete h.label;
          });
        });
        h.total = null;
      };
      c("waterfall", "column", {
        dataLabels: {
          inside: !0
        },
        lineWidth: 1,
        lineColor: "#333333",
        dashStyle: "Dot",
        borderColor: "#333333",
        states: {
          hover: {
            lineWidthPlus: 0
          }
        }
      }, {
        pointValKey: "y",
        showLine: !0,
        generatePoints: function() {
          var a;
          A.column.prototype.generatePoints.apply(this);
          var d = 0;
          for (a = this.points.length; d < a; d++) {
            var h = this.points[d];
            var g = this.processedYData[d];
            if (h.isIntermediateSum || h.isSum) h.y = w(g);
          }
        },
        translate: function() {
          var a = this.options, b = this.yAxis, h, g = d(a.minPointLength, 5), e = g / 2, k = a.threshold, c = a.stacking, C = b.waterfallStacks[this.stackKey];
          A.column.prototype.translate.apply(this);
          var q = h = k;
          var F = this.points;
          var m = 0;
          for (a = F.length; m < a; m++) {
            var l = F[m];
            var u = this.processedYData[m];
            var n = l.shapeArgs;
            var f = [ 0, u ];
            var t = l.y;
            if (c) {
              if (C) {
                f = C[m];
                if ("overlap" === c) {
                  var v = f.stackState[f.stateIndex--];
                  v = 0 <= t ? v : v - t;
                  Object.hasOwnProperty.call(f, "absolutePos") && delete f.absolutePos;
                  Object.hasOwnProperty.call(f, "absoluteNeg") && delete f.absoluteNeg;
                } else 0 <= t ? (v = f.threshold + f.posTotal, f.posTotal -= t) : (v = f.threshold + f.negTotal, 
                f.negTotal -= t, v -= t), !f.posTotal && Object.hasOwnProperty.call(f, "absolutePos") && (f.posTotal = f.absolutePos, 
                delete f.absolutePos), !f.negTotal && Object.hasOwnProperty.call(f, "absoluteNeg") && (f.negTotal = f.absoluteNeg, 
                delete f.absoluteNeg);
                l.isSum || (f.connectorThreshold = f.threshold + f.stackTotal);
                b.reversed ? (u = 0 <= t ? v - t : v + t, t = v) : (u = v, t = v - t);
                l.below = u <= d(k, 0);
                n.y = b.translate(u, 0, 1, 0, 1);
                n.height = Math.abs(n.y - b.translate(t, 0, 1, 0, 1));
              }
              if (t = b.dummyStackItem) t.x = m, t.label = C[m].label, t.setOffset(this.pointXOffset || 0, this.barW || 0, this.stackedYNeg[m], this.stackedYPos[m]);
            } else v = Math.max(q, q + t) + f[0], n.y = b.translate(v, 0, 1, 0, 1), l.isSum ? (n.y = b.translate(f[1], 0, 1, 0, 1), 
            n.height = Math.min(b.translate(f[0], 0, 1, 0, 1), b.len) - n.y) : l.isIntermediateSum ? (0 <= t ? (u = f[1] + h, 
            t = h) : (u = h, t = f[1] + h), b.reversed && (u ^= t, t ^= u, u ^= t), n.y = b.translate(u, 0, 1, 0, 1), 
            n.height = Math.abs(n.y - Math.min(b.translate(t, 0, 1, 0, 1), b.len)), h += f[1]) : (n.height = 0 < u ? b.translate(q, 0, 1, 0, 1) - n.y : b.translate(q, 0, 1, 0, 1) - b.translate(q - u, 0, 1, 0, 1), 
            q += u, l.below = q < d(k, 0)), 0 > n.height && (n.y += n.height, n.height *= -1);
            l.plotY = n.y = Math.round(n.y) - this.borderWidth % 2 / 2;
            n.height = Math.max(Math.round(n.height), .001);
            l.yBottom = n.y + n.height;
            n.height <= g && !l.isNull ? (n.height = g, n.y -= e, l.plotY = n.y, l.minPointLengthOffset = 0 > l.y ? -e : e) : (l.isNull && (n.width = 0), 
            l.minPointLengthOffset = 0);
            n = l.plotY + (l.negative ? n.height : 0);
            this.chart.inverted ? l.tooltipPos[0] = b.len - n : l.tooltipPos[1] = n;
          }
        },
        processData: function(a) {
          var d = this.options, h = this.yData, g = d.data, e = h.length, k = d.threshold || 0, b, r, q, c, m;
          for (m = r = b = q = c = 0; m < e; m++) {
            var n = h[m];
            var l = g && g[m] ? g[m] : {};
            "sum" === n || l.isSum ? h[m] = w(r) : "intermediateSum" === n || l.isIntermediateSum ? (h[m] = w(b), 
            b = 0) : (r += n, b += n);
            q = Math.min(r, q);
            c = Math.max(r, c);
          }
          t.prototype.processData.call(this, a);
          d.stacking || (this.dataMin = q + k, this.dataMax = c);
        },
        toYData: function(a) {
          return a.isSum ? "sum" : a.isIntermediateSum ? "intermediateSum" : a.y;
        },
        updateParallelArrays: function(a, d) {
          t.prototype.updateParallelArrays.call(this, a, d);
          if ("sum" === this.yData[0] || "intermediateSum" === this.yData[0]) this.yData[0] = null;
        },
        pointAttribs: function(a, d) {
          var b = this.options.upColor;
          b && !a.options.color && (a.color = 0 < a.y ? b : null);
          a = A.column.prototype.pointAttribs.call(this, a, d);
          delete a.dashstyle;
          return a;
        },
        getGraphPath: function() {
          return [ "M", 0, 0 ];
        },
        getCrispPath: function() {
          var a = this.data, d = this.yAxis, b = a.length, g = Math.round(this.graph.strokeWidth()) % 2 / 2, e = Math.round(this.borderWidth) % 2 / 2, k = this.xAxis.reversed, c = this.yAxis.reversed, C = this.options.stacking, q = [], m;
          for (m = 1; m < b; m++) {
            var n = a[m].shapeArgs;
            var l = a[m - 1];
            var f = a[m - 1].shapeArgs;
            var u = d.waterfallStacks[this.stackKey];
            var t = 0 < l.y ? -f.height : 0;
            if (u) {
              u = u[m - 1];
              C ? (u = u.connectorThreshold, t = Math.round(d.translate(u, 0, 1, 0, 1) + (c ? t : 0)) - g) : t = f.y + l.minPointLengthOffset + e - g;
              var v = [ "M", f.x + (k ? 0 : f.width), t, "L", n.x + (k ? n.width : 0), t ];
            }
            if (!C && v && 0 > l.y && !c || 0 < l.y && c) v[2] += f.height, v[5] += f.height;
            q = q.concat(v);
          }
          return q;
        },
        drawGraph: function() {
          t.prototype.drawGraph.call(this);
          this.graph.attr({
            d: this.getCrispPath()
          });
        },
        setStackedPoints: function() {
          function a(e, a, k, g) {
            if (z) for (k; k < z; k++) w.stackState[k] += g; else w.stackState[0] = e, z = w.stackState.length;
            w.stackState.push(w.stackState[z - 1] + a);
          }
          var d = this.options, b = this.yAxis.waterfallStacks, g = d.threshold, e = g || 0, k = e, c = this.stackKey, C = this.xData, q = C.length, m, n, l;
          this.yAxis.usePercentage = !1;
          var f = n = l = e;
          if (this.visible || !this.chart.options.chart.ignoreHiddenSeries) {
            var u = b.changed;
            (m = b.alreadyChanged) && 0 > m.indexOf(c) && (u = !0);
            b[c] || (b[c] = {});
            m = b[c];
            for (var t = 0; t < q; t++) {
              var v = C[t];
              if (!m[v] || u) m[v] = {
                negTotal: 0,
                posTotal: 0,
                stackTotal: 0,
                threshold: 0,
                stateIndex: 0,
                stackState: [],
                label: u && m[v] ? m[v].label : void 0
              };
              var w = m[v];
              var x = this.yData[t];
              0 <= x ? w.posTotal += x : w.negTotal += x;
              var y = d.data[t];
              v = w.absolutePos = w.posTotal;
              var A = w.absoluteNeg = w.negTotal;
              w.stackTotal = v + A;
              var z = w.stackState.length;
              y && y.isIntermediateSum ? (a(l, n, 0, l), l = n, n = g, e ^= k, k ^= e, e ^= k) : y && y.isSum ? (a(g, f, z), 
              e = g) : (a(e, x, 0, f), y && (f += x, n += x));
              w.stateIndex++;
              w.threshold = e;
              e += w.stackTotal;
            }
            b.changed = !1;
            b.alreadyChanged || (b.alreadyChanged = []);
            b.alreadyChanged.push(c);
          }
        },
        getExtremes: function() {
          var a = this.options.stacking;
          if (a) {
            var d = this.yAxis;
            d = d.waterfallStacks;
            var b = this.stackedYNeg = [];
            var g = this.stackedYPos = [];
            "overlap" === a ? y(d[this.stackKey], function(e) {
              b.push(f(e.stackState));
              g.push(u(e.stackState));
            }) : y(d[this.stackKey], function(e) {
              b.push(e.negTotal + e.threshold);
              g.push(e.posTotal + e.threshold);
            });
            this.dataMin = f(b);
            this.dataMax = u(g);
          }
        }
      }, {
        getClassName: function() {
          var d = a.prototype.getClassName.call(this);
          this.isSum ? d += " highcharts-sum" : this.isIntermediateSum && (d += " highcharts-intermediate-sum");
          return d;
        },
        isValid: function() {
          return z(this.y) || this.isSum || this.isIntermediateSum;
        }
      });
    });
    E(f, "parts-more/PolygonSeries.js", [ f["parts/Globals.js"], f["mixins/legend-symbol.js"], f["parts/Utilities.js"] ], function(l, a, c) {
      c = c.seriesType;
      var b = l.Series, f = l.seriesTypes;
      c("polygon", "scatter", {
        marker: {
          enabled: !1,
          states: {
            hover: {
              enabled: !1
            }
          }
        },
        stickyTracking: !1,
        tooltip: {
          followPointer: !0,
          pointFormat: ""
        },
        trackByArea: !0
      }, {
        type: "polygon",
        getGraphPath: function() {
          for (var a = b.prototype.getGraphPath.call(this), c = a.length + 1; c--; ) (c === a.length || "M" === a[c]) && 0 < c && a.splice(c, 0, "z");
          return this.areaPath = a;
        },
        drawGraph: function() {
          this.options.fillColor = this.color;
          f.area.prototype.drawGraph.call(this);
        },
        drawLegendSymbol: a.drawRectangle,
        drawTracker: b.prototype.drawTracker,
        setStackedPoints: l.noop
      });
    });
    E(f, "parts-more/BubbleLegend.js", [ f["parts/Globals.js"], f["parts/Color.js"], f["parts/Legend.js"], f["parts/Utilities.js"] ], function(l, a, c, b) {
      var f = a.parse;
      a = b.addEvent;
      var v = b.arrayMax, w = b.arrayMin, z = b.isNumber, y = b.merge, d = b.objectEach, m = b.pick, n = b.stableSort, t = b.wrap, x = l.Series, A = l.Chart, r = l.noop, p = l.setOptions;
      p({
        legend: {
          bubbleLegend: {
            borderColor: void 0,
            borderWidth: 2,
            className: void 0,
            color: void 0,
            connectorClassName: void 0,
            connectorColor: void 0,
            connectorDistance: 60,
            connectorWidth: 1,
            enabled: !1,
            labels: {
              className: void 0,
              allowOverlap: !1,
              format: "",
              formatter: void 0,
              align: "right",
              style: {
                fontSize: 10,
                color: void 0
              },
              x: 0,
              y: 0
            },
            maxSize: 60,
            minSize: 10,
            legendIndex: 0,
            ranges: {
              value: void 0,
              borderColor: void 0,
              color: void 0,
              connectorColor: void 0
            },
            sizeBy: "area",
            sizeByAbsoluteValue: !1,
            zIndex: 1,
            zThreshold: 0
          }
        }
      });
      p = function() {
        function a(a, e) {
          this.options = this.symbols = this.visible = this.ranges = this.movementX = this.maxLabel = this.legendSymbol = this.legendItemWidth = this.legendItemHeight = this.legendItem = this.legendGroup = this.legend = this.fontMetrics = this.chart = void 0;
          this.setState = r;
          this.init(a, e);
        }
        a.prototype.init = function(a, e) {
          this.options = a;
          this.visible = !0;
          this.chart = e.chart;
          this.legend = e;
        };
        a.prototype.addToLegend = function(a) {
          a.splice(this.options.legendIndex, 0, this);
        };
        a.prototype.drawLegendSymbol = function(a) {
          var e = this.chart, k = this.options, d = m(a.options.itemDistance, 20), b = k.ranges;
          var g = k.connectorDistance;
          this.fontMetrics = e.renderer.fontMetrics(k.labels.style.fontSize.toString() + "px");
          b && b.length && z(b[0].value) ? (n(b, function(e, a) {
            return a.value - e.value;
          }), this.ranges = b, this.setOptions(), this.render(), e = this.getMaxLabelSize(), 
          b = this.ranges[0].radius, a = 2 * b, g = g - b + e.width, g = 0 < g ? g : 0, this.maxLabel = e, 
          this.movementX = "left" === k.labels.align ? g : 0, this.legendItemWidth = a + g + d, 
          this.legendItemHeight = a + this.fontMetrics.h / 2) : a.options.bubbleLegend.autoRanges = !0;
        };
        a.prototype.setOptions = function() {
          var a = this.ranges, e = this.options, k = this.chart.series[e.seriesIndex], d = this.legend.baseline, b = {
            "z-index": e.zIndex,
            "stroke-width": e.borderWidth
          }, h = {
            "z-index": e.zIndex,
            "stroke-width": e.connectorWidth
          }, c = this.getLabelStyles(), p = k.options.marker.fillOpacity, r = this.chart.styledMode;
          a.forEach(function(g, q) {
            r || (b.stroke = m(g.borderColor, e.borderColor, k.color), b.fill = m(g.color, e.color, 1 !== p ? f(k.color).setOpacity(p).get("rgba") : k.color), 
            h.stroke = m(g.connectorColor, e.connectorColor, k.color));
            a[q].radius = this.getRangeRadius(g.value);
            a[q] = y(a[q], {
              center: a[0].radius - a[q].radius + d
            });
            r || y(!0, a[q], {
              bubbleStyle: y(!1, b),
              connectorStyle: y(!1, h),
              labelStyle: c
            });
          }, this);
        };
        a.prototype.getLabelStyles = function() {
          var a = this.options, e = {}, k = "left" === a.labels.align, b = this.legend.options.rtl;
          d(a.labels.style, function(a, k) {
            "color" !== k && "fontSize" !== k && "z-index" !== k && (e[k] = a);
          });
          return y(!1, e, {
            "font-size": a.labels.style.fontSize,
            fill: m(a.labels.style.color, "#000000"),
            "z-index": a.zIndex,
            align: b || k ? "right" : "left"
          });
        };
        a.prototype.getRangeRadius = function(a) {
          var e = this.options;
          return this.chart.series[this.options.seriesIndex].getRadius.call(this, e.ranges[e.ranges.length - 1].value, e.ranges[0].value, e.minSize, e.maxSize, a);
        };
        a.prototype.render = function() {
          var a = this.chart.renderer, e = this.options.zThreshold;
          this.symbols || (this.symbols = {
            connectors: [],
            bubbleItems: [],
            labels: []
          });
          this.legendSymbol = a.g("bubble-legend");
          this.legendItem = a.g("bubble-legend-item");
          this.legendSymbol.translateX = 0;
          this.legendSymbol.translateY = 0;
          this.ranges.forEach(function(a) {
            a.value >= e && this.renderRange(a);
          }, this);
          this.legendSymbol.add(this.legendItem);
          this.legendItem.add(this.legendGroup);
          this.hideOverlappingLabels();
        };
        a.prototype.renderRange = function(a) {
          var e = this.options, k = e.labels, b = this.chart.renderer, d = this.symbols, g = d.labels, h = a.center, c = Math.abs(a.radius), p = e.connectorDistance, r = k.align, m = k.style.fontSize;
          p = this.legend.options.rtl || "left" === r ? -p : p;
          k = e.connectorWidth;
          var n = this.ranges[0].radius, l = h - c - e.borderWidth / 2 + k / 2;
          m = m / 2 - (this.fontMetrics.h - m) / 2;
          var f = b.styledMode;
          "center" === r && (p = 0, e.connectorDistance = 0, a.labelStyle.align = "center");
          r = l + e.labels.y;
          var u = n + p + e.labels.x;
          d.bubbleItems.push(b.circle(n, h + ((l % 1 ? 1 : .5) - (k % 2 ? 0 : .5)), c).attr(f ? {} : a.bubbleStyle).addClass((f ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-symbol " + (e.className || "")).add(this.legendSymbol));
          d.connectors.push(b.path(b.crispLine([ "M", n, l, "L", n + p, l ], e.connectorWidth)).attr(f ? {} : a.connectorStyle).addClass((f ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-connectors " + (e.connectorClassName || "")).add(this.legendSymbol));
          a = b.text(this.formatLabel(a), u, r + m).attr(f ? {} : a.labelStyle).addClass("highcharts-bubble-legend-labels " + (e.labels.className || "")).add(this.legendSymbol);
          g.push(a);
          a.placed = !0;
          a.alignAttr = {
            x: u,
            y: r + m
          };
        };
        a.prototype.getMaxLabelSize = function() {
          var a, e;
          this.symbols.labels.forEach(function(k) {
            e = k.getBBox(!0);
            a = a ? e.width > a.width ? e : a : e;
          });
          return a || {};
        };
        a.prototype.formatLabel = function(a) {
          var e = this.options, k = e.labels.formatter;
          e = e.labels.format;
          var d = this.chart.numberFormatter;
          return e ? b.format(e, a) : k ? k.call(a) : d(a.value, 1);
        };
        a.prototype.hideOverlappingLabels = function() {
          var a = this.chart, e = this.symbols;
          !this.options.labels.allowOverlap && e && (a.hideOverlappingLabels(e.labels), e.labels.forEach(function(a, b) {
            a.newOpacity ? a.newOpacity !== a.oldOpacity && e.connectors[b].show() : e.connectors[b].hide();
          }));
        };
        a.prototype.getRanges = function() {
          var a = this.legend.bubbleLegend, e = a.options.ranges, k, b = Number.MAX_VALUE, d = -Number.MAX_VALUE;
          a.chart.series.forEach(function(e) {
            e.isBubble && !e.ignoreSeries && (k = e.zData.filter(z), k.length && (b = m(e.options.zMin, Math.min(b, Math.max(w(k), !1 === e.options.displayNegative ? e.options.zThreshold : -Number.MAX_VALUE))), 
            d = m(e.options.zMax, Math.max(d, v(k)))));
          });
          var h = b === d ? [ {
            value: d
          } ] : [ {
            value: b
          }, {
            value: (b + d) / 2
          }, {
            value: d,
            autoRanges: !0
          } ];
          e.length && e[0].radius && h.reverse();
          h.forEach(function(a, b) {
            e && e[b] && (h[b] = y(!1, e[b], a));
          });
          return h;
        };
        a.prototype.predictBubbleSizes = function() {
          var a = this.chart, e = this.fontMetrics, b = a.legend.options, d = "horizontal" === b.layout, h = d ? a.legend.lastLineHeight : 0, q = a.plotSizeX, c = a.plotSizeY, p = a.series[this.options.seriesIndex];
          a = Math.ceil(p.minPxSize);
          var r = Math.ceil(p.maxPxSize);
          p = p.options.maxSize;
          var m = Math.min(c, q);
          if (b.floating || !/%$/.test(p)) e = r; else if (p = parseFloat(p), e = (m + h - e.h / 2) * p / 100 / (p / 100 + 1), 
          d && c - e >= q || !d && q - e >= c) e = r;
          return [ a, Math.ceil(e) ];
        };
        a.prototype.updateRanges = function(a, e) {
          var b = this.legend.options.bubbleLegend;
          b.minSize = a;
          b.maxSize = e;
          b.ranges = this.getRanges();
        };
        a.prototype.correctSizes = function() {
          var a = this.legend, e = this.chart.series[this.options.seriesIndex];
          1 < Math.abs(Math.ceil(e.maxPxSize) - this.options.maxSize) && (this.updateRanges(this.options.minSize, e.maxPxSize), 
          a.render());
        };
        return a;
      }();
      a(c, "afterGetAllItems", function(a) {
        var b = this.bubbleLegend, e = this.options, d = e.bubbleLegend, h = this.chart.getVisibleBubbleSeriesIndex();
        b && b.ranges && b.ranges.length && (d.ranges.length && (d.autoRanges = !!d.ranges[0].autoRanges), 
        this.destroyItem(b));
        0 <= h && e.enabled && d.enabled && (d.seriesIndex = h, this.bubbleLegend = new l.BubbleLegend(d, this), 
        this.bubbleLegend.addToLegend(a.allItems));
      });
      A.prototype.getVisibleBubbleSeriesIndex = function() {
        for (var a = this.series, b = 0; b < a.length; ) {
          if (a[b] && a[b].isBubble && a[b].visible && a[b].zData.length) return b;
          b++;
        }
        return -1;
      };
      c.prototype.getLinesHeights = function() {
        var a = this.allItems, b = [], e = a.length, d, c = 0;
        for (d = 0; d < e; d++) if (a[d].legendItemHeight && (a[d].itemHeight = a[d].legendItemHeight), 
        a[d] === a[e - 1] || a[d + 1] && a[d]._legendItemPos[1] !== a[d + 1]._legendItemPos[1]) {
          b.push({
            height: 0
          });
          var p = b[b.length - 1];
          for (c; c <= d; c++) a[c].itemHeight > p.height && (p.height = a[c].itemHeight);
          p.step = d;
        }
        return b;
      };
      c.prototype.retranslateItems = function(a) {
        var b, e, d, h = this.options.rtl, c = 0;
        this.allItems.forEach(function(k, g) {
          b = k.legendGroup.translateX;
          e = k._legendItemPos[1];
          if ((d = k.movementX) || h && k.ranges) d = h ? b - k.options.maxSize / 2 : b + d, 
          k.legendGroup.attr({
            translateX: d
          });
          g > a[c].step && c++;
          k.legendGroup.attr({
            translateY: Math.round(e + a[c].height / 2)
          });
          k._legendItemPos[1] = e + a[c].height / 2;
        });
      };
      a(x, "legendItemClick", function() {
        var a = this.chart, b = this.visible, e = this.chart.legend;
        e && e.bubbleLegend && (this.visible = !b, this.ignoreSeries = b, a = 0 <= a.getVisibleBubbleSeriesIndex(), 
        e.bubbleLegend.visible !== a && (e.update({
          bubbleLegend: {
            enabled: a
          }
        }), e.bubbleLegend.visible = a), this.visible = b);
      });
      t(A.prototype, "drawChartBox", function(a, b, e) {
        var k = this.legend, h = 0 <= this.getVisibleBubbleSeriesIndex();
        if (k && k.options.enabled && k.bubbleLegend && k.options.bubbleLegend.autoRanges && h) {
          var g = k.bubbleLegend.options;
          h = k.bubbleLegend.predictBubbleSizes();
          k.bubbleLegend.updateRanges(h[0], h[1]);
          g.placed || (k.group.placed = !1, k.allItems.forEach(function(e) {
            e.legendGroup.translateY = null;
          }));
          k.render();
          this.getMargins();
          this.axes.forEach(function(e) {
            e.visible && e.render();
            g.placed || (e.setScale(), e.updateNames(), d(e.ticks, function(e) {
              e.isNew = !0;
              e.isNewLabel = !0;
            }));
          });
          g.placed = !0;
          this.getMargins();
          a.call(this, b, e);
          k.bubbleLegend.correctSizes();
          k.retranslateItems(k.getLinesHeights());
        } else a.call(this, b, e), k && k.options.enabled && k.bubbleLegend && (k.render(), 
        k.retranslateItems(k.getLinesHeights()));
      });
      l.BubbleLegend = p;
      return l.BubbleLegend;
    });
    E(f, "parts-more/BubbleSeries.js", [ f["parts/Globals.js"], f["parts/Color.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(l, a, c, b) {
      var f = a.parse, v = b.arrayMax, w = b.arrayMin, z = b.clamp, y = b.extend, d = b.isNumber, m = b.pick, n = b.pInt;
      a = b.seriesType;
      b = l.Axis;
      var t = l.noop, x = l.Series, A = l.seriesTypes;
      a("bubble", "scatter", {
        dataLabels: {
          formatter: function() {
            return this.point.z;
          },
          inside: !0,
          verticalAlign: "middle"
        },
        animationLimit: 250,
        marker: {
          lineColor: null,
          lineWidth: 1,
          fillOpacity: .5,
          radius: null,
          states: {
            hover: {
              radiusPlus: 0
            }
          },
          symbol: "circle"
        },
        minSize: 8,
        maxSize: "20%",
        softThreshold: !1,
        states: {
          hover: {
            halo: {
              size: 5
            }
          }
        },
        tooltip: {
          pointFormat: "({point.x}, {point.y}), Size: {point.z}"
        },
        turboThreshold: 0,
        zThreshold: 0,
        zoneAxis: "z"
      }, {
        pointArrayMap: [ "y", "z" ],
        parallelArrays: [ "x", "y", "z" ],
        trackerGroups: [ "group", "dataLabelsGroup" ],
        specialGroup: "group",
        bubblePadding: !0,
        zoneAxis: "z",
        directTouch: !0,
        isBubble: !0,
        pointAttribs: function(a, b) {
          var d = this.options.marker.fillOpacity;
          a = x.prototype.pointAttribs.call(this, a, b);
          1 !== d && (a.fill = f(a.fill).setOpacity(d).get("rgba"));
          return a;
        },
        getRadii: function(a, b, d) {
          var g = this.zData, e = this.yData, k = d.minPxSize, h = d.maxPxSize, c = [];
          var q = 0;
          for (d = g.length; q < d; q++) {
            var p = g[q];
            c.push(this.getRadius(a, b, k, h, p, e[q]));
          }
          this.radii = c;
        },
        getRadius: function(a, b, h, g, e, k) {
          var c = this.options, p = "width" !== c.sizeBy, q = c.zThreshold, r = b - a, m = .5;
          if (null === k || null === e) return null;
          if (d(e)) {
            c.sizeByAbsoluteValue && (e = Math.abs(e - q), r = Math.max(b - q, Math.abs(a - q)), 
            a = 0);
            if (e < a) return h / 2 - 1;
            0 < r && (m = (e - a) / r);
          }
          p && 0 <= m && (m = Math.sqrt(m));
          return Math.ceil(h + m * (g - h)) / 2;
        },
        animate: function(a) {
          !a && this.points.length < this.options.animationLimit && this.points.forEach(function(a) {
            var b = a.graphic;
            if (b && b.width) {
              var d = {
                x: b.x,
                y: b.y,
                width: b.width,
                height: b.height
              };
              b.attr({
                x: a.plotX,
                y: a.plotY,
                width: 1,
                height: 1
              });
              b.animate(d, this.options.animation);
            }
          }, this);
        },
        hasData: function() {
          return !!this.processedXData.length;
        },
        translate: function() {
          var a, b = this.data, c = this.radii;
          A.scatter.prototype.translate.call(this);
          for (a = b.length; a--; ) {
            var g = b[a];
            var e = c ? c[a] : 0;
            d(e) && e >= this.minPxSize / 2 ? (g.marker = y(g.marker, {
              radius: e,
              width: 2 * e,
              height: 2 * e
            }), g.dlBox = {
              x: g.plotX - e,
              y: g.plotY - e,
              width: 2 * e,
              height: 2 * e
            }) : g.shapeArgs = g.plotY = g.dlBox = void 0;
          }
        },
        alignDataLabel: A.column.prototype.alignDataLabel,
        buildKDTree: t,
        applyZones: t
      }, {
        haloPath: function(a) {
          return c.prototype.haloPath.call(this, 0 === a ? 0 : (this.marker ? this.marker.radius || 0 : 0) + a);
        },
        ttBelow: !1
      });
      b.prototype.beforePadding = function() {
        var a = this, b = this.len, c = this.chart, g = 0, e = b, k = this.isXAxis, l = k ? "xData" : "yData", f = this.min, q = {}, u = Math.min(c.plotWidth, c.plotHeight), t = Number.MAX_VALUE, x = -Number.MAX_VALUE, y = this.max - f, A = b / y, H = [];
        this.series.forEach(function(e) {
          var b = e.options;
          !e.bubblePadding || !e.visible && c.options.chart.ignoreHiddenSeries || (a.allowZoomOutside = !0, 
          H.push(e), k && ([ "minSize", "maxSize" ].forEach(function(e) {
            var a = b[e], d = /%$/.test(a);
            a = n(a);
            q[e] = d ? u * a / 100 : a;
          }), e.minPxSize = q.minSize, e.maxPxSize = Math.max(q.maxSize, q.minSize), e = e.zData.filter(d), 
          e.length && (t = m(b.zMin, z(w(e), !1 === b.displayNegative ? b.zThreshold : -Number.MAX_VALUE, t)), 
          x = m(b.zMax, Math.max(x, v(e))))));
        });
        H.forEach(function(b) {
          var c = b[l], h = c.length;
          k && b.getRadii(t, x, b);
          if (0 < y) for (;h--; ) if (d(c[h]) && a.dataMin <= c[h] && c[h] <= a.max) {
            var q = b.radii ? b.radii[h] : 0;
            g = Math.min((c[h] - f) * A - q, g);
            e = Math.max((c[h] - f) * A + q, e);
          }
        });
        H.length && 0 < y && !this.isLog && (e -= b, A *= (b + Math.max(0, g) - Math.min(e, b)) / b, 
        [ [ "min", "userMin", g ], [ "max", "userMax", e ] ].forEach(function(e) {
          "undefined" === typeof m(a.options[e[0]], a[e[1]]) && (a[e[0]] += e[2] / A);
        }));
      };
    });
    E(f, "modules/networkgraph/integrations.js", [ f["parts/Globals.js"] ], function(l) {
      l.networkgraphIntegrations = {
        verlet: {
          attractiveForceFunction: function(a, c) {
            return (c - a) / a;
          },
          repulsiveForceFunction: function(a, c) {
            return (c - a) / a * (c > a ? 1 : 0);
          },
          barycenter: function() {
            var a = this.options.gravitationalConstant, c = this.barycenter.xFactor, b = this.barycenter.yFactor;
            c = (c - (this.box.left + this.box.width) / 2) * a;
            b = (b - (this.box.top + this.box.height) / 2) * a;
            this.nodes.forEach(function(a) {
              a.fixedPosition || (a.plotX -= c / a.mass / a.degree, a.plotY -= b / a.mass / a.degree);
            });
          },
          repulsive: function(a, c, b) {
            c = c * this.diffTemperature / a.mass / a.degree;
            a.fixedPosition || (a.plotX += b.x * c, a.plotY += b.y * c);
          },
          attractive: function(a, c, b) {
            var l = a.getMass(), f = -b.x * c * this.diffTemperature;
            c = -b.y * c * this.diffTemperature;
            a.fromNode.fixedPosition || (a.fromNode.plotX -= f * l.fromNode / a.fromNode.degree, 
            a.fromNode.plotY -= c * l.fromNode / a.fromNode.degree);
            a.toNode.fixedPosition || (a.toNode.plotX += f * l.toNode / a.toNode.degree, a.toNode.plotY += c * l.toNode / a.toNode.degree);
          },
          integrate: function(a, c) {
            var b = -a.options.friction, l = a.options.maxSpeed, f = (c.plotX + c.dispX - c.prevX) * b;
            b *= c.plotY + c.dispY - c.prevY;
            var w = Math.abs, z = w(f) / (f || 1);
            w = w(b) / (b || 1);
            f = z * Math.min(l, Math.abs(f));
            b = w * Math.min(l, Math.abs(b));
            c.prevX = c.plotX + c.dispX;
            c.prevY = c.plotY + c.dispY;
            c.plotX += f;
            c.plotY += b;
            c.temperature = a.vectorLength({
              x: f,
              y: b
            });
          },
          getK: function(a) {
            return Math.pow(a.box.width * a.box.height / a.nodes.length, .5);
          }
        },
        euler: {
          attractiveForceFunction: function(a, c) {
            return a * a / c;
          },
          repulsiveForceFunction: function(a, c) {
            return c * c / a;
          },
          barycenter: function() {
            var a = this.options.gravitationalConstant, c = this.barycenter.xFactor, b = this.barycenter.yFactor;
            this.nodes.forEach(function(f) {
              if (!f.fixedPosition) {
                var l = f.getDegree();
                l *= 1 + l / 2;
                f.dispX += (c - f.plotX) * a * l / f.degree;
                f.dispY += (b - f.plotY) * a * l / f.degree;
              }
            });
          },
          repulsive: function(a, c, b, f) {
            a.dispX += b.x / f * c / a.degree;
            a.dispY += b.y / f * c / a.degree;
          },
          attractive: function(a, c, b, f) {
            var l = a.getMass(), u = b.x / f * c;
            c *= b.y / f;
            a.fromNode.fixedPosition || (a.fromNode.dispX -= u * l.fromNode / a.fromNode.degree, 
            a.fromNode.dispY -= c * l.fromNode / a.fromNode.degree);
            a.toNode.fixedPosition || (a.toNode.dispX += u * l.toNode / a.toNode.degree, a.toNode.dispY += c * l.toNode / a.toNode.degree);
          },
          integrate: function(a, c) {
            c.dispX += c.dispX * a.options.friction;
            c.dispY += c.dispY * a.options.friction;
            var b = c.temperature = a.vectorLength({
              x: c.dispX,
              y: c.dispY
            });
            0 !== b && (c.plotX += c.dispX / b * Math.min(Math.abs(c.dispX), a.temperature), 
            c.plotY += c.dispY / b * Math.min(Math.abs(c.dispY), a.temperature));
          },
          getK: function(a) {
            return Math.pow(a.box.width * a.box.height / a.nodes.length, .3);
          }
        }
      };
    });
    E(f, "modules/networkgraph/QuadTree.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      a = a.extend;
      var c = f.QuadTreeNode = function(a) {
        this.box = a;
        this.boxSize = Math.min(a.width, a.height);
        this.nodes = [];
        this.body = this.isInternal = !1;
        this.isEmpty = !0;
      };
      a(c.prototype, {
        insert: function(a, f) {
          this.isInternal ? this.nodes[this.getBoxPosition(a)].insert(a, f - 1) : (this.isEmpty = !1, 
          this.body ? f ? (this.isInternal = !0, this.divideBox(), !0 !== this.body && (this.nodes[this.getBoxPosition(this.body)].insert(this.body, f - 1), 
          this.body = !0), this.nodes[this.getBoxPosition(a)].insert(a, f - 1)) : (f = new c({
            top: a.plotX,
            left: a.plotY,
            width: .1,
            height: .1
          }), f.body = a, f.isInternal = !1, this.nodes.push(f)) : (this.isInternal = !1, 
          this.body = a));
        },
        updateMassAndCenter: function() {
          var a = 0, c = 0, f = 0;
          this.isInternal ? (this.nodes.forEach(function(b) {
            b.isEmpty || (a += b.mass, c += b.plotX * b.mass, f += b.plotY * b.mass);
          }), c /= a, f /= a) : this.body && (a = this.body.mass, c = this.body.plotX, f = this.body.plotY);
          this.mass = a;
          this.plotX = c;
          this.plotY = f;
        },
        divideBox: function() {
          var a = this.box.width / 2, f = this.box.height / 2;
          this.nodes[0] = new c({
            left: this.box.left,
            top: this.box.top,
            width: a,
            height: f
          });
          this.nodes[1] = new c({
            left: this.box.left + a,
            top: this.box.top,
            width: a,
            height: f
          });
          this.nodes[2] = new c({
            left: this.box.left + a,
            top: this.box.top + f,
            width: a,
            height: f
          });
          this.nodes[3] = new c({
            left: this.box.left,
            top: this.box.top + f,
            width: a,
            height: f
          });
        },
        getBoxPosition: function(a) {
          var b = a.plotY < this.box.top + this.box.height / 2;
          return a.plotX < this.box.left + this.box.width / 2 ? b ? 0 : 3 : b ? 1 : 2;
        }
      });
      f = f.QuadTree = function(a, f, l, w) {
        this.box = {
          left: a,
          top: f,
          width: l,
          height: w
        };
        this.maxDepth = 25;
        this.root = new c(this.box, "0");
        this.root.isInternal = !0;
        this.root.isRoot = !0;
        this.root.divideBox();
      };
      a(f.prototype, {
        insertNodes: function(a) {
          a.forEach(function(a) {
            this.root.insert(a, this.maxDepth);
          }, this);
        },
        visitNodeRecursive: function(a, c, f) {
          var b;
          a || (a = this.root);
          a === this.root && c && (b = c(a));
          !1 !== b && (a.nodes.forEach(function(a) {
            if (a.isInternal) {
              c && (b = c(a));
              if (!1 === b) return;
              this.visitNodeRecursive(a, c, f);
            } else a.body && c && c(a.body);
            f && f(a);
          }, this), a === this.root && f && f(a));
        },
        calculateMassAndCenter: function() {
          this.visitNodeRecursive(null, null, function(a) {
            a.updateMassAndCenter();
          });
        }
      });
    });
    E(f, "modules/networkgraph/layouts.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      var c = a.addEvent, b = a.clamp, l = a.defined, v = a.extend, w = a.isFunction, z = a.pick, y = a.setAnimation;
      a = f.Chart;
      f.layouts = {
        "reingold-fruchterman": function() {}
      };
      v(f.layouts["reingold-fruchterman"].prototype, {
        init: function(a) {
          this.options = a;
          this.nodes = [];
          this.links = [];
          this.series = [];
          this.box = {
            x: 0,
            y: 0,
            width: 0,
            height: 0
          };
          this.setInitialRendering(!0);
          this.integration = f.networkgraphIntegrations[a.integration];
          this.attractiveForce = z(a.attractiveForce, this.integration.attractiveForceFunction);
          this.repulsiveForce = z(a.repulsiveForce, this.integration.repulsiveForceFunction);
          this.approximation = a.approximation;
        },
        start: function() {
          var a = this.series, b = this.options;
          this.currentStep = 0;
          this.forces = a[0] && a[0].forces || [];
          this.initialRendering && (this.initPositions(), a.forEach(function(a) {
            a.render();
          }));
          this.setK();
          this.resetSimulation(b);
          b.enableSimulation && this.step();
        },
        step: function() {
          var a = this, b = this.series, c = this.options;
          a.currentStep++;
          "barnes-hut" === a.approximation && (a.createQuadTree(), a.quadTree.calculateMassAndCenter());
          a.forces.forEach(function(b) {
            a[b + "Forces"](a.temperature);
          });
          a.applyLimits(a.temperature);
          a.temperature = a.coolDown(a.startTemperature, a.diffTemperature, a.currentStep);
          a.prevSystemTemperature = a.systemTemperature;
          a.systemTemperature = a.getSystemTemperature();
          c.enableSimulation && (b.forEach(function(a) {
            a.chart && a.render();
          }), a.maxIterations-- && isFinite(a.temperature) && !a.isStable() ? (a.simulation && f.win.cancelAnimationFrame(a.simulation), 
          a.simulation = f.win.requestAnimationFrame(function() {
            a.step();
          })) : a.simulation = !1);
        },
        stop: function() {
          this.simulation && f.win.cancelAnimationFrame(this.simulation);
        },
        setArea: function(a, b, c, f) {
          this.box = {
            left: a,
            top: b,
            width: c,
            height: f
          };
        },
        setK: function() {
          this.k = this.options.linkLength || this.integration.getK(this);
        },
        addElementsToCollection: function(a, b) {
          a.forEach(function(a) {
            -1 === b.indexOf(a) && b.push(a);
          });
        },
        removeElementFromCollection: function(a, b) {
          a = b.indexOf(a);
          -1 !== a && b.splice(a, 1);
        },
        clear: function() {
          this.nodes.length = 0;
          this.links.length = 0;
          this.series.length = 0;
          this.resetSimulation();
        },
        resetSimulation: function() {
          this.forcedStop = !1;
          this.systemTemperature = 0;
          this.setMaxIterations();
          this.setTemperature();
          this.setDiffTemperature();
        },
        setMaxIterations: function(a) {
          this.maxIterations = z(a, this.options.maxIterations);
        },
        setTemperature: function() {
          this.temperature = this.startTemperature = Math.sqrt(this.nodes.length);
        },
        setDiffTemperature: function() {
          this.diffTemperature = this.startTemperature / (this.options.maxIterations + 1);
        },
        setInitialRendering: function(a) {
          this.initialRendering = a;
        },
        createQuadTree: function() {
          this.quadTree = new f.QuadTree(this.box.left, this.box.top, this.box.width, this.box.height);
          this.quadTree.insertNodes(this.nodes);
        },
        initPositions: function() {
          var a = this.options.initialPositions;
          w(a) ? (a.call(this), this.nodes.forEach(function(a) {
            l(a.prevX) || (a.prevX = a.plotX);
            l(a.prevY) || (a.prevY = a.plotY);
            a.dispX = 0;
            a.dispY = 0;
          })) : "circle" === a ? this.setCircularPositions() : this.setRandomPositions();
        },
        setCircularPositions: function() {
          function a(b) {
            b.linksFrom.forEach(function(b) {
              r[b.toNode.id] || (r[b.toNode.id] = !0, u.push(b.toNode), a(b.toNode));
            });
          }
          var b = this.box, c = this.nodes, f = 2 * Math.PI / (c.length + 1), l = c.filter(function(a) {
            return 0 === a.linksTo.length;
          }), u = [], r = {}, p = this.options.initialPositionRadius;
          l.forEach(function(b) {
            u.push(b);
            a(b);
          });
          u.length ? c.forEach(function(a) {
            -1 === u.indexOf(a) && u.push(a);
          }) : u = c;
          u.forEach(function(a, d) {
            a.plotX = a.prevX = z(a.plotX, b.width / 2 + p * Math.cos(d * f));
            a.plotY = a.prevY = z(a.plotY, b.height / 2 + p * Math.sin(d * f));
            a.dispX = 0;
            a.dispY = 0;
          });
        },
        setRandomPositions: function() {
          function a(a) {
            a = a * a / Math.PI;
            return a -= Math.floor(a);
          }
          var b = this.box, c = this.nodes, f = c.length + 1;
          c.forEach(function(d, c) {
            d.plotX = d.prevX = z(d.plotX, b.width * a(c));
            d.plotY = d.prevY = z(d.plotY, b.height * a(f + c));
            d.dispX = 0;
            d.dispY = 0;
          });
        },
        force: function(a) {
          this.integration[a].apply(this, Array.prototype.slice.call(arguments, 1));
        },
        barycenterForces: function() {
          this.getBarycenter();
          this.force("barycenter");
        },
        getBarycenter: function() {
          var a = 0, b = 0, c = 0;
          this.nodes.forEach(function(d) {
            b += d.plotX * d.mass;
            c += d.plotY * d.mass;
            a += d.mass;
          });
          return this.barycenter = {
            x: b,
            y: c,
            xFactor: b / a,
            yFactor: c / a
          };
        },
        barnesHutApproximation: function(a, b) {
          var d = this.getDistXY(a, b), c = this.vectorLength(d);
          if (a !== b && 0 !== c) if (b.isInternal) {
            if (b.boxSize / c < this.options.theta && 0 !== c) {
              var f = this.repulsiveForce(c, this.k);
              this.force("repulsive", a, f * b.mass, d, c);
              var l = !1;
            } else l = !0;
          } else f = this.repulsiveForce(c, this.k), this.force("repulsive", a, f * b.mass, d, c);
          return l;
        },
        repulsiveForces: function() {
          var a = this;
          "barnes-hut" === a.approximation ? a.nodes.forEach(function(b) {
            a.quadTree.visitNodeRecursive(null, function(d) {
              return a.barnesHutApproximation(b, d);
            });
          }) : a.nodes.forEach(function(b) {
            a.nodes.forEach(function(d) {
              if (b !== d && !b.fixedPosition) {
                var c = a.getDistXY(b, d);
                var f = a.vectorLength(c);
                if (0 !== f) {
                  var l = a.repulsiveForce(f, a.k);
                  a.force("repulsive", b, l * d.mass, c, f);
                }
              }
            });
          });
        },
        attractiveForces: function() {
          var a = this, b, c, f;
          a.links.forEach(function(d) {
            d.fromNode && d.toNode && (b = a.getDistXY(d.fromNode, d.toNode), c = a.vectorLength(b), 
            0 !== c && (f = a.attractiveForce(c, a.k), a.force("attractive", d, f, b, c)));
          });
        },
        applyLimits: function() {
          var a = this;
          a.nodes.forEach(function(b) {
            b.fixedPosition || (a.integration.integrate(a, b), a.applyLimitBox(b, a.box), b.dispX = 0, 
            b.dispY = 0);
          });
        },
        applyLimitBox: function(a, c) {
          var d = a.radius;
          a.plotX = b(a.plotX, c.left + d, c.width - d);
          a.plotY = b(a.plotY, c.top + d, c.height - d);
        },
        coolDown: function(a, b, c) {
          return a - b * c;
        },
        isStable: function() {
          return 1e-5 > Math.abs(this.systemTemperature - this.prevSystemTemperature) || 0 >= this.temperature;
        },
        getSystemTemperature: function() {
          return this.nodes.reduce(function(a, b) {
            return a + b.temperature;
          }, 0);
        },
        vectorLength: function(a) {
          return Math.sqrt(a.x * a.x + a.y * a.y);
        },
        getDistR: function(a, b) {
          a = this.getDistXY(a, b);
          return this.vectorLength(a);
        },
        getDistXY: function(a, b) {
          var c = a.plotX - b.plotX;
          a = a.plotY - b.plotY;
          return {
            x: c,
            y: a,
            absX: Math.abs(c),
            absY: Math.abs(a)
          };
        }
      });
      c(a, "predraw", function() {
        this.graphLayoutsLookup && this.graphLayoutsLookup.forEach(function(a) {
          a.stop();
        });
      });
      c(a, "render", function() {
        function a(a) {
          a.maxIterations-- && isFinite(a.temperature) && !a.isStable() && !a.options.enableSimulation && (a.beforeStep && a.beforeStep(), 
          a.step(), c = !1, b = !0);
        }
        var b = !1;
        if (this.graphLayoutsLookup) {
          y(!1, this);
          for (this.graphLayoutsLookup.forEach(function(a) {
            a.start();
          }); !c; ) {
            var c = !0;
            this.graphLayoutsLookup.forEach(a);
          }
          b && this.series.forEach(function(a) {
            a && a.layout && a.render();
          });
        }
      });
    });
    E(f, "modules/networkgraph/draggable-nodes.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      var c = a.addEvent;
      a = f.Chart;
      f.dragNodesMixin = {
        onMouseDown: function(a, c) {
          c = this.chart.pointer.normalize(c);
          a.fixedPosition = {
            chartX: c.chartX,
            chartY: c.chartY,
            plotX: a.plotX,
            plotY: a.plotY
          };
          a.inDragMode = !0;
        },
        onMouseMove: function(a, c) {
          if (a.fixedPosition && a.inDragMode) {
            var b = this.chart, f = b.pointer.normalize(c);
            c = a.fixedPosition.chartX - f.chartX;
            f = a.fixedPosition.chartY - f.chartY;
            if (5 < Math.abs(c) || 5 < Math.abs(f)) c = a.fixedPosition.plotX - c, f = a.fixedPosition.plotY - f, 
            b.isInsidePlot(c, f) && (a.plotX = c, a.plotY = f, a.hasDragged = !0, this.redrawHalo(a), 
            this.layout.simulation ? this.layout.resetSimulation() : (this.layout.setInitialRendering(!1), 
            this.layout.enableSimulation ? this.layout.start() : this.layout.setMaxIterations(1), 
            this.chart.redraw(), this.layout.setInitialRendering(!0)));
          }
        },
        onMouseUp: function(a, c) {
          a.fixedPosition && a.hasDragged && (this.layout.enableSimulation ? this.layout.start() : this.chart.redraw(), 
          a.inDragMode = a.hasDragged = !1, this.options.fixedDraggable || delete a.fixedPosition);
        },
        redrawHalo: function(a) {
          a && this.halo && this.halo.attr({
            d: a.haloPath(this.options.states.hover.halo.size)
          });
        }
      };
      c(a, "load", function() {
        var a = this, f, l, w;
        a.container && (f = c(a.container, "mousedown", function(b) {
          var f = a.hoverPoint;
          f && f.series && f.series.hasDraggableNodes && f.series.options.draggable && (f.series.onMouseDown(f, b), 
          l = c(a.container, "mousemove", function(a) {
            return f && f.series && f.series.onMouseMove(f, a);
          }), w = c(a.container.ownerDocument, "mouseup", function(a) {
            l();
            w();
            return f && f.series && f.series.onMouseUp(f, a);
          }));
        }));
        c(a, "destroy", function() {
          f();
        });
      });
    });
    E(f, "parts-more/PackedBubbleSeries.js", [ f["parts/Globals.js"], f["parts/Color.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(f, a, c, b) {
      var l = a.parse, v = b.addEvent, w = b.clamp, z = b.defined, y = b.extend;
      a = b.extendClass;
      var d = b.fireEvent, m = b.isArray, n = b.isNumber, t = b.merge, x = b.pick;
      b = b.seriesType;
      var A = f.Series, r = f.Chart, p = f.layouts["reingold-fruchterman"], h = f.seriesTypes.bubble.prototype.pointClass, g = f.dragNodesMixin;
      f.networkgraphIntegrations.packedbubble = {
        repulsiveForceFunction: function(a, b, c, d) {
          return Math.min(a, (c.marker.radius + d.marker.radius) / 2);
        },
        barycenter: function() {
          var a = this, b = a.options.gravitationalConstant, c = a.box, d = a.nodes, f, g;
          d.forEach(function(e) {
            a.options.splitSeries && !e.isParentNode ? (f = e.series.parentNode.plotX, g = e.series.parentNode.plotY) : (f = c.width / 2, 
            g = c.height / 2);
            e.fixedPosition || (e.plotX -= (e.plotX - f) * b / (e.mass * Math.sqrt(d.length)), 
            e.plotY -= (e.plotY - g) * b / (e.mass * Math.sqrt(d.length)));
          });
        },
        repulsive: function(a, b, c, d) {
          var e = b * this.diffTemperature / a.mass / a.degree;
          b = c.x * e;
          c = c.y * e;
          a.fixedPosition || (a.plotX += b, a.plotY += c);
          d.fixedPosition || (d.plotX -= b, d.plotY -= c);
        },
        integrate: f.networkgraphIntegrations.verlet.integrate,
        getK: f.noop
      };
      f.layouts.packedbubble = a(p, {
        beforeStep: function() {
          this.options.marker && this.series.forEach(function(a) {
            a && a.calculateParentRadius();
          });
        },
        setCircularPositions: function() {
          var a = this, b = a.box, c = a.nodes, d = 2 * Math.PI / (c.length + 1), f, g, h = a.options.initialPositionRadius;
          c.forEach(function(e, c) {
            a.options.splitSeries && !e.isParentNode ? (f = e.series.parentNode.plotX, g = e.series.parentNode.plotY) : (f = b.width / 2, 
            g = b.height / 2);
            e.plotX = e.prevX = x(e.plotX, f + h * Math.cos(e.index || c * d));
            e.plotY = e.prevY = x(e.plotY, g + h * Math.sin(e.index || c * d));
            e.dispX = 0;
            e.dispY = 0;
          });
        },
        repulsiveForces: function() {
          var a = this, b, c, d, f = a.options.bubblePadding;
          a.nodes.forEach(function(e) {
            e.degree = e.mass;
            e.neighbours = 0;
            a.nodes.forEach(function(k) {
              b = 0;
              e === k || e.fixedPosition || !a.options.seriesInteraction && e.series !== k.series || (d = a.getDistXY(e, k), 
              c = a.vectorLength(d) - (e.marker.radius + k.marker.radius + f), 0 > c && (e.degree += .01, 
              e.neighbours++, b = a.repulsiveForce(-c / Math.sqrt(e.neighbours), a.k, e, k)), 
              a.force("repulsive", e, b * k.mass, d, k, c));
            });
          });
        },
        applyLimitBox: function(a) {
          if (this.options.splitSeries && !a.isParentNode && this.options.parentNodeLimit) {
            var e = this.getDistXY(a, a.series.parentNode);
            var b = a.series.parentNodeRadius - a.marker.radius - this.vectorLength(e);
            0 > b && b > -2 * a.marker.radius && (a.plotX -= .01 * e.x, a.plotY -= .01 * e.y);
          }
          p.prototype.applyLimitBox.apply(this, arguments);
        },
        isStable: function() {
          return 1e-5 > Math.abs(this.systemTemperature - this.prevSystemTemperature) || 0 >= this.temperature || 0 < this.systemTemperature && .02 > this.systemTemperature / this.nodes.length && this.enableSimulation;
        }
      });
      b("packedbubble", "bubble", {
        minSize: "10%",
        maxSize: "50%",
        sizeBy: "area",
        zoneAxis: "y",
        tooltip: {
          pointFormat: "Value: {point.value}"
        },
        draggable: !0,
        useSimulation: !0,
        dataLabels: {
          formatter: function() {
            return this.point.value;
          },
          parentNodeFormatter: function() {
            return this.name;
          },
          parentNodeTextPath: {
            enabled: !0
          },
          padding: 0
        },
        layoutAlgorithm: {
          initialPositions: "circle",
          initialPositionRadius: 20,
          bubblePadding: 5,
          parentNodeLimit: !1,
          seriesInteraction: !0,
          dragBetweenSeries: !1,
          parentNodeOptions: {
            maxIterations: 400,
            gravitationalConstant: .03,
            maxSpeed: 50,
            initialPositionRadius: 100,
            seriesInteraction: !0,
            marker: {
              fillColor: null,
              fillOpacity: 1,
              lineWidth: 1,
              lineColor: null,
              symbol: "circle"
            }
          },
          enableSimulation: !0,
          type: "packedbubble",
          integration: "packedbubble",
          maxIterations: 1e3,
          splitSeries: !1,
          maxSpeed: 5,
          gravitationalConstant: .01,
          friction: -.981
        }
      }, {
        hasDraggableNodes: !0,
        forces: [ "barycenter", "repulsive" ],
        pointArrayMap: [ "value" ],
        pointValKey: "value",
        isCartesian: !1,
        requireSorting: !1,
        directTouch: !0,
        axisTypes: [],
        noSharedTooltip: !0,
        searchPoint: f.noop,
        accumulateAllPoints: function(a) {
          var e = a.chart, b = [], c, d;
          for (c = 0; c < e.series.length; c++) if (a = e.series[c], a.visible || !e.options.chart.ignoreHiddenSeries) for (d = 0; d < a.yData.length; d++) b.push([ null, null, a.yData[d], a.index, d, {
            id: d,
            marker: {
              radius: 0
            }
          } ]);
          return b;
        },
        init: function() {
          A.prototype.init.apply(this, arguments);
          v(this, "updatedData", function() {
            this.chart.series.forEach(function(a) {
              a.type === this.type && (a.isDirty = !0);
            }, this);
          });
          return this;
        },
        render: function() {
          var a = [];
          A.prototype.render.apply(this, arguments);
          this.options.dataLabels.allowOverlap || (this.data.forEach(function(e) {
            m(e.dataLabels) && e.dataLabels.forEach(function(e) {
              a.push(e);
            });
          }), this.options.useSimulation && this.chart.hideOverlappingLabels(a));
        },
        setVisible: function() {
          var a = this;
          A.prototype.setVisible.apply(a, arguments);
          a.parentNodeLayout && a.graph ? a.visible ? (a.graph.show(), a.parentNode.dataLabel && a.parentNode.dataLabel.show()) : (a.graph.hide(), 
          a.parentNodeLayout.removeElementFromCollection(a.parentNode, a.parentNodeLayout.nodes), 
          a.parentNode.dataLabel && a.parentNode.dataLabel.hide()) : a.layout && (a.visible ? a.layout.addElementsToCollection(a.points, a.layout.nodes) : a.points.forEach(function(e) {
            a.layout.removeElementFromCollection(e, a.layout.nodes);
          }));
        },
        drawDataLabels: function() {
          var a = this.options.dataLabels.textPath, b = this.points;
          A.prototype.drawDataLabels.apply(this, arguments);
          this.parentNode && (this.parentNode.formatPrefix = "parentNode", this.points = [ this.parentNode ], 
          this.options.dataLabels.textPath = this.options.dataLabels.parentNodeTextPath, A.prototype.drawDataLabels.apply(this, arguments), 
          this.points = b, this.options.dataLabels.textPath = a);
        },
        seriesBox: function() {
          var a = this.chart, b = Math.max, c = Math.min, d, f = [ a.plotLeft, a.plotLeft + a.plotWidth, a.plotTop, a.plotTop + a.plotHeight ];
          this.data.forEach(function(a) {
            z(a.plotX) && z(a.plotY) && a.marker.radius && (d = a.marker.radius, f[0] = c(f[0], a.plotX - d), 
            f[1] = b(f[1], a.plotX + d), f[2] = c(f[2], a.plotY - d), f[3] = b(f[3], a.plotY + d));
          });
          return n(f.width / f.height) ? f : null;
        },
        calculateParentRadius: function() {
          var a = this.seriesBox();
          this.parentNodeRadius = w(Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20, 20, a ? Math.max(Math.sqrt(Math.pow(a.width, 2) + Math.pow(a.height, 2)) / 2 + 20, 20) : Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20);
          this.parentNode && (this.parentNode.marker.radius = this.parentNode.radius = this.parentNodeRadius);
        },
        drawGraph: function() {
          if (this.layout && this.layout.options.splitSeries) {
            var a = this.chart, b = this.layout.options.parentNodeOptions.marker;
            b = {
              fill: b.fillColor || l(this.color).brighten(.4).get(),
              opacity: b.fillOpacity,
              stroke: b.lineColor || this.color,
              "stroke-width": b.lineWidth
            };
            var c = this.visible ? "inherit" : "hidden";
            this.parentNodesGroup || (this.parentNodesGroup = this.plotGroup("parentNodesGroup", "parentNode", c, .1, a.seriesGroup), 
            this.group.attr({
              zIndex: 2
            }));
            this.calculateParentRadius();
            c = t({
              x: this.parentNode.plotX - this.parentNodeRadius,
              y: this.parentNode.plotY - this.parentNodeRadius,
              width: 2 * this.parentNodeRadius,
              height: 2 * this.parentNodeRadius
            }, b);
            this.parentNode.graphic || (this.graph = this.parentNode.graphic = a.renderer.symbol(b.symbol).add(this.parentNodesGroup));
            this.parentNode.graphic.attr(c);
          }
        },
        createParentNodes: function() {
          var a = this, b = a.chart, c = a.parentNodeLayout, d, f = a.parentNode;
          a.parentNodeMass = 0;
          a.points.forEach(function(e) {
            a.parentNodeMass += Math.PI * Math.pow(e.marker.radius, 2);
          });
          a.calculateParentRadius();
          c.nodes.forEach(function(e) {
            e.seriesIndex === a.index && (d = !0);
          });
          c.setArea(0, 0, b.plotWidth, b.plotHeight);
          d || (f || (f = new h().init(this, {
            mass: a.parentNodeRadius / 2,
            marker: {
              radius: a.parentNodeRadius
            },
            dataLabels: {
              inside: !1
            },
            dataLabelOnNull: !0,
            degree: a.parentNodeRadius,
            isParentNode: !0,
            seriesIndex: a.index
          })), a.parentNode && (f.plotX = a.parentNode.plotX, f.plotY = a.parentNode.plotY), 
          a.parentNode = f, c.addElementsToCollection([ a ], c.series), c.addElementsToCollection([ f ], c.nodes));
        },
        addSeriesLayout: function() {
          var a = this.options.layoutAlgorithm, b = this.chart.graphLayoutsStorage, c = this.chart.graphLayoutsLookup, d = t(a, a.parentNodeOptions, {
            enableSimulation: this.layout.options.enableSimulation
          });
          var g = b[a.type + "-series"];
          g || (b[a.type + "-series"] = g = new f.layouts[a.type](), g.init(d), c.splice(g.index, 0, g));
          this.parentNodeLayout = g;
          this.createParentNodes();
        },
        addLayout: function() {
          var a = this.options.layoutAlgorithm, b = this.chart.graphLayoutsStorage, c = this.chart.graphLayoutsLookup, d = this.chart.options.chart;
          b || (this.chart.graphLayoutsStorage = b = {}, this.chart.graphLayoutsLookup = c = []);
          var g = b[a.type];
          g || (a.enableSimulation = z(d.forExport) ? !d.forExport : a.enableSimulation, b[a.type] = g = new f.layouts[a.type](), 
          g.init(a), c.splice(g.index, 0, g));
          this.layout = g;
          this.points.forEach(function(a) {
            a.mass = 2;
            a.degree = 1;
            a.collisionNmb = 1;
          });
          g.setArea(0, 0, this.chart.plotWidth, this.chart.plotHeight);
          g.addElementsToCollection([ this ], g.series);
          g.addElementsToCollection(this.points, g.nodes);
        },
        deferLayout: function() {
          var a = this.options.layoutAlgorithm;
          this.visible && (this.addLayout(), a.splitSeries && this.addSeriesLayout());
        },
        translate: function() {
          var a = this.chart, b = this.data, c = this.index, f, g = this.options.useSimulation;
          this.processedXData = this.xData;
          this.generatePoints();
          z(a.allDataPoints) || (a.allDataPoints = this.accumulateAllPoints(this), this.getPointRadius());
          if (g) var h = a.allDataPoints; else h = this.placeBubbles(a.allDataPoints), this.options.draggable = !1;
          for (f = 0; f < h.length; f++) if (h[f][3] === c) {
            var p = b[h[f][4]];
            var r = h[f][2];
            g || (p.plotX = h[f][0] - a.plotLeft + a.diffX, p.plotY = h[f][1] - a.plotTop + a.diffY);
            p.marker = y(p.marker, {
              radius: r,
              width: 2 * r,
              height: 2 * r
            });
            p.radius = r;
          }
          g && this.deferLayout();
          d(this, "afterTranslate");
        },
        checkOverlap: function(a, b) {
          var e = a[0] - b[0], c = a[1] - b[1];
          return -.001 > Math.sqrt(e * e + c * c) - Math.abs(a[2] + b[2]);
        },
        positionBubble: function(a, b, c) {
          var e = Math.sqrt, d = Math.asin, f = Math.acos, g = Math.pow, k = Math.abs;
          e = e(g(a[0] - b[0], 2) + g(a[1] - b[1], 2));
          f = f((g(e, 2) + g(c[2] + b[2], 2) - g(c[2] + a[2], 2)) / (2 * (c[2] + b[2]) * e));
          d = d(k(a[0] - b[0]) / e);
          a = (0 > a[1] - b[1] ? 0 : Math.PI) + f + d * (0 > (a[0] - b[0]) * (a[1] - b[1]) ? 1 : -1);
          return [ b[0] + (b[2] + c[2]) * Math.sin(a), b[1] - (b[2] + c[2]) * Math.cos(a), c[2], c[3], c[4] ];
        },
        placeBubbles: function(a) {
          var b = this.checkOverlap, e = this.positionBubble, c = [], d = 1, f = 0, g = 0;
          var h = [];
          var p;
          a = a.sort(function(a, b) {
            return b[2] - a[2];
          });
          if (a.length) {
            c.push([ [ 0, 0, a[0][2], a[0][3], a[0][4] ] ]);
            if (1 < a.length) for (c.push([ [ 0, 0 - a[1][2] - a[0][2], a[1][2], a[1][3], a[1][4] ] ]), 
            p = 2; p < a.length; p++) a[p][2] = a[p][2] || 1, h = e(c[d][f], c[d - 1][g], a[p]), 
            b(h, c[d][0]) ? (c.push([]), g = 0, c[d + 1].push(e(c[d][f], c[d][0], a[p])), d++, 
            f = 0) : 1 < d && c[d - 1][g + 1] && b(h, c[d - 1][g + 1]) ? (g++, c[d].push(e(c[d][f], c[d - 1][g], a[p])), 
            f++) : (f++, c[d].push(h));
            this.chart.stages = c;
            this.chart.rawPositions = [].concat.apply([], c);
            this.resizeRadius();
            h = this.chart.rawPositions;
          }
          return h;
        },
        resizeRadius: function() {
          var a = this.chart, b = a.rawPositions, c = Math.min, d = Math.max, f = a.plotLeft, g = a.plotTop, h = a.plotHeight, p = a.plotWidth, r, l, m;
          var n = r = Number.POSITIVE_INFINITY;
          var t = l = Number.NEGATIVE_INFINITY;
          for (m = 0; m < b.length; m++) {
            var u = b[m][2];
            n = c(n, b[m][0] - u);
            t = d(t, b[m][0] + u);
            r = c(r, b[m][1] - u);
            l = d(l, b[m][1] + u);
          }
          m = [ t - n, l - r ];
          c = c.apply([], [ (p - f) / m[0], (h - g) / m[1] ]);
          if (1e-10 < Math.abs(c - 1)) {
            for (m = 0; m < b.length; m++) b[m][2] *= c;
            this.placeBubbles(b);
          } else a.diffY = h / 2 + g - r - (l - r) / 2, a.diffX = p / 2 + f - n - (t - n) / 2;
        },
        calculateZExtremes: function() {
          var a = this.options.zMin, b = this.options.zMax, c = Infinity, d = -Infinity;
          if (a && b) return [ a, b ];
          this.chart.series.forEach(function(a) {
            a.yData.forEach(function(a) {
              z(a) && (a > d && (d = a), a < c && (c = a));
            });
          });
          a = x(a, c);
          b = x(b, d);
          return [ a, b ];
        },
        getPointRadius: function() {
          var a = this, b = a.chart, c = a.options, d = c.useSimulation, f = Math.min(b.plotWidth, b.plotHeight), g = {}, h = [], p = b.allDataPoints, r, l, m, n;
          [ "minSize", "maxSize" ].forEach(function(a) {
            var b = parseInt(c[a], 10), e = /%$/.test(c[a]);
            g[a] = e ? f * b / 100 : b * Math.sqrt(p.length);
          });
          b.minRadius = r = g.minSize / Math.sqrt(p.length);
          b.maxRadius = l = g.maxSize / Math.sqrt(p.length);
          var t = d ? a.calculateZExtremes() : [ r, l ];
          (p || []).forEach(function(b, e) {
            m = d ? w(b[2], t[0], t[1]) : b[2];
            n = a.getRadius(t[0], t[1], r, l, m);
            0 === n && (n = null);
            p[e][2] = n;
            h.push(n);
          });
          a.radii = h;
        },
        redrawHalo: g.redrawHalo,
        onMouseDown: g.onMouseDown,
        onMouseMove: g.onMouseMove,
        onMouseUp: function(a) {
          if (a.fixedPosition && !a.removed) {
            var b, c, e = this.layout, d = this.parentNodeLayout;
            d && e.options.dragBetweenSeries && d.nodes.forEach(function(d) {
              a && a.marker && d !== a.series.parentNode && (b = e.getDistXY(a, d), c = e.vectorLength(b) - d.marker.radius - a.marker.radius, 
              0 > c && (d.series.addPoint(t(a.options, {
                plotX: a.plotX,
                plotY: a.plotY
              }), !1), e.removeElementFromCollection(a, e.nodes), a.remove()));
            });
            g.onMouseUp.apply(this, arguments);
          }
        },
        destroy: function() {
          this.chart.graphLayoutsLookup && this.chart.graphLayoutsLookup.forEach(function(a) {
            a.removeElementFromCollection(this, a.series);
          }, this);
          this.parentNode && (this.parentNodeLayout.removeElementFromCollection(this.parentNode, this.parentNodeLayout.nodes), 
          this.parentNode.dataLabel && (this.parentNode.dataLabel = this.parentNode.dataLabel.destroy()));
          f.Series.prototype.destroy.apply(this, arguments);
        },
        alignDataLabel: f.Series.prototype.alignDataLabel
      }, {
        destroy: function() {
          this.series.layout && this.series.layout.removeElementFromCollection(this, this.series.layout.nodes);
          return c.prototype.destroy.apply(this, arguments);
        }
      });
      v(r, "beforeRedraw", function() {
        this.allDataPoints && delete this.allDataPoints;
      });
    });
    E(f, "parts-more/Polar.js", [ f["parts/Globals.js"], f["parts/Utilities.js"], f["parts-more/Pane.js"] ], function(f, a, c) {
      var b = a.addEvent, l = a.defined, v = a.find, w = a.pick, z = a.splat, y = a.uniqueKey, d = a.wrap, m = f.Series, n = f.seriesTypes, t = m.prototype, x = f.Pointer.prototype;
      t.searchPointByAngle = function(a) {
        var b = this.chart, c = this.xAxis.pane.center;
        return this.searchKDTree({
          clientX: 180 + -180 / Math.PI * Math.atan2(a.chartX - c[0] - b.plotLeft, a.chartY - c[1] - b.plotTop)
        });
      };
      t.getConnectors = function(a, b, c, d) {
        var e = d ? 1 : 0;
        var f = 0 <= b && b <= a.length - 1 ? b : 0 > b ? a.length - 1 + b : 0;
        b = 0 > f - 1 ? a.length - (1 + e) : f - 1;
        e = f + 1 > a.length - 1 ? e : f + 1;
        var g = a[b];
        e = a[e];
        var h = g.plotX;
        g = g.plotY;
        var p = e.plotX;
        var r = e.plotY;
        e = a[f].plotX;
        f = a[f].plotY;
        h = (1.5 * e + h) / 2.5;
        g = (1.5 * f + g) / 2.5;
        p = (1.5 * e + p) / 2.5;
        var l = (1.5 * f + r) / 2.5;
        r = Math.sqrt(Math.pow(h - e, 2) + Math.pow(g - f, 2));
        var m = Math.sqrt(Math.pow(p - e, 2) + Math.pow(l - f, 2));
        h = Math.atan2(g - f, h - e);
        l = Math.PI / 2 + (h + Math.atan2(l - f, p - e)) / 2;
        Math.abs(h - l) > Math.PI / 2 && (l -= Math.PI);
        h = e + Math.cos(l) * r;
        g = f + Math.sin(l) * r;
        p = e + Math.cos(Math.PI + l) * m;
        l = f + Math.sin(Math.PI + l) * m;
        e = {
          rightContX: p,
          rightContY: l,
          leftContX: h,
          leftContY: g,
          plotX: e,
          plotY: f
        };
        c && (e.prevPointCont = this.getConnectors(a, b, !1, d));
        return e;
      };
      t.toXY = function(a) {
        var b = this.chart, c = this.xAxis;
        var d = this.yAxis;
        var e = a.plotX, f = a.plotY, l = a.series, r = b.inverted, m = a.y, n = r ? e : d.len - f;
        r && l && !l.isRadialBar && (a.plotY = f = "number" === typeof m ? d.translate(m) || 0 : 0);
        a.rectPlotX = e;
        a.rectPlotY = f;
        d.center && (n += d.center[3] / 2);
        d = r ? d.postTranslate(f, n) : c.postTranslate(e, n);
        a.plotX = a.polarPlotX = d.x - b.plotLeft;
        a.plotY = a.polarPlotY = d.y - b.plotTop;
        this.kdByAngle ? (b = (e / Math.PI * 180 + c.pane.options.startAngle) % 360, 0 > b && (b += 360), 
        a.clientX = b) : a.clientX = a.plotX;
      };
      n.spline && (d(n.spline.prototype, "getPointSpline", function(a, b, c, d) {
        this.chart.polar ? d ? (a = this.getConnectors(b, d, !0, this.connectEnds), a = [ "C", a.prevPointCont.rightContX, a.prevPointCont.rightContY, a.leftContX, a.leftContY, a.plotX, a.plotY ]) : a = [ "M", c.plotX, c.plotY ] : a = a.call(this, b, c, d);
        return a;
      }), n.areasplinerange && (n.areasplinerange.prototype.getPointSpline = n.spline.prototype.getPointSpline));
      b(m, "afterTranslate", function() {
        var a = this.chart;
        if (a.polar && this.xAxis) {
          (this.kdByAngle = a.tooltip && a.tooltip.shared) ? this.searchPoint = this.searchPointByAngle : this.options.findNearestPointBy = "xy";
          if (!this.preventPostTranslate) for (var c = this.points, d = c.length; d--; ) this.toXY(c[d]), 
          !a.hasParallelCoordinates && !this.yAxis.reversed && c[d].y < this.yAxis.min && (c[d].isNull = !0);
          this.hasClipCircleSetter || (this.hasClipCircleSetter = !!this.eventsToUnbind.push(b(this, "afterRender", function() {
            if (a.polar) {
              var b = this.yAxis.pane.center;
              this.clipCircle ? this.clipCircle.animate({
                x: b[0],
                y: b[1],
                r: b[2] / 2,
                innerR: b[3] / 2
              }) : this.clipCircle = a.renderer.clipCircle(b[0], b[1], b[2] / 2, b[3] / 2);
              this.group.clip(this.clipCircle);
              this.setClip = f.noop;
            }
          })));
        }
      }, {
        order: 2
      });
      d(t, "getGraphPath", function(a, b) {
        var c = this, d;
        if (this.chart.polar) {
          b = b || this.points;
          for (d = 0; d < b.length; d++) if (!b[d].isNull) {
            var e = d;
            break;
          }
          if (!1 !== this.options.connectEnds && "undefined" !== typeof e) {
            this.connectEnds = !0;
            b.splice(b.length, 0, b[e]);
            var f = !0;
          }
          b.forEach(function(a) {
            "undefined" === typeof a.polarPlotY && c.toXY(a);
          });
        }
        d = a.apply(this, [].slice.call(arguments, 1));
        f && b.pop();
        return d;
      });
      var A = function(a, b) {
        var c = this, d = this.chart, e = this.options.animation, k = this.group, p = this.markerGroup, l = this.xAxis.center, m = d.plotLeft, r = d.plotTop, n, t, u, v;
        if (d.polar) {
          if (c.isRadialBar) b || (c.startAngleRad = w(c.translatedThreshold, c.xAxis.startAngleRad), 
          f.seriesTypes.pie.prototype.animate.call(c, b)); else {
            if (d.renderer.isSVG) if (e = f.animObject(e), c.is("column")) {
              if (!b) {
                var x = l[3] / 2;
                c.points.forEach(function(a) {
                  n = a.graphic;
                  u = (t = a.shapeArgs) && t.r;
                  v = t && t.innerR;
                  n && t && (n.attr({
                    r: x,
                    innerR: x
                  }), n.animate({
                    r: u,
                    innerR: v
                  }, c.options.animation));
                });
              }
            } else b ? (a = {
              translateX: l[0] + m,
              translateY: l[1] + r,
              scaleX: .001,
              scaleY: .001
            }, k.attr(a), p && p.attr(a)) : (a = {
              translateX: m,
              translateY: r,
              scaleX: 1,
              scaleY: 1
            }, k.animate(a, e), p && p.animate(a, e));
          }
        } else a.call(this, b);
      };
      d(t, "animate", A);
      n.column && (m = n.arearange.prototype, n = n.column.prototype, n.polarArc = function(a, b, c, d) {
        var e = this.xAxis.center, f = this.yAxis.len, g = e[3] / 2;
        b = f - b + g;
        a = f - w(a, f) + g;
        this.yAxis.reversed && (0 > b && (b = g), 0 > a && (a = g));
        return {
          x: e[0],
          y: e[1],
          r: b,
          innerR: a,
          start: c,
          end: d
        };
      }, d(n, "animate", A), d(n, "translate", function(b) {
        var c = this.options, d = c.stacking, g = this.chart, e = this.xAxis, k = this.yAxis, m = k.reversed, r = k.center, n = e.startAngleRad, t = e.endAngleRad - n;
        this.preventPostTranslate = !0;
        b.call(this);
        if (e.isRadial) {
          b = this.points;
          e = b.length;
          var u = k.translate(k.min);
          var v = k.translate(k.max);
          c = c.threshold || 0;
          if (g.inverted && f.isNumber(c)) {
            var w = k.translate(c);
            l(w) && (0 > w ? w = 0 : w > t && (w = t), this.translatedThreshold = w + n);
          }
          for (;e--; ) {
            c = b[e];
            var x = c.barX;
            var y = c.x;
            var A = c.y;
            c.shapeType = "arc";
            if (g.inverted) {
              c.plotY = k.translate(A);
              if (d) {
                if (A = k.stacks[(0 > A ? "-" : "") + this.stackKey], this.visible && A && A[y] && !c.isNull) {
                  var z = A[y].points[this.getStackIndicator(void 0, y, this.index).key];
                  var D = k.translate(z[0]);
                  z = k.translate(z[1]);
                  l(D) && (D = a.clamp(D, 0, t));
                }
              } else D = w, z = c.plotY;
              D > z && (z = [ D, D = z ][0]);
              if (!m) {
                if (D < u) D = u; else if (z > v) z = v; else {
                  if (z < u || D > v) D = z = 0;
                }
              } else if (z > u) z = u; else if (D < v) D = v; else if (D > u || z < v) D = z = t;
              k.min > k.max && (D = z = m ? t : 0);
              D += n;
              z += n;
              r && (c.barX = x += r[3] / 2);
              y = Math.max(x, 0);
              A = Math.max(x + c.pointWidth, 0);
              c.shapeArgs = {
                x: r && r[0],
                y: r && r[1],
                r: A,
                innerR: y,
                start: D,
                end: z
              };
              c.opacity = D === z ? 0 : void 0;
              c.plotY = (l(this.translatedThreshold) && (D < this.translatedThreshold ? D : z)) - n;
            } else D = x + n, c.shapeArgs = this.polarArc(c.yBottom, c.plotY, D, D + c.pointWidth);
            this.toXY(c);
            g.inverted ? (x = k.postTranslate(c.rectPlotY, x + c.pointWidth / 2), c.tooltipPos = [ x.x - g.plotLeft, x.y - g.plotTop ]) : c.tooltipPos = [ c.plotX, c.plotY ];
            r && (c.ttBelow = c.plotY > r[1]);
          }
        }
      }), n.findAlignments = function(a, b) {
        null === b.align && (b.align = 20 < a && 160 > a ? "left" : 200 < a && 340 > a ? "right" : "center");
        null === b.verticalAlign && (b.verticalAlign = 45 > a || 315 < a ? "bottom" : 135 < a && 225 > a ? "top" : "middle");
        return b;
      }, m && (m.findAlignments = n.findAlignments), d(n, "alignDataLabel", function(a, b, c, d, e, f) {
        var g = this.chart, h = w(d.inside, !!this.options.stacking);
        g.polar ? (a = b.rectPlotX / Math.PI * 180, g.inverted ? (this.forceDL = g.isInsidePlot(b.plotX, Math.round(b.plotY), !1), 
        h && b.shapeArgs ? (e = b.shapeArgs, e = this.yAxis.postTranslate((e.start + e.end) / 2 - this.xAxis.startAngleRad, b.barX + b.pointWidth / 2), 
        e = {
          x: e.x - g.plotLeft,
          y: e.y - g.plotTop
        }) : b.tooltipPos && (e = {
          x: b.tooltipPos[0],
          y: b.tooltipPos[1]
        }), d.align = w(d.align, "center"), d.verticalAlign = w(d.verticalAlign, "middle")) : this.findAlignments && (d = this.findAlignments(a, d)), 
        t.alignDataLabel.call(this, b, c, d, e, f), this.isRadialBar && b.shapeArgs && b.shapeArgs.start === b.shapeArgs.end && c.hide(!0)) : a.call(this, b, c, d, e, f);
      }));
      d(x, "getCoordinates", function(a, b) {
        var c = this.chart, d = {
          xAxis: [],
          yAxis: []
        };
        c.polar ? c.axes.forEach(function(a) {
          var e = a.isXAxis, f = a.center;
          if ("colorAxis" !== a.coll) {
            var g = b.chartX - f[0] - c.plotLeft;
            f = b.chartY - f[1] - c.plotTop;
            d[e ? "xAxis" : "yAxis"].push({
              axis: a,
              value: a.translate(e ? Math.PI - Math.atan2(g, f) : Math.sqrt(Math.pow(g, 2) + Math.pow(f, 2)), !0)
            });
          }
        }) : d = a.call(this, b);
        return d;
      });
      f.SVGRenderer.prototype.clipCircle = function(a, b, c, d) {
        var e = y(), f = this.createElement("clipPath").attr({
          id: e
        }).add(this.defs);
        a = d ? this.arc(a, b, c, d, 0, 2 * Math.PI).add(f) : this.circle(a, b, c).add(f);
        a.id = e;
        a.clipPath = f;
        return a;
      };
      b(f.Chart, "getAxes", function() {
        this.pane || (this.pane = []);
        z(this.options.pane).forEach(function(a) {
          new c(a, this);
        }, this);
      });
      b(f.Chart, "afterDrawChartBox", function() {
        this.pane.forEach(function(a) {
          a.render();
        });
      });
      b(f.Series, "afterInit", function() {
        var a = this.chart;
        a.inverted && a.polar && (this.isRadialSeries = !0, this.is("column") && (this.isRadialBar = !0));
      });
      d(f.Chart.prototype, "get", function(a, b) {
        return v(this.pane, function(a) {
          return a.options.id === b;
        }) || a.call(this, b);
      });
    });
    E(f, "masters/highcharts-more.src.js", [], function() {});
  });
});

var Highcharts$1 = window.Highcharts;

var $$4 = window.$;

highchartsMore(Highcharts$1);

var _default$a = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {
      var _this = this;
      $$4.getJSON(this.data.get("url"), function(data) {
        Highcharts$1.chart(_this.element, {
          chart: {
            scrollablePlotArea: {
              minWidth: 600,
              scrollPositionX: 1
            }
          },
          title: {
            text: "",
            align: "left"
          },
          subtitle: {
            text: "",
            align: "left"
          },
          xAxis: {
            title: {
              text: "D/P creatinine (4hrs)"
            },
            type: "linear",
            labels: {
              overflow: "justify"
            },
            plotBands: [ {
              from: .3,
              to: .5,
              color: "rgba(68, 170, 213, 0.1)",
              label: {
                text: "Low",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: .5,
              to: .65,
              color: "rgba(0, 0, 0, 0)",
              label: {
                text: "Low average",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: .65,
              to: .82,
              color: "rgba(68, 170, 213, 0.1)",
              label: {
                text: "High average",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: .82,
              to: 1,
              color: "rgba(0, 0, 0, 0)",
              label: {
                text: "High",
                style: {
                  color: "#606060"
                }
              }
            } ]
          },
          yAxis: {
            title: {
              text: "Net Ultrafiltration (mls)"
            },
            tickInterval: 200,
            minorGridLineWidth: 0,
            gridLineWidth: 0,
            alternateGridColor: null,
            floor: -600,
            plotLines: [ {
              color: "#BBB",
              width: 1,
              value: 0
            } ]
          },
          tooltip: {
            formatter: function formatter() {
              return "<br>D_Pcr <b>" + this.x + "</b><br>" + "netUF <b>" + this.y + "</b>";
            }
          },
          plotOptions: {
            pointStart: .3,
            line: {
              dataLabels: {
                enabled: true,
                format: "{point.index}",
                style: {
                  fontSize: "15px"
                }
              }
            },
            series: {
              enableMouseTracking: false
            },
            dataLabels: {
              enabled: true,
              style: {
                fontWeight: "bold"
              }
            }
          },
          series: [ {
            name: "Expected",
            color: "#00a499",
            showInLegend: true,
            type: "polygon",
            data: [ [ .36, 400 ], [ .36, 1e3 ], [ .5, 1e3 ], [ .9, 600 ], [ .9, 300 ], [ .6, 100 ], [ .36, 400 ] ]
          }, {
            name: "Warning",
            color: "#fff495",
            showInLegend: true,
            type: "polygon",
            data: [ [ .6, 100 ], [ .9, 300 ], [ 1, 200 ], [ 1, -600 ], [ .75, -600 ], [ .6, 100 ] ]
          }, {
            color: "#040481",
            showInLegend: false,
            enableMouseTracking: true,
            data: data
          } ],
          navigation: {
            menuItemStyle: {
              fontSize: "10px"
            }
          }
        });
        _this.element.style.overflow = "unset";
      });
    }
  } ]);
  return _default;
}(Controller);

var _default$b = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {
      console.log("Not implemented");
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$b, "targets", [ "chart" ]);

var _default$c = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "connect",
    value: function connect() {}
  }, {
    key: "open",
    value: function open(event) {
      var _this = this;
      var index = this.linkTargets.indexOf(event.currentTarget);
      this.sectionTargets.forEach(function(elem, idx) {
        elem.classList.remove(_this.openClass);
        if (idx == index) {
          elem.classList.add(_this.openClass);
        }
      });
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$c, "targets", [ "section", "link" ]);

_defineProperty(_default$c, "classes", [ "open" ]);

var _default$d = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "handleSelectChange",
    value: function handleSelectChange() {
      this.populateSelect(this.sourceTarget.value);
    }
  }, {
    key: "populateSelect",
    value: function populateSelect(sourceId) {
      var _this = this;
      var targetId = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
      fetch("/".concat(this.data.get("sourceRoutePart"), "/").concat(sourceId, "/").concat(this.data.get("targetRoutePart"), ".json"), {
        credentials: "same-origin"
      }).then(function(response) {
        return response.json();
      }).then(function(data) {
        var selectBox = _this.targetTarget;
        selectBox.innerHTML = "";
        selectBox.appendChild(document.createElement("option"));
        data.forEach(function(item) {
          var opt = document.createElement("option");
          opt.value = item.id;
          opt.innerHTML = item[_this.data.get("displayAttribute")];
          opt.selected = parseInt(targetId) === item.id;
          selectBox.appendChild(opt);
        });
      });
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$d, "targets", [ "source", "target" ]);

var _default$e = function(_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [ {
    key: "toggleFileInputs",
    value: function toggleFileInputs(event) {
      var selectedOption = event.target.querySelector("option:checked");
      var storeFileExternally = "true" == selectedOption.getAttribute("data-store-file-externally");
      this.fileBrowserTarget.style.display = storeFileExternally ? "none" : "block";
      this.externalLocationTarget.style.display = storeFileExternally ? "block" : "none";
    }
  } ]);
  return _default;
}(Controller);

_defineProperty(_default$e, "targets", [ "fileBrowser", "externalLocation" ]);

var application = Application.start();

application.register("toggle", _default);

application.register("hd-prescription-administration", _default$1);

application.register("home-delivery-modal", _default$2);

application.register("snippets", _default$3);

application.register("letters-form", _default$4);

application.register("prescriptions", _default$5);

application.register("charts", _default$6);

application.register("session", _default$7);

application.register("simple-toggle", _default$8);

application.register("tabs", _default$9);

application.register("pd-pet-chart", _default$a);

application.register("pathology-sparklines", _default$b);

application.register("collapsible", _default$c);

application.register("dependent-select", _default$d);

application.register("patient-attachments", _default$e);

window.Chartkick.use(window.Highcharts);
