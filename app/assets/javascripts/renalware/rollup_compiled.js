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
  return function _createSuperInternal() {
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
  if (n === "Map" || n === "Set") return Array.from(o);
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
    function C(f, a, b, e) {
      f.hasOwnProperty(a) || (f[a] = e.apply(null, b));
    }
    f = f ? f._modules : {};
    C(f, "parts-more/Pane.js", [ f["parts/Chart.js"], f["parts/Globals.js"], f["parts/Pointer.js"], f["parts/Utilities.js"] ], function(f, a, b, e) {
      function h(l, c, p) {
        return Math.sqrt(Math.pow(l - p[0], 2) + Math.pow(c - p[1], 2)) < p[2] / 2;
      }
      var q = e.addEvent, t = e.extend, x = e.merge, B = e.pick, z = e.splat, c = a.CenteredSeriesMixin;
      f.prototype.collectionsWithUpdate.push("pane");
      e = function() {
        function l(l, c) {
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
          this.init(l, c);
        }
        l.prototype.init = function(l, c) {
          this.chart = c;
          this.background = [];
          c.pane.push(this);
          this.setOptions(l);
        };
        l.prototype.setOptions = function(l) {
          this.options = x(this.defaultOptions, this.chart.angular ? {
            background: {}
          } : void 0, l);
        };
        l.prototype.render = function() {
          var l = this.options, c = this.options.background, a = this.chart.renderer;
          this.group || (this.group = a.g("pane-group").attr({
            zIndex: l.zIndex || 0
          }).add());
          this.updateCenter();
          if (c) for (c = z(c), l = Math.max(c.length, this.background.length || 0), a = 0; a < l; a++) c[a] && this.axis ? this.renderBackground(x(this.defaultBackgroundOptions, c[a]), a) : this.background[a] && (this.background[a] = this.background[a].destroy(), 
          this.background.splice(a, 1));
        };
        l.prototype.renderBackground = function(l, c) {
          var a = "animate", p = {
            class: "highcharts-pane " + (l.className || "")
          };
          this.chart.styledMode || t(p, {
            fill: l.backgroundColor,
            stroke: l.borderColor,
            "stroke-width": l.borderWidth
          });
          this.background[c] || (this.background[c] = this.chart.renderer.path().add(this.group), 
          a = "attr");
          this.background[c][a]({
            d: this.axis.getPlotBandPath(l.from, l.to, l)
          }).attr(p);
        };
        l.prototype.updateCenter = function(l) {
          this.center = (l || this.axis || {}).center = c.getCenter.call(this);
        };
        l.prototype.update = function(l, c) {
          x(!0, this.options, l);
          x(!0, this.chart.options.pane, l);
          this.setOptions(this.options);
          this.render();
          this.chart.axes.forEach(function(l) {
            l.pane === this && (l.pane = null, l.update({}, c));
          }, this);
        };
        return l;
      }();
      a.Chart.prototype.getHoverPane = function(l) {
        var c = this, a;
        l && c.pane.forEach(function(p) {
          var e = l.chartX - c.plotLeft, m = l.chartY - c.plotTop;
          h(c.inverted ? m : e, c.inverted ? e : m, p.center) && (a = p);
        });
        return a;
      };
      q(f, "afterIsInsidePlot", function(l) {
        this.polar && (l.isInsidePlot = this.pane.some(function(c) {
          return h(l.x, l.y, c.center);
        }));
      });
      q(b, "beforeGetHoverData", function(l) {
        var c = this.chart;
        c.polar && (c.hoverPane = c.getHoverPane(l), l.filter = function(a) {
          return a.visible && !(!l.shared && a.directTouch) && B(a.options.enableMouseTracking, !0) && (!c.hoverPane || a.xAxis.pane === c.hoverPane);
        });
      });
      q(b, "afterGetHoverData", function(c) {
        var l = this.chart;
        c.hoverPoint && c.hoverPoint.plotX && c.hoverPoint.plotY && l.hoverPane && !h(c.hoverPoint.plotX, c.hoverPoint.plotY, l.hoverPane.center) && (c.hoverPoint = void 0);
      });
      a.Pane = e;
      return a.Pane;
    });
    C(f, "parts-more/HiddenAxis.js", [], function() {
      return function() {
        function f() {}
        f.init = function(a) {
          a.getOffset = function() {};
          a.redraw = function() {
            this.isDirty = !1;
          };
          a.render = function() {
            this.isDirty = !1;
          };
          a.createLabelCollector = function() {
            return function() {};
          };
          a.setScale = function() {};
          a.setCategories = function() {};
          a.setTitle = function() {};
          a.isHidden = !0;
        };
        return f;
      }();
    });
    C(f, "parts-more/RadialAxis.js", [ f["parts/Axis.js"], f["parts/Tick.js"], f["parts-more/HiddenAxis.js"], f["parts/Utilities.js"] ], function(f, a, b, e) {
      var h = e.addEvent, q = e.correctFloat, t = e.defined, x = e.extend, B = e.fireEvent, z = e.merge, c = e.pick, l = e.relativeLength, w = e.wrap;
      e = function() {
        function a() {}
        a.init = function(a) {
          var h = f.prototype;
          a.setOptions = function(m) {
            m = this.options = z(a.constructor.defaultOptions, this.defaultPolarOptions, m);
            m.plotBands || (m.plotBands = []);
            B(this, "afterSetOptions");
          };
          a.getOffset = function() {
            h.getOffset.call(this);
            this.chart.axisOffset[this.side] = 0;
          };
          a.getLinePath = function(m, n, d) {
            m = this.pane.center;
            var g = this.chart, k = c(n, m[2] / 2 - this.offset);
            "undefined" === typeof d && (d = this.horiz ? 0 : this.center && -this.center[3] / 2);
            d && (k += d);
            this.isCircular || "undefined" !== typeof n ? (n = this.chart.renderer.symbols.arc(this.left + m[0], this.top + m[1], k, k, {
              start: this.startAngleRad,
              end: this.endAngleRad,
              open: !0,
              innerR: 0
            }), n.xBounds = [ this.left + m[0] ], n.yBounds = [ this.top + m[1] - k ]) : (n = this.postTranslate(this.angleRad, k), 
            n = [ [ "M", this.center[0] + g.plotLeft, this.center[1] + g.plotTop ], [ "L", n.x, n.y ] ]);
            return n;
          };
          a.setAxisTranslation = function() {
            h.setAxisTranslation.call(this);
            this.center && (this.transA = this.isCircular ? (this.endAngleRad - this.startAngleRad) / (this.max - this.min || 1) : (this.center[2] - this.center[3]) / 2 / (this.max - this.min || 1), 
            this.minPixelPadding = this.isXAxis ? this.transA * this.minPointOffset : 0);
          };
          a.beforeSetTickPositions = function() {
            this.autoConnect = this.isCircular && "undefined" === typeof c(this.userMax, this.options.max) && q(this.endAngleRad - this.startAngleRad) === q(2 * Math.PI);
            !this.isCircular && this.chart.inverted && this.max++;
            this.autoConnect && (this.max += this.categories && 1 || this.pointRange || this.closestPointRange || 0);
          };
          a.setAxisSize = function() {
            h.setAxisSize.call(this);
            if (this.isRadial) {
              this.pane.updateCenter(this);
              var m = this.center = x([], this.pane.center);
              if (this.isCircular) this.sector = this.endAngleRad - this.startAngleRad; else {
                var n = this.postTranslate(this.angleRad, m[3] / 2);
                m[0] = n.x - this.chart.plotLeft;
                m[1] = n.y - this.chart.plotTop;
              }
              this.len = this.width = this.height = (m[2] - m[3]) * c(this.sector, 1) / 2;
            }
          };
          a.getPosition = function(m, n) {
            m = this.translate(m);
            return this.postTranslate(this.isCircular ? m : this.angleRad, c(this.isCircular ? n : 0 > m ? 0 : m, this.center[2] / 2) - this.offset);
          };
          a.postTranslate = function(m, n) {
            var d = this.chart, g = this.center;
            m = this.startAngleRad + m;
            return {
              x: d.plotLeft + g[0] + Math.cos(m) * n,
              y: d.plotTop + g[1] + Math.sin(m) * n
            };
          };
          a.getPlotBandPath = function(m, n, d) {
            var g = function(d) {
              if ("string" === typeof d) {
                var g = parseInt(d, 10);
                D.test(d) && (g = g * A / 100);
                return g;
              }
              return d;
            }, k = this.center, u = this.startAngleRad, A = k[2] / 2, r = Math.min(this.offset, 0), D = /%$/;
            var l = this.isCircular;
            var a = c(g(d.outerRadius), A), h = g(d.innerRadius);
            g = c(g(d.thickness), 10);
            if ("polygon" === this.options.gridLineInterpolation) r = this.getPlotLinePath({
              value: m
            }).concat(this.getPlotLinePath({
              value: n,
              reverse: !0
            })); else {
              m = Math.max(m, this.min);
              n = Math.min(n, this.max);
              m = this.translate(m);
              n = this.translate(n);
              l || (a = m || 0, h = n || 0);
              if ("circle" !== d.shape && l) d = u + (m || 0), u += n || 0; else {
                d = -Math.PI / 2;
                u = 1.5 * Math.PI;
                var p = !0;
              }
              a -= r;
              r = this.chart.renderer.symbols.arc(this.left + k[0], this.top + k[1], a, a, {
                start: Math.min(d, u),
                end: Math.max(d, u),
                innerR: c(h, a - (g - r)),
                open: p
              });
              l && (l = (u + d) / 2, p = this.left + k[0] + k[2] / 2 * Math.cos(l), r.xBounds = l > -Math.PI / 2 && l < Math.PI / 2 ? [ p, this.chart.plotWidth ] : [ 0, p ], 
              r.yBounds = [ this.top + k[1] + k[2] / 2 * Math.sin(l) ], r.yBounds[0] += l > -Math.PI && 0 > l || l > Math.PI ? -10 : 10);
            }
            return r;
          };
          a.getCrosshairPosition = function(m, n, d) {
            var g = m.value, k = this.pane.center;
            if (this.isCircular) {
              if (t(g)) m.point && (u = m.point.shapeArgs || {}, u.start && (g = this.chart.inverted ? this.translate(m.point.rectPlotY, !0) : m.point.x)); else {
                var u = m.chartX || 0;
                var A = m.chartY || 0;
                g = this.translate(Math.atan2(A - d, u - n) - this.startAngleRad, !0);
              }
              m = this.getPosition(g);
              u = m.x;
              A = m.y;
            } else t(g) || (u = m.chartX, A = m.chartY), t(u) && t(A) && (d = k[1] + this.chart.plotTop, 
            g = this.translate(Math.min(Math.sqrt(Math.pow(u - n, 2) + Math.pow(A - d, 2)), k[2] / 2) - k[3] / 2, !0));
            return [ g, u || 0, A || 0 ];
          };
          a.getPlotLinePath = function(m) {
            var n = this, d = n.pane.center, g = n.chart, k = g.inverted, u = m.value, A = m.reverse, r = n.getPosition(u), c = n.pane.options.background ? n.pane.options.background[0] || n.pane.options.background : {}, a = c.innerRadius || "0%", h = c.outerRadius || "100%";
            c = d[0] + g.plotLeft;
            var p = d[1] + g.plotTop, e = r.x, b = r.y, w = n.height;
            r = d[3] / 2;
            var q;
            m.isCrosshair && (b = this.getCrosshairPosition(m, c, p), u = b[0], e = b[1], b = b[2]);
            if (n.isCircular) u = Math.sqrt(Math.pow(e - c, 2) + Math.pow(b - p, 2)), A = "string" === typeof a ? l(a, 1) : a / u, 
            g = "string" === typeof h ? l(h, 1) : h / u, d && r && (u = r / u, A < u && (A = u), 
            g < u && (g = u)), d = [ [ "M", c + A * (e - c), p - A * (p - b) ], [ "L", e - (1 - g) * (e - c), b + (1 - g) * (p - b) ] ]; else if ((u = n.translate(u)) && (0 > u || u > w) && (u = 0), 
            "circle" === n.options.gridLineInterpolation) d = n.getLinePath(0, u, r); else if (d = [], 
            g[k ? "yAxis" : "xAxis"].forEach(function(d) {
              d.pane === n.pane && (q = d);
            }), q) for (c = q.tickPositions, q.autoConnect && (c = c.concat([ c[0] ])), A && (c = c.slice().reverse()), 
            u && (u += r), e = 0; e < c.length; e++) p = q.getPosition(c[e], u), d.push(e ? [ "L", p.x, p.y ] : [ "M", p.x, p.y ]);
            return d;
          };
          a.getTitlePosition = function() {
            var c = this.center, n = this.chart, d = this.options.title;
            return {
              x: n.plotLeft + c[0] + (d.x || 0),
              y: n.plotTop + c[1] - {
                high: .5,
                middle: .25,
                low: 0
              }[d.align] * c[2] + (d.y || 0)
            };
          };
          a.createLabelCollector = function() {
            var c = this;
            return function() {
              if (c.isRadial && c.tickPositions && !0 !== c.options.labels.allowOverlap) return c.tickPositions.map(function(n) {
                return c.ticks[n] && c.ticks[n].label;
              }).filter(function(n) {
                return !!n;
              });
            };
          };
        };
        a.compose = function(p, e) {
          h(p, "init", function(c) {
            var n = this.chart, d = n.inverted, g = n.angular, k = n.polar, u = this.isXAxis, A = this.coll, r = g && u, l, m = n.options;
            c = c.userOptions.pane || 0;
            c = this.pane = n.pane && n.pane[c];
            if ("colorAxis" === A) this.isRadial = !1; else {
              if (g) {
                if (r ? b.init(this) : a.init(this), l = !u) this.defaultPolarOptions = a.defaultRadialGaugeOptions;
              } else k && (a.init(this), this.defaultPolarOptions = (l = this.horiz) ? a.defaultCircularOptions : z("xAxis" === A ? p.defaultOptions : p.defaultYAxisOptions, a.defaultRadialOptions), 
              d && "yAxis" === A && (this.defaultPolarOptions.stackLabels = p.defaultYAxisOptions.stackLabels));
              g || k ? (this.isRadial = !0, m.chart.zoomType = null, this.labelCollector || (this.labelCollector = this.createLabelCollector()), 
              this.labelCollector && n.labelCollectors.push(this.labelCollector)) : this.isRadial = !1;
              c && l && (c.axis = this);
              this.isCircular = l;
            }
          });
          h(p, "afterInit", function() {
            var l = this.chart, n = this.options, d = this.pane, g = d && d.options;
            l.angular && this.isXAxis || !d || !l.angular && !l.polar || (this.angleRad = (n.angle || 0) * Math.PI / 180, 
            this.startAngleRad = (g.startAngle - 90) * Math.PI / 180, this.endAngleRad = (c(g.endAngle, g.startAngle + 360) - 90) * Math.PI / 180, 
            this.offset = n.offset || 0);
          });
          h(p, "autoLabelAlign", function(c) {
            this.isRadial && (c.align = void 0, c.preventDefault());
          });
          h(p, "destroy", function() {
            if (this.chart && this.chart.labelCollectors) {
              var c = this.labelCollector ? this.chart.labelCollectors.indexOf(this.labelCollector) : -1;
              0 <= c && this.chart.labelCollectors.splice(c, 1);
            }
          });
          h(p, "initialAxisTranslation", function() {
            this.isRadial && this.beforeSetTickPositions();
          });
          h(e, "afterGetPosition", function(c) {
            this.axis.getPosition && x(c.pos, this.axis.getPosition(this.pos));
          });
          h(e, "afterGetLabelPosition", function(a) {
            var n = this.axis, d = this.label;
            if (d) {
              var g = d.getBBox(), k = n.options.labels, u = k.y, A = 20, r = k.align, m = (n.translate(this.pos) + n.startAngleRad + Math.PI / 2) / Math.PI * 180 % 360, p = Math.round(m), h = "end", e = 0 > p ? p + 360 : p, b = e, w = 0, q = 0, v = null === k.y ? .3 * -g.height : 0;
              if (n.isRadial) {
                var y = n.getPosition(this.pos, n.center[2] / 2 + l(c(k.distance, -25), n.center[2] / 2, -n.center[2] / 2));
                "auto" === k.rotation ? d.attr({
                  rotation: m
                }) : null === u && (u = n.chart.renderer.fontMetrics(d.styles && d.styles.fontSize).b - g.height / 2);
                null === r && (n.isCircular ? (g.width > n.len * n.tickInterval / (n.max - n.min) && (A = 0), 
                r = m > A && m < 180 - A ? "left" : m > 180 + A && m < 360 - A ? "right" : "center") : r = "center", 
                d.attr({
                  align: r
                }));
                if ("auto" === r && 2 === n.tickPositions.length && n.isCircular) {
                  90 < e && 180 > e ? e = 180 - e : 270 < e && 360 >= e && (e = 540 - e);
                  180 < b && 360 >= b && (b = 360 - b);
                  if (n.pane.options.startAngle === p || n.pane.options.startAngle === p + 360 || n.pane.options.startAngle === p - 360) h = "start";
                  r = -90 <= p && 90 >= p || -360 <= p && -270 >= p || 270 <= p && 360 >= p ? "start" === h ? "right" : "left" : "start" === h ? "left" : "right";
                  70 < b && 110 > b && (r = "center");
                  15 > e || 180 <= e && 195 > e ? w = .3 * g.height : 15 <= e && 35 >= e ? w = "start" === h ? 0 : .75 * g.height : 195 <= e && 215 >= e ? w = "start" === h ? .75 * g.height : 0 : 35 < e && 90 >= e ? w = "start" === h ? .25 * -g.height : g.height : 215 < e && 270 >= e && (w = "start" === h ? g.height : .25 * -g.height);
                  15 > b ? q = "start" === h ? .15 * -g.height : .15 * g.height : 165 < b && 180 >= b && (q = "start" === h ? .15 * g.height : .15 * -g.height);
                  d.attr({
                    align: r
                  });
                  d.translate(q, w + v);
                }
                a.pos.x = y.x + k.x;
                a.pos.y = y.y + u;
              }
            }
          });
          w(e.prototype, "getMarkPath", function(c, n, d, g, k, u, A) {
            var r = this.axis;
            r.isRadial ? (c = r.getPosition(this.pos, r.center[2] / 2 + g), n = [ "M", n, d, "L", c.x, c.y ]) : n = c.call(this, n, d, g, k, u, A);
            return n;
          });
        };
        a.defaultCircularOptions = {
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
        };
        a.defaultRadialGaugeOptions = {
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
        };
        a.defaultRadialOptions = {
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
        };
        return a;
      }();
      e.compose(f, a);
      return e;
    });
    C(f, "parts-more/AreaRangeSeries.js", [ f["parts/Globals.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(f, a, b) {
      var e = b.defined, h = b.extend, q = b.isArray, t = b.isNumber, x = b.pick;
      b = b.seriesType;
      var B = f.seriesTypes, z = f.Series.prototype, c = a.prototype;
      b("arearange", "area", {
        lineWidth: 1,
        threshold: null,
        tooltip: {
          pointFormat: '<span style="color:{series.color}">●</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'
        },
        trackByArea: !0,
        dataLabels: {
          align: void 0,
          verticalAlign: void 0,
          xLow: 0,
          xHigh: 0,
          yLow: 0,
          yHigh: 0
        }
      }, {
        pointArrayMap: [ "low", "high" ],
        pointValKey: "low",
        deferTranslatePolar: !0,
        toYData: function(c) {
          return [ c.low, c.high ];
        },
        highToXY: function(c) {
          var l = this.chart, a = this.xAxis.postTranslate(c.rectPlotX, this.yAxis.len - c.plotHigh);
          c.plotHighX = a.x - l.plotLeft;
          c.plotHigh = a.y - l.plotTop;
          c.plotLowX = c.plotX;
        },
        translate: function() {
          var c = this, a = c.yAxis, p = !!c.modifyValue;
          B.area.prototype.translate.apply(c);
          c.points.forEach(function(l) {
            var e = l.high, m = l.plotY;
            l.isNull ? l.plotY = null : (l.plotLow = m, l.plotHigh = a.translate(p ? c.modifyValue(e, l) : e, 0, 1, 0, 1), 
            p && (l.yBottom = l.plotHigh));
          });
          this.chart.polar && this.points.forEach(function(l) {
            c.highToXY(l);
            l.tooltipPos = [ (l.plotHighX + l.plotLowX) / 2, (l.plotHigh + l.plotLow) / 2 ];
          });
        },
        getGraphPath: function(c) {
          var a = [], l = [], e, h = B.area.prototype.getGraphPath;
          var m = this.options;
          var n = this.chart.polar && !1 !== m.connectEnds, d = m.connectNulls, g = m.step;
          c = c || this.points;
          for (e = c.length; e--; ) {
            var k = c[e];
            k.isNull || n || d || c[e + 1] && !c[e + 1].isNull || l.push({
              plotX: k.plotX,
              plotY: k.plotY,
              doCurve: !1
            });
            var u = {
              polarPlotY: k.polarPlotY,
              rectPlotX: k.rectPlotX,
              yBottom: k.yBottom,
              plotX: x(k.plotHighX, k.plotX),
              plotY: k.plotHigh,
              isNull: k.isNull
            };
            l.push(u);
            a.push(u);
            k.isNull || n || d || c[e - 1] && !c[e - 1].isNull || l.push({
              plotX: k.plotX,
              plotY: k.plotY,
              doCurve: !1
            });
          }
          c = h.call(this, c);
          g && (!0 === g && (g = "left"), m.step = {
            left: "right",
            center: "center",
            right: "left"
          }[g]);
          a = h.call(this, a);
          l = h.call(this, l);
          m.step = g;
          m = [].concat(c, a);
          !this.chart.polar && l[0] && "M" === l[0][0] && (l[0] = [ "L", l[0][1], l[0][2] ]);
          this.graphPath = m;
          this.areaPath = c.concat(l);
          m.isArea = !0;
          m.xMap = c.xMap;
          this.areaPath.xMap = c.xMap;
          return m;
        },
        drawDataLabels: function() {
          var c = this.points, a = c.length, e, b = [], f = this.options.dataLabels, m, n = this.chart.inverted;
          if (q(f)) {
            if (1 < f.length) {
              var d = f[0];
              var g = f[1];
            } else d = f[0], g = {
              enabled: !1
            };
          } else d = h({}, f), d.x = f.xHigh, d.y = f.yHigh, g = h({}, f), g.x = f.xLow, g.y = f.yLow;
          if (d.enabled || this._hasPointLabels) {
            for (e = a; e--; ) if (m = c[e]) {
              var k = d.inside ? m.plotHigh < m.plotLow : m.plotHigh > m.plotLow;
              m.y = m.high;
              m._plotY = m.plotY;
              m.plotY = m.plotHigh;
              b[e] = m.dataLabel;
              m.dataLabel = m.dataLabelUpper;
              m.below = k;
              n ? d.align || (d.align = k ? "right" : "left") : d.verticalAlign || (d.verticalAlign = k ? "top" : "bottom");
            }
            this.options.dataLabels = d;
            z.drawDataLabels && z.drawDataLabels.apply(this, arguments);
            for (e = a; e--; ) if (m = c[e]) m.dataLabelUpper = m.dataLabel, m.dataLabel = b[e], 
            delete m.dataLabels, m.y = m.low, m.plotY = m._plotY;
          }
          if (g.enabled || this._hasPointLabels) {
            for (e = a; e--; ) if (m = c[e]) k = g.inside ? m.plotHigh < m.plotLow : m.plotHigh > m.plotLow, 
            m.below = !k, n ? g.align || (g.align = k ? "left" : "right") : g.verticalAlign || (g.verticalAlign = k ? "bottom" : "top");
            this.options.dataLabels = g;
            z.drawDataLabels && z.drawDataLabels.apply(this, arguments);
          }
          if (d.enabled) for (e = a; e--; ) if (m = c[e]) m.dataLabels = [ m.dataLabelUpper, m.dataLabel ].filter(function(d) {
            return !!d;
          });
          this.options.dataLabels = f;
        },
        alignDataLabel: function() {
          B.column.prototype.alignDataLabel.apply(this, arguments);
        },
        drawPoints: function() {
          var c = this.points.length, a;
          z.drawPoints.apply(this, arguments);
          for (a = 0; a < c; ) {
            var b = this.points[a];
            b.origProps = {
              plotY: b.plotY,
              plotX: b.plotX,
              isInside: b.isInside,
              negative: b.negative,
              zone: b.zone,
              y: b.y
            };
            b.lowerGraphic = b.graphic;
            b.graphic = b.upperGraphic;
            b.plotY = b.plotHigh;
            e(b.plotHighX) && (b.plotX = b.plotHighX);
            b.y = b.high;
            b.negative = b.high < (this.options.threshold || 0);
            b.zone = this.zones.length && b.getZone();
            this.chart.polar || (b.isInside = b.isTopInside = "undefined" !== typeof b.plotY && 0 <= b.plotY && b.plotY <= this.yAxis.len && 0 <= b.plotX && b.plotX <= this.xAxis.len);
            a++;
          }
          z.drawPoints.apply(this, arguments);
          for (a = 0; a < c; ) b = this.points[a], b.upperGraphic = b.graphic, b.graphic = b.lowerGraphic, 
          h(b, b.origProps), delete b.origProps, a++;
        },
        setStackedPoints: f.noop
      }, {
        setState: function() {
          var a = this.state, b = this.series, h = b.chart.polar;
          e(this.plotHigh) || (this.plotHigh = b.yAxis.toPixels(this.high, !0));
          e(this.plotLow) || (this.plotLow = this.plotY = b.yAxis.toPixels(this.low, !0));
          b.stateMarkerGraphic && (b.lowerStateMarkerGraphic = b.stateMarkerGraphic, b.stateMarkerGraphic = b.upperStateMarkerGraphic);
          this.graphic = this.upperGraphic;
          this.plotY = this.plotHigh;
          h && (this.plotX = this.plotHighX);
          c.setState.apply(this, arguments);
          this.state = a;
          this.plotY = this.plotLow;
          this.graphic = this.lowerGraphic;
          h && (this.plotX = this.plotLowX);
          b.stateMarkerGraphic && (b.upperStateMarkerGraphic = b.stateMarkerGraphic, b.stateMarkerGraphic = b.lowerStateMarkerGraphic, 
          b.lowerStateMarkerGraphic = void 0);
          c.setState.apply(this, arguments);
        },
        haloPath: function() {
          var a = this.series.chart.polar, b = [];
          this.plotY = this.plotLow;
          a && (this.plotX = this.plotLowX);
          this.isInside && (b = c.haloPath.apply(this, arguments));
          this.plotY = this.plotHigh;
          a && (this.plotX = this.plotHighX);
          this.isTopInside && (b = b.concat(c.haloPath.apply(this, arguments)));
          return b;
        },
        destroyElements: function() {
          [ "lowerGraphic", "upperGraphic" ].forEach(function(c) {
            this[c] && (this[c] = this[c].destroy());
          }, this);
          this.graphic = null;
          return c.destroyElements.apply(this, arguments);
        },
        isValid: function() {
          return t(this.low) && t(this.high);
        }
      });
    });
    C(f, "parts-more/AreaSplineRangeSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      a = a.seriesType;
      a("areasplinerange", "arearange", null, {
        getPointSpline: f.seriesTypes.spline.prototype.getPointSpline
      });
    });
    C(f, "parts-more/ColumnRangeSeries.js", [ f["parts/Globals.js"], f["parts/Options.js"], f["parts/Utilities.js"] ], function(f, a, b) {
      a = a.defaultOptions;
      var e = b.clamp, h = b.merge, q = b.pick;
      b = b.seriesType;
      var t = f.noop, x = f.seriesTypes.column.prototype;
      b("columnrange", "arearange", h(a.plotOptions.column, a.plotOptions.arearange, {
        pointRange: null,
        marker: null,
        states: {
          hover: {
            halo: !1
          }
        }
      }), {
        translate: function() {
          var a = this, b = a.yAxis, c = a.xAxis, l = c.startAngleRad, h, p = a.chart, f = a.xAxis.isRadial, t = Math.max(p.chartWidth, p.chartHeight) + 999, m;
          x.translate.apply(a);
          a.points.forEach(function(n) {
            var d = n.shapeArgs, g = a.options.minPointLength;
            n.plotHigh = m = e(b.translate(n.high, 0, 1, 0, 1), -t, t);
            n.plotLow = e(n.plotY, -t, t);
            var k = m;
            var u = q(n.rectPlotY, n.plotY) - m;
            Math.abs(u) < g ? (g -= u, u += g, k -= g / 2) : 0 > u && (u *= -1, k -= u);
            f ? (h = n.barX + l, n.shapeType = "arc", n.shapeArgs = a.polarArc(k + u, k, h, h + n.pointWidth)) : (d.height = u, 
            d.y = k, n.tooltipPos = p.inverted ? [ b.len + b.pos - p.plotLeft - k - u / 2, c.len + c.pos - p.plotTop - d.x - d.width / 2, u ] : [ c.left - p.plotLeft + d.x + d.width / 2, b.pos - p.plotTop + k + u / 2, u ]);
          });
        },
        directTouch: !0,
        trackerGroups: [ "group", "dataLabelsGroup" ],
        drawGraph: t,
        getSymbol: t,
        crispCol: function() {
          return x.crispCol.apply(this, arguments);
        },
        drawPoints: function() {
          return x.drawPoints.apply(this, arguments);
        },
        drawTracker: function() {
          return x.drawTracker.apply(this, arguments);
        },
        getColumnMetrics: function() {
          return x.getColumnMetrics.apply(this, arguments);
        },
        pointAttribs: function() {
          return x.pointAttribs.apply(this, arguments);
        },
        animate: function() {
          return x.animate.apply(this, arguments);
        },
        polarArc: function() {
          return x.polarArc.apply(this, arguments);
        },
        translate3dPoints: function() {
          return x.translate3dPoints.apply(this, arguments);
        },
        translate3dShapes: function() {
          return x.translate3dShapes.apply(this, arguments);
        }
      }, {
        setState: x.pointClass.prototype.setState
      });
    });
    C(f, "parts-more/ColumnPyramidSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      var b = a.clamp, e = a.pick;
      a = a.seriesType;
      var h = f.seriesTypes.column.prototype;
      a("columnpyramid", "column", {}, {
        translate: function() {
          var a = this, f = a.chart, x = a.options, B = a.dense = 2 > a.closestPointRange * a.xAxis.transA;
          B = a.borderWidth = e(x.borderWidth, B ? 0 : 1);
          var z = a.yAxis, c = x.threshold, l = a.translatedThreshold = z.getThreshold(c), w = e(x.minPointLength, 5), p = a.getColumnMetrics(), y = p.width, v = a.barW = Math.max(y, 1 + 2 * B), m = a.pointXOffset = p.offset;
          f.inverted && (l -= .5);
          x.pointPadding && (v = Math.ceil(v));
          h.translate.apply(a);
          a.points.forEach(function(n) {
            var d = e(n.yBottom, l), g = 999 + Math.abs(d), k = b(n.plotY, -g, z.len + g);
            g = n.plotX + m;
            var u = v / 2, A = Math.min(k, d);
            d = Math.max(k, d) - A;
            var r;
            n.barX = g;
            n.pointWidth = y;
            n.tooltipPos = f.inverted ? [ z.len + z.pos - f.plotLeft - k, a.xAxis.len - g - u, d ] : [ g + u, k + z.pos - f.plotTop, d ];
            k = c + (n.total || n.y);
            "percent" === x.stacking && (k = c + (0 > n.y) ? -100 : 100);
            k = z.toPixels(k, !0);
            var D = (r = f.plotHeight - k - (f.plotHeight - l)) ? u * (A - k) / r : 0;
            var h = r ? u * (A + d - k) / r : 0;
            r = g - D + u;
            D = g + D + u;
            var p = g + h + u;
            h = g - h + u;
            var q = A - w;
            var E = A + d;
            0 > n.y && (q = A, E = A + d + w);
            f.inverted && (p = f.plotWidth - A, r = k - (f.plotWidth - l), D = u * (k - p) / r, 
            h = u * (k - (p - d)) / r, r = g + u + D, D = r - 2 * D, p = g - h + u, h = g + h + u, 
            q = A, E = A + d - w, 0 > n.y && (E = A + d + w));
            n.shapeType = "path";
            n.shapeArgs = {
              x: r,
              y: q,
              width: D - r,
              height: d,
              d: [ [ "M", r, q ], [ "L", D, q ], [ "L", p, E ], [ "L", h, E ], [ "Z" ] ]
            };
          });
        }
      });
    });
    C(f, "parts-more/GaugeSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      var b = a.clamp, e = a.isNumber, h = a.merge, q = a.pick, t = a.pInt;
      a = a.seriesType;
      var x = f.Series, B = f.TrackerMixin;
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
        drawGraph: f.noop,
        fixedBox: !0,
        forceDL: !0,
        noSharedTooltip: !0,
        trackerGroups: [ "group", "dataLabelsGroup" ],
        translate: function() {
          var a = this.yAxis, c = this.options, l = a.center;
          this.generatePoints();
          this.points.forEach(function(f) {
            var p = h(c.dial, f.dial), w = t(q(p.radius, "80%")) * l[2] / 200, v = t(q(p.baseLength, "70%")) * w / 100, m = t(q(p.rearLength, "10%")) * w / 100, n = p.baseWidth || 3, d = p.topWidth || 1, g = c.overshoot, k = a.startAngleRad + a.translate(f.y, null, null, null, !0);
            if (e(g) || !1 === c.wrap) g = e(g) ? g / 180 * Math.PI : 0, k = b(k, a.startAngleRad - g, a.endAngleRad + g);
            k = 180 * k / Math.PI;
            f.shapeType = "path";
            f.shapeArgs = {
              d: p.path || [ [ "M", -m, -n / 2 ], [ "L", v, -n / 2 ], [ "L", w, -d / 2 ], [ "L", w, d / 2 ], [ "L", v, n / 2 ], [ "L", -m, n / 2 ], [ "Z" ] ],
              translateX: l[0],
              translateY: l[1],
              rotation: k
            };
            f.plotX = l[0];
            f.plotY = l[1];
          });
        },
        drawPoints: function() {
          var a = this, c = a.chart, b = a.yAxis.center, e = a.pivot, f = a.options, t = f.pivot, v = c.renderer;
          a.points.forEach(function(b) {
            var n = b.graphic, d = b.shapeArgs, g = d.d, k = h(f.dial, b.dial);
            n ? (n.animate(d), d.d = g) : b.graphic = v[b.shapeType](d).attr({
              rotation: d.rotation,
              zIndex: 1
            }).addClass("highcharts-dial").add(a.group);
            if (!c.styledMode) b.graphic[n ? "animate" : "attr"]({
              stroke: k.borderColor || "none",
              "stroke-width": k.borderWidth || 0,
              fill: k.backgroundColor || "#000000"
            });
          });
          e ? e.animate({
            translateX: b[0],
            translateY: b[1]
          }) : (a.pivot = v.circle(0, 0, q(t.radius, 5)).attr({
            zIndex: 2
          }).addClass("highcharts-pivot").translate(b[0], b[1]).add(a.group), c.styledMode || a.pivot.attr({
            "stroke-width": t.borderWidth || 0,
            stroke: t.borderColor || "#cccccc",
            fill: t.backgroundColor || "#000000"
          }));
        },
        animate: function(a) {
          var c = this;
          a || c.points.forEach(function(a) {
            var b = a.graphic;
            b && (b.attr({
              rotation: 180 * c.yAxis.startAngleRad / Math.PI
            }), b.animate({
              rotation: a.shapeArgs.rotation
            }, c.options.animation));
          });
        },
        render: function() {
          this.group = this.plotGroup("group", "series", this.visible ? "visible" : "hidden", this.options.zIndex, this.chart.seriesGroup);
          x.prototype.render.call(this);
          this.group.clip(this.chart.clipRect);
        },
        setData: function(a, c) {
          x.prototype.setData.call(this, a, !1);
          this.processData();
          this.generatePoints();
          q(c, !0) && this.chart.redraw();
        },
        hasData: function() {
          return !!this.points.length;
        },
        drawTracker: B && B.drawTrackerPoint
      }, {
        setState: function(a) {
          this.state = a;
        }
      });
    });
    C(f, "parts-more/BoxPlotSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      var b = a.pick;
      a = a.seriesType;
      var e = f.noop, h = f.seriesTypes;
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
        drawDataLabels: e,
        translate: function() {
          var a = this.yAxis, b = this.pointArrayMap;
          h.column.prototype.translate.apply(this);
          this.points.forEach(function(e) {
            b.forEach(function(b) {
              null !== e[b] && (e[b + "Plot"] = a.translate(e[b], 0, 1, 0, 1));
            });
            e.plotHigh = e.highPlot;
          });
        },
        drawPoints: function() {
          var a = this, e = a.options, h = a.chart, f = h.renderer, z, c, l, w, p, y, v = 0, m, n, d, g, k = !1 !== a.doQuartiles, u, A = a.options.whiskerLength;
          a.points.forEach(function(r) {
            var D = r.graphic, I = D ? "animate" : "attr", q = r.shapeArgs, G = {}, E = {}, F = {}, H = {}, t = r.color || a.color;
            "undefined" !== typeof r.plotY && (m = Math.round(q.width), n = Math.floor(q.x), 
            d = n + m, g = Math.round(m / 2), z = Math.floor(k ? r.q1Plot : r.lowPlot), c = Math.floor(k ? r.q3Plot : r.lowPlot), 
            l = Math.floor(r.highPlot), w = Math.floor(r.lowPlot), D || (r.graphic = D = f.g("point").add(a.group), 
            r.stem = f.path().addClass("highcharts-boxplot-stem").add(D), A && (r.whiskers = f.path().addClass("highcharts-boxplot-whisker").add(D)), 
            k && (r.box = f.path(void 0).addClass("highcharts-boxplot-box").add(D)), r.medianShape = f.path(void 0).addClass("highcharts-boxplot-median").add(D)), 
            h.styledMode || (E.stroke = r.stemColor || e.stemColor || t, E["stroke-width"] = b(r.stemWidth, e.stemWidth, e.lineWidth), 
            E.dashstyle = r.stemDashStyle || e.stemDashStyle || e.dashStyle, r.stem.attr(E), 
            A && (F.stroke = r.whiskerColor || e.whiskerColor || t, F["stroke-width"] = b(r.whiskerWidth, e.whiskerWidth, e.lineWidth), 
            F.dashstyle = r.whiskerDashStyle || e.whiskerDashStyle || e.dashStyle, r.whiskers.attr(F)), 
            k && (G.fill = r.fillColor || e.fillColor || t, G.stroke = e.lineColor || t, G["stroke-width"] = e.lineWidth || 0, 
            G.dashstyle = r.boxDashStyle || e.boxDashStyle || e.dashStyle, r.box.attr(G)), H.stroke = r.medianColor || e.medianColor || t, 
            H["stroke-width"] = b(r.medianWidth, e.medianWidth, e.lineWidth), H.dashstyle = r.medianDashStyle || e.medianDashStyle || e.dashStyle, 
            r.medianShape.attr(H)), y = r.stem.strokeWidth() % 2 / 2, v = n + g + y, D = [ [ "M", v, c ], [ "L", v, l ], [ "M", v, z ], [ "L", v, w ] ], 
            r.stem[I]({
              d: D
            }), k && (y = r.box.strokeWidth() % 2 / 2, z = Math.floor(z) + y, c = Math.floor(c) + y, 
            n += y, d += y, D = [ [ "M", n, c ], [ "L", n, z ], [ "L", d, z ], [ "L", d, c ], [ "L", n, c ], [ "Z" ] ], 
            r.box[I]({
              d: D
            })), A && (y = r.whiskers.strokeWidth() % 2 / 2, l += y, w += y, u = /%$/.test(A) ? g * parseFloat(A) / 100 : A / 2, 
            D = [ [ "M", v - u, l ], [ "L", v + u, l ], [ "M", v - u, w ], [ "L", v + u, w ] ], 
            r.whiskers[I]({
              d: D
            })), p = Math.round(r.medianPlot), y = r.medianShape.strokeWidth() % 2 / 2, p += y, 
            D = [ [ "M", n, p ], [ "L", d, p ] ], r.medianShape[I]({
              d: D
            }));
          });
        },
        setStackedPoints: e
      });
    });
    C(f, "parts-more/ErrorBarSeries.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      a = a.seriesType;
      var b = f.noop, e = f.seriesTypes;
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
        drawDataLabels: e.arearange ? function() {
          var a = this.pointValKey;
          e.arearange.prototype.drawDataLabels.call(this);
          this.data.forEach(function(b) {
            b.y = b[a];
          });
        } : b,
        getColumnMetrics: function() {
          return this.linkedParent && this.linkedParent.columnMetrics || e.column.prototype.getColumnMetrics.call(this);
        }
      });
    });
    C(f, "parts-more/WaterfallSeries.js", [ f["parts/Axis.js"], f["parts/Chart.js"], f["parts/Globals.js"], f["parts/Point.js"], f["parts/Stacking.js"], f["parts/Utilities.js"] ], function(f, a, b, e, h, q) {
      var t = q.addEvent, x = q.arrayMax, B = q.arrayMin, z = q.correctFloat, c = q.isNumber, l = q.objectEach, w = q.pick;
      q = q.seriesType;
      var p = b.Series, y = b.seriesTypes, v;
      (function(a) {
        function c() {
          var d = this.waterfall.stacks;
          d && (d.changed = !1, delete d.alreadyChanged);
        }
        function d() {
          var d = this.options.stackLabels;
          d && d.enabled && this.waterfall.stacks && this.waterfall.renderStackTotals();
        }
        function g() {
          for (var d = this.axes, g = this.series, k = g.length; k--; ) g[k].options.stacking && (d.forEach(function(d) {
            d.isXAxis || (d.waterfall.stacks.changed = !0);
          }), k = 0);
        }
        function k() {
          this.waterfall || (this.waterfall = new u(this));
        }
        var u = function() {
          function d(d) {
            this.axis = d;
            this.stacks = {
              changed: !1
            };
          }
          d.prototype.renderStackTotals = function() {
            var d = this.axis, g = d.waterfall.stacks, k = d.stacking && d.stacking.stackTotalGroup, a = new h(d, d.options.stackLabels, !1, 0, void 0);
            this.dummyStackItem = a;
            l(g, function(d) {
              l(d, function(d) {
                a.total = d.stackTotal;
                d.label && (a.label = d.label);
                h.prototype.render.call(a, k);
                d.label = a.label;
                delete a.label;
              });
            });
            a.total = null;
          };
          return d;
        }();
        a.Composition = u;
        a.compose = function(a, r) {
          t(a, "init", k);
          t(a, "afterBuildStacks", c);
          t(a, "afterRender", d);
          t(r, "beforeRedraw", g);
        };
      })(v || (v = {}));
      q("waterfall", "column", {
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
          y.column.prototype.generatePoints.apply(this);
          var c = 0;
          for (a = this.points.length; c < a; c++) {
            var d = this.points[c];
            var g = this.processedYData[c];
            if (d.isIntermediateSum || d.isSum) d.y = z(g);
          }
        },
        translate: function() {
          var a = this.options, c = this.yAxis, d, g = w(a.minPointLength, 5), k = g / 2, u = a.threshold, A = a.stacking, r = c.waterfall.stacks[this.stackKey];
          y.column.prototype.translate.apply(this);
          var b = d = u;
          var e = this.points;
          var l = 0;
          for (a = e.length; l < a; l++) {
            var h = e[l];
            var f = this.processedYData[l];
            var p = h.shapeArgs;
            var q = [ 0, f ];
            var v = h.y;
            if (A) {
              if (r) {
                q = r[l];
                if ("overlap" === A) {
                  var t = q.stackState[q.stateIndex--];
                  t = 0 <= v ? t : t - v;
                  Object.hasOwnProperty.call(q, "absolutePos") && delete q.absolutePos;
                  Object.hasOwnProperty.call(q, "absoluteNeg") && delete q.absoluteNeg;
                } else 0 <= v ? (t = q.threshold + q.posTotal, q.posTotal -= v) : (t = q.threshold + q.negTotal, 
                q.negTotal -= v, t -= v), !q.posTotal && Object.hasOwnProperty.call(q, "absolutePos") && (q.posTotal = q.absolutePos, 
                delete q.absolutePos), !q.negTotal && Object.hasOwnProperty.call(q, "absoluteNeg") && (q.negTotal = q.absoluteNeg, 
                delete q.absoluteNeg);
                h.isSum || (q.connectorThreshold = q.threshold + q.stackTotal);
                c.reversed ? (f = 0 <= v ? t - v : t + v, v = t) : (f = t, v = t - v);
                h.below = f <= w(u, 0);
                p.y = c.translate(f, 0, 1, 0, 1);
                p.height = Math.abs(p.y - c.translate(v, 0, 1, 0, 1));
              }
              if (v = c.waterfall.dummyStackItem) v.x = l, v.label = r[l].label, v.setOffset(this.pointXOffset || 0, this.barW || 0, this.stackedYNeg[l], this.stackedYPos[l]);
            } else t = Math.max(b, b + v) + q[0], p.y = c.translate(t, 0, 1, 0, 1), h.isSum ? (p.y = c.translate(q[1], 0, 1, 0, 1), 
            p.height = Math.min(c.translate(q[0], 0, 1, 0, 1), c.len) - p.y) : h.isIntermediateSum ? (0 <= v ? (f = q[1] + d, 
            v = d) : (f = d, v = q[1] + d), c.reversed && (f ^= v, v ^= f, f ^= v), p.y = c.translate(f, 0, 1, 0, 1), 
            p.height = Math.abs(p.y - Math.min(c.translate(v, 0, 1, 0, 1), c.len)), d += q[1]) : (p.height = 0 < f ? c.translate(b, 0, 1, 0, 1) - p.y : c.translate(b, 0, 1, 0, 1) - c.translate(b - f, 0, 1, 0, 1), 
            b += f, h.below = b < w(u, 0)), 0 > p.height && (p.y += p.height, p.height *= -1);
            h.plotY = p.y = Math.round(p.y) - this.borderWidth % 2 / 2;
            p.height = Math.max(Math.round(p.height), .001);
            h.yBottom = p.y + p.height;
            p.height <= g && !h.isNull ? (p.height = g, p.y -= k, h.plotY = p.y, h.minPointLengthOffset = 0 > h.y ? -k : k) : (h.isNull && (p.width = 0), 
            h.minPointLengthOffset = 0);
            p = h.plotY + (h.negative ? p.height : 0);
            this.chart.inverted ? h.tooltipPos[0] = c.len - p : h.tooltipPos[1] = p;
          }
        },
        processData: function(a) {
          var c = this.options, d = this.yData, g = c.data, k = d.length, u = c.threshold || 0, b, r, e, l, h;
          for (h = r = b = e = l = 0; h < k; h++) {
            var m = d[h];
            var f = g && g[h] ? g[h] : {};
            "sum" === m || f.isSum ? d[h] = z(r) : "intermediateSum" === m || f.isIntermediateSum ? (d[h] = z(b), 
            b = 0) : (r += m, b += m);
            e = Math.min(r, e);
            l = Math.max(r, l);
          }
          p.prototype.processData.call(this, a);
          c.stacking || (this.dataMin = e + u, this.dataMax = l);
        },
        toYData: function(c) {
          return c.isSum ? "sum" : c.isIntermediateSum ? "intermediateSum" : c.y;
        },
        updateParallelArrays: function(c, a) {
          p.prototype.updateParallelArrays.call(this, c, a);
          if ("sum" === this.yData[0] || "intermediateSum" === this.yData[0]) this.yData[0] = null;
        },
        pointAttribs: function(c, a) {
          var d = this.options.upColor;
          d && !c.options.color && (c.color = 0 < c.y ? d : null);
          c = y.column.prototype.pointAttribs.call(this, c, a);
          delete c.dashstyle;
          return c;
        },
        getGraphPath: function() {
          return [ [ "M", 0, 0 ] ];
        },
        getCrispPath: function() {
          var c = this.data, a = this.yAxis, d = c.length, g = Math.round(this.graph.strokeWidth()) % 2 / 2, k = Math.round(this.borderWidth) % 2 / 2, u = this.xAxis.reversed, b = this.yAxis.reversed, r = this.options.stacking, e = [], h;
          for (h = 1; h < d; h++) {
            var l = c[h].shapeArgs;
            var f = c[h - 1];
            var p = c[h - 1].shapeArgs;
            var q = a.waterfall.stacks[this.stackKey];
            var v = 0 < f.y ? -p.height : 0;
            q && p && l && (q = q[h - 1], r ? (q = q.connectorThreshold, v = Math.round(a.translate(q, 0, 1, 0, 1) + (b ? v : 0)) - g) : v = p.y + f.minPointLengthOffset + k - g, 
            e.push([ "M", (p.x || 0) + (u ? 0 : p.width || 0), v ], [ "L", (l.x || 0) + (u ? l.width || 0 : 0), v ]));
            !r && e.length && p && (0 > f.y && !b || 0 < f.y && b) && (e[e.length - 2][2] += p.height, 
            e[e.length - 1][2] += p.height);
          }
          return e;
        },
        drawGraph: function() {
          p.prototype.drawGraph.call(this);
          this.graph.attr({
            d: this.getCrispPath()
          });
        },
        setStackedPoints: function() {
          function c(d, g, k, c) {
            if (B) for (k; k < B; k++) w.stackState[k] += c; else w.stackState[0] = d, B = w.stackState.length;
            w.stackState.push(w.stackState[B - 1] + g);
          }
          var a = this.options, d = this.yAxis.waterfall.stacks, g = a.threshold, k = g || 0, u = k, b = this.stackKey, r = this.xData, e = r.length, h, l, f;
          this.yAxis.stacking.usePercentage = !1;
          var p = l = f = k;
          if (this.visible || !this.chart.options.chart.ignoreHiddenSeries) {
            var q = d.changed;
            (h = d.alreadyChanged) && 0 > h.indexOf(b) && (q = !0);
            d[b] || (d[b] = {});
            h = d[b];
            for (var v = 0; v < e; v++) {
              var t = r[v];
              if (!h[t] || q) h[t] = {
                negTotal: 0,
                posTotal: 0,
                stackTotal: 0,
                threshold: 0,
                stateIndex: 0,
                stackState: [],
                label: q && h[t] ? h[t].label : void 0
              };
              var w = h[t];
              var y = this.yData[v];
              0 <= y ? w.posTotal += y : w.negTotal += y;
              var z = a.data[v];
              t = w.absolutePos = w.posTotal;
              var x = w.absoluteNeg = w.negTotal;
              w.stackTotal = t + x;
              var B = w.stackState.length;
              z && z.isIntermediateSum ? (c(f, l, 0, f), f = l, l = g, k ^= u, u ^= k, k ^= u) : z && z.isSum ? (c(g, p, B), 
              k = g) : (c(k, y, 0, p), z && (p += y, l += y));
              w.stateIndex++;
              w.threshold = k;
              k += w.stackTotal;
            }
            d.changed = !1;
            d.alreadyChanged || (d.alreadyChanged = []);
            d.alreadyChanged.push(b);
          }
        },
        getExtremes: function() {
          var c = this.options.stacking;
          if (c) {
            var a = this.yAxis;
            a = a.waterfall.stacks;
            var d = this.stackedYNeg = [];
            var g = this.stackedYPos = [];
            "overlap" === c ? l(a[this.stackKey], function(k) {
              d.push(B(k.stackState));
              g.push(x(k.stackState));
            }) : l(a[this.stackKey], function(k) {
              d.push(k.negTotal + k.threshold);
              g.push(k.posTotal + k.threshold);
            });
            return {
              dataMin: B(d),
              dataMax: x(g)
            };
          }
          return {
            dataMin: this.dataMin,
            dataMax: this.dataMax
          };
        }
      }, {
        getClassName: function() {
          var c = e.prototype.getClassName.call(this);
          this.isSum ? c += " highcharts-sum" : this.isIntermediateSum && (c += " highcharts-intermediate-sum");
          return c;
        },
        isValid: function() {
          return c(this.y) || this.isSum || !!this.isIntermediateSum;
        }
      });
      v.compose(f, a);
      return v;
    });
    C(f, "parts-more/PolygonSeries.js", [ f["parts/Globals.js"], f["mixins/legend-symbol.js"], f["parts/Utilities.js"] ], function(f, a, b) {
      b = b.seriesType;
      var e = f.Series, h = f.seriesTypes;
      b("polygon", "scatter", {
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
          for (var a = e.prototype.getGraphPath.call(this), b = a.length + 1; b--; ) (b === a.length || "M" === a[b][0]) && 0 < b && a.splice(b, 0, [ "Z" ]);
          return this.areaPath = a;
        },
        drawGraph: function() {
          this.options.fillColor = this.color;
          h.area.prototype.drawGraph.call(this);
        },
        drawLegendSymbol: a.drawRectangle,
        drawTracker: e.prototype.drawTracker,
        setStackedPoints: f.noop
      });
    });
    C(f, "parts-more/BubbleLegend.js", [ f["parts/Chart.js"], f["parts/Color.js"], f["parts/Globals.js"], f["parts/Legend.js"], f["parts/Utilities.js"] ], function(f, a, b, e, h) {
      var q = a.parse;
      a = h.addEvent;
      var t = h.arrayMax, x = h.arrayMin, B = h.isNumber, z = h.merge, c = h.objectEach, l = h.pick, w = h.setOptions, p = h.stableSort, y = h.wrap;
      var v = b.Series, m = b.noop;
      w({
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
      w = function() {
        function a(d, g) {
          this.options = this.symbols = this.visible = this.ranges = this.movementX = this.maxLabel = this.legendSymbol = this.legendItemWidth = this.legendItemHeight = this.legendItem = this.legendGroup = this.legend = this.fontMetrics = this.chart = void 0;
          this.setState = m;
          this.init(d, g);
        }
        a.prototype.init = function(d, g) {
          this.options = d;
          this.visible = !0;
          this.chart = g.chart;
          this.legend = g;
        };
        a.prototype.addToLegend = function(d) {
          d.splice(this.options.legendIndex, 0, this);
        };
        a.prototype.drawLegendSymbol = function(d) {
          var g = this.chart, k = this.options, a = l(d.options.itemDistance, 20), c = k.ranges;
          var r = k.connectorDistance;
          this.fontMetrics = g.renderer.fontMetrics(k.labels.style.fontSize.toString() + "px");
          c && c.length && B(c[0].value) ? (p(c, function(d, g) {
            return g.value - d.value;
          }), this.ranges = c, this.setOptions(), this.render(), g = this.getMaxLabelSize(), 
          c = this.ranges[0].radius, d = 2 * c, r = r - c + g.width, r = 0 < r ? r : 0, this.maxLabel = g, 
          this.movementX = "left" === k.labels.align ? r : 0, this.legendItemWidth = d + r + a, 
          this.legendItemHeight = d + this.fontMetrics.h / 2) : d.options.bubbleLegend.autoRanges = !0;
        };
        a.prototype.setOptions = function() {
          var d = this.ranges, g = this.options, k = this.chart.series[g.seriesIndex], c = this.legend.baseline, a = {
            "z-index": g.zIndex,
            "stroke-width": g.borderWidth
          }, r = {
            "z-index": g.zIndex,
            "stroke-width": g.connectorWidth
          }, b = this.getLabelStyles(), e = k.options.marker.fillOpacity, h = this.chart.styledMode;
          d.forEach(function(u, A) {
            h || (a.stroke = l(u.borderColor, g.borderColor, k.color), a.fill = l(u.color, g.color, 1 !== e ? q(k.color).setOpacity(e).get("rgba") : k.color), 
            r.stroke = l(u.connectorColor, g.connectorColor, k.color));
            d[A].radius = this.getRangeRadius(u.value);
            d[A] = z(d[A], {
              center: d[0].radius - d[A].radius + c
            });
            h || z(!0, d[A], {
              bubbleStyle: z(!1, a),
              connectorStyle: z(!1, r),
              labelStyle: b
            });
          }, this);
        };
        a.prototype.getLabelStyles = function() {
          var d = this.options, g = {}, k = "left" === d.labels.align, a = this.legend.options.rtl;
          c(d.labels.style, function(d, k) {
            "color" !== k && "fontSize" !== k && "z-index" !== k && (g[k] = d);
          });
          return z(!1, g, {
            "font-size": d.labels.style.fontSize,
            fill: l(d.labels.style.color, "#000000"),
            "z-index": d.zIndex,
            align: a || k ? "right" : "left"
          });
        };
        a.prototype.getRangeRadius = function(d) {
          var g = this.options;
          return this.chart.series[this.options.seriesIndex].getRadius.call(this, g.ranges[g.ranges.length - 1].value, g.ranges[0].value, g.minSize, g.maxSize, d);
        };
        a.prototype.render = function() {
          var d = this.chart.renderer, g = this.options.zThreshold;
          this.symbols || (this.symbols = {
            connectors: [],
            bubbleItems: [],
            labels: []
          });
          this.legendSymbol = d.g("bubble-legend");
          this.legendItem = d.g("bubble-legend-item");
          this.legendSymbol.translateX = 0;
          this.legendSymbol.translateY = 0;
          this.ranges.forEach(function(d) {
            d.value >= g && this.renderRange(d);
          }, this);
          this.legendSymbol.add(this.legendItem);
          this.legendItem.add(this.legendGroup);
          this.hideOverlappingLabels();
        };
        a.prototype.renderRange = function(d) {
          var g = this.options, k = g.labels, a = this.chart.renderer, c = this.symbols, r = c.labels, b = d.center, e = Math.abs(d.radius), h = g.connectorDistance || 0, l = k.align, n = k.style.fontSize;
          h = this.legend.options.rtl || "left" === l ? -h : h;
          k = g.connectorWidth;
          var f = this.ranges[0].radius || 0, p = b - e - g.borderWidth / 2 + k / 2;
          n = n / 2 - (this.fontMetrics.h - n) / 2;
          var m = a.styledMode;
          "center" === l && (h = 0, g.connectorDistance = 0, d.labelStyle.align = "center");
          l = p + g.labels.y;
          var q = f + h + g.labels.x;
          c.bubbleItems.push(a.circle(f, b + ((p % 1 ? 1 : .5) - (k % 2 ? 0 : .5)), e).attr(m ? {} : d.bubbleStyle).addClass((m ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-symbol " + (g.className || "")).add(this.legendSymbol));
          c.connectors.push(a.path(a.crispLine([ [ "M", f, p ], [ "L", f + h, p ] ], g.connectorWidth)).attr(m ? {} : d.connectorStyle).addClass((m ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-connectors " + (g.connectorClassName || "")).add(this.legendSymbol));
          d = a.text(this.formatLabel(d), q, l + n).attr(m ? {} : d.labelStyle).addClass("highcharts-bubble-legend-labels " + (g.labels.className || "")).add(this.legendSymbol);
          r.push(d);
          d.placed = !0;
          d.alignAttr = {
            x: q,
            y: l + n
          };
        };
        a.prototype.getMaxLabelSize = function() {
          var d, g;
          this.symbols.labels.forEach(function(k) {
            g = k.getBBox(!0);
            d = d ? g.width > d.width ? g : d : g;
          });
          return d || {};
        };
        a.prototype.formatLabel = function(d) {
          var g = this.options, k = g.labels.formatter;
          g = g.labels.format;
          var a = this.chart.numberFormatter;
          return g ? h.format(g, d) : k ? k.call(d) : a(d.value, 1);
        };
        a.prototype.hideOverlappingLabels = function() {
          var d = this.chart, g = this.symbols;
          !this.options.labels.allowOverlap && g && (d.hideOverlappingLabels(g.labels), g.labels.forEach(function(d, a) {
            d.newOpacity ? d.newOpacity !== d.oldOpacity && g.connectors[a].show() : g.connectors[a].hide();
          }));
        };
        a.prototype.getRanges = function() {
          var d = this.legend.bubbleLegend, g = d.options.ranges, k, a = Number.MAX_VALUE, c = -Number.MAX_VALUE;
          d.chart.series.forEach(function(d) {
            d.isBubble && !d.ignoreSeries && (k = d.zData.filter(B), k.length && (a = l(d.options.zMin, Math.min(a, Math.max(x(k), !1 === d.options.displayNegative ? d.options.zThreshold : -Number.MAX_VALUE))), 
            c = l(d.options.zMax, Math.max(c, t(k)))));
          });
          var b = a === c ? [ {
            value: c
          } ] : [ {
            value: a
          }, {
            value: (a + c) / 2
          }, {
            value: c,
            autoRanges: !0
          } ];
          g.length && g[0].radius && b.reverse();
          b.forEach(function(d, k) {
            g && g[k] && (b[k] = z(!1, g[k], d));
          });
          return b;
        };
        a.prototype.predictBubbleSizes = function() {
          var d = this.chart, g = this.fontMetrics, k = d.legend.options, a = "horizontal" === k.layout, c = a ? d.legend.lastLineHeight : 0, b = d.plotSizeX, e = d.plotSizeY, h = d.series[this.options.seriesIndex];
          d = Math.ceil(h.minPxSize);
          var l = Math.ceil(h.maxPxSize);
          h = h.options.maxSize;
          var n = Math.min(e, b);
          if (k.floating || !/%$/.test(h)) g = l; else if (h = parseFloat(h), g = (n + c - g.h / 2) * h / 100 / (h / 100 + 1), 
          a && e - g >= b || !a && b - g >= e) g = l;
          return [ d, Math.ceil(g) ];
        };
        a.prototype.updateRanges = function(d, g) {
          var k = this.legend.options.bubbleLegend;
          k.minSize = d;
          k.maxSize = g;
          k.ranges = this.getRanges();
        };
        a.prototype.correctSizes = function() {
          var d = this.legend, g = this.chart.series[this.options.seriesIndex];
          1 < Math.abs(Math.ceil(g.maxPxSize) - this.options.maxSize) && (this.updateRanges(this.options.minSize, g.maxPxSize), 
          d.render());
        };
        return a;
      }();
      a(e, "afterGetAllItems", function(a) {
        var d = this.bubbleLegend, g = this.options, k = g.bubbleLegend, c = this.chart.getVisibleBubbleSeriesIndex();
        d && d.ranges && d.ranges.length && (k.ranges.length && (k.autoRanges = !!k.ranges[0].autoRanges), 
        this.destroyItem(d));
        0 <= c && g.enabled && k.enabled && (k.seriesIndex = c, this.bubbleLegend = new b.BubbleLegend(k, this), 
        this.bubbleLegend.addToLegend(a.allItems));
      });
      f.prototype.getVisibleBubbleSeriesIndex = function() {
        for (var a = this.series, d = 0; d < a.length; ) {
          if (a[d] && a[d].isBubble && a[d].visible && a[d].zData.length) return d;
          d++;
        }
        return -1;
      };
      e.prototype.getLinesHeights = function() {
        var a = this.allItems, d = [], g = a.length, k, c = 0;
        for (k = 0; k < g; k++) if (a[k].legendItemHeight && (a[k].itemHeight = a[k].legendItemHeight), 
        a[k] === a[g - 1] || a[k + 1] && a[k]._legendItemPos[1] !== a[k + 1]._legendItemPos[1]) {
          d.push({
            height: 0
          });
          var b = d[d.length - 1];
          for (c; c <= k; c++) a[c].itemHeight > b.height && (b.height = a[c].itemHeight);
          b.step = k;
        }
        return d;
      };
      e.prototype.retranslateItems = function(a) {
        var d, g, k, c = this.options.rtl, b = 0;
        this.allItems.forEach(function(r, e) {
          d = r.legendGroup.translateX;
          g = r._legendItemPos[1];
          if ((k = r.movementX) || c && r.ranges) k = c ? d - r.options.maxSize / 2 : d + k, 
          r.legendGroup.attr({
            translateX: k
          });
          e > a[b].step && b++;
          r.legendGroup.attr({
            translateY: Math.round(g + a[b].height / 2)
          });
          r._legendItemPos[1] = g + a[b].height / 2;
        });
      };
      a(v, "legendItemClick", function() {
        var a = this.chart, d = this.visible, g = this.chart.legend;
        g && g.bubbleLegend && (this.visible = !d, this.ignoreSeries = d, a = 0 <= a.getVisibleBubbleSeriesIndex(), 
        g.bubbleLegend.visible !== a && (g.update({
          bubbleLegend: {
            enabled: a
          }
        }), g.bubbleLegend.visible = a), this.visible = d);
      });
      y(f.prototype, "drawChartBox", function(a, d, g) {
        var k = this.legend, b = 0 <= this.getVisibleBubbleSeriesIndex();
        if (k && k.options.enabled && k.bubbleLegend && k.options.bubbleLegend.autoRanges && b) {
          var e = k.bubbleLegend.options;
          b = k.bubbleLegend.predictBubbleSizes();
          k.bubbleLegend.updateRanges(b[0], b[1]);
          e.placed || (k.group.placed = !1, k.allItems.forEach(function(d) {
            d.legendGroup.translateY = null;
          }));
          k.render();
          this.getMargins();
          this.axes.forEach(function(d) {
            d.visible && d.render();
            e.placed || (d.setScale(), d.updateNames(), c(d.ticks, function(d) {
              d.isNew = !0;
              d.isNewLabel = !0;
            }));
          });
          e.placed = !0;
          this.getMargins();
          a.call(this, d, g);
          k.bubbleLegend.correctSizes();
          k.retranslateItems(k.getLinesHeights());
        } else a.call(this, d, g), k && k.options.enabled && k.bubbleLegend && (k.render(), 
        k.retranslateItems(k.getLinesHeights()));
      });
      b.BubbleLegend = w;
      return b.BubbleLegend;
    });
    C(f, "parts-more/BubbleSeries.js", [ f["parts/Globals.js"], f["parts/Color.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(f, a, b, e) {
      var h = a.parse, q = e.arrayMax, t = e.arrayMin, x = e.clamp, B = e.extend, z = e.isNumber, c = e.pick, l = e.pInt;
      a = e.seriesType;
      e = f.Axis;
      var w = f.noop, p = f.Series, y = f.seriesTypes;
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
        pointAttribs: function(a, c) {
          var b = this.options.marker.fillOpacity;
          a = p.prototype.pointAttribs.call(this, a, c);
          1 !== b && (a.fill = h(a.fill).setOpacity(b).get("rgba"));
          return a;
        },
        getRadii: function(a, c, b) {
          var d = this.zData, g = this.yData, k = b.minPxSize, e = b.maxPxSize, h = [];
          var r = 0;
          for (b = d.length; r < b; r++) {
            var l = d[r];
            h.push(this.getRadius(a, c, k, e, l, g[r]));
          }
          this.radii = h;
        },
        getRadius: function(a, c, b, d, g, k) {
          var e = this.options, h = "width" !== e.sizeBy, r = e.zThreshold, l = c - a, f = .5;
          if (null === k || null === g) return null;
          if (z(g)) {
            e.sizeByAbsoluteValue && (g = Math.abs(g - r), l = Math.max(c - r, Math.abs(a - r)), 
            a = 0);
            if (g < a) return b / 2 - 1;
            0 < l && (f = (g - a) / l);
          }
          h && 0 <= f && (f = Math.sqrt(f));
          return Math.ceil(b + f * (d - b)) / 2;
        },
        animate: function(a) {
          !a && this.points.length < this.options.animationLimit && this.points.forEach(function(a) {
            var c = a.graphic;
            c && c.width && (this.hasRendered || c.attr({
              x: a.plotX,
              y: a.plotY,
              width: 1,
              height: 1
            }), c.animate(this.markerAttribs(a), this.options.animation));
          }, this);
        },
        hasData: function() {
          return !!this.processedXData.length;
        },
        translate: function() {
          var a, c = this.data, b = this.radii;
          y.scatter.prototype.translate.call(this);
          for (a = c.length; a--; ) {
            var d = c[a];
            var g = b ? b[a] : 0;
            z(g) && g >= this.minPxSize / 2 ? (d.marker = B(d.marker, {
              radius: g,
              width: 2 * g,
              height: 2 * g
            }), d.dlBox = {
              x: d.plotX - g,
              y: d.plotY - g,
              width: 2 * g,
              height: 2 * g
            }) : d.shapeArgs = d.plotY = d.dlBox = void 0;
          }
        },
        alignDataLabel: y.column.prototype.alignDataLabel,
        buildKDTree: w,
        applyZones: w
      }, {
        haloPath: function(a) {
          return b.prototype.haloPath.call(this, 0 === a ? 0 : (this.marker ? this.marker.radius || 0 : 0) + a);
        },
        ttBelow: !1
      });
      e.prototype.beforePadding = function() {
        var a = this, b = this.len, e = this.chart, d = 0, g = b, k = this.isXAxis, h = k ? "xData" : "yData", f = this.min, r = {}, p = Math.min(e.plotWidth, e.plotHeight), w = Number.MAX_VALUE, y = -Number.MAX_VALUE, B = this.max - f, E = b / B, F = [];
        this.series.forEach(function(d) {
          var g = d.options;
          !d.bubblePadding || !d.visible && e.options.chart.ignoreHiddenSeries || (a.allowZoomOutside = !0, 
          F.push(d), k && ([ "minSize", "maxSize" ].forEach(function(d) {
            var a = g[d], c = /%$/.test(a);
            a = l(a);
            r[d] = c ? p * a / 100 : a;
          }), d.minPxSize = r.minSize, d.maxPxSize = Math.max(r.maxSize, r.minSize), d = d.zData.filter(z), 
          d.length && (w = c(g.zMin, x(t(d), !1 === g.displayNegative ? g.zThreshold : -Number.MAX_VALUE, w)), 
          y = c(g.zMax, Math.max(y, q(d))))));
        });
        F.forEach(function(c) {
          var b = c[h], e = b.length;
          k && c.getRadii(w, y, c);
          if (0 < B) for (;e--; ) if (z(b[e]) && a.dataMin <= b[e] && b[e] <= a.max) {
            var r = c.radii ? c.radii[e] : 0;
            d = Math.min((b[e] - f) * E - r, d);
            g = Math.max((b[e] - f) * E + r, g);
          }
        });
        F.length && 0 < B && !this.logarithmic && (g -= b, E *= (b + Math.max(0, d) - Math.min(g, b)) / b, 
        [ [ "min", "userMin", d ], [ "max", "userMax", g ] ].forEach(function(d) {
          "undefined" === typeof c(a.options[d[0]], a[d[1]]) && (a[d[0]] += d[2] / E);
        }));
      };
    });
    C(f, "modules/networkgraph/integrations.js", [ f["parts/Globals.js"] ], function(f) {
      f.networkgraphIntegrations = {
        verlet: {
          attractiveForceFunction: function(a, b) {
            return (b - a) / a;
          },
          repulsiveForceFunction: function(a, b) {
            return (b - a) / a * (b > a ? 1 : 0);
          },
          barycenter: function() {
            var a = this.options.gravitationalConstant, b = this.barycenter.xFactor, e = this.barycenter.yFactor;
            b = (b - (this.box.left + this.box.width) / 2) * a;
            e = (e - (this.box.top + this.box.height) / 2) * a;
            this.nodes.forEach(function(a) {
              a.fixedPosition || (a.plotX -= b / a.mass / a.degree, a.plotY -= e / a.mass / a.degree);
            });
          },
          repulsive: function(a, b, e) {
            b = b * this.diffTemperature / a.mass / a.degree;
            a.fixedPosition || (a.plotX += e.x * b, a.plotY += e.y * b);
          },
          attractive: function(a, b, e) {
            var h = a.getMass(), f = -e.x * b * this.diffTemperature;
            b = -e.y * b * this.diffTemperature;
            a.fromNode.fixedPosition || (a.fromNode.plotX -= f * h.fromNode / a.fromNode.degree, 
            a.fromNode.plotY -= b * h.fromNode / a.fromNode.degree);
            a.toNode.fixedPosition || (a.toNode.plotX += f * h.toNode / a.toNode.degree, a.toNode.plotY += b * h.toNode / a.toNode.degree);
          },
          integrate: function(a, b) {
            var e = -a.options.friction, h = a.options.maxSpeed, f = (b.plotX + b.dispX - b.prevX) * e;
            e *= b.plotY + b.dispY - b.prevY;
            var t = Math.abs, x = t(f) / (f || 1);
            t = t(e) / (e || 1);
            f = x * Math.min(h, Math.abs(f));
            e = t * Math.min(h, Math.abs(e));
            b.prevX = b.plotX + b.dispX;
            b.prevY = b.plotY + b.dispY;
            b.plotX += f;
            b.plotY += e;
            b.temperature = a.vectorLength({
              x: f,
              y: e
            });
          },
          getK: function(a) {
            return Math.pow(a.box.width * a.box.height / a.nodes.length, .5);
          }
        },
        euler: {
          attractiveForceFunction: function(a, b) {
            return a * a / b;
          },
          repulsiveForceFunction: function(a, b) {
            return b * b / a;
          },
          barycenter: function() {
            var a = this.options.gravitationalConstant, b = this.barycenter.xFactor, e = this.barycenter.yFactor;
            this.nodes.forEach(function(h) {
              if (!h.fixedPosition) {
                var f = h.getDegree();
                f *= 1 + f / 2;
                h.dispX += (b - h.plotX) * a * f / h.degree;
                h.dispY += (e - h.plotY) * a * f / h.degree;
              }
            });
          },
          repulsive: function(a, b, e, h) {
            a.dispX += e.x / h * b / a.degree;
            a.dispY += e.y / h * b / a.degree;
          },
          attractive: function(a, b, e, h) {
            var f = a.getMass(), t = e.x / h * b;
            b *= e.y / h;
            a.fromNode.fixedPosition || (a.fromNode.dispX -= t * f.fromNode / a.fromNode.degree, 
            a.fromNode.dispY -= b * f.fromNode / a.fromNode.degree);
            a.toNode.fixedPosition || (a.toNode.dispX += t * f.toNode / a.toNode.degree, a.toNode.dispY += b * f.toNode / a.toNode.degree);
          },
          integrate: function(a, b) {
            b.dispX += b.dispX * a.options.friction;
            b.dispY += b.dispY * a.options.friction;
            var e = b.temperature = a.vectorLength({
              x: b.dispX,
              y: b.dispY
            });
            0 !== e && (b.plotX += b.dispX / e * Math.min(Math.abs(b.dispX), a.temperature), 
            b.plotY += b.dispY / e * Math.min(Math.abs(b.dispY), a.temperature));
          },
          getK: function(a) {
            return Math.pow(a.box.width * a.box.height / a.nodes.length, .3);
          }
        }
      };
    });
    C(f, "modules/networkgraph/QuadTree.js", [ f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a) {
      a = a.extend;
      var b = f.QuadTreeNode = function(a) {
        this.box = a;
        this.boxSize = Math.min(a.width, a.height);
        this.nodes = [];
        this.body = this.isInternal = !1;
        this.isEmpty = !0;
      };
      a(b.prototype, {
        insert: function(a, h) {
          this.isInternal ? this.nodes[this.getBoxPosition(a)].insert(a, h - 1) : (this.isEmpty = !1, 
          this.body ? h ? (this.isInternal = !0, this.divideBox(), !0 !== this.body && (this.nodes[this.getBoxPosition(this.body)].insert(this.body, h - 1), 
          this.body = !0), this.nodes[this.getBoxPosition(a)].insert(a, h - 1)) : (h = new b({
            top: a.plotX,
            left: a.plotY,
            width: .1,
            height: .1
          }), h.body = a, h.isInternal = !1, this.nodes.push(h)) : (this.isInternal = !1, 
          this.body = a));
        },
        updateMassAndCenter: function() {
          var a = 0, b = 0, f = 0;
          this.isInternal ? (this.nodes.forEach(function(e) {
            e.isEmpty || (a += e.mass, b += e.plotX * e.mass, f += e.plotY * e.mass);
          }), b /= a, f /= a) : this.body && (a = this.body.mass, b = this.body.plotX, f = this.body.plotY);
          this.mass = a;
          this.plotX = b;
          this.plotY = f;
        },
        divideBox: function() {
          var a = this.box.width / 2, h = this.box.height / 2;
          this.nodes[0] = new b({
            left: this.box.left,
            top: this.box.top,
            width: a,
            height: h
          });
          this.nodes[1] = new b({
            left: this.box.left + a,
            top: this.box.top,
            width: a,
            height: h
          });
          this.nodes[2] = new b({
            left: this.box.left + a,
            top: this.box.top + h,
            width: a,
            height: h
          });
          this.nodes[3] = new b({
            left: this.box.left,
            top: this.box.top + h,
            width: a,
            height: h
          });
        },
        getBoxPosition: function(a) {
          var b = a.plotY < this.box.top + this.box.height / 2;
          return a.plotX < this.box.left + this.box.width / 2 ? b ? 0 : 3 : b ? 1 : 2;
        }
      });
      f = f.QuadTree = function(a, h, f, t) {
        this.box = {
          left: a,
          top: h,
          width: f,
          height: t
        };
        this.maxDepth = 25;
        this.root = new b(this.box, "0");
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
        visitNodeRecursive: function(a, b, f) {
          var e;
          a || (a = this.root);
          a === this.root && b && (e = b(a));
          !1 !== e && (a.nodes.forEach(function(a) {
            if (a.isInternal) {
              b && (e = b(a));
              if (!1 === e) return;
              this.visitNodeRecursive(a, b, f);
            } else a.body && b && b(a.body);
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
    C(f, "modules/networkgraph/layouts.js", [ f["parts/Chart.js"], f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a, b) {
      var e = b.addEvent, h = b.clamp, q = b.defined, t = b.extend, x = b.isFunction, B = b.pick, z = b.setAnimation;
      a.layouts = {
        "reingold-fruchterman": function() {}
      };
      t(a.layouts["reingold-fruchterman"].prototype, {
        init: function(c) {
          this.options = c;
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
          this.integration = a.networkgraphIntegrations[c.integration];
          this.enableSimulation = c.enableSimulation;
          this.attractiveForce = B(c.attractiveForce, this.integration.attractiveForceFunction);
          this.repulsiveForce = B(c.repulsiveForce, this.integration.repulsiveForceFunction);
          this.approximation = c.approximation;
        },
        updateSimulation: function(a) {
          this.enableSimulation = B(a, this.options.enableSimulation);
        },
        start: function() {
          var a = this.series, b = this.options;
          this.currentStep = 0;
          this.forces = a[0] && a[0].forces || [];
          this.chart = a[0] && a[0].chart;
          this.initialRendering && (this.initPositions(), a.forEach(function(a) {
            a.finishedAnimating = !0;
            a.render();
          }));
          this.setK();
          this.resetSimulation(b);
          this.enableSimulation && this.step();
        },
        step: function() {
          var c = this, b = this.series;
          c.currentStep++;
          "barnes-hut" === c.approximation && (c.createQuadTree(), c.quadTree.calculateMassAndCenter());
          c.forces.forEach(function(a) {
            c[a + "Forces"](c.temperature);
          });
          c.applyLimits(c.temperature);
          c.temperature = c.coolDown(c.startTemperature, c.diffTemperature, c.currentStep);
          c.prevSystemTemperature = c.systemTemperature;
          c.systemTemperature = c.getSystemTemperature();
          c.enableSimulation && (b.forEach(function(a) {
            a.chart && a.render();
          }), c.maxIterations-- && isFinite(c.temperature) && !c.isStable() ? (c.simulation && a.win.cancelAnimationFrame(c.simulation), 
          c.simulation = a.win.requestAnimationFrame(function() {
            c.step();
          })) : c.simulation = !1);
        },
        stop: function() {
          this.simulation && a.win.cancelAnimationFrame(this.simulation);
        },
        setArea: function(a, b, e, f) {
          this.box = {
            left: a,
            top: b,
            width: e,
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
        restartSimulation: function() {
          this.simulation ? this.resetSimulation() : (this.setInitialRendering(!1), this.enableSimulation ? this.start() : this.setMaxIterations(1), 
          this.chart && this.chart.redraw(), this.setInitialRendering(!0));
        },
        setMaxIterations: function(a) {
          this.maxIterations = B(a, this.options.maxIterations);
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
          this.quadTree = new a.QuadTree(this.box.left, this.box.top, this.box.width, this.box.height);
          this.quadTree.insertNodes(this.nodes);
        },
        initPositions: function() {
          var a = this.options.initialPositions;
          x(a) ? (a.call(this), this.nodes.forEach(function(a) {
            q(a.prevX) || (a.prevX = a.plotX);
            q(a.prevY) || (a.prevY = a.plotY);
            a.dispX = 0;
            a.dispY = 0;
          })) : "circle" === a ? this.setCircularPositions() : this.setRandomPositions();
        },
        setCircularPositions: function() {
          function a(d) {
            d.linksFrom.forEach(function(d) {
              m[d.toNode.id] || (m[d.toNode.id] = !0, q.push(d.toNode), a(d.toNode));
            });
          }
          var b = this.box, e = this.nodes, f = 2 * Math.PI / (e.length + 1), h = e.filter(function(a) {
            return 0 === a.linksTo.length;
          }), q = [], m = {}, n = this.options.initialPositionRadius;
          h.forEach(function(d) {
            q.push(d);
            a(d);
          });
          q.length ? e.forEach(function(a) {
            -1 === q.indexOf(a) && q.push(a);
          }) : q = e;
          q.forEach(function(a, g) {
            a.plotX = a.prevX = B(a.plotX, b.width / 2 + n * Math.cos(g * f));
            a.plotY = a.prevY = B(a.plotY, b.height / 2 + n * Math.sin(g * f));
            a.dispX = 0;
            a.dispY = 0;
          });
        },
        setRandomPositions: function() {
          function a(a) {
            a = a * a / Math.PI;
            return a -= Math.floor(a);
          }
          var b = this.box, e = this.nodes, f = e.length + 1;
          e.forEach(function(c, e) {
            c.plotX = c.prevX = B(c.plotX, b.width * a(e));
            c.plotY = c.prevY = B(c.plotY, b.height * a(f + e));
            c.dispX = 0;
            c.dispY = 0;
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
          var a = 0, b = 0, e = 0;
          this.nodes.forEach(function(c) {
            b += c.plotX * c.mass;
            e += c.plotY * c.mass;
            a += c.mass;
          });
          return this.barycenter = {
            x: b,
            y: e,
            xFactor: b / a,
            yFactor: e / a
          };
        },
        barnesHutApproximation: function(a, b) {
          var c = this.getDistXY(a, b), e = this.vectorLength(c);
          if (a !== b && 0 !== e) if (b.isInternal) {
            if (b.boxSize / e < this.options.theta && 0 !== e) {
              var f = this.repulsiveForce(e, this.k);
              this.force("repulsive", a, f * b.mass, c, e);
              var h = !1;
            } else h = !0;
          } else f = this.repulsiveForce(e, this.k), this.force("repulsive", a, f * b.mass, c, e);
          return h;
        },
        repulsiveForces: function() {
          var a = this;
          "barnes-hut" === a.approximation ? a.nodes.forEach(function(c) {
            a.quadTree.visitNodeRecursive(null, function(b) {
              return a.barnesHutApproximation(c, b);
            });
          }) : a.nodes.forEach(function(c) {
            a.nodes.forEach(function(b) {
              if (c !== b && !c.fixedPosition) {
                var e = a.getDistXY(c, b);
                var f = a.vectorLength(e);
                if (0 !== f) {
                  var h = a.repulsiveForce(f, a.k);
                  a.force("repulsive", c, h * b.mass, e, f);
                }
              }
            });
          });
        },
        attractiveForces: function() {
          var a = this, b, e, f;
          a.links.forEach(function(c) {
            c.fromNode && c.toNode && (b = a.getDistXY(c.fromNode, c.toNode), e = a.vectorLength(b), 
            0 !== e && (f = a.attractiveForce(e, a.k), a.force("attractive", c, f, b, e)));
          });
        },
        applyLimits: function() {
          var a = this;
          a.nodes.forEach(function(c) {
            c.fixedPosition || (a.integration.integrate(a, c), a.applyLimitBox(c, a.box), c.dispX = 0, 
            c.dispY = 0);
          });
        },
        applyLimitBox: function(a, b) {
          var c = a.radius;
          a.plotX = h(a.plotX, b.left + c, b.width - c);
          a.plotY = h(a.plotY, b.top + c, b.height - c);
        },
        coolDown: function(a, b, e) {
          return a - b * e;
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
      e(f, "predraw", function() {
        this.graphLayoutsLookup && this.graphLayoutsLookup.forEach(function(a) {
          a.stop();
        });
      });
      e(f, "render", function() {
        function a(a) {
          a.maxIterations-- && isFinite(a.temperature) && !a.isStable() && !a.enableSimulation && (a.beforeStep && a.beforeStep(), 
          a.step(), e = !1, b = !0);
        }
        var b = !1;
        if (this.graphLayoutsLookup) {
          z(!1, this);
          for (this.graphLayoutsLookup.forEach(function(a) {
            a.start();
          }); !e; ) {
            var e = !0;
            this.graphLayoutsLookup.forEach(a);
          }
          b && this.series.forEach(function(a) {
            a && a.layout && a.render();
          });
        }
      });
      e(f, "beforePrint", function() {
        this.graphLayoutsLookup && (this.graphLayoutsLookup.forEach(function(a) {
          a.updateSimulation(!1);
        }), this.redraw());
      });
      e(f, "afterPrint", function() {
        this.graphLayoutsLookup && this.graphLayoutsLookup.forEach(function(a) {
          a.updateSimulation();
        });
        this.redraw();
      });
    });
    C(f, "modules/networkgraph/draggable-nodes.js", [ f["parts/Chart.js"], f["parts/Globals.js"], f["parts/Utilities.js"] ], function(f, a, b) {
      var e = b.addEvent;
      a.dragNodesMixin = {
        onMouseDown: function(a, b) {
          b = this.chart.pointer.normalize(b);
          a.fixedPosition = {
            chartX: b.chartX,
            chartY: b.chartY,
            plotX: a.plotX,
            plotY: a.plotY
          };
          a.inDragMode = !0;
        },
        onMouseMove: function(a, b) {
          if (a.fixedPosition && a.inDragMode) {
            var e = this.chart;
            b = e.pointer.normalize(b);
            var f = a.fixedPosition.chartX - b.chartX, h = a.fixedPosition.chartY - b.chartY;
            b = e.graphLayoutsLookup;
            if (5 < Math.abs(f) || 5 < Math.abs(h)) f = a.fixedPosition.plotX - f, h = a.fixedPosition.plotY - h, 
            e.isInsidePlot(f, h) && (a.plotX = f, a.plotY = h, a.hasDragged = !0, this.redrawHalo(a), 
            b.forEach(function(a) {
              a.restartSimulation();
            }));
          }
        },
        onMouseUp: function(a, b) {
          a.fixedPosition && a.hasDragged && (this.layout.enableSimulation ? this.layout.start() : this.chart.redraw(), 
          a.inDragMode = a.hasDragged = !1, this.options.fixedDraggable || delete a.fixedPosition);
        },
        redrawHalo: function(a) {
          a && this.halo && this.halo.attr({
            d: a.haloPath(this.options.states.hover.halo.size)
          });
        }
      };
      e(f, "load", function() {
        var a = this, b, f, x;
        a.container && (b = e(a.container, "mousedown", function(b) {
          var h = a.hoverPoint;
          h && h.series && h.series.hasDraggableNodes && h.series.options.draggable && (h.series.onMouseDown(h, b), 
          f = e(a.container, "mousemove", function(a) {
            return h && h.series && h.series.onMouseMove(h, a);
          }), x = e(a.container.ownerDocument, "mouseup", function(a) {
            f();
            x();
            return h && h.series && h.series.onMouseUp(h, a);
          }));
        }));
        e(a, "destroy", function() {
          b();
        });
      });
    });
    C(f, "parts-more/PackedBubbleSeries.js", [ f["parts/Chart.js"], f["parts/Color.js"], f["parts/Globals.js"], f["parts/Point.js"], f["parts/Utilities.js"] ], function(f, a, b, e, h) {
      var q = a.parse, t = h.addEvent, x = h.clamp, B = h.defined, z = h.extend;
      a = h.extendClass;
      var c = h.fireEvent, l = h.isArray, w = h.isNumber, p = h.merge, y = h.pick;
      h = h.seriesType;
      var v = b.Series, m = b.layouts["reingold-fruchterman"], n = b.dragNodesMixin;
      f.prototype.getSelectedParentNodes = function() {
        var a = [];
        this.series.forEach(function(d) {
          d.parentNode && d.parentNode.selected && a.push(d.parentNode);
        });
        return a;
      };
      b.networkgraphIntegrations.packedbubble = {
        repulsiveForceFunction: function(a, g, b, c) {
          return Math.min(a, (b.marker.radius + c.marker.radius) / 2);
        },
        barycenter: function() {
          var a = this, g = a.options.gravitationalConstant, b = a.box, c = a.nodes, e, f;
          c.forEach(function(d) {
            a.options.splitSeries && !d.isParentNode ? (e = d.series.parentNode.plotX, f = d.series.parentNode.plotY) : (e = b.width / 2, 
            f = b.height / 2);
            d.fixedPosition || (d.plotX -= (d.plotX - e) * g / (d.mass * Math.sqrt(c.length)), 
            d.plotY -= (d.plotY - f) * g / (d.mass * Math.sqrt(c.length)));
          });
        },
        repulsive: function(a, g, b, c) {
          var d = g * this.diffTemperature / a.mass / a.degree;
          g = b.x * d;
          b = b.y * d;
          a.fixedPosition || (a.plotX += g, a.plotY += b);
          c.fixedPosition || (c.plotX -= g, c.plotY -= b);
        },
        integrate: b.networkgraphIntegrations.verlet.integrate,
        getK: b.noop
      };
      b.layouts.packedbubble = a(m, {
        beforeStep: function() {
          this.options.marker && this.series.forEach(function(a) {
            a && a.calculateParentRadius();
          });
        },
        setCircularPositions: function() {
          var a = this, g = a.box, b = a.nodes, c = 2 * Math.PI / (b.length + 1), e, f, h = a.options.initialPositionRadius;
          b.forEach(function(d, b) {
            a.options.splitSeries && !d.isParentNode ? (e = d.series.parentNode.plotX, f = d.series.parentNode.plotY) : (e = g.width / 2, 
            f = g.height / 2);
            d.plotX = d.prevX = y(d.plotX, e + h * Math.cos(d.index || b * c));
            d.plotY = d.prevY = y(d.plotY, f + h * Math.sin(d.index || b * c));
            d.dispX = 0;
            d.dispY = 0;
          });
        },
        repulsiveForces: function() {
          var a = this, g, b, c, e = a.options.bubblePadding;
          a.nodes.forEach(function(d) {
            d.degree = d.mass;
            d.neighbours = 0;
            a.nodes.forEach(function(k) {
              g = 0;
              d === k || d.fixedPosition || !a.options.seriesInteraction && d.series !== k.series || (c = a.getDistXY(d, k), 
              b = a.vectorLength(c) - (d.marker.radius + k.marker.radius + e), 0 > b && (d.degree += .01, 
              d.neighbours++, g = a.repulsiveForce(-b / Math.sqrt(d.neighbours), a.k, d, k)), 
              a.force("repulsive", d, g * k.mass, c, k, b));
            });
          });
        },
        applyLimitBox: function(a) {
          if (this.options.splitSeries && !a.isParentNode && this.options.parentNodeLimit) {
            var d = this.getDistXY(a, a.series.parentNode);
            var b = a.series.parentNodeRadius - a.marker.radius - this.vectorLength(d);
            0 > b && b > -2 * a.marker.radius && (a.plotX -= .01 * d.x, a.plotY -= .01 * d.y);
          }
          m.prototype.applyLimitBox.apply(this, arguments);
        }
      });
      h("packedbubble", "bubble", {
        minSize: "10%",
        maxSize: "50%",
        sizeBy: "area",
        zoneAxis: "y",
        crisp: !1,
        tooltip: {
          pointFormat: "Value: {point.value}"
        },
        draggable: !0,
        useSimulation: !0,
        parentNode: {
          allowPointSelect: !1
        },
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
          padding: 0,
          style: {
            transition: "opacity 2000ms"
          }
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
        trackerGroups: [ "group", "dataLabelsGroup", "parentNodesGroup" ],
        pointValKey: "value",
        isCartesian: !1,
        requireSorting: !1,
        directTouch: !0,
        axisTypes: [],
        noSharedTooltip: !0,
        searchPoint: b.noop,
        accumulateAllPoints: function(a) {
          var d = a.chart, b = [], c, e;
          for (c = 0; c < d.series.length; c++) if (a = d.series[c], a.is("packedbubble") && a.visible || !d.options.chart.ignoreHiddenSeries) for (e = 0; e < a.yData.length; e++) b.push([ null, null, a.yData[e], a.index, e, {
            id: e,
            marker: {
              radius: 0
            }
          } ]);
          return b;
        },
        init: function() {
          v.prototype.init.apply(this, arguments);
          t(this, "updatedData", function() {
            this.chart.series.forEach(function(a) {
              a.type === this.type && (a.isDirty = !0);
            }, this);
          });
          return this;
        },
        render: function() {
          var a = [];
          v.prototype.render.apply(this, arguments);
          this.options.dataLabels.allowOverlap || (this.data.forEach(function(d) {
            l(d.dataLabels) && d.dataLabels.forEach(function(d) {
              a.push(d);
            });
          }), this.options.useSimulation && this.chart.hideOverlappingLabels(a));
        },
        setVisible: function() {
          var a = this;
          v.prototype.setVisible.apply(a, arguments);
          a.parentNodeLayout && a.graph ? a.visible ? (a.graph.show(), a.parentNode.dataLabel && a.parentNode.dataLabel.show()) : (a.graph.hide(), 
          a.parentNodeLayout.removeElementFromCollection(a.parentNode, a.parentNodeLayout.nodes), 
          a.parentNode.dataLabel && a.parentNode.dataLabel.hide()) : a.layout && (a.visible ? a.layout.addElementsToCollection(a.points, a.layout.nodes) : a.points.forEach(function(d) {
            a.layout.removeElementFromCollection(d, a.layout.nodes);
          }));
        },
        drawDataLabels: function() {
          var a = this.options.dataLabels.textPath, b = this.points;
          v.prototype.drawDataLabels.apply(this, arguments);
          this.parentNode && (this.parentNode.formatPrefix = "parentNode", this.points = [ this.parentNode ], 
          this.options.dataLabels.textPath = this.options.dataLabels.parentNodeTextPath, v.prototype.drawDataLabels.apply(this, arguments), 
          this.points = b, this.options.dataLabels.textPath = a);
        },
        seriesBox: function() {
          var a = this.chart, b = Math.max, c = Math.min, e, f = [ a.plotLeft, a.plotLeft + a.plotWidth, a.plotTop, a.plotTop + a.plotHeight ];
          this.data.forEach(function(a) {
            B(a.plotX) && B(a.plotY) && a.marker.radius && (e = a.marker.radius, f[0] = c(f[0], a.plotX - e), 
            f[1] = b(f[1], a.plotX + e), f[2] = c(f[2], a.plotY - e), f[3] = b(f[3], a.plotY + e));
          });
          return w(f.width / f.height) ? f : null;
        },
        calculateParentRadius: function() {
          var a = this.seriesBox();
          this.parentNodeRadius = x(Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20, 20, a ? Math.max(Math.sqrt(Math.pow(a.width, 2) + Math.pow(a.height, 2)) / 2 + 20, 20) : Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20);
          this.parentNode && (this.parentNode.marker.radius = this.parentNode.radius = this.parentNodeRadius);
        },
        drawGraph: function() {
          if (this.layout && this.layout.options.splitSeries) {
            var a = this.chart, b = this.layout.options.parentNodeOptions.marker;
            b = {
              fill: b.fillColor || q(this.color).brighten(.4).get(),
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
            c = p({
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
          var a = this, b = a.chart, c = a.parentNodeLayout, e, f = a.parentNode, h = a.pointClass;
          a.parentNodeMass = 0;
          a.points.forEach(function(d) {
            a.parentNodeMass += Math.PI * Math.pow(d.marker.radius, 2);
          });
          a.calculateParentRadius();
          c.nodes.forEach(function(d) {
            d.seriesIndex === a.index && (e = !0);
          });
          c.setArea(0, 0, b.plotWidth, b.plotHeight);
          e || (f || (f = new h().init(this, {
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
        drawTracker: function() {
          var a = this.parentNode;
          b.TrackerMixin.drawTrackerPoint.call(this);
          if (a) {
            var g = l(a.dataLabels) ? a.dataLabels : a.dataLabel ? [ a.dataLabel ] : [];
            a.graphic && (a.graphic.element.point = a);
            g.forEach(function(d) {
              d.div ? d.div.point = a : d.element.point = a;
            });
          }
        },
        addSeriesLayout: function() {
          var a = this.options.layoutAlgorithm, g = this.chart.graphLayoutsStorage, c = this.chart.graphLayoutsLookup, e = p(a, a.parentNodeOptions, {
            enableSimulation: this.layout.options.enableSimulation
          });
          var f = g[a.type + "-series"];
          f || (g[a.type + "-series"] = f = new b.layouts[a.type](), f.init(e), c.splice(f.index, 0, f));
          this.parentNodeLayout = f;
          this.createParentNodes();
        },
        addLayout: function() {
          var a = this.options.layoutAlgorithm, g = this.chart.graphLayoutsStorage, c = this.chart.graphLayoutsLookup, e = this.chart.options.chart;
          g || (this.chart.graphLayoutsStorage = g = {}, this.chart.graphLayoutsLookup = c = []);
          var f = g[a.type];
          f || (a.enableSimulation = B(e.forExport) ? !e.forExport : a.enableSimulation, g[a.type] = f = new b.layouts[a.type](), 
          f.init(a), c.splice(f.index, 0, f));
          this.layout = f;
          this.points.forEach(function(a) {
            a.mass = 2;
            a.degree = 1;
            a.collisionNmb = 1;
          });
          f.setArea(0, 0, this.chart.plotWidth, this.chart.plotHeight);
          f.addElementsToCollection([ this ], f.series);
          f.addElementsToCollection(this.points, f.nodes);
        },
        deferLayout: function() {
          var a = this.options.layoutAlgorithm;
          this.visible && (this.addLayout(), a.splitSeries && this.addSeriesLayout());
        },
        translate: function() {
          var a = this.chart, b = this.data, k = this.index, e, f = this.options.useSimulation;
          this.processedXData = this.xData;
          this.generatePoints();
          B(a.allDataPoints) || (a.allDataPoints = this.accumulateAllPoints(this), this.getPointRadius());
          if (f) var h = a.allDataPoints; else h = this.placeBubbles(a.allDataPoints), this.options.draggable = !1;
          for (e = 0; e < h.length; e++) if (h[e][3] === k) {
            var l = b[h[e][4]];
            var m = h[e][2];
            f || (l.plotX = h[e][0] - a.plotLeft + a.diffX, l.plotY = h[e][1] - a.plotTop + a.diffY);
            l.marker = z(l.marker, {
              radius: m,
              width: 2 * m,
              height: 2 * m
            });
            l.radius = m;
          }
          f && this.deferLayout();
          c(this, "afterTranslate");
        },
        checkOverlap: function(a, b) {
          var d = a[0] - b[0], g = a[1] - b[1];
          return -.001 > Math.sqrt(d * d + g * g) - Math.abs(a[2] + b[2]);
        },
        positionBubble: function(a, b, c) {
          var d = Math.sqrt, g = Math.asin, k = Math.acos, e = Math.pow, f = Math.abs;
          d = d(e(a[0] - b[0], 2) + e(a[1] - b[1], 2));
          k = k((e(d, 2) + e(c[2] + b[2], 2) - e(c[2] + a[2], 2)) / (2 * (c[2] + b[2]) * d));
          g = g(f(a[0] - b[0]) / d);
          a = (0 > a[1] - b[1] ? 0 : Math.PI) + k + g * (0 > (a[0] - b[0]) * (a[1] - b[1]) ? 1 : -1);
          return [ b[0] + (b[2] + c[2]) * Math.sin(a), b[1] - (b[2] + c[2]) * Math.cos(a), c[2], c[3], c[4] ];
        },
        placeBubbles: function(a) {
          var b = this.checkOverlap, d = this.positionBubble, c = [], e = 1, f = 0, h = 0;
          var l = [];
          var m;
          a = a.sort(function(a, b) {
            return b[2] - a[2];
          });
          if (a.length) {
            c.push([ [ 0, 0, a[0][2], a[0][3], a[0][4] ] ]);
            if (1 < a.length) for (c.push([ [ 0, 0 - a[1][2] - a[0][2], a[1][2], a[1][3], a[1][4] ] ]), 
            m = 2; m < a.length; m++) a[m][2] = a[m][2] || 1, l = d(c[e][f], c[e - 1][h], a[m]), 
            b(l, c[e][0]) ? (c.push([]), h = 0, c[e + 1].push(d(c[e][f], c[e][0], a[m])), e++, 
            f = 0) : 1 < e && c[e - 1][h + 1] && b(l, c[e - 1][h + 1]) ? (h++, c[e].push(d(c[e][f], c[e - 1][h], a[m])), 
            f++) : (f++, c[e].push(l));
            this.chart.stages = c;
            this.chart.rawPositions = [].concat.apply([], c);
            this.resizeRadius();
            l = this.chart.rawPositions;
          }
          return l;
        },
        resizeRadius: function() {
          var a = this.chart, b = a.rawPositions, c = Math.min, e = Math.max, f = a.plotLeft, h = a.plotTop, l = a.plotHeight, m = a.plotWidth, n, p, q;
          var t = n = Number.POSITIVE_INFINITY;
          var v = p = Number.NEGATIVE_INFINITY;
          for (q = 0; q < b.length; q++) {
            var w = b[q][2];
            t = c(t, b[q][0] - w);
            v = e(v, b[q][0] + w);
            n = c(n, b[q][1] - w);
            p = e(p, b[q][1] + w);
          }
          q = [ v - t, p - n ];
          c = c.apply([], [ (m - f) / q[0], (l - h) / q[1] ]);
          if (1e-10 < Math.abs(c - 1)) {
            for (q = 0; q < b.length; q++) b[q][2] *= c;
            this.placeBubbles(b);
          } else a.diffY = l / 2 + h - n - (p - n) / 2, a.diffX = m / 2 + f - t - (v - t) / 2;
        },
        calculateZExtremes: function() {
          var a = this.options.zMin, b = this.options.zMax, c = Infinity, e = -Infinity;
          if (a && b) return [ a, b ];
          this.chart.series.forEach(function(a) {
            a.yData.forEach(function(a) {
              B(a) && (a > e && (e = a), a < c && (c = a));
            });
          });
          a = y(a, c);
          b = y(b, e);
          return [ a, b ];
        },
        getPointRadius: function() {
          var a = this, b = a.chart, c = a.options, e = c.useSimulation, f = Math.min(b.plotWidth, b.plotHeight), h = {}, l = [], m = b.allDataPoints, n, p, q, t;
          [ "minSize", "maxSize" ].forEach(function(a) {
            var b = parseInt(c[a], 10), d = /%$/.test(c[a]);
            h[a] = d ? f * b / 100 : b * Math.sqrt(m.length);
          });
          b.minRadius = n = h.minSize / Math.sqrt(m.length);
          b.maxRadius = p = h.maxSize / Math.sqrt(m.length);
          var v = e ? a.calculateZExtremes() : [ n, p ];
          (m || []).forEach(function(b, c) {
            q = e ? x(b[2], v[0], v[1]) : b[2];
            t = a.getRadius(v[0], v[1], n, p, q);
            0 === t && (t = null);
            m[c][2] = t;
            l.push(t);
          });
          a.radii = l;
        },
        redrawHalo: n.redrawHalo,
        onMouseDown: n.onMouseDown,
        onMouseMove: n.onMouseMove,
        onMouseUp: function(a) {
          if (a.fixedPosition && !a.removed) {
            var b, c, d = this.layout, e = this.parentNodeLayout;
            e && d.options.dragBetweenSeries && e.nodes.forEach(function(g) {
              a && a.marker && g !== a.series.parentNode && (b = d.getDistXY(a, g), c = d.vectorLength(b) - g.marker.radius - a.marker.radius, 
              0 > c && (g.series.addPoint(p(a.options, {
                plotX: a.plotX,
                plotY: a.plotY
              }), !1), d.removeElementFromCollection(a, d.nodes), a.remove()));
            });
            n.onMouseUp.apply(this, arguments);
          }
        },
        destroy: function() {
          this.chart.graphLayoutsLookup && this.chart.graphLayoutsLookup.forEach(function(a) {
            a.removeElementFromCollection(this, a.series);
          }, this);
          this.parentNode && (this.parentNodeLayout.removeElementFromCollection(this.parentNode, this.parentNodeLayout.nodes), 
          this.parentNode.dataLabel && (this.parentNode.dataLabel = this.parentNode.dataLabel.destroy()));
          b.Series.prototype.destroy.apply(this, arguments);
        },
        alignDataLabel: b.Series.prototype.alignDataLabel
      }, {
        destroy: function() {
          this.series.layout && this.series.layout.removeElementFromCollection(this, this.series.layout.nodes);
          return e.prototype.destroy.apply(this, arguments);
        },
        firePointEvent: function(a, b, c) {
          var d = this.series.options;
          if (this.isParentNode && d.parentNode) {
            var g = d.allowPointSelect;
            d.allowPointSelect = d.parentNode.allowPointSelect;
            e.prototype.firePointEvent.apply(this, arguments);
            d.allowPointSelect = g;
          } else e.prototype.firePointEvent.apply(this, arguments);
        },
        select: function(a, c) {
          var d = this.series.chart;
          this.isParentNode ? (d.getSelectedPoints = d.getSelectedParentNodes, e.prototype.select.apply(this, arguments), 
          d.getSelectedPoints = b.Chart.prototype.getSelectedPoints) : e.prototype.select.apply(this, arguments);
        }
      });
      t(f, "beforeRedraw", function() {
        this.allDataPoints && delete this.allDataPoints;
      });
    });
    C(f, "parts-more/Polar.js", [ f["parts/Chart.js"], f["parts/Globals.js"], f["parts-more/Pane.js"], f["parts/Pointer.js"], f["parts/SVGRenderer.js"], f["parts/Utilities.js"] ], function(f, a, b, e, h, q) {
      var t = q.addEvent, x = q.animObject, B = q.defined, z = q.find, c = q.isNumber, l = q.pick, w = q.splat, p = q.uniqueKey, y = q.wrap, v = a.Series, m = a.seriesTypes, n = v.prototype;
      e = e.prototype;
      n.searchPointByAngle = function(a) {
        var b = this.chart, c = this.xAxis.pane.center;
        return this.searchKDTree({
          clientX: 180 + -180 / Math.PI * Math.atan2(a.chartX - c[0] - b.plotLeft, a.chartY - c[1] - b.plotTop)
        });
      };
      n.getConnectors = function(a, b, c, d) {
        var g = d ? 1 : 0;
        var e = 0 <= b && b <= a.length - 1 ? b : 0 > b ? a.length - 1 + b : 0;
        b = 0 > e - 1 ? a.length - (1 + g) : e - 1;
        g = e + 1 > a.length - 1 ? g : e + 1;
        var f = a[b];
        g = a[g];
        var k = f.plotX;
        f = f.plotY;
        var h = g.plotX;
        var l = g.plotY;
        g = a[e].plotX;
        e = a[e].plotY;
        k = (1.5 * g + k) / 2.5;
        f = (1.5 * e + f) / 2.5;
        h = (1.5 * g + h) / 2.5;
        var m = (1.5 * e + l) / 2.5;
        l = Math.sqrt(Math.pow(k - g, 2) + Math.pow(f - e, 2));
        var n = Math.sqrt(Math.pow(h - g, 2) + Math.pow(m - e, 2));
        k = Math.atan2(f - e, k - g);
        m = Math.PI / 2 + (k + Math.atan2(m - e, h - g)) / 2;
        Math.abs(k - m) > Math.PI / 2 && (m -= Math.PI);
        k = g + Math.cos(m) * l;
        f = e + Math.sin(m) * l;
        h = g + Math.cos(Math.PI + m) * n;
        m = e + Math.sin(Math.PI + m) * n;
        g = {
          rightContX: h,
          rightContY: m,
          leftContX: k,
          leftContY: f,
          plotX: g,
          plotY: e
        };
        c && (g.prevPointCont = this.getConnectors(a, b, !1, d));
        return g;
      };
      n.toXY = function(a) {
        var b = this.chart, c = this.xAxis;
        var d = this.yAxis;
        var e = a.plotX, g = a.plotY, f = a.series, h = b.inverted, l = a.y, m = h ? e : d.len - g;
        h && f && !f.isRadialBar && (a.plotY = g = "number" === typeof l ? d.translate(l) || 0 : 0);
        a.rectPlotX = e;
        a.rectPlotY = g;
        d.center && (m += d.center[3] / 2);
        d = h ? d.postTranslate(g, m) : c.postTranslate(e, m);
        a.plotX = a.polarPlotX = d.x - b.plotLeft;
        a.plotY = a.polarPlotY = d.y - b.plotTop;
        this.kdByAngle ? (b = (e / Math.PI * 180 + c.pane.options.startAngle) % 360, 0 > b && (b += 360), 
        a.clientX = b) : a.clientX = a.plotX;
      };
      m.spline && (y(m.spline.prototype, "getPointSpline", function(a, b, c, d) {
        this.chart.polar ? d ? (a = this.getConnectors(b, d, !0, this.connectEnds), a = [ "C", a.prevPointCont.rightContX, a.prevPointCont.rightContY, a.leftContX, a.leftContY, a.plotX, a.plotY ]) : a = [ "M", c.plotX, c.plotY ] : a = a.call(this, b, c, d);
        return a;
      }), m.areasplinerange && (m.areasplinerange.prototype.getPointSpline = m.spline.prototype.getPointSpline));
      t(v, "afterTranslate", function() {
        var b = this.chart;
        if (b.polar && this.xAxis) {
          (this.kdByAngle = b.tooltip && b.tooltip.shared) ? this.searchPoint = this.searchPointByAngle : this.options.findNearestPointBy = "xy";
          if (!this.preventPostTranslate) for (var c = this.points, d = c.length; d--; ) this.toXY(c[d]), 
          !b.hasParallelCoordinates && !this.yAxis.reversed && c[d].y < this.yAxis.min && (c[d].isNull = !0);
          this.hasClipCircleSetter || (this.hasClipCircleSetter = !!this.eventsToUnbind.push(t(this, "afterRender", function() {
            if (b.polar) {
              var c = this.yAxis.pane.center;
              this.clipCircle ? this.clipCircle.animate({
                x: c[0],
                y: c[1],
                r: c[2] / 2,
                innerR: c[3] / 2
              }) : this.clipCircle = b.renderer.clipCircle(c[0], c[1], c[2] / 2, c[3] / 2);
              this.group.clip(this.clipCircle);
              this.setClip = a.noop;
            }
          })));
        }
      }, {
        order: 2
      });
      y(n, "getGraphPath", function(a, b) {
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
            var g = !0;
          }
          b.forEach(function(a) {
            "undefined" === typeof a.polarPlotY && c.toXY(a);
          });
        }
        d = a.apply(this, [].slice.call(arguments, 1));
        g && b.pop();
        return d;
      });
      var d = function(b, c) {
        var d = this, e = this.chart, f = this.options.animation, g = this.group, k = this.markerGroup, h = this.xAxis.center, m = e.plotLeft, n = e.plotTop, p, q, t, v;
        if (e.polar) {
          if (d.isRadialBar) c || (d.startAngleRad = l(d.translatedThreshold, d.xAxis.startAngleRad), 
          a.seriesTypes.pie.prototype.animate.call(d, c)); else {
            if (e.renderer.isSVG) if (f = x(f), d.is("column")) {
              if (!c) {
                var w = h[3] / 2;
                d.points.forEach(function(a) {
                  p = a.graphic;
                  t = (q = a.shapeArgs) && q.r;
                  v = q && q.innerR;
                  p && q && (p.attr({
                    r: w,
                    innerR: w
                  }), p.animate({
                    r: t,
                    innerR: v
                  }, d.options.animation));
                });
              }
            } else c ? (b = {
              translateX: h[0] + m,
              translateY: h[1] + n,
              scaleX: .001,
              scaleY: .001
            }, g.attr(b), k && k.attr(b)) : (b = {
              translateX: m,
              translateY: n,
              scaleX: 1,
              scaleY: 1
            }, g.animate(b, f), k && k.animate(b, f));
          }
        } else b.call(this, c);
      };
      y(n, "animate", d);
      m.column && (v = m.arearange.prototype, m = m.column.prototype, m.polarArc = function(a, b, c, d) {
        var e = this.xAxis.center, f = this.yAxis.len, g = e[3] / 2;
        b = f - b + g;
        a = f - l(a, f) + g;
        this.yAxis.reversed && (0 > b && (b = g), 0 > a && (a = g));
        return {
          x: e[0],
          y: e[1],
          r: b,
          innerR: a,
          start: c,
          end: d
        };
      }, y(m, "animate", d), y(m, "translate", function(a) {
        var b = this.options, d = b.stacking, e = this.chart, f = this.xAxis, g = this.yAxis, h = g.reversed, l = g.center, m = f.startAngleRad, n = f.endAngleRad - m;
        this.preventPostTranslate = !0;
        a.call(this);
        if (f.isRadial) {
          a = this.points;
          f = a.length;
          var p = g.translate(g.min);
          var t = g.translate(g.max);
          b = b.threshold || 0;
          if (e.inverted && c(b)) {
            var v = g.translate(b);
            B(v) && (0 > v ? v = 0 : v > n && (v = n), this.translatedThreshold = v + m);
          }
          for (;f--; ) {
            b = a[f];
            var w = b.barX;
            var z = b.x;
            var y = b.y;
            b.shapeType = "arc";
            if (e.inverted) {
              b.plotY = g.translate(y);
              if (d && g.stacking) {
                if (y = g.stacking.stacks[(0 > y ? "-" : "") + this.stackKey], this.visible && y && y[z] && !b.isNull) {
                  var x = y[z].points[this.getStackIndicator(void 0, z, this.index).key];
                  var C = g.translate(x[0]);
                  x = g.translate(x[1]);
                  B(C) && (C = q.clamp(C, 0, n));
                }
              } else C = v, x = b.plotY;
              C > x && (x = [ C, C = x ][0]);
              if (!h) {
                if (C < p) C = p; else if (x > t) x = t; else {
                  if (x < p || C > t) C = x = 0;
                }
              } else if (x > p) x = p; else if (C < t) C = t; else if (C > p || x < t) C = x = n;
              g.min > g.max && (C = x = h ? n : 0);
              C += m;
              x += m;
              l && (b.barX = w += l[3] / 2);
              z = Math.max(w, 0);
              y = Math.max(w + b.pointWidth, 0);
              b.shapeArgs = {
                x: l && l[0],
                y: l && l[1],
                r: y,
                innerR: z,
                start: C,
                end: x
              };
              b.opacity = C === x ? 0 : void 0;
              b.plotY = (B(this.translatedThreshold) && (C < this.translatedThreshold ? C : x)) - m;
            } else C = w + m, b.shapeArgs = this.polarArc(b.yBottom, b.plotY, C, C + b.pointWidth);
            this.toXY(b);
            e.inverted ? (w = g.postTranslate(b.rectPlotY, w + b.pointWidth / 2), b.tooltipPos = [ w.x - e.plotLeft, w.y - e.plotTop ]) : b.tooltipPos = [ b.plotX, b.plotY ];
            l && (b.ttBelow = b.plotY > l[1]);
          }
        }
      }), m.findAlignments = function(a, b) {
        null === b.align && (b.align = 20 < a && 160 > a ? "left" : 200 < a && 340 > a ? "right" : "center");
        null === b.verticalAlign && (b.verticalAlign = 45 > a || 315 < a ? "bottom" : 135 < a && 225 > a ? "top" : "middle");
        return b;
      }, v && (v.findAlignments = m.findAlignments), y(m, "alignDataLabel", function(a, b, c, d, e, f) {
        var g = this.chart, h = l(d.inside, !!this.options.stacking);
        g.polar ? (a = b.rectPlotX / Math.PI * 180, g.inverted ? (this.forceDL = g.isInsidePlot(b.plotX, Math.round(b.plotY), !1), 
        h && b.shapeArgs ? (e = b.shapeArgs, e = this.yAxis.postTranslate((e.start + e.end) / 2 - this.xAxis.startAngleRad, b.barX + b.pointWidth / 2), 
        e = {
          x: e.x - g.plotLeft,
          y: e.y - g.plotTop
        }) : b.tooltipPos && (e = {
          x: b.tooltipPos[0],
          y: b.tooltipPos[1]
        }), d.align = l(d.align, "center"), d.verticalAlign = l(d.verticalAlign, "middle")) : this.findAlignments && (d = this.findAlignments(a, d)), 
        n.alignDataLabel.call(this, b, c, d, e, f), this.isRadialBar && b.shapeArgs && b.shapeArgs.start === b.shapeArgs.end && c.hide(!0)) : a.call(this, b, c, d, e, f);
      }));
      y(e, "getCoordinates", function(a, b) {
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
      h.prototype.clipCircle = function(a, b, c, d) {
        var e = p(), f = this.createElement("clipPath").attr({
          id: e
        }).add(this.defs);
        a = d ? this.arc(a, b, c, d, 0, 2 * Math.PI).add(f) : this.circle(a, b, c).add(f);
        a.id = e;
        a.clipPath = f;
        return a;
      };
      t(f, "getAxes", function() {
        this.pane || (this.pane = []);
        w(this.options.pane).forEach(function(a) {
          new b(a, this);
        }, this);
      });
      t(f, "afterDrawChartBox", function() {
        this.pane.forEach(function(a) {
          a.render();
        });
      });
      t(a.Series, "afterInit", function() {
        var a = this.chart;
        a.inverted && a.polar && (this.isRadialSeries = !0, this.is("column") && (this.isRadialBar = !0));
      });
      y(f.prototype, "get", function(a, b) {
        return z(this.pane, function(a) {
          return a.options.id === b;
        }) || a.call(this, b);
      });
    });
    C(f, "masters/highcharts-more.src.js", [], function() {});
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

window.Chartkick.use(window.Highcharts);
