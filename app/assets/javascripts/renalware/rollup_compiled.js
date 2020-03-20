function createCommonjsModule(fn, module) {
  return module = {
    exports: {}
  }, fn(module, module.exports), module.exports;
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

var _core_1 = _core.version;

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

var _meta_1 = _meta.KEY;

var _meta_2 = _meta.NEED;

var _meta_3 = _meta.fastKey;

var _meta_4 = _meta.getWeak;

var _meta_5 = _meta.onFreeze;

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

var EventListener = function() {
  function EventListener(eventTarget, eventName) {
    this.eventTarget = eventTarget;
    this.eventName = eventName;
    this.unorderedBindings = new Set();
  }
  EventListener.prototype.connect = function() {
    this.eventTarget.addEventListener(this.eventName, this, false);
  };
  EventListener.prototype.disconnect = function() {
    this.eventTarget.removeEventListener(this.eventName, this, false);
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
    enumerable: true,
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
    enumerable: true,
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
    var eventTarget = binding.eventTarget, eventName = binding.eventName;
    return this.fetchEventListener(eventTarget, eventName);
  };
  Dispatcher.prototype.fetchEventListener = function(eventTarget, eventName) {
    var eventListenerMap = this.fetchEventListenerMapForEventTarget(eventTarget);
    var eventListener = eventListenerMap.get(eventName);
    if (!eventListener) {
      eventListener = this.createEventListener(eventTarget, eventName);
      eventListenerMap.set(eventName, eventListener);
    }
    return eventListener;
  };
  Dispatcher.prototype.createEventListener = function(eventTarget, eventName) {
    var eventListener = new EventListener(eventTarget, eventName);
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
  return Dispatcher;
}();

var descriptorPattern = /^((.+?)(@(window|document))?->)?(.+?)(#(.+))?$/;

function parseDescriptorString(descriptorString) {
  var source = descriptorString.trim();
  var matches = source.match(descriptorPattern) || [];
  return {
    eventTarget: parseEventTarget(matches[4]),
    eventName: matches[2],
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
    this.identifier = descriptor.identifier || error("missing identifier");
    this.methodName = descriptor.methodName || error("missing method name");
  }
  Action.forToken = function(token) {
    return new this(token.element, token.index, parseDescriptorString(token.content));
  };
  Action.prototype.toString = function() {
    var eventNameSuffix = this.eventTargetName ? "@" + this.eventTargetName : "";
    return "" + this.eventName + eventNameSuffix + "->" + this.identifier + "#" + this.methodName;
  };
  Object.defineProperty(Action.prototype, "eventTargetName", {
    get: function() {
      return stringifyEventTarget(this.eventTarget);
    },
    enumerable: true,
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
    return e.getAttribute("type") == "submit" ? "click" : "change";
  },
  select: function(e) {
    return "change";
  },
  textarea: function(e) {
    return "change";
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "eventTarget", {
    get: function() {
      return this.action.eventTarget;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "identifier", {
    get: function() {
      return this.context.identifier;
    },
    enumerable: true,
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
    enumerable: true,
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
    enumerable: true,
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
      return true;
    }
  };
  Object.defineProperty(Binding.prototype, "controller", {
    get: function() {
      return this.context.controller;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "methodName", {
    get: function() {
      return this.action.methodName;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "scope", {
    get: function() {
      return this.context.scope;
    },
    enumerable: true,
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(AttributeObserver.prototype, "selector", {
    get: function() {
      return "[" + this.attributeName + "]";
    },
    enumerable: true,
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
    enumerable: true,
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

function add(map, key, value) {
  fetch(map, key).add(value);
}

function del(map, key, value) {
  fetch(map, key).delete(value);
  prune(map, key);
}

function fetch(map, key) {
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Multimap.prototype, "size", {
    get: function() {
      var sets = Array.from(this.valuesByKey.values());
      return sets.reduce(function(size, set) {
        return size + set.size;
      }, 0);
    },
    enumerable: true,
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
  var extendStatics = Object.setPrototypeOf || {
    __proto__: []
  } instanceof Array && function(d, b) {
    d.__proto__ = b;
  } || function(d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
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
    enumerable: true,
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
    enumerable: true,
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(TokenListObserver.prototype, "attributeName", {
    get: function() {
      return this.attributeObserver.attributeName;
    },
    enumerable: true,
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
    enumerable: true,
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(ValueListObserver.prototype, "attributeName", {
    get: function() {
      return this.tokenListObserver.attributeName;
    },
    enumerable: true,
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "identifier", {
    get: function() {
      return this.context.identifier;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "actionAttribute", {
    get: function() {
      return this.schema.actionAttribute;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "schema", {
    get: function() {
      return this.context.schema;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "bindings", {
    get: function() {
      return Array.from(this.bindingsByAction.values());
    },
    enumerable: true,
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

var Context = function() {
  function Context(module, scope) {
    this.module = module;
    this.scope = scope;
    this.controller = new module.controllerConstructor(this);
    this.bindingObserver = new BindingObserver(this, this.dispatcher);
    try {
      this.controller.initialize();
    } catch (error) {
      this.handleError(error, "initializing controller");
    }
  }
  Context.prototype.connect = function() {
    this.bindingObserver.start();
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
    this.bindingObserver.stop();
  };
  Object.defineProperty(Context.prototype, "application", {
    get: function() {
      return this.module.application;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "identifier", {
    get: function() {
      return this.module.identifier;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "schema", {
    get: function() {
      return this.application.schema;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "dispatcher", {
    get: function() {
      return this.application.dispatcher;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "parentElement", {
    get: function() {
      return this.element.parentElement;
    },
    enumerable: true,
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

var __extends$1 = window && window.__extends || function() {
  var extendStatics = Object.setPrototypeOf || {
    __proto__: []
  } instanceof Array && function(d, b) {
    d.__proto__ = b;
  } || function(d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
  };
  return function(d, b) {
    extendStatics(d, b);
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

function blessDefinition(definition) {
  return {
    identifier: definition.identifier,
    controllerConstructor: blessControllerConstructor(definition.controllerConstructor)
  };
}

function blessControllerConstructor(controllerConstructor) {
  var constructor = extend(controllerConstructor);
  constructor.bless();
  return constructor;
}

var extend = function() {
  function extendWithReflect(constructor) {
    function Controller() {
      var _newTarget = this && this instanceof Controller ? this.constructor : void 0;
      return Reflect.construct(constructor, arguments, _newTarget);
    }
    Controller.prototype = Object.create(constructor.prototype, {
      constructor: {
        value: Controller
      }
    });
    Reflect.setPrototypeOf(Controller, constructor);
    return Controller;
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
        __extends$1(Controller, _super);
        function Controller() {
          return _super !== null && _super.apply(this, arguments) || this;
        }
        return Controller;
      }(constructor);
    };
  }
}();

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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Module.prototype, "controllerConstructor", {
    get: function() {
      return this.definition.controllerConstructor;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Module.prototype, "contexts", {
    get: function() {
      return Array.from(this.connectedContexts);
    },
    enumerable: true,
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

var DataMap = function() {
  function DataMap(scope) {
    this.scope = scope;
  }
  Object.defineProperty(DataMap.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(DataMap.prototype, "identifier", {
    get: function() {
      return this.scope.identifier;
    },
    enumerable: true,
    configurable: true
  });
  DataMap.prototype.get = function(key) {
    key = this.getFormattedKey(key);
    return this.element.getAttribute(key);
  };
  DataMap.prototype.set = function(key, value) {
    key = this.getFormattedKey(key);
    this.element.setAttribute(key, value);
    return this.get(key);
  };
  DataMap.prototype.has = function(key) {
    key = this.getFormattedKey(key);
    return this.element.hasAttribute(key);
  };
  DataMap.prototype.delete = function(key) {
    if (this.has(key)) {
      key = this.getFormattedKey(key);
      this.element.removeAttribute(key);
      return true;
    } else {
      return false;
    }
  };
  DataMap.prototype.getFormattedKey = function(key) {
    return "data-" + this.identifier + "-" + dasherize(key);
  };
  return DataMap;
}();

function dasherize(value) {
  return value.replace(/([A-Z])/g, function(_, char) {
    return "-" + char.toLowerCase();
  });
}

function attributeValueContainsToken(attributeName, token) {
  return "[" + attributeName + '~="' + token + '"]';
}

var TargetSet = function() {
  function TargetSet(scope) {
    this.scope = scope;
  }
  Object.defineProperty(TargetSet.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(TargetSet.prototype, "identifier", {
    get: function() {
      return this.scope.identifier;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(TargetSet.prototype, "schema", {
    get: function() {
      return this.scope.schema;
    },
    enumerable: true,
    configurable: true
  });
  TargetSet.prototype.has = function(targetName) {
    return this.find(targetName) != null;
  };
  TargetSet.prototype.find = function() {
    var targetNames = [];
    for (var _i = 0; _i < arguments.length; _i++) {
      targetNames[_i] = arguments[_i];
    }
    var selector = this.getSelectorForTargetNames(targetNames);
    return this.scope.findElement(selector);
  };
  TargetSet.prototype.findAll = function() {
    var targetNames = [];
    for (var _i = 0; _i < arguments.length; _i++) {
      targetNames[_i] = arguments[_i];
    }
    var selector = this.getSelectorForTargetNames(targetNames);
    return this.scope.findAllElements(selector);
  };
  TargetSet.prototype.getSelectorForTargetNames = function(targetNames) {
    var _this = this;
    return targetNames.map(function(targetName) {
      return _this.getSelectorForTargetName(targetName);
    }).join(", ");
  };
  TargetSet.prototype.getSelectorForTargetName = function(targetName) {
    var targetDescriptor = this.identifier + "." + targetName;
    return attributeValueContainsToken(this.schema.targetAttribute, targetDescriptor);
  };
  return TargetSet;
}();

var Scope = function() {
  function Scope(schema, identifier, element) {
    this.schema = schema;
    this.identifier = identifier;
    this.element = element;
    this.targets = new TargetSet(this);
    this.data = new DataMap(this);
  }
  Scope.prototype.findElement = function(selector) {
    return this.findAllElements(selector)[0];
  };
  Scope.prototype.findAllElements = function(selector) {
    var head = this.element.matches(selector) ? [ this.element ] : [];
    var tail = this.filterElements(Array.from(this.element.querySelectorAll(selector)));
    return head.concat(tail);
  };
  Scope.prototype.filterElements = function(elements) {
    var _this = this;
    return elements.filter(function(element) {
      return _this.containsElement(element);
    });
  };
  Scope.prototype.containsElement = function(element) {
    return element.closest(this.controllerSelector) === this.element;
  };
  Object.defineProperty(Scope.prototype, "controllerSelector", {
    get: function() {
      return attributeValueContainsToken(this.schema.controllerAttribute, this.identifier);
    },
    enumerable: true,
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
    enumerable: true,
    configurable: true
  });
  ScopeObserver.prototype.parseValueForToken = function(token) {
    var element = token.element, identifier = token.content;
    var scopesByIdentifier = this.fetchScopesByIdentifierForElement(element);
    var scope = scopesByIdentifier.get(identifier);
    if (!scope) {
      scope = new Scope(this.schema, identifier, element);
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
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "schema", {
    get: function() {
      return this.application.schema;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "controllerAttribute", {
    get: function() {
      return this.schema.controllerAttribute;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "modules", {
    get: function() {
      return Array.from(this.modulesByIdentifier.values());
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "contexts", {
    get: function() {
      return this.modules.reduce(function(contexts, module) {
        return contexts.concat(module.contexts);
      }, []);
    },
    enumerable: true,
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
      result.done ? resolve(result.value) : new P(function(resolve) {
        resolve(result.value);
      }).then(fulfilled, rejected);
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
      if (f = 1, y && (t = y[op[0] & 2 ? "return" : op[0] ? "throw" : "next"]) && !(t = t.call(y, op[1])).done) return t;
      if (y = 0, t) op = [ 0, t.value ];
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

var Application = function() {
  function Application(element, schema) {
    if (element === void 0) {
      element = document.documentElement;
    }
    if (schema === void 0) {
      schema = defaultSchema;
    }
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
          this.router.start();
          this.dispatcher.start();
          return [ 2 ];
        }
      });
    });
  };
  Application.prototype.stop = function() {
    this.router.stop();
    this.dispatcher.stop();
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
    var definitions = Array.isArray(head) ? head : [ head ].concat(rest);
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
    var identifiers = Array.isArray(head) ? head : [ head ].concat(rest);
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
    enumerable: true,
    configurable: true
  });
  Application.prototype.getControllerForElementAndIdentifier = function(element, identifier) {
    var context = this.router.getContextForElementAndIdentifier(element, identifier);
    return context ? context.controller : null;
  };
  Application.prototype.handleError = function(error, message, detail) {
    console.error("%s\n\n%o\n\n%o", message, error, detail);
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

function defineTargetProperties(constructor) {
  var prototype = constructor.prototype;
  var targetNames = getTargetNamesForConstructor(constructor);
  targetNames.forEach(function(name) {
    var _a;
    return defineLinkedProperties(prototype, (_a = {}, _a[name + "Target"] = {
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
    }, _a));
  });
}

function getTargetNamesForConstructor(constructor) {
  var ancestors = getAncestorsForConstructor(constructor);
  return Array.from(ancestors.reduce(function(targetNames, constructor) {
    getOwnTargetNamesForConstructor(constructor).forEach(function(name) {
      return targetNames.add(name);
    });
    return targetNames;
  }, new Set()));
}

function getAncestorsForConstructor(constructor) {
  var ancestors = [];
  while (constructor) {
    ancestors.push(constructor);
    constructor = Object.getPrototypeOf(constructor);
  }
  return ancestors;
}

function getOwnTargetNamesForConstructor(constructor) {
  var definition = constructor["targets"];
  return Array.isArray(definition) ? definition : [];
}

function defineLinkedProperties(object, properties) {
  Object.keys(properties).forEach(function(name) {
    if (!(name in object)) {
      var descriptor = properties[name];
      Object.defineProperty(object, name, descriptor);
    }
  });
}

function capitalize(name) {
  return name.charAt(0).toUpperCase() + name.slice(1);
}

var Controller = function() {
  function Controller(context) {
    this.context = context;
  }
  Controller.bless = function() {
    defineTargetProperties(this);
  };
  Object.defineProperty(Controller.prototype, "application", {
    get: function() {
      return this.context.application;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "scope", {
    get: function() {
      return this.context.scope;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "element", {
    get: function() {
      return this.scope.element;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "identifier", {
    get: function() {
      return this.scope.identifier;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "targets", {
    get: function() {
      return this.scope.targets;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "data", {
    get: function() {
      return this.scope.data;
    },
    enumerable: true,
    configurable: true
  });
  Controller.prototype.initialize = function() {};
  Controller.prototype.connect = function() {};
  Controller.prototype.disconnect = function() {};
  Controller.targets = [];
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
  var hasNativeReflectConstruct = _isNativeReflectConstruct();
  return function() {
    var Super = _getPrototypeOf(Derived), result;
    if (hasNativeReflectConstruct) {
      var NewTarget = _getPrototypeOf(this).constructor;
      result = Reflect.construct(Super, arguments, NewTarget);
    } else {
      result = Super.apply(this, arguments);
    }
    return _possibleConstructorReturn(this, result);
  };
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

var application = Application.start();

application.register("toggle", _default);

application.register("hd-prescription-administration", _default$1);

application.register("home-delivery-modal", _default$2);

application.register("snippets", _default$3);

application.register("letters-form", _default$4);

application.register("prescriptions", _default$5);

application.register("charts", _default$6);

application.register("session", _default$7);

window.Chartkick.use(window.Highcharts);
