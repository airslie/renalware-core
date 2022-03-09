function createCommonjsModule(fn, basedir, module) {
	return module = {
		path: basedir,
		exports: {},
		require: function (path, base) {
			return commonjsRequire(path, (base === undefined || base === null) ? module.path : base);
		}
	}, fn(module, module.exports), module.exports;
}

function commonjsRequire () {
	throw new Error('Dynamic requires are not currently supported by @rollup/plugin-commonjs');
}

var _global = createCommonjsModule(function (module) {
// https://github.com/zloirock/core-js/issues/86#issuecomment-115759028
var global = module.exports = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self // eslint-disable-next-line no-new-func
: Function('return this')();
if (typeof __g == 'number') __g = global; // eslint-disable-line no-undef
});

var _core = createCommonjsModule(function (module) {
var core = module.exports = {
  version: '2.6.11'
};
if (typeof __e == 'number') __e = core; // eslint-disable-line no-undef
});

var _isObject = function (it) {
  return typeof it === 'object' ? it !== null : typeof it === 'function';
};

var _anObject = function (it) {
  if (!_isObject(it)) throw TypeError(it + ' is not an object!');
  return it;
};

var _fails = function (exec) {
  try {
    return !!exec();
  } catch (e) {
    return true;
  }
};

// Thank's IE8 for his funny defineProperty
var _descriptors = !_fails(function () {
  return Object.defineProperty({}, 'a', {
    get: function () {
      return 7;
    }
  }).a != 7;
});

var document$2 = _global.document; // typeof document.createElement is 'object' in old IE


var is = _isObject(document$2) && _isObject(document$2.createElement);

var _domCreate = function (it) {
  return is ? document$2.createElement(it) : {};
};

var _ie8DomDefine = !_descriptors && !_fails(function () {
  return Object.defineProperty(_domCreate('div'), 'a', {
    get: function () {
      return 7;
    }
  }).a != 7;
});

// 7.1.1 ToPrimitive(input [, PreferredType])
 // instead of the ES6 spec version, we didn't implement @@toPrimitive case
// and the second argument - flag - preferred type is a string


var _toPrimitive = function (it, S) {
  if (!_isObject(it)) return it;
  var fn, val;
  if (S && typeof (fn = it.toString) == 'function' && !_isObject(val = fn.call(it))) return val;
  if (typeof (fn = it.valueOf) == 'function' && !_isObject(val = fn.call(it))) return val;
  if (!S && typeof (fn = it.toString) == 'function' && !_isObject(val = fn.call(it))) return val;
  throw TypeError("Can't convert object to primitive value");
};

var dP$1 = Object.defineProperty;
var f$4 = _descriptors ? Object.defineProperty : function defineProperty(O, P, Attributes) {
  _anObject(O);
  P = _toPrimitive(P, true);
  _anObject(Attributes);
  if (_ie8DomDefine) try {
    return dP$1(O, P, Attributes);
  } catch (e) {
    /* empty */
  }
  if ('get' in Attributes || 'set' in Attributes) throw TypeError('Accessors not supported!');
  if ('value' in Attributes) O[P] = Attributes.value;
  return O;
};

var _objectDp = {
	f: f$4
};

var _propertyDesc = function (bitmap, value) {
  return {
    enumerable: !(bitmap & 1),
    configurable: !(bitmap & 2),
    writable: !(bitmap & 4),
    value: value
  };
};

var _hide = _descriptors ? function (object, key, value) {
  return _objectDp.f(object, key, _propertyDesc(1, value));
} : function (object, key, value) {
  object[key] = value;
  return object;
};

var hasOwnProperty = {}.hasOwnProperty;

var _has = function (it, key) {
  return hasOwnProperty.call(it, key);
};

var id = 0;
var px = Math.random();

var _uid = function (key) {
  return 'Symbol('.concat(key === undefined ? '' : key, ')_', (++id + px).toString(36));
};

var _shared = createCommonjsModule(function (module) {
var SHARED = '__core-js_shared__';
var store = _global[SHARED] || (_global[SHARED] = {});
(module.exports = function (key, value) {
  return store[key] || (store[key] = value !== undefined ? value : {});
})('versions', []).push({
  version: _core.version,
  mode: 'global',
  copyright: '© 2019 Denis Pushkarev (zloirock.ru)'
});
});

var _functionToString = _shared('native-function-to-string', Function.toString);

var _redefine = createCommonjsModule(function (module) {
var SRC = _uid('src');



var TO_STRING = 'toString';
var TPL = ('' + _functionToString).split(TO_STRING);

_core.inspectSource = function (it) {
  return _functionToString.call(it);
};

(module.exports = function (O, key, val, safe) {
  var isFunction = typeof val == 'function';
  if (isFunction) _has(val, 'name') || _hide(val, 'name', key);
  if (O[key] === val) return;
  if (isFunction) _has(val, SRC) || _hide(val, SRC, O[key] ? '' + O[key] : TPL.join(String(key)));

  if (O === _global) {
    O[key] = val;
  } else if (!safe) {
    delete O[key];
    _hide(O, key, val);
  } else if (O[key]) {
    O[key] = val;
  } else {
    _hide(O, key, val);
  } // add fake Function#toString for correct work wrapped methods / constructors with methods like LoDash isNative

})(Function.prototype, TO_STRING, function toString() {
  return typeof this == 'function' && this[SRC] || _functionToString.call(this);
});
});

var _aFunction = function (it) {
  if (typeof it != 'function') throw TypeError(it + ' is not a function!');
  return it;
};

// optional / simple context binding


var _ctx = function (fn, that, length) {
  _aFunction(fn);
  if (that === undefined) return fn;

  switch (length) {
    case 1:
      return function (a) {
        return fn.call(that, a);
      };

    case 2:
      return function (a, b) {
        return fn.call(that, a, b);
      };

    case 3:
      return function (a, b, c) {
        return fn.call(that, a, b, c);
      };
  }

  return function ()
  /* ...args */
  {
    return fn.apply(that, arguments);
  };
};

var PROTOTYPE$1 = 'prototype';

var $export = function (type, name, source) {
  var IS_FORCED = type & $export.F;
  var IS_GLOBAL = type & $export.G;
  var IS_STATIC = type & $export.S;
  var IS_PROTO = type & $export.P;
  var IS_BIND = type & $export.B;
  var target = IS_GLOBAL ? _global : IS_STATIC ? _global[name] || (_global[name] = {}) : (_global[name] || {})[PROTOTYPE$1];
  var exports = IS_GLOBAL ? _core : _core[name] || (_core[name] = {});
  var expProto = exports[PROTOTYPE$1] || (exports[PROTOTYPE$1] = {});
  var key, own, out, exp;
  if (IS_GLOBAL) source = name;

  for (key in source) {
    // contains in native
    own = !IS_FORCED && target && target[key] !== undefined; // export native or passed

    out = (own ? target : source)[key]; // bind timers to global for call from export context

    exp = IS_BIND && own ? _ctx(out, _global) : IS_PROTO && typeof out == 'function' ? _ctx(Function.call, out) : out; // extend global

    if (target) _redefine(target, key, out, type & $export.U); // export

    if (exports[key] != out) _hide(exports, key, exp);
    if (IS_PROTO && expProto[key] != out) expProto[key] = out;
  }
};

_global.core = _core; // type bitmap

$export.F = 1; // forced

$export.G = 2; // global

$export.S = 4; // static

$export.P = 8; // proto

$export.B = 16; // bind

$export.W = 32; // wrap

$export.U = 64; // safe

$export.R = 128; // real proto method for `library`

var _export = $export;

var toString = {}.toString;

var _cof = function (it) {
  return toString.call(it).slice(8, -1);
};

// fallback for non-array-like ES3 and non-enumerable old V8 strings
 // eslint-disable-next-line no-prototype-builtins


var _iobject = Object('z').propertyIsEnumerable(0) ? Object : function (it) {
  return _cof(it) == 'String' ? it.split('') : Object(it);
};

// 7.2.1 RequireObjectCoercible(argument)
var _defined = function (it) {
  if (it == undefined) throw TypeError("Can't call method on  " + it);
  return it;
};

// 7.1.13 ToObject(argument)


var _toObject = function (it) {
  return Object(_defined(it));
};

// 7.1.4 ToInteger
var ceil = Math.ceil;
var floor = Math.floor;

var _toInteger = function (it) {
  return isNaN(it = +it) ? 0 : (it > 0 ? floor : ceil)(it);
};

// 7.1.15 ToLength


var min$1 = Math.min;

var _toLength = function (it) {
  return it > 0 ? min$1(_toInteger(it), 0x1fffffffffffff) : 0; // pow(2, 53) - 1 == 9007199254740991
};

// 7.2.2 IsArray(argument)


var _isArray = Array.isArray || function isArray(arg) {
  return _cof(arg) == 'Array';
};

var _wks = createCommonjsModule(function (module) {
var store = _shared('wks');



var Symbol = _global.Symbol;

var USE_SYMBOL = typeof Symbol == 'function';

var $exports = module.exports = function (name) {
  return store[name] || (store[name] = USE_SYMBOL && Symbol[name] || (USE_SYMBOL ? Symbol : _uid)('Symbol.' + name));
};

$exports.store = store;
});

var SPECIES$2 = _wks('species');

var _arraySpeciesConstructor = function (original) {
  var C;

  if (_isArray(original)) {
    C = original.constructor; // cross-realm fallback

    if (typeof C == 'function' && (C === Array || _isArray(C.prototype))) C = undefined;

    if (_isObject(C)) {
      C = C[SPECIES$2];
      if (C === null) C = undefined;
    }
  }

  return C === undefined ? Array : C;
};

// 9.4.2.3 ArraySpeciesCreate(originalArray, length)


var _arraySpeciesCreate = function (original, length) {
  return new (_arraySpeciesConstructor(original))(length);
};

// 0 -> Array#forEach
// 1 -> Array#map
// 2 -> Array#filter
// 3 -> Array#some
// 4 -> Array#every
// 5 -> Array#find
// 6 -> Array#findIndex










var _arrayMethods = function (TYPE, $create) {
  var IS_MAP = TYPE == 1;
  var IS_FILTER = TYPE == 2;
  var IS_SOME = TYPE == 3;
  var IS_EVERY = TYPE == 4;
  var IS_FIND_INDEX = TYPE == 6;
  var NO_HOLES = TYPE == 5 || IS_FIND_INDEX;
  var create = $create || _arraySpeciesCreate;
  return function ($this, callbackfn, that) {
    var O = _toObject($this);
    var self = _iobject(O);
    var f = _ctx(callbackfn, that, 3);
    var length = _toLength(self.length);
    var index = 0;
    var result = IS_MAP ? create($this, length) : IS_FILTER ? create($this, 0) : undefined;
    var val, res;

    for (; length > index; index++) if (NO_HOLES || index in self) {
      val = self[index];
      res = f(val, index, O);

      if (TYPE) {
        if (IS_MAP) result[index] = res; // map
        else if (res) switch (TYPE) {
            case 3:
              return true;
            // some

            case 5:
              return val;
            // find

            case 6:
              return index;
            // findIndex

            case 2:
              result.push(val);
            // filter
          } else if (IS_EVERY) return false; // every
      }
    }

    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : result;
  };
};

// 22.1.3.31 Array.prototype[@@unscopables]
var UNSCOPABLES = _wks('unscopables');

var ArrayProto$1 = Array.prototype;
if (ArrayProto$1[UNSCOPABLES] == undefined) _hide(ArrayProto$1, UNSCOPABLES, {});

var _addToUnscopables = function (key) {
  ArrayProto$1[UNSCOPABLES][key] = true;
};

var $find$1 = _arrayMethods(5);

var KEY$1 = 'find';
var forced$1 = true; // Shouldn't skip holes

if (KEY$1 in []) Array(1)[KEY$1](function () {
  forced$1 = false;
});
_export(_export.P + _export.F * forced$1, 'Array', {
  find: function find(callbackfn
  /* , that = undefined */
  ) {
    return $find$1(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});

_addToUnscopables(KEY$1);

_core.Array.find;

var $find = _arrayMethods(6);

var KEY = 'findIndex';
var forced = true; // Shouldn't skip holes

if (KEY in []) Array(1)[KEY](function () {
  forced = false;
});
_export(_export.P + _export.F * forced, 'Array', {
  findIndex: function findIndex(callbackfn
  /* , that = undefined */
  ) {
    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});

_addToUnscopables(KEY);

_core.Array.findIndex;

// true  -> String#at
// false -> String#codePointAt


var _stringAt = function (TO_STRING) {
  return function (that, pos) {
    var s = String(_defined(that));
    var i = _toInteger(pos);
    var l = s.length;
    var a, b;
    if (i < 0 || i >= l) return TO_STRING ? '' : undefined;
    a = s.charCodeAt(i);
    return a < 0xd800 || a > 0xdbff || i + 1 === l || (b = s.charCodeAt(i + 1)) < 0xdc00 || b > 0xdfff ? TO_STRING ? s.charAt(i) : a : TO_STRING ? s.slice(i, i + 2) : (a - 0xd800 << 10) + (b - 0xdc00) + 0x10000;
  };
};

var _iterators = {};

// to indexed object, toObject with fallback for non-array-like ES3 strings




var _toIobject = function (it) {
  return _iobject(_defined(it));
};

var max = Math.max;
var min = Math.min;

var _toAbsoluteIndex = function (index, length) {
  index = _toInteger(index);
  return index < 0 ? max(index + length, 0) : min(index, length);
};

// false -> Array#indexOf
// true  -> Array#includes






var _arrayIncludes = function (IS_INCLUDES) {
  return function ($this, el, fromIndex) {
    var O = _toIobject($this);
    var length = _toLength(O.length);
    var index = _toAbsoluteIndex(fromIndex, length);
    var value; // Array#includes uses SameValueZero equality algorithm
    // eslint-disable-next-line no-self-compare

    if (IS_INCLUDES && el != el) while (length > index) {
      value = O[index++]; // eslint-disable-next-line no-self-compare

      if (value != value) return true; // Array#indexOf ignores holes, Array#includes - not
    } else for (; length > index; index++) if (IS_INCLUDES || index in O) {
      if (O[index] === el) return IS_INCLUDES || index || 0;
    }
    return !IS_INCLUDES && -1;
  };
};

var shared = _shared('keys');



var _sharedKey = function (key) {
  return shared[key] || (shared[key] = _uid(key));
};

var arrayIndexOf = _arrayIncludes(false);

var IE_PROTO$2 = _sharedKey('IE_PROTO');

var _objectKeysInternal = function (object, names) {
  var O = _toIobject(object);
  var i = 0;
  var result = [];
  var key;

  for (key in O) if (key != IE_PROTO$2) _has(O, key) && result.push(key); // Don't enum bug & hidden keys


  while (names.length > i) if (_has(O, key = names[i++])) {
    ~arrayIndexOf(result, key) || result.push(key);
  }

  return result;
};

// IE 8- don't enum bug keys
var _enumBugKeys = 'constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,toLocaleString,toString,valueOf'.split(',');

// 19.1.2.14 / 15.2.3.14 Object.keys(O)




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

var document$1 = _global.document;

var _html = document$1 && document$1.documentElement;

// 19.1.2.2 / 15.2.3.5 Object.create(O [, Properties])






var IE_PROTO$1 = _sharedKey('IE_PROTO');

var Empty = function () {
  /* empty */
};

var PROTOTYPE = 'prototype'; // Create object with fake `null` prototype: use iframe Object with cleared prototype

var createDict = function () {
  // Thrash, waste and sodomy: IE GC bug
  var iframe = _domCreate('iframe');

  var i = _enumBugKeys.length;
  var lt = '<';
  var gt = '>';
  var iframeDocument;
  iframe.style.display = 'none';

  _html.appendChild(iframe);

  iframe.src = 'javascript:'; // eslint-disable-line no-script-url
  // createDict = iframe.contentWindow.Object;
  // html.removeChild(iframe);

  iframeDocument = iframe.contentWindow.document;
  iframeDocument.open();
  iframeDocument.write(lt + 'script' + gt + 'document.F=Object' + lt + '/script' + gt);
  iframeDocument.close();
  createDict = iframeDocument.F;

  while (i--) delete createDict[PROTOTYPE][_enumBugKeys[i]];

  return createDict();
};

var _objectCreate = Object.create || function create(O, Properties) {
  var result;

  if (O !== null) {
    Empty[PROTOTYPE] = _anObject(O);
    result = new Empty();
    Empty[PROTOTYPE] = null; // add "__proto__" for Object.getPrototypeOf polyfill

    result[IE_PROTO$1] = O;
  } else result = createDict();

  return Properties === undefined ? result : _objectDps(result, Properties);
};

var def = _objectDp.f;



var TAG$1 = _wks('toStringTag');

var _setToStringTag = function (it, tag, stat) {
  if (it && !_has(it = stat ? it : it.prototype, TAG$1)) def(it, TAG$1, {
    configurable: true,
    value: tag
  });
};

var IteratorPrototype = {}; // 25.1.2.1.1 %IteratorPrototype%[@@iterator]()

_hide(IteratorPrototype, _wks('iterator'), function () {
  return this;
});

var _iterCreate = function (Constructor, NAME, next) {
  Constructor.prototype = _objectCreate(IteratorPrototype, {
    next: _propertyDesc(1, next)
  });
  _setToStringTag(Constructor, NAME + ' Iterator');
};

// 19.1.2.9 / 15.2.3.2 Object.getPrototypeOf(O)




var IE_PROTO = _sharedKey('IE_PROTO');

var ObjectProto = Object.prototype;

var _objectGpo = Object.getPrototypeOf || function (O) {
  O = _toObject(O);
  if (_has(O, IE_PROTO)) return O[IE_PROTO];

  if (typeof O.constructor == 'function' && O instanceof O.constructor) {
    return O.constructor.prototype;
  }

  return O instanceof Object ? ObjectProto : null;
};

var ITERATOR$4 = _wks('iterator');

var BUGGY = !([].keys && 'next' in [].keys()); // Safari has buggy iterators w/o `next`

var FF_ITERATOR = '@@iterator';
var KEYS = 'keys';
var VALUES = 'values';

var returnThis = function () {
  return this;
};

var _iterDefine = function (Base, NAME, Constructor, next, DEFAULT, IS_SET, FORCED) {
  _iterCreate(Constructor, NAME, next);

  var getMethod = function (kind) {
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

  var TAG = NAME + ' Iterator';
  var DEF_VALUES = DEFAULT == VALUES;
  var VALUES_BUG = false;
  var proto = Base.prototype;
  var $native = proto[ITERATOR$4] || proto[FF_ITERATOR] || DEFAULT && proto[DEFAULT];
  var $default = $native || getMethod(DEFAULT);
  var $entries = DEFAULT ? !DEF_VALUES ? $default : getMethod('entries') : undefined;
  var $anyNative = NAME == 'Array' ? proto.entries || $native : $native;
  var methods, key, IteratorPrototype; // Fix native

  if ($anyNative) {
    IteratorPrototype = _objectGpo($anyNative.call(new Base()));

    if (IteratorPrototype !== Object.prototype && IteratorPrototype.next) {
      // Set @@toStringTag to native iterators
      _setToStringTag(IteratorPrototype, TAG, true); // fix for some old engines

      if (typeof IteratorPrototype[ITERATOR$4] != 'function') _hide(IteratorPrototype, ITERATOR$4, returnThis);
    }
  } // fix Array#{values, @@iterator}.name in V8 / FF


  if (DEF_VALUES && $native && $native.name !== VALUES) {
    VALUES_BUG = true;

    $default = function values() {
      return $native.call(this);
    };
  } // Define iterator


  if ((BUGGY || VALUES_BUG || !proto[ITERATOR$4])) {
    _hide(proto, ITERATOR$4, $default);
  } // Plug for library


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

var $at = _stringAt(true); // 21.1.3.27 String.prototype[@@iterator]()


_iterDefine(String, 'String', function (iterated) {
  this._t = String(iterated); // target

  this._i = 0; // next index
  // 21.1.5.2.1 %StringIteratorPrototype%.next()
}, function () {
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

// call something on iterator step with safe closing on error


var _iterCall = function (iterator, fn, value, entries) {
  try {
    return entries ? fn(_anObject(value)[0], value[1]) : fn(value); // 7.4.6 IteratorClose(iterator, completion)
  } catch (e) {
    var ret = iterator['return'];
    if (ret !== undefined) _anObject(ret.call(iterator));
    throw e;
  }
};

// check on default Array iterator


var ITERATOR$3 = _wks('iterator');

var ArrayProto = Array.prototype;

var _isArrayIter = function (it) {
  return it !== undefined && (_iterators.Array === it || ArrayProto[ITERATOR$3] === it);
};

var _createProperty = function (object, index, value) {
  if (index in object) _objectDp.f(object, index, _propertyDesc(0, value));else object[index] = value;
};

// getting tag from 19.1.3.6 Object.prototype.toString()


var TAG = _wks('toStringTag'); // ES3 wrong here


var ARG = _cof(function () {
  return arguments;
}()) == 'Arguments'; // fallback for IE11 Script Access Denied error

var tryGet = function (it, key) {
  try {
    return it[key];
  } catch (e) {
    /* empty */
  }
};

var _classof = function (it) {
  var O, T, B;
  return it === undefined ? 'Undefined' : it === null ? 'Null' // @@toStringTag case
  : typeof (T = tryGet(O = Object(it), TAG)) == 'string' ? T // builtinTag case
  : ARG ? _cof(O) // ES3 arguments fallback
  : (B = _cof(O)) == 'Object' && typeof O.callee == 'function' ? 'Arguments' : B;
};

var ITERATOR$2 = _wks('iterator');



var core_getIteratorMethod = _core.getIteratorMethod = function (it) {
  if (it != undefined) return it[ITERATOR$2] || it['@@iterator'] || _iterators[_classof(it)];
};

var ITERATOR$1 = _wks('iterator');

var SAFE_CLOSING = false;

try {
  var riter = [7][ITERATOR$1]();

  riter['return'] = function () {
    SAFE_CLOSING = true;
  }; // eslint-disable-next-line no-throw-literal


  Array.from(riter, function () {
    throw 2;
  });
} catch (e) {
  /* empty */
}

var _iterDetect = function (exec, skipClosing) {
  if (!skipClosing && !SAFE_CLOSING) return false;
  var safe = false;

  try {
    var arr = [7];
    var iter = arr[ITERATOR$1]();

    iter.next = function () {
      return {
        done: safe = true
      };
    };

    arr[ITERATOR$1] = function () {
      return iter;
    };

    exec(arr);
  } catch (e) {
    /* empty */
  }

  return safe;
};

_export(_export.S + _export.F * !_iterDetect(function (iter) {
  Array.from(iter);
}), 'Array', {
  // 22.1.2.1 Array.from(arrayLike, mapfn = undefined, thisArg = undefined)
  from: function from(arrayLike
  /* , mapfn = undefined, thisArg = undefined */
  ) {
    var O = _toObject(arrayLike);
    var C = typeof this == 'function' ? this : Array;
    var aLen = arguments.length;
    var mapfn = aLen > 1 ? arguments[1] : undefined;
    var mapping = mapfn !== undefined;
    var index = 0;
    var iterFn = core_getIteratorMethod(O);
    var length, result, step, iterator;
    if (mapping) mapfn = _ctx(mapfn, aLen > 2 ? arguments[2] : undefined, 2); // if object isn't iterable or it's array with default iterator - use simple case

    if (iterFn != undefined && !(C == Array && _isArrayIter(iterFn))) {
      for (iterator = iterFn.call(O), result = new C(); !(step = iterator.next()).done; index++) {
        _createProperty(result, index, mapping ? _iterCall(iterator, mapfn, [step.value, index], true) : step.value);
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

_core.Array.from;

var test = {};
test[_wks('toStringTag')] = 'z';

if (test + '' != '[object z]') {
  _redefine(Object.prototype, 'toString', function toString() {
    return '[object ' + _classof(this) + ']';
  }, true);
}

var _iterStep = function (done, value) {
  return {
    value: value,
    done: !!done
  };
};

// 22.1.3.4 Array.prototype.entries()
// 22.1.3.13 Array.prototype.keys()
// 22.1.3.29 Array.prototype.values()
// 22.1.3.30 Array.prototype[@@iterator]()


var es6_array_iterator = _iterDefine(Array, 'Array', function (iterated, kind) {
  this._t = _toIobject(iterated); // target

  this._i = 0; // next index

  this._k = kind; // kind
  // 22.1.5.2.1 %ArrayIteratorPrototype%.next()
}, function () {
  var O = this._t;
  var kind = this._k;
  var index = this._i++;

  if (!O || index >= O.length) {
    this._t = undefined;
    return _iterStep(1);
  }

  if (kind == 'keys') return _iterStep(0, index);
  if (kind == 'values') return _iterStep(0, O[index]);
  return _iterStep(0, [index, O[index]]);
}, 'values'); // argumentsList[@@iterator] is %ArrayProto_values% (9.4.4.6, 9.4.4.7)

_iterators.Arguments = _iterators.Array;
_addToUnscopables('keys');
_addToUnscopables('values');
_addToUnscopables('entries');

var ITERATOR = _wks('iterator');
var TO_STRING_TAG = _wks('toStringTag');
var ArrayValues = _iterators.Array;
var DOMIterables = {
  CSSRuleList: true,
  // TODO: Not spec compliant, should be false.
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
  // TODO: Not spec compliant, should be false.
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
  // TODO: Not spec compliant, should be false.
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
    if (!proto[ITERATOR]) _hide(proto, ITERATOR, ArrayValues);
    if (!proto[TO_STRING_TAG]) _hide(proto, TO_STRING_TAG, NAME);
    _iterators[NAME] = ArrayValues;
    if (explicit) for (key in es6_array_iterator) if (!proto[key]) _redefine(proto, key, es6_array_iterator[key], true);
  }
}

var _redefineAll = function (target, src, safe) {
  for (var key in src) _redefine(target, key, src[key], safe);

  return target;
};

var _anInstance = function (it, Constructor, name, forbiddenField) {
  if (!(it instanceof Constructor) || forbiddenField !== undefined && forbiddenField in it) {
    throw TypeError(name + ': incorrect invocation!');
  }

  return it;
};

var _forOf = createCommonjsModule(function (module) {
var BREAK = {};
var RETURN = {};

var exports = module.exports = function (iterable, entries, fn, that, ITERATOR) {
  var iterFn = ITERATOR ? function () {
    return iterable;
  } : core_getIteratorMethod(iterable);
  var f = _ctx(fn, that, entries ? 2 : 1);
  var index = 0;
  var length, step, iterator, result;
  if (typeof iterFn != 'function') throw TypeError(iterable + ' is not iterable!'); // fast case for arrays with default iterator

  if (_isArrayIter(iterFn)) for (length = _toLength(iterable.length); length > index; index++) {
    result = entries ? f(_anObject(step = iterable[index])[0], step[1]) : f(iterable[index]);
    if (result === BREAK || result === RETURN) return result;
  } else for (iterator = iterFn.call(iterable); !(step = iterator.next()).done;) {
    result = _iterCall(iterator, f, step.value, entries);
    if (result === BREAK || result === RETURN) return result;
  }
};

exports.BREAK = BREAK;
exports.RETURN = RETURN;
});

var SPECIES$1 = _wks('species');

var _setSpecies = function (KEY) {
  var C = _global[KEY];
  if (_descriptors && C && !C[SPECIES$1]) _objectDp.f(C, SPECIES$1, {
    configurable: true,
    get: function () {
      return this;
    }
  });
};

var _meta = createCommonjsModule(function (module) {
var META = _uid('meta');





var setDesc = _objectDp.f;

var id = 0;

var isExtensible = Object.isExtensible || function () {
  return true;
};

var FREEZE = !_fails(function () {
  return isExtensible(Object.preventExtensions({}));
});

var setMeta = function (it) {
  setDesc(it, META, {
    value: {
      i: 'O' + ++id,
      // object ID
      w: {} // weak collections IDs

    }
  });
};

var fastKey = function (it, create) {
  // return primitive with prefix
  if (!_isObject(it)) return typeof it == 'symbol' ? it : (typeof it == 'string' ? 'S' : 'P') + it;

  if (!_has(it, META)) {
    // can't set metadata to uncaught frozen object
    if (!isExtensible(it)) return 'F'; // not necessary to add metadata

    if (!create) return 'E'; // add missing metadata

    setMeta(it); // return object ID
  }

  return it[META].i;
};

var getWeak = function (it, create) {
  if (!_has(it, META)) {
    // can't set metadata to uncaught frozen object
    if (!isExtensible(it)) return true; // not necessary to add metadata

    if (!create) return false; // add missing metadata

    setMeta(it); // return hash weak collections IDs
  }

  return it[META].w;
}; // add metadata on freeze-family methods calling


var onFreeze = function (it) {
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

var _validateCollection = function (it, TYPE) {
  if (!_isObject(it) || it._t !== TYPE) throw TypeError('Incompatible receiver, ' + TYPE + ' required!');
  return it;
};

var dP = _objectDp.f;



















var fastKey = _meta.fastKey;



var SIZE = _descriptors ? '_s' : 'size';

var getEntry = function (that, key) {
  // fast case
  var index = fastKey(key);
  var entry;
  if (index !== 'F') return that._i[index]; // frozen object case

  for (entry = that._f; entry; entry = entry.n) {
    if (entry.k == key) return entry;
  }
};

var _collectionStrong = {
  getConstructor: function (wrapper, NAME, IS_MAP, ADDER) {
    var C = wrapper(function (that, iterable) {
      _anInstance(that, C, NAME, '_i');
      that._t = NAME; // collection type

      that._i = _objectCreate(null); // index

      that._f = undefined; // first entry

      that._l = undefined; // last entry

      that[SIZE] = 0; // size

      if (iterable != undefined) _forOf(iterable, IS_MAP, that[ADDER], that);
    });
    _redefineAll(C.prototype, {
      // 23.1.3.1 Map.prototype.clear()
      // 23.2.3.2 Set.prototype.clear()
      clear: function clear() {
        for (var that = _validateCollection(this, NAME), data = that._i, entry = that._f; entry; entry = entry.n) {
          entry.r = true;
          if (entry.p) entry.p = entry.p.n = undefined;
          delete data[entry.i];
        }

        that._f = that._l = undefined;
        that[SIZE] = 0;
      },
      // 23.1.3.3 Map.prototype.delete(key)
      // 23.2.3.4 Set.prototype.delete(value)
      'delete': function (key) {
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
      // 23.2.3.6 Set.prototype.forEach(callbackfn, thisArg = undefined)
      // 23.1.3.5 Map.prototype.forEach(callbackfn, thisArg = undefined)
      forEach: function forEach(callbackfn
      /* , that = undefined */
      ) {
        _validateCollection(this, NAME);
        var f = _ctx(callbackfn, arguments.length > 1 ? arguments[1] : undefined, 3);
        var entry;

        while (entry = entry ? entry.n : this._f) {
          f(entry.v, entry.k, this); // revert to the last existing entry

          while (entry && entry.r) entry = entry.p;
        }
      },
      // 23.1.3.7 Map.prototype.has(key)
      // 23.2.3.7 Set.prototype.has(value)
      has: function has(key) {
        return !!getEntry(_validateCollection(this, NAME), key);
      }
    });
    if (_descriptors) dP(C.prototype, 'size', {
      get: function () {
        return _validateCollection(this, NAME)[SIZE];
      }
    });
    return C;
  },
  def: function (that, key, value) {
    var entry = getEntry(that, key);
    var prev, index; // change existing entry

    if (entry) {
      entry.v = value; // create new entry
    } else {
      that._l = entry = {
        i: index = fastKey(key, true),
        // <- index
        k: key,
        // <- key
        v: value,
        // <- value
        p: prev = that._l,
        // <- previous entry
        n: undefined,
        // <- next entry
        r: false // <- removed

      };
      if (!that._f) that._f = entry;
      if (prev) prev.n = entry;
      that[SIZE]++; // add to index

      if (index !== 'F') that._i[index] = entry;
    }

    return that;
  },
  getEntry: getEntry,
  setStrong: function (C, NAME, IS_MAP) {
    // add .keys, .values, .entries, [@@iterator]
    // 23.1.3.4, 23.1.3.8, 23.1.3.11, 23.1.3.12, 23.2.3.5, 23.2.3.8, 23.2.3.10, 23.2.3.11
    _iterDefine(C, NAME, function (iterated, kind) {
      this._t = _validateCollection(iterated, NAME); // target

      this._k = kind; // kind

      this._l = undefined; // previous
    }, function () {
      var that = this;
      var kind = that._k;
      var entry = that._l; // revert to the last existing entry

      while (entry && entry.r) entry = entry.p; // get next entry


      if (!that._t || !(that._l = entry = entry ? entry.n : that._t._f)) {
        // or finish the iteration
        that._t = undefined;
        return _iterStep(1);
      } // return step by kind


      if (kind == 'keys') return _iterStep(0, entry.k);
      if (kind == 'values') return _iterStep(0, entry.v);
      return _iterStep(0, [entry.k, entry.v]);
    }, IS_MAP ? 'entries' : 'values', !IS_MAP, true); // add [@@species], 23.1.2.2, 23.2.2.2

    _setSpecies(NAME);
  }
};

var f$3 = {}.propertyIsEnumerable;

var _objectPie = {
	f: f$3
};

var gOPD = Object.getOwnPropertyDescriptor;
var f$2 = _descriptors ? gOPD : function getOwnPropertyDescriptor(O, P) {
  O = _toIobject(O);
  P = _toPrimitive(P, true);
  if (_ie8DomDefine) try {
    return gOPD(O, P);
  } catch (e) {
    /* empty */
  }
  if (_has(O, P)) return _propertyDesc(!_objectPie.f.call(O, P), O[P]);
};

var _objectGopd = {
	f: f$2
};

// Works with __proto__ only. Old v8 can't work with null proto objects.

/* eslint-disable no-proto */




var check = function (O, proto) {
  _anObject(O);
  if (!_isObject(proto) && proto !== null) throw TypeError(proto + ": can't set as prototype!");
};

var _setProto = {
  set: Object.setPrototypeOf || ('__proto__' in {} ? // eslint-disable-line
  function (test, buggy, set) {
    try {
      set = _ctx(Function.call, _objectGopd.f(Object.prototype, '__proto__').set, 2);
      set(test, []);
      buggy = !(test instanceof Array);
    } catch (e) {
      buggy = true;
    }

    return function setPrototypeOf(O, proto) {
      check(O, proto);
      if (buggy) O.__proto__ = proto;else set(O, proto);
      return O;
    };
  }({}, false) : undefined),
  check: check
};

var setPrototypeOf = _setProto.set;

var _inheritIfRequired = function (that, target, C) {
  var S = target.constructor;
  var P;

  if (S !== C && typeof S == 'function' && (P = S.prototype) !== C.prototype && _isObject(P) && setPrototypeOf) {
    setPrototypeOf(that, P);
  }

  return that;
};

var _collection = function (NAME, wrapper, methods, common, IS_MAP, IS_WEAK) {
  var Base = _global[NAME];
  var C = Base;
  var ADDER = IS_MAP ? 'set' : 'add';
  var proto = C && C.prototype;
  var O = {};

  var fixMethod = function (KEY) {
    var fn = proto[KEY];
    _redefine(proto, KEY, KEY == 'delete' ? function (a) {
      return IS_WEAK && !_isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
    } : KEY == 'has' ? function has(a) {
      return IS_WEAK && !_isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
    } : KEY == 'get' ? function get(a) {
      return IS_WEAK && !_isObject(a) ? undefined : fn.call(this, a === 0 ? 0 : a);
    } : KEY == 'add' ? function add(a) {
      fn.call(this, a === 0 ? 0 : a);
      return this;
    } : function set(a, b) {
      fn.call(this, a === 0 ? 0 : a, b);
      return this;
    });
  };

  if (typeof C != 'function' || !(IS_WEAK || proto.forEach && !_fails(function () {
    new C().entries().next();
  }))) {
    // create collection constructor
    C = common.getConstructor(wrapper, NAME, IS_MAP, ADDER);
    _redefineAll(C.prototype, methods);
    _meta.NEED = true;
  } else {
    var instance = new C(); // early implementations not supports chaining

    var HASNT_CHAINING = instance[ADDER](IS_WEAK ? {} : -0, 1) != instance; // V8 ~  Chromium 40- weak-collections throws on primitives, but should return false

    var THROWS_ON_PRIMITIVES = _fails(function () {
      instance.has(1);
    }); // most early implementations doesn't supports iterables, most modern - not close it correctly

    var ACCEPT_ITERABLES = _iterDetect(function (iter) {
      new C(iter);
    }); // eslint-disable-line no-new
    // for early implementations -0 and +0 not the same

    var BUGGY_ZERO = !IS_WEAK && _fails(function () {
      // V8 ~ Chromium 42- fails only with 5+ elements
      var $instance = new C();
      var index = 5;

      while (index--) $instance[ADDER](index, index);

      return !$instance.has(-0);
    });

    if (!ACCEPT_ITERABLES) {
      C = wrapper(function (target, iterable) {
        _anInstance(target, C, NAME);
        var that = _inheritIfRequired(new Base(), target, C);
        if (iterable != undefined) _forOf(iterable, IS_MAP, that[ADDER], that);
        return that;
      });
      C.prototype = proto;
      proto.constructor = C;
    }

    if (THROWS_ON_PRIMITIVES || BUGGY_ZERO) {
      fixMethod('delete');
      fixMethod('has');
      IS_MAP && fixMethod('get');
    }

    if (BUGGY_ZERO || HASNT_CHAINING) fixMethod(ADDER); // weak collections should not contains .clear method

    if (IS_WEAK && proto.clear) delete proto.clear;
  }

  _setToStringTag(C, NAME);
  O[NAME] = C;
  _export(_export.G + _export.W + _export.F * (C != Base), O);
  if (!IS_WEAK) common.setStrong(C, NAME, IS_MAP);
  return C;
};

var MAP = 'Map'; // 23.1 Map Objects

_collection(MAP, function (get) {
  return function Map() {
    return get(this, arguments.length > 0 ? arguments[0] : undefined);
  };
}, {
  // 23.1.3.6 Map.prototype.get(key)
  get: function get(key) {
    var entry = _collectionStrong.getEntry(_validateCollection(this, MAP), key);
    return entry && entry.v;
  },
  // 23.1.3.9 Map.prototype.set(key, value)
  set: function set(key, value) {
    return _collectionStrong.def(_validateCollection(this, MAP), key === 0 ? 0 : key, value);
  }
}, _collectionStrong, true);

var _arrayFromIterable = function (iter, ITERATOR) {
  var result = [];
  _forOf(iter, false, result.push, result, ITERATOR);
  return result;
};

// https://github.com/DavidBruant/Map-Set.prototype.toJSON




var _collectionToJson = function (NAME) {
  return function toJSON() {
    if (_classof(this) != NAME) throw TypeError(NAME + "#toJSON isn't generic");
    return _arrayFromIterable(this);
  };
};

// https://github.com/DavidBruant/Map-Set.prototype.toJSON


_export(_export.P + _export.R, 'Map', {
  toJSON: _collectionToJson('Map')
});

var _setCollectionOf = function (COLLECTION) {
  _export(_export.S, COLLECTION, {
    of: function of() {
      var length = arguments.length;
      var A = new Array(length);

      while (length--) A[length] = arguments[length];

      return new this(A);
    }
  });
};

// https://tc39.github.io/proposal-setmap-offrom/#sec-map.of
_setCollectionOf('Map');

var _setCollectionFrom = function (COLLECTION) {
  _export(_export.S, COLLECTION, {
    from: function from(source
    /* , mapFn, thisArg */
    ) {
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
        _forOf(source, false, function (nextItem) {
          A.push(cb(nextItem, n++));
        });
      } else {
        _forOf(source, false, A.push, A);
      }

      return new this(A);
    }
  });
};

// https://tc39.github.io/proposal-setmap-offrom/#sec-map.from
_setCollectionFrom('Map');

_core.Map;

var f$1 = Object.getOwnPropertySymbols;

var _objectGops = {
	f: f$1
};

var $assign = Object.assign; // should work with symbols and should have deterministic property order (V8 bug)

var _objectAssign = !$assign || _fails(function () {
  var A = {};
  var B = {}; // eslint-disable-next-line no-undef

  var S = Symbol();
  var K = 'abcdefghijklmnopqrst';
  A[S] = 7;
  K.split('').forEach(function (k) {
    B[k] = k;
  });
  return $assign({}, A)[S] != 7 || Object.keys($assign({}, B)).join('') != K;
}) ? function assign(target, source) {
  // eslint-disable-line no-unused-vars
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

// 19.1.3.1 Object.assign(target, source)


_export(_export.S + _export.F, 'Object', {
  assign: _objectAssign
});

_core.Object.assign;

// 7.3.20 SpeciesConstructor(O, defaultConstructor)




var SPECIES = _wks('species');

var _speciesConstructor = function (O, D) {
  var C = _anObject(O).constructor;
  var S;
  return C === undefined || (S = _anObject(C)[SPECIES]) == undefined ? D : _aFunction(S);
};

// fast apply, http://jsperf.lnkit.com/fast-apply/5
var _invoke = function (fn, args, that) {
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

var process$2 = _global.process;
var setTask = _global.setImmediate;
var clearTask = _global.clearImmediate;
var MessageChannel = _global.MessageChannel;
var Dispatch = _global.Dispatch;
var counter = 0;
var queue = {};
var ONREADYSTATECHANGE = 'onreadystatechange';
var defer, channel, port;

var run = function () {
  var id = +this; // eslint-disable-next-line no-prototype-builtins

  if (queue.hasOwnProperty(id)) {
    var fn = queue[id];
    delete queue[id];
    fn();
  }
};

var listener = function (event) {
  run.call(event.data);
}; // Node.js 0.9+ & IE10+ has setImmediate, otherwise:


if (!setTask || !clearTask) {
  setTask = function setImmediate(fn) {
    var args = [];
    var i = 1;

    while (arguments.length > i) args.push(arguments[i++]);

    queue[++counter] = function () {
      // eslint-disable-next-line no-new-func
      _invoke(typeof fn == 'function' ? fn : Function(fn), args);
    };

    defer(counter);
    return counter;
  };

  clearTask = function clearImmediate(id) {
    delete queue[id];
  }; // Node.js 0.8-


  if (_cof(process$2) == 'process') {
    defer = function (id) {
      process$2.nextTick(_ctx(run, id, 1));
    }; // Sphere (JS game engine) Dispatch API

  } else if (Dispatch && Dispatch.now) {
    defer = function (id) {
      Dispatch.now(_ctx(run, id, 1));
    }; // Browsers with MessageChannel, includes WebWorkers

  } else if (MessageChannel) {
    channel = new MessageChannel();
    port = channel.port2;
    channel.port1.onmessage = listener;
    defer = _ctx(port.postMessage, port, 1); // Browsers with postMessage, skip WebWorkers
    // IE8 has postMessage, but it's sync & typeof its postMessage is 'object'
  } else if (_global.addEventListener && typeof postMessage == 'function' && !_global.importScripts) {
    defer = function (id) {
      _global.postMessage(id + '', '*');
    };

    _global.addEventListener('message', listener, false); // IE8-
  } else if (ONREADYSTATECHANGE in _domCreate('script')) {
    defer = function (id) {
      _html.appendChild(_domCreate('script'))[ONREADYSTATECHANGE] = function () {
        _html.removeChild(this);
        run.call(id);
      };
    }; // Rest old browsers

  } else {
    defer = function (id) {
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
var Promise$2 = _global.Promise;
var isNode$1 = _cof(process$1) == 'process';

var _microtask = function () {
  var head, last, notify;

  var flush = function () {
    var parent, fn;
    if (isNode$1 && (parent = process$1.domain)) parent.exit();

    while (head) {
      fn = head.fn;
      head = head.next;

      try {
        fn();
      } catch (e) {
        if (head) notify();else last = undefined;
        throw e;
      }
    }

    last = undefined;
    if (parent) parent.enter();
  }; // Node.js


  if (isNode$1) {
    notify = function () {
      process$1.nextTick(flush);
    }; // browsers with MutationObserver, except iOS Safari - https://github.com/zloirock/core-js/issues/339

  } else if (Observer && !(_global.navigator && _global.navigator.standalone)) {
    var toggle = true;
    var node = document.createTextNode('');
    new Observer(flush).observe(node, {
      characterData: true
    }); // eslint-disable-line no-new

    notify = function () {
      node.data = toggle = !toggle;
    }; // environments with maybe non-completely correct, but existent Promise

  } else if (Promise$2 && Promise$2.resolve) {
    // Promise.resolve without an argument throws an error in LG WebOS 2
    var promise = Promise$2.resolve(undefined);

    notify = function () {
      promise.then(flush);
    }; // for other environments - macrotask based on:
    // - setImmediate
    // - MessageChannel
    // - window.postMessag
    // - onreadystatechange
    // - setTimeout

  } else {
    notify = function () {
      // strange IE + webpack dev server bug - use .call(global)
      macrotask.call(_global, flush);
    };
  }

  return function (fn) {
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
  this.promise = new C(function ($$resolve, $$reject) {
    if (resolve !== undefined || reject !== undefined) throw TypeError('Bad Promise constructor');
    resolve = $$resolve;
    reject = $$reject;
  });
  this.resolve = _aFunction(resolve);
  this.reject = _aFunction(reject);
}

var f = function (C) {
  return new PromiseCapability(C);
};

var _newPromiseCapability = {
	f: f
};

var _perform = function (exec) {
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

var navigator$2 = _global.navigator;
var _userAgent = navigator$2 && navigator$2.userAgent || '';

var _promiseResolve = function (C, x) {
  _anObject(C);
  if (_isObject(x) && x.constructor === C) return x;
  var promiseCapability = _newPromiseCapability.f(C);
  var resolve = promiseCapability.resolve;
  resolve(x);
  return promiseCapability.promise;
};

var task = _task.set;

var microtask = _microtask();









var PROMISE = 'Promise';
var TypeError$1 = _global.TypeError;
var process = _global.process;
var versions = process && process.versions;
var v8 = versions && versions.v8 || '';
var $Promise = _global[PROMISE];
var isNode = _classof(process) == 'process';

var empty = function () {
  /* empty */
};

var Internal, newGenericPromiseCapability, OwnPromiseCapability, Wrapper;
var newPromiseCapability = newGenericPromiseCapability = _newPromiseCapability.f;
var USE_NATIVE = !!function () {
  try {
    // correct subclassing with @@species support
    var promise = $Promise.resolve(1);

    var FakePromise = (promise.constructor = {})[_wks('species')] = function (exec) {
      exec(empty, empty);
    }; // unhandled rejections tracking support, NodeJS Promise without it fails @@species test


    return (isNode || typeof PromiseRejectionEvent == 'function') && promise.then(empty) instanceof FakePromise // v8 6.6 (Node 10 and Chrome 66) have a bug with resolving custom thenables
    // https://bugs.chromium.org/p/chromium/issues/detail?id=830565
    // we can't detect it synchronously, so just check versions
    && v8.indexOf('6.6') !== 0 && _userAgent.indexOf('Chrome/66') === -1;
  } catch (e) {
    /* empty */
  }
}(); // helpers

var isThenable = function (it) {
  var then;
  return _isObject(it) && typeof (then = it.then) == 'function' ? then : false;
};

var notify = function (promise, isReject) {
  if (promise._n) return;
  promise._n = true;
  var chain = promise._c;
  microtask(function () {
    var value = promise._v;
    var ok = promise._s == 1;
    var i = 0;

    var run = function (reaction) {
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

          if (handler === true) result = value;else {
            if (domain) domain.enter();
            result = handler(value); // may throw

            if (domain) {
              domain.exit();
              exited = true;
            }
          }

          if (result === reaction.promise) {
            reject(TypeError$1('Promise-chain cycle'));
          } else if (then = isThenable(result)) {
            then.call(result, resolve, reject);
          } else resolve(result);
        } else reject(value);
      } catch (e) {
        if (domain && !exited) domain.exit();
        reject(e);
      }
    };

    while (chain.length > i) run(chain[i++]); // variable length - can't use forEach


    promise._c = [];
    promise._n = false;
    if (isReject && !promise._h) onUnhandled(promise);
  });
};

var onUnhandled = function (promise) {
  task.call(_global, function () {
    var value = promise._v;
    var unhandled = isUnhandled(promise);
    var result, handler, console;

    if (unhandled) {
      result = _perform(function () {
        if (isNode) {
          process.emit('unhandledRejection', value, promise);
        } else if (handler = _global.onunhandledrejection) {
          handler({
            promise: promise,
            reason: value
          });
        } else if ((console = _global.console) && console.error) {
          console.error('Unhandled promise rejection', value);
        }
      }); // Browsers should not trigger `rejectionHandled` event if it was handled here, NodeJS - should

      promise._h = isNode || isUnhandled(promise) ? 2 : 1;
    }

    promise._a = undefined;
    if (unhandled && result.e) throw result.v;
  });
};

var isUnhandled = function (promise) {
  return promise._h !== 1 && (promise._a || promise._c).length === 0;
};

var onHandleUnhandled = function (promise) {
  task.call(_global, function () {
    var handler;

    if (isNode) {
      process.emit('rejectionHandled', promise);
    } else if (handler = _global.onrejectionhandled) {
      handler({
        promise: promise,
        reason: promise._v
      });
    }
  });
};

var $reject = function (value) {
  var promise = this;
  if (promise._d) return;
  promise._d = true;
  promise = promise._w || promise; // unwrap

  promise._v = value;
  promise._s = 2;
  if (!promise._a) promise._a = promise._c.slice();
  notify(promise, true);
};

var $resolve = function (value) {
  var promise = this;
  var then;
  if (promise._d) return;
  promise._d = true;
  promise = promise._w || promise; // unwrap

  try {
    if (promise === value) throw TypeError$1("Promise can't be resolved itself");

    if (then = isThenable(value)) {
      microtask(function () {
        var wrapper = {
          _w: promise,
          _d: false
        }; // wrap

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
    }, e); // wrap
  }
}; // constructor polyfill


if (!USE_NATIVE) {
  // 25.4.3.1 Promise(executor)
  $Promise = function Promise(executor) {
    _anInstance(this, $Promise, PROMISE, '_h');
    _aFunction(executor);
    Internal.call(this);

    try {
      executor(_ctx($resolve, this, 1), _ctx($reject, this, 1));
    } catch (err) {
      $reject.call(this, err);
    }
  }; // eslint-disable-next-line no-unused-vars


  Internal = function Promise(executor) {
    this._c = []; // <- awaiting reactions

    this._a = undefined; // <- checked in isUnhandled reactions

    this._s = 0; // <- state

    this._d = false; // <- done

    this._v = undefined; // <- value

    this._h = 0; // <- rejection state, 0 - default, 1 - handled, 2 - unhandled

    this._n = false; // <- notify
  };

  Internal.prototype = _redefineAll($Promise.prototype, {
    // 25.4.5.3 Promise.prototype.then(onFulfilled, onRejected)
    then: function then(onFulfilled, onRejected) {
      var reaction = newPromiseCapability(_speciesConstructor(this, $Promise));
      reaction.ok = typeof onFulfilled == 'function' ? onFulfilled : true;
      reaction.fail = typeof onRejected == 'function' && onRejected;
      reaction.domain = isNode ? process.domain : undefined;

      this._c.push(reaction);

      if (this._a) this._a.push(reaction);
      if (this._s) notify(this, false);
      return reaction.promise;
    },
    // 25.4.5.1 Promise.prototype.catch(onRejected)
    'catch': function (onRejected) {
      return this.then(undefined, onRejected);
    }
  });

  OwnPromiseCapability = function () {
    var promise = new Internal();
    this.promise = promise;
    this.resolve = _ctx($resolve, promise, 1);
    this.reject = _ctx($reject, promise, 1);
  };

  _newPromiseCapability.f = newPromiseCapability = function (C) {
    return C === $Promise || C === Wrapper ? new OwnPromiseCapability(C) : newGenericPromiseCapability(C);
  };
}

_export(_export.G + _export.W + _export.F * !USE_NATIVE, {
  Promise: $Promise
});

_setToStringTag($Promise, PROMISE);

_setSpecies(PROMISE);

Wrapper = _core[PROMISE]; // statics

_export(_export.S + _export.F * !USE_NATIVE, PROMISE, {
  // 25.4.4.5 Promise.reject(r)
  reject: function reject(r) {
    var capability = newPromiseCapability(this);
    var $$reject = capability.reject;
    $$reject(r);
    return capability.promise;
  }
});
_export(_export.S + _export.F * (!USE_NATIVE), PROMISE, {
  // 25.4.4.6 Promise.resolve(x)
  resolve: function resolve(x) {
    return _promiseResolve(this, x);
  }
});
_export(_export.S + _export.F * !(USE_NATIVE && _iterDetect(function (iter) {
  $Promise.all(iter)['catch'](empty);
})), PROMISE, {
  // 25.4.4.1 Promise.all(iterable)
  all: function all(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var resolve = capability.resolve;
    var reject = capability.reject;
    var result = _perform(function () {
      var values = [];
      var index = 0;
      var remaining = 1;
      _forOf(iterable, false, function (promise) {
        var $index = index++;
        var alreadyCalled = false;
        values.push(undefined);
        remaining++;
        C.resolve(promise).then(function (value) {
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
  // 25.4.4.4 Promise.race(iterable)
  race: function race(iterable) {
    var C = this;
    var capability = newPromiseCapability(C);
    var reject = capability.reject;
    var result = _perform(function () {
      _forOf(iterable, false, function (promise) {
        C.resolve(promise).then(capability.resolve, reject);
      });
    });
    if (result.e) reject(result.v);
    return capability.promise;
  }
});

_export(_export.P + _export.R, 'Promise', {
  'finally': function (onFinally) {
    var C = _speciesConstructor(this, _core.Promise || _global.Promise);
    var isFunction = typeof onFinally == 'function';
    return this.then(isFunction ? function (x) {
      return _promiseResolve(C, onFinally()).then(function () {
        return x;
      });
    } : onFinally, isFunction ? function (e) {
      return _promiseResolve(C, onFinally()).then(function () {
        throw e;
      });
    } : onFinally);
  }
});

_export(_export.S, 'Promise', {
  'try': function (callbackfn) {
    var promiseCapability = _newPromiseCapability.f(this);
    var result = _perform(callbackfn);
    (result.e ? promiseCapability.reject : promiseCapability.resolve)(result.v);
    return promiseCapability.promise;
  }
});

_core.Promise;

var SET = 'Set'; // 23.2 Set Objects

_collection(SET, function (get) {
  return function Set() {
    return get(this, arguments.length > 0 ? arguments[0] : undefined);
  };
}, {
  // 23.2.3.1 Set.prototype.add(value)
  add: function add(value) {
    return _collectionStrong.def(_validateCollection(this, SET), value = value === 0 ? 0 : value, value);
  }
}, _collectionStrong);

// https://github.com/DavidBruant/Map-Set.prototype.toJSON


_export(_export.P + _export.R, 'Set', {
  toJSON: _collectionToJson('Set')
});

// https://tc39.github.io/proposal-setmap-offrom/#sec-set.of
_setCollectionOf('Set');

// https://tc39.github.io/proposal-setmap-offrom/#sec-set.from
_setCollectionFrom('Set');

_core.Set;

// element-closest | CC0-1.0 | github.com/jonathantneal/closest
(function (ElementProto) {
  if (typeof ElementProto.matches !== 'function') {
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

  if (typeof ElementProto.closest !== 'function') {
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
  new MutationObserver(function (mutations, observer) {
    observer.disconnect();

    if (mutations[0] && mutations[0].type == "childList" && mutations[0].removedNodes[0].childNodes.length == 0) {
      var prototype = HTMLElement.prototype;
      var descriptor = Object.getOwnPropertyDescriptor(prototype, "innerHTML");

      if (descriptor && descriptor.set) {
        Object.defineProperty(prototype, "innerHTML", {
          set: function (value) {
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

/**
 * @this {Promise}
 */
function finallyConstructor(callback) {
  var constructor = this.constructor;
  return this.then(function (value) {
    // @ts-ignore
    return constructor.resolve(callback()).then(function () {
      return value;
    });
  }, function (reason) {
    // @ts-ignore
    return constructor.resolve(callback()).then(function () {
      // @ts-ignore
      return constructor.reject(reason);
    });
  });
}

function allSettled(arr) {
  var P = this;
  return new P(function (resolve, reject) {
    if (!(arr && typeof arr.length !== 'undefined')) {
      return reject(new TypeError(typeof arr + ' ' + arr + ' is not iterable(cannot read property Symbol(Symbol.iterator))'));
    }

    var args = Array.prototype.slice.call(arr);
    if (args.length === 0) return resolve([]);
    var remaining = args.length;

    function res(i, val) {
      if (val && (typeof val === 'object' || typeof val === 'function')) {
        var then = val.then;

        if (typeof then === 'function') {
          then.call(val, function (val) {
            res(i, val);
          }, function (e) {
            args[i] = {
              status: 'rejected',
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
        status: 'fulfilled',
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

// other code modifying setTimeout (like sinon.useFakeTimers())

var setTimeoutFunc = setTimeout;

function isArray(x) {
  return Boolean(x && typeof x.length !== 'undefined');
}

function noop() {} // Polyfill for Function.prototype.bind


function bind(fn, thisArg) {
  return function () {
    fn.apply(thisArg, arguments);
  };
}
/**
 * @constructor
 * @param {Function} fn
 */


function Promise$1(fn) {
  if (!(this instanceof Promise$1)) throw new TypeError('Promises must be constructed via new');
  if (typeof fn !== 'function') throw new TypeError('not a function');
  /** @type {!number} */

  this._state = 0;
  /** @type {!boolean} */

  this._handled = false;
  /** @type {Promise|undefined} */

  this._value = undefined;
  /** @type {!Array<!Function>} */

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

  Promise$1._immediateFn(function () {
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
    // Promise Resolution Procedure: https://github.com/promises-aplus/promises-spec#the-promise-resolution-procedure
    if (newValue === self) throw new TypeError('A promise cannot be resolved with itself.');

    if (newValue && (typeof newValue === 'object' || typeof newValue === 'function')) {
      var then = newValue.then;

      if (newValue instanceof Promise$1) {
        self._state = 3;
        self._value = newValue;
        finale(self);
        return;
      } else if (typeof then === 'function') {
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
    Promise$1._immediateFn(function () {
      if (!self._handled) {
        Promise$1._unhandledRejectionFn(self._value);
      }
    });
  }

  for (var i = 0, len = self._deferreds.length; i < len; i++) {
    handle(self, self._deferreds[i]);
  }

  self._deferreds = null;
}
/**
 * @constructor
 */


function Handler(onFulfilled, onRejected, promise) {
  this.onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : null;
  this.onRejected = typeof onRejected === 'function' ? onRejected : null;
  this.promise = promise;
}
/**
 * Take a potentially misbehaving resolver function and make sure
 * onFulfilled and onRejected are only called once.
 *
 * Makes no guarantees about asynchrony.
 */


function doResolve(fn, self) {
  var done = false;

  try {
    fn(function (value) {
      if (done) return;
      done = true;
      resolve(self, value);
    }, function (reason) {
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

Promise$1.prototype['catch'] = function (onRejected) {
  return this.then(null, onRejected);
};

Promise$1.prototype.then = function (onFulfilled, onRejected) {
  // @ts-ignore
  var prom = new this.constructor(noop);
  handle(this, new Handler(onFulfilled, onRejected, prom));
  return prom;
};

Promise$1.prototype['finally'] = finallyConstructor;

Promise$1.all = function (arr) {
  return new Promise$1(function (resolve, reject) {
    if (!isArray(arr)) {
      return reject(new TypeError('Promise.all accepts an array'));
    }

    var args = Array.prototype.slice.call(arr);
    if (args.length === 0) return resolve([]);
    var remaining = args.length;

    function res(i, val) {
      try {
        if (val && (typeof val === 'object' || typeof val === 'function')) {
          var then = val.then;

          if (typeof then === 'function') {
            then.call(val, function (val) {
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

Promise$1.allSettled = allSettled;

Promise$1.resolve = function (value) {
  if (value && typeof value === 'object' && value.constructor === Promise$1) {
    return value;
  }

  return new Promise$1(function (resolve) {
    resolve(value);
  });
};

Promise$1.reject = function (value) {
  return new Promise$1(function (resolve, reject) {
    reject(value);
  });
};

Promise$1.race = function (arr) {
  return new Promise$1(function (resolve, reject) {
    if (!isArray(arr)) {
      return reject(new TypeError('Promise.race accepts an array'));
    }

    for (var i = 0, len = arr.length; i < len; i++) {
      Promise$1.resolve(arr[i]).then(resolve, reject);
    }
  });
}; // Use polyfill for setImmediate for performance gains


Promise$1._immediateFn = // @ts-ignore
typeof setImmediate === 'function' && function (fn) {
  // @ts-ignore
  setImmediate(fn);
} || function (fn) {
  setTimeoutFunc(fn, 0);
};

Promise$1._unhandledRejectionFn = function _unhandledRejectionFn(err) {
  if (typeof console !== 'undefined' && console) {
    console.warn('Possible Unhandled Promise Rejection:', err); // eslint-disable-line no-console
  }
};

/** @suppress {undefinedVars} */

var globalNS = function () {
  // the only reliable means to get the global object is
  // `Function('return this')()`
  // However, this causes CSP violations in Chrome apps.
  if (typeof self !== 'undefined') {
    return self;
  }

  if (typeof window !== 'undefined') {
    return window;
  }

  if (typeof global !== 'undefined') {
    return global;
  }

  throw new Error('unable to locate global object');
}(); // Expose the polyfill if Promise is undefined or set to a
// non-function value. The latter can be due to a named HTMLElement
// being exposed by browsers for legacy reasons.
// https://github.com/taylorhakes/promise-polyfill/issues/114


if (typeof globalNS['Promise'] !== 'function') {
  globalNS['Promise'] = Promise$1;
} else if (!globalNS.Promise.prototype['finally']) {
  globalNS.Promise.prototype['finally'] = finallyConstructor;
} else if (!globalNS.Promise.allSettled) {
  globalNS.Promise.allSettled = allSettled;
}

var global$1 = typeof globalThis !== 'undefined' && globalThis || typeof self !== 'undefined' && self || typeof global$1 !== 'undefined' && global$1;
var support = {
  searchParams: 'URLSearchParams' in global$1,
  iterable: 'Symbol' in global$1 && 'iterator' in Symbol,
  blob: 'FileReader' in global$1 && 'Blob' in global$1 && function () {
    try {
      new Blob();
      return true;
    } catch (e) {
      return false;
    }
  }(),
  formData: 'FormData' in global$1,
  arrayBuffer: 'ArrayBuffer' in global$1
};

function isDataView(obj) {
  return obj && DataView.prototype.isPrototypeOf(obj);
}

if (support.arrayBuffer) {
  var viewClasses = ['[object Int8Array]', '[object Uint8Array]', '[object Uint8ClampedArray]', '[object Int16Array]', '[object Uint16Array]', '[object Int32Array]', '[object Uint32Array]', '[object Float32Array]', '[object Float64Array]'];

  var isArrayBufferView = ArrayBuffer.isView || function (obj) {
    return obj && viewClasses.indexOf(Object.prototype.toString.call(obj)) > -1;
  };
}

function normalizeName(name) {
  if (typeof name !== 'string') {
    name = String(name);
  }

  if (/[^a-z0-9\-#$%&'*+.^_`|~!]/i.test(name) || name === '') {
    throw new TypeError('Invalid character in header field name: "' + name + '"');
  }

  return name.toLowerCase();
}

function normalizeValue(value) {
  if (typeof value !== 'string') {
    value = String(value);
  }

  return value;
} // Build a destructive iterator for the value list


function iteratorFor(items) {
  var iterator = {
    next: function () {
      var value = items.shift();
      return {
        done: value === undefined,
        value: value
      };
    }
  };

  if (support.iterable) {
    iterator[Symbol.iterator] = function () {
      return iterator;
    };
  }

  return iterator;
}

function Headers$1(headers) {
  this.map = {};

  if (headers instanceof Headers$1) {
    headers.forEach(function (value, name) {
      this.append(name, value);
    }, this);
  } else if (Array.isArray(headers)) {
    headers.forEach(function (header) {
      this.append(header[0], header[1]);
    }, this);
  } else if (headers) {
    Object.getOwnPropertyNames(headers).forEach(function (name) {
      this.append(name, headers[name]);
    }, this);
  }
}

Headers$1.prototype.append = function (name, value) {
  name = normalizeName(name);
  value = normalizeValue(value);
  var oldValue = this.map[name];
  this.map[name] = oldValue ? oldValue + ', ' + value : value;
};

Headers$1.prototype['delete'] = function (name) {
  delete this.map[normalizeName(name)];
};

Headers$1.prototype.get = function (name) {
  name = normalizeName(name);
  return this.has(name) ? this.map[name] : null;
};

Headers$1.prototype.has = function (name) {
  return this.map.hasOwnProperty(normalizeName(name));
};

Headers$1.prototype.set = function (name, value) {
  this.map[normalizeName(name)] = normalizeValue(value);
};

Headers$1.prototype.forEach = function (callback, thisArg) {
  for (var name in this.map) {
    if (this.map.hasOwnProperty(name)) {
      callback.call(thisArg, this.map[name], name, this);
    }
  }
};

Headers$1.prototype.keys = function () {
  var items = [];
  this.forEach(function (value, name) {
    items.push(name);
  });
  return iteratorFor(items);
};

Headers$1.prototype.values = function () {
  var items = [];
  this.forEach(function (value) {
    items.push(value);
  });
  return iteratorFor(items);
};

Headers$1.prototype.entries = function () {
  var items = [];
  this.forEach(function (value, name) {
    items.push([name, value]);
  });
  return iteratorFor(items);
};

if (support.iterable) {
  Headers$1.prototype[Symbol.iterator] = Headers$1.prototype.entries;
}

function consumed(body) {
  if (body.bodyUsed) {
    return Promise.reject(new TypeError('Already read'));
  }

  body.bodyUsed = true;
}

function fileReaderReady(reader) {
  return new Promise(function (resolve, reject) {
    reader.onload = function () {
      resolve(reader.result);
    };

    reader.onerror = function () {
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

  return chars.join('');
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

  this._initBody = function (body) {
    /*
      fetch-mock wraps the Response object in an ES6 Proxy to
      provide useful test harness features such as flush. However, on
      ES5 browsers without fetch or Proxy support pollyfills must be used;
      the proxy-pollyfill is unable to proxy an attribute unless it exists
      on the object before the Proxy is created. This change ensures
      Response.bodyUsed exists on the instance, while maintaining the
      semantic of setting Request.bodyUsed in the constructor before
      _initBody is called.
    */
    this.bodyUsed = this.bodyUsed;
    this._bodyInit = body;

    if (!body) {
      this._bodyText = '';
    } else if (typeof body === 'string') {
      this._bodyText = body;
    } else if (support.blob && Blob.prototype.isPrototypeOf(body)) {
      this._bodyBlob = body;
    } else if (support.formData && FormData.prototype.isPrototypeOf(body)) {
      this._bodyFormData = body;
    } else if (support.searchParams && URLSearchParams.prototype.isPrototypeOf(body)) {
      this._bodyText = body.toString();
    } else if (support.arrayBuffer && support.blob && isDataView(body)) {
      this._bodyArrayBuffer = bufferClone(body.buffer); // IE 10-11 can't handle a DataView body.

      this._bodyInit = new Blob([this._bodyArrayBuffer]);
    } else if (support.arrayBuffer && (ArrayBuffer.prototype.isPrototypeOf(body) || isArrayBufferView(body))) {
      this._bodyArrayBuffer = bufferClone(body);
    } else {
      this._bodyText = body = Object.prototype.toString.call(body);
    }

    if (!this.headers.get('content-type')) {
      if (typeof body === 'string') {
        this.headers.set('content-type', 'text/plain;charset=UTF-8');
      } else if (this._bodyBlob && this._bodyBlob.type) {
        this.headers.set('content-type', this._bodyBlob.type);
      } else if (support.searchParams && URLSearchParams.prototype.isPrototypeOf(body)) {
        this.headers.set('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
      }
    }
  };

  if (support.blob) {
    this.blob = function () {
      var rejected = consumed(this);

      if (rejected) {
        return rejected;
      }

      if (this._bodyBlob) {
        return Promise.resolve(this._bodyBlob);
      } else if (this._bodyArrayBuffer) {
        return Promise.resolve(new Blob([this._bodyArrayBuffer]));
      } else if (this._bodyFormData) {
        throw new Error('could not read FormData body as blob');
      } else {
        return Promise.resolve(new Blob([this._bodyText]));
      }
    };

    this.arrayBuffer = function () {
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

  this.text = function () {
    var rejected = consumed(this);

    if (rejected) {
      return rejected;
    }

    if (this._bodyBlob) {
      return readBlobAsText(this._bodyBlob);
    } else if (this._bodyArrayBuffer) {
      return Promise.resolve(readArrayBufferAsText(this._bodyArrayBuffer));
    } else if (this._bodyFormData) {
      throw new Error('could not read FormData body as text');
    } else {
      return Promise.resolve(this._bodyText);
    }
  };

  if (support.formData) {
    this.formData = function () {
      return this.text().then(decode);
    };
  }

  this.json = function () {
    return this.text().then(JSON.parse);
  };

  return this;
} // HTTP methods whose capitalization should be normalized


var methods = ['DELETE', 'GET', 'HEAD', 'OPTIONS', 'POST', 'PUT'];

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
      throw new TypeError('Already read');
    }

    this.url = input.url;
    this.credentials = input.credentials;

    if (!options.headers) {
      this.headers = new Headers$1(input.headers);
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

  this.credentials = options.credentials || this.credentials || 'same-origin';

  if (options.headers || !this.headers) {
    this.headers = new Headers$1(options.headers);
  }

  this.method = normalizeMethod(options.method || this.method || 'GET');
  this.mode = options.mode || this.mode || null;
  this.signal = options.signal || this.signal;
  this.referrer = null;

  if ((this.method === 'GET' || this.method === 'HEAD') && body) {
    throw new TypeError('Body not allowed for GET or HEAD requests');
  }

  this._initBody(body);

  if (this.method === 'GET' || this.method === 'HEAD') {
    if (options.cache === 'no-store' || options.cache === 'no-cache') {
      // Search for a '_' parameter in the query string
      var reParamSearch = /([?&])_=[^&]*/;

      if (reParamSearch.test(this.url)) {
        // If it already exists then set the value with the current time
        this.url = this.url.replace(reParamSearch, '$1_=' + new Date().getTime());
      } else {
        // Otherwise add a new '_' parameter to the end with the current time
        var reQueryString = /\?/;
        this.url += (reQueryString.test(this.url) ? '&' : '?') + '_=' + new Date().getTime();
      }
    }
  }
}

Request.prototype.clone = function () {
  return new Request(this, {
    body: this._bodyInit
  });
};

function decode(body) {
  var form = new FormData();
  body.trim().split('&').forEach(function (bytes) {
    if (bytes) {
      var split = bytes.split('=');
      var name = split.shift().replace(/\+/g, ' ');
      var value = split.join('=').replace(/\+/g, ' ');
      form.append(decodeURIComponent(name), decodeURIComponent(value));
    }
  });
  return form;
}

function parseHeaders(rawHeaders) {
  var headers = new Headers$1(); // Replace instances of \r\n and \n followed by at least one space or horizontal tab with a space
  // https://tools.ietf.org/html/rfc7230#section-3.2

  var preProcessedHeaders = rawHeaders.replace(/\r?\n[\t ]+/g, ' '); // Avoiding split via regex to work around a common IE11 bug with the core-js 3.6.0 regex polyfill
  // https://github.com/github/fetch/issues/748
  // https://github.com/zloirock/core-js/issues/751

  preProcessedHeaders.split('\r').map(function (header) {
    return header.indexOf('\n') === 0 ? header.substr(1, header.length) : header;
  }).forEach(function (line) {
    var parts = line.split(':');
    var key = parts.shift().trim();

    if (key) {
      var value = parts.join(':').trim();
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

  this.type = 'default';
  this.status = options.status === undefined ? 200 : options.status;
  this.ok = this.status >= 200 && this.status < 300;
  this.statusText = options.statusText === undefined ? '' : '' + options.statusText;
  this.headers = new Headers$1(options.headers);
  this.url = options.url || '';

  this._initBody(bodyInit);
}
Body.call(Response.prototype);

Response.prototype.clone = function () {
  return new Response(this._bodyInit, {
    status: this.status,
    statusText: this.statusText,
    headers: new Headers$1(this.headers),
    url: this.url
  });
};

Response.error = function () {
  var response = new Response(null, {
    status: 0,
    statusText: ''
  });
  response.type = 'error';
  return response;
};

var redirectStatuses = [301, 302, 303, 307, 308];

Response.redirect = function (url, status) {
  if (redirectStatuses.indexOf(status) === -1) {
    throw new RangeError('Invalid status code');
  }

  return new Response(null, {
    status: status,
    headers: {
      location: url
    }
  });
};

var DOMException$1 = global$1.DOMException;

try {
  new DOMException$1();
} catch (err) {
  DOMException$1 = function (message, name) {
    this.message = message;
    this.name = name;
    var error = Error(message);
    this.stack = error.stack;
  };

  DOMException$1.prototype = Object.create(Error.prototype);
  DOMException$1.prototype.constructor = DOMException$1;
}

function fetch$2(input, init) {
  return new Promise(function (resolve, reject) {
    var request = new Request(input, init);

    if (request.signal && request.signal.aborted) {
      return reject(new DOMException$1('Aborted', 'AbortError'));
    }

    var xhr = new XMLHttpRequest();

    function abortXhr() {
      xhr.abort();
    }

    xhr.onload = function () {
      var options = {
        status: xhr.status,
        statusText: xhr.statusText,
        headers: parseHeaders(xhr.getAllResponseHeaders() || '')
      };
      options.url = 'responseURL' in xhr ? xhr.responseURL : options.headers.get('X-Request-URL');
      var body = 'response' in xhr ? xhr.response : xhr.responseText;
      setTimeout(function () {
        resolve(new Response(body, options));
      }, 0);
    };

    xhr.onerror = function () {
      setTimeout(function () {
        reject(new TypeError('Network request failed'));
      }, 0);
    };

    xhr.ontimeout = function () {
      setTimeout(function () {
        reject(new TypeError('Network request failed'));
      }, 0);
    };

    xhr.onabort = function () {
      setTimeout(function () {
        reject(new DOMException$1('Aborted', 'AbortError'));
      }, 0);
    };

    function fixUrl(url) {
      try {
        return url === '' && global$1.location.href ? global$1.location.href : url;
      } catch (e) {
        return url;
      }
    }

    xhr.open(request.method, fixUrl(request.url), true);

    if (request.credentials === 'include') {
      xhr.withCredentials = true;
    } else if (request.credentials === 'omit') {
      xhr.withCredentials = false;
    }

    if ('responseType' in xhr) {
      if (support.blob) {
        xhr.responseType = 'blob';
      } else if (support.arrayBuffer && request.headers.get('Content-Type') && request.headers.get('Content-Type').indexOf('application/octet-stream') !== -1) {
        xhr.responseType = 'arraybuffer';
      }
    }

    if (init && typeof init.headers === 'object' && !(init.headers instanceof Headers$1)) {
      Object.getOwnPropertyNames(init.headers).forEach(function (name) {
        xhr.setRequestHeader(name, normalizeValue(init.headers[name]));
      });
    } else {
      request.headers.forEach(function (value, name) {
        xhr.setRequestHeader(name, value);
      });
    }

    if (request.signal) {
      request.signal.addEventListener('abort', abortXhr);

      xhr.onreadystatechange = function () {
        // DONE (success or failure)
        if (xhr.readyState === 4) {
          request.signal.removeEventListener('abort', abortXhr);
        }
      };
    }

    xhr.send(typeof request._bodyInit === 'undefined' ? null : request._bodyInit);
  });
}
fetch$2.polyfill = true;

if (!global$1.fetch) {
  global$1.fetch = fetch$2;
  global$1.Headers = Headers$1;
  global$1.Request = Request;
  global$1.Response = Response;
}

var EventListener =
/** @class */
function () {
  function EventListener(eventTarget, eventName, eventOptions) {
    this.eventTarget = eventTarget;
    this.eventName = eventName;
    this.eventOptions = eventOptions;
    this.unorderedBindings = new Set();
  }

  EventListener.prototype.connect = function () {
    this.eventTarget.addEventListener(this.eventName, this, this.eventOptions);
  };

  EventListener.prototype.disconnect = function () {
    this.eventTarget.removeEventListener(this.eventName, this, this.eventOptions);
  }; // Binding observer delegate

  /** @hidden */


  EventListener.prototype.bindingConnected = function (binding) {
    this.unorderedBindings.add(binding);
  };
  /** @hidden */


  EventListener.prototype.bindingDisconnected = function (binding) {
    this.unorderedBindings.delete(binding);
  };

  EventListener.prototype.handleEvent = function (event) {
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
    get: function () {
      return Array.from(this.unorderedBindings).sort(function (left, right) {
        var leftIndex = left.index,
            rightIndex = right.index;
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
      stopImmediatePropagation: function () {
        this.immediatePropagationStopped = true;
        stopImmediatePropagation_1.call(this);
      }
    });
  }
}

var Dispatcher =
/** @class */
function () {
  function Dispatcher(application) {
    this.application = application;
    this.eventListenerMaps = new Map();
    this.started = false;
  }

  Dispatcher.prototype.start = function () {
    if (!this.started) {
      this.started = true;
      this.eventListeners.forEach(function (eventListener) {
        return eventListener.connect();
      });
    }
  };

  Dispatcher.prototype.stop = function () {
    if (this.started) {
      this.started = false;
      this.eventListeners.forEach(function (eventListener) {
        return eventListener.disconnect();
      });
    }
  };

  Object.defineProperty(Dispatcher.prototype, "eventListeners", {
    get: function () {
      return Array.from(this.eventListenerMaps.values()).reduce(function (listeners, map) {
        return listeners.concat(Array.from(map.values()));
      }, []);
    },
    enumerable: false,
    configurable: true
  }); // Binding observer delegate

  /** @hidden */

  Dispatcher.prototype.bindingConnected = function (binding) {
    this.fetchEventListenerForBinding(binding).bindingConnected(binding);
  };
  /** @hidden */


  Dispatcher.prototype.bindingDisconnected = function (binding) {
    this.fetchEventListenerForBinding(binding).bindingDisconnected(binding);
  }; // Error handling


  Dispatcher.prototype.handleError = function (error, message, detail) {
    if (detail === void 0) {
      detail = {};
    }

    this.application.handleError(error, "Error " + message, detail);
  };

  Dispatcher.prototype.fetchEventListenerForBinding = function (binding) {
    var eventTarget = binding.eventTarget,
        eventName = binding.eventName,
        eventOptions = binding.eventOptions;
    return this.fetchEventListener(eventTarget, eventName, eventOptions);
  };

  Dispatcher.prototype.fetchEventListener = function (eventTarget, eventName, eventOptions) {
    var eventListenerMap = this.fetchEventListenerMapForEventTarget(eventTarget);
    var cacheKey = this.cacheKey(eventName, eventOptions);
    var eventListener = eventListenerMap.get(cacheKey);

    if (!eventListener) {
      eventListener = this.createEventListener(eventTarget, eventName, eventOptions);
      eventListenerMap.set(cacheKey, eventListener);
    }

    return eventListener;
  };

  Dispatcher.prototype.createEventListener = function (eventTarget, eventName, eventOptions) {
    var eventListener = new EventListener(eventTarget, eventName, eventOptions);

    if (this.started) {
      eventListener.connect();
    }

    return eventListener;
  };

  Dispatcher.prototype.fetchEventListenerMapForEventTarget = function (eventTarget) {
    var eventListenerMap = this.eventListenerMaps.get(eventTarget);

    if (!eventListenerMap) {
      eventListenerMap = new Map();
      this.eventListenerMaps.set(eventTarget, eventListenerMap);
    }

    return eventListenerMap;
  };

  Dispatcher.prototype.cacheKey = function (eventName, eventOptions) {
    var parts = [eventName];
    Object.keys(eventOptions).sort().forEach(function (key) {
      parts.push("" + (eventOptions[key] ? "" : "!") + key);
    });
    return parts.join(":");
  };

  return Dispatcher;
}();

// capture nos.:            12   23 4               43   1 5   56 7      768 9  98
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
  return eventOptions.split(":").reduce(function (options, token) {
    var _a;

    return Object.assign(options, (_a = {}, _a[token.replace(/^!/, "")] = !/^!/.test(token), _a));
  }, {});
}

function stringifyEventTarget(eventTarget) {
  if (eventTarget == window) {
    return "window";
  } else if (eventTarget == document) {
    return "document";
  }
}

var Action =
/** @class */
function () {
  function Action(element, index, descriptor) {
    this.element = element;
    this.index = index;
    this.eventTarget = descriptor.eventTarget || element;
    this.eventName = descriptor.eventName || getDefaultEventNameForElement(element) || error("missing event name");
    this.eventOptions = descriptor.eventOptions || {};
    this.identifier = descriptor.identifier || error("missing identifier");
    this.methodName = descriptor.methodName || error("missing method name");
  }

  Action.forToken = function (token) {
    return new this(token.element, token.index, parseActionDescriptorString(token.content));
  };

  Action.prototype.toString = function () {
    var eventNameSuffix = this.eventTargetName ? "@" + this.eventTargetName : "";
    return "" + this.eventName + eventNameSuffix + "->" + this.identifier + "#" + this.methodName;
  };

  Object.defineProperty(Action.prototype, "eventTargetName", {
    get: function () {
      return stringifyEventTarget(this.eventTarget);
    },
    enumerable: false,
    configurable: true
  });
  return Action;
}();
var defaultEventNames = {
  "a": function (e) {
    return "click";
  },
  "button": function (e) {
    return "click";
  },
  "form": function (e) {
    return "submit";
  },
  "input": function (e) {
    return e.getAttribute("type") == "submit" ? "click" : "input";
  },
  "select": function (e) {
    return "change";
  },
  "textarea": function (e) {
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

var Binding =
/** @class */
function () {
  function Binding(context, action) {
    this.context = context;
    this.action = action;
  }

  Object.defineProperty(Binding.prototype, "index", {
    get: function () {
      return this.action.index;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "eventTarget", {
    get: function () {
      return this.action.eventTarget;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "eventOptions", {
    get: function () {
      return this.action.eventOptions;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "identifier", {
    get: function () {
      return this.context.identifier;
    },
    enumerable: false,
    configurable: true
  });

  Binding.prototype.handleEvent = function (event) {
    if (this.willBeInvokedByEvent(event)) {
      this.invokeWithEvent(event);
    }
  };

  Object.defineProperty(Binding.prototype, "eventName", {
    get: function () {
      return this.action.eventName;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "method", {
    get: function () {
      var method = this.controller[this.methodName];

      if (typeof method == "function") {
        return method;
      }

      throw new Error("Action \"" + this.action + "\" references undefined method \"" + this.methodName + "\"");
    },
    enumerable: false,
    configurable: true
  });

  Binding.prototype.invokeWithEvent = function (event) {
    try {
      this.method.call(this.controller, event);
    } catch (error) {
      var _a = this,
          identifier = _a.identifier,
          controller = _a.controller,
          element = _a.element,
          index = _a.index;

      var detail = {
        identifier: identifier,
        controller: controller,
        element: element,
        index: index,
        event: event
      };
      this.context.handleError(error, "invoking action \"" + this.action + "\"", detail);
    }
  };

  Binding.prototype.willBeInvokedByEvent = function (event) {
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
    get: function () {
      return this.context.controller;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "methodName", {
    get: function () {
      return this.action.methodName;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "element", {
    get: function () {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Binding.prototype, "scope", {
    get: function () {
      return this.context.scope;
    },
    enumerable: false,
    configurable: true
  });
  return Binding;
}();

var ElementObserver =
/** @class */
function () {
  function ElementObserver(element, delegate) {
    var _this = this;

    this.element = element;
    this.started = false;
    this.delegate = delegate;
    this.elements = new Set();
    this.mutationObserver = new MutationObserver(function (mutations) {
      return _this.processMutations(mutations);
    });
  }

  ElementObserver.prototype.start = function () {
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

  ElementObserver.prototype.stop = function () {
    if (this.started) {
      this.mutationObserver.takeRecords();
      this.mutationObserver.disconnect();
      this.started = false;
    }
  };

  ElementObserver.prototype.refresh = function () {
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
  }; // Mutation record processing


  ElementObserver.prototype.processMutations = function (mutations) {
    if (this.started) {
      for (var _i = 0, mutations_1 = mutations; _i < mutations_1.length; _i++) {
        var mutation = mutations_1[_i];
        this.processMutation(mutation);
      }
    }
  };

  ElementObserver.prototype.processMutation = function (mutation) {
    if (mutation.type == "attributes") {
      this.processAttributeChange(mutation.target, mutation.attributeName);
    } else if (mutation.type == "childList") {
      this.processRemovedNodes(mutation.removedNodes);
      this.processAddedNodes(mutation.addedNodes);
    }
  };

  ElementObserver.prototype.processAttributeChange = function (node, attributeName) {
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

  ElementObserver.prototype.processRemovedNodes = function (nodes) {
    for (var _i = 0, _a = Array.from(nodes); _i < _a.length; _i++) {
      var node = _a[_i];
      var element = this.elementFromNode(node);

      if (element) {
        this.processTree(element, this.removeElement);
      }
    }
  };

  ElementObserver.prototype.processAddedNodes = function (nodes) {
    for (var _i = 0, _a = Array.from(nodes); _i < _a.length; _i++) {
      var node = _a[_i];
      var element = this.elementFromNode(node);

      if (element && this.elementIsActive(element)) {
        this.processTree(element, this.addElement);
      }
    }
  }; // Element matching


  ElementObserver.prototype.matchElement = function (element) {
    return this.delegate.matchElement(element);
  };

  ElementObserver.prototype.matchElementsInTree = function (tree) {
    if (tree === void 0) {
      tree = this.element;
    }

    return this.delegate.matchElementsInTree(tree);
  };

  ElementObserver.prototype.processTree = function (tree, processor) {
    for (var _i = 0, _a = this.matchElementsInTree(tree); _i < _a.length; _i++) {
      var element = _a[_i];
      processor.call(this, element);
    }
  };

  ElementObserver.prototype.elementFromNode = function (node) {
    if (node.nodeType == Node.ELEMENT_NODE) {
      return node;
    }
  };

  ElementObserver.prototype.elementIsActive = function (element) {
    if (element.isConnected != this.element.isConnected) {
      return false;
    } else {
      return this.element.contains(element);
    }
  }; // Element tracking


  ElementObserver.prototype.addElement = function (element) {
    if (!this.elements.has(element)) {
      if (this.elementIsActive(element)) {
        this.elements.add(element);

        if (this.delegate.elementMatched) {
          this.delegate.elementMatched(element);
        }
      }
    }
  };

  ElementObserver.prototype.removeElement = function (element) {
    if (this.elements.has(element)) {
      this.elements.delete(element);

      if (this.delegate.elementUnmatched) {
        this.delegate.elementUnmatched(element);
      }
    }
  };

  return ElementObserver;
}();

var AttributeObserver =
/** @class */
function () {
  function AttributeObserver(element, attributeName, delegate) {
    this.attributeName = attributeName;
    this.delegate = delegate;
    this.elementObserver = new ElementObserver(element, this);
  }

  Object.defineProperty(AttributeObserver.prototype, "element", {
    get: function () {
      return this.elementObserver.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(AttributeObserver.prototype, "selector", {
    get: function () {
      return "[" + this.attributeName + "]";
    },
    enumerable: false,
    configurable: true
  });

  AttributeObserver.prototype.start = function () {
    this.elementObserver.start();
  };

  AttributeObserver.prototype.stop = function () {
    this.elementObserver.stop();
  };

  AttributeObserver.prototype.refresh = function () {
    this.elementObserver.refresh();
  };

  Object.defineProperty(AttributeObserver.prototype, "started", {
    get: function () {
      return this.elementObserver.started;
    },
    enumerable: false,
    configurable: true
  }); // Element observer delegate

  AttributeObserver.prototype.matchElement = function (element) {
    return element.hasAttribute(this.attributeName);
  };

  AttributeObserver.prototype.matchElementsInTree = function (tree) {
    var match = this.matchElement(tree) ? [tree] : [];
    var matches = Array.from(tree.querySelectorAll(this.selector));
    return match.concat(matches);
  };

  AttributeObserver.prototype.elementMatched = function (element) {
    if (this.delegate.elementMatchedAttribute) {
      this.delegate.elementMatchedAttribute(element, this.attributeName);
    }
  };

  AttributeObserver.prototype.elementUnmatched = function (element) {
    if (this.delegate.elementUnmatchedAttribute) {
      this.delegate.elementUnmatchedAttribute(element, this.attributeName);
    }
  };

  AttributeObserver.prototype.elementAttributeChanged = function (element, attributeName) {
    if (this.delegate.elementAttributeValueChanged && this.attributeName == attributeName) {
      this.delegate.elementAttributeValueChanged(element, attributeName);
    }
  };

  return AttributeObserver;
}();

var StringMapObserver =
/** @class */
function () {
  function StringMapObserver(element, delegate) {
    var _this = this;

    this.element = element;
    this.delegate = delegate;
    this.started = false;
    this.stringMap = new Map();
    this.mutationObserver = new MutationObserver(function (mutations) {
      return _this.processMutations(mutations);
    });
  }

  StringMapObserver.prototype.start = function () {
    if (!this.started) {
      this.started = true;
      this.mutationObserver.observe(this.element, {
        attributes: true
      });
      this.refresh();
    }
  };

  StringMapObserver.prototype.stop = function () {
    if (this.started) {
      this.mutationObserver.takeRecords();
      this.mutationObserver.disconnect();
      this.started = false;
    }
  };

  StringMapObserver.prototype.refresh = function () {
    if (this.started) {
      for (var _i = 0, _a = this.knownAttributeNames; _i < _a.length; _i++) {
        var attributeName = _a[_i];
        this.refreshAttribute(attributeName);
      }
    }
  }; // Mutation record processing


  StringMapObserver.prototype.processMutations = function (mutations) {
    if (this.started) {
      for (var _i = 0, mutations_1 = mutations; _i < mutations_1.length; _i++) {
        var mutation = mutations_1[_i];
        this.processMutation(mutation);
      }
    }
  };

  StringMapObserver.prototype.processMutation = function (mutation) {
    var attributeName = mutation.attributeName;

    if (attributeName) {
      this.refreshAttribute(attributeName);
    }
  }; // State tracking


  StringMapObserver.prototype.refreshAttribute = function (attributeName) {
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

  StringMapObserver.prototype.stringMapKeyAdded = function (key, attributeName) {
    if (this.delegate.stringMapKeyAdded) {
      this.delegate.stringMapKeyAdded(key, attributeName);
    }
  };

  StringMapObserver.prototype.stringMapValueChanged = function (value, key) {
    if (this.delegate.stringMapValueChanged) {
      this.delegate.stringMapValueChanged(value, key);
    }
  };

  StringMapObserver.prototype.stringMapKeyRemoved = function (key, attributeName) {
    if (this.delegate.stringMapKeyRemoved) {
      this.delegate.stringMapKeyRemoved(key, attributeName);
    }
  };

  Object.defineProperty(StringMapObserver.prototype, "knownAttributeNames", {
    get: function () {
      return Array.from(new Set(this.currentAttributeNames.concat(this.recordedAttributeNames)));
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(StringMapObserver.prototype, "currentAttributeNames", {
    get: function () {
      return Array.from(this.element.attributes).map(function (attribute) {
        return attribute.name;
      });
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(StringMapObserver.prototype, "recordedAttributeNames", {
    get: function () {
      return Array.from(this.stringMap.keys());
    },
    enumerable: false,
    configurable: true
  });
  return StringMapObserver;
}();

function add(map, key, value) {
  fetch$1(map, key).add(value);
}
function del(map, key, value) {
  fetch$1(map, key).delete(value);
  prune(map, key);
}
function fetch$1(map, key) {
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

var Multimap =
/** @class */
function () {
  function Multimap() {
    this.valuesByKey = new Map();
  }

  Object.defineProperty(Multimap.prototype, "values", {
    get: function () {
      var sets = Array.from(this.valuesByKey.values());
      return sets.reduce(function (values, set) {
        return values.concat(Array.from(set));
      }, []);
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Multimap.prototype, "size", {
    get: function () {
      var sets = Array.from(this.valuesByKey.values());
      return sets.reduce(function (size, set) {
        return size + set.size;
      }, 0);
    },
    enumerable: false,
    configurable: true
  });

  Multimap.prototype.add = function (key, value) {
    add(this.valuesByKey, key, value);
  };

  Multimap.prototype.delete = function (key, value) {
    del(this.valuesByKey, key, value);
  };

  Multimap.prototype.has = function (key, value) {
    var values = this.valuesByKey.get(key);
    return values != null && values.has(value);
  };

  Multimap.prototype.hasKey = function (key) {
    return this.valuesByKey.has(key);
  };

  Multimap.prototype.hasValue = function (value) {
    var sets = Array.from(this.valuesByKey.values());
    return sets.some(function (set) {
      return set.has(value);
    });
  };

  Multimap.prototype.getValuesForKey = function (key) {
    var values = this.valuesByKey.get(key);
    return values ? Array.from(values) : [];
  };

  Multimap.prototype.getKeysForValue = function (value) {
    return Array.from(this.valuesByKey).filter(function (_a) {
      _a[0];
          var values = _a[1];
      return values.has(value);
    }).map(function (_a) {
      var key = _a[0];
          _a[1];
      return key;
    });
  };

  return Multimap;
}();

var __extends$1 = window && window.__extends || function () {
  var extendStatics = function (d, b) {
    extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    };

    return extendStatics(d, b);
  };

  return function (d, b) {
    extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

/** @class */
(function (_super) {
  __extends$1(IndexedMultimap, _super);

  function IndexedMultimap() {
    var _this = _super.call(this) || this;

    _this.keysByValue = new Map();
    return _this;
  }

  Object.defineProperty(IndexedMultimap.prototype, "values", {
    get: function () {
      return Array.from(this.keysByValue.keys());
    },
    enumerable: false,
    configurable: true
  });

  IndexedMultimap.prototype.add = function (key, value) {
    _super.prototype.add.call(this, key, value);

    add(this.keysByValue, value, key);
  };

  IndexedMultimap.prototype.delete = function (key, value) {
    _super.prototype.delete.call(this, key, value);

    del(this.keysByValue, value, key);
  };

  IndexedMultimap.prototype.hasValue = function (value) {
    return this.keysByValue.has(value);
  };

  IndexedMultimap.prototype.getKeysForValue = function (value) {
    var set = this.keysByValue.get(value);
    return set ? Array.from(set) : [];
  };

  return IndexedMultimap;
})(Multimap);

var TokenListObserver =
/** @class */
function () {
  function TokenListObserver(element, attributeName, delegate) {
    this.attributeObserver = new AttributeObserver(element, attributeName, this);
    this.delegate = delegate;
    this.tokensByElement = new Multimap();
  }

  Object.defineProperty(TokenListObserver.prototype, "started", {
    get: function () {
      return this.attributeObserver.started;
    },
    enumerable: false,
    configurable: true
  });

  TokenListObserver.prototype.start = function () {
    this.attributeObserver.start();
  };

  TokenListObserver.prototype.stop = function () {
    this.attributeObserver.stop();
  };

  TokenListObserver.prototype.refresh = function () {
    this.attributeObserver.refresh();
  };

  Object.defineProperty(TokenListObserver.prototype, "element", {
    get: function () {
      return this.attributeObserver.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(TokenListObserver.prototype, "attributeName", {
    get: function () {
      return this.attributeObserver.attributeName;
    },
    enumerable: false,
    configurable: true
  }); // Attribute observer delegate

  TokenListObserver.prototype.elementMatchedAttribute = function (element) {
    this.tokensMatched(this.readTokensForElement(element));
  };

  TokenListObserver.prototype.elementAttributeValueChanged = function (element) {
    var _a = this.refreshTokensForElement(element),
        unmatchedTokens = _a[0],
        matchedTokens = _a[1];

    this.tokensUnmatched(unmatchedTokens);
    this.tokensMatched(matchedTokens);
  };

  TokenListObserver.prototype.elementUnmatchedAttribute = function (element) {
    this.tokensUnmatched(this.tokensByElement.getValuesForKey(element));
  };

  TokenListObserver.prototype.tokensMatched = function (tokens) {
    var _this = this;

    tokens.forEach(function (token) {
      return _this.tokenMatched(token);
    });
  };

  TokenListObserver.prototype.tokensUnmatched = function (tokens) {
    var _this = this;

    tokens.forEach(function (token) {
      return _this.tokenUnmatched(token);
    });
  };

  TokenListObserver.prototype.tokenMatched = function (token) {
    this.delegate.tokenMatched(token);
    this.tokensByElement.add(token.element, token);
  };

  TokenListObserver.prototype.tokenUnmatched = function (token) {
    this.delegate.tokenUnmatched(token);
    this.tokensByElement.delete(token.element, token);
  };

  TokenListObserver.prototype.refreshTokensForElement = function (element) {
    var previousTokens = this.tokensByElement.getValuesForKey(element);
    var currentTokens = this.readTokensForElement(element);
    var firstDifferingIndex = zip(previousTokens, currentTokens).findIndex(function (_a) {
      var previousToken = _a[0],
          currentToken = _a[1];
      return !tokensAreEqual(previousToken, currentToken);
    });

    if (firstDifferingIndex == -1) {
      return [[], []];
    } else {
      return [previousTokens.slice(firstDifferingIndex), currentTokens.slice(firstDifferingIndex)];
    }
  };

  TokenListObserver.prototype.readTokensForElement = function (element) {
    var attributeName = this.attributeName;
    var tokenString = element.getAttribute(attributeName) || "";
    return parseTokenString(tokenString, element, attributeName);
  };

  return TokenListObserver;
}();

function parseTokenString(tokenString, element, attributeName) {
  return tokenString.trim().split(/\s+/).filter(function (content) {
    return content.length;
  }).map(function (content, index) {
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
  }, function (_, index) {
    return [left[index], right[index]];
  });
}

function tokensAreEqual(left, right) {
  return left && right && left.index == right.index && left.content == right.content;
}

var ValueListObserver =
/** @class */
function () {
  function ValueListObserver(element, attributeName, delegate) {
    this.tokenListObserver = new TokenListObserver(element, attributeName, this);
    this.delegate = delegate;
    this.parseResultsByToken = new WeakMap();
    this.valuesByTokenByElement = new WeakMap();
  }

  Object.defineProperty(ValueListObserver.prototype, "started", {
    get: function () {
      return this.tokenListObserver.started;
    },
    enumerable: false,
    configurable: true
  });

  ValueListObserver.prototype.start = function () {
    this.tokenListObserver.start();
  };

  ValueListObserver.prototype.stop = function () {
    this.tokenListObserver.stop();
  };

  ValueListObserver.prototype.refresh = function () {
    this.tokenListObserver.refresh();
  };

  Object.defineProperty(ValueListObserver.prototype, "element", {
    get: function () {
      return this.tokenListObserver.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(ValueListObserver.prototype, "attributeName", {
    get: function () {
      return this.tokenListObserver.attributeName;
    },
    enumerable: false,
    configurable: true
  });

  ValueListObserver.prototype.tokenMatched = function (token) {
    var element = token.element;
    var value = this.fetchParseResultForToken(token).value;

    if (value) {
      this.fetchValuesByTokenForElement(element).set(token, value);
      this.delegate.elementMatchedValue(element, value);
    }
  };

  ValueListObserver.prototype.tokenUnmatched = function (token) {
    var element = token.element;
    var value = this.fetchParseResultForToken(token).value;

    if (value) {
      this.fetchValuesByTokenForElement(element).delete(token);
      this.delegate.elementUnmatchedValue(element, value);
    }
  };

  ValueListObserver.prototype.fetchParseResultForToken = function (token) {
    var parseResult = this.parseResultsByToken.get(token);

    if (!parseResult) {
      parseResult = this.parseToken(token);
      this.parseResultsByToken.set(token, parseResult);
    }

    return parseResult;
  };

  ValueListObserver.prototype.fetchValuesByTokenForElement = function (element) {
    var valuesByToken = this.valuesByTokenByElement.get(element);

    if (!valuesByToken) {
      valuesByToken = new Map();
      this.valuesByTokenByElement.set(element, valuesByToken);
    }

    return valuesByToken;
  };

  ValueListObserver.prototype.parseToken = function (token) {
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

var BindingObserver =
/** @class */
function () {
  function BindingObserver(context, delegate) {
    this.context = context;
    this.delegate = delegate;
    this.bindingsByAction = new Map();
  }

  BindingObserver.prototype.start = function () {
    if (!this.valueListObserver) {
      this.valueListObserver = new ValueListObserver(this.element, this.actionAttribute, this);
      this.valueListObserver.start();
    }
  };

  BindingObserver.prototype.stop = function () {
    if (this.valueListObserver) {
      this.valueListObserver.stop();
      delete this.valueListObserver;
      this.disconnectAllActions();
    }
  };

  Object.defineProperty(BindingObserver.prototype, "element", {
    get: function () {
      return this.context.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "identifier", {
    get: function () {
      return this.context.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "actionAttribute", {
    get: function () {
      return this.schema.actionAttribute;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "schema", {
    get: function () {
      return this.context.schema;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(BindingObserver.prototype, "bindings", {
    get: function () {
      return Array.from(this.bindingsByAction.values());
    },
    enumerable: false,
    configurable: true
  });

  BindingObserver.prototype.connectAction = function (action) {
    var binding = new Binding(this.context, action);
    this.bindingsByAction.set(action, binding);
    this.delegate.bindingConnected(binding);
  };

  BindingObserver.prototype.disconnectAction = function (action) {
    var binding = this.bindingsByAction.get(action);

    if (binding) {
      this.bindingsByAction.delete(action);
      this.delegate.bindingDisconnected(binding);
    }
  };

  BindingObserver.prototype.disconnectAllActions = function () {
    var _this = this;

    this.bindings.forEach(function (binding) {
      return _this.delegate.bindingDisconnected(binding);
    });
    this.bindingsByAction.clear();
  }; // Value observer delegate


  BindingObserver.prototype.parseValueForToken = function (token) {
    var action = Action.forToken(token);

    if (action.identifier == this.identifier) {
      return action;
    }
  };

  BindingObserver.prototype.elementMatchedValue = function (element, action) {
    this.connectAction(action);
  };

  BindingObserver.prototype.elementUnmatchedValue = function (element, action) {
    this.disconnectAction(action);
  };

  return BindingObserver;
}();

var ValueObserver =
/** @class */
function () {
  function ValueObserver(context, receiver) {
    this.context = context;
    this.receiver = receiver;
    this.stringMapObserver = new StringMapObserver(this.element, this);
    this.valueDescriptorMap = this.controller.valueDescriptorMap;
    this.invokeChangedCallbacksForDefaultValues();
  }

  ValueObserver.prototype.start = function () {
    this.stringMapObserver.start();
  };

  ValueObserver.prototype.stop = function () {
    this.stringMapObserver.stop();
  };

  Object.defineProperty(ValueObserver.prototype, "element", {
    get: function () {
      return this.context.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(ValueObserver.prototype, "controller", {
    get: function () {
      return this.context.controller;
    },
    enumerable: false,
    configurable: true
  }); // String map observer delegate

  ValueObserver.prototype.getStringMapKeyForAttribute = function (attributeName) {
    if (attributeName in this.valueDescriptorMap) {
      return this.valueDescriptorMap[attributeName].name;
    }
  };

  ValueObserver.prototype.stringMapValueChanged = function (attributeValue, name) {
    this.invokeChangedCallbackForValue(name);
  };

  ValueObserver.prototype.invokeChangedCallbacksForDefaultValues = function () {
    for (var _i = 0, _a = this.valueDescriptors; _i < _a.length; _i++) {
      var _b = _a[_i],
          key = _b.key,
          name_1 = _b.name,
          defaultValue = _b.defaultValue;

      if (defaultValue != undefined && !this.controller.data.has(key)) {
        this.invokeChangedCallbackForValue(name_1);
      }
    }
  };

  ValueObserver.prototype.invokeChangedCallbackForValue = function (name) {
    var methodName = name + "Changed";
    var method = this.receiver[methodName];

    if (typeof method == "function") {
      var value = this.receiver[name];
      method.call(this.receiver, value);
    }
  };

  Object.defineProperty(ValueObserver.prototype, "valueDescriptors", {
    get: function () {
      var valueDescriptorMap = this.valueDescriptorMap;
      return Object.keys(valueDescriptorMap).map(function (key) {
        return valueDescriptorMap[key];
      });
    },
    enumerable: false,
    configurable: true
  });
  return ValueObserver;
}();

var Context =
/** @class */
function () {
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

  Context.prototype.connect = function () {
    this.bindingObserver.start();
    this.valueObserver.start();

    try {
      this.controller.connect();
    } catch (error) {
      this.handleError(error, "connecting controller");
    }
  };

  Context.prototype.disconnect = function () {
    try {
      this.controller.disconnect();
    } catch (error) {
      this.handleError(error, "disconnecting controller");
    }

    this.valueObserver.stop();
    this.bindingObserver.stop();
  };

  Object.defineProperty(Context.prototype, "application", {
    get: function () {
      return this.module.application;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "identifier", {
    get: function () {
      return this.module.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "schema", {
    get: function () {
      return this.application.schema;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "dispatcher", {
    get: function () {
      return this.application.dispatcher;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "element", {
    get: function () {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Context.prototype, "parentElement", {
    get: function () {
      return this.element.parentElement;
    },
    enumerable: false,
    configurable: true
  }); // Error handling

  Context.prototype.handleError = function (error, message, detail) {
    if (detail === void 0) {
      detail = {};
    }

    var _a = this,
        identifier = _a.identifier,
        controller = _a.controller,
        element = _a.element;

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
  return Array.from(ancestors.reduce(function (values, constructor) {
    getOwnStaticArrayValues(constructor, propertyName).forEach(function (name) {
      return values.add(name);
    });
    return values;
  }, new Set()));
}
function readInheritableStaticObjectPairs(constructor, propertyName) {
  var ancestors = getAncestorsForConstructor(constructor);
  return ancestors.reduce(function (pairs, constructor) {
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
  return definition ? Object.keys(definition).map(function (key) {
    return [key, definition[key]];
  }) : [];
}

var __extends = window && window.__extends || function () {
  var extendStatics = function (d, b) {
    extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    };

    return extendStatics(d, b);
  };

  return function (d, b) {
    extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __spreadArrays$3 = window && window.__spreadArrays || function () {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;

  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++) r[k] = a[j];

  return r;
};
/** @hidden */

function bless(constructor) {
  return shadow(constructor, getBlessedProperties(constructor));
}

function shadow(constructor, properties) {
  var shadowConstructor = extend$2(constructor);
  var shadowProperties = getShadowProperties(constructor.prototype, properties);
  Object.defineProperties(shadowConstructor.prototype, shadowProperties);
  return shadowConstructor;
}

function getBlessedProperties(constructor) {
  var blessings = readInheritableStaticArrayValues(constructor, "blessings");
  return blessings.reduce(function (blessedProperties, blessing) {
    var properties = blessing(constructor);

    for (var key in properties) {
      var descriptor = blessedProperties[key] || {};
      blessedProperties[key] = Object.assign(descriptor, properties[key]);
    }

    return blessedProperties;
  }, {});
}

function getShadowProperties(prototype, properties) {
  return getOwnKeys(properties).reduce(function (shadowProperties, key) {
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

var getOwnKeys = function () {
  if (typeof Object.getOwnPropertySymbols == "function") {
    return function (object) {
      return __spreadArrays$3(Object.getOwnPropertyNames(object), Object.getOwnPropertySymbols(object));
    };
  } else {
    return Object.getOwnPropertyNames;
  }
}();

var extend$2 = function () {
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
    var a = function () {
      this.a.call(this);
    };

    var b = extendWithReflect(a);

    b.prototype.a = function () {};

    return new b();
  }

  try {
    testReflectExtension();
    return extendWithReflect;
  } catch (error) {
    return function (constructor) {
      return (
        /** @class */
        function (_super) {
          __extends(extended, _super);

          function extended() {
            return _super !== null && _super.apply(this, arguments) || this;
          }

          return extended;
        }(constructor)
      );
    };
  }
}();

/** @hidden */

function blessDefinition(definition) {
  return {
    identifier: definition.identifier,
    controllerConstructor: bless(definition.controllerConstructor)
  };
}

var Module =
/** @class */
function () {
  function Module(application, definition) {
    this.application = application;
    this.definition = blessDefinition(definition);
    this.contextsByScope = new WeakMap();
    this.connectedContexts = new Set();
  }

  Object.defineProperty(Module.prototype, "identifier", {
    get: function () {
      return this.definition.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Module.prototype, "controllerConstructor", {
    get: function () {
      return this.definition.controllerConstructor;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Module.prototype, "contexts", {
    get: function () {
      return Array.from(this.connectedContexts);
    },
    enumerable: false,
    configurable: true
  });

  Module.prototype.connectContextForScope = function (scope) {
    var context = this.fetchContextForScope(scope);
    this.connectedContexts.add(context);
    context.connect();
  };

  Module.prototype.disconnectContextForScope = function (scope) {
    var context = this.contextsByScope.get(scope);

    if (context) {
      this.connectedContexts.delete(context);
      context.disconnect();
    }
  };

  Module.prototype.fetchContextForScope = function (scope) {
    var context = this.contextsByScope.get(scope);

    if (!context) {
      context = new Context(this, scope);
      this.contextsByScope.set(scope, context);
    }

    return context;
  };

  return Module;
}();

var ClassMap =
/** @class */
function () {
  function ClassMap(scope) {
    this.scope = scope;
  }

  ClassMap.prototype.has = function (name) {
    return this.data.has(this.getDataKey(name));
  };

  ClassMap.prototype.get = function (name) {
    return this.data.get(this.getDataKey(name));
  };

  ClassMap.prototype.getAttributeName = function (name) {
    return this.data.getAttributeNameForKey(this.getDataKey(name));
  };

  ClassMap.prototype.getDataKey = function (name) {
    return name + "-class";
  };

  Object.defineProperty(ClassMap.prototype, "data", {
    get: function () {
      return this.scope.data;
    },
    enumerable: false,
    configurable: true
  });
  return ClassMap;
}();

function camelize(value) {
  return value.replace(/(?:[_-])([a-z0-9])/g, function (_, char) {
    return char.toUpperCase();
  });
}
function capitalize(value) {
  return value.charAt(0).toUpperCase() + value.slice(1);
}
function dasherize(value) {
  return value.replace(/([A-Z])/g, function (_, char) {
    return "-" + char.toLowerCase();
  });
}

var DataMap =
/** @class */
function () {
  function DataMap(scope) {
    this.scope = scope;
  }

  Object.defineProperty(DataMap.prototype, "element", {
    get: function () {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(DataMap.prototype, "identifier", {
    get: function () {
      return this.scope.identifier;
    },
    enumerable: false,
    configurable: true
  });

  DataMap.prototype.get = function (key) {
    var name = this.getAttributeNameForKey(key);
    return this.element.getAttribute(name);
  };

  DataMap.prototype.set = function (key, value) {
    var name = this.getAttributeNameForKey(key);
    this.element.setAttribute(name, value);
    return this.get(key);
  };

  DataMap.prototype.has = function (key) {
    var name = this.getAttributeNameForKey(key);
    return this.element.hasAttribute(name);
  };

  DataMap.prototype.delete = function (key) {
    if (this.has(key)) {
      var name_1 = this.getAttributeNameForKey(key);
      this.element.removeAttribute(name_1);
      return true;
    } else {
      return false;
    }
  };

  DataMap.prototype.getAttributeNameForKey = function (key) {
    return "data-" + this.identifier + "-" + dasherize(key);
  };

  return DataMap;
}();

var Guide =
/** @class */
function () {
  function Guide(logger) {
    this.warnedKeysByObject = new WeakMap();
    this.logger = logger;
  }

  Guide.prototype.warn = function (object, key, message) {
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

/** @hidden */
function attributeValueContainsToken(attributeName, token) {
  return "[" + attributeName + "~=\"" + token + "\"]";
}

var __spreadArrays$2 = window && window.__spreadArrays || function () {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;

  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++) r[k] = a[j];

  return r;
};

var TargetSet =
/** @class */
function () {
  function TargetSet(scope) {
    this.scope = scope;
  }

  Object.defineProperty(TargetSet.prototype, "element", {
    get: function () {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(TargetSet.prototype, "identifier", {
    get: function () {
      return this.scope.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(TargetSet.prototype, "schema", {
    get: function () {
      return this.scope.schema;
    },
    enumerable: false,
    configurable: true
  });

  TargetSet.prototype.has = function (targetName) {
    return this.find(targetName) != null;
  };

  TargetSet.prototype.find = function () {
    var _this = this;

    var targetNames = [];

    for (var _i = 0; _i < arguments.length; _i++) {
      targetNames[_i] = arguments[_i];
    }

    return targetNames.reduce(function (target, targetName) {
      return target || _this.findTarget(targetName) || _this.findLegacyTarget(targetName);
    }, undefined);
  };

  TargetSet.prototype.findAll = function () {
    var _this = this;

    var targetNames = [];

    for (var _i = 0; _i < arguments.length; _i++) {
      targetNames[_i] = arguments[_i];
    }

    return targetNames.reduce(function (targets, targetName) {
      return __spreadArrays$2(targets, _this.findAllTargets(targetName), _this.findAllLegacyTargets(targetName));
    }, []);
  };

  TargetSet.prototype.findTarget = function (targetName) {
    var selector = this.getSelectorForTargetName(targetName);
    return this.scope.findElement(selector);
  };

  TargetSet.prototype.findAllTargets = function (targetName) {
    var selector = this.getSelectorForTargetName(targetName);
    return this.scope.findAllElements(selector);
  };

  TargetSet.prototype.getSelectorForTargetName = function (targetName) {
    var attributeName = "data-" + this.identifier + "-target";
    return attributeValueContainsToken(attributeName, targetName);
  };

  TargetSet.prototype.findLegacyTarget = function (targetName) {
    var selector = this.getLegacySelectorForTargetName(targetName);
    return this.deprecate(this.scope.findElement(selector), targetName);
  };

  TargetSet.prototype.findAllLegacyTargets = function (targetName) {
    var _this = this;

    var selector = this.getLegacySelectorForTargetName(targetName);
    return this.scope.findAllElements(selector).map(function (element) {
      return _this.deprecate(element, targetName);
    });
  };

  TargetSet.prototype.getLegacySelectorForTargetName = function (targetName) {
    var targetDescriptor = this.identifier + "." + targetName;
    return attributeValueContainsToken(this.schema.targetAttribute, targetDescriptor);
  };

  TargetSet.prototype.deprecate = function (element, targetName) {
    if (element) {
      var identifier = this.identifier;
      var attributeName = this.schema.targetAttribute;
      this.guide.warn(element, "target:" + targetName, "Please replace " + attributeName + "=\"" + identifier + "." + targetName + "\" with data-" + identifier + "-target=\"" + targetName + "\". " + ("The " + attributeName + " attribute is deprecated and will be removed in a future version of Stimulus."));
    }

    return element;
  };

  Object.defineProperty(TargetSet.prototype, "guide", {
    get: function () {
      return this.scope.guide;
    },
    enumerable: false,
    configurable: true
  });
  return TargetSet;
}();

var __spreadArrays$1 = window && window.__spreadArrays || function () {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;

  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++) r[k] = a[j];

  return r;
};

var Scope =
/** @class */
function () {
  function Scope(schema, element, identifier, logger) {
    var _this = this;

    this.targets = new TargetSet(this);
    this.classes = new ClassMap(this);
    this.data = new DataMap(this);

    this.containsElement = function (element) {
      return element.closest(_this.controllerSelector) === _this.element;
    };

    this.schema = schema;
    this.element = element;
    this.identifier = identifier;
    this.guide = new Guide(logger);
  }

  Scope.prototype.findElement = function (selector) {
    return this.element.matches(selector) ? this.element : this.queryElements(selector).find(this.containsElement);
  };

  Scope.prototype.findAllElements = function (selector) {
    return __spreadArrays$1(this.element.matches(selector) ? [this.element] : [], this.queryElements(selector).filter(this.containsElement));
  };

  Scope.prototype.queryElements = function (selector) {
    return Array.from(this.element.querySelectorAll(selector));
  };

  Object.defineProperty(Scope.prototype, "controllerSelector", {
    get: function () {
      return attributeValueContainsToken(this.schema.controllerAttribute, this.identifier);
    },
    enumerable: false,
    configurable: true
  });
  return Scope;
}();

var ScopeObserver =
/** @class */
function () {
  function ScopeObserver(element, schema, delegate) {
    this.element = element;
    this.schema = schema;
    this.delegate = delegate;
    this.valueListObserver = new ValueListObserver(this.element, this.controllerAttribute, this);
    this.scopesByIdentifierByElement = new WeakMap();
    this.scopeReferenceCounts = new WeakMap();
  }

  ScopeObserver.prototype.start = function () {
    this.valueListObserver.start();
  };

  ScopeObserver.prototype.stop = function () {
    this.valueListObserver.stop();
  };

  Object.defineProperty(ScopeObserver.prototype, "controllerAttribute", {
    get: function () {
      return this.schema.controllerAttribute;
    },
    enumerable: false,
    configurable: true
  }); // Value observer delegate

  /** @hidden */

  ScopeObserver.prototype.parseValueForToken = function (token) {
    var element = token.element,
        identifier = token.content;
    var scopesByIdentifier = this.fetchScopesByIdentifierForElement(element);
    var scope = scopesByIdentifier.get(identifier);

    if (!scope) {
      scope = this.delegate.createScopeForElementAndIdentifier(element, identifier);
      scopesByIdentifier.set(identifier, scope);
    }

    return scope;
  };
  /** @hidden */


  ScopeObserver.prototype.elementMatchedValue = function (element, value) {
    var referenceCount = (this.scopeReferenceCounts.get(value) || 0) + 1;
    this.scopeReferenceCounts.set(value, referenceCount);

    if (referenceCount == 1) {
      this.delegate.scopeConnected(value);
    }
  };
  /** @hidden */


  ScopeObserver.prototype.elementUnmatchedValue = function (element, value) {
    var referenceCount = this.scopeReferenceCounts.get(value);

    if (referenceCount) {
      this.scopeReferenceCounts.set(value, referenceCount - 1);

      if (referenceCount == 1) {
        this.delegate.scopeDisconnected(value);
      }
    }
  };

  ScopeObserver.prototype.fetchScopesByIdentifierForElement = function (element) {
    var scopesByIdentifier = this.scopesByIdentifierByElement.get(element);

    if (!scopesByIdentifier) {
      scopesByIdentifier = new Map();
      this.scopesByIdentifierByElement.set(element, scopesByIdentifier);
    }

    return scopesByIdentifier;
  };

  return ScopeObserver;
}();

var Router =
/** @class */
function () {
  function Router(application) {
    this.application = application;
    this.scopeObserver = new ScopeObserver(this.element, this.schema, this);
    this.scopesByIdentifier = new Multimap();
    this.modulesByIdentifier = new Map();
  }

  Object.defineProperty(Router.prototype, "element", {
    get: function () {
      return this.application.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "schema", {
    get: function () {
      return this.application.schema;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "logger", {
    get: function () {
      return this.application.logger;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "controllerAttribute", {
    get: function () {
      return this.schema.controllerAttribute;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "modules", {
    get: function () {
      return Array.from(this.modulesByIdentifier.values());
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Router.prototype, "contexts", {
    get: function () {
      return this.modules.reduce(function (contexts, module) {
        return contexts.concat(module.contexts);
      }, []);
    },
    enumerable: false,
    configurable: true
  });

  Router.prototype.start = function () {
    this.scopeObserver.start();
  };

  Router.prototype.stop = function () {
    this.scopeObserver.stop();
  };

  Router.prototype.loadDefinition = function (definition) {
    this.unloadIdentifier(definition.identifier);
    var module = new Module(this.application, definition);
    this.connectModule(module);
  };

  Router.prototype.unloadIdentifier = function (identifier) {
    var module = this.modulesByIdentifier.get(identifier);

    if (module) {
      this.disconnectModule(module);
    }
  };

  Router.prototype.getContextForElementAndIdentifier = function (element, identifier) {
    var module = this.modulesByIdentifier.get(identifier);

    if (module) {
      return module.contexts.find(function (context) {
        return context.element == element;
      });
    }
  }; // Error handler delegate

  /** @hidden */


  Router.prototype.handleError = function (error, message, detail) {
    this.application.handleError(error, message, detail);
  }; // Scope observer delegate

  /** @hidden */


  Router.prototype.createScopeForElementAndIdentifier = function (element, identifier) {
    return new Scope(this.schema, element, identifier, this.logger);
  };
  /** @hidden */


  Router.prototype.scopeConnected = function (scope) {
    this.scopesByIdentifier.add(scope.identifier, scope);
    var module = this.modulesByIdentifier.get(scope.identifier);

    if (module) {
      module.connectContextForScope(scope);
    }
  };
  /** @hidden */


  Router.prototype.scopeDisconnected = function (scope) {
    this.scopesByIdentifier.delete(scope.identifier, scope);
    var module = this.modulesByIdentifier.get(scope.identifier);

    if (module) {
      module.disconnectContextForScope(scope);
    }
  }; // Modules


  Router.prototype.connectModule = function (module) {
    this.modulesByIdentifier.set(module.identifier, module);
    var scopes = this.scopesByIdentifier.getValuesForKey(module.identifier);
    scopes.forEach(function (scope) {
      return module.connectContextForScope(scope);
    });
  };

  Router.prototype.disconnectModule = function (module) {
    this.modulesByIdentifier.delete(module.identifier);
    var scopes = this.scopesByIdentifier.getValuesForKey(module.identifier);
    scopes.forEach(function (scope) {
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

var __awaiter = window && window.__awaiter || function (thisArg, _arguments, P, generator) {
  function adopt(value) {
    return value instanceof P ? value : new P(function (resolve) {
      resolve(value);
    });
  }

  return new (P || (P = Promise))(function (resolve, reject) {
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

var __generator = window && window.__generator || function (thisArg, body) {
  var _ = {
    label: 0,
    sent: function () {
      if (t[0] & 1) throw t[1];
      return t[1];
    },
    trys: [],
    ops: []
  },
      f,
      y,
      t,
      g;
  return g = {
    next: verb(0),
    "throw": verb(1),
    "return": verb(2)
  }, typeof Symbol === "function" && (g[Symbol.iterator] = function () {
    return this;
  }), g;

  function verb(n) {
    return function (v) {
      return step([n, v]);
    };
  }

  function step(op) {
    if (f) throw new TypeError("Generator is already executing.");

    while (_) try {
      if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
      if (y = 0, t) op = [op[0] & 2, t.value];

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
          op = [0];
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
      op = [6, e];
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

var __spreadArrays = window && window.__spreadArrays || function () {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;

  for (var r = Array(s), k = 0, i = 0; i < il; i++) for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++) r[k] = a[j];

  return r;
};

var Application =
/** @class */
function () {
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

  Application.start = function (element, schema) {
    var application = new Application(element, schema);
    application.start();
    return application;
  };

  Application.prototype.start = function () {
    return __awaiter(this, void 0, void 0, function () {
      return __generator(this, function (_a) {
        switch (_a.label) {
          case 0:
            return [4
            /*yield*/
            , domReady()];

          case 1:
            _a.sent();

            this.dispatcher.start();
            this.router.start();
            return [2
            /*return*/
            ];
        }
      });
    });
  };

  Application.prototype.stop = function () {
    this.dispatcher.stop();
    this.router.stop();
  };

  Application.prototype.register = function (identifier, controllerConstructor) {
    this.load({
      identifier: identifier,
      controllerConstructor: controllerConstructor
    });
  };

  Application.prototype.load = function (head) {
    var _this = this;

    var rest = [];

    for (var _i = 1; _i < arguments.length; _i++) {
      rest[_i - 1] = arguments[_i];
    }

    var definitions = Array.isArray(head) ? head : __spreadArrays([head], rest);
    definitions.forEach(function (definition) {
      return _this.router.loadDefinition(definition);
    });
  };

  Application.prototype.unload = function (head) {
    var _this = this;

    var rest = [];

    for (var _i = 1; _i < arguments.length; _i++) {
      rest[_i - 1] = arguments[_i];
    }

    var identifiers = Array.isArray(head) ? head : __spreadArrays([head], rest);
    identifiers.forEach(function (identifier) {
      return _this.router.unloadIdentifier(identifier);
    });
  };

  Object.defineProperty(Application.prototype, "controllers", {
    // Controllers
    get: function () {
      return this.router.contexts.map(function (context) {
        return context.controller;
      });
    },
    enumerable: false,
    configurable: true
  });

  Application.prototype.getControllerForElementAndIdentifier = function (element, identifier) {
    var context = this.router.getContextForElementAndIdentifier(element, identifier);
    return context ? context.controller : null;
  }; // Error handling


  Application.prototype.handleError = function (error, message, detail) {
    this.logger.error("%s\n\n%o\n\n%o", message, error, detail);
  };

  return Application;
}();

function domReady() {
  return new Promise(function (resolve) {
    if (document.readyState == "loading") {
      document.addEventListener("DOMContentLoaded", resolve);
    } else {
      resolve();
    }
  });
}

/** @hidden */

function ClassPropertiesBlessing(constructor) {
  var classes = readInheritableStaticArrayValues(constructor, "classes");
  return classes.reduce(function (properties, classDefinition) {
    return Object.assign(properties, propertiesForClassDefinition(classDefinition));
  }, {});
}

function propertiesForClassDefinition(key) {
  var _a;

  var name = key + "Class";
  return _a = {}, _a[name] = {
    get: function () {
      var classes = this.classes;

      if (classes.has(key)) {
        return classes.get(key);
      } else {
        var attribute = classes.getAttributeName(key);
        throw new Error("Missing attribute \"" + attribute + "\"");
      }
    }
  }, _a["has" + capitalize(name)] = {
    get: function () {
      return this.classes.has(key);
    }
  }, _a;
}

/** @hidden */

function TargetPropertiesBlessing(constructor) {
  var targets = readInheritableStaticArrayValues(constructor, "targets");
  return targets.reduce(function (properties, targetDefinition) {
    return Object.assign(properties, propertiesForTargetDefinition(targetDefinition));
  }, {});
}

function propertiesForTargetDefinition(name) {
  var _a;

  return _a = {}, _a[name + "Target"] = {
    get: function () {
      var target = this.targets.find(name);

      if (target) {
        return target;
      } else {
        throw new Error("Missing target element \"" + this.identifier + "." + name + "\"");
      }
    }
  }, _a[name + "Targets"] = {
    get: function () {
      return this.targets.findAll(name);
    }
  }, _a["has" + capitalize(name) + "Target"] = {
    get: function () {
      return this.targets.has(name);
    }
  }, _a;
}

/** @hidden */

function ValuePropertiesBlessing(constructor) {
  var valueDefinitionPairs = readInheritableStaticObjectPairs(constructor, "values");
  var propertyDescriptorMap = {
    valueDescriptorMap: {
      get: function () {
        var _this = this;

        return valueDefinitionPairs.reduce(function (result, valueDefinitionPair) {
          var _a;

          var valueDescriptor = parseValueDefinitionPair(valueDefinitionPair);

          var attributeName = _this.data.getAttributeNameForKey(valueDescriptor.key);

          return Object.assign(result, (_a = {}, _a[attributeName] = valueDescriptor, _a));
        }, {});
      }
    }
  };
  return valueDefinitionPairs.reduce(function (properties, valueDefinitionPair) {
    return Object.assign(properties, propertiesForValueDefinitionPair(valueDefinitionPair));
  }, propertyDescriptorMap);
}
/** @hidden */

function propertiesForValueDefinitionPair(valueDefinitionPair) {
  var _a;

  var definition = parseValueDefinitionPair(valueDefinitionPair);
  var type = definition.type,
      key = definition.key,
      name = definition.name;
  var read = readers[type],
      write = writers[type] || writers.default;
  return _a = {}, _a[name] = {
    get: function () {
      var value = this.data.get(key);

      if (value !== null) {
        return read(value);
      } else {
        return definition.defaultValue;
      }
    },
    set: function (value) {
      if (value === undefined) {
        this.data.delete(key);
      } else {
        this.data.set(key, write(value));
      }
    }
  }, _a["has" + capitalize(name)] = {
    get: function () {
      return this.data.has(key);
    }
  }, _a;
}

function parseValueDefinitionPair(_a) {
  var token = _a[0],
      typeConstant = _a[1];
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

  throw new Error("Unknown value type constant \"" + typeConstant + "\"");
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
  array: function (value) {
    var array = JSON.parse(value);

    if (!Array.isArray(array)) {
      throw new TypeError("Expected array");
    }

    return array;
  },
  boolean: function (value) {
    return !(value == "0" || value == "false");
  },
  number: function (value) {
    return parseFloat(value);
  },
  object: function (value) {
    var object = JSON.parse(value);

    if (object === null || typeof object != "object" || Array.isArray(object)) {
      throw new TypeError("Expected object");
    }

    return object;
  },
  string: function (value) {
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

var Controller =
/** @class */
function () {
  function Controller(context) {
    this.context = context;
  }

  Object.defineProperty(Controller.prototype, "application", {
    get: function () {
      return this.context.application;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "scope", {
    get: function () {
      return this.context.scope;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "element", {
    get: function () {
      return this.scope.element;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "identifier", {
    get: function () {
      return this.scope.identifier;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "targets", {
    get: function () {
      return this.scope.targets;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "classes", {
    get: function () {
      return this.scope.classes;
    },
    enumerable: false,
    configurable: true
  });
  Object.defineProperty(Controller.prototype, "data", {
    get: function () {
      return this.scope.data;
    },
    enumerable: false,
    configurable: true
  });

  Controller.prototype.initialize = function () {// Override in your subclass to set up initial controller state
  };

  Controller.prototype.connect = function () {// Override in your subclass to respond when the controller is connected to the DOM
  };

  Controller.prototype.disconnect = function () {// Override in your subclass to respond when the controller is disconnected from the DOM
  };

  Controller.blessings = [ClassPropertiesBlessing, TargetPropertiesBlessing, ValuePropertiesBlessing];
  Controller.targets = [];
  Controller.values = {};
  return Controller;
}();

/*
Turbo 7.1.0
Copyright © 2021 Basecamp, LLC
 */
(function () {
  if (window.Reflect === undefined || window.customElements === undefined || window.customElements.polyfillWrapFlushCallback) {
    return;
  }

  const BuiltInHTMLElement = HTMLElement;
  const wrapperForTheName = {
    'HTMLElement': function HTMLElement() {
      return Reflect.construct(BuiltInHTMLElement, [], this.constructor);
    }
  };
  window.HTMLElement = wrapperForTheName['HTMLElement'];
  HTMLElement.prototype = BuiltInHTMLElement.prototype;
  HTMLElement.prototype.constructor = HTMLElement;
  Object.setPrototypeOf(HTMLElement, BuiltInHTMLElement);
})();
/**
 * The MIT License (MIT)
 * 
 * Copyright (c) 2019 Javan Makhmali
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


(function (prototype) {
  if (typeof prototype.requestSubmit == "function") return;

  prototype.requestSubmit = function (submitter) {
    if (submitter) {
      validateSubmitter(submitter, this);
      submitter.click();
    } else {
      submitter = document.createElement("input");
      submitter.type = "submit";
      submitter.hidden = true;
      this.appendChild(submitter);
      submitter.click();
      this.removeChild(submitter);
    }
  };

  function validateSubmitter(submitter, form) {
    submitter instanceof HTMLElement || raise(TypeError, "parameter 1 is not of type 'HTMLElement'");
    submitter.type == "submit" || raise(TypeError, "The specified element is not a submit button");
    submitter.form == form || raise(DOMException, "The specified element is not owned by this form element", "NotFoundError");
  }

  function raise(errorConstructor, message, name) {
    throw new errorConstructor("Failed to execute 'requestSubmit' on 'HTMLFormElement': " + message + ".", name);
  }
})(HTMLFormElement.prototype);

const submittersByForm = new WeakMap();

function findSubmitterFromClickTarget(target) {
  const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null;
  const candidate = element ? element.closest("input, button") : null;
  return (candidate === null || candidate === void 0 ? void 0 : candidate.type) == "submit" ? candidate : null;
}

function clickCaptured(event) {
  const submitter = findSubmitterFromClickTarget(event.target);

  if (submitter && submitter.form) {
    submittersByForm.set(submitter.form, submitter);
  }
}

(function () {
  if ("submitter" in Event.prototype) return;
  let prototype;

  if ("SubmitEvent" in window && /Apple Computer/.test(navigator.vendor)) {
    prototype = window.SubmitEvent.prototype;
  } else if ("SubmitEvent" in window) {
    return;
  } else {
    prototype = window.Event.prototype;
  }

  addEventListener("click", clickCaptured, true);
  Object.defineProperty(prototype, "submitter", {
    get() {
      if (this.type == "submit" && this.target instanceof HTMLFormElement) {
        return submittersByForm.get(this.target);
      }
    }

  });
})();

var FrameLoadingStyle;

(function (FrameLoadingStyle) {
  FrameLoadingStyle["eager"] = "eager";
  FrameLoadingStyle["lazy"] = "lazy";
})(FrameLoadingStyle || (FrameLoadingStyle = {}));

class FrameElement extends HTMLElement {
  constructor() {
    super();
    this.loaded = Promise.resolve();
    this.delegate = new FrameElement.delegateConstructor(this);
  }

  static get observedAttributes() {
    return ["disabled", "loading", "src"];
  }

  connectedCallback() {
    this.delegate.connect();
  }

  disconnectedCallback() {
    this.delegate.disconnect();
  }

  reload() {
    const {
      src
    } = this;
    this.src = null;
    this.src = src;
  }

  attributeChangedCallback(name) {
    if (name == "loading") {
      this.delegate.loadingStyleChanged();
    } else if (name == "src") {
      this.delegate.sourceURLChanged();
    } else {
      this.delegate.disabledChanged();
    }
  }

  get src() {
    return this.getAttribute("src");
  }

  set src(value) {
    if (value) {
      this.setAttribute("src", value);
    } else {
      this.removeAttribute("src");
    }
  }

  get loading() {
    return frameLoadingStyleFromString(this.getAttribute("loading") || "");
  }

  set loading(value) {
    if (value) {
      this.setAttribute("loading", value);
    } else {
      this.removeAttribute("loading");
    }
  }

  get disabled() {
    return this.hasAttribute("disabled");
  }

  set disabled(value) {
    if (value) {
      this.setAttribute("disabled", "");
    } else {
      this.removeAttribute("disabled");
    }
  }

  get autoscroll() {
    return this.hasAttribute("autoscroll");
  }

  set autoscroll(value) {
    if (value) {
      this.setAttribute("autoscroll", "");
    } else {
      this.removeAttribute("autoscroll");
    }
  }

  get complete() {
    return !this.delegate.isLoading;
  }

  get isActive() {
    return this.ownerDocument === document && !this.isPreview;
  }

  get isPreview() {
    var _a, _b;

    return (_b = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.documentElement) === null || _b === void 0 ? void 0 : _b.hasAttribute("data-turbo-preview");
  }

}

function frameLoadingStyleFromString(style) {
  switch (style.toLowerCase()) {
    case "lazy":
      return FrameLoadingStyle.lazy;

    default:
      return FrameLoadingStyle.eager;
  }
}

function expandURL(locatable) {
  return new URL(locatable.toString(), document.baseURI);
}

function getAnchor(url) {
  let anchorMatch;

  if (url.hash) {
    return url.hash.slice(1);
  } else if (anchorMatch = url.href.match(/#(.*)$/)) {
    return anchorMatch[1];
  }
}

function getAction(form, submitter) {
  const action = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formaction")) || form.getAttribute("action") || form.action;
  return expandURL(action);
}

function getExtension(url) {
  return (getLastPathComponent(url).match(/\.[^.]*$/) || [])[0] || "";
}

function isHTML(url) {
  return !!getExtension(url).match(/^(?:|\.(?:htm|html|xhtml))$/);
}

function isPrefixedBy(baseURL, url) {
  const prefix = getPrefix(url);
  return baseURL.href === expandURL(prefix).href || baseURL.href.startsWith(prefix);
}

function locationIsVisitable(location, rootLocation) {
  return isPrefixedBy(location, rootLocation) && isHTML(location);
}

function getRequestURL(url) {
  const anchor = getAnchor(url);
  return anchor != null ? url.href.slice(0, -(anchor.length + 1)) : url.href;
}

function toCacheKey(url) {
  return getRequestURL(url);
}

function urlsAreEqual(left, right) {
  return expandURL(left).href == expandURL(right).href;
}

function getPathComponents(url) {
  return url.pathname.split("/").slice(1);
}

function getLastPathComponent(url) {
  return getPathComponents(url).slice(-1)[0];
}

function getPrefix(url) {
  return addTrailingSlash(url.origin + url.pathname);
}

function addTrailingSlash(value) {
  return value.endsWith("/") ? value : value + "/";
}

class FetchResponse {
  constructor(response) {
    this.response = response;
  }

  get succeeded() {
    return this.response.ok;
  }

  get failed() {
    return !this.succeeded;
  }

  get clientError() {
    return this.statusCode >= 400 && this.statusCode <= 499;
  }

  get serverError() {
    return this.statusCode >= 500 && this.statusCode <= 599;
  }

  get redirected() {
    return this.response.redirected;
  }

  get location() {
    return expandURL(this.response.url);
  }

  get isHTML() {
    return this.contentType && this.contentType.match(/^(?:text\/([^\s;,]+\b)?html|application\/xhtml\+xml)\b/);
  }

  get statusCode() {
    return this.response.status;
  }

  get contentType() {
    return this.header("Content-Type");
  }

  get responseText() {
    return this.response.clone().text();
  }

  get responseHTML() {
    if (this.isHTML) {
      return this.response.clone().text();
    } else {
      return Promise.resolve(undefined);
    }
  }

  header(name) {
    return this.response.headers.get(name);
  }

}

function dispatch(eventName, {
  target,
  cancelable,
  detail
} = {}) {
  const event = new CustomEvent(eventName, {
    cancelable,
    bubbles: true,
    detail
  });

  if (target && target.isConnected) {
    target.dispatchEvent(event);
  } else {
    document.documentElement.dispatchEvent(event);
  }

  return event;
}

function nextAnimationFrame() {
  return new Promise(resolve => requestAnimationFrame(() => resolve()));
}

function nextEventLoopTick() {
  return new Promise(resolve => setTimeout(() => resolve(), 0));
}

function nextMicrotask() {
  return Promise.resolve();
}

function parseHTMLDocument(html = "") {
  return new DOMParser().parseFromString(html, "text/html");
}

function unindent(strings, ...values) {
  const lines = interpolate(strings, values).replace(/^\n/, "").split("\n");
  const match = lines[0].match(/^\s+/);
  const indent = match ? match[0].length : 0;
  return lines.map(line => line.slice(indent)).join("\n");
}

function interpolate(strings, values) {
  return strings.reduce((result, string, i) => {
    const value = values[i] == undefined ? "" : values[i];
    return result + string + value;
  }, "");
}

function uuid() {
  return Array.apply(null, {
    length: 36
  }).map((_, i) => {
    if (i == 8 || i == 13 || i == 18 || i == 23) {
      return "-";
    } else if (i == 14) {
      return "4";
    } else if (i == 19) {
      return (Math.floor(Math.random() * 4) + 8).toString(16);
    } else {
      return Math.floor(Math.random() * 15).toString(16);
    }
  }).join("");
}

function getAttribute(attributeName, ...elements) {
  for (const value of elements.map(element => element === null || element === void 0 ? void 0 : element.getAttribute(attributeName))) {
    if (typeof value == "string") return value;
  }

  return null;
}

function markAsBusy(...elements) {
  for (const element of elements) {
    if (element.localName == "turbo-frame") {
      element.setAttribute("busy", "");
    }

    element.setAttribute("aria-busy", "true");
  }
}

function clearBusyState(...elements) {
  for (const element of elements) {
    if (element.localName == "turbo-frame") {
      element.removeAttribute("busy");
    }

    element.removeAttribute("aria-busy");
  }
}

var FetchMethod;

(function (FetchMethod) {
  FetchMethod[FetchMethod["get"] = 0] = "get";
  FetchMethod[FetchMethod["post"] = 1] = "post";
  FetchMethod[FetchMethod["put"] = 2] = "put";
  FetchMethod[FetchMethod["patch"] = 3] = "patch";
  FetchMethod[FetchMethod["delete"] = 4] = "delete";
})(FetchMethod || (FetchMethod = {}));

function fetchMethodFromString(method) {
  switch (method.toLowerCase()) {
    case "get":
      return FetchMethod.get;

    case "post":
      return FetchMethod.post;

    case "put":
      return FetchMethod.put;

    case "patch":
      return FetchMethod.patch;

    case "delete":
      return FetchMethod.delete;
  }
}

class FetchRequest {
  constructor(delegate, method, location, body = new URLSearchParams(), target = null) {
    this.abortController = new AbortController();

    this.resolveRequestPromise = value => {};

    this.delegate = delegate;
    this.method = method;
    this.headers = this.defaultHeaders;
    this.body = body;
    this.url = location;
    this.target = target;
  }

  get location() {
    return this.url;
  }

  get params() {
    return this.url.searchParams;
  }

  get entries() {
    return this.body ? Array.from(this.body.entries()) : [];
  }

  cancel() {
    this.abortController.abort();
  }

  async perform() {
    var _a, _b;

    const {
      fetchOptions
    } = this;
    (_b = (_a = this.delegate).prepareHeadersForRequest) === null || _b === void 0 ? void 0 : _b.call(_a, this.headers, this);
    await this.allowRequestToBeIntercepted(fetchOptions);

    try {
      this.delegate.requestStarted(this);
      const response = await fetch(this.url.href, fetchOptions);
      return await this.receive(response);
    } catch (error) {
      if (error.name !== 'AbortError') {
        this.delegate.requestErrored(this, error);
        throw error;
      }
    } finally {
      this.delegate.requestFinished(this);
    }
  }

  async receive(response) {
    const fetchResponse = new FetchResponse(response);
    const event = dispatch("turbo:before-fetch-response", {
      cancelable: true,
      detail: {
        fetchResponse
      },
      target: this.target
    });

    if (event.defaultPrevented) {
      this.delegate.requestPreventedHandlingResponse(this, fetchResponse);
    } else if (fetchResponse.succeeded) {
      this.delegate.requestSucceededWithResponse(this, fetchResponse);
    } else {
      this.delegate.requestFailedWithResponse(this, fetchResponse);
    }

    return fetchResponse;
  }

  get fetchOptions() {
    var _a;

    return {
      method: FetchMethod[this.method].toUpperCase(),
      credentials: "same-origin",
      headers: this.headers,
      redirect: "follow",
      body: this.isIdempotent ? null : this.body,
      signal: this.abortSignal,
      referrer: (_a = this.delegate.referrer) === null || _a === void 0 ? void 0 : _a.href
    };
  }

  get defaultHeaders() {
    return {
      "Accept": "text/html, application/xhtml+xml"
    };
  }

  get isIdempotent() {
    return this.method == FetchMethod.get;
  }

  get abortSignal() {
    return this.abortController.signal;
  }

  async allowRequestToBeIntercepted(fetchOptions) {
    const requestInterception = new Promise(resolve => this.resolveRequestPromise = resolve);
    const event = dispatch("turbo:before-fetch-request", {
      cancelable: true,
      detail: {
        fetchOptions,
        url: this.url,
        resume: this.resolveRequestPromise
      },
      target: this.target
    });
    if (event.defaultPrevented) await requestInterception;
  }

}

class AppearanceObserver {
  constructor(delegate, element) {
    this.started = false;

    this.intersect = entries => {
      const lastEntry = entries.slice(-1)[0];

      if (lastEntry === null || lastEntry === void 0 ? void 0 : lastEntry.isIntersecting) {
        this.delegate.elementAppearedInViewport(this.element);
      }
    };

    this.delegate = delegate;
    this.element = element;
    this.intersectionObserver = new IntersectionObserver(this.intersect);
  }

  start() {
    if (!this.started) {
      this.started = true;
      this.intersectionObserver.observe(this.element);
    }
  }

  stop() {
    if (this.started) {
      this.started = false;
      this.intersectionObserver.unobserve(this.element);
    }
  }

}

class StreamMessage {
  constructor(html) {
    this.templateElement = document.createElement("template");
    this.templateElement.innerHTML = html;
  }

  static wrap(message) {
    if (typeof message == "string") {
      return new this(message);
    } else {
      return message;
    }
  }

  get fragment() {
    const fragment = document.createDocumentFragment();

    for (const element of this.foreignElements) {
      fragment.appendChild(document.importNode(element, true));
    }

    return fragment;
  }

  get foreignElements() {
    return this.templateChildren.reduce((streamElements, child) => {
      if (child.tagName.toLowerCase() == "turbo-stream") {
        return [...streamElements, child];
      } else {
        return streamElements;
      }
    }, []);
  }

  get templateChildren() {
    return Array.from(this.templateElement.content.children);
  }

}

StreamMessage.contentType = "text/vnd.turbo-stream.html";
var FormSubmissionState;

(function (FormSubmissionState) {
  FormSubmissionState[FormSubmissionState["initialized"] = 0] = "initialized";
  FormSubmissionState[FormSubmissionState["requesting"] = 1] = "requesting";
  FormSubmissionState[FormSubmissionState["waiting"] = 2] = "waiting";
  FormSubmissionState[FormSubmissionState["receiving"] = 3] = "receiving";
  FormSubmissionState[FormSubmissionState["stopping"] = 4] = "stopping";
  FormSubmissionState[FormSubmissionState["stopped"] = 5] = "stopped";
})(FormSubmissionState || (FormSubmissionState = {}));

var FormEnctype;

(function (FormEnctype) {
  FormEnctype["urlEncoded"] = "application/x-www-form-urlencoded";
  FormEnctype["multipart"] = "multipart/form-data";
  FormEnctype["plain"] = "text/plain";
})(FormEnctype || (FormEnctype = {}));

function formEnctypeFromString(encoding) {
  switch (encoding.toLowerCase()) {
    case FormEnctype.multipart:
      return FormEnctype.multipart;

    case FormEnctype.plain:
      return FormEnctype.plain;

    default:
      return FormEnctype.urlEncoded;
  }
}

class FormSubmission {
  constructor(delegate, formElement, submitter, mustRedirect = false) {
    this.state = FormSubmissionState.initialized;
    this.delegate = delegate;
    this.formElement = formElement;
    this.submitter = submitter;
    this.formData = buildFormData(formElement, submitter);
    this.location = expandURL(this.action);

    if (this.method == FetchMethod.get) {
      mergeFormDataEntries(this.location, [...this.body.entries()]);
    }

    this.fetchRequest = new FetchRequest(this, this.method, this.location, this.body, this.formElement);
    this.mustRedirect = mustRedirect;
  }

  static confirmMethod(message, element) {
    return confirm(message);
  }

  get method() {
    var _a;

    const method = ((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formmethod")) || this.formElement.getAttribute("method") || "";
    return fetchMethodFromString(method.toLowerCase()) || FetchMethod.get;
  }

  get action() {
    var _a;

    const formElementAction = typeof this.formElement.action === 'string' ? this.formElement.action : null;
    return ((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formaction")) || this.formElement.getAttribute("action") || formElementAction || "";
  }

  get body() {
    if (this.enctype == FormEnctype.urlEncoded || this.method == FetchMethod.get) {
      return new URLSearchParams(this.stringFormData);
    } else {
      return this.formData;
    }
  }

  get enctype() {
    var _a;

    return formEnctypeFromString(((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formenctype")) || this.formElement.enctype);
  }

  get isIdempotent() {
    return this.fetchRequest.isIdempotent;
  }

  get stringFormData() {
    return [...this.formData].reduce((entries, [name, value]) => {
      return entries.concat(typeof value == "string" ? [[name, value]] : []);
    }, []);
  }

  get confirmationMessage() {
    return this.formElement.getAttribute("data-turbo-confirm");
  }

  get needsConfirmation() {
    return this.confirmationMessage !== null;
  }

  async start() {
    const {
      initialized,
      requesting
    } = FormSubmissionState;

    if (this.needsConfirmation) {
      const answer = FormSubmission.confirmMethod(this.confirmationMessage, this.formElement);

      if (!answer) {
        return;
      }
    }

    if (this.state == initialized) {
      this.state = requesting;
      return this.fetchRequest.perform();
    }
  }

  stop() {
    const {
      stopping,
      stopped
    } = FormSubmissionState;

    if (this.state != stopping && this.state != stopped) {
      this.state = stopping;
      this.fetchRequest.cancel();
      return true;
    }
  }

  prepareHeadersForRequest(headers, request) {
    if (!request.isIdempotent) {
      const token = getCookieValue(getMetaContent("csrf-param")) || getMetaContent("csrf-token");

      if (token) {
        headers["X-CSRF-Token"] = token;
      }

      headers["Accept"] = [StreamMessage.contentType, headers["Accept"]].join(", ");
    }
  }

  requestStarted(request) {
    var _a;

    this.state = FormSubmissionState.waiting;
    (_a = this.submitter) === null || _a === void 0 ? void 0 : _a.setAttribute("disabled", "");
    dispatch("turbo:submit-start", {
      target: this.formElement,
      detail: {
        formSubmission: this
      }
    });
    this.delegate.formSubmissionStarted(this);
  }

  requestPreventedHandlingResponse(request, response) {
    this.result = {
      success: response.succeeded,
      fetchResponse: response
    };
  }

  requestSucceededWithResponse(request, response) {
    if (response.clientError || response.serverError) {
      this.delegate.formSubmissionFailedWithResponse(this, response);
    } else if (this.requestMustRedirect(request) && responseSucceededWithoutRedirect(response)) {
      const error = new Error("Form responses must redirect to another location");
      this.delegate.formSubmissionErrored(this, error);
    } else {
      this.state = FormSubmissionState.receiving;
      this.result = {
        success: true,
        fetchResponse: response
      };
      this.delegate.formSubmissionSucceededWithResponse(this, response);
    }
  }

  requestFailedWithResponse(request, response) {
    this.result = {
      success: false,
      fetchResponse: response
    };
    this.delegate.formSubmissionFailedWithResponse(this, response);
  }

  requestErrored(request, error) {
    this.result = {
      success: false,
      error
    };
    this.delegate.formSubmissionErrored(this, error);
  }

  requestFinished(request) {
    var _a;

    this.state = FormSubmissionState.stopped;
    (_a = this.submitter) === null || _a === void 0 ? void 0 : _a.removeAttribute("disabled");
    dispatch("turbo:submit-end", {
      target: this.formElement,
      detail: Object.assign({
        formSubmission: this
      }, this.result)
    });
    this.delegate.formSubmissionFinished(this);
  }

  requestMustRedirect(request) {
    return !request.isIdempotent && this.mustRedirect;
  }

}

function buildFormData(formElement, submitter) {
  const formData = new FormData(formElement);
  const name = submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("name");
  const value = submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("value");

  if (name && value != null && formData.get(name) != value) {
    formData.append(name, value);
  }

  return formData;
}

function getCookieValue(cookieName) {
  if (cookieName != null) {
    const cookies = document.cookie ? document.cookie.split("; ") : [];
    const cookie = cookies.find(cookie => cookie.startsWith(cookieName));

    if (cookie) {
      const value = cookie.split("=").slice(1).join("=");
      return value ? decodeURIComponent(value) : undefined;
    }
  }
}

function getMetaContent(name) {
  const element = document.querySelector(`meta[name="${name}"]`);
  return element && element.content;
}

function responseSucceededWithoutRedirect(response) {
  return response.statusCode == 200 && !response.redirected;
}

function mergeFormDataEntries(url, entries) {
  const searchParams = new URLSearchParams();

  for (const [name, value] of entries) {
    if (value instanceof File) continue;
    searchParams.append(name, value);
  }

  url.search = searchParams.toString();
  return url;
}

class Snapshot {
  constructor(element) {
    this.element = element;
  }

  get children() {
    return [...this.element.children];
  }

  hasAnchor(anchor) {
    return this.getElementForAnchor(anchor) != null;
  }

  getElementForAnchor(anchor) {
    return anchor ? this.element.querySelector(`[id='${anchor}'], a[name='${anchor}']`) : null;
  }

  get isConnected() {
    return this.element.isConnected;
  }

  get firstAutofocusableElement() {
    return this.element.querySelector("[autofocus]");
  }

  get permanentElements() {
    return [...this.element.querySelectorAll("[id][data-turbo-permanent]")];
  }

  getPermanentElementById(id) {
    return this.element.querySelector(`#${id}[data-turbo-permanent]`);
  }

  getPermanentElementMapForSnapshot(snapshot) {
    const permanentElementMap = {};

    for (const currentPermanentElement of this.permanentElements) {
      const {
        id
      } = currentPermanentElement;
      const newPermanentElement = snapshot.getPermanentElementById(id);

      if (newPermanentElement) {
        permanentElementMap[id] = [currentPermanentElement, newPermanentElement];
      }
    }

    return permanentElementMap;
  }

}

class FormInterceptor {
  constructor(delegate, element) {
    this.submitBubbled = event => {
      const form = event.target;

      if (!event.defaultPrevented && form instanceof HTMLFormElement && form.closest("turbo-frame, html") == this.element) {
        const submitter = event.submitter || undefined;
        const method = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formmethod")) || form.method;

        if (method != "dialog" && this.delegate.shouldInterceptFormSubmission(form, submitter)) {
          event.preventDefault();
          event.stopImmediatePropagation();
          this.delegate.formSubmissionIntercepted(form, submitter);
        }
      }
    };

    this.delegate = delegate;
    this.element = element;
  }

  start() {
    this.element.addEventListener("submit", this.submitBubbled);
  }

  stop() {
    this.element.removeEventListener("submit", this.submitBubbled);
  }

}

class View {
  constructor(delegate, element) {
    this.resolveRenderPromise = value => {};

    this.resolveInterceptionPromise = value => {};

    this.delegate = delegate;
    this.element = element;
  }

  scrollToAnchor(anchor) {
    const element = this.snapshot.getElementForAnchor(anchor);

    if (element) {
      this.scrollToElement(element);
      this.focusElement(element);
    } else {
      this.scrollToPosition({
        x: 0,
        y: 0
      });
    }
  }

  scrollToAnchorFromLocation(location) {
    this.scrollToAnchor(getAnchor(location));
  }

  scrollToElement(element) {
    element.scrollIntoView();
  }

  focusElement(element) {
    if (element instanceof HTMLElement) {
      if (element.hasAttribute("tabindex")) {
        element.focus();
      } else {
        element.setAttribute("tabindex", "-1");
        element.focus();
        element.removeAttribute("tabindex");
      }
    }
  }

  scrollToPosition({
    x,
    y
  }) {
    this.scrollRoot.scrollTo(x, y);
  }

  scrollToTop() {
    this.scrollToPosition({
      x: 0,
      y: 0
    });
  }

  get scrollRoot() {
    return window;
  }

  async render(renderer) {
    const {
      isPreview,
      shouldRender,
      newSnapshot: snapshot
    } = renderer;

    if (shouldRender) {
      try {
        this.renderPromise = new Promise(resolve => this.resolveRenderPromise = resolve);
        this.renderer = renderer;
        this.prepareToRenderSnapshot(renderer);
        const renderInterception = new Promise(resolve => this.resolveInterceptionPromise = resolve);
        const immediateRender = this.delegate.allowsImmediateRender(snapshot, this.resolveInterceptionPromise);
        if (!immediateRender) await renderInterception;
        await this.renderSnapshot(renderer);
        this.delegate.viewRenderedSnapshot(snapshot, isPreview);
        this.finishRenderingSnapshot(renderer);
      } finally {
        delete this.renderer;
        this.resolveRenderPromise(undefined);
        delete this.renderPromise;
      }
    } else {
      this.invalidate();
    }
  }

  invalidate() {
    this.delegate.viewInvalidated();
  }

  prepareToRenderSnapshot(renderer) {
    this.markAsPreview(renderer.isPreview);
    renderer.prepareToRender();
  }

  markAsPreview(isPreview) {
    if (isPreview) {
      this.element.setAttribute("data-turbo-preview", "");
    } else {
      this.element.removeAttribute("data-turbo-preview");
    }
  }

  async renderSnapshot(renderer) {
    await renderer.render();
  }

  finishRenderingSnapshot(renderer) {
    renderer.finishRendering();
  }

}

class FrameView extends View {
  invalidate() {
    this.element.innerHTML = "";
  }

  get snapshot() {
    return new Snapshot(this.element);
  }

}

class LinkInterceptor {
  constructor(delegate, element) {
    this.clickBubbled = event => {
      if (this.respondsToEventTarget(event.target)) {
        this.clickEvent = event;
      } else {
        delete this.clickEvent;
      }
    };

    this.linkClicked = event => {
      if (this.clickEvent && this.respondsToEventTarget(event.target) && event.target instanceof Element) {
        if (this.delegate.shouldInterceptLinkClick(event.target, event.detail.url)) {
          this.clickEvent.preventDefault();
          event.preventDefault();
          this.delegate.linkClickIntercepted(event.target, event.detail.url);
        }
      }

      delete this.clickEvent;
    };

    this.willVisit = () => {
      delete this.clickEvent;
    };

    this.delegate = delegate;
    this.element = element;
  }

  start() {
    this.element.addEventListener("click", this.clickBubbled);
    document.addEventListener("turbo:click", this.linkClicked);
    document.addEventListener("turbo:before-visit", this.willVisit);
  }

  stop() {
    this.element.removeEventListener("click", this.clickBubbled);
    document.removeEventListener("turbo:click", this.linkClicked);
    document.removeEventListener("turbo:before-visit", this.willVisit);
  }

  respondsToEventTarget(target) {
    const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null;
    return element && element.closest("turbo-frame, html") == this.element;
  }

}

class Bardo {
  constructor(permanentElementMap) {
    this.permanentElementMap = permanentElementMap;
  }

  static preservingPermanentElements(permanentElementMap, callback) {
    const bardo = new this(permanentElementMap);
    bardo.enter();
    callback();
    bardo.leave();
  }

  enter() {
    for (const id in this.permanentElementMap) {
      const [, newPermanentElement] = this.permanentElementMap[id];
      this.replaceNewPermanentElementWithPlaceholder(newPermanentElement);
    }
  }

  leave() {
    for (const id in this.permanentElementMap) {
      const [currentPermanentElement] = this.permanentElementMap[id];
      this.replaceCurrentPermanentElementWithClone(currentPermanentElement);
      this.replacePlaceholderWithPermanentElement(currentPermanentElement);
    }
  }

  replaceNewPermanentElementWithPlaceholder(permanentElement) {
    const placeholder = createPlaceholderForPermanentElement(permanentElement);
    permanentElement.replaceWith(placeholder);
  }

  replaceCurrentPermanentElementWithClone(permanentElement) {
    const clone = permanentElement.cloneNode(true);
    permanentElement.replaceWith(clone);
  }

  replacePlaceholderWithPermanentElement(permanentElement) {
    const placeholder = this.getPlaceholderById(permanentElement.id);
    placeholder === null || placeholder === void 0 ? void 0 : placeholder.replaceWith(permanentElement);
  }

  getPlaceholderById(id) {
    return this.placeholders.find(element => element.content == id);
  }

  get placeholders() {
    return [...document.querySelectorAll("meta[name=turbo-permanent-placeholder][content]")];
  }

}

function createPlaceholderForPermanentElement(permanentElement) {
  const element = document.createElement("meta");
  element.setAttribute("name", "turbo-permanent-placeholder");
  element.setAttribute("content", permanentElement.id);
  return element;
}

class Renderer {
  constructor(currentSnapshot, newSnapshot, isPreview, willRender = true) {
    this.currentSnapshot = currentSnapshot;
    this.newSnapshot = newSnapshot;
    this.isPreview = isPreview;
    this.willRender = willRender;
    this.promise = new Promise((resolve, reject) => this.resolvingFunctions = {
      resolve,
      reject
    });
  }

  get shouldRender() {
    return true;
  }

  prepareToRender() {
    return;
  }

  finishRendering() {
    if (this.resolvingFunctions) {
      this.resolvingFunctions.resolve();
      delete this.resolvingFunctions;
    }
  }

  createScriptElement(element) {
    if (element.getAttribute("data-turbo-eval") == "false") {
      return element;
    } else {
      const createdScriptElement = document.createElement("script");

      if (this.cspNonce) {
        createdScriptElement.nonce = this.cspNonce;
      }

      createdScriptElement.textContent = element.textContent;
      createdScriptElement.async = false;
      copyElementAttributes(createdScriptElement, element);
      return createdScriptElement;
    }
  }

  preservingPermanentElements(callback) {
    Bardo.preservingPermanentElements(this.permanentElementMap, callback);
  }

  focusFirstAutofocusableElement() {
    const element = this.connectedSnapshot.firstAutofocusableElement;

    if (elementIsFocusable(element)) {
      element.focus();
    }
  }

  get connectedSnapshot() {
    return this.newSnapshot.isConnected ? this.newSnapshot : this.currentSnapshot;
  }

  get currentElement() {
    return this.currentSnapshot.element;
  }

  get newElement() {
    return this.newSnapshot.element;
  }

  get permanentElementMap() {
    return this.currentSnapshot.getPermanentElementMapForSnapshot(this.newSnapshot);
  }

  get cspNonce() {
    var _a;

    return (_a = document.head.querySelector('meta[name="csp-nonce"]')) === null || _a === void 0 ? void 0 : _a.getAttribute("content");
  }

}

function copyElementAttributes(destinationElement, sourceElement) {
  for (const {
    name,
    value
  } of [...sourceElement.attributes]) {
    destinationElement.setAttribute(name, value);
  }
}

function elementIsFocusable(element) {
  return element && typeof element.focus == "function";
}

class FrameRenderer extends Renderer {
  get shouldRender() {
    return true;
  }

  async render() {
    await nextAnimationFrame();
    this.preservingPermanentElements(() => {
      this.loadFrameElement();
    });
    this.scrollFrameIntoView();
    await nextAnimationFrame();
    this.focusFirstAutofocusableElement();
    await nextAnimationFrame();
    this.activateScriptElements();
  }

  loadFrameElement() {
    var _a;

    const destinationRange = document.createRange();
    destinationRange.selectNodeContents(this.currentElement);
    destinationRange.deleteContents();
    const frameElement = this.newElement;
    const sourceRange = (_a = frameElement.ownerDocument) === null || _a === void 0 ? void 0 : _a.createRange();

    if (sourceRange) {
      sourceRange.selectNodeContents(frameElement);
      this.currentElement.appendChild(sourceRange.extractContents());
    }
  }

  scrollFrameIntoView() {
    if (this.currentElement.autoscroll || this.newElement.autoscroll) {
      const element = this.currentElement.firstElementChild;
      const block = readScrollLogicalPosition(this.currentElement.getAttribute("data-autoscroll-block"), "end");

      if (element) {
        element.scrollIntoView({
          block
        });
        return true;
      }
    }

    return false;
  }

  activateScriptElements() {
    for (const inertScriptElement of this.newScriptElements) {
      const activatedScriptElement = this.createScriptElement(inertScriptElement);
      inertScriptElement.replaceWith(activatedScriptElement);
    }
  }

  get newScriptElements() {
    return this.currentElement.querySelectorAll("script");
  }

}

function readScrollLogicalPosition(value, defaultValue) {
  if (value == "end" || value == "start" || value == "center" || value == "nearest") {
    return value;
  } else {
    return defaultValue;
  }
}

class ProgressBar {
  constructor() {
    this.hiding = false;
    this.value = 0;
    this.visible = false;

    this.trickle = () => {
      this.setValue(this.value + Math.random() / 100);
    };

    this.stylesheetElement = this.createStylesheetElement();
    this.progressElement = this.createProgressElement();
    this.installStylesheetElement();
    this.setValue(0);
  }

  static get defaultCSS() {
    return unindent`
      .turbo-progress-bar {
        position: fixed;
        display: block;
        top: 0;
        left: 0;
        height: 3px;
        background: #0076ff;
        z-index: 9999;
        transition:
          width ${ProgressBar.animationDuration}ms ease-out,
          opacity ${ProgressBar.animationDuration / 2}ms ${ProgressBar.animationDuration / 2}ms ease-in;
        transform: translate3d(0, 0, 0);
      }
    `;
  }

  show() {
    if (!this.visible) {
      this.visible = true;
      this.installProgressElement();
      this.startTrickling();
    }
  }

  hide() {
    if (this.visible && !this.hiding) {
      this.hiding = true;
      this.fadeProgressElement(() => {
        this.uninstallProgressElement();
        this.stopTrickling();
        this.visible = false;
        this.hiding = false;
      });
    }
  }

  setValue(value) {
    this.value = value;
    this.refresh();
  }

  installStylesheetElement() {
    document.head.insertBefore(this.stylesheetElement, document.head.firstChild);
  }

  installProgressElement() {
    this.progressElement.style.width = "0";
    this.progressElement.style.opacity = "1";
    document.documentElement.insertBefore(this.progressElement, document.body);
    this.refresh();
  }

  fadeProgressElement(callback) {
    this.progressElement.style.opacity = "0";
    setTimeout(callback, ProgressBar.animationDuration * 1.5);
  }

  uninstallProgressElement() {
    if (this.progressElement.parentNode) {
      document.documentElement.removeChild(this.progressElement);
    }
  }

  startTrickling() {
    if (!this.trickleInterval) {
      this.trickleInterval = window.setInterval(this.trickle, ProgressBar.animationDuration);
    }
  }

  stopTrickling() {
    window.clearInterval(this.trickleInterval);
    delete this.trickleInterval;
  }

  refresh() {
    requestAnimationFrame(() => {
      this.progressElement.style.width = `${10 + this.value * 90}%`;
    });
  }

  createStylesheetElement() {
    const element = document.createElement("style");
    element.type = "text/css";
    element.textContent = ProgressBar.defaultCSS;
    return element;
  }

  createProgressElement() {
    const element = document.createElement("div");
    element.className = "turbo-progress-bar";
    return element;
  }

}

ProgressBar.animationDuration = 300;

class HeadSnapshot extends Snapshot {
  constructor() {
    super(...arguments);
    this.detailsByOuterHTML = this.children.filter(element => !elementIsNoscript(element)).map(element => elementWithoutNonce(element)).reduce((result, element) => {
      const {
        outerHTML
      } = element;
      const details = outerHTML in result ? result[outerHTML] : {
        type: elementType(element),
        tracked: elementIsTracked(element),
        elements: []
      };
      return Object.assign(Object.assign({}, result), {
        [outerHTML]: Object.assign(Object.assign({}, details), {
          elements: [...details.elements, element]
        })
      });
    }, {});
  }

  get trackedElementSignature() {
    return Object.keys(this.detailsByOuterHTML).filter(outerHTML => this.detailsByOuterHTML[outerHTML].tracked).join("");
  }

  getScriptElementsNotInSnapshot(snapshot) {
    return this.getElementsMatchingTypeNotInSnapshot("script", snapshot);
  }

  getStylesheetElementsNotInSnapshot(snapshot) {
    return this.getElementsMatchingTypeNotInSnapshot("stylesheet", snapshot);
  }

  getElementsMatchingTypeNotInSnapshot(matchedType, snapshot) {
    return Object.keys(this.detailsByOuterHTML).filter(outerHTML => !(outerHTML in snapshot.detailsByOuterHTML)).map(outerHTML => this.detailsByOuterHTML[outerHTML]).filter(({
      type
    }) => type == matchedType).map(({
      elements: [element]
    }) => element);
  }

  get provisionalElements() {
    return Object.keys(this.detailsByOuterHTML).reduce((result, outerHTML) => {
      const {
        type,
        tracked,
        elements
      } = this.detailsByOuterHTML[outerHTML];

      if (type == null && !tracked) {
        return [...result, ...elements];
      } else if (elements.length > 1) {
        return [...result, ...elements.slice(1)];
      } else {
        return result;
      }
    }, []);
  }

  getMetaValue(name) {
    const element = this.findMetaElementByName(name);
    return element ? element.getAttribute("content") : null;
  }

  findMetaElementByName(name) {
    return Object.keys(this.detailsByOuterHTML).reduce((result, outerHTML) => {
      const {
        elements: [element]
      } = this.detailsByOuterHTML[outerHTML];
      return elementIsMetaElementWithName(element, name) ? element : result;
    }, undefined);
  }

}

function elementType(element) {
  if (elementIsScript(element)) {
    return "script";
  } else if (elementIsStylesheet(element)) {
    return "stylesheet";
  }
}

function elementIsTracked(element) {
  return element.getAttribute("data-turbo-track") == "reload";
}

function elementIsScript(element) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "script";
}

function elementIsNoscript(element) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "noscript";
}

function elementIsStylesheet(element) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "style" || tagName == "link" && element.getAttribute("rel") == "stylesheet";
}

function elementIsMetaElementWithName(element, name) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "meta" && element.getAttribute("name") == name;
}

function elementWithoutNonce(element) {
  if (element.hasAttribute("nonce")) {
    element.setAttribute("nonce", "");
  }

  return element;
}

class PageSnapshot extends Snapshot {
  constructor(element, headSnapshot) {
    super(element);
    this.headSnapshot = headSnapshot;
  }

  static fromHTMLString(html = "") {
    return this.fromDocument(parseHTMLDocument(html));
  }

  static fromElement(element) {
    return this.fromDocument(element.ownerDocument);
  }

  static fromDocument({
    head,
    body
  }) {
    return new this(body, new HeadSnapshot(head));
  }

  clone() {
    return new PageSnapshot(this.element.cloneNode(true), this.headSnapshot);
  }

  get headElement() {
    return this.headSnapshot.element;
  }

  get rootLocation() {
    var _a;

    const root = (_a = this.getSetting("root")) !== null && _a !== void 0 ? _a : "/";
    return expandURL(root);
  }

  get cacheControlValue() {
    return this.getSetting("cache-control");
  }

  get isPreviewable() {
    return this.cacheControlValue != "no-preview";
  }

  get isCacheable() {
    return this.cacheControlValue != "no-cache";
  }

  get isVisitable() {
    return this.getSetting("visit-control") != "reload";
  }

  getSetting(name) {
    return this.headSnapshot.getMetaValue(`turbo-${name}`);
  }

}

var TimingMetric;

(function (TimingMetric) {
  TimingMetric["visitStart"] = "visitStart";
  TimingMetric["requestStart"] = "requestStart";
  TimingMetric["requestEnd"] = "requestEnd";
  TimingMetric["visitEnd"] = "visitEnd";
})(TimingMetric || (TimingMetric = {}));

var VisitState;

(function (VisitState) {
  VisitState["initialized"] = "initialized";
  VisitState["started"] = "started";
  VisitState["canceled"] = "canceled";
  VisitState["failed"] = "failed";
  VisitState["completed"] = "completed";
})(VisitState || (VisitState = {}));

const defaultOptions = {
  action: "advance",
  historyChanged: false,
  visitCachedSnapshot: () => {},
  willRender: true
};
var SystemStatusCode;

(function (SystemStatusCode) {
  SystemStatusCode[SystemStatusCode["networkFailure"] = 0] = "networkFailure";
  SystemStatusCode[SystemStatusCode["timeoutFailure"] = -1] = "timeoutFailure";
  SystemStatusCode[SystemStatusCode["contentTypeMismatch"] = -2] = "contentTypeMismatch";
})(SystemStatusCode || (SystemStatusCode = {}));

class Visit {
  constructor(delegate, location, restorationIdentifier, options = {}) {
    this.identifier = uuid();
    this.timingMetrics = {};
    this.followedRedirect = false;
    this.historyChanged = false;
    this.scrolled = false;
    this.snapshotCached = false;
    this.state = VisitState.initialized;
    this.delegate = delegate;
    this.location = location;
    this.restorationIdentifier = restorationIdentifier || uuid();
    const {
      action,
      historyChanged,
      referrer,
      snapshotHTML,
      response,
      visitCachedSnapshot,
      willRender
    } = Object.assign(Object.assign({}, defaultOptions), options);
    this.action = action;
    this.historyChanged = historyChanged;
    this.referrer = referrer;
    this.snapshotHTML = snapshotHTML;
    this.response = response;
    this.isSamePage = this.delegate.locationWithActionIsSamePage(this.location, this.action);
    this.visitCachedSnapshot = visitCachedSnapshot;
    this.willRender = willRender;
    this.scrolled = !willRender;
  }

  get adapter() {
    return this.delegate.adapter;
  }

  get view() {
    return this.delegate.view;
  }

  get history() {
    return this.delegate.history;
  }

  get restorationData() {
    return this.history.getRestorationDataForIdentifier(this.restorationIdentifier);
  }

  get silent() {
    return this.isSamePage;
  }

  start() {
    if (this.state == VisitState.initialized) {
      this.recordTimingMetric(TimingMetric.visitStart);
      this.state = VisitState.started;
      this.adapter.visitStarted(this);
      this.delegate.visitStarted(this);
    }
  }

  cancel() {
    if (this.state == VisitState.started) {
      if (this.request) {
        this.request.cancel();
      }

      this.cancelRender();
      this.state = VisitState.canceled;
    }
  }

  complete() {
    if (this.state == VisitState.started) {
      this.recordTimingMetric(TimingMetric.visitEnd);
      this.state = VisitState.completed;
      this.adapter.visitCompleted(this);
      this.delegate.visitCompleted(this);
      this.followRedirect();
    }
  }

  fail() {
    if (this.state == VisitState.started) {
      this.state = VisitState.failed;
      this.adapter.visitFailed(this);
    }
  }

  changeHistory() {
    var _a;

    if (!this.historyChanged) {
      const actionForHistory = this.location.href === ((_a = this.referrer) === null || _a === void 0 ? void 0 : _a.href) ? "replace" : this.action;
      const method = this.getHistoryMethodForAction(actionForHistory);
      this.history.update(method, this.location, this.restorationIdentifier);
      this.historyChanged = true;
    }
  }

  issueRequest() {
    if (this.hasPreloadedResponse()) {
      this.simulateRequest();
    } else if (this.shouldIssueRequest() && !this.request) {
      this.request = new FetchRequest(this, FetchMethod.get, this.location);
      this.request.perform();
    }
  }

  simulateRequest() {
    if (this.response) {
      this.startRequest();
      this.recordResponse();
      this.finishRequest();
    }
  }

  startRequest() {
    this.recordTimingMetric(TimingMetric.requestStart);
    this.adapter.visitRequestStarted(this);
  }

  recordResponse(response = this.response) {
    this.response = response;

    if (response) {
      const {
        statusCode
      } = response;

      if (isSuccessful(statusCode)) {
        this.adapter.visitRequestCompleted(this);
      } else {
        this.adapter.visitRequestFailedWithStatusCode(this, statusCode);
      }
    }
  }

  finishRequest() {
    this.recordTimingMetric(TimingMetric.requestEnd);
    this.adapter.visitRequestFinished(this);
  }

  loadResponse() {
    if (this.response) {
      const {
        statusCode,
        responseHTML
      } = this.response;
      this.render(async () => {
        this.cacheSnapshot();
        if (this.view.renderPromise) await this.view.renderPromise;

        if (isSuccessful(statusCode) && responseHTML != null) {
          await this.view.renderPage(PageSnapshot.fromHTMLString(responseHTML), false, this.willRender);
          this.adapter.visitRendered(this);
          this.complete();
        } else {
          await this.view.renderError(PageSnapshot.fromHTMLString(responseHTML));
          this.adapter.visitRendered(this);
          this.fail();
        }
      });
    }
  }

  getCachedSnapshot() {
    const snapshot = this.view.getCachedSnapshotForLocation(this.location) || this.getPreloadedSnapshot();

    if (snapshot && (!getAnchor(this.location) || snapshot.hasAnchor(getAnchor(this.location)))) {
      if (this.action == "restore" || snapshot.isPreviewable) {
        return snapshot;
      }
    }
  }

  getPreloadedSnapshot() {
    if (this.snapshotHTML) {
      return PageSnapshot.fromHTMLString(this.snapshotHTML);
    }
  }

  hasCachedSnapshot() {
    return this.getCachedSnapshot() != null;
  }

  loadCachedSnapshot() {
    const snapshot = this.getCachedSnapshot();

    if (snapshot) {
      const isPreview = this.shouldIssueRequest();
      this.render(async () => {
        this.cacheSnapshot();

        if (this.isSamePage) {
          this.adapter.visitRendered(this);
        } else {
          if (this.view.renderPromise) await this.view.renderPromise;
          await this.view.renderPage(snapshot, isPreview, this.willRender);
          this.adapter.visitRendered(this);

          if (!isPreview) {
            this.complete();
          }
        }
      });
    }
  }

  followRedirect() {
    var _a;

    if (this.redirectedToLocation && !this.followedRedirect && ((_a = this.response) === null || _a === void 0 ? void 0 : _a.redirected)) {
      this.adapter.visitProposedToLocation(this.redirectedToLocation, {
        action: 'replace',
        response: this.response
      });
      this.followedRedirect = true;
    }
  }

  goToSamePageAnchor() {
    if (this.isSamePage) {
      this.render(async () => {
        this.cacheSnapshot();
        this.adapter.visitRendered(this);
      });
    }
  }

  requestStarted() {
    this.startRequest();
  }

  requestPreventedHandlingResponse(request, response) {}

  async requestSucceededWithResponse(request, response) {
    const responseHTML = await response.responseHTML;
    const {
      redirected,
      statusCode
    } = response;

    if (responseHTML == undefined) {
      this.recordResponse({
        statusCode: SystemStatusCode.contentTypeMismatch,
        redirected
      });
    } else {
      this.redirectedToLocation = response.redirected ? response.location : undefined;
      this.recordResponse({
        statusCode: statusCode,
        responseHTML,
        redirected
      });
    }
  }

  async requestFailedWithResponse(request, response) {
    const responseHTML = await response.responseHTML;
    const {
      redirected,
      statusCode
    } = response;

    if (responseHTML == undefined) {
      this.recordResponse({
        statusCode: SystemStatusCode.contentTypeMismatch,
        redirected
      });
    } else {
      this.recordResponse({
        statusCode: statusCode,
        responseHTML,
        redirected
      });
    }
  }

  requestErrored(request, error) {
    this.recordResponse({
      statusCode: SystemStatusCode.networkFailure,
      redirected: false
    });
  }

  requestFinished() {
    this.finishRequest();
  }

  performScroll() {
    if (!this.scrolled) {
      if (this.action == "restore") {
        this.scrollToRestoredPosition() || this.scrollToAnchor() || this.view.scrollToTop();
      } else {
        this.scrollToAnchor() || this.view.scrollToTop();
      }

      if (this.isSamePage) {
        this.delegate.visitScrolledToSamePageLocation(this.view.lastRenderedLocation, this.location);
      }

      this.scrolled = true;
    }
  }

  scrollToRestoredPosition() {
    const {
      scrollPosition
    } = this.restorationData;

    if (scrollPosition) {
      this.view.scrollToPosition(scrollPosition);
      return true;
    }
  }

  scrollToAnchor() {
    const anchor = getAnchor(this.location);

    if (anchor != null) {
      this.view.scrollToAnchor(anchor);
      return true;
    }
  }

  recordTimingMetric(metric) {
    this.timingMetrics[metric] = new Date().getTime();
  }

  getTimingMetrics() {
    return Object.assign({}, this.timingMetrics);
  }

  getHistoryMethodForAction(action) {
    switch (action) {
      case "replace":
        return history.replaceState;

      case "advance":
      case "restore":
        return history.pushState;
    }
  }

  hasPreloadedResponse() {
    return typeof this.response == "object";
  }

  shouldIssueRequest() {
    if (this.isSamePage) {
      return false;
    } else if (this.action == "restore") {
      return !this.hasCachedSnapshot();
    } else {
      return this.willRender;
    }
  }

  cacheSnapshot() {
    if (!this.snapshotCached) {
      this.view.cacheSnapshot().then(snapshot => snapshot && this.visitCachedSnapshot(snapshot));
      this.snapshotCached = true;
    }
  }

  async render(callback) {
    this.cancelRender();
    await new Promise(resolve => {
      this.frame = requestAnimationFrame(() => resolve());
    });
    await callback();
    delete this.frame;
    this.performScroll();
  }

  cancelRender() {
    if (this.frame) {
      cancelAnimationFrame(this.frame);
      delete this.frame;
    }
  }

}

function isSuccessful(statusCode) {
  return statusCode >= 200 && statusCode < 300;
}

class BrowserAdapter {
  constructor(session) {
    this.progressBar = new ProgressBar();

    this.showProgressBar = () => {
      this.progressBar.show();
    };

    this.session = session;
  }

  visitProposedToLocation(location, options) {
    this.navigator.startVisit(location, uuid(), options);
  }

  visitStarted(visit) {
    visit.loadCachedSnapshot();
    visit.issueRequest();
    visit.changeHistory();
    visit.goToSamePageAnchor();
  }

  visitRequestStarted(visit) {
    this.progressBar.setValue(0);

    if (visit.hasCachedSnapshot() || visit.action != "restore") {
      this.showVisitProgressBarAfterDelay();
    } else {
      this.showProgressBar();
    }
  }

  visitRequestCompleted(visit) {
    visit.loadResponse();
  }

  visitRequestFailedWithStatusCode(visit, statusCode) {
    switch (statusCode) {
      case SystemStatusCode.networkFailure:
      case SystemStatusCode.timeoutFailure:
      case SystemStatusCode.contentTypeMismatch:
        return this.reload();

      default:
        return visit.loadResponse();
    }
  }

  visitRequestFinished(visit) {
    this.progressBar.setValue(1);
    this.hideVisitProgressBar();
  }

  visitCompleted(visit) {}

  pageInvalidated() {
    this.reload();
  }

  visitFailed(visit) {}

  visitRendered(visit) {}

  formSubmissionStarted(formSubmission) {
    this.progressBar.setValue(0);
    this.showFormProgressBarAfterDelay();
  }

  formSubmissionFinished(formSubmission) {
    this.progressBar.setValue(1);
    this.hideFormProgressBar();
  }

  showVisitProgressBarAfterDelay() {
    this.visitProgressBarTimeout = window.setTimeout(this.showProgressBar, this.session.progressBarDelay);
  }

  hideVisitProgressBar() {
    this.progressBar.hide();

    if (this.visitProgressBarTimeout != null) {
      window.clearTimeout(this.visitProgressBarTimeout);
      delete this.visitProgressBarTimeout;
    }
  }

  showFormProgressBarAfterDelay() {
    if (this.formProgressBarTimeout == null) {
      this.formProgressBarTimeout = window.setTimeout(this.showProgressBar, this.session.progressBarDelay);
    }
  }

  hideFormProgressBar() {
    this.progressBar.hide();

    if (this.formProgressBarTimeout != null) {
      window.clearTimeout(this.formProgressBarTimeout);
      delete this.formProgressBarTimeout;
    }
  }

  reload() {
    window.location.reload();
  }

  get navigator() {
    return this.session.navigator;
  }

}

class CacheObserver {
  constructor() {
    this.started = false;
  }

  start() {
    if (!this.started) {
      this.started = true;
      addEventListener("turbo:before-cache", this.removeStaleElements, false);
    }
  }

  stop() {
    if (this.started) {
      this.started = false;
      removeEventListener("turbo:before-cache", this.removeStaleElements, false);
    }
  }

  removeStaleElements() {
    const staleElements = [...document.querySelectorAll('[data-turbo-cache="false"]')];

    for (const element of staleElements) {
      element.remove();
    }
  }

}

class FormSubmitObserver {
  constructor(delegate) {
    this.started = false;

    this.submitCaptured = () => {
      removeEventListener("submit", this.submitBubbled, false);
      addEventListener("submit", this.submitBubbled, false);
    };

    this.submitBubbled = event => {
      if (!event.defaultPrevented) {
        const form = event.target instanceof HTMLFormElement ? event.target : undefined;
        const submitter = event.submitter || undefined;

        if (form) {
          const method = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formmethod")) || form.getAttribute("method");

          if (method != "dialog" && this.delegate.willSubmitForm(form, submitter)) {
            event.preventDefault();
            this.delegate.formSubmitted(form, submitter);
          }
        }
      }
    };

    this.delegate = delegate;
  }

  start() {
    if (!this.started) {
      addEventListener("submit", this.submitCaptured, true);
      this.started = true;
    }
  }

  stop() {
    if (this.started) {
      removeEventListener("submit", this.submitCaptured, true);
      this.started = false;
    }
  }

}

class FrameRedirector {
  constructor(element) {
    this.element = element;
    this.linkInterceptor = new LinkInterceptor(this, element);
    this.formInterceptor = new FormInterceptor(this, element);
  }

  start() {
    this.linkInterceptor.start();
    this.formInterceptor.start();
  }

  stop() {
    this.linkInterceptor.stop();
    this.formInterceptor.stop();
  }

  shouldInterceptLinkClick(element, url) {
    return this.shouldRedirect(element);
  }

  linkClickIntercepted(element, url) {
    const frame = this.findFrameElement(element);

    if (frame) {
      frame.delegate.linkClickIntercepted(element, url);
    }
  }

  shouldInterceptFormSubmission(element, submitter) {
    return this.shouldSubmit(element, submitter);
  }

  formSubmissionIntercepted(element, submitter) {
    const frame = this.findFrameElement(element, submitter);

    if (frame) {
      frame.removeAttribute("reloadable");
      frame.delegate.formSubmissionIntercepted(element, submitter);
    }
  }

  shouldSubmit(form, submitter) {
    var _a;

    const action = getAction(form, submitter);
    const meta = this.element.ownerDocument.querySelector(`meta[name="turbo-root"]`);
    const rootLocation = expandURL((_a = meta === null || meta === void 0 ? void 0 : meta.content) !== null && _a !== void 0 ? _a : "/");
    return this.shouldRedirect(form, submitter) && locationIsVisitable(action, rootLocation);
  }

  shouldRedirect(element, submitter) {
    const frame = this.findFrameElement(element, submitter);
    return frame ? frame != element.closest("turbo-frame") : false;
  }

  findFrameElement(element, submitter) {
    const id = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("data-turbo-frame")) || element.getAttribute("data-turbo-frame");

    if (id && id != "_top") {
      const frame = this.element.querySelector(`#${id}:not([disabled])`);

      if (frame instanceof FrameElement) {
        return frame;
      }
    }
  }

}

class History {
  constructor(delegate) {
    this.restorationIdentifier = uuid();
    this.restorationData = {};
    this.started = false;
    this.pageLoaded = false;

    this.onPopState = event => {
      if (this.shouldHandlePopState()) {
        const {
          turbo
        } = event.state || {};

        if (turbo) {
          this.location = new URL(window.location.href);
          const {
            restorationIdentifier
          } = turbo;
          this.restorationIdentifier = restorationIdentifier;
          this.delegate.historyPoppedToLocationWithRestorationIdentifier(this.location, restorationIdentifier);
        }
      }
    };

    this.onPageLoad = async event => {
      await nextMicrotask();
      this.pageLoaded = true;
    };

    this.delegate = delegate;
  }

  start() {
    if (!this.started) {
      addEventListener("popstate", this.onPopState, false);
      addEventListener("load", this.onPageLoad, false);
      this.started = true;
      this.replace(new URL(window.location.href));
    }
  }

  stop() {
    if (this.started) {
      removeEventListener("popstate", this.onPopState, false);
      removeEventListener("load", this.onPageLoad, false);
      this.started = false;
    }
  }

  push(location, restorationIdentifier) {
    this.update(history.pushState, location, restorationIdentifier);
  }

  replace(location, restorationIdentifier) {
    this.update(history.replaceState, location, restorationIdentifier);
  }

  update(method, location, restorationIdentifier = uuid()) {
    const state = {
      turbo: {
        restorationIdentifier
      }
    };
    method.call(history, state, "", location.href);
    this.location = location;
    this.restorationIdentifier = restorationIdentifier;
  }

  getRestorationDataForIdentifier(restorationIdentifier) {
    return this.restorationData[restorationIdentifier] || {};
  }

  updateRestorationData(additionalData) {
    const {
      restorationIdentifier
    } = this;
    const restorationData = this.restorationData[restorationIdentifier];
    this.restorationData[restorationIdentifier] = Object.assign(Object.assign({}, restorationData), additionalData);
  }

  assumeControlOfScrollRestoration() {
    var _a;

    if (!this.previousScrollRestoration) {
      this.previousScrollRestoration = (_a = history.scrollRestoration) !== null && _a !== void 0 ? _a : "auto";
      history.scrollRestoration = "manual";
    }
  }

  relinquishControlOfScrollRestoration() {
    if (this.previousScrollRestoration) {
      history.scrollRestoration = this.previousScrollRestoration;
      delete this.previousScrollRestoration;
    }
  }

  shouldHandlePopState() {
    return this.pageIsLoaded();
  }

  pageIsLoaded() {
    return this.pageLoaded || document.readyState == "complete";
  }

}

class LinkClickObserver {
  constructor(delegate) {
    this.started = false;

    this.clickCaptured = () => {
      removeEventListener("click", this.clickBubbled, false);
      addEventListener("click", this.clickBubbled, false);
    };

    this.clickBubbled = event => {
      if (this.clickEventIsSignificant(event)) {
        const target = event.composedPath && event.composedPath()[0] || event.target;
        const link = this.findLinkFromClickTarget(target);

        if (link) {
          const location = this.getLocationForLink(link);

          if (this.delegate.willFollowLinkToLocation(link, location)) {
            event.preventDefault();
            this.delegate.followedLinkToLocation(link, location);
          }
        }
      }
    };

    this.delegate = delegate;
  }

  start() {
    if (!this.started) {
      addEventListener("click", this.clickCaptured, true);
      this.started = true;
    }
  }

  stop() {
    if (this.started) {
      removeEventListener("click", this.clickCaptured, true);
      this.started = false;
    }
  }

  clickEventIsSignificant(event) {
    return !(event.target && event.target.isContentEditable || event.defaultPrevented || event.which > 1 || event.altKey || event.ctrlKey || event.metaKey || event.shiftKey);
  }

  findLinkFromClickTarget(target) {
    if (target instanceof Element) {
      return target.closest("a[href]:not([target^=_]):not([download])");
    }
  }

  getLocationForLink(link) {
    return expandURL(link.getAttribute("href") || "");
  }

}

function isAction(action) {
  return action == "advance" || action == "replace" || action == "restore";
}

class Navigator {
  constructor(delegate) {
    this.delegate = delegate;
  }

  proposeVisit(location, options = {}) {
    if (this.delegate.allowsVisitingLocationWithAction(location, options.action)) {
      if (locationIsVisitable(location, this.view.snapshot.rootLocation)) {
        this.delegate.visitProposedToLocation(location, options);
      } else {
        window.location.href = location.toString();
      }
    }
  }

  startVisit(locatable, restorationIdentifier, options = {}) {
    this.stop();
    this.currentVisit = new Visit(this, expandURL(locatable), restorationIdentifier, Object.assign({
      referrer: this.location
    }, options));
    this.currentVisit.start();
  }

  submitForm(form, submitter) {
    this.stop();
    this.formSubmission = new FormSubmission(this, form, submitter, true);
    this.formSubmission.start();
  }

  stop() {
    if (this.formSubmission) {
      this.formSubmission.stop();
      delete this.formSubmission;
    }

    if (this.currentVisit) {
      this.currentVisit.cancel();
      delete this.currentVisit;
    }
  }

  get adapter() {
    return this.delegate.adapter;
  }

  get view() {
    return this.delegate.view;
  }

  get history() {
    return this.delegate.history;
  }

  formSubmissionStarted(formSubmission) {
    if (typeof this.adapter.formSubmissionStarted === 'function') {
      this.adapter.formSubmissionStarted(formSubmission);
    }
  }

  async formSubmissionSucceededWithResponse(formSubmission, fetchResponse) {
    if (formSubmission == this.formSubmission) {
      const responseHTML = await fetchResponse.responseHTML;

      if (responseHTML) {
        if (formSubmission.method != FetchMethod.get) {
          this.view.clearSnapshotCache();
        }

        const {
          statusCode,
          redirected
        } = fetchResponse;
        const action = this.getActionForFormSubmission(formSubmission);
        const visitOptions = {
          action,
          response: {
            statusCode,
            responseHTML,
            redirected
          }
        };
        this.proposeVisit(fetchResponse.location, visitOptions);
      }
    }
  }

  async formSubmissionFailedWithResponse(formSubmission, fetchResponse) {
    const responseHTML = await fetchResponse.responseHTML;

    if (responseHTML) {
      const snapshot = PageSnapshot.fromHTMLString(responseHTML);

      if (fetchResponse.serverError) {
        await this.view.renderError(snapshot);
      } else {
        await this.view.renderPage(snapshot);
      }

      this.view.scrollToTop();
      this.view.clearSnapshotCache();
    }
  }

  formSubmissionErrored(formSubmission, error) {
    console.error(error);
  }

  formSubmissionFinished(formSubmission) {
    if (typeof this.adapter.formSubmissionFinished === 'function') {
      this.adapter.formSubmissionFinished(formSubmission);
    }
  }

  visitStarted(visit) {
    this.delegate.visitStarted(visit);
  }

  visitCompleted(visit) {
    this.delegate.visitCompleted(visit);
  }

  locationWithActionIsSamePage(location, action) {
    const anchor = getAnchor(location);
    const currentAnchor = getAnchor(this.view.lastRenderedLocation);
    const isRestorationToTop = action === 'restore' && typeof anchor === 'undefined';
    return action !== "replace" && getRequestURL(location) === getRequestURL(this.view.lastRenderedLocation) && (isRestorationToTop || anchor != null && anchor !== currentAnchor);
  }

  visitScrolledToSamePageLocation(oldURL, newURL) {
    this.delegate.visitScrolledToSamePageLocation(oldURL, newURL);
  }

  get location() {
    return this.history.location;
  }

  get restorationIdentifier() {
    return this.history.restorationIdentifier;
  }

  getActionForFormSubmission(formSubmission) {
    const {
      formElement,
      submitter
    } = formSubmission;
    const action = getAttribute("data-turbo-action", submitter, formElement);
    return isAction(action) ? action : "advance";
  }

}

var PageStage;

(function (PageStage) {
  PageStage[PageStage["initial"] = 0] = "initial";
  PageStage[PageStage["loading"] = 1] = "loading";
  PageStage[PageStage["interactive"] = 2] = "interactive";
  PageStage[PageStage["complete"] = 3] = "complete";
})(PageStage || (PageStage = {}));

class PageObserver {
  constructor(delegate) {
    this.stage = PageStage.initial;
    this.started = false;

    this.interpretReadyState = () => {
      const {
        readyState
      } = this;

      if (readyState == "interactive") {
        this.pageIsInteractive();
      } else if (readyState == "complete") {
        this.pageIsComplete();
      }
    };

    this.pageWillUnload = () => {
      this.delegate.pageWillUnload();
    };

    this.delegate = delegate;
  }

  start() {
    if (!this.started) {
      if (this.stage == PageStage.initial) {
        this.stage = PageStage.loading;
      }

      document.addEventListener("readystatechange", this.interpretReadyState, false);
      addEventListener("pagehide", this.pageWillUnload, false);
      this.started = true;
    }
  }

  stop() {
    if (this.started) {
      document.removeEventListener("readystatechange", this.interpretReadyState, false);
      removeEventListener("pagehide", this.pageWillUnload, false);
      this.started = false;
    }
  }

  pageIsInteractive() {
    if (this.stage == PageStage.loading) {
      this.stage = PageStage.interactive;
      this.delegate.pageBecameInteractive();
    }
  }

  pageIsComplete() {
    this.pageIsInteractive();

    if (this.stage == PageStage.interactive) {
      this.stage = PageStage.complete;
      this.delegate.pageLoaded();
    }
  }

  get readyState() {
    return document.readyState;
  }

}

class ScrollObserver {
  constructor(delegate) {
    this.started = false;

    this.onScroll = () => {
      this.updatePosition({
        x: window.pageXOffset,
        y: window.pageYOffset
      });
    };

    this.delegate = delegate;
  }

  start() {
    if (!this.started) {
      addEventListener("scroll", this.onScroll, false);
      this.onScroll();
      this.started = true;
    }
  }

  stop() {
    if (this.started) {
      removeEventListener("scroll", this.onScroll, false);
      this.started = false;
    }
  }

  updatePosition(position) {
    this.delegate.scrollPositionChanged(position);
  }

}

class StreamObserver {
  constructor(delegate) {
    this.sources = new Set();
    this.started = false;

    this.inspectFetchResponse = event => {
      const response = fetchResponseFromEvent(event);

      if (response && fetchResponseIsStream(response)) {
        event.preventDefault();
        this.receiveMessageResponse(response);
      }
    };

    this.receiveMessageEvent = event => {
      if (this.started && typeof event.data == "string") {
        this.receiveMessageHTML(event.data);
      }
    };

    this.delegate = delegate;
  }

  start() {
    if (!this.started) {
      this.started = true;
      addEventListener("turbo:before-fetch-response", this.inspectFetchResponse, false);
    }
  }

  stop() {
    if (this.started) {
      this.started = false;
      removeEventListener("turbo:before-fetch-response", this.inspectFetchResponse, false);
    }
  }

  connectStreamSource(source) {
    if (!this.streamSourceIsConnected(source)) {
      this.sources.add(source);
      source.addEventListener("message", this.receiveMessageEvent, false);
    }
  }

  disconnectStreamSource(source) {
    if (this.streamSourceIsConnected(source)) {
      this.sources.delete(source);
      source.removeEventListener("message", this.receiveMessageEvent, false);
    }
  }

  streamSourceIsConnected(source) {
    return this.sources.has(source);
  }

  async receiveMessageResponse(response) {
    const html = await response.responseHTML;

    if (html) {
      this.receiveMessageHTML(html);
    }
  }

  receiveMessageHTML(html) {
    this.delegate.receivedMessageFromStream(new StreamMessage(html));
  }

}

function fetchResponseFromEvent(event) {
  var _a;

  const fetchResponse = (_a = event.detail) === null || _a === void 0 ? void 0 : _a.fetchResponse;

  if (fetchResponse instanceof FetchResponse) {
    return fetchResponse;
  }
}

function fetchResponseIsStream(response) {
  var _a;

  const contentType = (_a = response.contentType) !== null && _a !== void 0 ? _a : "";
  return contentType.startsWith(StreamMessage.contentType);
}

class ErrorRenderer extends Renderer {
  async render() {
    this.replaceHeadAndBody();
    this.activateScriptElements();
  }

  replaceHeadAndBody() {
    const {
      documentElement,
      head,
      body
    } = document;
    documentElement.replaceChild(this.newHead, head);
    documentElement.replaceChild(this.newElement, body);
  }

  activateScriptElements() {
    for (const replaceableElement of this.scriptElements) {
      const parentNode = replaceableElement.parentNode;

      if (parentNode) {
        const element = this.createScriptElement(replaceableElement);
        parentNode.replaceChild(element, replaceableElement);
      }
    }
  }

  get newHead() {
    return this.newSnapshot.headSnapshot.element;
  }

  get scriptElements() {
    return [...document.documentElement.querySelectorAll("script")];
  }

}

class PageRenderer extends Renderer {
  get shouldRender() {
    return this.newSnapshot.isVisitable && this.trackedElementsAreIdentical;
  }

  prepareToRender() {
    this.mergeHead();
  }

  async render() {
    if (this.willRender) {
      this.replaceBody();
    }
  }

  finishRendering() {
    super.finishRendering();

    if (!this.isPreview) {
      this.focusFirstAutofocusableElement();
    }
  }

  get currentHeadSnapshot() {
    return this.currentSnapshot.headSnapshot;
  }

  get newHeadSnapshot() {
    return this.newSnapshot.headSnapshot;
  }

  get newElement() {
    return this.newSnapshot.element;
  }

  mergeHead() {
    this.copyNewHeadStylesheetElements();
    this.copyNewHeadScriptElements();
    this.removeCurrentHeadProvisionalElements();
    this.copyNewHeadProvisionalElements();
  }

  replaceBody() {
    this.preservingPermanentElements(() => {
      this.activateNewBody();
      this.assignNewBody();
    });
  }

  get trackedElementsAreIdentical() {
    return this.currentHeadSnapshot.trackedElementSignature == this.newHeadSnapshot.trackedElementSignature;
  }

  copyNewHeadStylesheetElements() {
    for (const element of this.newHeadStylesheetElements) {
      document.head.appendChild(element);
    }
  }

  copyNewHeadScriptElements() {
    for (const element of this.newHeadScriptElements) {
      document.head.appendChild(this.createScriptElement(element));
    }
  }

  removeCurrentHeadProvisionalElements() {
    for (const element of this.currentHeadProvisionalElements) {
      document.head.removeChild(element);
    }
  }

  copyNewHeadProvisionalElements() {
    for (const element of this.newHeadProvisionalElements) {
      document.head.appendChild(element);
    }
  }

  activateNewBody() {
    document.adoptNode(this.newElement);
    this.activateNewBodyScriptElements();
  }

  activateNewBodyScriptElements() {
    for (const inertScriptElement of this.newBodyScriptElements) {
      const activatedScriptElement = this.createScriptElement(inertScriptElement);
      inertScriptElement.replaceWith(activatedScriptElement);
    }
  }

  assignNewBody() {
    if (document.body && this.newElement instanceof HTMLBodyElement) {
      document.body.replaceWith(this.newElement);
    } else {
      document.documentElement.appendChild(this.newElement);
    }
  }

  get newHeadStylesheetElements() {
    return this.newHeadSnapshot.getStylesheetElementsNotInSnapshot(this.currentHeadSnapshot);
  }

  get newHeadScriptElements() {
    return this.newHeadSnapshot.getScriptElementsNotInSnapshot(this.currentHeadSnapshot);
  }

  get currentHeadProvisionalElements() {
    return this.currentHeadSnapshot.provisionalElements;
  }

  get newHeadProvisionalElements() {
    return this.newHeadSnapshot.provisionalElements;
  }

  get newBodyScriptElements() {
    return this.newElement.querySelectorAll("script");
  }

}

class SnapshotCache {
  constructor(size) {
    this.keys = [];
    this.snapshots = {};
    this.size = size;
  }

  has(location) {
    return toCacheKey(location) in this.snapshots;
  }

  get(location) {
    if (this.has(location)) {
      const snapshot = this.read(location);
      this.touch(location);
      return snapshot;
    }
  }

  put(location, snapshot) {
    this.write(location, snapshot);
    this.touch(location);
    return snapshot;
  }

  clear() {
    this.snapshots = {};
  }

  read(location) {
    return this.snapshots[toCacheKey(location)];
  }

  write(location, snapshot) {
    this.snapshots[toCacheKey(location)] = snapshot;
  }

  touch(location) {
    const key = toCacheKey(location);
    const index = this.keys.indexOf(key);
    if (index > -1) this.keys.splice(index, 1);
    this.keys.unshift(key);
    this.trim();
  }

  trim() {
    for (const key of this.keys.splice(this.size)) {
      delete this.snapshots[key];
    }
  }

}

class PageView extends View {
  constructor() {
    super(...arguments);
    this.snapshotCache = new SnapshotCache(10);
    this.lastRenderedLocation = new URL(location.href);
  }

  renderPage(snapshot, isPreview = false, willRender = true) {
    const renderer = new PageRenderer(this.snapshot, snapshot, isPreview, willRender);
    return this.render(renderer);
  }

  renderError(snapshot) {
    const renderer = new ErrorRenderer(this.snapshot, snapshot, false);
    return this.render(renderer);
  }

  clearSnapshotCache() {
    this.snapshotCache.clear();
  }

  async cacheSnapshot() {
    if (this.shouldCacheSnapshot) {
      this.delegate.viewWillCacheSnapshot();
      const {
        snapshot,
        lastRenderedLocation: location
      } = this;
      await nextEventLoopTick();
      const cachedSnapshot = snapshot.clone();
      this.snapshotCache.put(location, cachedSnapshot);
      return cachedSnapshot;
    }
  }

  getCachedSnapshotForLocation(location) {
    return this.snapshotCache.get(location);
  }

  get snapshot() {
    return PageSnapshot.fromElement(this.element);
  }

  get shouldCacheSnapshot() {
    return this.snapshot.isCacheable;
  }

}

class Session {
  constructor() {
    this.navigator = new Navigator(this);
    this.history = new History(this);
    this.view = new PageView(this, document.documentElement);
    this.adapter = new BrowserAdapter(this);
    this.pageObserver = new PageObserver(this);
    this.cacheObserver = new CacheObserver();
    this.linkClickObserver = new LinkClickObserver(this);
    this.formSubmitObserver = new FormSubmitObserver(this);
    this.scrollObserver = new ScrollObserver(this);
    this.streamObserver = new StreamObserver(this);
    this.frameRedirector = new FrameRedirector(document.documentElement);
    this.drive = true;
    this.enabled = true;
    this.progressBarDelay = 500;
    this.started = false;
  }

  start() {
    if (!this.started) {
      this.pageObserver.start();
      this.cacheObserver.start();
      this.linkClickObserver.start();
      this.formSubmitObserver.start();
      this.scrollObserver.start();
      this.streamObserver.start();
      this.frameRedirector.start();
      this.history.start();
      this.started = true;
      this.enabled = true;
    }
  }

  disable() {
    this.enabled = false;
  }

  stop() {
    if (this.started) {
      this.pageObserver.stop();
      this.cacheObserver.stop();
      this.linkClickObserver.stop();
      this.formSubmitObserver.stop();
      this.scrollObserver.stop();
      this.streamObserver.stop();
      this.frameRedirector.stop();
      this.history.stop();
      this.started = false;
    }
  }

  registerAdapter(adapter) {
    this.adapter = adapter;
  }

  visit(location, options = {}) {
    this.navigator.proposeVisit(expandURL(location), options);
  }

  connectStreamSource(source) {
    this.streamObserver.connectStreamSource(source);
  }

  disconnectStreamSource(source) {
    this.streamObserver.disconnectStreamSource(source);
  }

  renderStreamMessage(message) {
    document.documentElement.appendChild(StreamMessage.wrap(message).fragment);
  }

  clearCache() {
    this.view.clearSnapshotCache();
  }

  setProgressBarDelay(delay) {
    this.progressBarDelay = delay;
  }

  get location() {
    return this.history.location;
  }

  get restorationIdentifier() {
    return this.history.restorationIdentifier;
  }

  historyPoppedToLocationWithRestorationIdentifier(location, restorationIdentifier) {
    if (this.enabled) {
      this.navigator.startVisit(location, restorationIdentifier, {
        action: "restore",
        historyChanged: true
      });
    } else {
      this.adapter.pageInvalidated();
    }
  }

  scrollPositionChanged(position) {
    this.history.updateRestorationData({
      scrollPosition: position
    });
  }

  willFollowLinkToLocation(link, location) {
    return this.elementDriveEnabled(link) && locationIsVisitable(location, this.snapshot.rootLocation) && this.applicationAllowsFollowingLinkToLocation(link, location);
  }

  followedLinkToLocation(link, location) {
    const action = this.getActionForLink(link);
    this.convertLinkWithMethodClickToFormSubmission(link) || this.visit(location.href, {
      action
    });
  }

  convertLinkWithMethodClickToFormSubmission(link) {
    const linkMethod = link.getAttribute("data-turbo-method");

    if (linkMethod) {
      const form = document.createElement("form");
      form.method = linkMethod;
      form.action = link.getAttribute("href") || "undefined";
      form.hidden = true;

      if (link.hasAttribute("data-turbo-confirm")) {
        form.setAttribute("data-turbo-confirm", link.getAttribute("data-turbo-confirm"));
      }

      const frame = this.getTargetFrameForLink(link);

      if (frame) {
        form.setAttribute("data-turbo-frame", frame);
        form.addEventListener("turbo:submit-start", () => form.remove());
      } else {
        form.addEventListener("submit", () => form.remove());
      }

      document.body.appendChild(form);
      return dispatch("submit", {
        cancelable: true,
        target: form
      });
    } else {
      return false;
    }
  }

  allowsVisitingLocationWithAction(location, action) {
    return this.locationWithActionIsSamePage(location, action) || this.applicationAllowsVisitingLocation(location);
  }

  visitProposedToLocation(location, options) {
    extendURLWithDeprecatedProperties(location);
    this.adapter.visitProposedToLocation(location, options);
  }

  visitStarted(visit) {
    extendURLWithDeprecatedProperties(visit.location);

    if (!visit.silent) {
      this.notifyApplicationAfterVisitingLocation(visit.location, visit.action);
    }
  }

  visitCompleted(visit) {
    this.notifyApplicationAfterPageLoad(visit.getTimingMetrics());
  }

  locationWithActionIsSamePage(location, action) {
    return this.navigator.locationWithActionIsSamePage(location, action);
  }

  visitScrolledToSamePageLocation(oldURL, newURL) {
    this.notifyApplicationAfterVisitingSamePageLocation(oldURL, newURL);
  }

  willSubmitForm(form, submitter) {
    const action = getAction(form, submitter);
    return this.elementDriveEnabled(form) && (!submitter || this.elementDriveEnabled(submitter)) && locationIsVisitable(expandURL(action), this.snapshot.rootLocation);
  }

  formSubmitted(form, submitter) {
    this.navigator.submitForm(form, submitter);
  }

  pageBecameInteractive() {
    this.view.lastRenderedLocation = this.location;
    this.notifyApplicationAfterPageLoad();
  }

  pageLoaded() {
    this.history.assumeControlOfScrollRestoration();
  }

  pageWillUnload() {
    this.history.relinquishControlOfScrollRestoration();
  }

  receivedMessageFromStream(message) {
    this.renderStreamMessage(message);
  }

  viewWillCacheSnapshot() {
    var _a;

    if (!((_a = this.navigator.currentVisit) === null || _a === void 0 ? void 0 : _a.silent)) {
      this.notifyApplicationBeforeCachingSnapshot();
    }
  }

  allowsImmediateRender({
    element
  }, resume) {
    const event = this.notifyApplicationBeforeRender(element, resume);
    return !event.defaultPrevented;
  }

  viewRenderedSnapshot(snapshot, isPreview) {
    this.view.lastRenderedLocation = this.history.location;
    this.notifyApplicationAfterRender();
  }

  viewInvalidated() {
    this.adapter.pageInvalidated();
  }

  frameLoaded(frame) {
    this.notifyApplicationAfterFrameLoad(frame);
  }

  frameRendered(fetchResponse, frame) {
    this.notifyApplicationAfterFrameRender(fetchResponse, frame);
  }

  applicationAllowsFollowingLinkToLocation(link, location) {
    const event = this.notifyApplicationAfterClickingLinkToLocation(link, location);
    return !event.defaultPrevented;
  }

  applicationAllowsVisitingLocation(location) {
    const event = this.notifyApplicationBeforeVisitingLocation(location);
    return !event.defaultPrevented;
  }

  notifyApplicationAfterClickingLinkToLocation(link, location) {
    return dispatch("turbo:click", {
      target: link,
      detail: {
        url: location.href
      },
      cancelable: true
    });
  }

  notifyApplicationBeforeVisitingLocation(location) {
    return dispatch("turbo:before-visit", {
      detail: {
        url: location.href
      },
      cancelable: true
    });
  }

  notifyApplicationAfterVisitingLocation(location, action) {
    markAsBusy(document.documentElement);
    return dispatch("turbo:visit", {
      detail: {
        url: location.href,
        action
      }
    });
  }

  notifyApplicationBeforeCachingSnapshot() {
    return dispatch("turbo:before-cache");
  }

  notifyApplicationBeforeRender(newBody, resume) {
    return dispatch("turbo:before-render", {
      detail: {
        newBody,
        resume
      },
      cancelable: true
    });
  }

  notifyApplicationAfterRender() {
    return dispatch("turbo:render");
  }

  notifyApplicationAfterPageLoad(timing = {}) {
    clearBusyState(document.documentElement);
    return dispatch("turbo:load", {
      detail: {
        url: this.location.href,
        timing
      }
    });
  }

  notifyApplicationAfterVisitingSamePageLocation(oldURL, newURL) {
    dispatchEvent(new HashChangeEvent("hashchange", {
      oldURL: oldURL.toString(),
      newURL: newURL.toString()
    }));
  }

  notifyApplicationAfterFrameLoad(frame) {
    return dispatch("turbo:frame-load", {
      target: frame
    });
  }

  notifyApplicationAfterFrameRender(fetchResponse, frame) {
    return dispatch("turbo:frame-render", {
      detail: {
        fetchResponse
      },
      target: frame,
      cancelable: true
    });
  }

  elementDriveEnabled(element) {
    const container = element === null || element === void 0 ? void 0 : element.closest("[data-turbo]");

    if (this.drive) {
      if (container) {
        return container.getAttribute("data-turbo") != "false";
      } else {
        return true;
      }
    } else {
      if (container) {
        return container.getAttribute("data-turbo") == "true";
      } else {
        return false;
      }
    }
  }

  getActionForLink(link) {
    const action = link.getAttribute("data-turbo-action");
    return isAction(action) ? action : "advance";
  }

  getTargetFrameForLink(link) {
    const frame = link.getAttribute("data-turbo-frame");

    if (frame) {
      return frame;
    } else {
      const container = link.closest("turbo-frame");

      if (container) {
        return container.id;
      }
    }
  }

  get snapshot() {
    return this.view.snapshot;
  }

}

function extendURLWithDeprecatedProperties(url) {
  Object.defineProperties(url, deprecatedLocationPropertyDescriptors);
}

const deprecatedLocationPropertyDescriptors = {
  absoluteURL: {
    get() {
      return this.toString();
    }

  }
};
const session = new Session();
const {
  navigator: navigator$1
} = session;

function start() {
  session.start();
}

function registerAdapter(adapter) {
  session.registerAdapter(adapter);
}

function visit(location, options) {
  session.visit(location, options);
}

function connectStreamSource(source) {
  session.connectStreamSource(source);
}

function disconnectStreamSource(source) {
  session.disconnectStreamSource(source);
}

function renderStreamMessage(message) {
  session.renderStreamMessage(message);
}

function clearCache() {
  session.clearCache();
}

function setProgressBarDelay(delay) {
  session.setProgressBarDelay(delay);
}

function setConfirmMethod(confirmMethod) {
  FormSubmission.confirmMethod = confirmMethod;
}

var Turbo = /*#__PURE__*/Object.freeze({
  __proto__: null,
  navigator: navigator$1,
  session: session,
  PageRenderer: PageRenderer,
  PageSnapshot: PageSnapshot,
  start: start,
  registerAdapter: registerAdapter,
  visit: visit,
  connectStreamSource: connectStreamSource,
  disconnectStreamSource: disconnectStreamSource,
  renderStreamMessage: renderStreamMessage,
  clearCache: clearCache,
  setProgressBarDelay: setProgressBarDelay,
  setConfirmMethod: setConfirmMethod
});

class FrameController {
  constructor(element) {
    this.fetchResponseLoaded = fetchResponse => {};

    this.currentFetchRequest = null;

    this.resolveVisitPromise = () => {};

    this.connected = false;
    this.hasBeenLoaded = false;
    this.settingSourceURL = false;
    this.element = element;
    this.view = new FrameView(this, this.element);
    this.appearanceObserver = new AppearanceObserver(this, this.element);
    this.linkInterceptor = new LinkInterceptor(this, this.element);
    this.formInterceptor = new FormInterceptor(this, this.element);
  }

  connect() {
    if (!this.connected) {
      this.connected = true;
      this.reloadable = false;

      if (this.loadingStyle == FrameLoadingStyle.lazy) {
        this.appearanceObserver.start();
      }

      this.linkInterceptor.start();
      this.formInterceptor.start();
      this.sourceURLChanged();
    }
  }

  disconnect() {
    if (this.connected) {
      this.connected = false;
      this.appearanceObserver.stop();
      this.linkInterceptor.stop();
      this.formInterceptor.stop();
    }
  }

  disabledChanged() {
    if (this.loadingStyle == FrameLoadingStyle.eager) {
      this.loadSourceURL();
    }
  }

  sourceURLChanged() {
    if (this.loadingStyle == FrameLoadingStyle.eager || this.hasBeenLoaded) {
      this.loadSourceURL();
    }
  }

  loadingStyleChanged() {
    if (this.loadingStyle == FrameLoadingStyle.lazy) {
      this.appearanceObserver.start();
    } else {
      this.appearanceObserver.stop();
      this.loadSourceURL();
    }
  }

  async loadSourceURL() {
    if (!this.settingSourceURL && this.enabled && this.isActive && (this.reloadable || this.sourceURL != this.currentURL)) {
      const previousURL = this.currentURL;
      this.currentURL = this.sourceURL;

      if (this.sourceURL) {
        try {
          this.element.loaded = this.visit(expandURL(this.sourceURL));
          this.appearanceObserver.stop();
          await this.element.loaded;
          this.hasBeenLoaded = true;
        } catch (error) {
          this.currentURL = previousURL;
          throw error;
        }
      }
    }
  }

  async loadResponse(fetchResponse) {
    if (fetchResponse.redirected || fetchResponse.succeeded && fetchResponse.isHTML) {
      this.sourceURL = fetchResponse.response.url;
    }

    try {
      const html = await fetchResponse.responseHTML;

      if (html) {
        const {
          body
        } = parseHTMLDocument(html);
        const snapshot = new Snapshot((await this.extractForeignFrameElement(body)));
        const renderer = new FrameRenderer(this.view.snapshot, snapshot, false, false);
        if (this.view.renderPromise) await this.view.renderPromise;
        await this.view.render(renderer);
        session.frameRendered(fetchResponse, this.element);
        session.frameLoaded(this.element);
        this.fetchResponseLoaded(fetchResponse);
      }
    } catch (error) {
      console.error(error);
      this.view.invalidate();
    } finally {
      this.fetchResponseLoaded = () => {};
    }
  }

  elementAppearedInViewport(element) {
    this.loadSourceURL();
  }

  shouldInterceptLinkClick(element, url) {
    if (element.hasAttribute("data-turbo-method")) {
      return false;
    } else {
      return this.shouldInterceptNavigation(element);
    }
  }

  linkClickIntercepted(element, url) {
    this.reloadable = true;
    this.navigateFrame(element, url);
  }

  shouldInterceptFormSubmission(element, submitter) {
    return this.shouldInterceptNavigation(element, submitter);
  }

  formSubmissionIntercepted(element, submitter) {
    if (this.formSubmission) {
      this.formSubmission.stop();
    }

    this.reloadable = false;
    this.formSubmission = new FormSubmission(this, element, submitter);
    const {
      fetchRequest
    } = this.formSubmission;
    this.prepareHeadersForRequest(fetchRequest.headers, fetchRequest);
    this.formSubmission.start();
  }

  prepareHeadersForRequest(headers, request) {
    headers["Turbo-Frame"] = this.id;
  }

  requestStarted(request) {
    markAsBusy(this.element);
  }

  requestPreventedHandlingResponse(request, response) {
    this.resolveVisitPromise();
  }

  async requestSucceededWithResponse(request, response) {
    await this.loadResponse(response);
    this.resolveVisitPromise();
  }

  requestFailedWithResponse(request, response) {
    console.error(response);
    this.resolveVisitPromise();
  }

  requestErrored(request, error) {
    console.error(error);
    this.resolveVisitPromise();
  }

  requestFinished(request) {
    clearBusyState(this.element);
  }

  formSubmissionStarted({
    formElement
  }) {
    markAsBusy(formElement, this.findFrameElement(formElement));
  }

  formSubmissionSucceededWithResponse(formSubmission, response) {
    const frame = this.findFrameElement(formSubmission.formElement, formSubmission.submitter);
    this.proposeVisitIfNavigatedWithAction(frame, formSubmission.formElement, formSubmission.submitter);
    frame.delegate.loadResponse(response);
  }

  formSubmissionFailedWithResponse(formSubmission, fetchResponse) {
    this.element.delegate.loadResponse(fetchResponse);
  }

  formSubmissionErrored(formSubmission, error) {
    console.error(error);
  }

  formSubmissionFinished({
    formElement
  }) {
    clearBusyState(formElement, this.findFrameElement(formElement));
  }

  allowsImmediateRender(snapshot, resume) {
    return true;
  }

  viewRenderedSnapshot(snapshot, isPreview) {}

  viewInvalidated() {}

  async visit(url) {
    var _a;

    const request = new FetchRequest(this, FetchMethod.get, url, new URLSearchParams(), this.element);
    (_a = this.currentFetchRequest) === null || _a === void 0 ? void 0 : _a.cancel();
    this.currentFetchRequest = request;
    return new Promise(resolve => {
      this.resolveVisitPromise = () => {
        this.resolveVisitPromise = () => {};

        this.currentFetchRequest = null;
        resolve();
      };

      request.perform();
    });
  }

  navigateFrame(element, url, submitter) {
    const frame = this.findFrameElement(element, submitter);
    this.proposeVisitIfNavigatedWithAction(frame, element, submitter);
    frame.setAttribute("reloadable", "");
    frame.src = url;
  }

  proposeVisitIfNavigatedWithAction(frame, element, submitter) {
    const action = getAttribute("data-turbo-action", submitter, element, frame);

    if (isAction(action)) {
      const {
        visitCachedSnapshot
      } = new SnapshotSubstitution(frame);

      frame.delegate.fetchResponseLoaded = fetchResponse => {
        if (frame.src) {
          const {
            statusCode,
            redirected
          } = fetchResponse;
          const responseHTML = frame.ownerDocument.documentElement.outerHTML;
          const response = {
            statusCode,
            redirected,
            responseHTML
          };
          session.visit(frame.src, {
            action,
            response,
            visitCachedSnapshot,
            willRender: false
          });
        }
      };
    }
  }

  findFrameElement(element, submitter) {
    var _a;

    const id = getAttribute("data-turbo-frame", submitter, element) || this.element.getAttribute("target");
    return (_a = getFrameElementById(id)) !== null && _a !== void 0 ? _a : this.element;
  }

  async extractForeignFrameElement(container) {
    let element;
    const id = CSS.escape(this.id);

    try {
      if (element = activateElement(container.querySelector(`turbo-frame#${id}`), this.currentURL)) {
        return element;
      }

      if (element = activateElement(container.querySelector(`turbo-frame[src][recurse~=${id}]`), this.currentURL)) {
        await element.loaded;
        return await this.extractForeignFrameElement(element);
      }

      console.error(`Response has no matching <turbo-frame id="${id}"> element`);
    } catch (error) {
      console.error(error);
    }

    return new FrameElement();
  }

  formActionIsVisitable(form, submitter) {
    const action = getAction(form, submitter);
    return locationIsVisitable(expandURL(action), this.rootLocation);
  }

  shouldInterceptNavigation(element, submitter) {
    const id = getAttribute("data-turbo-frame", submitter, element) || this.element.getAttribute("target");

    if (element instanceof HTMLFormElement && !this.formActionIsVisitable(element, submitter)) {
      return false;
    }

    if (!this.enabled || id == "_top") {
      return false;
    }

    if (id) {
      const frameElement = getFrameElementById(id);

      if (frameElement) {
        return !frameElement.disabled;
      }
    }

    if (!session.elementDriveEnabled(element)) {
      return false;
    }

    if (submitter && !session.elementDriveEnabled(submitter)) {
      return false;
    }

    return true;
  }

  get id() {
    return this.element.id;
  }

  get enabled() {
    return !this.element.disabled;
  }

  get sourceURL() {
    if (this.element.src) {
      return this.element.src;
    }
  }

  get reloadable() {
    const frame = this.findFrameElement(this.element);
    return frame.hasAttribute("reloadable");
  }

  set reloadable(value) {
    const frame = this.findFrameElement(this.element);

    if (value) {
      frame.setAttribute("reloadable", "");
    } else {
      frame.removeAttribute("reloadable");
    }
  }

  set sourceURL(sourceURL) {
    this.settingSourceURL = true;
    this.element.src = sourceURL !== null && sourceURL !== void 0 ? sourceURL : null;
    this.currentURL = this.element.src;
    this.settingSourceURL = false;
  }

  get loadingStyle() {
    return this.element.loading;
  }

  get isLoading() {
    return this.formSubmission !== undefined || this.resolveVisitPromise() !== undefined;
  }

  get isActive() {
    return this.element.isActive && this.connected;
  }

  get rootLocation() {
    var _a;

    const meta = this.element.ownerDocument.querySelector(`meta[name="turbo-root"]`);
    const root = (_a = meta === null || meta === void 0 ? void 0 : meta.content) !== null && _a !== void 0 ? _a : "/";
    return expandURL(root);
  }

}

class SnapshotSubstitution {
  constructor(element) {
    this.visitCachedSnapshot = ({
      element
    }) => {
      var _a;

      const {
        id,
        clone
      } = this;
      (_a = element.querySelector("#" + id)) === null || _a === void 0 ? void 0 : _a.replaceWith(clone);
    };

    this.clone = element.cloneNode(true);
    this.id = element.id;
  }

}

function getFrameElementById(id) {
  if (id != null) {
    const element = document.getElementById(id);

    if (element instanceof FrameElement) {
      return element;
    }
  }
}

function activateElement(element, currentURL) {
  if (element) {
    const src = element.getAttribute("src");

    if (src != null && currentURL != null && urlsAreEqual(src, currentURL)) {
      throw new Error(`Matching <turbo-frame id="${element.id}"> element has a source URL which references itself`);
    }

    if (element.ownerDocument !== document) {
      element = document.importNode(element, true);
    }

    if (element instanceof FrameElement) {
      element.connectedCallback();
      element.disconnectedCallback();
      return element;
    }
  }
}

const StreamActions = {
  after() {
    this.targetElements.forEach(e => {
      var _a;

      return (_a = e.parentElement) === null || _a === void 0 ? void 0 : _a.insertBefore(this.templateContent, e.nextSibling);
    });
  },

  append() {
    this.removeDuplicateTargetChildren();
    this.targetElements.forEach(e => e.append(this.templateContent));
  },

  before() {
    this.targetElements.forEach(e => {
      var _a;

      return (_a = e.parentElement) === null || _a === void 0 ? void 0 : _a.insertBefore(this.templateContent, e);
    });
  },

  prepend() {
    this.removeDuplicateTargetChildren();
    this.targetElements.forEach(e => e.prepend(this.templateContent));
  },

  remove() {
    this.targetElements.forEach(e => e.remove());
  },

  replace() {
    this.targetElements.forEach(e => e.replaceWith(this.templateContent));
  },

  update() {
    this.targetElements.forEach(e => {
      e.innerHTML = "";
      e.append(this.templateContent);
    });
  }

};

class StreamElement extends HTMLElement {
  async connectedCallback() {
    try {
      await this.render();
    } catch (error) {
      console.error(error);
    } finally {
      this.disconnect();
    }
  }

  async render() {
    var _a;

    return (_a = this.renderPromise) !== null && _a !== void 0 ? _a : this.renderPromise = (async () => {
      if (this.dispatchEvent(this.beforeRenderEvent)) {
        await nextAnimationFrame();
        this.performAction();
      }
    })();
  }

  disconnect() {
    try {
      this.remove();
    } catch (_a) {}
  }

  removeDuplicateTargetChildren() {
    this.duplicateChildren.forEach(c => c.remove());
  }

  get duplicateChildren() {
    var _a;

    const existingChildren = this.targetElements.flatMap(e => [...e.children]).filter(c => !!c.id);
    const newChildrenIds = [...((_a = this.templateContent) === null || _a === void 0 ? void 0 : _a.children)].filter(c => !!c.id).map(c => c.id);
    return existingChildren.filter(c => newChildrenIds.includes(c.id));
  }

  get performAction() {
    if (this.action) {
      const actionFunction = StreamActions[this.action];

      if (actionFunction) {
        return actionFunction;
      }

      this.raise("unknown action");
    }

    this.raise("action attribute is missing");
  }

  get targetElements() {
    if (this.target) {
      return this.targetElementsById;
    } else if (this.targets) {
      return this.targetElementsByQuery;
    } else {
      this.raise("target or targets attribute is missing");
    }
  }

  get templateContent() {
    return this.templateElement.content.cloneNode(true);
  }

  get templateElement() {
    if (this.firstElementChild instanceof HTMLTemplateElement) {
      return this.firstElementChild;
    }

    this.raise("first child element must be a <template> element");
  }

  get action() {
    return this.getAttribute("action");
  }

  get target() {
    return this.getAttribute("target");
  }

  get targets() {
    return this.getAttribute("targets");
  }

  raise(message) {
    throw new Error(`${this.description}: ${message}`);
  }

  get description() {
    var _a, _b;

    return (_b = ((_a = this.outerHTML.match(/<[^>]+>/)) !== null && _a !== void 0 ? _a : [])[0]) !== null && _b !== void 0 ? _b : "<turbo-stream>";
  }

  get beforeRenderEvent() {
    return new CustomEvent("turbo:before-stream-render", {
      bubbles: true,
      cancelable: true
    });
  }

  get targetElementsById() {
    var _a;

    const element = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.getElementById(this.target);

    if (element !== null) {
      return [element];
    } else {
      return [];
    }
  }

  get targetElementsByQuery() {
    var _a;

    const elements = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.querySelectorAll(this.targets);

    if (elements.length !== 0) {
      return Array.prototype.slice.call(elements);
    } else {
      return [];
    }
  }

}

FrameElement.delegateConstructor = FrameController;
customElements.define("turbo-frame", FrameElement);
customElements.define("turbo-stream", StreamElement);

(() => {
  let element = document.currentScript;
  if (!element) return;
  if (element.hasAttribute("data-turbo-suppress-warning")) return;

  while (element = element.parentElement) {
    if (element == document.body) {
      return console.warn(unindent`
        You are loading Turbo from a <script> element inside the <body> element. This is probably not what you meant to do!

        Load your application’s JavaScript bundle inside the <head> element instead. <script> elements in <body> are evaluated with each page change.

        For more information, see: https://turbo.hotwired.dev/handbook/building#working-with-script-elements

        ——
        Suppress this warning by adding a "data-turbo-suppress-warning" attribute to: %s
      `, element.outerHTML);
    }
  }
})();

window.Turbo = Turbo;
start();

let consumer;
async function getConsumer() {
  return consumer || setConsumer(createConsumer$1().then(setConsumer));
}
function setConsumer(newConsumer) {
  return consumer = newConsumer;
}
async function createConsumer$1() {
  const {
    createConsumer
  } = await Promise.resolve().then(function () { return index; });
  return createConsumer();
}
async function subscribeTo(channel, mixin) {
  const {
    subscriptions
  } = await getConsumer();
  return subscriptions.create(channel, mixin);
}

class TurboCableStreamSourceElement extends HTMLElement {
  async connectedCallback() {
    connectStreamSource(this);
    this.subscription = await subscribeTo(this.channel, {
      received: this.dispatchMessageEvent.bind(this)
    });
  }

  disconnectedCallback() {
    disconnectStreamSource(this);
    if (this.subscription) this.subscription.unsubscribe();
  }

  dispatchMessageEvent(data) {
    const event = new MessageEvent("message", {
      data
    });
    return this.dispatchEvent(event);
  }

  get channel() {
    const channel = this.getAttribute("channel");
    const signed_stream_name = this.getAttribute("signed-stream-name");
    return {
      channel,
      signed_stream_name
    };
  }

}

customElements.define("turbo-cable-stream-source", TurboCableStreamSourceElement);

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

function _defineProperty$1(obj, key, value) {
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

function ownKeys(object, enumerableOnly) {
  var keys = Object.keys(object);

  if (Object.getOwnPropertySymbols) {
    var symbols = Object.getOwnPropertySymbols(object);
    if (enumerableOnly) symbols = symbols.filter(function (sym) {
      return Object.getOwnPropertyDescriptor(object, sym).enumerable;
    });
    keys.push.apply(keys, symbols);
  }

  return keys;
}

function _objectSpread2(target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i] != null ? arguments[i] : {};

    if (i % 2) {
      ownKeys(Object(source), true).forEach(function (key) {
        _defineProperty$1(target, key, source[key]);
      });
    } else if (Object.getOwnPropertyDescriptors) {
      Object.defineProperties(target, Object.getOwnPropertyDescriptors(source));
    } else {
      ownKeys(Object(source)).forEach(function (key) {
        Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key));
      });
    }
  }

  return target;
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
    Date.prototype.toString.call(Reflect.construct(Date, [], function () {}));
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
  return function () {
    var Super = _getPrototypeOf(Derived),
        result;

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

var $$4 = window.$;
// to see e.g. notes or extended details) and each master row and its toggleable sibling are
// nested in a tbody (this is valid HTML) - ie there are probably two trs per tbody, and the last
// one is toggleable. If you need anyting more complex you'll need to clone or adapt this
// controller

var _default$k = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "row",
    // This handler toggles the last tr in the current tbody. We use multiple tbodys in each table
    // to make toggling like this simpler, and to group the related (visible and toggleable) rows
    // together.
    value: function row(event) {
      event.preventDefault;
      var tbody = event.target.closest("tbody");
      tbody.classList.toggle("toggleable--open"); // Update masonry - TODO: move to a module

      $$4(".mgrid > .row").masonry("layout");
    } // Toggle the last tr in each tbody in the current table.
    // The link that triggers this event will most likelt be a double chevron icon
    // sitting in a thead.

  }, {
    key: "table",
    value: function table(event) {
      event.preventDefault;
      var table = event.target.closest("table");
      var thead = event.target.closest("thead"); // Use an Array rather a NodeList here as IE does not support NodeList.forEach

      var tbodies = Array.prototype.slice.call(table.querySelectorAll("tbody"));
      var hide = thead.classList.contains("toggleable--open");
      thead.classList.toggle("toggleable--open");
      tbodies.forEach(function (tbody) {
        tbody.classList.toggle("toggleable--open", !hide);
      }); // Update masonry - TODO: move to a module

      $$4(".mgrid > .row").masonry("layout");
    }
  }]);

  return _default;
}(Controller);

var $$3 = window.$;

var _default$j = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
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
      this.containerTarget.classList.remove("undecided"); // The rest of this actions are using jQuery for now.

      $$3(".authentication", this.containerTarget).toggle(checked);
      $$3(".authentication", this.containerTarget).toggleClass("disabled-with-faded-overlay", !checked);
      $$3(".reason-why-not-administered", this.containerTarget).toggle(!checked);
      $$3("#btn_save_and_witness_later").toggle(checked);
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$j, "targets", ["container", "radio"]);

var Rails$2 = window.Rails;
// the user. Used on the prescrptions page.

var _default$i = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "refreshForm",
    // Submit and re-display the form when 'drug type' or 'prescription duration'
    // dropdowns are changed
    value: function refreshForm() {
      Rails$2.fire(this.formTarget, "submit");
    } // When the user has clicked Print (launching the PDF in a new tab), hide
    // the Print button and display content which asks whether printing was
    // successful or not. Click one of these 2 buttons will dismiss the modal.
    // FYI if they say Yes (printing was a success) the home delivery
    // event (the object 'behind' our modal form) is updated with printed=true.

  }, {
    key: "askForPrintFeedback",
    value: function askForPrintFeedback() {
      this.printOptionsTarget.classList.toggle("visuallyhidden");
      this.printFeedbackTarget.classList.toggle("visuallyhidden");
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$i, "targets", ["form", "printOptions", "printFeedback"]);

var $$2 = window.$;

var _default$h = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "insert",
    value: function insert(event) {
      // TODO: set up the trix editor in each page as data-target="snippets.trix"
      var modal = $$2("#snippets-modal");
      var snippetBody = $$2(event.target).parent().closest("tr").find(".body").html();
      var trix = document.querySelector("trix-editor");
      trix.editor.insertHTML(snippetBody);
      $$2(modal).foundation("reveal", "close");
    }
  }]);

  return _default;
}(Controller);

var $$1 = window.$;

var _default$g = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "initInsertEventNotesIntoTrixEditor",
    value: function initInsertEventNotesIntoTrixEditor(event) {
      event.preventDefault();
      var notes = $$1(event.target).data("notes");

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
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$g, "targets", ["trix"]);

// the user. Used on the prescrptions page.

var _default$f = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
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
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$f, "targets", ["homeDeliveryDates", "providers"]);

/*! (c) Andrea Giammarchi - ISC */
var self$1 = {};

try {
  (function (URLSearchParams, plus) {
    if (new URLSearchParams('q=%2B').get('q') !== plus || new URLSearchParams({
      q: plus
    }).get('q') !== plus || new URLSearchParams([['q', plus]]).get('q') !== plus || new URLSearchParams('q=\n').toString() !== 'q=%0A' || new URLSearchParams({
      q: ' &'
    }).toString() !== 'q=+%26' || new URLSearchParams({
      q: '%zx'
    }).toString() !== 'q=%25zx') throw URLSearchParams;
    self$1.URLSearchParams = URLSearchParams;
  })(URLSearchParams, '+');
} catch (URLSearchParams) {
  (function (Object, String, isArray) {

    var create = Object.create;
    var defineProperty = Object.defineProperty;
    var find = /[!'\(\)~]|%20|%00/g;
    var findPercentSign = /%(?![0-9a-fA-F]{2})/g;
    var plus = /\+/g;
    var replace = {
      '!': '%21',
      "'": '%27',
      '(': '%28',
      ')': '%29',
      '~': '%7E',
      '%20': '+',
      '%00': '\x00'
    };
    var proto = {
      append: function (key, value) {
        appendTo(this._ungap, key, value);
      },
      delete: function (key) {
        delete this._ungap[key];
      },
      get: function (key) {
        return this.has(key) ? this._ungap[key][0] : null;
      },
      getAll: function (key) {
        return this.has(key) ? this._ungap[key].slice(0) : [];
      },
      has: function (key) {
        return key in this._ungap;
      },
      set: function (key, value) {
        this._ungap[key] = [String(value)];
      },
      forEach: function (callback, thisArg) {
        var self = this;

        for (var key in self._ungap) self._ungap[key].forEach(invoke, key);

        function invoke(value) {
          callback.call(thisArg, value, String(key), self);
        }
      },
      toJSON: function () {
        return {};
      },
      toString: function () {
        var query = [];

        for (var key in this._ungap) {
          var encoded = encode(key);

          for (var i = 0, value = this._ungap[key]; i < value.length; i++) {
            query.push(encoded + '=' + encode(value[i]));
          }
        }

        return query.join('&');
      }
    };

    for (var key in proto) defineProperty(URLSearchParams.prototype, key, {
      configurable: true,
      writable: true,
      value: proto[key]
    });

    self$1.URLSearchParams = URLSearchParams;

    function URLSearchParams(query) {
      var dict = create(null);
      defineProperty(this, '_ungap', {
        value: dict
      });

      switch (true) {
        case !query:
          break;

        case typeof query === 'string':
          if (query.charAt(0) === '?') {
            query = query.slice(1);
          }

          for (var pairs = query.split('&'), i = 0, length = pairs.length; i < length; i++) {
            var value = pairs[i];
            var index = value.indexOf('=');

            if (-1 < index) {
              appendTo(dict, decode(value.slice(0, index)), decode(value.slice(index + 1)));
            } else if (value.length) {
              appendTo(dict, decode(value), '');
            }
          }

          break;

        case isArray(query):
          for (var i = 0, length = query.length; i < length; i++) {
            var value = query[i];
            appendTo(dict, value[0], value[1]);
          }

          break;

        case 'forEach' in query:
          query.forEach(addEach, dict);
          break;

        default:
          for (var key in query) appendTo(dict, key, query[key]);

      }
    }

    function addEach(value, key) {
      appendTo(this, key, value);
    }

    function appendTo(dict, key, value) {
      var res = isArray(value) ? value.join(',') : value;
      if (key in dict) dict[key].push(res);else dict[key] = [res];
    }

    function decode(str) {
      return decodeURIComponent(str.replace(findPercentSign, '%25').replace(plus, ' '));
    }

    function encode(str) {
      return encodeURIComponent(str).replace(find, replacer);
    }

    function replacer(match) {
      return replace[match];
    }
  })(Object, String, Array.isArray);
}

(function (URLSearchParamsProto) {
  var iterable = false;

  try {
    iterable = !!Symbol.iterator;
  } catch (o_O) {}
  /* istanbul ignore else */


  if (!('forEach' in URLSearchParamsProto)) {
    URLSearchParamsProto.forEach = function forEach(callback, thisArg) {
      var self = this;
      var names = Object.create(null);
      this.toString().replace(/=[\s\S]*?(?:&|$)/g, '=').split('=').forEach(function (name) {
        if (!name.length || name in names) return;
        (names[name] = self.getAll(name)).forEach(function (value) {
          callback.call(thisArg, value, name, self);
        });
      });
    };
  }
  /* istanbul ignore else */


  if (!('keys' in URLSearchParamsProto)) {
    URLSearchParamsProto.keys = function keys() {
      return iterator(this, function (value, key) {
        this.push(key);
      });
    };
  }
  /* istanbul ignore else */


  if (!('values' in URLSearchParamsProto)) {
    URLSearchParamsProto.values = function values() {
      return iterator(this, function (value, key) {
        this.push(value);
      });
    };
  }
  /* istanbul ignore else */


  if (!('entries' in URLSearchParamsProto)) {
    URLSearchParamsProto.entries = function entries() {
      return iterator(this, function (value, key) {
        this.push([key, value]);
      });
    };
  }
  /* istanbul ignore else */


  if (iterable && !(Symbol.iterator in URLSearchParamsProto)) {
    URLSearchParamsProto[Symbol.iterator] = URLSearchParamsProto.entries;
  }
  /* istanbul ignore else */


  if (!('sort' in URLSearchParamsProto)) {
    URLSearchParamsProto.sort = function sort() {
      var entries = this.entries(),
          entry = entries.next(),
          done = entry.done,
          keys = [],
          values = Object.create(null),
          i,
          key,
          value;

      while (!done) {
        value = entry.value;
        key = value[0];
        keys.push(key);

        if (!(key in values)) {
          values[key] = [];
        }

        values[key].push(value[1]);
        entry = entries.next();
        done = entry.done;
      } // not the champion in efficiency
      // but these two bits just do the job


      keys.sort();

      for (i = 0; i < keys.length; i++) {
        this.delete(keys[i]);
      }

      for (i = 0; i < keys.length; i++) {
        key = keys[i];
        this.append(key, values[key].shift());
      }
    };
  }

  function iterator(self, callback) {
    var items = [];
    self.forEach(callback, items);
    /* istanbul ignore next */

    return iterable ? items[Symbol.iterator]() : {
      next: function () {
        var value = items.shift();
        return {
          done: value === void 0,
          value: value
        };
      }
    };
  }
  /* istanbul ignore next */


  (function (Object) {
    var dP = Object.defineProperty,
        gOPD = Object.getOwnPropertyDescriptor,
        createSearchParamsPollute = function (search) {
      function append(name, value) {
        URLSearchParamsProto.append.call(this, name, value);
        name = this.toString();
        search.set.call(this._usp, name ? '?' + name : '');
      }

      function del(name) {
        URLSearchParamsProto.delete.call(this, name);
        name = this.toString();
        search.set.call(this._usp, name ? '?' + name : '');
      }

      function set(name, value) {
        URLSearchParamsProto.set.call(this, name, value);
        name = this.toString();
        search.set.call(this._usp, name ? '?' + name : '');
      }

      return function (sp, value) {
        sp.append = append;
        sp.delete = del;
        sp.set = set;
        return dP(sp, '_usp', {
          configurable: true,
          writable: true,
          value: value
        });
      };
    },
        createSearchParamsCreate = function (polluteSearchParams) {
      return function (obj, sp) {
        dP(obj, '_searchParams', {
          configurable: true,
          writable: true,
          value: polluteSearchParams(sp, obj)
        });
        return sp;
      };
    },
        updateSearchParams = function (sp) {
      var append = sp.append;
      sp.append = URLSearchParamsProto.append;
      URLSearchParams.call(sp, sp._usp.search.slice(1));
      sp.append = append;
    },
        verifySearchParams = function (obj, Class) {
      if (!(obj instanceof Class)) throw new TypeError("'searchParams' accessed on an object that " + "does not implement interface " + Class.name);
    },
        upgradeClass = function (Class) {
      var ClassProto = Class.prototype,
          searchParams = gOPD(ClassProto, 'searchParams'),
          href = gOPD(ClassProto, 'href'),
          search = gOPD(ClassProto, 'search'),
          createSearchParams;

      if (!searchParams && search && search.set) {
        createSearchParams = createSearchParamsCreate(createSearchParamsPollute(search));
        Object.defineProperties(ClassProto, {
          href: {
            get: function () {
              return href.get.call(this);
            },
            set: function (value) {
              var sp = this._searchParams;
              href.set.call(this, value);
              if (sp) updateSearchParams(sp);
            }
          },
          search: {
            get: function () {
              return search.get.call(this);
            },
            set: function (value) {
              var sp = this._searchParams;
              search.set.call(this, value);
              if (sp) updateSearchParams(sp);
            }
          },
          searchParams: {
            get: function () {
              verifySearchParams(this, Class);
              return this._searchParams || createSearchParams(this, new URLSearchParams(this.search.slice(1)));
            },
            set: function (sp) {
              verifySearchParams(this, Class);
              createSearchParams(this, sp);
            }
          }
        });
      }
    };

    try {
      upgradeClass(HTMLAnchorElement);
      if (/^function|object$/.test(typeof URL) && URL.prototype) upgradeClass(URL);
    } catch (meh) {}
  })(Object);
})(self$1.URLSearchParams.prototype);

var URLSearchParams$1 = self$1.URLSearchParams;

var Highcharts$2 = window.Highcharts;

var _default$e = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "initialize",
    value: function initialize() {
      this.getJson();
      this.addCurrentPeriodClassToDefaultPeriod();
    } // A user clicked on a period link eg "3y"
    // Update the 'period' stimulus 'value' data attribute on the controller element in the DOM with
    // the data-period attribute on the clicked link, and then refresh the graph, which will request
    // json for the selected time period eg "3y"

  }, {
    key: "periodChanged",
    value: function periodChanged(event) {
      this.periodValue = event.target.getAttribute("data-period");
      this.removeCurrentClassFromAllPeriods();
      this.addCurrentClassToSelectedPeriod(event.target);
      this.getJson();
    }
  }, {
    key: "removeCurrentClassFromAllPeriods",
    value: function removeCurrentClassFromAllPeriods() {
      this.periodTargets.forEach(function (el) {
        el.classList.remove("current-period");
      });
    }
  }, {
    key: "addCurrentPeriodClassToDefaultPeriod",
    value: function addCurrentPeriodClassToDefaultPeriod() {
      var _this = this;

      this.periodTargets.forEach(function (el) {
        if (el.getAttribute("data-period") == _this.periodValue) {
          _this.addCurrentClassToSelectedPeriod(el);
        }
      });
    }
  }, {
    key: "addCurrentClassToSelectedPeriod",
    value: function addCurrentClassToSelectedPeriod(el) {
      el.classList.add(this.currentPeriodClass);
    }
  }, {
    key: "updateChart",
    value: function updateChart(json) {
      Highcharts$2.chart(this.chartTarget, {
        chart: {
          zoomType: "x"
        },
        credits: {
          enabled: false
        },
        title: {
          text: this.titleValue,
          align: "left"
        },
        xAxis: {
          type: "datetime"
        },
        yAxis: {
          type: this.yAxisTypeValue,
          title: {
            text: this.yAxisLabelValue
          }
        },
        tooltip: {
          headerFormat: "<b>{series.name}</b><br>",
          pointFormat: "{point.x:%e-%b-%Y}: {point.y:.2f}"
        },
        plotOptions: {
          series: {
            animation: {
              duration: 500
            },
            marker: {
              enabled: true
            }
          }
        },
        series: json,
        responsive: {
          rules: [{
            condition: {
              maxWidth: 500
            },
            chartOptions: {
              plotOptions: {
                series: {
                  marker: {
                    radius: 2.5
                  }
                }
              }
            }
          }]
        }
      });
    }
  }, {
    key: "getJson",
    value: function getJson() {
      var _this2 = this;

      fetch(this.urlValue + "?" + new URLSearchParams$1({
        period: this.periodValue
      }), {
        credentials: "same-origin",
        headers: new Headers({
          "content-type": "application/json"
        })
      }).then(function (response) {
        return response.json();
      }).then(function (json) {
        _this2.updateChart(json);
      });
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$e, "targets", ["chart", // chart container
"period" // array of period (10y, 3y..) links
]);

_defineProperty$1(_default$e, "values", {
  url: String,
  // API endpoint for chart json
  title: String,
  // Chart title
  period: String,
  // State for the last selected period
  yAxisLabel: String,
  // eg Kg
  yAxisType: String // linear or logarithmic

});

_defineProperty$1(_default$e, "classes", ["currentPeriod" // Maps to a CSS class name via data attribute on controller element
]);

var Rails$1 = window.Rails;
var _ = window._;
// - Keep a users session alive
//   Keep the user's session alive if they are 'active' (there are keypresses,
//   clicks or resize events on the same page) by sending a throttled ajax
//   request to reset the session window which will prevent their session
//   expiring and throwing them out when they are for example writing a long
//   letter (which they would otherwise not finish before their session expires)
// - Auto logging-out a user after a period of inactivity
//   Check after a period of intactivity to see if their session has expired.
//   If it has then refresh the page which will redirect them to the login page.
// - Signalling to other open tabs when the user's session has expired or they
//   have manually logged out - so that all tabs go to the login page at around
//   the same time.
//
// Goals:
// - Performance and code clarity more important than having an accurate session
//   window - if it is extended for a minute or two that is OK.
// - The server should always be the judge of whether the session has timed out
// - Query the server as little as possible - partly for performance and partly
//   to avoid noise in the server logs
// - Keep event handler activity minimal to preserve CPU cycles - ie use
//   throttle or debounce
//
// Possible enhancements:
// - After a period of inactivity, show a dialog asking if user wants to extend
//   the session - this would involve starting a separate timer and displaying
//   the countdown
//
// Scenarios to test:
// - Keypresses, clicks and window resizing - any of these should reset session
//   and thus the user remains logged in as long as one of these events ocurrs
//   within sessionTimeoutSeconds
// - User closes lid on laptop overnight and reopens in the morning - what is
//   expected?
// - Network disconnected - what do we do?
// - user gets withing 10 seconds of session timeout and starts typing - session
//   window shoud be reset
// - user has > 1 tab open and logs out of one - ideally it should log out of
//   other tabs before too long. We do by setting a localStorage value to signal
//   to other tabs
//
// Known issues:
// - user sitting on register page will keep polling checkAlivePath
// - if a user becomes active on a page within throttlePeriodSeconds of
//   sessionTimeoutSeconds then there is no currently opportunity for
//   throttledRegisterUserActivity to reset kick in a trump
//   checkForSessionExpiryTimeout - so the session will log out. We might need
//   an extra step before calling checkForSessionExpiry - a final chance to
//   check if the user was
//   active
// - Not quite sure if putting the data attribute config settings in the body
//   tag is the right thing to do - perhaps should be in a config .js.erb

var _default$d = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    var _this;

    _classCallCheck(this, _default);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _super.call.apply(_super, [this].concat(args));

    _defineProperty$1(_assertThisInitialized(_this), "checkForSessionExpiryTimeout", null);

    _defineProperty$1(_assertThisInitialized(_this), "userActivityDetected", false);

    _defineProperty$1(_assertThisInitialized(_this), "checkAlivePath", null);

    _defineProperty$1(_assertThisInitialized(_this), "keepAlivePath", null);

    _defineProperty$1(_assertThisInitialized(_this), "loginPath", null);

    _defineProperty$1(_assertThisInitialized(_this), "throttledRegisterUserActivity", null);

    _defineProperty$1(_assertThisInitialized(_this), "sessionTimeoutSeconds", 0);

    _defineProperty$1(_assertThisInitialized(_this), "defaultSessionTimeoutSeconds", 20 * 60);

    _defineProperty$1(_assertThisInitialized(_this), "throttlePeriodSeconds", 0);

    _defineProperty$1(_assertThisInitialized(_this), "defaultThrottlePeriodSeconds", 20);

    return _this;
  }

  _createClass(_default, [{
    key: "initialize",
    value: function initialize() {
      this.throttlePeriodSeconds = parseInt(this.data.get("register-user-activity-after") || this.defaultThrottlePeriodSeconds);
      this.sessionTimeoutSeconds = parseInt(this.data.get("timeout") || this.defaultSessionTimeoutSeconds);
      this.sessionTimeoutSeconds += 10; // To allow for network roundtrips etc

      this.checkAlivePath = this.data.get("check-alive-path");
      this.loginPath = this.data.get("login-path");
      this.keepAlivePath = this.data.get("keep-alive-path");
      this.logSettings(); // Throttle the user activity callback because we only need to know about user activity
      // only very occasionally, so that we can periodically tell there server the user was active.
      // Here, even if there are hundreds of events (click, keypress etc) within throttlePeriodSeconds,
      // our function is only called at most once in that period, when throttlePeriodSeconds has
      // passed (since trailing = true). This suits is as we want to avoid making any call to the
      // server unless the user has been on the page for at least throttlePeriodSeconds.
      // See https://lodash.com/docs/#trottle

      this.throttledRegisterUserActivity = _.throttle(this.registerUserActivity.bind(this), this.throttlePeriodSeconds * 1000, {
        "leading": false,
        "trailing": true
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
    } // Debounced event handler for key/click/resize
    // If we come in there then the user has interacted with the page
    // within throttlePeriodSeconds

  }, {
    key: "registerUserActivity",
    value: function registerUserActivity() {
      this.sendRequestToKeepSessionAlive();
      this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds);
    } // Timeout handler for checking if the sesison has expired

  }, {
    key: "resetCheckForSessionExpiryTimeout",
    value: function resetCheckForSessionExpiryTimeout(intervalSeconds) {
      this.log("resetting session expiry timeout ".concat(intervalSeconds));
      clearTimeout(this.checkForSessionExpiryTimeout);
      this.checkForSessionExpiryTimeout = setTimeout(this.checkForSessionExpiry.bind(this), intervalSeconds * 1000);
    } // Here we really expect the session to have expired. In case it hasn't
    // we reset the timeout to check again. We could reset the timeout to be
    // sessionTimeoutSeconds, but if when we checked for expiry we had only just
    // missed it, we will end up staying on this page (assuming the user is
    // inactive) for nearly twice as long as we need to. So we set the timeout
    // to be throttlePeriodSeconds * 2, which gives time for the
    // throttledRegisterUserActivity handler to reset the session again if it
    // fires.

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
    } // An event handler to watch for changes in the value of the local storage item called
    // 'logged_in'. We use localStorage as a cross-tab communication protocol: when the user has
    // logged out of one tab, this mechanism is used to signal to any other logged-in tabs that they
    // should log themselves out.
    // This applies in 2 circumstances:
    // - the user has clicked the "Log Out" link in the navbar - the sendLogoutMessageToAnyOpenTabs()
    //   action defined above is called
    // - our tab has timed out due to inactivity; other open tabs may not timeout for another few
    //   minutes (depending on the polling frequency etc) so we give them a nudge.

  }, {
    key: "storageChange",
    value: function storageChange(event) {
      if (event.key == "logout-event") {
        setTimeout(this.sendRequestToTestForSessionExpiry.bind(this), 2000);
      }
    }
  }, {
    key: "onLoginPage",
    get: function get() {
      return window.location.pathname == this.loginPath;
    } // If you add data-session-debug=1 then logging will be enabled
    // This is evaluated each time we can add debugging into a running page

  }, {
    key: "debug",
    get: function get() {
      return this.data.get("debug") === "true";
    }
  }]);

  return _default;
}(Controller);

var _default$c = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      this.toggleClass = this.data.get("class") || "hidden";
    }
  }, {
    key: "toggle",
    value: function toggle(event) {
      var _this = this;

      event.preventDefault();
      this.toggleableTargets.forEach(function (target) {
        target.classList.toggle(_this.toggleClass);
      });
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$c, "targets", ["toggleable"]);

var _default$b = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
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

      this.tabTargets.forEach(function (tab, index) {
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
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$b, "targets", ["tab", "panel"]);

var highchartsMore = createCommonjsModule(function (module) {
/*
 Highcharts JS v8.0.4 (2020-03-10)

 (c) 2009-2018 Torstein Honsi

 License: www.highcharts.com/license
*/
(function (f) {
  module.exports ? (f["default"] = f, module.exports = f) : f("undefined" !== typeof Highcharts ? Highcharts : void 0);
})(function (f) {
  function E(l, a, c, b) {
    l.hasOwnProperty(a) || (l[a] = b.apply(null, c));
  }

  f = f ? f._modules : {};
  E(f, "parts-more/Pane.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    function c(d, b, n) {
      return Math.sqrt(Math.pow(d - n[0], 2) + Math.pow(b - n[1], 2)) < n[2] / 2;
    }

    var b = a.addEvent,
        u = a.extend,
        v = a.merge,
        w = a.pick,
        f = a.splat,
        y = l.CenteredSeriesMixin;
    l.Chart.prototype.collectionsWithUpdate.push("pane");

    a = function () {
      function d(d, b) {
        this.options = this.chart = this.center = this.background = void 0;
        this.coll = "pane";
        this.defaultOptions = {
          center: ["50%", "50%"],
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
            stops: [[0, "#ffffff"], [1, "#e6e6e6"]]
          },
          from: -Number.MAX_VALUE,
          innerRadius: 0,
          to: Number.MAX_VALUE,
          outerRadius: "105%"
        };
        this.init(d, b);
      }

      d.prototype.init = function (d, b) {
        this.chart = b;
        this.background = [];
        b.pane.push(this);
        this.setOptions(d);
      };

      d.prototype.setOptions = function (d) {
        this.options = v(this.defaultOptions, this.chart.angular ? {
          background: {}
        } : void 0, d);
      };

      d.prototype.render = function () {
        var d = this.options,
            b = this.options.background,
            a = this.chart.renderer;
        this.group || (this.group = a.g("pane-group").attr({
          zIndex: d.zIndex || 0
        }).add());
        this.updateCenter();
        if (b) for (b = f(b), d = Math.max(b.length, this.background.length || 0), a = 0; a < d; a++) b[a] && this.axis ? this.renderBackground(v(this.defaultBackgroundOptions, b[a]), a) : this.background[a] && (this.background[a] = this.background[a].destroy(), this.background.splice(a, 1));
      };

      d.prototype.renderBackground = function (d, b) {
        var a = "animate",
            n = {
          "class": "highcharts-pane " + (d.className || "")
        };
        this.chart.styledMode || u(n, {
          fill: d.backgroundColor,
          stroke: d.borderColor,
          "stroke-width": d.borderWidth
        });
        this.background[b] || (this.background[b] = this.chart.renderer.path().add(this.group), a = "attr");
        this.background[b][a]({
          d: this.axis.getPlotBandPath(d.from, d.to, d)
        }).attr(n);
      };

      d.prototype.updateCenter = function (d) {
        this.center = (d || this.axis || {}).center = y.getCenter.call(this);
      };

      d.prototype.update = function (d, b) {
        v(!0, this.options, d);
        v(!0, this.chart.options.pane, d);
        this.setOptions(this.options);
        this.render();
        this.chart.axes.forEach(function (d) {
          d.pane === this && (d.pane = null, d.update({}, b));
        }, this);
      };

      return d;
    }();

    l.Chart.prototype.getHoverPane = function (d) {
      var b = this,
          a;
      d && b.pane.forEach(function (n) {
        var m = d.chartX - b.plotLeft,
            t = d.chartY - b.plotTop;
        c(b.inverted ? t : m, b.inverted ? m : t, n.center) && (a = n);
      });
      return a;
    };

    b(l.Chart, "afterIsInsidePlot", function (d) {
      this.polar && (d.isInsidePlot = this.pane.some(function (b) {
        return c(d.x, d.y, b.center);
      }));
    });
    b(l.Pointer, "beforeGetHoverData", function (d) {
      var b = this.chart;
      b.polar && (b.hoverPane = b.getHoverPane(d), d.filter = function (a) {
        return a.visible && !(!d.shared && a.directTouch) && w(a.options.enableMouseTracking, !0) && (!b.hoverPane || a.xAxis.pane === b.hoverPane);
      });
    });
    b(l.Pointer, "afterGetHoverData", function (d) {
      var b = this.chart;
      d.hoverPoint && d.hoverPoint.plotX && d.hoverPoint.plotY && b.hoverPane && !c(d.hoverPoint.plotX, d.hoverPoint.plotY, b.hoverPane.center) && (d.hoverPoint = void 0);
    });
    l.Pane = a;
    return l.Pane;
  });
  E(f, "parts-more/RadialAxis.js", [f["parts/Globals.js"], f["parts/Tick.js"], f["parts/Utilities.js"]], function (l, a, c) {
    var b = c.addEvent,
        u = c.correctFloat,
        v = c.defined,
        w = c.extend,
        f = c.merge,
        y = c.pick,
        d = c.pInt,
        m = c.relativeLength;
    c = c.wrap;
    var n = l.Axis,
        t = l.noop,
        x = n.prototype,
        A = a.prototype;
    var r = {
      getOffset: t,
      redraw: function () {
        this.isDirty = !1;
      },
      render: function () {
        this.isDirty = !1;
      },
      createLabelCollector: function () {
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
      setOptions: function (h) {
        h = this.options = f(this.defaultOptions, this.defaultPolarOptions, h);
        h.plotBands || (h.plotBands = []);
        l.fireEvent(this, "afterSetOptions");
      },
      getOffset: function () {
        x.getOffset.call(this);
        this.chart.axisOffset[this.side] = 0;
      },
      getLinePath: function (h, g, e) {
        h = this.pane.center;
        var k = this.chart,
            p = y(g, h[2] / 2 - this.offset);
        "undefined" === typeof e && (e = this.horiz ? 0 : this.center && -this.center[3] / 2);
        e && (p += e);
        this.isCircular || "undefined" !== typeof g ? (g = this.chart.renderer.symbols.arc(this.left + h[0], this.top + h[1], p, p, {
          start: this.startAngleRad,
          end: this.endAngleRad,
          open: !0,
          innerR: 0
        }), g.xBounds = [this.left + h[0]], g.yBounds = [this.top + h[1] - p]) : (g = this.postTranslate(this.angleRad, p), g = ["M", this.center[0] + k.plotLeft, this.center[1] + k.plotTop, "L", g.x, g.y]);
        return g;
      },
      setAxisTranslation: function () {
        x.setAxisTranslation.call(this);
        this.center && (this.transA = this.isCircular ? (this.endAngleRad - this.startAngleRad) / (this.max - this.min || 1) : (this.center[2] - this.center[3]) / 2 / (this.max - this.min || 1), this.minPixelPadding = this.isXAxis ? this.transA * this.minPointOffset : 0);
      },
      beforeSetTickPositions: function () {
        this.autoConnect = this.isCircular && "undefined" === typeof y(this.userMax, this.options.max) && u(this.endAngleRad - this.startAngleRad) === u(2 * Math.PI);
        !this.isCircular && this.chart.inverted && this.max++;
        this.autoConnect && (this.max += this.categories && 1 || this.pointRange || this.closestPointRange || 0);
      },
      setAxisSize: function () {
        x.setAxisSize.call(this);

        if (this.isRadial) {
          this.pane.updateCenter(this);
          var h = this.center = w([], this.pane.center);
          if (this.isCircular) this.sector = this.endAngleRad - this.startAngleRad;else {
            var g = this.postTranslate(this.angleRad, h[3] / 2);
            h[0] = g.x - this.chart.plotLeft;
            h[1] = g.y - this.chart.plotTop;
          }
          this.len = this.width = this.height = (h[2] - h[3]) * y(this.sector, 1) / 2;
        }
      },
      getPosition: function (h, g) {
        h = this.translate(h);
        return this.postTranslate(this.isCircular ? h : this.angleRad, y(this.isCircular ? g : 0 > h ? 0 : h, this.center[2] / 2) - this.offset);
      },
      postTranslate: function (h, g) {
        var e = this.chart,
            k = this.center;
        h = this.startAngleRad + h;
        return {
          x: e.plotLeft + k[0] + Math.cos(h) * g,
          y: e.plotTop + k[1] + Math.sin(h) * g
        };
      },
      getPlotBandPath: function (h, g, e) {
        var k = this.center,
            p = this.startAngleRad,
            C = k[2] / 2,
            q = [y(e.outerRadius, "100%"), e.innerRadius, y(e.thickness, 10)],
            r = Math.min(this.offset, 0),
            b = /%$/;
        var a = this.isCircular;
        if ("polygon" === this.options.gridLineInterpolation) q = this.getPlotLinePath({
          value: h
        }).concat(this.getPlotLinePath({
          value: g,
          reverse: !0
        }));else {
          h = Math.max(h, this.min);
          g = Math.min(g, this.max);
          a || (q[0] = this.translate(h), q[1] = this.translate(g));
          q = q.map(function (e) {
            b.test(e) && (e = d(e, 10) * C / 100);
            return e;
          });
          if ("circle" !== e.shape && a) h = p + this.translate(h), g = p + this.translate(g);else {
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
          a && (a = (g + h) / 2, r = this.left + k[0] + k[2] / 2 * Math.cos(a), q.xBounds = a > -Math.PI / 2 && a < Math.PI / 2 ? [r, this.chart.plotWidth] : [0, r], q.yBounds = [this.top + k[1] + k[2] / 2 * Math.sin(a)], q.yBounds[0] += a > -Math.PI && 0 > a || a > Math.PI ? -10 : 10);
        }
        return q;
      },
      getCrosshairPosition: function (h, g, e) {
        var k = h.value,
            p = this.pane.center;

        if (this.isCircular) {
          if (v(k)) h.point && (d = h.point.shapeArgs || {}, d.start && (k = this.chart.inverted ? this.translate(h.point.rectPlotY, !0) : h.point.x));else {
            var d = h.chartX || 0;
            var q = h.chartY || 0;
            k = this.translate(Math.atan2(q - e, d - g) - this.startAngleRad, !0);
          }
          h = this.getPosition(k);
          d = h.x;
          q = h.y;
        } else v(k) || (d = h.chartX, q = h.chartY), v(d) && v(q) && (e = p[1] + this.chart.plotTop, k = this.translate(Math.min(Math.sqrt(Math.pow(d - g, 2) + Math.pow(q - e, 2)), p[2] / 2) - p[3] / 2, !0));

        return [k, d || 0, q || 0];
      },
      getPlotLinePath: function (h) {
        var g = this,
            e = g.pane.center,
            k = g.chart,
            p = k.inverted,
            d = h.value,
            q = h.reverse,
            r = g.getPosition(d),
            b = g.pane.options.background ? g.pane.options.background[0] || g.pane.options.background : {},
            a = b.innerRadius || "0%",
            n = b.outerRadius || "100%";
        b = e[0] + k.plotLeft;
        var c = e[1] + k.plotTop,
            t = r.x,
            x = r.y,
            u = g.height;
        r = e[3] / 2;
        var v, l;
        h.isCrosshair && (x = this.getCrosshairPosition(h, b, c), d = x[0], t = x[1], x = x[2]);

        if (g.isCircular) {
          q = Math.sqrt(Math.pow(t - b, 2) + Math.pow(x - c, 2));
          a = "string" === typeof a ? m(a, 1) : a / q;
          n = "string" === typeof n ? m(n, 1) : n / q;
          e && r && (e = r / q, a < e && (a = e), n < e && (n = e));
          var w = ["M", b + a * (t - b), c - a * (c - x), "L", t - (1 - n) * (t - b), x + (1 - n) * (c - x)];
        } else (d = g.translate(d)) && (0 > d || d > u) && (d = 0), "circle" === g.options.gridLineInterpolation ? w = g.getLinePath(0, d, r) : (k[p ? "yAxis" : "xAxis"].forEach(function (e) {
          e.pane === g.pane && (v = e);
        }), w = [], e = v.tickPositions, v.autoConnect && (e = e.concat([e[0]])), q && (e = [].concat(e).reverse()), d && (d += r), e.forEach(function (e, k) {
          l = v.getPosition(e, d);
          w.push(k ? "L" : "M", l.x, l.y);
        }));

        return w;
      },
      getTitlePosition: function () {
        var h = this.center,
            g = this.chart,
            e = this.options.title;
        return {
          x: g.plotLeft + h[0] + (e.x || 0),
          y: g.plotTop + h[1] - {
            high: .5,
            middle: .25,
            low: 0
          }[e.align] * h[2] + (e.y || 0)
        };
      },
      createLabelCollector: function () {
        var h = this;
        return function () {
          if (h.isRadial && h.tickPositions && !0 !== h.options.labels.allowOverlap) return h.tickPositions.map(function (g) {
            return h.ticks[g] && h.ticks[g].label;
          }).filter(function (g) {
            return !!g;
          });
        };
      }
    };
    b(n, "init", function (h) {
      var g = this.chart,
          e = g.inverted,
          k = g.angular,
          d = g.polar,
          b = this.isXAxis,
          q = this.coll,
          a = k && b,
          n,
          c = g.options;
      h = h.userOptions.pane || 0;
      h = this.pane = g.pane && g.pane[h];
      if ("colorAxis" === q) this.isRadial = !1;else {
        if (k) {
          if (w(this, a ? r : p), n = !b) this.defaultPolarOptions = this.defaultRadialGaugeOptions;
        } else d && (w(this, p), this.defaultPolarOptions = (n = this.horiz) ? this.defaultCircularOptions : f("xAxis" === q ? this.defaultOptions : this.defaultYAxisOptions, this.defaultRadialOptions), e && "yAxis" === q && (this.defaultPolarOptions.stackLabels = this.defaultYAxisOptions.stackLabels));

        k || d ? (this.isRadial = !0, c.chart.zoomType = null, this.labelCollector || (this.labelCollector = this.createLabelCollector()), this.labelCollector && g.labelCollectors.push(this.labelCollector)) : this.isRadial = !1;
        h && n && (h.axis = this);
        this.isCircular = n;
      }
    });
    b(n, "afterInit", function () {
      var h = this.chart,
          g = this.options,
          e = this.pane,
          k = e && e.options;
      h.angular && this.isXAxis || !e || !h.angular && !h.polar || (this.angleRad = (g.angle || 0) * Math.PI / 180, this.startAngleRad = (k.startAngle - 90) * Math.PI / 180, this.endAngleRad = (y(k.endAngle, k.startAngle + 360) - 90) * Math.PI / 180, this.offset = g.offset || 0);
    });
    b(n, "autoLabelAlign", function (h) {
      this.isRadial && (h.align = void 0, h.preventDefault());
    });
    b(n, "destroy", function () {
      if (this.chart && this.chart.labelCollectors) {
        var h = this.chart.labelCollectors.indexOf(this.labelCollector);
        0 <= h && this.chart.labelCollectors.splice(h, 1);
      }
    });
    b(a, "afterGetPosition", function (h) {
      this.axis.getPosition && w(h.pos, this.axis.getPosition(this.pos));
    });
    b(a, "afterGetLabelPosition", function (h) {
      var g = this.axis,
          e = this.label,
          k = e.getBBox(),
          d = g.options.labels,
          p = d.y,
          q = 20,
          r = d.align,
          b = (g.translate(this.pos) + g.startAngleRad + Math.PI / 2) / Math.PI * 180 % 360,
          a = Math.round(b),
          n = "end",
          c = 0 > a ? a + 360 : a,
          x = c,
          t = 0,
          u = 0,
          v = null === d.y ? .3 * -k.height : 0;

      if (g.isRadial) {
        var l = g.getPosition(this.pos, g.center[2] / 2 + m(y(d.distance, -25), g.center[2] / 2, -g.center[2] / 2));
        "auto" === d.rotation ? e.attr({
          rotation: b
        }) : null === p && (p = g.chart.renderer.fontMetrics(e.styles && e.styles.fontSize).b - k.height / 2);
        null === r && (g.isCircular ? (k.width > g.len * g.tickInterval / (g.max - g.min) && (q = 0), r = b > q && b < 180 - q ? "left" : b > 180 + q && b < 360 - q ? "right" : "center") : r = "center", e.attr({
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
    c(A, "getMarkPath", function (h, g, e, k, d, p, q) {
      var r = this.axis;
      r.isRadial ? (h = r.getPosition(this.pos, r.center[2] / 2 + k), g = ["M", g, e, "L", h.x, h.y]) : g = h.call(this, g, e, k, d, p, q);
      return g;
    });
  });
  E(f, "parts-more/AreaRangeSeries.js", [f["parts/Globals.js"], f["parts/Point.js"], f["parts/Utilities.js"]], function (l, a, c) {
    var b = c.defined,
        u = c.extend,
        v = c.isArray,
        w = c.isNumber,
        f = c.pick;
    c = c.seriesType;
    var y = l.seriesTypes,
        d = l.Series.prototype,
        m = a.prototype;
    c("arearange", "area", {
      lineWidth: 1,
      threshold: null,
      tooltip: {
        pointFormat: '<span style="color:{series.color}">\u25cf</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'
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
      pointArrayMap: ["low", "high"],
      pointValKey: "low",
      deferTranslatePolar: !0,
      toYData: function (d) {
        return [d.low, d.high];
      },
      highToXY: function (d) {
        var b = this.chart,
            a = this.xAxis.postTranslate(d.rectPlotX, this.yAxis.len - d.plotHigh);
        d.plotHighX = a.x - b.plotLeft;
        d.plotHigh = a.y - b.plotTop;
        d.plotLowX = d.plotX;
      },
      translate: function () {
        var d = this,
            b = d.yAxis,
            a = !!d.modifyValue;
        y.area.prototype.translate.apply(d);
        d.points.forEach(function (c) {
          var r = c.high,
              p = c.plotY;
          c.isNull ? c.plotY = null : (c.plotLow = p, c.plotHigh = b.translate(a ? d.modifyValue(r, c) : r, 0, 1, 0, 1), a && (c.yBottom = c.plotHigh));
        });
        this.chart.polar && this.points.forEach(function (b) {
          d.highToXY(b);
          b.tooltipPos = [(b.plotHighX + b.plotLowX) / 2, (b.plotHigh + b.plotLow) / 2];
        });
      },
      getGraphPath: function (d) {
        var b = [],
            a = [],
            c,
            r = y.area.prototype.getGraphPath;
        var p = this.options;
        var h = this.chart.polar && !1 !== p.connectEnds,
            g = p.connectNulls,
            e = p.step;
        d = d || this.points;

        for (c = d.length; c--;) {
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
      drawDataLabels: function () {
        var b = this.points,
            a = b.length,
            c,
            m = [],
            r = this.options.dataLabels,
            p,
            h = this.chart.inverted;
        if (v(r)) {
          if (1 < r.length) {
            var g = r[0];
            var e = r[1];
          } else g = r[0], e = {
            enabled: !1
          };
        } else g = u({}, r), g.x = r.xHigh, g.y = r.yHigh, e = u({}, r), e.x = r.xLow, e.y = r.yLow;

        if (g.enabled || this._hasPointLabels) {
          for (c = a; c--;) if (p = b[c]) {
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

          for (c = a; c--;) if (p = b[c]) p.dataLabelUpper = p.dataLabel, p.dataLabel = m[c], delete p.dataLabels, p.y = p.low, p.plotY = p._plotY;
        }

        if (e.enabled || this._hasPointLabels) {
          for (c = a; c--;) if (p = b[c]) k = e.inside ? p.plotHigh < p.plotLow : p.plotHigh > p.plotLow, p.below = !k, h ? e.align || (e.align = k ? "left" : "right") : e.verticalAlign || (e.verticalAlign = k ? "bottom" : "top");

          this.options.dataLabels = e;
          d.drawDataLabels && d.drawDataLabels.apply(this, arguments);
        }

        if (g.enabled) for (c = a; c--;) if (p = b[c]) p.dataLabels = [p.dataLabelUpper, p.dataLabel].filter(function (e) {
          return !!e;
        });
        this.options.dataLabels = r;
      },
      alignDataLabel: function () {
        y.column.prototype.alignDataLabel.apply(this, arguments);
      },
      drawPoints: function () {
        var a = this.points.length,
            c;
        d.drawPoints.apply(this, arguments);

        for (c = 0; c < a;) {
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

        for (c = 0; c < a;) m = this.points[c], m.upperGraphic = m.graphic, m.graphic = m.lowerGraphic, u(m, m.origProps), delete m.origProps, c++;
      },
      setStackedPoints: l.noop
    }, {
      setState: function () {
        var d = this.state,
            a = this.series,
            c = a.chart.polar;
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
        a.stateMarkerGraphic && (a.upperStateMarkerGraphic = a.stateMarkerGraphic, a.stateMarkerGraphic = a.lowerStateMarkerGraphic, a.lowerStateMarkerGraphic = void 0);
        m.setState.apply(this, arguments);
      },
      haloPath: function () {
        var d = this.series.chart.polar,
            a = [];
        this.plotY = this.plotLow;
        d && (this.plotX = this.plotLowX);
        this.isInside && (a = m.haloPath.apply(this, arguments));
        this.plotY = this.plotHigh;
        d && (this.plotX = this.plotHighX);
        this.isTopInside && (a = a.concat(m.haloPath.apply(this, arguments)));
        return a;
      },
      destroyElements: function () {
        ["lowerGraphic", "upperGraphic"].forEach(function (d) {
          this[d] && (this[d] = this[d].destroy());
        }, this);
        this.graphic = null;
        return m.destroyElements.apply(this, arguments);
      },
      isValid: function () {
        return w(this.low) && w(this.high);
      }
    });
  });
  E(f, "parts-more/AreaSplineRangeSeries.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    a = a.seriesType;
    a("areasplinerange", "arearange", null, {
      getPointSpline: l.seriesTypes.spline.prototype.getPointSpline
    });
  });
  E(f, "parts-more/ColumnRangeSeries.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    var c = a.clamp,
        b = a.merge,
        u = a.pick;
    a = a.seriesType;
    var v = l.defaultPlotOptions,
        w = l.noop,
        f = l.seriesTypes.column.prototype;
    a("columnrange", "arearange", b(v.column, v.arearange, {
      pointRange: null,
      marker: null,
      states: {
        hover: {
          halo: !1
        }
      }
    }), {
      translate: function () {
        var a = this,
            d = a.yAxis,
            b = a.xAxis,
            n = b.startAngleRad,
            v,
            l = a.chart,
            w = a.xAxis.isRadial,
            r = Math.max(l.chartWidth, l.chartHeight) + 999,
            p;
        f.translate.apply(a);
        a.points.forEach(function (h) {
          var g = h.shapeArgs,
              e = a.options.minPointLength;
          h.plotHigh = p = c(d.translate(h.high, 0, 1, 0, 1), -r, r);
          h.plotLow = c(h.plotY, -r, r);
          var k = p;
          var B = u(h.rectPlotY, h.plotY) - p;
          Math.abs(B) < e ? (e -= B, B += e, k -= e / 2) : 0 > B && (B *= -1, k -= B);
          w ? (v = h.barX + n, h.shapeType = "arc", h.shapeArgs = a.polarArc(k + B, k, v, v + h.pointWidth)) : (g.height = B, g.y = k, h.tooltipPos = l.inverted ? [d.len + d.pos - l.plotLeft - k - B / 2, b.len + b.pos - l.plotTop - g.x - g.width / 2, B] : [b.left - l.plotLeft + g.x + g.width / 2, d.pos - l.plotTop + k + B / 2, B]);
        });
      },
      directTouch: !0,
      trackerGroups: ["group", "dataLabelsGroup"],
      drawGraph: w,
      getSymbol: w,
      crispCol: function () {
        return f.crispCol.apply(this, arguments);
      },
      drawPoints: function () {
        return f.drawPoints.apply(this, arguments);
      },
      drawTracker: function () {
        return f.drawTracker.apply(this, arguments);
      },
      getColumnMetrics: function () {
        return f.getColumnMetrics.apply(this, arguments);
      },
      pointAttribs: function () {
        return f.pointAttribs.apply(this, arguments);
      },
      animate: function () {
        return f.animate.apply(this, arguments);
      },
      polarArc: function () {
        return f.polarArc.apply(this, arguments);
      },
      translate3dPoints: function () {
        return f.translate3dPoints.apply(this, arguments);
      },
      translate3dShapes: function () {
        return f.translate3dShapes.apply(this, arguments);
      }
    }, {
      setState: f.pointClass.prototype.setState
    });
  });
  E(f, "parts-more/ColumnPyramidSeries.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    var c = a.clamp,
        b = a.pick;
    a = a.seriesType;
    var u = l.seriesTypes.column.prototype;
    a("columnpyramid", "column", {}, {
      translate: function () {
        var a = this,
            l = a.chart,
            f = a.options,
            y = a.dense = 2 > a.closestPointRange * a.xAxis.transA;
        y = a.borderWidth = b(f.borderWidth, y ? 0 : 1);
        var d = a.yAxis,
            m = f.threshold,
            n = a.translatedThreshold = d.getThreshold(m),
            t = b(f.minPointLength, 5),
            x = a.getColumnMetrics(),
            A = x.width,
            r = a.barW = Math.max(A, 1 + 2 * y),
            p = a.pointXOffset = x.offset;
        l.inverted && (n -= .5);
        f.pointPadding && (r = Math.ceil(r));
        u.translate.apply(a);
        a.points.forEach(function (h) {
          var g = b(h.yBottom, n),
              e = 999 + Math.abs(g),
              k = c(h.plotY, -e, d.len + e);
          e = h.plotX + p;
          var B = r / 2,
              C = Math.min(k, g);
          g = Math.max(k, g) - C;
          var q;
          h.barX = e;
          h.pointWidth = A;
          h.tooltipPos = l.inverted ? [d.len + d.pos - l.plotLeft - k, a.xAxis.len - e - B, g] : [e + B, k + d.pos - l.plotTop, g];
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
          l.inverted && (u = l.plotWidth - C, q = k - (l.plotWidth - n), F = B * (k - u) / q, G = B * (k - (u - g)) / q, q = e + B + F, F = q - 2 * F, u = e - G + B, G = e + G + B, v = C, w = C + g - t, 0 > h.y && (w = C + g + t));
          h.shapeType = "path";
          h.shapeArgs = {
            x: q,
            y: v,
            width: F - q,
            height: g,
            d: ["M", q, v, "L", F, v, u, w, G, w, "Z"]
          };
        });
      }
    });
  });
  E(f, "parts-more/GaugeSeries.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    var c = a.clamp,
        b = a.isNumber,
        u = a.merge,
        v = a.pick,
        f = a.pInt;
    a = a.seriesType;
    var z = l.Series,
        y = l.TrackerMixin;
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
      trackerGroups: ["group", "dataLabelsGroup"],
      translate: function () {
        var d = this.yAxis,
            a = this.options,
            n = d.center;
        this.generatePoints();
        this.points.forEach(function (m) {
          var l = u(a.dial, m.dial),
              t = f(v(l.radius, "80%")) * n[2] / 200,
              r = f(v(l.baseLength, "70%")) * t / 100,
              p = f(v(l.rearLength, "10%")) * t / 100,
              h = l.baseWidth || 3,
              g = l.topWidth || 1,
              e = a.overshoot,
              k = d.startAngleRad + d.translate(m.y, null, null, null, !0);
          if (b(e) || !1 === a.wrap) e = b(e) ? e / 180 * Math.PI : 0, k = c(k, d.startAngleRad - e, d.endAngleRad + e);
          k = 180 * k / Math.PI;
          m.shapeType = "path";
          m.shapeArgs = {
            d: l.path || ["M", -p, -h / 2, "L", r, -h / 2, t, -g / 2, t, g / 2, r, h / 2, -p, h / 2, "z"],
            translateX: n[0],
            translateY: n[1],
            rotation: k
          };
          m.plotX = n[0];
          m.plotY = n[1];
        });
      },
      drawPoints: function () {
        var d = this,
            a = d.chart,
            b = d.yAxis.center,
            c = d.pivot,
            l = d.options,
            f = l.pivot,
            r = a.renderer;
        d.points.forEach(function (b) {
          var h = b.graphic,
              g = b.shapeArgs,
              e = g.d,
              k = u(l.dial, b.dial);
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
      animate: function (d) {
        var a = this;
        d || a.points.forEach(function (d) {
          var b = d.graphic;
          b && (b.attr({
            rotation: 180 * a.yAxis.startAngleRad / Math.PI
          }), b.animate({
            rotation: d.shapeArgs.rotation
          }, a.options.animation));
        });
      },
      render: function () {
        this.group = this.plotGroup("group", "series", this.visible ? "visible" : "hidden", this.options.zIndex, this.chart.seriesGroup);
        z.prototype.render.call(this);
        this.group.clip(this.chart.clipRect);
      },
      setData: function (d, a) {
        z.prototype.setData.call(this, d, !1);
        this.processData();
        this.generatePoints();
        v(a, !0) && this.chart.redraw();
      },
      hasData: function () {
        return !!this.points.length;
      },
      drawTracker: y && y.drawTrackerPoint
    }, {
      setState: function (d) {
        this.state = d;
      }
    });
  });
  E(f, "parts-more/BoxPlotSeries.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    var c = a.pick;
    a = a.seriesType;
    var b = l.noop,
        u = l.seriesTypes;
    a("boxplot", "column", {
      threshold: null,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25cf</span> <b> {series.name}</b><br/>Maximum: {point.high}<br/>Upper quartile: {point.q3}<br/>Median: {point.median}<br/>Lower quartile: {point.q1}<br/>Minimum: {point.low}<br/>'
      },
      whiskerLength: "50%",
      fillColor: "#ffffff",
      lineWidth: 1,
      medianWidth: 2,
      whiskerWidth: 2
    }, {
      pointArrayMap: ["low", "q1", "median", "q3", "high"],
      toYData: function (a) {
        return [a.low, a.q1, a.median, a.q3, a.high];
      },
      pointValKey: "high",
      pointAttribs: function () {
        return {};
      },
      drawDataLabels: b,
      translate: function () {
        var a = this.yAxis,
            b = this.pointArrayMap;
        u.column.prototype.translate.apply(this);
        this.points.forEach(function (c) {
          b.forEach(function (b) {
            null !== c[b] && (c[b + "Plot"] = a.translate(c[b], 0, 1, 0, 1));
          });
          c.plotHigh = c.highPlot;
        });
      },
      drawPoints: function () {
        var a = this,
            b = a.options,
            l = a.chart,
            u = l.renderer,
            d,
            m,
            n,
            f,
            x,
            A,
            r = 0,
            p,
            h,
            g,
            e,
            k = !1 !== a.doQuartiles,
            B,
            C = a.options.whiskerLength;
        a.points.forEach(function (q) {
          var F = q.graphic,
              G = F ? "animate" : "attr",
              K = q.shapeArgs,
              v = {},
              t = {},
              H = {},
              J = {},
              I = q.color || a.color;
          "undefined" !== typeof q.plotY && (p = K.width, h = Math.floor(K.x), g = h + p, e = Math.round(p / 2), d = Math.floor(k ? q.q1Plot : q.lowPlot), m = Math.floor(k ? q.q3Plot : q.lowPlot), n = Math.floor(q.highPlot), f = Math.floor(q.lowPlot), F || (q.graphic = F = u.g("point").add(a.group), q.stem = u.path().addClass("highcharts-boxplot-stem").add(F), C && (q.whiskers = u.path().addClass("highcharts-boxplot-whisker").add(F)), k && (q.box = u.path(void 0).addClass("highcharts-boxplot-box").add(F)), q.medianShape = u.path(void 0).addClass("highcharts-boxplot-median").add(F)), l.styledMode || (t.stroke = q.stemColor || b.stemColor || I, t["stroke-width"] = c(q.stemWidth, b.stemWidth, b.lineWidth), t.dashstyle = q.stemDashStyle || b.stemDashStyle, q.stem.attr(t), C && (H.stroke = q.whiskerColor || b.whiskerColor || I, H["stroke-width"] = c(q.whiskerWidth, b.whiskerWidth, b.lineWidth), q.whiskers.attr(H)), k && (v.fill = q.fillColor || b.fillColor || I, v.stroke = b.lineColor || I, v["stroke-width"] = b.lineWidth || 0, q.box.attr(v)), J.stroke = q.medianColor || b.medianColor || I, J["stroke-width"] = c(q.medianWidth, b.medianWidth, b.lineWidth), q.medianShape.attr(J)), A = q.stem.strokeWidth() % 2 / 2, r = h + e + A, q.stem[G]({
            d: ["M", r, m, "L", r, n, "M", r, d, "L", r, f]
          }), k && (A = q.box.strokeWidth() % 2 / 2, d = Math.floor(d) + A, m = Math.floor(m) + A, h += A, g += A, q.box[G]({
            d: ["M", h, m, "L", h, d, "L", g, d, "L", g, m, "L", h, m, "z"]
          })), C && (A = q.whiskers.strokeWidth() % 2 / 2, n += A, f += A, B = /%$/.test(C) ? e * parseFloat(C) / 100 : C / 2, q.whiskers[G]({
            d: ["M", r - B, n, "L", r + B, n, "M", r - B, f, "L", r + B, f]
          })), x = Math.round(q.medianPlot), A = q.medianShape.strokeWidth() % 2 / 2, x += A, q.medianShape[G]({
            d: ["M", h, x, "L", g, x]
          }));
        });
      },
      setStackedPoints: b
    });
  });
  E(f, "parts-more/ErrorBarSeries.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (l, a) {
    a = a.seriesType;
    var c = l.noop,
        b = l.seriesTypes;
    a("errorbar", "boxplot", {
      color: "#000000",
      grouping: !1,
      linkedTo: ":previous",
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25cf</span> {series.name}: <b>{point.low}</b> - <b>{point.high}</b><br/>'
      },
      whiskerWidth: null
    }, {
      type: "errorbar",
      pointArrayMap: ["low", "high"],
      toYData: function (a) {
        return [a.low, a.high];
      },
      pointValKey: "high",
      doQuartiles: !1,
      drawDataLabels: b.arearange ? function () {
        var a = this.pointValKey;
        b.arearange.prototype.drawDataLabels.call(this);
        this.data.forEach(function (b) {
          b.y = b[a];
        });
      } : c,
      getColumnMetrics: function () {
        return this.linkedParent && this.linkedParent.columnMetrics || b.column.prototype.getColumnMetrics.call(this);
      }
    });
  });
  E(f, "parts-more/WaterfallSeries.js", [f["parts/Globals.js"], f["parts/Point.js"], f["parts/Utilities.js"]], function (l, a, c) {
    var b = c.addEvent,
        u = c.arrayMax,
        f = c.arrayMin,
        w = c.correctFloat,
        z = c.isNumber,
        y = c.objectEach,
        d = c.pick;
    c = c.seriesType;
    var m = l.Axis,
        n = l.Chart,
        t = l.Series,
        x = l.StackItem,
        A = l.seriesTypes;
    b(m, "afterInit", function () {
      this.isXAxis || (this.waterfallStacks = {
        changed: !1
      });
    });
    b(m, "afterBuildStacks", function () {
      this.waterfallStacks.changed = !1;
      delete this.waterfallStacks.alreadyChanged;
    });
    b(n, "beforeRedraw", function () {
      for (var a = this.axes, d = this.series, h = d.length; h--;) d[h].options.stacking && (a.forEach(function (g) {
        g.isXAxis || (g.waterfallStacks.changed = !0);
      }), h = 0);
    });
    b(m, "afterRender", function () {
      var a = this.options.stackLabels;
      a && a.enabled && this.waterfallStacks && this.renderWaterfallStackTotals();
    });

    m.prototype.renderWaterfallStackTotals = function () {
      var a = this.waterfallStacks,
          d = this.stackTotalGroup,
          h = new x(this, this.options.stackLabels, !1, 0, void 0);
      this.dummyStackItem = h;
      y(a, function (g) {
        y(g, function (e) {
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
      generatePoints: function () {
        var a;
        A.column.prototype.generatePoints.apply(this);
        var d = 0;

        for (a = this.points.length; d < a; d++) {
          var h = this.points[d];
          var g = this.processedYData[d];
          if (h.isIntermediateSum || h.isSum) h.y = w(g);
        }
      },
      translate: function () {
        var a = this.options,
            b = this.yAxis,
            h,
            g = d(a.minPointLength, 5),
            e = g / 2,
            k = a.threshold,
            c = a.stacking,
            C = b.waterfallStacks[this.stackKey];
        A.column.prototype.translate.apply(this);
        var q = h = k;
        var F = this.points;
        var m = 0;

        for (a = F.length; m < a; m++) {
          var l = F[m];
          var u = this.processedYData[m];
          var n = l.shapeArgs;
          var f = [0, u];
          var t = l.y;

          if (c) {
            if (C) {
              f = C[m];

              if ("overlap" === c) {
                var v = f.stackState[f.stateIndex--];
                v = 0 <= t ? v : v - t;
                Object.hasOwnProperty.call(f, "absolutePos") && delete f.absolutePos;
                Object.hasOwnProperty.call(f, "absoluteNeg") && delete f.absoluteNeg;
              } else 0 <= t ? (v = f.threshold + f.posTotal, f.posTotal -= t) : (v = f.threshold + f.negTotal, f.negTotal -= t, v -= t), !f.posTotal && Object.hasOwnProperty.call(f, "absolutePos") && (f.posTotal = f.absolutePos, delete f.absolutePos), !f.negTotal && Object.hasOwnProperty.call(f, "absoluteNeg") && (f.negTotal = f.absoluteNeg, delete f.absoluteNeg);

              l.isSum || (f.connectorThreshold = f.threshold + f.stackTotal);
              b.reversed ? (u = 0 <= t ? v - t : v + t, t = v) : (u = v, t = v - t);
              l.below = u <= d(k, 0);
              n.y = b.translate(u, 0, 1, 0, 1);
              n.height = Math.abs(n.y - b.translate(t, 0, 1, 0, 1));
            }

            if (t = b.dummyStackItem) t.x = m, t.label = C[m].label, t.setOffset(this.pointXOffset || 0, this.barW || 0, this.stackedYNeg[m], this.stackedYPos[m]);
          } else v = Math.max(q, q + t) + f[0], n.y = b.translate(v, 0, 1, 0, 1), l.isSum ? (n.y = b.translate(f[1], 0, 1, 0, 1), n.height = Math.min(b.translate(f[0], 0, 1, 0, 1), b.len) - n.y) : l.isIntermediateSum ? (0 <= t ? (u = f[1] + h, t = h) : (u = h, t = f[1] + h), b.reversed && (u ^= t, t ^= u, u ^= t), n.y = b.translate(u, 0, 1, 0, 1), n.height = Math.abs(n.y - Math.min(b.translate(t, 0, 1, 0, 1), b.len)), h += f[1]) : (n.height = 0 < u ? b.translate(q, 0, 1, 0, 1) - n.y : b.translate(q, 0, 1, 0, 1) - b.translate(q - u, 0, 1, 0, 1), q += u, l.below = q < d(k, 0)), 0 > n.height && (n.y += n.height, n.height *= -1);

          l.plotY = n.y = Math.round(n.y) - this.borderWidth % 2 / 2;
          n.height = Math.max(Math.round(n.height), .001);
          l.yBottom = n.y + n.height;
          n.height <= g && !l.isNull ? (n.height = g, n.y -= e, l.plotY = n.y, l.minPointLengthOffset = 0 > l.y ? -e : e) : (l.isNull && (n.width = 0), l.minPointLengthOffset = 0);
          n = l.plotY + (l.negative ? n.height : 0);
          this.chart.inverted ? l.tooltipPos[0] = b.len - n : l.tooltipPos[1] = n;
        }
      },
      processData: function (a) {
        var d = this.options,
            h = this.yData,
            g = d.data,
            e = h.length,
            k = d.threshold || 0,
            b,
            r,
            q,
            c,
            m;

        for (m = r = b = q = c = 0; m < e; m++) {
          var n = h[m];
          var l = g && g[m] ? g[m] : {};
          "sum" === n || l.isSum ? h[m] = w(r) : "intermediateSum" === n || l.isIntermediateSum ? (h[m] = w(b), b = 0) : (r += n, b += n);
          q = Math.min(r, q);
          c = Math.max(r, c);
        }

        t.prototype.processData.call(this, a);
        d.stacking || (this.dataMin = q + k, this.dataMax = c);
      },
      toYData: function (a) {
        return a.isSum ? "sum" : a.isIntermediateSum ? "intermediateSum" : a.y;
      },
      updateParallelArrays: function (a, d) {
        t.prototype.updateParallelArrays.call(this, a, d);
        if ("sum" === this.yData[0] || "intermediateSum" === this.yData[0]) this.yData[0] = null;
      },
      pointAttribs: function (a, d) {
        var b = this.options.upColor;
        b && !a.options.color && (a.color = 0 < a.y ? b : null);
        a = A.column.prototype.pointAttribs.call(this, a, d);
        delete a.dashstyle;
        return a;
      },
      getGraphPath: function () {
        return ["M", 0, 0];
      },
      getCrispPath: function () {
        var a = this.data,
            d = this.yAxis,
            b = a.length,
            g = Math.round(this.graph.strokeWidth()) % 2 / 2,
            e = Math.round(this.borderWidth) % 2 / 2,
            k = this.xAxis.reversed,
            c = this.yAxis.reversed,
            C = this.options.stacking,
            q = [],
            m;

        for (m = 1; m < b; m++) {
          var n = a[m].shapeArgs;
          var l = a[m - 1];
          var f = a[m - 1].shapeArgs;
          var u = d.waterfallStacks[this.stackKey];
          var t = 0 < l.y ? -f.height : 0;

          if (u) {
            u = u[m - 1];
            C ? (u = u.connectorThreshold, t = Math.round(d.translate(u, 0, 1, 0, 1) + (c ? t : 0)) - g) : t = f.y + l.minPointLengthOffset + e - g;
            var v = ["M", f.x + (k ? 0 : f.width), t, "L", n.x + (k ? n.width : 0), t];
          }

          if (!C && v && 0 > l.y && !c || 0 < l.y && c) v[2] += f.height, v[5] += f.height;
          q = q.concat(v);
        }

        return q;
      },
      drawGraph: function () {
        t.prototype.drawGraph.call(this);
        this.graph.attr({
          d: this.getCrispPath()
        });
      },
      setStackedPoints: function () {
        function a(e, a, k, g) {
          if (z) for (k; k < z; k++) w.stackState[k] += g;else w.stackState[0] = e, z = w.stackState.length;
          w.stackState.push(w.stackState[z - 1] + a);
        }

        var d = this.options,
            b = this.yAxis.waterfallStacks,
            g = d.threshold,
            e = g || 0,
            k = e,
            c = this.stackKey,
            C = this.xData,
            q = C.length,
            m,
            n,
            l;
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
            y && y.isIntermediateSum ? (a(l, n, 0, l), l = n, n = g, e ^= k, k ^= e, e ^= k) : y && y.isSum ? (a(g, f, z), e = g) : (a(e, x, 0, f), y && (f += x, n += x));
            w.stateIndex++;
            w.threshold = e;
            e += w.stackTotal;
          }

          b.changed = !1;
          b.alreadyChanged || (b.alreadyChanged = []);
          b.alreadyChanged.push(c);
        }
      },
      getExtremes: function () {
        var a = this.options.stacking;

        if (a) {
          var d = this.yAxis;
          d = d.waterfallStacks;
          var b = this.stackedYNeg = [];
          var g = this.stackedYPos = [];
          "overlap" === a ? y(d[this.stackKey], function (e) {
            b.push(f(e.stackState));
            g.push(u(e.stackState));
          }) : y(d[this.stackKey], function (e) {
            b.push(e.negTotal + e.threshold);
            g.push(e.posTotal + e.threshold);
          });
          this.dataMin = f(b);
          this.dataMax = u(g);
        }
      }
    }, {
      getClassName: function () {
        var d = a.prototype.getClassName.call(this);
        this.isSum ? d += " highcharts-sum" : this.isIntermediateSum && (d += " highcharts-intermediate-sum");
        return d;
      },
      isValid: function () {
        return z(this.y) || this.isSum || this.isIntermediateSum;
      }
    });
  });
  E(f, "parts-more/PolygonSeries.js", [f["parts/Globals.js"], f["mixins/legend-symbol.js"], f["parts/Utilities.js"]], function (l, a, c) {
    c = c.seriesType;
    var b = l.Series,
        f = l.seriesTypes;
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
      getGraphPath: function () {
        for (var a = b.prototype.getGraphPath.call(this), c = a.length + 1; c--;) (c === a.length || "M" === a[c]) && 0 < c && a.splice(c, 0, "z");

        return this.areaPath = a;
      },
      drawGraph: function () {
        this.options.fillColor = this.color;
        f.area.prototype.drawGraph.call(this);
      },
      drawLegendSymbol: a.drawRectangle,
      drawTracker: b.prototype.drawTracker,
      setStackedPoints: l.noop
    });
  });
  E(f, "parts-more/BubbleLegend.js", [f["parts/Globals.js"], f["parts/Color.js"], f["parts/Legend.js"], f["parts/Utilities.js"]], function (l, a, c, b) {

    var f = a.parse;
    a = b.addEvent;
    var v = b.arrayMax,
        w = b.arrayMin,
        z = b.isNumber,
        y = b.merge,
        d = b.objectEach,
        m = b.pick,
        n = b.stableSort,
        t = b.wrap,
        x = l.Series,
        A = l.Chart,
        r = l.noop,
        p = l.setOptions;
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

    p = function () {
      function a(a, e) {
        this.options = this.symbols = this.visible = this.ranges = this.movementX = this.maxLabel = this.legendSymbol = this.legendItemWidth = this.legendItemHeight = this.legendItem = this.legendGroup = this.legend = this.fontMetrics = this.chart = void 0;
        this.setState = r;
        this.init(a, e);
      }

      a.prototype.init = function (a, e) {
        this.options = a;
        this.visible = !0;
        this.chart = e.chart;
        this.legend = e;
      };

      a.prototype.addToLegend = function (a) {
        a.splice(this.options.legendIndex, 0, this);
      };

      a.prototype.drawLegendSymbol = function (a) {
        var e = this.chart,
            k = this.options,
            d = m(a.options.itemDistance, 20),
            b = k.ranges;
        var g = k.connectorDistance;
        this.fontMetrics = e.renderer.fontMetrics(k.labels.style.fontSize.toString() + "px");
        b && b.length && z(b[0].value) ? (n(b, function (e, a) {
          return a.value - e.value;
        }), this.ranges = b, this.setOptions(), this.render(), e = this.getMaxLabelSize(), b = this.ranges[0].radius, a = 2 * b, g = g - b + e.width, g = 0 < g ? g : 0, this.maxLabel = e, this.movementX = "left" === k.labels.align ? g : 0, this.legendItemWidth = a + g + d, this.legendItemHeight = a + this.fontMetrics.h / 2) : a.options.bubbleLegend.autoRanges = !0;
      };

      a.prototype.setOptions = function () {
        var a = this.ranges,
            e = this.options,
            k = this.chart.series[e.seriesIndex],
            d = this.legend.baseline,
            b = {
          "z-index": e.zIndex,
          "stroke-width": e.borderWidth
        },
            h = {
          "z-index": e.zIndex,
          "stroke-width": e.connectorWidth
        },
            c = this.getLabelStyles(),
            p = k.options.marker.fillOpacity,
            r = this.chart.styledMode;
        a.forEach(function (g, q) {
          r || (b.stroke = m(g.borderColor, e.borderColor, k.color), b.fill = m(g.color, e.color, 1 !== p ? f(k.color).setOpacity(p).get("rgba") : k.color), h.stroke = m(g.connectorColor, e.connectorColor, k.color));
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

      a.prototype.getLabelStyles = function () {
        var a = this.options,
            e = {},
            k = "left" === a.labels.align,
            b = this.legend.options.rtl;
        d(a.labels.style, function (a, k) {
          "color" !== k && "fontSize" !== k && "z-index" !== k && (e[k] = a);
        });
        return y(!1, e, {
          "font-size": a.labels.style.fontSize,
          fill: m(a.labels.style.color, "#000000"),
          "z-index": a.zIndex,
          align: b || k ? "right" : "left"
        });
      };

      a.prototype.getRangeRadius = function (a) {
        var e = this.options;
        return this.chart.series[this.options.seriesIndex].getRadius.call(this, e.ranges[e.ranges.length - 1].value, e.ranges[0].value, e.minSize, e.maxSize, a);
      };

      a.prototype.render = function () {
        var a = this.chart.renderer,
            e = this.options.zThreshold;
        this.symbols || (this.symbols = {
          connectors: [],
          bubbleItems: [],
          labels: []
        });
        this.legendSymbol = a.g("bubble-legend");
        this.legendItem = a.g("bubble-legend-item");
        this.legendSymbol.translateX = 0;
        this.legendSymbol.translateY = 0;
        this.ranges.forEach(function (a) {
          a.value >= e && this.renderRange(a);
        }, this);
        this.legendSymbol.add(this.legendItem);
        this.legendItem.add(this.legendGroup);
        this.hideOverlappingLabels();
      };

      a.prototype.renderRange = function (a) {
        var e = this.options,
            k = e.labels,
            b = this.chart.renderer,
            d = this.symbols,
            g = d.labels,
            h = a.center,
            c = Math.abs(a.radius),
            p = e.connectorDistance,
            r = k.align,
            m = k.style.fontSize;
        p = this.legend.options.rtl || "left" === r ? -p : p;
        k = e.connectorWidth;
        var n = this.ranges[0].radius,
            l = h - c - e.borderWidth / 2 + k / 2;
        m = m / 2 - (this.fontMetrics.h - m) / 2;
        var f = b.styledMode;
        "center" === r && (p = 0, e.connectorDistance = 0, a.labelStyle.align = "center");
        r = l + e.labels.y;
        var u = n + p + e.labels.x;
        d.bubbleItems.push(b.circle(n, h + ((l % 1 ? 1 : .5) - (k % 2 ? 0 : .5)), c).attr(f ? {} : a.bubbleStyle).addClass((f ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-symbol " + (e.className || "")).add(this.legendSymbol));
        d.connectors.push(b.path(b.crispLine(["M", n, l, "L", n + p, l], e.connectorWidth)).attr(f ? {} : a.connectorStyle).addClass((f ? "highcharts-color-" + this.options.seriesIndex + " " : "") + "highcharts-bubble-legend-connectors " + (e.connectorClassName || "")).add(this.legendSymbol));
        a = b.text(this.formatLabel(a), u, r + m).attr(f ? {} : a.labelStyle).addClass("highcharts-bubble-legend-labels " + (e.labels.className || "")).add(this.legendSymbol);
        g.push(a);
        a.placed = !0;
        a.alignAttr = {
          x: u,
          y: r + m
        };
      };

      a.prototype.getMaxLabelSize = function () {
        var a, e;
        this.symbols.labels.forEach(function (k) {
          e = k.getBBox(!0);
          a = a ? e.width > a.width ? e : a : e;
        });
        return a || {};
      };

      a.prototype.formatLabel = function (a) {
        var e = this.options,
            k = e.labels.formatter;
        e = e.labels.format;
        var d = this.chart.numberFormatter;
        return e ? b.format(e, a) : k ? k.call(a) : d(a.value, 1);
      };

      a.prototype.hideOverlappingLabels = function () {
        var a = this.chart,
            e = this.symbols;
        !this.options.labels.allowOverlap && e && (a.hideOverlappingLabels(e.labels), e.labels.forEach(function (a, b) {
          a.newOpacity ? a.newOpacity !== a.oldOpacity && e.connectors[b].show() : e.connectors[b].hide();
        }));
      };

      a.prototype.getRanges = function () {
        var a = this.legend.bubbleLegend,
            e = a.options.ranges,
            k,
            b = Number.MAX_VALUE,
            d = -Number.MAX_VALUE;
        a.chart.series.forEach(function (e) {
          e.isBubble && !e.ignoreSeries && (k = e.zData.filter(z), k.length && (b = m(e.options.zMin, Math.min(b, Math.max(w(k), !1 === e.options.displayNegative ? e.options.zThreshold : -Number.MAX_VALUE))), d = m(e.options.zMax, Math.max(d, v(k)))));
        });
        var h = b === d ? [{
          value: d
        }] : [{
          value: b
        }, {
          value: (b + d) / 2
        }, {
          value: d,
          autoRanges: !0
        }];
        e.length && e[0].radius && h.reverse();
        h.forEach(function (a, b) {
          e && e[b] && (h[b] = y(!1, e[b], a));
        });
        return h;
      };

      a.prototype.predictBubbleSizes = function () {
        var a = this.chart,
            e = this.fontMetrics,
            b = a.legend.options,
            d = "horizontal" === b.layout,
            h = d ? a.legend.lastLineHeight : 0,
            q = a.plotSizeX,
            c = a.plotSizeY,
            p = a.series[this.options.seriesIndex];
        a = Math.ceil(p.minPxSize);
        var r = Math.ceil(p.maxPxSize);
        p = p.options.maxSize;
        var m = Math.min(c, q);
        if (b.floating || !/%$/.test(p)) e = r;else if (p = parseFloat(p), e = (m + h - e.h / 2) * p / 100 / (p / 100 + 1), d && c - e >= q || !d && q - e >= c) e = r;
        return [a, Math.ceil(e)];
      };

      a.prototype.updateRanges = function (a, e) {
        var b = this.legend.options.bubbleLegend;
        b.minSize = a;
        b.maxSize = e;
        b.ranges = this.getRanges();
      };

      a.prototype.correctSizes = function () {
        var a = this.legend,
            e = this.chart.series[this.options.seriesIndex];
        1 < Math.abs(Math.ceil(e.maxPxSize) - this.options.maxSize) && (this.updateRanges(this.options.minSize, e.maxPxSize), a.render());
      };

      return a;
    }();

    a(c, "afterGetAllItems", function (a) {
      var b = this.bubbleLegend,
          e = this.options,
          d = e.bubbleLegend,
          h = this.chart.getVisibleBubbleSeriesIndex();
      b && b.ranges && b.ranges.length && (d.ranges.length && (d.autoRanges = !!d.ranges[0].autoRanges), this.destroyItem(b));
      0 <= h && e.enabled && d.enabled && (d.seriesIndex = h, this.bubbleLegend = new l.BubbleLegend(d, this), this.bubbleLegend.addToLegend(a.allItems));
    });

    A.prototype.getVisibleBubbleSeriesIndex = function () {
      for (var a = this.series, b = 0; b < a.length;) {
        if (a[b] && a[b].isBubble && a[b].visible && a[b].zData.length) return b;
        b++;
      }

      return -1;
    };

    c.prototype.getLinesHeights = function () {
      var a = this.allItems,
          b = [],
          e = a.length,
          d,
          c = 0;

      for (d = 0; d < e; d++) if (a[d].legendItemHeight && (a[d].itemHeight = a[d].legendItemHeight), a[d] === a[e - 1] || a[d + 1] && a[d]._legendItemPos[1] !== a[d + 1]._legendItemPos[1]) {
        b.push({
          height: 0
        });
        var p = b[b.length - 1];

        for (c; c <= d; c++) a[c].itemHeight > p.height && (p.height = a[c].itemHeight);

        p.step = d;
      }

      return b;
    };

    c.prototype.retranslateItems = function (a) {
      var b,
          e,
          d,
          h = this.options.rtl,
          c = 0;
      this.allItems.forEach(function (k, g) {
        b = k.legendGroup.translateX;
        e = k._legendItemPos[1];
        if ((d = k.movementX) || h && k.ranges) d = h ? b - k.options.maxSize / 2 : b + d, k.legendGroup.attr({
          translateX: d
        });
        g > a[c].step && c++;
        k.legendGroup.attr({
          translateY: Math.round(e + a[c].height / 2)
        });
        k._legendItemPos[1] = e + a[c].height / 2;
      });
    };

    a(x, "legendItemClick", function () {
      var a = this.chart,
          b = this.visible,
          e = this.chart.legend;
      e && e.bubbleLegend && (this.visible = !b, this.ignoreSeries = b, a = 0 <= a.getVisibleBubbleSeriesIndex(), e.bubbleLegend.visible !== a && (e.update({
        bubbleLegend: {
          enabled: a
        }
      }), e.bubbleLegend.visible = a), this.visible = b);
    });
    t(A.prototype, "drawChartBox", function (a, b, e) {
      var k = this.legend,
          h = 0 <= this.getVisibleBubbleSeriesIndex();

      if (k && k.options.enabled && k.bubbleLegend && k.options.bubbleLegend.autoRanges && h) {
        var g = k.bubbleLegend.options;
        h = k.bubbleLegend.predictBubbleSizes();
        k.bubbleLegend.updateRanges(h[0], h[1]);
        g.placed || (k.group.placed = !1, k.allItems.forEach(function (e) {
          e.legendGroup.translateY = null;
        }));
        k.render();
        this.getMargins();
        this.axes.forEach(function (e) {
          e.visible && e.render();
          g.placed || (e.setScale(), e.updateNames(), d(e.ticks, function (e) {
            e.isNew = !0;
            e.isNewLabel = !0;
          }));
        });
        g.placed = !0;
        this.getMargins();
        a.call(this, b, e);
        k.bubbleLegend.correctSizes();
        k.retranslateItems(k.getLinesHeights());
      } else a.call(this, b, e), k && k.options.enabled && k.bubbleLegend && (k.render(), k.retranslateItems(k.getLinesHeights()));
    });
    l.BubbleLegend = p;
    return l.BubbleLegend;
  });
  E(f, "parts-more/BubbleSeries.js", [f["parts/Globals.js"], f["parts/Color.js"], f["parts/Point.js"], f["parts/Utilities.js"]], function (l, a, c, b) {
    var f = a.parse,
        v = b.arrayMax,
        w = b.arrayMin,
        z = b.clamp,
        y = b.extend,
        d = b.isNumber,
        m = b.pick,
        n = b.pInt;
    a = b.seriesType;
    b = l.Axis;
    var t = l.noop,
        x = l.Series,
        A = l.seriesTypes;
    a("bubble", "scatter", {
      dataLabels: {
        formatter: function () {
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
      pointArrayMap: ["y", "z"],
      parallelArrays: ["x", "y", "z"],
      trackerGroups: ["group", "dataLabelsGroup"],
      specialGroup: "group",
      bubblePadding: !0,
      zoneAxis: "z",
      directTouch: !0,
      isBubble: !0,
      pointAttribs: function (a, b) {
        var d = this.options.marker.fillOpacity;
        a = x.prototype.pointAttribs.call(this, a, b);
        1 !== d && (a.fill = f(a.fill).setOpacity(d).get("rgba"));
        return a;
      },
      getRadii: function (a, b, d) {
        var g = this.zData,
            e = this.yData,
            k = d.minPxSize,
            h = d.maxPxSize,
            c = [];
        var q = 0;

        for (d = g.length; q < d; q++) {
          var p = g[q];
          c.push(this.getRadius(a, b, k, h, p, e[q]));
        }

        this.radii = c;
      },
      getRadius: function (a, b, h, g, e, k) {
        var c = this.options,
            p = "width" !== c.sizeBy,
            q = c.zThreshold,
            r = b - a,
            m = .5;
        if (null === k || null === e) return null;

        if (d(e)) {
          c.sizeByAbsoluteValue && (e = Math.abs(e - q), r = Math.max(b - q, Math.abs(a - q)), a = 0);
          if (e < a) return h / 2 - 1;
          0 < r && (m = (e - a) / r);
        }

        p && 0 <= m && (m = Math.sqrt(m));
        return Math.ceil(h + m * (g - h)) / 2;
      },
      animate: function (a) {
        !a && this.points.length < this.options.animationLimit && this.points.forEach(function (a) {
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
      hasData: function () {
        return !!this.processedXData.length;
      },
      translate: function () {
        var a,
            b = this.data,
            c = this.radii;
        A.scatter.prototype.translate.call(this);

        for (a = b.length; a--;) {
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
      haloPath: function (a) {
        return c.prototype.haloPath.call(this, 0 === a ? 0 : (this.marker ? this.marker.radius || 0 : 0) + a);
      },
      ttBelow: !1
    });

    b.prototype.beforePadding = function () {
      var a = this,
          b = this.len,
          c = this.chart,
          g = 0,
          e = b,
          k = this.isXAxis,
          l = k ? "xData" : "yData",
          f = this.min,
          q = {},
          u = Math.min(c.plotWidth, c.plotHeight),
          t = Number.MAX_VALUE,
          x = -Number.MAX_VALUE,
          y = this.max - f,
          A = b / y,
          H = [];
      this.series.forEach(function (e) {
        var b = e.options;
        !e.bubblePadding || !e.visible && c.options.chart.ignoreHiddenSeries || (a.allowZoomOutside = !0, H.push(e), k && (["minSize", "maxSize"].forEach(function (e) {
          var a = b[e],
              d = /%$/.test(a);
          a = n(a);
          q[e] = d ? u * a / 100 : a;
        }), e.minPxSize = q.minSize, e.maxPxSize = Math.max(q.maxSize, q.minSize), e = e.zData.filter(d), e.length && (t = m(b.zMin, z(w(e), !1 === b.displayNegative ? b.zThreshold : -Number.MAX_VALUE, t)), x = m(b.zMax, Math.max(x, v(e))))));
      });
      H.forEach(function (b) {
        var c = b[l],
            h = c.length;
        k && b.getRadii(t, x, b);
        if (0 < y) for (; h--;) if (d(c[h]) && a.dataMin <= c[h] && c[h] <= a.max) {
          var q = b.radii ? b.radii[h] : 0;
          g = Math.min((c[h] - f) * A - q, g);
          e = Math.max((c[h] - f) * A + q, e);
        }
      });
      H.length && 0 < y && !this.isLog && (e -= b, A *= (b + Math.max(0, g) - Math.min(e, b)) / b, [["min", "userMin", g], ["max", "userMax", e]].forEach(function (e) {
        "undefined" === typeof m(a.options[e[0]], a[e[1]]) && (a[e[0]] += e[2] / A);
      }));
    };
  });
  E(f, "modules/networkgraph/integrations.js", [f["parts/Globals.js"]], function (l) {
    l.networkgraphIntegrations = {
      verlet: {
        attractiveForceFunction: function (a, c) {
          return (c - a) / a;
        },
        repulsiveForceFunction: function (a, c) {
          return (c - a) / a * (c > a ? 1 : 0);
        },
        barycenter: function () {
          var a = this.options.gravitationalConstant,
              c = this.barycenter.xFactor,
              b = this.barycenter.yFactor;
          c = (c - (this.box.left + this.box.width) / 2) * a;
          b = (b - (this.box.top + this.box.height) / 2) * a;
          this.nodes.forEach(function (a) {
            a.fixedPosition || (a.plotX -= c / a.mass / a.degree, a.plotY -= b / a.mass / a.degree);
          });
        },
        repulsive: function (a, c, b) {
          c = c * this.diffTemperature / a.mass / a.degree;
          a.fixedPosition || (a.plotX += b.x * c, a.plotY += b.y * c);
        },
        attractive: function (a, c, b) {
          var l = a.getMass(),
              f = -b.x * c * this.diffTemperature;
          c = -b.y * c * this.diffTemperature;
          a.fromNode.fixedPosition || (a.fromNode.plotX -= f * l.fromNode / a.fromNode.degree, a.fromNode.plotY -= c * l.fromNode / a.fromNode.degree);
          a.toNode.fixedPosition || (a.toNode.plotX += f * l.toNode / a.toNode.degree, a.toNode.plotY += c * l.toNode / a.toNode.degree);
        },
        integrate: function (a, c) {
          var b = -a.options.friction,
              l = a.options.maxSpeed,
              f = (c.plotX + c.dispX - c.prevX) * b;
          b *= c.plotY + c.dispY - c.prevY;
          var w = Math.abs,
              z = w(f) / (f || 1);
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
        getK: function (a) {
          return Math.pow(a.box.width * a.box.height / a.nodes.length, .5);
        }
      },
      euler: {
        attractiveForceFunction: function (a, c) {
          return a * a / c;
        },
        repulsiveForceFunction: function (a, c) {
          return c * c / a;
        },
        barycenter: function () {
          var a = this.options.gravitationalConstant,
              c = this.barycenter.xFactor,
              b = this.barycenter.yFactor;
          this.nodes.forEach(function (f) {
            if (!f.fixedPosition) {
              var l = f.getDegree();
              l *= 1 + l / 2;
              f.dispX += (c - f.plotX) * a * l / f.degree;
              f.dispY += (b - f.plotY) * a * l / f.degree;
            }
          });
        },
        repulsive: function (a, c, b, f) {
          a.dispX += b.x / f * c / a.degree;
          a.dispY += b.y / f * c / a.degree;
        },
        attractive: function (a, c, b, f) {
          var l = a.getMass(),
              u = b.x / f * c;
          c *= b.y / f;
          a.fromNode.fixedPosition || (a.fromNode.dispX -= u * l.fromNode / a.fromNode.degree, a.fromNode.dispY -= c * l.fromNode / a.fromNode.degree);
          a.toNode.fixedPosition || (a.toNode.dispX += u * l.toNode / a.toNode.degree, a.toNode.dispY += c * l.toNode / a.toNode.degree);
        },
        integrate: function (a, c) {
          c.dispX += c.dispX * a.options.friction;
          c.dispY += c.dispY * a.options.friction;
          var b = c.temperature = a.vectorLength({
            x: c.dispX,
            y: c.dispY
          });
          0 !== b && (c.plotX += c.dispX / b * Math.min(Math.abs(c.dispX), a.temperature), c.plotY += c.dispY / b * Math.min(Math.abs(c.dispY), a.temperature));
        },
        getK: function (a) {
          return Math.pow(a.box.width * a.box.height / a.nodes.length, .3);
        }
      }
    };
  });
  E(f, "modules/networkgraph/QuadTree.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (f, a) {
    a = a.extend;

    var c = f.QuadTreeNode = function (a) {
      this.box = a;
      this.boxSize = Math.min(a.width, a.height);
      this.nodes = [];
      this.body = this.isInternal = !1;
      this.isEmpty = !0;
    };

    a(c.prototype, {
      insert: function (a, f) {
        this.isInternal ? this.nodes[this.getBoxPosition(a)].insert(a, f - 1) : (this.isEmpty = !1, this.body ? f ? (this.isInternal = !0, this.divideBox(), !0 !== this.body && (this.nodes[this.getBoxPosition(this.body)].insert(this.body, f - 1), this.body = !0), this.nodes[this.getBoxPosition(a)].insert(a, f - 1)) : (f = new c({
          top: a.plotX,
          left: a.plotY,
          width: .1,
          height: .1
        }), f.body = a, f.isInternal = !1, this.nodes.push(f)) : (this.isInternal = !1, this.body = a));
      },
      updateMassAndCenter: function () {
        var a = 0,
            c = 0,
            f = 0;
        this.isInternal ? (this.nodes.forEach(function (b) {
          b.isEmpty || (a += b.mass, c += b.plotX * b.mass, f += b.plotY * b.mass);
        }), c /= a, f /= a) : this.body && (a = this.body.mass, c = this.body.plotX, f = this.body.plotY);
        this.mass = a;
        this.plotX = c;
        this.plotY = f;
      },
      divideBox: function () {
        var a = this.box.width / 2,
            f = this.box.height / 2;
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
      getBoxPosition: function (a) {
        var b = a.plotY < this.box.top + this.box.height / 2;
        return a.plotX < this.box.left + this.box.width / 2 ? b ? 0 : 3 : b ? 1 : 2;
      }
    });

    f = f.QuadTree = function (a, f, l, w) {
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
      insertNodes: function (a) {
        a.forEach(function (a) {
          this.root.insert(a, this.maxDepth);
        }, this);
      },
      visitNodeRecursive: function (a, c, f) {
        var b;
        a || (a = this.root);
        a === this.root && c && (b = c(a));
        !1 !== b && (a.nodes.forEach(function (a) {
          if (a.isInternal) {
            c && (b = c(a));
            if (!1 === b) return;
            this.visitNodeRecursive(a, c, f);
          } else a.body && c && c(a.body);

          f && f(a);
        }, this), a === this.root && f && f(a));
      },
      calculateMassAndCenter: function () {
        this.visitNodeRecursive(null, null, function (a) {
          a.updateMassAndCenter();
        });
      }
    });
  });
  E(f, "modules/networkgraph/layouts.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (f, a) {
    var c = a.addEvent,
        b = a.clamp,
        l = a.defined,
        v = a.extend,
        w = a.isFunction,
        z = a.pick,
        y = a.setAnimation;
    a = f.Chart;
    f.layouts = {
      "reingold-fruchterman": function () {}
    };
    v(f.layouts["reingold-fruchterman"].prototype, {
      init: function (a) {
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
      start: function () {
        var a = this.series,
            b = this.options;
        this.currentStep = 0;
        this.forces = a[0] && a[0].forces || [];
        this.initialRendering && (this.initPositions(), a.forEach(function (a) {
          a.render();
        }));
        this.setK();
        this.resetSimulation(b);
        b.enableSimulation && this.step();
      },
      step: function () {
        var a = this,
            b = this.series,
            c = this.options;
        a.currentStep++;
        "barnes-hut" === a.approximation && (a.createQuadTree(), a.quadTree.calculateMassAndCenter());
        a.forces.forEach(function (b) {
          a[b + "Forces"](a.temperature);
        });
        a.applyLimits(a.temperature);
        a.temperature = a.coolDown(a.startTemperature, a.diffTemperature, a.currentStep);
        a.prevSystemTemperature = a.systemTemperature;
        a.systemTemperature = a.getSystemTemperature();
        c.enableSimulation && (b.forEach(function (a) {
          a.chart && a.render();
        }), a.maxIterations-- && isFinite(a.temperature) && !a.isStable() ? (a.simulation && f.win.cancelAnimationFrame(a.simulation), a.simulation = f.win.requestAnimationFrame(function () {
          a.step();
        })) : a.simulation = !1);
      },
      stop: function () {
        this.simulation && f.win.cancelAnimationFrame(this.simulation);
      },
      setArea: function (a, b, c, f) {
        this.box = {
          left: a,
          top: b,
          width: c,
          height: f
        };
      },
      setK: function () {
        this.k = this.options.linkLength || this.integration.getK(this);
      },
      addElementsToCollection: function (a, b) {
        a.forEach(function (a) {
          -1 === b.indexOf(a) && b.push(a);
        });
      },
      removeElementFromCollection: function (a, b) {
        a = b.indexOf(a);
        -1 !== a && b.splice(a, 1);
      },
      clear: function () {
        this.nodes.length = 0;
        this.links.length = 0;
        this.series.length = 0;
        this.resetSimulation();
      },
      resetSimulation: function () {
        this.forcedStop = !1;
        this.systemTemperature = 0;
        this.setMaxIterations();
        this.setTemperature();
        this.setDiffTemperature();
      },
      setMaxIterations: function (a) {
        this.maxIterations = z(a, this.options.maxIterations);
      },
      setTemperature: function () {
        this.temperature = this.startTemperature = Math.sqrt(this.nodes.length);
      },
      setDiffTemperature: function () {
        this.diffTemperature = this.startTemperature / (this.options.maxIterations + 1);
      },
      setInitialRendering: function (a) {
        this.initialRendering = a;
      },
      createQuadTree: function () {
        this.quadTree = new f.QuadTree(this.box.left, this.box.top, this.box.width, this.box.height);
        this.quadTree.insertNodes(this.nodes);
      },
      initPositions: function () {
        var a = this.options.initialPositions;
        w(a) ? (a.call(this), this.nodes.forEach(function (a) {
          l(a.prevX) || (a.prevX = a.plotX);
          l(a.prevY) || (a.prevY = a.plotY);
          a.dispX = 0;
          a.dispY = 0;
        })) : "circle" === a ? this.setCircularPositions() : this.setRandomPositions();
      },
      setCircularPositions: function () {
        function a(b) {
          b.linksFrom.forEach(function (b) {
            r[b.toNode.id] || (r[b.toNode.id] = !0, u.push(b.toNode), a(b.toNode));
          });
        }

        var b = this.box,
            c = this.nodes,
            f = 2 * Math.PI / (c.length + 1),
            l = c.filter(function (a) {
          return 0 === a.linksTo.length;
        }),
            u = [],
            r = {},
            p = this.options.initialPositionRadius;
        l.forEach(function (b) {
          u.push(b);
          a(b);
        });
        u.length ? c.forEach(function (a) {
          -1 === u.indexOf(a) && u.push(a);
        }) : u = c;
        u.forEach(function (a, d) {
          a.plotX = a.prevX = z(a.plotX, b.width / 2 + p * Math.cos(d * f));
          a.plotY = a.prevY = z(a.plotY, b.height / 2 + p * Math.sin(d * f));
          a.dispX = 0;
          a.dispY = 0;
        });
      },
      setRandomPositions: function () {
        function a(a) {
          a = a * a / Math.PI;
          return a -= Math.floor(a);
        }

        var b = this.box,
            c = this.nodes,
            f = c.length + 1;
        c.forEach(function (d, c) {
          d.plotX = d.prevX = z(d.plotX, b.width * a(c));
          d.plotY = d.prevY = z(d.plotY, b.height * a(f + c));
          d.dispX = 0;
          d.dispY = 0;
        });
      },
      force: function (a) {
        this.integration[a].apply(this, Array.prototype.slice.call(arguments, 1));
      },
      barycenterForces: function () {
        this.getBarycenter();
        this.force("barycenter");
      },
      getBarycenter: function () {
        var a = 0,
            b = 0,
            c = 0;
        this.nodes.forEach(function (d) {
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
      barnesHutApproximation: function (a, b) {
        var d = this.getDistXY(a, b),
            c = this.vectorLength(d);
        if (a !== b && 0 !== c) if (b.isInternal) {
          if (b.boxSize / c < this.options.theta && 0 !== c) {
            var f = this.repulsiveForce(c, this.k);
            this.force("repulsive", a, f * b.mass, d, c);
            var l = !1;
          } else l = !0;
        } else f = this.repulsiveForce(c, this.k), this.force("repulsive", a, f * b.mass, d, c);
        return l;
      },
      repulsiveForces: function () {
        var a = this;
        "barnes-hut" === a.approximation ? a.nodes.forEach(function (b) {
          a.quadTree.visitNodeRecursive(null, function (d) {
            return a.barnesHutApproximation(b, d);
          });
        }) : a.nodes.forEach(function (b) {
          a.nodes.forEach(function (d) {
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
      attractiveForces: function () {
        var a = this,
            b,
            c,
            f;
        a.links.forEach(function (d) {
          d.fromNode && d.toNode && (b = a.getDistXY(d.fromNode, d.toNode), c = a.vectorLength(b), 0 !== c && (f = a.attractiveForce(c, a.k), a.force("attractive", d, f, b, c)));
        });
      },
      applyLimits: function () {
        var a = this;
        a.nodes.forEach(function (b) {
          b.fixedPosition || (a.integration.integrate(a, b), a.applyLimitBox(b, a.box), b.dispX = 0, b.dispY = 0);
        });
      },
      applyLimitBox: function (a, c) {
        var d = a.radius;
        a.plotX = b(a.plotX, c.left + d, c.width - d);
        a.plotY = b(a.plotY, c.top + d, c.height - d);
      },
      coolDown: function (a, b, c) {
        return a - b * c;
      },
      isStable: function () {
        return .00001 > Math.abs(this.systemTemperature - this.prevSystemTemperature) || 0 >= this.temperature;
      },
      getSystemTemperature: function () {
        return this.nodes.reduce(function (a, b) {
          return a + b.temperature;
        }, 0);
      },
      vectorLength: function (a) {
        return Math.sqrt(a.x * a.x + a.y * a.y);
      },
      getDistR: function (a, b) {
        a = this.getDistXY(a, b);
        return this.vectorLength(a);
      },
      getDistXY: function (a, b) {
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
    c(a, "predraw", function () {
      this.graphLayoutsLookup && this.graphLayoutsLookup.forEach(function (a) {
        a.stop();
      });
    });
    c(a, "render", function () {
      function a(a) {
        a.maxIterations-- && isFinite(a.temperature) && !a.isStable() && !a.options.enableSimulation && (a.beforeStep && a.beforeStep(), a.step(), c = !1, b = !0);
      }

      var b = !1;

      if (this.graphLayoutsLookup) {
        y(!1, this);

        for (this.graphLayoutsLookup.forEach(function (a) {
          a.start();
        }); !c;) {
          var c = !0;
          this.graphLayoutsLookup.forEach(a);
        }

        b && this.series.forEach(function (a) {
          a && a.layout && a.render();
        });
      }
    });
  });
  E(f, "modules/networkgraph/draggable-nodes.js", [f["parts/Globals.js"], f["parts/Utilities.js"]], function (f, a) {
    var c = a.addEvent;
    a = f.Chart;
    f.dragNodesMixin = {
      onMouseDown: function (a, c) {
        c = this.chart.pointer.normalize(c);
        a.fixedPosition = {
          chartX: c.chartX,
          chartY: c.chartY,
          plotX: a.plotX,
          plotY: a.plotY
        };
        a.inDragMode = !0;
      },
      onMouseMove: function (a, c) {
        if (a.fixedPosition && a.inDragMode) {
          var b = this.chart,
              f = b.pointer.normalize(c);
          c = a.fixedPosition.chartX - f.chartX;
          f = a.fixedPosition.chartY - f.chartY;
          if (5 < Math.abs(c) || 5 < Math.abs(f)) c = a.fixedPosition.plotX - c, f = a.fixedPosition.plotY - f, b.isInsidePlot(c, f) && (a.plotX = c, a.plotY = f, a.hasDragged = !0, this.redrawHalo(a), this.layout.simulation ? this.layout.resetSimulation() : (this.layout.setInitialRendering(!1), this.layout.enableSimulation ? this.layout.start() : this.layout.setMaxIterations(1), this.chart.redraw(), this.layout.setInitialRendering(!0)));
        }
      },
      onMouseUp: function (a, c) {
        a.fixedPosition && a.hasDragged && (this.layout.enableSimulation ? this.layout.start() : this.chart.redraw(), a.inDragMode = a.hasDragged = !1, this.options.fixedDraggable || delete a.fixedPosition);
      },
      redrawHalo: function (a) {
        a && this.halo && this.halo.attr({
          d: a.haloPath(this.options.states.hover.halo.size)
        });
      }
    };
    c(a, "load", function () {
      var a = this,
          f,
          l,
          w;
      a.container && (f = c(a.container, "mousedown", function (b) {
        var f = a.hoverPoint;
        f && f.series && f.series.hasDraggableNodes && f.series.options.draggable && (f.series.onMouseDown(f, b), l = c(a.container, "mousemove", function (a) {
          return f && f.series && f.series.onMouseMove(f, a);
        }), w = c(a.container.ownerDocument, "mouseup", function (a) {
          l();
          w();
          return f && f.series && f.series.onMouseUp(f, a);
        }));
      }));
      c(a, "destroy", function () {
        f();
      });
    });
  });
  E(f, "parts-more/PackedBubbleSeries.js", [f["parts/Globals.js"], f["parts/Color.js"], f["parts/Point.js"], f["parts/Utilities.js"]], function (f, a, c, b) {
    var l = a.parse,
        v = b.addEvent,
        w = b.clamp,
        z = b.defined,
        y = b.extend;
    a = b.extendClass;
    var d = b.fireEvent,
        m = b.isArray,
        n = b.isNumber,
        t = b.merge,
        x = b.pick;
    b = b.seriesType;
    var A = f.Series,
        r = f.Chart,
        p = f.layouts["reingold-fruchterman"],
        h = f.seriesTypes.bubble.prototype.pointClass,
        g = f.dragNodesMixin;
    f.networkgraphIntegrations.packedbubble = {
      repulsiveForceFunction: function (a, b, c, d) {
        return Math.min(a, (c.marker.radius + d.marker.radius) / 2);
      },
      barycenter: function () {
        var a = this,
            b = a.options.gravitationalConstant,
            c = a.box,
            d = a.nodes,
            f,
            g;
        d.forEach(function (e) {
          a.options.splitSeries && !e.isParentNode ? (f = e.series.parentNode.plotX, g = e.series.parentNode.plotY) : (f = c.width / 2, g = c.height / 2);
          e.fixedPosition || (e.plotX -= (e.plotX - f) * b / (e.mass * Math.sqrt(d.length)), e.plotY -= (e.plotY - g) * b / (e.mass * Math.sqrt(d.length)));
        });
      },
      repulsive: function (a, b, c, d) {
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
      beforeStep: function () {
        this.options.marker && this.series.forEach(function (a) {
          a && a.calculateParentRadius();
        });
      },
      setCircularPositions: function () {
        var a = this,
            b = a.box,
            c = a.nodes,
            d = 2 * Math.PI / (c.length + 1),
            f,
            g,
            h = a.options.initialPositionRadius;
        c.forEach(function (e, c) {
          a.options.splitSeries && !e.isParentNode ? (f = e.series.parentNode.plotX, g = e.series.parentNode.plotY) : (f = b.width / 2, g = b.height / 2);
          e.plotX = e.prevX = x(e.plotX, f + h * Math.cos(e.index || c * d));
          e.plotY = e.prevY = x(e.plotY, g + h * Math.sin(e.index || c * d));
          e.dispX = 0;
          e.dispY = 0;
        });
      },
      repulsiveForces: function () {
        var a = this,
            b,
            c,
            d,
            f = a.options.bubblePadding;
        a.nodes.forEach(function (e) {
          e.degree = e.mass;
          e.neighbours = 0;
          a.nodes.forEach(function (k) {
            b = 0;
            e === k || e.fixedPosition || !a.options.seriesInteraction && e.series !== k.series || (d = a.getDistXY(e, k), c = a.vectorLength(d) - (e.marker.radius + k.marker.radius + f), 0 > c && (e.degree += .01, e.neighbours++, b = a.repulsiveForce(-c / Math.sqrt(e.neighbours), a.k, e, k)), a.force("repulsive", e, b * k.mass, d, k, c));
          });
        });
      },
      applyLimitBox: function (a) {
        if (this.options.splitSeries && !a.isParentNode && this.options.parentNodeLimit) {
          var e = this.getDistXY(a, a.series.parentNode);
          var b = a.series.parentNodeRadius - a.marker.radius - this.vectorLength(e);
          0 > b && b > -2 * a.marker.radius && (a.plotX -= .01 * e.x, a.plotY -= .01 * e.y);
        }

        p.prototype.applyLimitBox.apply(this, arguments);
      },
      isStable: function () {
        return .00001 > Math.abs(this.systemTemperature - this.prevSystemTemperature) || 0 >= this.temperature || 0 < this.systemTemperature && .02 > this.systemTemperature / this.nodes.length && this.enableSimulation;
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
        formatter: function () {
          return this.point.value;
        },
        parentNodeFormatter: function () {
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
        maxIterations: 1E3,
        splitSeries: !1,
        maxSpeed: 5,
        gravitationalConstant: .01,
        friction: -.981
      }
    }, {
      hasDraggableNodes: !0,
      forces: ["barycenter", "repulsive"],
      pointArrayMap: ["value"],
      pointValKey: "value",
      isCartesian: !1,
      requireSorting: !1,
      directTouch: !0,
      axisTypes: [],
      noSharedTooltip: !0,
      searchPoint: f.noop,
      accumulateAllPoints: function (a) {
        var e = a.chart,
            b = [],
            c,
            d;

        for (c = 0; c < e.series.length; c++) if (a = e.series[c], a.visible || !e.options.chart.ignoreHiddenSeries) for (d = 0; d < a.yData.length; d++) b.push([null, null, a.yData[d], a.index, d, {
          id: d,
          marker: {
            radius: 0
          }
        }]);

        return b;
      },
      init: function () {
        A.prototype.init.apply(this, arguments);
        v(this, "updatedData", function () {
          this.chart.series.forEach(function (a) {
            a.type === this.type && (a.isDirty = !0);
          }, this);
        });
        return this;
      },
      render: function () {
        var a = [];
        A.prototype.render.apply(this, arguments);
        this.options.dataLabels.allowOverlap || (this.data.forEach(function (e) {
          m(e.dataLabels) && e.dataLabels.forEach(function (e) {
            a.push(e);
          });
        }), this.options.useSimulation && this.chart.hideOverlappingLabels(a));
      },
      setVisible: function () {
        var a = this;
        A.prototype.setVisible.apply(a, arguments);
        a.parentNodeLayout && a.graph ? a.visible ? (a.graph.show(), a.parentNode.dataLabel && a.parentNode.dataLabel.show()) : (a.graph.hide(), a.parentNodeLayout.removeElementFromCollection(a.parentNode, a.parentNodeLayout.nodes), a.parentNode.dataLabel && a.parentNode.dataLabel.hide()) : a.layout && (a.visible ? a.layout.addElementsToCollection(a.points, a.layout.nodes) : a.points.forEach(function (e) {
          a.layout.removeElementFromCollection(e, a.layout.nodes);
        }));
      },
      drawDataLabels: function () {
        var a = this.options.dataLabels.textPath,
            b = this.points;
        A.prototype.drawDataLabels.apply(this, arguments);
        this.parentNode && (this.parentNode.formatPrefix = "parentNode", this.points = [this.parentNode], this.options.dataLabels.textPath = this.options.dataLabels.parentNodeTextPath, A.prototype.drawDataLabels.apply(this, arguments), this.points = b, this.options.dataLabels.textPath = a);
      },
      seriesBox: function () {
        var a = this.chart,
            b = Math.max,
            c = Math.min,
            d,
            f = [a.plotLeft, a.plotLeft + a.plotWidth, a.plotTop, a.plotTop + a.plotHeight];
        this.data.forEach(function (a) {
          z(a.plotX) && z(a.plotY) && a.marker.radius && (d = a.marker.radius, f[0] = c(f[0], a.plotX - d), f[1] = b(f[1], a.plotX + d), f[2] = c(f[2], a.plotY - d), f[3] = b(f[3], a.plotY + d));
        });
        return n(f.width / f.height) ? f : null;
      },
      calculateParentRadius: function () {
        var a = this.seriesBox();
        this.parentNodeRadius = w(Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20, 20, a ? Math.max(Math.sqrt(Math.pow(a.width, 2) + Math.pow(a.height, 2)) / 2 + 20, 20) : Math.sqrt(2 * this.parentNodeMass / Math.PI) + 20);
        this.parentNode && (this.parentNode.marker.radius = this.parentNode.radius = this.parentNodeRadius);
      },
      drawGraph: function () {
        if (this.layout && this.layout.options.splitSeries) {
          var a = this.chart,
              b = this.layout.options.parentNodeOptions.marker;
          b = {
            fill: b.fillColor || l(this.color).brighten(.4).get(),
            opacity: b.fillOpacity,
            stroke: b.lineColor || this.color,
            "stroke-width": b.lineWidth
          };
          var c = this.visible ? "inherit" : "hidden";
          this.parentNodesGroup || (this.parentNodesGroup = this.plotGroup("parentNodesGroup", "parentNode", c, .1, a.seriesGroup), this.group.attr({
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
      createParentNodes: function () {
        var a = this,
            b = a.chart,
            c = a.parentNodeLayout,
            d,
            f = a.parentNode;
        a.parentNodeMass = 0;
        a.points.forEach(function (e) {
          a.parentNodeMass += Math.PI * Math.pow(e.marker.radius, 2);
        });
        a.calculateParentRadius();
        c.nodes.forEach(function (e) {
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
        })), a.parentNode && (f.plotX = a.parentNode.plotX, f.plotY = a.parentNode.plotY), a.parentNode = f, c.addElementsToCollection([a], c.series), c.addElementsToCollection([f], c.nodes));
      },
      addSeriesLayout: function () {
        var a = this.options.layoutAlgorithm,
            b = this.chart.graphLayoutsStorage,
            c = this.chart.graphLayoutsLookup,
            d = t(a, a.parentNodeOptions, {
          enableSimulation: this.layout.options.enableSimulation
        });
        var g = b[a.type + "-series"];
        g || (b[a.type + "-series"] = g = new f.layouts[a.type](), g.init(d), c.splice(g.index, 0, g));
        this.parentNodeLayout = g;
        this.createParentNodes();
      },
      addLayout: function () {
        var a = this.options.layoutAlgorithm,
            b = this.chart.graphLayoutsStorage,
            c = this.chart.graphLayoutsLookup,
            d = this.chart.options.chart;
        b || (this.chart.graphLayoutsStorage = b = {}, this.chart.graphLayoutsLookup = c = []);
        var g = b[a.type];
        g || (a.enableSimulation = z(d.forExport) ? !d.forExport : a.enableSimulation, b[a.type] = g = new f.layouts[a.type](), g.init(a), c.splice(g.index, 0, g));
        this.layout = g;
        this.points.forEach(function (a) {
          a.mass = 2;
          a.degree = 1;
          a.collisionNmb = 1;
        });
        g.setArea(0, 0, this.chart.plotWidth, this.chart.plotHeight);
        g.addElementsToCollection([this], g.series);
        g.addElementsToCollection(this.points, g.nodes);
      },
      deferLayout: function () {
        var a = this.options.layoutAlgorithm;
        this.visible && (this.addLayout(), a.splitSeries && this.addSeriesLayout());
      },
      translate: function () {
        var a = this.chart,
            b = this.data,
            c = this.index,
            f,
            g = this.options.useSimulation;
        this.processedXData = this.xData;
        this.generatePoints();
        z(a.allDataPoints) || (a.allDataPoints = this.accumulateAllPoints(this), this.getPointRadius());
        if (g) var h = a.allDataPoints;else h = this.placeBubbles(a.allDataPoints), this.options.draggable = !1;

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
      checkOverlap: function (a, b) {
        var e = a[0] - b[0],
            c = a[1] - b[1];
        return -.001 > Math.sqrt(e * e + c * c) - Math.abs(a[2] + b[2]);
      },
      positionBubble: function (a, b, c) {
        var e = Math.sqrt,
            d = Math.asin,
            f = Math.acos,
            g = Math.pow,
            k = Math.abs;
        e = e(g(a[0] - b[0], 2) + g(a[1] - b[1], 2));
        f = f((g(e, 2) + g(c[2] + b[2], 2) - g(c[2] + a[2], 2)) / (2 * (c[2] + b[2]) * e));
        d = d(k(a[0] - b[0]) / e);
        a = (0 > a[1] - b[1] ? 0 : Math.PI) + f + d * (0 > (a[0] - b[0]) * (a[1] - b[1]) ? 1 : -1);
        return [b[0] + (b[2] + c[2]) * Math.sin(a), b[1] - (b[2] + c[2]) * Math.cos(a), c[2], c[3], c[4]];
      },
      placeBubbles: function (a) {
        var b = this.checkOverlap,
            e = this.positionBubble,
            c = [],
            d = 1,
            f = 0,
            g = 0;
        var h = [];
        var p;
        a = a.sort(function (a, b) {
          return b[2] - a[2];
        });

        if (a.length) {
          c.push([[0, 0, a[0][2], a[0][3], a[0][4]]]);
          if (1 < a.length) for (c.push([[0, 0 - a[1][2] - a[0][2], a[1][2], a[1][3], a[1][4]]]), p = 2; p < a.length; p++) a[p][2] = a[p][2] || 1, h = e(c[d][f], c[d - 1][g], a[p]), b(h, c[d][0]) ? (c.push([]), g = 0, c[d + 1].push(e(c[d][f], c[d][0], a[p])), d++, f = 0) : 1 < d && c[d - 1][g + 1] && b(h, c[d - 1][g + 1]) ? (g++, c[d].push(e(c[d][f], c[d - 1][g], a[p])), f++) : (f++, c[d].push(h));
          this.chart.stages = c;
          this.chart.rawPositions = [].concat.apply([], c);
          this.resizeRadius();
          h = this.chart.rawPositions;
        }

        return h;
      },
      resizeRadius: function () {
        var a = this.chart,
            b = a.rawPositions,
            c = Math.min,
            d = Math.max,
            f = a.plotLeft,
            g = a.plotTop,
            h = a.plotHeight,
            p = a.plotWidth,
            r,
            l,
            m;
        var n = r = Number.POSITIVE_INFINITY;
        var t = l = Number.NEGATIVE_INFINITY;

        for (m = 0; m < b.length; m++) {
          var u = b[m][2];
          n = c(n, b[m][0] - u);
          t = d(t, b[m][0] + u);
          r = c(r, b[m][1] - u);
          l = d(l, b[m][1] + u);
        }

        m = [t - n, l - r];
        c = c.apply([], [(p - f) / m[0], (h - g) / m[1]]);

        if (1e-10 < Math.abs(c - 1)) {
          for (m = 0; m < b.length; m++) b[m][2] *= c;

          this.placeBubbles(b);
        } else a.diffY = h / 2 + g - r - (l - r) / 2, a.diffX = p / 2 + f - n - (t - n) / 2;
      },
      calculateZExtremes: function () {
        var a = this.options.zMin,
            b = this.options.zMax,
            c = Infinity,
            d = -Infinity;
        if (a && b) return [a, b];
        this.chart.series.forEach(function (a) {
          a.yData.forEach(function (a) {
            z(a) && (a > d && (d = a), a < c && (c = a));
          });
        });
        a = x(a, c);
        b = x(b, d);
        return [a, b];
      },
      getPointRadius: function () {
        var a = this,
            b = a.chart,
            c = a.options,
            d = c.useSimulation,
            f = Math.min(b.plotWidth, b.plotHeight),
            g = {},
            h = [],
            p = b.allDataPoints,
            r,
            l,
            m,
            n;
        ["minSize", "maxSize"].forEach(function (a) {
          var b = parseInt(c[a], 10),
              e = /%$/.test(c[a]);
          g[a] = e ? f * b / 100 : b * Math.sqrt(p.length);
        });
        b.minRadius = r = g.minSize / Math.sqrt(p.length);
        b.maxRadius = l = g.maxSize / Math.sqrt(p.length);
        var t = d ? a.calculateZExtremes() : [r, l];
        (p || []).forEach(function (b, e) {
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
      onMouseUp: function (a) {
        if (a.fixedPosition && !a.removed) {
          var b,
              c,
              e = this.layout,
              d = this.parentNodeLayout;
          d && e.options.dragBetweenSeries && d.nodes.forEach(function (d) {
            a && a.marker && d !== a.series.parentNode && (b = e.getDistXY(a, d), c = e.vectorLength(b) - d.marker.radius - a.marker.radius, 0 > c && (d.series.addPoint(t(a.options, {
              plotX: a.plotX,
              plotY: a.plotY
            }), !1), e.removeElementFromCollection(a, e.nodes), a.remove()));
          });
          g.onMouseUp.apply(this, arguments);
        }
      },
      destroy: function () {
        this.chart.graphLayoutsLookup && this.chart.graphLayoutsLookup.forEach(function (a) {
          a.removeElementFromCollection(this, a.series);
        }, this);
        this.parentNode && (this.parentNodeLayout.removeElementFromCollection(this.parentNode, this.parentNodeLayout.nodes), this.parentNode.dataLabel && (this.parentNode.dataLabel = this.parentNode.dataLabel.destroy()));
        f.Series.prototype.destroy.apply(this, arguments);
      },
      alignDataLabel: f.Series.prototype.alignDataLabel
    }, {
      destroy: function () {
        this.series.layout && this.series.layout.removeElementFromCollection(this, this.series.layout.nodes);
        return c.prototype.destroy.apply(this, arguments);
      }
    });
    v(r, "beforeRedraw", function () {
      this.allDataPoints && delete this.allDataPoints;
    });
  });
  E(f, "parts-more/Polar.js", [f["parts/Globals.js"], f["parts/Utilities.js"], f["parts-more/Pane.js"]], function (f, a, c) {
    var b = a.addEvent,
        l = a.defined,
        v = a.find,
        w = a.pick,
        z = a.splat,
        y = a.uniqueKey,
        d = a.wrap,
        m = f.Series,
        n = f.seriesTypes,
        t = m.prototype,
        x = f.Pointer.prototype;

    t.searchPointByAngle = function (a) {
      var b = this.chart,
          c = this.xAxis.pane.center;
      return this.searchKDTree({
        clientX: 180 + -180 / Math.PI * Math.atan2(a.chartX - c[0] - b.plotLeft, a.chartY - c[1] - b.plotTop)
      });
    };

    t.getConnectors = function (a, b, c, d) {
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

    t.toXY = function (a) {
      var b = this.chart,
          c = this.xAxis;
      var d = this.yAxis;
      var e = a.plotX,
          f = a.plotY,
          l = a.series,
          r = b.inverted,
          m = a.y,
          n = r ? e : d.len - f;
      r && l && !l.isRadialBar && (a.plotY = f = "number" === typeof m ? d.translate(m) || 0 : 0);
      a.rectPlotX = e;
      a.rectPlotY = f;
      d.center && (n += d.center[3] / 2);
      d = r ? d.postTranslate(f, n) : c.postTranslate(e, n);
      a.plotX = a.polarPlotX = d.x - b.plotLeft;
      a.plotY = a.polarPlotY = d.y - b.plotTop;
      this.kdByAngle ? (b = (e / Math.PI * 180 + c.pane.options.startAngle) % 360, 0 > b && (b += 360), a.clientX = b) : a.clientX = a.plotX;
    };

    n.spline && (d(n.spline.prototype, "getPointSpline", function (a, b, c, d) {
      this.chart.polar ? d ? (a = this.getConnectors(b, d, !0, this.connectEnds), a = ["C", a.prevPointCont.rightContX, a.prevPointCont.rightContY, a.leftContX, a.leftContY, a.plotX, a.plotY]) : a = ["M", c.plotX, c.plotY] : a = a.call(this, b, c, d);
      return a;
    }), n.areasplinerange && (n.areasplinerange.prototype.getPointSpline = n.spline.prototype.getPointSpline));
    b(m, "afterTranslate", function () {
      var a = this.chart;

      if (a.polar && this.xAxis) {
        (this.kdByAngle = a.tooltip && a.tooltip.shared) ? this.searchPoint = this.searchPointByAngle : this.options.findNearestPointBy = "xy";
        if (!this.preventPostTranslate) for (var c = this.points, d = c.length; d--;) this.toXY(c[d]), !a.hasParallelCoordinates && !this.yAxis.reversed && c[d].y < this.yAxis.min && (c[d].isNull = !0);
        this.hasClipCircleSetter || (this.hasClipCircleSetter = !!this.eventsToUnbind.push(b(this, "afterRender", function () {
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
    d(t, "getGraphPath", function (a, b) {
      var c = this,
          d;

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

        b.forEach(function (a) {
          "undefined" === typeof a.polarPlotY && c.toXY(a);
        });
      }

      d = a.apply(this, [].slice.call(arguments, 1));
      f && b.pop();
      return d;
    });

    var A = function (a, b) {
      var c = this,
          d = this.chart,
          e = this.options.animation,
          k = this.group,
          p = this.markerGroup,
          l = this.xAxis.center,
          m = d.plotLeft,
          r = d.plotTop,
          n,
          t,
          u,
          v;
      if (d.polar) {
        if (c.isRadialBar) b || (c.startAngleRad = w(c.translatedThreshold, c.xAxis.startAngleRad), f.seriesTypes.pie.prototype.animate.call(c, b));else {
          if (d.renderer.isSVG) if (e = f.animObject(e), c.is("column")) {
            if (!b) {
              var x = l[3] / 2;
              c.points.forEach(function (a) {
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
    n.column && (m = n.arearange.prototype, n = n.column.prototype, n.polarArc = function (a, b, c, d) {
      var e = this.xAxis.center,
          f = this.yAxis.len,
          g = e[3] / 2;
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
    }, d(n, "animate", A), d(n, "translate", function (b) {
      var c = this.options,
          d = c.stacking,
          g = this.chart,
          e = this.xAxis,
          k = this.yAxis,
          m = k.reversed,
          r = k.center,
          n = e.startAngleRad,
          t = e.endAngleRad - n;
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

        for (; e--;) {
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

            D > z && (z = [D, D = z][0]);
            if (!m) {
              if (D < u) D = u;else if (z > v) z = v;else {
                if (z < u || D > v) D = z = 0;
              }
            } else if (z > u) z = u;else if (D < v) D = v;else if (D > u || z < v) D = z = t;
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
          g.inverted ? (x = k.postTranslate(c.rectPlotY, x + c.pointWidth / 2), c.tooltipPos = [x.x - g.plotLeft, x.y - g.plotTop]) : c.tooltipPos = [c.plotX, c.plotY];
          r && (c.ttBelow = c.plotY > r[1]);
        }
      }
    }), n.findAlignments = function (a, b) {
      null === b.align && (b.align = 20 < a && 160 > a ? "left" : 200 < a && 340 > a ? "right" : "center");
      null === b.verticalAlign && (b.verticalAlign = 45 > a || 315 < a ? "bottom" : 135 < a && 225 > a ? "top" : "middle");
      return b;
    }, m && (m.findAlignments = n.findAlignments), d(n, "alignDataLabel", function (a, b, c, d, e, f) {
      var g = this.chart,
          h = w(d.inside, !!this.options.stacking);
      g.polar ? (a = b.rectPlotX / Math.PI * 180, g.inverted ? (this.forceDL = g.isInsidePlot(b.plotX, Math.round(b.plotY), !1), h && b.shapeArgs ? (e = b.shapeArgs, e = this.yAxis.postTranslate((e.start + e.end) / 2 - this.xAxis.startAngleRad, b.barX + b.pointWidth / 2), e = {
        x: e.x - g.plotLeft,
        y: e.y - g.plotTop
      }) : b.tooltipPos && (e = {
        x: b.tooltipPos[0],
        y: b.tooltipPos[1]
      }), d.align = w(d.align, "center"), d.verticalAlign = w(d.verticalAlign, "middle")) : this.findAlignments && (d = this.findAlignments(a, d)), t.alignDataLabel.call(this, b, c, d, e, f), this.isRadialBar && b.shapeArgs && b.shapeArgs.start === b.shapeArgs.end && c.hide(!0)) : a.call(this, b, c, d, e, f);
    }));
    d(x, "getCoordinates", function (a, b) {
      var c = this.chart,
          d = {
        xAxis: [],
        yAxis: []
      };
      c.polar ? c.axes.forEach(function (a) {
        var e = a.isXAxis,
            f = a.center;

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

    f.SVGRenderer.prototype.clipCircle = function (a, b, c, d) {
      var e = y(),
          f = this.createElement("clipPath").attr({
        id: e
      }).add(this.defs);
      a = d ? this.arc(a, b, c, d, 0, 2 * Math.PI).add(f) : this.circle(a, b, c).add(f);
      a.id = e;
      a.clipPath = f;
      return a;
    };

    b(f.Chart, "getAxes", function () {
      this.pane || (this.pane = []);
      z(this.options.pane).forEach(function (a) {
        new c(a, this);
      }, this);
    });
    b(f.Chart, "afterDrawChartBox", function () {
      this.pane.forEach(function (a) {
        a.render();
      });
    });
    b(f.Series, "afterInit", function () {
      var a = this.chart;
      a.inverted && a.polar && (this.isRadialSeries = !0, this.is("column") && (this.isRadialBar = !0));
    });
    d(f.Chart.prototype, "get", function (a, b) {
      return v(this.pane, function (a) {
        return a.options.id === b;
      }) || a.call(this, b);
    });
  });
  E(f, "masters/highcharts-more.src.js", [], function () {});
});
});

// NB Chartkick and Highcharts are defined as global in rollup
var Highcharts$1 = window.Highcharts; // Highcharts is defined as global in rollup

var $ = window.$;
highchartsMore(Highcharts$1);

var _default$a = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      var _this = this;

      $.getJSON(this.data.get("url"), function (data) {
        Highcharts$1.chart(_this.element, {
          chart: {
            scrollablePlotArea: {
              minWidth: 600,
              scrollPositionX: 1
            }
          },
          title: {
            //text: "Peritoneal Equilibration Test",
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
            plotBands: [{
              from: 0.3,
              to: 0.5,
              color: "rgba(68, 170, 213, 0.1)",
              label: {
                text: "Low",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: 0.5,
              to: 0.65,
              color: "rgba(0, 0, 0, 0)",
              label: {
                text: "Low average",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: 0.65,
              to: 0.82,
              color: "rgba(68, 170, 213, 0.1)",
              label: {
                text: "High average",
                style: {
                  color: "#606060"
                }
              }
            }, {
              from: 0.82,
              to: 1.0,
              color: "rgba(0, 0, 0, 0)",
              label: {
                text: "High",
                style: {
                  color: "#606060"
                }
              }
            }]
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
            plotLines: [{
              color: "#BBB",
              width: 1,
              value: 0
            }]
          },
          tooltip: {
            formatter: function formatter() {
              return "<br>D_Pcr <b>" + this.x + "</b><br>" + "netUF <b>" + this.y + "</b>";
            }
          },
          plotOptions: {
            pointStart: 0.3,
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
          series: [{
            name: "Expected",
            color: "#00a499",
            //"#D970D9",
            showInLegend: true,
            type: "polygon",
            data: [[0.36, 400], [0.36, 1000], [0.5, 1000], [0.9, 600], [0.9, 300], [0.6, 100], [0.36, 400]]
          }, {
            name: "Warning",
            color: "#fff495",
            showInLegend: true,
            type: "polygon",
            data: [[0.6, 100], [0.9, 300], [1.0, 200], [1.0, -600], [0.75, -600], [0.6, 100]]
          }, {
            // patient data
            color: "#040481",
            showInLegend: false,
            enableMouseTracking: true,
            data: data
          }],
          navigation: {
            menuItemStyle: {
              fontSize: "10px"
            }
          }
        });
        _this.element.style.overflow = "unset";
      });
    }
  }]);

  return _default;
}(Controller);

var _default$9 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      // let data = this.data.get("chartData")
      // let chartId = this.chartTarget.id
      // console.log(chartId)
      // let json = [
      //     {
      //       name: "",
      //       data: data
      //     }
      //   ]
      console.log("Not implemented"); //Highcharts.SparkLine(this.chartTarget, {})
      //     series: [{
      //         name: '',
      //         data: data
      //    }]
      // })
      //new Chartkick.LineChart(chartId, json, this.chartOptions)
    } // get chartOptions() {
    //   return {
    //     library: {
    //       chart: {
    //         type: "area",
    //         margin: [0, 0, 0, 0],
    //         height: 20,
    //         width: 80,
    //         skipClone: true,
    //         style: {
    //           overflow: "visible"
    //         }
    //       },
    //       credits: {
    //         enabled: false
    //       },
    //       title: "",
    //       xAxis: {
    //         type: "datetime",
    //         tickPositions: [],
    //         labels: {
    //           enabled: false
    //         },
    //         startOnTick: false,
    //         endOnTick: false,
    //         title: {
    //           text: null
    //         }
    //       },
    //       legend: {
    //         enabled: false
    //       },
    //       yAxis: {
    //         tickPositions: [0],
    //         endOnTick: false,
    //         startOnTick: false,
    //         title: {
    //           text: null
    //         },
    //         min: 0,
    //         labels: {
    //           enabled: false
    //         }
    //       },
    //       tooltip: {
    //         hideDelay: 0,
    //         outside: true,
    //         shared: true,
    //         xDateFormat: '%d-%b-%Y'
    //       },
    //       plotOptions: {
    //         series: {
    //           animation: false,
    //           lineWidth: 1,
    //           shadow: false,
    //           states: {
    //             hover: {
    //               lineWidth: 1
    //             }
    //           },
    //           marker: {
    //             radius: 1,
    //             states: {
    //               hover: {
    //                 radius: 2
    //               }
    //             }
    //           },
    //           fillOpacity: 0.25
    //         },
    //         column: {
    //           negativeColor: "#910000",
    //           borderColor: "silver"
    //         }
    //       }
    //     }
    //   }
    // }

  }]);

  return _default;
}(Controller);
/**
* Create a constructor for sparklines that takes some sensible defaults and merges in the individual
* chart options.
*/

/*
window.Highcharts.SparkLine = function (a, b, c) {
console.log("defining1");
var hasRenderToArg = typeof a === 'string' || a.nodeName,
    options = arguments[hasRenderToArg ? 1 : 0],
    defaultOptions = {
        chart: {
            renderTo: (options.chart && options.chart.renderTo) || this,
            backgroundColor: null,
            borderWidth: 0,
            type: 'area',
            margin: [2, 0, 2, 0],
            width: 120,
            height: 20,
            style: {
                overflow: 'visible'
            },
             // small optimalization, saves 1-2 ms each sparkline
            skipClone: true
        },
        title: {
            text: ''
        },
        credits: {
            enabled: false
        },
        xAxis: {
            labels: {
                enabled: false
            },
            title: {
                text: null
            },
            startOnTick: false,
            endOnTick: false,
            tickPositions: []
        },
        yAxis: {
            endOnTick: false,
            startOnTick: false,
            labels: {
                enabled: false
            },
            title: {
                text: null
            },
            tickPositions: [0]
        },
        legend: {
            enabled: false
        },
        tooltip: {
            hideDelay: 0,
            outside: true,
            shared: true
        },
        plotOptions: {
            series: {
                animation: false,
                lineWidth: 1,
                shadow: false,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                marker: {
                    radius: 1,
                    states: {
                        hover: {
                            radius: 2
                        }
                    }
                },
                fillOpacity: 0.25
            },
            column: {
                negativeColor: '#910000',
                borderColor: 'silver'
            }
        }
    };
 options = Highcharts.merge(defaultOptions, options);
 return hasRenderToArg ?
    new Highcharts.Chart(a, options, c) :
    new Highcharts.Chart(options, b)
}
 */


_defineProperty$1(_default$9, "targets", ["chart"]);

// allow a more dense menu that can simplifies by hiding/collapsing sections.
//
// Example slim markup:
//
// div(data-controller="collapsible" data-collapsible-open-class="open")
//   a(data-action="collapsible#open" data-collapsible-target="link" href="#") X
//   div.collapsible(data-collapsible-target="section")
//     p XXX
//   a(data-action="collapsible#open" data-collapsible-target="link" href="#") Y
//   div.collapsible(data-collapsible-target="section")
//     p YYY

var _default$8 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "connect",
    value: function connect() {} // TODO: We could support an initial open section here for example.
    // When a user clicks on a link with the target of "link", we determine its index,
    // hide all "section" targets initially, then just show the section with the
    // current index. This is a similar approach to the one we take with the tabs controller.

  }, {
    key: "open",
    value: function open(event) {
      var _this = this;

      var index = this.linkTargets.indexOf(event.currentTarget);
      this.sectionTargets.forEach(function (elem, idx) {
        elem.classList.remove(_this.openClass);

        if (idx == index) {
          elem.classList.add(_this.openClass);
        }
      });
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$8, "targets", ["section", "link"]);

_defineProperty$1(_default$8, "classes", ["open"]);

var _default$7 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
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
      }).then(function (response) {
        return response.json();
      }).then(function (data) {
        var selectBox = _this.targetTarget;
        selectBox.innerHTML = "";
        selectBox.appendChild(document.createElement("option")); // blank option

        data.forEach(function (item) {
          var opt = document.createElement("option");
          opt.value = item.id;
          opt.innerHTML = item[_this.data.get("displayAttribute")];
          opt.selected = parseInt(targetId) === item.id;
          selectBox.appendChild(opt);
        });
      });
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$7, "targets", ["source", "target"]);

var _default$6 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "toggleFileInputs",
    // When the attachment type changes we examine a data attribute on the selected option
    // and show/hide the relevant file input (a text input if its an external stored, otherwise
    // a conventional file input).
    value: function toggleFileInputs(event) {
      var selectedOption = event.target.querySelector("option:checked");
      var storeFileExternally = "true" == selectedOption.getAttribute("data-store-file-externally");
      this.fileBrowserTarget.style.display = storeFileExternally ? "none" : "block";
      this.externalLocationTarget.style.display = storeFileExternally ? "block" : "none";
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$6, "targets", ["fileBrowser", "externalLocation"]);

/**!
 * Sortable 1.13.0
 * @author	RubaXa   <trash@rubaxa.org>
 * @author	owenm    <owen23355@gmail.com>
 * @license MIT
 */
function _typeof(obj) {
  if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
    _typeof = function (obj) {
      return typeof obj;
    };
  } else {
    _typeof = function (obj) {
      return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
    };
  }

  return _typeof(obj);
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

function _extends() {
  _extends = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }

    return target;
  };

  return _extends.apply(this, arguments);
}

function _objectSpread(target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i] != null ? arguments[i] : {};
    var ownKeys = Object.keys(source);

    if (typeof Object.getOwnPropertySymbols === 'function') {
      ownKeys = ownKeys.concat(Object.getOwnPropertySymbols(source).filter(function (sym) {
        return Object.getOwnPropertyDescriptor(source, sym).enumerable;
      }));
    }

    ownKeys.forEach(function (key) {
      _defineProperty(target, key, source[key]);
    });
  }

  return target;
}

function _objectWithoutPropertiesLoose(source, excluded) {
  if (source == null) return {};
  var target = {};
  var sourceKeys = Object.keys(source);
  var key, i;

  for (i = 0; i < sourceKeys.length; i++) {
    key = sourceKeys[i];
    if (excluded.indexOf(key) >= 0) continue;
    target[key] = source[key];
  }

  return target;
}

function _objectWithoutProperties(source, excluded) {
  if (source == null) return {};

  var target = _objectWithoutPropertiesLoose(source, excluded);

  var key, i;

  if (Object.getOwnPropertySymbols) {
    var sourceSymbolKeys = Object.getOwnPropertySymbols(source);

    for (i = 0; i < sourceSymbolKeys.length; i++) {
      key = sourceSymbolKeys[i];
      if (excluded.indexOf(key) >= 0) continue;
      if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue;
      target[key] = source[key];
    }
  }

  return target;
}

var version = "1.13.0";

function userAgent(pattern) {
  if (typeof window !== 'undefined' && window.navigator) {
    return !! /*@__PURE__*/navigator.userAgent.match(pattern);
  }
}

var IE11OrLess = userAgent(/(?:Trident.*rv[ :]?11\.|msie|iemobile|Windows Phone)/i);
var Edge = userAgent(/Edge/i);
var FireFox = userAgent(/firefox/i);
var Safari = userAgent(/safari/i) && !userAgent(/chrome/i) && !userAgent(/android/i);
var IOS = userAgent(/iP(ad|od|hone)/i);
var ChromeForAndroid = userAgent(/chrome/i) && userAgent(/android/i);
var captureMode = {
  capture: false,
  passive: false
};

function on(el, event, fn) {
  el.addEventListener(event, fn, !IE11OrLess && captureMode);
}

function off(el, event, fn) {
  el.removeEventListener(event, fn, !IE11OrLess && captureMode);
}

function matches(
/**HTMLElement*/
el,
/**String*/
selector) {
  if (!selector) return;
  selector[0] === '>' && (selector = selector.substring(1));

  if (el) {
    try {
      if (el.matches) {
        return el.matches(selector);
      } else if (el.msMatchesSelector) {
        return el.msMatchesSelector(selector);
      } else if (el.webkitMatchesSelector) {
        return el.webkitMatchesSelector(selector);
      }
    } catch (_) {
      return false;
    }
  }

  return false;
}

function getParentOrHost(el) {
  return el.host && el !== document && el.host.nodeType ? el.host : el.parentNode;
}

function closest(
/**HTMLElement*/
el,
/**String*/
selector,
/**HTMLElement*/
ctx, includeCTX) {
  if (el) {
    ctx = ctx || document;

    do {
      if (selector != null && (selector[0] === '>' ? el.parentNode === ctx && matches(el, selector) : matches(el, selector)) || includeCTX && el === ctx) {
        return el;
      }

      if (el === ctx) break;
      /* jshint boss:true */
    } while (el = getParentOrHost(el));
  }

  return null;
}

var R_SPACE = /\s+/g;

function toggleClass(el, name, state) {
  if (el && name) {
    if (el.classList) {
      el.classList[state ? 'add' : 'remove'](name);
    } else {
      var className = (' ' + el.className + ' ').replace(R_SPACE, ' ').replace(' ' + name + ' ', ' ');
      el.className = (className + (state ? ' ' + name : '')).replace(R_SPACE, ' ');
    }
  }
}

function css(el, prop, val) {
  var style = el && el.style;

  if (style) {
    if (val === void 0) {
      if (document.defaultView && document.defaultView.getComputedStyle) {
        val = document.defaultView.getComputedStyle(el, '');
      } else if (el.currentStyle) {
        val = el.currentStyle;
      }

      return prop === void 0 ? val : val[prop];
    } else {
      if (!(prop in style) && prop.indexOf('webkit') === -1) {
        prop = '-webkit-' + prop;
      }

      style[prop] = val + (typeof val === 'string' ? '' : 'px');
    }
  }
}

function matrix(el, selfOnly) {
  var appliedTransforms = '';

  if (typeof el === 'string') {
    appliedTransforms = el;
  } else {
    do {
      var transform = css(el, 'transform');

      if (transform && transform !== 'none') {
        appliedTransforms = transform + ' ' + appliedTransforms;
      }
      /* jshint boss:true */

    } while (!selfOnly && (el = el.parentNode));
  }

  var matrixFn = window.DOMMatrix || window.WebKitCSSMatrix || window.CSSMatrix || window.MSCSSMatrix;
  /*jshint -W056 */

  return matrixFn && new matrixFn(appliedTransforms);
}

function find(ctx, tagName, iterator) {
  if (ctx) {
    var list = ctx.getElementsByTagName(tagName),
        i = 0,
        n = list.length;

    if (iterator) {
      for (; i < n; i++) {
        iterator(list[i], i);
      }
    }

    return list;
  }

  return [];
}

function getWindowScrollingElement() {
  var scrollingElement = document.scrollingElement;

  if (scrollingElement) {
    return scrollingElement;
  } else {
    return document.documentElement;
  }
}
/**
 * Returns the "bounding client rect" of given element
 * @param  {HTMLElement} el                       The element whose boundingClientRect is wanted
 * @param  {[Boolean]} relativeToContainingBlock  Whether the rect should be relative to the containing block of (including) the container
 * @param  {[Boolean]} relativeToNonStaticParent  Whether the rect should be relative to the relative parent of (including) the contaienr
 * @param  {[Boolean]} undoScale                  Whether the container's scale() should be undone
 * @param  {[HTMLElement]} container              The parent the element will be placed in
 * @return {Object}                               The boundingClientRect of el, with specified adjustments
 */


function getRect(el, relativeToContainingBlock, relativeToNonStaticParent, undoScale, container) {
  if (!el.getBoundingClientRect && el !== window) return;
  var elRect, top, left, bottom, right, height, width;

  if (el !== window && el.parentNode && el !== getWindowScrollingElement()) {
    elRect = el.getBoundingClientRect();
    top = elRect.top;
    left = elRect.left;
    bottom = elRect.bottom;
    right = elRect.right;
    height = elRect.height;
    width = elRect.width;
  } else {
    top = 0;
    left = 0;
    bottom = window.innerHeight;
    right = window.innerWidth;
    height = window.innerHeight;
    width = window.innerWidth;
  }

  if ((relativeToContainingBlock || relativeToNonStaticParent) && el !== window) {
    // Adjust for translate()
    container = container || el.parentNode; // solves #1123 (see: https://stackoverflow.com/a/37953806/6088312)
    // Not needed on <= IE11

    if (!IE11OrLess) {
      do {
        if (container && container.getBoundingClientRect && (css(container, 'transform') !== 'none' || relativeToNonStaticParent && css(container, 'position') !== 'static')) {
          var containerRect = container.getBoundingClientRect(); // Set relative to edges of padding box of container

          top -= containerRect.top + parseInt(css(container, 'border-top-width'));
          left -= containerRect.left + parseInt(css(container, 'border-left-width'));
          bottom = top + elRect.height;
          right = left + elRect.width;
          break;
        }
        /* jshint boss:true */

      } while (container = container.parentNode);
    }
  }

  if (undoScale && el !== window) {
    // Adjust for scale()
    var elMatrix = matrix(container || el),
        scaleX = elMatrix && elMatrix.a,
        scaleY = elMatrix && elMatrix.d;

    if (elMatrix) {
      top /= scaleY;
      left /= scaleX;
      width /= scaleX;
      height /= scaleY;
      bottom = top + height;
      right = left + width;
    }
  }

  return {
    top: top,
    left: left,
    bottom: bottom,
    right: right,
    width: width,
    height: height
  };
}
/**
 * Checks if a side of an element is scrolled past a side of its parents
 * @param  {HTMLElement}  el           The element who's side being scrolled out of view is in question
 * @param  {String}       elSide       Side of the element in question ('top', 'left', 'right', 'bottom')
 * @param  {String}       parentSide   Side of the parent in question ('top', 'left', 'right', 'bottom')
 * @return {HTMLElement}               The parent scroll element that the el's side is scrolled past, or null if there is no such element
 */


function isScrolledPast(el, elSide, parentSide) {
  var parent = getParentAutoScrollElement(el, true),
      elSideVal = getRect(el)[elSide];
  /* jshint boss:true */

  while (parent) {
    var parentSideVal = getRect(parent)[parentSide],
        visible = void 0;

    if (parentSide === 'top' || parentSide === 'left') {
      visible = elSideVal >= parentSideVal;
    } else {
      visible = elSideVal <= parentSideVal;
    }

    if (!visible) return parent;
    if (parent === getWindowScrollingElement()) break;
    parent = getParentAutoScrollElement(parent, false);
  }

  return false;
}
/**
 * Gets nth child of el, ignoring hidden children, sortable's elements (does not ignore clone if it's visible)
 * and non-draggable elements
 * @param  {HTMLElement} el       The parent element
 * @param  {Number} childNum      The index of the child
 * @param  {Object} options       Parent Sortable's options
 * @return {HTMLElement}          The child at index childNum, or null if not found
 */


function getChild(el, childNum, options) {
  var currentChild = 0,
      i = 0,
      children = el.children;

  while (i < children.length) {
    if (children[i].style.display !== 'none' && children[i] !== Sortable.ghost && children[i] !== Sortable.dragged && closest(children[i], options.draggable, el, false)) {
      if (currentChild === childNum) {
        return children[i];
      }

      currentChild++;
    }

    i++;
  }

  return null;
}
/**
 * Gets the last child in the el, ignoring ghostEl or invisible elements (clones)
 * @param  {HTMLElement} el       Parent element
 * @param  {selector} selector    Any other elements that should be ignored
 * @return {HTMLElement}          The last child, ignoring ghostEl
 */


function lastChild(el, selector) {
  var last = el.lastElementChild;

  while (last && (last === Sortable.ghost || css(last, 'display') === 'none' || selector && !matches(last, selector))) {
    last = last.previousElementSibling;
  }

  return last || null;
}
/**
 * Returns the index of an element within its parent for a selected set of
 * elements
 * @param  {HTMLElement} el
 * @param  {selector} selector
 * @return {number}
 */


function index$1(el, selector) {
  var index = 0;

  if (!el || !el.parentNode) {
    return -1;
  }
  /* jshint boss:true */


  while (el = el.previousElementSibling) {
    if (el.nodeName.toUpperCase() !== 'TEMPLATE' && el !== Sortable.clone && (!selector || matches(el, selector))) {
      index++;
    }
  }

  return index;
}
/**
 * Returns the scroll offset of the given element, added with all the scroll offsets of parent elements.
 * The value is returned in real pixels.
 * @param  {HTMLElement} el
 * @return {Array}             Offsets in the format of [left, top]
 */


function getRelativeScrollOffset(el) {
  var offsetLeft = 0,
      offsetTop = 0,
      winScroller = getWindowScrollingElement();

  if (el) {
    do {
      var elMatrix = matrix(el),
          scaleX = elMatrix.a,
          scaleY = elMatrix.d;
      offsetLeft += el.scrollLeft * scaleX;
      offsetTop += el.scrollTop * scaleY;
    } while (el !== winScroller && (el = el.parentNode));
  }

  return [offsetLeft, offsetTop];
}
/**
 * Returns the index of the object within the given array
 * @param  {Array} arr   Array that may or may not hold the object
 * @param  {Object} obj  An object that has a key-value pair unique to and identical to a key-value pair in the object you want to find
 * @return {Number}      The index of the object in the array, or -1
 */


function indexOfObject(arr, obj) {
  for (var i in arr) {
    if (!arr.hasOwnProperty(i)) continue;

    for (var key in obj) {
      if (obj.hasOwnProperty(key) && obj[key] === arr[i][key]) return Number(i);
    }
  }

  return -1;
}

function getParentAutoScrollElement(el, includeSelf) {
  // skip to window
  if (!el || !el.getBoundingClientRect) return getWindowScrollingElement();
  var elem = el;
  var gotSelf = false;

  do {
    // we don't need to get elem css if it isn't even overflowing in the first place (performance)
    if (elem.clientWidth < elem.scrollWidth || elem.clientHeight < elem.scrollHeight) {
      var elemCSS = css(elem);

      if (elem.clientWidth < elem.scrollWidth && (elemCSS.overflowX == 'auto' || elemCSS.overflowX == 'scroll') || elem.clientHeight < elem.scrollHeight && (elemCSS.overflowY == 'auto' || elemCSS.overflowY == 'scroll')) {
        if (!elem.getBoundingClientRect || elem === document.body) return getWindowScrollingElement();
        if (gotSelf || includeSelf) return elem;
        gotSelf = true;
      }
    }
    /* jshint boss:true */

  } while (elem = elem.parentNode);

  return getWindowScrollingElement();
}

function extend$1(dst, src) {
  if (dst && src) {
    for (var key in src) {
      if (src.hasOwnProperty(key)) {
        dst[key] = src[key];
      }
    }
  }

  return dst;
}

function isRectEqual(rect1, rect2) {
  return Math.round(rect1.top) === Math.round(rect2.top) && Math.round(rect1.left) === Math.round(rect2.left) && Math.round(rect1.height) === Math.round(rect2.height) && Math.round(rect1.width) === Math.round(rect2.width);
}

var _throttleTimeout;

function throttle(callback, ms) {
  return function () {
    if (!_throttleTimeout) {
      var args = arguments,
          _this = this;

      if (args.length === 1) {
        callback.call(_this, args[0]);
      } else {
        callback.apply(_this, args);
      }

      _throttleTimeout = setTimeout(function () {
        _throttleTimeout = void 0;
      }, ms);
    }
  };
}

function cancelThrottle() {
  clearTimeout(_throttleTimeout);
  _throttleTimeout = void 0;
}

function scrollBy(el, x, y) {
  el.scrollLeft += x;
  el.scrollTop += y;
}

function clone(el) {
  var Polymer = window.Polymer;
  var $ = window.jQuery || window.Zepto;

  if (Polymer && Polymer.dom) {
    return Polymer.dom(el).cloneNode(true);
  } else if ($) {
    return $(el).clone(true)[0];
  } else {
    return el.cloneNode(true);
  }
}

var expando = 'Sortable' + new Date().getTime();

function AnimationStateManager() {
  var animationStates = [],
      animationCallbackId;
  return {
    captureAnimationState: function captureAnimationState() {
      animationStates = [];
      if (!this.options.animation) return;
      var children = [].slice.call(this.el.children);
      children.forEach(function (child) {
        if (css(child, 'display') === 'none' || child === Sortable.ghost) return;
        animationStates.push({
          target: child,
          rect: getRect(child)
        });

        var fromRect = _objectSpread({}, animationStates[animationStates.length - 1].rect); // If animating: compensate for current animation


        if (child.thisAnimationDuration) {
          var childMatrix = matrix(child, true);

          if (childMatrix) {
            fromRect.top -= childMatrix.f;
            fromRect.left -= childMatrix.e;
          }
        }

        child.fromRect = fromRect;
      });
    },
    addAnimationState: function addAnimationState(state) {
      animationStates.push(state);
    },
    removeAnimationState: function removeAnimationState(target) {
      animationStates.splice(indexOfObject(animationStates, {
        target: target
      }), 1);
    },
    animateAll: function animateAll(callback) {
      var _this = this;

      if (!this.options.animation) {
        clearTimeout(animationCallbackId);
        if (typeof callback === 'function') callback();
        return;
      }

      var animating = false,
          animationTime = 0;
      animationStates.forEach(function (state) {
        var time = 0,
            target = state.target,
            fromRect = target.fromRect,
            toRect = getRect(target),
            prevFromRect = target.prevFromRect,
            prevToRect = target.prevToRect,
            animatingRect = state.rect,
            targetMatrix = matrix(target, true);

        if (targetMatrix) {
          // Compensate for current animation
          toRect.top -= targetMatrix.f;
          toRect.left -= targetMatrix.e;
        }

        target.toRect = toRect;

        if (target.thisAnimationDuration) {
          // Could also check if animatingRect is between fromRect and toRect
          if (isRectEqual(prevFromRect, toRect) && !isRectEqual(fromRect, toRect) && // Make sure animatingRect is on line between toRect & fromRect
          (animatingRect.top - toRect.top) / (animatingRect.left - toRect.left) === (fromRect.top - toRect.top) / (fromRect.left - toRect.left)) {
            // If returning to same place as started from animation and on same axis
            time = calculateRealTime(animatingRect, prevFromRect, prevToRect, _this.options);
          }
        } // if fromRect != toRect: animate


        if (!isRectEqual(toRect, fromRect)) {
          target.prevFromRect = fromRect;
          target.prevToRect = toRect;

          if (!time) {
            time = _this.options.animation;
          }

          _this.animate(target, animatingRect, toRect, time);
        }

        if (time) {
          animating = true;
          animationTime = Math.max(animationTime, time);
          clearTimeout(target.animationResetTimer);
          target.animationResetTimer = setTimeout(function () {
            target.animationTime = 0;
            target.prevFromRect = null;
            target.fromRect = null;
            target.prevToRect = null;
            target.thisAnimationDuration = null;
          }, time);
          target.thisAnimationDuration = time;
        }
      });
      clearTimeout(animationCallbackId);

      if (!animating) {
        if (typeof callback === 'function') callback();
      } else {
        animationCallbackId = setTimeout(function () {
          if (typeof callback === 'function') callback();
        }, animationTime);
      }

      animationStates = [];
    },
    animate: function animate(target, currentRect, toRect, duration) {
      if (duration) {
        css(target, 'transition', '');
        css(target, 'transform', '');
        var elMatrix = matrix(this.el),
            scaleX = elMatrix && elMatrix.a,
            scaleY = elMatrix && elMatrix.d,
            translateX = (currentRect.left - toRect.left) / (scaleX || 1),
            translateY = (currentRect.top - toRect.top) / (scaleY || 1);
        target.animatingX = !!translateX;
        target.animatingY = !!translateY;
        css(target, 'transform', 'translate3d(' + translateX + 'px,' + translateY + 'px,0)');
        this.forRepaintDummy = repaint(target); // repaint

        css(target, 'transition', 'transform ' + duration + 'ms' + (this.options.easing ? ' ' + this.options.easing : ''));
        css(target, 'transform', 'translate3d(0,0,0)');
        typeof target.animated === 'number' && clearTimeout(target.animated);
        target.animated = setTimeout(function () {
          css(target, 'transition', '');
          css(target, 'transform', '');
          target.animated = false;
          target.animatingX = false;
          target.animatingY = false;
        }, duration);
      }
    }
  };
}

function repaint(target) {
  return target.offsetWidth;
}

function calculateRealTime(animatingRect, fromRect, toRect, options) {
  return Math.sqrt(Math.pow(fromRect.top - animatingRect.top, 2) + Math.pow(fromRect.left - animatingRect.left, 2)) / Math.sqrt(Math.pow(fromRect.top - toRect.top, 2) + Math.pow(fromRect.left - toRect.left, 2)) * options.animation;
}

var plugins = [];
var defaults = {
  initializeByDefault: true
};
var PluginManager = {
  mount: function mount(plugin) {
    // Set default static properties
    for (var option in defaults) {
      if (defaults.hasOwnProperty(option) && !(option in plugin)) {
        plugin[option] = defaults[option];
      }
    }

    plugins.forEach(function (p) {
      if (p.pluginName === plugin.pluginName) {
        throw "Sortable: Cannot mount plugin ".concat(plugin.pluginName, " more than once");
      }
    });
    plugins.push(plugin);
  },
  pluginEvent: function pluginEvent(eventName, sortable, evt) {
    var _this = this;

    this.eventCanceled = false;

    evt.cancel = function () {
      _this.eventCanceled = true;
    };

    var eventNameGlobal = eventName + 'Global';
    plugins.forEach(function (plugin) {
      if (!sortable[plugin.pluginName]) return; // Fire global events if it exists in this sortable

      if (sortable[plugin.pluginName][eventNameGlobal]) {
        sortable[plugin.pluginName][eventNameGlobal](_objectSpread({
          sortable: sortable
        }, evt));
      } // Only fire plugin event if plugin is enabled in this sortable,
      // and plugin has event defined


      if (sortable.options[plugin.pluginName] && sortable[plugin.pluginName][eventName]) {
        sortable[plugin.pluginName][eventName](_objectSpread({
          sortable: sortable
        }, evt));
      }
    });
  },
  initializePlugins: function initializePlugins(sortable, el, defaults, options) {
    plugins.forEach(function (plugin) {
      var pluginName = plugin.pluginName;
      if (!sortable.options[pluginName] && !plugin.initializeByDefault) return;
      var initialized = new plugin(sortable, el, sortable.options);
      initialized.sortable = sortable;
      initialized.options = sortable.options;
      sortable[pluginName] = initialized; // Add default options from plugin

      _extends(defaults, initialized.defaults);
    });

    for (var option in sortable.options) {
      if (!sortable.options.hasOwnProperty(option)) continue;
      var modified = this.modifyOption(sortable, option, sortable.options[option]);

      if (typeof modified !== 'undefined') {
        sortable.options[option] = modified;
      }
    }
  },
  getEventProperties: function getEventProperties(name, sortable) {
    var eventProperties = {};
    plugins.forEach(function (plugin) {
      if (typeof plugin.eventProperties !== 'function') return;

      _extends(eventProperties, plugin.eventProperties.call(sortable[plugin.pluginName], name));
    });
    return eventProperties;
  },
  modifyOption: function modifyOption(sortable, name, value) {
    var modifiedValue;
    plugins.forEach(function (plugin) {
      // Plugin must exist on the Sortable
      if (!sortable[plugin.pluginName]) return; // If static option listener exists for this option, call in the context of the Sortable's instance of this plugin

      if (plugin.optionListeners && typeof plugin.optionListeners[name] === 'function') {
        modifiedValue = plugin.optionListeners[name].call(sortable[plugin.pluginName], value);
      }
    });
    return modifiedValue;
  }
};

function dispatchEvent$1(_ref) {
  var sortable = _ref.sortable,
      rootEl = _ref.rootEl,
      name = _ref.name,
      targetEl = _ref.targetEl,
      cloneEl = _ref.cloneEl,
      toEl = _ref.toEl,
      fromEl = _ref.fromEl,
      oldIndex = _ref.oldIndex,
      newIndex = _ref.newIndex,
      oldDraggableIndex = _ref.oldDraggableIndex,
      newDraggableIndex = _ref.newDraggableIndex,
      originalEvent = _ref.originalEvent,
      putSortable = _ref.putSortable,
      extraEventProperties = _ref.extraEventProperties;
  sortable = sortable || rootEl && rootEl[expando];
  if (!sortable) return;
  var evt,
      options = sortable.options,
      onName = 'on' + name.charAt(0).toUpperCase() + name.substr(1); // Support for new CustomEvent feature

  if (window.CustomEvent && !IE11OrLess && !Edge) {
    evt = new CustomEvent(name, {
      bubbles: true,
      cancelable: true
    });
  } else {
    evt = document.createEvent('Event');
    evt.initEvent(name, true, true);
  }

  evt.to = toEl || rootEl;
  evt.from = fromEl || rootEl;
  evt.item = targetEl || rootEl;
  evt.clone = cloneEl;
  evt.oldIndex = oldIndex;
  evt.newIndex = newIndex;
  evt.oldDraggableIndex = oldDraggableIndex;
  evt.newDraggableIndex = newDraggableIndex;
  evt.originalEvent = originalEvent;
  evt.pullMode = putSortable ? putSortable.lastPutMode : undefined;

  var allEventProperties = _objectSpread({}, extraEventProperties, PluginManager.getEventProperties(name, sortable));

  for (var option in allEventProperties) {
    evt[option] = allEventProperties[option];
  }

  if (rootEl) {
    rootEl.dispatchEvent(evt);
  }

  if (options[onName]) {
    options[onName].call(sortable, evt);
  }
}

var pluginEvent = function pluginEvent(eventName, sortable) {
  var _ref = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {},
      originalEvent = _ref.evt,
      data = _objectWithoutProperties(_ref, ["evt"]);

  PluginManager.pluginEvent.bind(Sortable)(eventName, sortable, _objectSpread({
    dragEl: dragEl,
    parentEl: parentEl,
    ghostEl: ghostEl,
    rootEl: rootEl,
    nextEl: nextEl,
    lastDownEl: lastDownEl,
    cloneEl: cloneEl,
    cloneHidden: cloneHidden,
    dragStarted: moved,
    putSortable: putSortable,
    activeSortable: Sortable.active,
    originalEvent: originalEvent,
    oldIndex: oldIndex,
    oldDraggableIndex: oldDraggableIndex,
    newIndex: newIndex,
    newDraggableIndex: newDraggableIndex,
    hideGhostForTarget: _hideGhostForTarget,
    unhideGhostForTarget: _unhideGhostForTarget,
    cloneNowHidden: function cloneNowHidden() {
      cloneHidden = true;
    },
    cloneNowShown: function cloneNowShown() {
      cloneHidden = false;
    },
    dispatchSortableEvent: function dispatchSortableEvent(name) {
      _dispatchEvent({
        sortable: sortable,
        name: name,
        originalEvent: originalEvent
      });
    }
  }, data));
};

function _dispatchEvent(info) {
  dispatchEvent$1(_objectSpread({
    putSortable: putSortable,
    cloneEl: cloneEl,
    targetEl: dragEl,
    rootEl: rootEl,
    oldIndex: oldIndex,
    oldDraggableIndex: oldDraggableIndex,
    newIndex: newIndex,
    newDraggableIndex: newDraggableIndex
  }, info));
}

var dragEl,
    parentEl,
    ghostEl,
    rootEl,
    nextEl,
    lastDownEl,
    cloneEl,
    cloneHidden,
    oldIndex,
    newIndex,
    oldDraggableIndex,
    newDraggableIndex,
    activeGroup,
    putSortable,
    awaitingDragStarted = false,
    ignoreNextClick = false,
    sortables = [],
    tapEvt,
    touchEvt,
    lastDx,
    lastDy,
    tapDistanceLeft,
    tapDistanceTop,
    moved,
    lastTarget,
    lastDirection,
    pastFirstInvertThresh = false,
    isCircumstantialInvert = false,
    targetMoveDistance,
    // For positioning ghost absolutely
ghostRelativeParent,
    ghostRelativeParentInitialScroll = [],
    // (left, top)
_silent = false,
    savedInputChecked = [];
/** @const */

var documentExists = typeof document !== 'undefined',
    PositionGhostAbsolutely = IOS,
    CSSFloatProperty = Edge || IE11OrLess ? 'cssFloat' : 'float',
    // This will not pass for IE9, because IE9 DnD only works on anchors
supportDraggable = documentExists && !ChromeForAndroid && !IOS && 'draggable' in document.createElement('div'),
    supportCssPointerEvents = function () {
  if (!documentExists) return; // false when <= IE11

  if (IE11OrLess) {
    return false;
  }

  var el = document.createElement('x');
  el.style.cssText = 'pointer-events:auto';
  return el.style.pointerEvents === 'auto';
}(),
    _detectDirection = function _detectDirection(el, options) {
  var elCSS = css(el),
      elWidth = parseInt(elCSS.width) - parseInt(elCSS.paddingLeft) - parseInt(elCSS.paddingRight) - parseInt(elCSS.borderLeftWidth) - parseInt(elCSS.borderRightWidth),
      child1 = getChild(el, 0, options),
      child2 = getChild(el, 1, options),
      firstChildCSS = child1 && css(child1),
      secondChildCSS = child2 && css(child2),
      firstChildWidth = firstChildCSS && parseInt(firstChildCSS.marginLeft) + parseInt(firstChildCSS.marginRight) + getRect(child1).width,
      secondChildWidth = secondChildCSS && parseInt(secondChildCSS.marginLeft) + parseInt(secondChildCSS.marginRight) + getRect(child2).width;

  if (elCSS.display === 'flex') {
    return elCSS.flexDirection === 'column' || elCSS.flexDirection === 'column-reverse' ? 'vertical' : 'horizontal';
  }

  if (elCSS.display === 'grid') {
    return elCSS.gridTemplateColumns.split(' ').length <= 1 ? 'vertical' : 'horizontal';
  }

  if (child1 && firstChildCSS["float"] && firstChildCSS["float"] !== 'none') {
    var touchingSideChild2 = firstChildCSS["float"] === 'left' ? 'left' : 'right';
    return child2 && (secondChildCSS.clear === 'both' || secondChildCSS.clear === touchingSideChild2) ? 'vertical' : 'horizontal';
  }

  return child1 && (firstChildCSS.display === 'block' || firstChildCSS.display === 'flex' || firstChildCSS.display === 'table' || firstChildCSS.display === 'grid' || firstChildWidth >= elWidth && elCSS[CSSFloatProperty] === 'none' || child2 && elCSS[CSSFloatProperty] === 'none' && firstChildWidth + secondChildWidth > elWidth) ? 'vertical' : 'horizontal';
},
    _dragElInRowColumn = function _dragElInRowColumn(dragRect, targetRect, vertical) {
  var dragElS1Opp = vertical ? dragRect.left : dragRect.top,
      dragElS2Opp = vertical ? dragRect.right : dragRect.bottom,
      dragElOppLength = vertical ? dragRect.width : dragRect.height,
      targetS1Opp = vertical ? targetRect.left : targetRect.top,
      targetS2Opp = vertical ? targetRect.right : targetRect.bottom,
      targetOppLength = vertical ? targetRect.width : targetRect.height;
  return dragElS1Opp === targetS1Opp || dragElS2Opp === targetS2Opp || dragElS1Opp + dragElOppLength / 2 === targetS1Opp + targetOppLength / 2;
},

/**
 * Detects first nearest empty sortable to X and Y position using emptyInsertThreshold.
 * @param  {Number} x      X position
 * @param  {Number} y      Y position
 * @return {HTMLElement}   Element of the first found nearest Sortable
 */
_detectNearestEmptySortable = function _detectNearestEmptySortable(x, y) {
  var ret;
  sortables.some(function (sortable) {
    if (lastChild(sortable)) return;
    var rect = getRect(sortable),
        threshold = sortable[expando].options.emptyInsertThreshold,
        insideHorizontally = x >= rect.left - threshold && x <= rect.right + threshold,
        insideVertically = y >= rect.top - threshold && y <= rect.bottom + threshold;

    if (threshold && insideHorizontally && insideVertically) {
      return ret = sortable;
    }
  });
  return ret;
},
    _prepareGroup = function _prepareGroup(options) {
  function toFn(value, pull) {
    return function (to, from, dragEl, evt) {
      var sameGroup = to.options.group.name && from.options.group.name && to.options.group.name === from.options.group.name;

      if (value == null && (pull || sameGroup)) {
        // Default pull value
        // Default pull and put value if same group
        return true;
      } else if (value == null || value === false) {
        return false;
      } else if (pull && value === 'clone') {
        return value;
      } else if (typeof value === 'function') {
        return toFn(value(to, from, dragEl, evt), pull)(to, from, dragEl, evt);
      } else {
        var otherGroup = (pull ? to : from).options.group.name;
        return value === true || typeof value === 'string' && value === otherGroup || value.join && value.indexOf(otherGroup) > -1;
      }
    };
  }

  var group = {};
  var originalGroup = options.group;

  if (!originalGroup || _typeof(originalGroup) != 'object') {
    originalGroup = {
      name: originalGroup
    };
  }

  group.name = originalGroup.name;
  group.checkPull = toFn(originalGroup.pull, true);
  group.checkPut = toFn(originalGroup.put);
  group.revertClone = originalGroup.revertClone;
  options.group = group;
},
    _hideGhostForTarget = function _hideGhostForTarget() {
  if (!supportCssPointerEvents && ghostEl) {
    css(ghostEl, 'display', 'none');
  }
},
    _unhideGhostForTarget = function _unhideGhostForTarget() {
  if (!supportCssPointerEvents && ghostEl) {
    css(ghostEl, 'display', '');
  }
}; // #1184 fix - Prevent click event on fallback if dragged but item not changed position


if (documentExists) {
  document.addEventListener('click', function (evt) {
    if (ignoreNextClick) {
      evt.preventDefault();
      evt.stopPropagation && evt.stopPropagation();
      evt.stopImmediatePropagation && evt.stopImmediatePropagation();
      ignoreNextClick = false;
      return false;
    }
  }, true);
}

var nearestEmptyInsertDetectEvent = function nearestEmptyInsertDetectEvent(evt) {
  if (dragEl) {
    evt = evt.touches ? evt.touches[0] : evt;

    var nearest = _detectNearestEmptySortable(evt.clientX, evt.clientY);

    if (nearest) {
      // Create imitation event
      var event = {};

      for (var i in evt) {
        if (evt.hasOwnProperty(i)) {
          event[i] = evt[i];
        }
      }

      event.target = event.rootEl = nearest;
      event.preventDefault = void 0;
      event.stopPropagation = void 0;

      nearest[expando]._onDragOver(event);
    }
  }
};

var _checkOutsideTargetEl = function _checkOutsideTargetEl(evt) {
  if (dragEl) {
    dragEl.parentNode[expando]._isOutsideThisEl(evt.target);
  }
};
/**
 * @class  Sortable
 * @param  {HTMLElement}  el
 * @param  {Object}       [options]
 */


function Sortable(el, options) {
  if (!(el && el.nodeType && el.nodeType === 1)) {
    throw "Sortable: `el` must be an HTMLElement, not ".concat({}.toString.call(el));
  }

  this.el = el; // root element

  this.options = options = _extends({}, options); // Export instance

  el[expando] = this;
  var defaults = {
    group: null,
    sort: true,
    disabled: false,
    store: null,
    handle: null,
    draggable: /^[uo]l$/i.test(el.nodeName) ? '>li' : '>*',
    swapThreshold: 1,
    // percentage; 0 <= x <= 1
    invertSwap: false,
    // invert always
    invertedSwapThreshold: null,
    // will be set to same as swapThreshold if default
    removeCloneOnHide: true,
    direction: function direction() {
      return _detectDirection(el, this.options);
    },
    ghostClass: 'sortable-ghost',
    chosenClass: 'sortable-chosen',
    dragClass: 'sortable-drag',
    ignore: 'a, img',
    filter: null,
    preventOnFilter: true,
    animation: 0,
    easing: null,
    setData: function setData(dataTransfer, dragEl) {
      dataTransfer.setData('Text', dragEl.textContent);
    },
    dropBubble: false,
    dragoverBubble: false,
    dataIdAttr: 'data-id',
    delay: 0,
    delayOnTouchOnly: false,
    touchStartThreshold: (Number.parseInt ? Number : window).parseInt(window.devicePixelRatio, 10) || 1,
    forceFallback: false,
    fallbackClass: 'sortable-fallback',
    fallbackOnBody: false,
    fallbackTolerance: 0,
    fallbackOffset: {
      x: 0,
      y: 0
    },
    supportPointer: Sortable.supportPointer !== false && 'PointerEvent' in window && !Safari,
    emptyInsertThreshold: 5
  };
  PluginManager.initializePlugins(this, el, defaults); // Set default options

  for (var name in defaults) {
    !(name in options) && (options[name] = defaults[name]);
  }

  _prepareGroup(options); // Bind all private methods


  for (var fn in this) {
    if (fn.charAt(0) === '_' && typeof this[fn] === 'function') {
      this[fn] = this[fn].bind(this);
    }
  } // Setup drag mode


  this.nativeDraggable = options.forceFallback ? false : supportDraggable;

  if (this.nativeDraggable) {
    // Touch start threshold cannot be greater than the native dragstart threshold
    this.options.touchStartThreshold = 1;
  } // Bind events


  if (options.supportPointer) {
    on(el, 'pointerdown', this._onTapStart);
  } else {
    on(el, 'mousedown', this._onTapStart);
    on(el, 'touchstart', this._onTapStart);
  }

  if (this.nativeDraggable) {
    on(el, 'dragover', this);
    on(el, 'dragenter', this);
  }

  sortables.push(this.el); // Restore sorting

  options.store && options.store.get && this.sort(options.store.get(this) || []); // Add animation state manager

  _extends(this, AnimationStateManager());
}

Sortable.prototype =
/** @lends Sortable.prototype */
{
  constructor: Sortable,
  _isOutsideThisEl: function _isOutsideThisEl(target) {
    if (!this.el.contains(target) && target !== this.el) {
      lastTarget = null;
    }
  },
  _getDirection: function _getDirection(evt, target) {
    return typeof this.options.direction === 'function' ? this.options.direction.call(this, evt, target, dragEl) : this.options.direction;
  },
  _onTapStart: function _onTapStart(
  /** Event|TouchEvent */
  evt) {
    if (!evt.cancelable) return;

    var _this = this,
        el = this.el,
        options = this.options,
        preventOnFilter = options.preventOnFilter,
        type = evt.type,
        touch = evt.touches && evt.touches[0] || evt.pointerType && evt.pointerType === 'touch' && evt,
        target = (touch || evt).target,
        originalTarget = evt.target.shadowRoot && (evt.path && evt.path[0] || evt.composedPath && evt.composedPath()[0]) || target,
        filter = options.filter;

    _saveInputCheckedState(el); // Don't trigger start event when an element is been dragged, otherwise the evt.oldindex always wrong when set option.group.


    if (dragEl) {
      return;
    }

    if (/mousedown|pointerdown/.test(type) && evt.button !== 0 || options.disabled) {
      return; // only left button and enabled
    } // cancel dnd if original target is content editable


    if (originalTarget.isContentEditable) {
      return;
    } // Safari ignores further event handling after mousedown


    if (!this.nativeDraggable && Safari && target && target.tagName.toUpperCase() === 'SELECT') {
      return;
    }

    target = closest(target, options.draggable, el, false);

    if (target && target.animated) {
      return;
    }

    if (lastDownEl === target) {
      // Ignoring duplicate `down`
      return;
    } // Get the index of the dragged element within its parent


    oldIndex = index$1(target);
    oldDraggableIndex = index$1(target, options.draggable); // Check filter

    if (typeof filter === 'function') {
      if (filter.call(this, evt, target, this)) {
        _dispatchEvent({
          sortable: _this,
          rootEl: originalTarget,
          name: 'filter',
          targetEl: target,
          toEl: el,
          fromEl: el
        });

        pluginEvent('filter', _this, {
          evt: evt
        });
        preventOnFilter && evt.cancelable && evt.preventDefault();
        return; // cancel dnd
      }
    } else if (filter) {
      filter = filter.split(',').some(function (criteria) {
        criteria = closest(originalTarget, criteria.trim(), el, false);

        if (criteria) {
          _dispatchEvent({
            sortable: _this,
            rootEl: criteria,
            name: 'filter',
            targetEl: target,
            fromEl: el,
            toEl: el
          });

          pluginEvent('filter', _this, {
            evt: evt
          });
          return true;
        }
      });

      if (filter) {
        preventOnFilter && evt.cancelable && evt.preventDefault();
        return; // cancel dnd
      }
    }

    if (options.handle && !closest(originalTarget, options.handle, el, false)) {
      return;
    } // Prepare `dragstart`


    this._prepareDragStart(evt, touch, target);
  },
  _prepareDragStart: function _prepareDragStart(
  /** Event */
  evt,
  /** Touch */
  touch,
  /** HTMLElement */
  target) {
    var _this = this,
        el = _this.el,
        options = _this.options,
        ownerDocument = el.ownerDocument,
        dragStartFn;

    if (target && !dragEl && target.parentNode === el) {
      var dragRect = getRect(target);
      rootEl = el;
      dragEl = target;
      parentEl = dragEl.parentNode;
      nextEl = dragEl.nextSibling;
      lastDownEl = target;
      activeGroup = options.group;
      Sortable.dragged = dragEl;
      tapEvt = {
        target: dragEl,
        clientX: (touch || evt).clientX,
        clientY: (touch || evt).clientY
      };
      tapDistanceLeft = tapEvt.clientX - dragRect.left;
      tapDistanceTop = tapEvt.clientY - dragRect.top;
      this._lastX = (touch || evt).clientX;
      this._lastY = (touch || evt).clientY;
      dragEl.style['will-change'] = 'all';

      dragStartFn = function dragStartFn() {
        pluginEvent('delayEnded', _this, {
          evt: evt
        });

        if (Sortable.eventCanceled) {
          _this._onDrop();

          return;
        } // Delayed drag has been triggered
        // we can re-enable the events: touchmove/mousemove


        _this._disableDelayedDragEvents();

        if (!FireFox && _this.nativeDraggable) {
          dragEl.draggable = true;
        } // Bind the events: dragstart/dragend


        _this._triggerDragStart(evt, touch); // Drag start event


        _dispatchEvent({
          sortable: _this,
          name: 'choose',
          originalEvent: evt
        }); // Chosen item


        toggleClass(dragEl, options.chosenClass, true);
      }; // Disable "draggable"


      options.ignore.split(',').forEach(function (criteria) {
        find(dragEl, criteria.trim(), _disableDraggable);
      });
      on(ownerDocument, 'dragover', nearestEmptyInsertDetectEvent);
      on(ownerDocument, 'mousemove', nearestEmptyInsertDetectEvent);
      on(ownerDocument, 'touchmove', nearestEmptyInsertDetectEvent);
      on(ownerDocument, 'mouseup', _this._onDrop);
      on(ownerDocument, 'touchend', _this._onDrop);
      on(ownerDocument, 'touchcancel', _this._onDrop); // Make dragEl draggable (must be before delay for FireFox)

      if (FireFox && this.nativeDraggable) {
        this.options.touchStartThreshold = 4;
        dragEl.draggable = true;
      }

      pluginEvent('delayStart', this, {
        evt: evt
      }); // Delay is impossible for native DnD in Edge or IE

      if (options.delay && (!options.delayOnTouchOnly || touch) && (!this.nativeDraggable || !(Edge || IE11OrLess))) {
        if (Sortable.eventCanceled) {
          this._onDrop();

          return;
        } // If the user moves the pointer or let go the click or touch
        // before the delay has been reached:
        // disable the delayed drag


        on(ownerDocument, 'mouseup', _this._disableDelayedDrag);
        on(ownerDocument, 'touchend', _this._disableDelayedDrag);
        on(ownerDocument, 'touchcancel', _this._disableDelayedDrag);
        on(ownerDocument, 'mousemove', _this._delayedDragTouchMoveHandler);
        on(ownerDocument, 'touchmove', _this._delayedDragTouchMoveHandler);
        options.supportPointer && on(ownerDocument, 'pointermove', _this._delayedDragTouchMoveHandler);
        _this._dragStartTimer = setTimeout(dragStartFn, options.delay);
      } else {
        dragStartFn();
      }
    }
  },
  _delayedDragTouchMoveHandler: function _delayedDragTouchMoveHandler(
  /** TouchEvent|PointerEvent **/
  e) {
    var touch = e.touches ? e.touches[0] : e;

    if (Math.max(Math.abs(touch.clientX - this._lastX), Math.abs(touch.clientY - this._lastY)) >= Math.floor(this.options.touchStartThreshold / (this.nativeDraggable && window.devicePixelRatio || 1))) {
      this._disableDelayedDrag();
    }
  },
  _disableDelayedDrag: function _disableDelayedDrag() {
    dragEl && _disableDraggable(dragEl);
    clearTimeout(this._dragStartTimer);

    this._disableDelayedDragEvents();
  },
  _disableDelayedDragEvents: function _disableDelayedDragEvents() {
    var ownerDocument = this.el.ownerDocument;
    off(ownerDocument, 'mouseup', this._disableDelayedDrag);
    off(ownerDocument, 'touchend', this._disableDelayedDrag);
    off(ownerDocument, 'touchcancel', this._disableDelayedDrag);
    off(ownerDocument, 'mousemove', this._delayedDragTouchMoveHandler);
    off(ownerDocument, 'touchmove', this._delayedDragTouchMoveHandler);
    off(ownerDocument, 'pointermove', this._delayedDragTouchMoveHandler);
  },
  _triggerDragStart: function _triggerDragStart(
  /** Event */
  evt,
  /** Touch */
  touch) {
    touch = touch || evt.pointerType == 'touch' && evt;

    if (!this.nativeDraggable || touch) {
      if (this.options.supportPointer) {
        on(document, 'pointermove', this._onTouchMove);
      } else if (touch) {
        on(document, 'touchmove', this._onTouchMove);
      } else {
        on(document, 'mousemove', this._onTouchMove);
      }
    } else {
      on(dragEl, 'dragend', this);
      on(rootEl, 'dragstart', this._onDragStart);
    }

    try {
      if (document.selection) {
        // Timeout neccessary for IE9
        _nextTick(function () {
          document.selection.empty();
        });
      } else {
        window.getSelection().removeAllRanges();
      }
    } catch (err) {}
  },
  _dragStarted: function _dragStarted(fallback, evt) {
    awaitingDragStarted = false;

    if (rootEl && dragEl) {
      pluginEvent('dragStarted', this, {
        evt: evt
      });

      if (this.nativeDraggable) {
        on(document, 'dragover', _checkOutsideTargetEl);
      }

      var options = this.options; // Apply effect

      !fallback && toggleClass(dragEl, options.dragClass, false);
      toggleClass(dragEl, options.ghostClass, true);
      Sortable.active = this;
      fallback && this._appendGhost(); // Drag start event

      _dispatchEvent({
        sortable: this,
        name: 'start',
        originalEvent: evt
      });
    } else {
      this._nulling();
    }
  },
  _emulateDragOver: function _emulateDragOver() {
    if (touchEvt) {
      this._lastX = touchEvt.clientX;
      this._lastY = touchEvt.clientY;

      _hideGhostForTarget();

      var target = document.elementFromPoint(touchEvt.clientX, touchEvt.clientY);
      var parent = target;

      while (target && target.shadowRoot) {
        target = target.shadowRoot.elementFromPoint(touchEvt.clientX, touchEvt.clientY);
        if (target === parent) break;
        parent = target;
      }

      dragEl.parentNode[expando]._isOutsideThisEl(target);

      if (parent) {
        do {
          if (parent[expando]) {
            var inserted = void 0;
            inserted = parent[expando]._onDragOver({
              clientX: touchEvt.clientX,
              clientY: touchEvt.clientY,
              target: target,
              rootEl: parent
            });

            if (inserted && !this.options.dragoverBubble) {
              break;
            }
          }

          target = parent; // store last element
        }
        /* jshint boss:true */
        while (parent = parent.parentNode);
      }

      _unhideGhostForTarget();
    }
  },
  _onTouchMove: function _onTouchMove(
  /**TouchEvent*/
  evt) {
    if (tapEvt) {
      var options = this.options,
          fallbackTolerance = options.fallbackTolerance,
          fallbackOffset = options.fallbackOffset,
          touch = evt.touches ? evt.touches[0] : evt,
          ghostMatrix = ghostEl && matrix(ghostEl, true),
          scaleX = ghostEl && ghostMatrix && ghostMatrix.a,
          scaleY = ghostEl && ghostMatrix && ghostMatrix.d,
          relativeScrollOffset = PositionGhostAbsolutely && ghostRelativeParent && getRelativeScrollOffset(ghostRelativeParent),
          dx = (touch.clientX - tapEvt.clientX + fallbackOffset.x) / (scaleX || 1) + (relativeScrollOffset ? relativeScrollOffset[0] - ghostRelativeParentInitialScroll[0] : 0) / (scaleX || 1),
          dy = (touch.clientY - tapEvt.clientY + fallbackOffset.y) / (scaleY || 1) + (relativeScrollOffset ? relativeScrollOffset[1] - ghostRelativeParentInitialScroll[1] : 0) / (scaleY || 1); // only set the status to dragging, when we are actually dragging

      if (!Sortable.active && !awaitingDragStarted) {
        if (fallbackTolerance && Math.max(Math.abs(touch.clientX - this._lastX), Math.abs(touch.clientY - this._lastY)) < fallbackTolerance) {
          return;
        }

        this._onDragStart(evt, true);
      }

      if (ghostEl) {
        if (ghostMatrix) {
          ghostMatrix.e += dx - (lastDx || 0);
          ghostMatrix.f += dy - (lastDy || 0);
        } else {
          ghostMatrix = {
            a: 1,
            b: 0,
            c: 0,
            d: 1,
            e: dx,
            f: dy
          };
        }

        var cssMatrix = "matrix(".concat(ghostMatrix.a, ",").concat(ghostMatrix.b, ",").concat(ghostMatrix.c, ",").concat(ghostMatrix.d, ",").concat(ghostMatrix.e, ",").concat(ghostMatrix.f, ")");
        css(ghostEl, 'webkitTransform', cssMatrix);
        css(ghostEl, 'mozTransform', cssMatrix);
        css(ghostEl, 'msTransform', cssMatrix);
        css(ghostEl, 'transform', cssMatrix);
        lastDx = dx;
        lastDy = dy;
        touchEvt = touch;
      }

      evt.cancelable && evt.preventDefault();
    }
  },
  _appendGhost: function _appendGhost() {
    // Bug if using scale(): https://stackoverflow.com/questions/2637058
    // Not being adjusted for
    if (!ghostEl) {
      var container = this.options.fallbackOnBody ? document.body : rootEl,
          rect = getRect(dragEl, true, PositionGhostAbsolutely, true, container),
          options = this.options; // Position absolutely

      if (PositionGhostAbsolutely) {
        // Get relatively positioned parent
        ghostRelativeParent = container;

        while (css(ghostRelativeParent, 'position') === 'static' && css(ghostRelativeParent, 'transform') === 'none' && ghostRelativeParent !== document) {
          ghostRelativeParent = ghostRelativeParent.parentNode;
        }

        if (ghostRelativeParent !== document.body && ghostRelativeParent !== document.documentElement) {
          if (ghostRelativeParent === document) ghostRelativeParent = getWindowScrollingElement();
          rect.top += ghostRelativeParent.scrollTop;
          rect.left += ghostRelativeParent.scrollLeft;
        } else {
          ghostRelativeParent = getWindowScrollingElement();
        }

        ghostRelativeParentInitialScroll = getRelativeScrollOffset(ghostRelativeParent);
      }

      ghostEl = dragEl.cloneNode(true);
      toggleClass(ghostEl, options.ghostClass, false);
      toggleClass(ghostEl, options.fallbackClass, true);
      toggleClass(ghostEl, options.dragClass, true);
      css(ghostEl, 'transition', '');
      css(ghostEl, 'transform', '');
      css(ghostEl, 'box-sizing', 'border-box');
      css(ghostEl, 'margin', 0);
      css(ghostEl, 'top', rect.top);
      css(ghostEl, 'left', rect.left);
      css(ghostEl, 'width', rect.width);
      css(ghostEl, 'height', rect.height);
      css(ghostEl, 'opacity', '0.8');
      css(ghostEl, 'position', PositionGhostAbsolutely ? 'absolute' : 'fixed');
      css(ghostEl, 'zIndex', '100000');
      css(ghostEl, 'pointerEvents', 'none');
      Sortable.ghost = ghostEl;
      container.appendChild(ghostEl); // Set transform-origin

      css(ghostEl, 'transform-origin', tapDistanceLeft / parseInt(ghostEl.style.width) * 100 + '% ' + tapDistanceTop / parseInt(ghostEl.style.height) * 100 + '%');
    }
  },
  _onDragStart: function _onDragStart(
  /**Event*/
  evt,
  /**boolean*/
  fallback) {
    var _this = this;

    var dataTransfer = evt.dataTransfer;
    var options = _this.options;
    pluginEvent('dragStart', this, {
      evt: evt
    });

    if (Sortable.eventCanceled) {
      this._onDrop();

      return;
    }

    pluginEvent('setupClone', this);

    if (!Sortable.eventCanceled) {
      cloneEl = clone(dragEl);
      cloneEl.draggable = false;
      cloneEl.style['will-change'] = '';

      this._hideClone();

      toggleClass(cloneEl, this.options.chosenClass, false);
      Sortable.clone = cloneEl;
    } // #1143: IFrame support workaround


    _this.cloneId = _nextTick(function () {
      pluginEvent('clone', _this);
      if (Sortable.eventCanceled) return;

      if (!_this.options.removeCloneOnHide) {
        rootEl.insertBefore(cloneEl, dragEl);
      }

      _this._hideClone();

      _dispatchEvent({
        sortable: _this,
        name: 'clone'
      });
    });
    !fallback && toggleClass(dragEl, options.dragClass, true); // Set proper drop events

    if (fallback) {
      ignoreNextClick = true;
      _this._loopId = setInterval(_this._emulateDragOver, 50);
    } else {
      // Undo what was set in _prepareDragStart before drag started
      off(document, 'mouseup', _this._onDrop);
      off(document, 'touchend', _this._onDrop);
      off(document, 'touchcancel', _this._onDrop);

      if (dataTransfer) {
        dataTransfer.effectAllowed = 'move';
        options.setData && options.setData.call(_this, dataTransfer, dragEl);
      }

      on(document, 'drop', _this); // #1276 fix:

      css(dragEl, 'transform', 'translateZ(0)');
    }

    awaitingDragStarted = true;
    _this._dragStartId = _nextTick(_this._dragStarted.bind(_this, fallback, evt));
    on(document, 'selectstart', _this);
    moved = true;

    if (Safari) {
      css(document.body, 'user-select', 'none');
    }
  },
  // Returns true - if no further action is needed (either inserted or another condition)
  _onDragOver: function _onDragOver(
  /**Event*/
  evt) {
    var el = this.el,
        target = evt.target,
        dragRect,
        targetRect,
        revert,
        options = this.options,
        group = options.group,
        activeSortable = Sortable.active,
        isOwner = activeGroup === group,
        canSort = options.sort,
        fromSortable = putSortable || activeSortable,
        vertical,
        _this = this,
        completedFired = false;

    if (_silent) return;

    function dragOverEvent(name, extra) {
      pluginEvent(name, _this, _objectSpread({
        evt: evt,
        isOwner: isOwner,
        axis: vertical ? 'vertical' : 'horizontal',
        revert: revert,
        dragRect: dragRect,
        targetRect: targetRect,
        canSort: canSort,
        fromSortable: fromSortable,
        target: target,
        completed: completed,
        onMove: function onMove(target, after) {
          return _onMove(rootEl, el, dragEl, dragRect, target, getRect(target), evt, after);
        },
        changed: changed
      }, extra));
    } // Capture animation state


    function capture() {
      dragOverEvent('dragOverAnimationCapture');

      _this.captureAnimationState();

      if (_this !== fromSortable) {
        fromSortable.captureAnimationState();
      }
    } // Return invocation when dragEl is inserted (or completed)


    function completed(insertion) {
      dragOverEvent('dragOverCompleted', {
        insertion: insertion
      });

      if (insertion) {
        // Clones must be hidden before folding animation to capture dragRectAbsolute properly
        if (isOwner) {
          activeSortable._hideClone();
        } else {
          activeSortable._showClone(_this);
        }

        if (_this !== fromSortable) {
          // Set ghost class to new sortable's ghost class
          toggleClass(dragEl, putSortable ? putSortable.options.ghostClass : activeSortable.options.ghostClass, false);
          toggleClass(dragEl, options.ghostClass, true);
        }

        if (putSortable !== _this && _this !== Sortable.active) {
          putSortable = _this;
        } else if (_this === Sortable.active && putSortable) {
          putSortable = null;
        } // Animation


        if (fromSortable === _this) {
          _this._ignoreWhileAnimating = target;
        }

        _this.animateAll(function () {
          dragOverEvent('dragOverAnimationComplete');
          _this._ignoreWhileAnimating = null;
        });

        if (_this !== fromSortable) {
          fromSortable.animateAll();
          fromSortable._ignoreWhileAnimating = null;
        }
      } // Null lastTarget if it is not inside a previously swapped element


      if (target === dragEl && !dragEl.animated || target === el && !target.animated) {
        lastTarget = null;
      } // no bubbling and not fallback


      if (!options.dragoverBubble && !evt.rootEl && target !== document) {
        dragEl.parentNode[expando]._isOutsideThisEl(evt.target); // Do not detect for empty insert if already inserted


        !insertion && nearestEmptyInsertDetectEvent(evt);
      }

      !options.dragoverBubble && evt.stopPropagation && evt.stopPropagation();
      return completedFired = true;
    } // Call when dragEl has been inserted


    function changed() {
      newIndex = index$1(dragEl);
      newDraggableIndex = index$1(dragEl, options.draggable);

      _dispatchEvent({
        sortable: _this,
        name: 'change',
        toEl: el,
        newIndex: newIndex,
        newDraggableIndex: newDraggableIndex,
        originalEvent: evt
      });
    }

    if (evt.preventDefault !== void 0) {
      evt.cancelable && evt.preventDefault();
    }

    target = closest(target, options.draggable, el, true);
    dragOverEvent('dragOver');
    if (Sortable.eventCanceled) return completedFired;

    if (dragEl.contains(evt.target) || target.animated && target.animatingX && target.animatingY || _this._ignoreWhileAnimating === target) {
      return completed(false);
    }

    ignoreNextClick = false;

    if (activeSortable && !options.disabled && (isOwner ? canSort || (revert = !rootEl.contains(dragEl)) // Reverting item into the original list
    : putSortable === this || (this.lastPutMode = activeGroup.checkPull(this, activeSortable, dragEl, evt)) && group.checkPut(this, activeSortable, dragEl, evt))) {
      vertical = this._getDirection(evt, target) === 'vertical';
      dragRect = getRect(dragEl);
      dragOverEvent('dragOverValid');
      if (Sortable.eventCanceled) return completedFired;

      if (revert) {
        parentEl = rootEl; // actualization

        capture();

        this._hideClone();

        dragOverEvent('revert');

        if (!Sortable.eventCanceled) {
          if (nextEl) {
            rootEl.insertBefore(dragEl, nextEl);
          } else {
            rootEl.appendChild(dragEl);
          }
        }

        return completed(true);
      }

      var elLastChild = lastChild(el, options.draggable);

      if (!elLastChild || _ghostIsLast(evt, vertical, this) && !elLastChild.animated) {
        // If already at end of list: Do not insert
        if (elLastChild === dragEl) {
          return completed(false);
        } // assign target only if condition is true


        if (elLastChild && el === evt.target) {
          target = elLastChild;
        }

        if (target) {
          targetRect = getRect(target);
        }

        if (_onMove(rootEl, el, dragEl, dragRect, target, targetRect, evt, !!target) !== false) {
          capture();
          el.appendChild(dragEl);
          parentEl = el; // actualization

          changed();
          return completed(true);
        }
      } else if (target.parentNode === el) {
        targetRect = getRect(target);
        var direction = 0,
            targetBeforeFirstSwap,
            differentLevel = dragEl.parentNode !== el,
            differentRowCol = !_dragElInRowColumn(dragEl.animated && dragEl.toRect || dragRect, target.animated && target.toRect || targetRect, vertical),
            side1 = vertical ? 'top' : 'left',
            scrolledPastTop = isScrolledPast(target, 'top', 'top') || isScrolledPast(dragEl, 'top', 'top'),
            scrollBefore = scrolledPastTop ? scrolledPastTop.scrollTop : void 0;

        if (lastTarget !== target) {
          targetBeforeFirstSwap = targetRect[side1];
          pastFirstInvertThresh = false;
          isCircumstantialInvert = !differentRowCol && options.invertSwap || differentLevel;
        }

        direction = _getSwapDirection(evt, target, targetRect, vertical, differentRowCol ? 1 : options.swapThreshold, options.invertedSwapThreshold == null ? options.swapThreshold : options.invertedSwapThreshold, isCircumstantialInvert, lastTarget === target);
        var sibling;

        if (direction !== 0) {
          // Check if target is beside dragEl in respective direction (ignoring hidden elements)
          var dragIndex = index$1(dragEl);

          do {
            dragIndex -= direction;
            sibling = parentEl.children[dragIndex];
          } while (sibling && (css(sibling, 'display') === 'none' || sibling === ghostEl));
        } // If dragEl is already beside target: Do not insert


        if (direction === 0 || sibling === target) {
          return completed(false);
        }

        lastTarget = target;
        lastDirection = direction;
        var nextSibling = target.nextElementSibling,
            after = false;
        after = direction === 1;

        var moveVector = _onMove(rootEl, el, dragEl, dragRect, target, targetRect, evt, after);

        if (moveVector !== false) {
          if (moveVector === 1 || moveVector === -1) {
            after = moveVector === 1;
          }

          _silent = true;
          setTimeout(_unsilent, 30);
          capture();

          if (after && !nextSibling) {
            el.appendChild(dragEl);
          } else {
            target.parentNode.insertBefore(dragEl, after ? nextSibling : target);
          } // Undo chrome's scroll adjustment (has no effect on other browsers)


          if (scrolledPastTop) {
            scrollBy(scrolledPastTop, 0, scrollBefore - scrolledPastTop.scrollTop);
          }

          parentEl = dragEl.parentNode; // actualization
          // must be done before animation

          if (targetBeforeFirstSwap !== undefined && !isCircumstantialInvert) {
            targetMoveDistance = Math.abs(targetBeforeFirstSwap - getRect(target)[side1]);
          }

          changed();
          return completed(true);
        }
      }

      if (el.contains(dragEl)) {
        return completed(false);
      }
    }

    return false;
  },
  _ignoreWhileAnimating: null,
  _offMoveEvents: function _offMoveEvents() {
    off(document, 'mousemove', this._onTouchMove);
    off(document, 'touchmove', this._onTouchMove);
    off(document, 'pointermove', this._onTouchMove);
    off(document, 'dragover', nearestEmptyInsertDetectEvent);
    off(document, 'mousemove', nearestEmptyInsertDetectEvent);
    off(document, 'touchmove', nearestEmptyInsertDetectEvent);
  },
  _offUpEvents: function _offUpEvents() {
    var ownerDocument = this.el.ownerDocument;
    off(ownerDocument, 'mouseup', this._onDrop);
    off(ownerDocument, 'touchend', this._onDrop);
    off(ownerDocument, 'pointerup', this._onDrop);
    off(ownerDocument, 'touchcancel', this._onDrop);
    off(document, 'selectstart', this);
  },
  _onDrop: function _onDrop(
  /**Event*/
  evt) {
    var el = this.el,
        options = this.options; // Get the index of the dragged element within its parent

    newIndex = index$1(dragEl);
    newDraggableIndex = index$1(dragEl, options.draggable);
    pluginEvent('drop', this, {
      evt: evt
    });
    parentEl = dragEl && dragEl.parentNode; // Get again after plugin event

    newIndex = index$1(dragEl);
    newDraggableIndex = index$1(dragEl, options.draggable);

    if (Sortable.eventCanceled) {
      this._nulling();

      return;
    }

    awaitingDragStarted = false;
    isCircumstantialInvert = false;
    pastFirstInvertThresh = false;
    clearInterval(this._loopId);
    clearTimeout(this._dragStartTimer);

    _cancelNextTick(this.cloneId);

    _cancelNextTick(this._dragStartId); // Unbind events


    if (this.nativeDraggable) {
      off(document, 'drop', this);
      off(el, 'dragstart', this._onDragStart);
    }

    this._offMoveEvents();

    this._offUpEvents();

    if (Safari) {
      css(document.body, 'user-select', '');
    }

    css(dragEl, 'transform', '');

    if (evt) {
      if (moved) {
        evt.cancelable && evt.preventDefault();
        !options.dropBubble && evt.stopPropagation();
      }

      ghostEl && ghostEl.parentNode && ghostEl.parentNode.removeChild(ghostEl);

      if (rootEl === parentEl || putSortable && putSortable.lastPutMode !== 'clone') {
        // Remove clone(s)
        cloneEl && cloneEl.parentNode && cloneEl.parentNode.removeChild(cloneEl);
      }

      if (dragEl) {
        if (this.nativeDraggable) {
          off(dragEl, 'dragend', this);
        }

        _disableDraggable(dragEl);

        dragEl.style['will-change'] = ''; // Remove classes
        // ghostClass is added in dragStarted

        if (moved && !awaitingDragStarted) {
          toggleClass(dragEl, putSortable ? putSortable.options.ghostClass : this.options.ghostClass, false);
        }

        toggleClass(dragEl, this.options.chosenClass, false); // Drag stop event

        _dispatchEvent({
          sortable: this,
          name: 'unchoose',
          toEl: parentEl,
          newIndex: null,
          newDraggableIndex: null,
          originalEvent: evt
        });

        if (rootEl !== parentEl) {
          if (newIndex >= 0) {
            // Add event
            _dispatchEvent({
              rootEl: parentEl,
              name: 'add',
              toEl: parentEl,
              fromEl: rootEl,
              originalEvent: evt
            }); // Remove event


            _dispatchEvent({
              sortable: this,
              name: 'remove',
              toEl: parentEl,
              originalEvent: evt
            }); // drag from one list and drop into another


            _dispatchEvent({
              rootEl: parentEl,
              name: 'sort',
              toEl: parentEl,
              fromEl: rootEl,
              originalEvent: evt
            });

            _dispatchEvent({
              sortable: this,
              name: 'sort',
              toEl: parentEl,
              originalEvent: evt
            });
          }

          putSortable && putSortable.save();
        } else {
          if (newIndex !== oldIndex) {
            if (newIndex >= 0) {
              // drag & drop within the same list
              _dispatchEvent({
                sortable: this,
                name: 'update',
                toEl: parentEl,
                originalEvent: evt
              });

              _dispatchEvent({
                sortable: this,
                name: 'sort',
                toEl: parentEl,
                originalEvent: evt
              });
            }
          }
        }

        if (Sortable.active) {
          /* jshint eqnull:true */
          if (newIndex == null || newIndex === -1) {
            newIndex = oldIndex;
            newDraggableIndex = oldDraggableIndex;
          }

          _dispatchEvent({
            sortable: this,
            name: 'end',
            toEl: parentEl,
            originalEvent: evt
          }); // Save sorting


          this.save();
        }
      }
    }

    this._nulling();
  },
  _nulling: function _nulling() {
    pluginEvent('nulling', this);
    rootEl = dragEl = parentEl = ghostEl = nextEl = cloneEl = lastDownEl = cloneHidden = tapEvt = touchEvt = moved = newIndex = newDraggableIndex = oldIndex = oldDraggableIndex = lastTarget = lastDirection = putSortable = activeGroup = Sortable.dragged = Sortable.ghost = Sortable.clone = Sortable.active = null;
    savedInputChecked.forEach(function (el) {
      el.checked = true;
    });
    savedInputChecked.length = lastDx = lastDy = 0;
  },
  handleEvent: function handleEvent(
  /**Event*/
  evt) {
    switch (evt.type) {
      case 'drop':
      case 'dragend':
        this._onDrop(evt);

        break;

      case 'dragenter':
      case 'dragover':
        if (dragEl) {
          this._onDragOver(evt);

          _globalDragOver(evt);
        }

        break;

      case 'selectstart':
        evt.preventDefault();
        break;
    }
  },

  /**
   * Serializes the item into an array of string.
   * @returns {String[]}
   */
  toArray: function toArray() {
    var order = [],
        el,
        children = this.el.children,
        i = 0,
        n = children.length,
        options = this.options;

    for (; i < n; i++) {
      el = children[i];

      if (closest(el, options.draggable, this.el, false)) {
        order.push(el.getAttribute(options.dataIdAttr) || _generateId(el));
      }
    }

    return order;
  },

  /**
   * Sorts the elements according to the array.
   * @param  {String[]}  order  order of the items
   */
  sort: function sort(order, useAnimation) {
    var items = {},
        rootEl = this.el;
    this.toArray().forEach(function (id, i) {
      var el = rootEl.children[i];

      if (closest(el, this.options.draggable, rootEl, false)) {
        items[id] = el;
      }
    }, this);
    useAnimation && this.captureAnimationState();
    order.forEach(function (id) {
      if (items[id]) {
        rootEl.removeChild(items[id]);
        rootEl.appendChild(items[id]);
      }
    });
    useAnimation && this.animateAll();
  },

  /**
   * Save the current sorting
   */
  save: function save() {
    var store = this.options.store;
    store && store.set && store.set(this);
  },

  /**
   * For each element in the set, get the first element that matches the selector by testing the element itself and traversing up through its ancestors in the DOM tree.
   * @param   {HTMLElement}  el
   * @param   {String}       [selector]  default: `options.draggable`
   * @returns {HTMLElement|null}
   */
  closest: function closest$1(el, selector) {
    return closest(el, selector || this.options.draggable, this.el, false);
  },

  /**
   * Set/get option
   * @param   {string} name
   * @param   {*}      [value]
   * @returns {*}
   */
  option: function option(name, value) {
    var options = this.options;

    if (value === void 0) {
      return options[name];
    } else {
      var modifiedValue = PluginManager.modifyOption(this, name, value);

      if (typeof modifiedValue !== 'undefined') {
        options[name] = modifiedValue;
      } else {
        options[name] = value;
      }

      if (name === 'group') {
        _prepareGroup(options);
      }
    }
  },

  /**
   * Destroy
   */
  destroy: function destroy() {
    pluginEvent('destroy', this);
    var el = this.el;
    el[expando] = null;
    off(el, 'mousedown', this._onTapStart);
    off(el, 'touchstart', this._onTapStart);
    off(el, 'pointerdown', this._onTapStart);

    if (this.nativeDraggable) {
      off(el, 'dragover', this);
      off(el, 'dragenter', this);
    } // Remove draggable attributes


    Array.prototype.forEach.call(el.querySelectorAll('[draggable]'), function (el) {
      el.removeAttribute('draggable');
    });

    this._onDrop();

    this._disableDelayedDragEvents();

    sortables.splice(sortables.indexOf(this.el), 1);
    this.el = el = null;
  },
  _hideClone: function _hideClone() {
    if (!cloneHidden) {
      pluginEvent('hideClone', this);
      if (Sortable.eventCanceled) return;
      css(cloneEl, 'display', 'none');

      if (this.options.removeCloneOnHide && cloneEl.parentNode) {
        cloneEl.parentNode.removeChild(cloneEl);
      }

      cloneHidden = true;
    }
  },
  _showClone: function _showClone(putSortable) {
    if (putSortable.lastPutMode !== 'clone') {
      this._hideClone();

      return;
    }

    if (cloneHidden) {
      pluginEvent('showClone', this);
      if (Sortable.eventCanceled) return; // show clone at dragEl or original position

      if (dragEl.parentNode == rootEl && !this.options.group.revertClone) {
        rootEl.insertBefore(cloneEl, dragEl);
      } else if (nextEl) {
        rootEl.insertBefore(cloneEl, nextEl);
      } else {
        rootEl.appendChild(cloneEl);
      }

      if (this.options.group.revertClone) {
        this.animate(dragEl, cloneEl);
      }

      css(cloneEl, 'display', '');
      cloneHidden = false;
    }
  }
};

function _globalDragOver(
/**Event*/
evt) {
  if (evt.dataTransfer) {
    evt.dataTransfer.dropEffect = 'move';
  }

  evt.cancelable && evt.preventDefault();
}

function _onMove(fromEl, toEl, dragEl, dragRect, targetEl, targetRect, originalEvent, willInsertAfter) {
  var evt,
      sortable = fromEl[expando],
      onMoveFn = sortable.options.onMove,
      retVal; // Support for new CustomEvent feature

  if (window.CustomEvent && !IE11OrLess && !Edge) {
    evt = new CustomEvent('move', {
      bubbles: true,
      cancelable: true
    });
  } else {
    evt = document.createEvent('Event');
    evt.initEvent('move', true, true);
  }

  evt.to = toEl;
  evt.from = fromEl;
  evt.dragged = dragEl;
  evt.draggedRect = dragRect;
  evt.related = targetEl || toEl;
  evt.relatedRect = targetRect || getRect(toEl);
  evt.willInsertAfter = willInsertAfter;
  evt.originalEvent = originalEvent;
  fromEl.dispatchEvent(evt);

  if (onMoveFn) {
    retVal = onMoveFn.call(sortable, evt, originalEvent);
  }

  return retVal;
}

function _disableDraggable(el) {
  el.draggable = false;
}

function _unsilent() {
  _silent = false;
}

function _ghostIsLast(evt, vertical, sortable) {
  var rect = getRect(lastChild(sortable.el, sortable.options.draggable));
  var spacer = 10;
  return vertical ? evt.clientX > rect.right + spacer || evt.clientX <= rect.right && evt.clientY > rect.bottom && evt.clientX >= rect.left : evt.clientX > rect.right && evt.clientY > rect.top || evt.clientX <= rect.right && evt.clientY > rect.bottom + spacer;
}

function _getSwapDirection(evt, target, targetRect, vertical, swapThreshold, invertedSwapThreshold, invertSwap, isLastTarget) {
  var mouseOnAxis = vertical ? evt.clientY : evt.clientX,
      targetLength = vertical ? targetRect.height : targetRect.width,
      targetS1 = vertical ? targetRect.top : targetRect.left,
      targetS2 = vertical ? targetRect.bottom : targetRect.right,
      invert = false;

  if (!invertSwap) {
    // Never invert or create dragEl shadow when target movemenet causes mouse to move past the end of regular swapThreshold
    if (isLastTarget && targetMoveDistance < targetLength * swapThreshold) {
      // multiplied only by swapThreshold because mouse will already be inside target by (1 - threshold) * targetLength / 2
      // check if past first invert threshold on side opposite of lastDirection
      if (!pastFirstInvertThresh && (lastDirection === 1 ? mouseOnAxis > targetS1 + targetLength * invertedSwapThreshold / 2 : mouseOnAxis < targetS2 - targetLength * invertedSwapThreshold / 2)) {
        // past first invert threshold, do not restrict inverted threshold to dragEl shadow
        pastFirstInvertThresh = true;
      }

      if (!pastFirstInvertThresh) {
        // dragEl shadow (target move distance shadow)
        if (lastDirection === 1 ? mouseOnAxis < targetS1 + targetMoveDistance // over dragEl shadow
        : mouseOnAxis > targetS2 - targetMoveDistance) {
          return -lastDirection;
        }
      } else {
        invert = true;
      }
    } else {
      // Regular
      if (mouseOnAxis > targetS1 + targetLength * (1 - swapThreshold) / 2 && mouseOnAxis < targetS2 - targetLength * (1 - swapThreshold) / 2) {
        return _getInsertDirection(target);
      }
    }
  }

  invert = invert || invertSwap;

  if (invert) {
    // Invert of regular
    if (mouseOnAxis < targetS1 + targetLength * invertedSwapThreshold / 2 || mouseOnAxis > targetS2 - targetLength * invertedSwapThreshold / 2) {
      return mouseOnAxis > targetS1 + targetLength / 2 ? 1 : -1;
    }
  }

  return 0;
}
/**
 * Gets the direction dragEl must be swapped relative to target in order to make it
 * seem that dragEl has been "inserted" into that element's position
 * @param  {HTMLElement} target       The target whose position dragEl is being inserted at
 * @return {Number}                   Direction dragEl must be swapped
 */


function _getInsertDirection(target) {
  if (index$1(dragEl) < index$1(target)) {
    return 1;
  } else {
    return -1;
  }
}
/**
 * Generate id
 * @param   {HTMLElement} el
 * @returns {String}
 * @private
 */


function _generateId(el) {
  var str = el.tagName + el.className + el.src + el.href + el.textContent,
      i = str.length,
      sum = 0;

  while (i--) {
    sum += str.charCodeAt(i);
  }

  return sum.toString(36);
}

function _saveInputCheckedState(root) {
  savedInputChecked.length = 0;
  var inputs = root.getElementsByTagName('input');
  var idx = inputs.length;

  while (idx--) {
    var el = inputs[idx];
    el.checked && savedInputChecked.push(el);
  }
}

function _nextTick(fn) {
  return setTimeout(fn, 0);
}

function _cancelNextTick(id) {
  return clearTimeout(id);
} // Fixed #973:


if (documentExists) {
  on(document, 'touchmove', function (evt) {
    if ((Sortable.active || awaitingDragStarted) && evt.cancelable) {
      evt.preventDefault();
    }
  });
} // Export utils


Sortable.utils = {
  on: on,
  off: off,
  css: css,
  find: find,
  is: function is(el, selector) {
    return !!closest(el, selector, el, false);
  },
  extend: extend$1,
  throttle: throttle,
  closest: closest,
  toggleClass: toggleClass,
  clone: clone,
  index: index$1,
  nextTick: _nextTick,
  cancelNextTick: _cancelNextTick,
  detectDirection: _detectDirection,
  getChild: getChild
};
/**
 * Get the Sortable instance of an element
 * @param  {HTMLElement} element The element
 * @return {Sortable|undefined}         The instance of Sortable
 */

Sortable.get = function (element) {
  return element[expando];
};
/**
 * Mount a plugin to Sortable
 * @param  {...SortablePlugin|SortablePlugin[]} plugins       Plugins being mounted
 */


Sortable.mount = function () {
  for (var _len = arguments.length, plugins = new Array(_len), _key = 0; _key < _len; _key++) {
    plugins[_key] = arguments[_key];
  }

  if (plugins[0].constructor === Array) plugins = plugins[0];
  plugins.forEach(function (plugin) {
    if (!plugin.prototype || !plugin.prototype.constructor) {
      throw "Sortable: Mounted plugin must be a constructor function, not ".concat({}.toString.call(plugin));
    }

    if (plugin.utils) Sortable.utils = _objectSpread({}, Sortable.utils, plugin.utils);
    PluginManager.mount(plugin);
  });
};
/**
 * Create sortable instance
 * @param {HTMLElement}  el
 * @param {Object}      [options]
 */


Sortable.create = function (el, options) {
  return new Sortable(el, options);
}; // Export


Sortable.version = version;
var autoScrolls = [],
    scrollEl,
    scrollRootEl,
    scrolling = false,
    lastAutoScrollX,
    lastAutoScrollY,
    touchEvt$1,
    pointerElemChangedInterval;

function AutoScrollPlugin() {
  function AutoScroll() {
    this.defaults = {
      scroll: true,
      scrollSensitivity: 30,
      scrollSpeed: 10,
      bubbleScroll: true
    }; // Bind all private methods

    for (var fn in this) {
      if (fn.charAt(0) === '_' && typeof this[fn] === 'function') {
        this[fn] = this[fn].bind(this);
      }
    }
  }

  AutoScroll.prototype = {
    dragStarted: function dragStarted(_ref) {
      var originalEvent = _ref.originalEvent;

      if (this.sortable.nativeDraggable) {
        on(document, 'dragover', this._handleAutoScroll);
      } else {
        if (this.options.supportPointer) {
          on(document, 'pointermove', this._handleFallbackAutoScroll);
        } else if (originalEvent.touches) {
          on(document, 'touchmove', this._handleFallbackAutoScroll);
        } else {
          on(document, 'mousemove', this._handleFallbackAutoScroll);
        }
      }
    },
    dragOverCompleted: function dragOverCompleted(_ref2) {
      var originalEvent = _ref2.originalEvent; // For when bubbling is canceled and using fallback (fallback 'touchmove' always reached)

      if (!this.options.dragOverBubble && !originalEvent.rootEl) {
        this._handleAutoScroll(originalEvent);
      }
    },
    drop: function drop() {
      if (this.sortable.nativeDraggable) {
        off(document, 'dragover', this._handleAutoScroll);
      } else {
        off(document, 'pointermove', this._handleFallbackAutoScroll);
        off(document, 'touchmove', this._handleFallbackAutoScroll);
        off(document, 'mousemove', this._handleFallbackAutoScroll);
      }

      clearPointerElemChangedInterval();
      clearAutoScrolls();
      cancelThrottle();
    },
    nulling: function nulling() {
      touchEvt$1 = scrollRootEl = scrollEl = scrolling = pointerElemChangedInterval = lastAutoScrollX = lastAutoScrollY = null;
      autoScrolls.length = 0;
    },
    _handleFallbackAutoScroll: function _handleFallbackAutoScroll(evt) {
      this._handleAutoScroll(evt, true);
    },
    _handleAutoScroll: function _handleAutoScroll(evt, fallback) {
      var _this = this;

      var x = (evt.touches ? evt.touches[0] : evt).clientX,
          y = (evt.touches ? evt.touches[0] : evt).clientY,
          elem = document.elementFromPoint(x, y);
      touchEvt$1 = evt; // IE does not seem to have native autoscroll,
      // Edge's autoscroll seems too conditional,
      // MACOS Safari does not have autoscroll,
      // Firefox and Chrome are good

      if (fallback || Edge || IE11OrLess || Safari) {
        autoScroll(evt, this.options, elem, fallback); // Listener for pointer element change

        var ogElemScroller = getParentAutoScrollElement(elem, true);

        if (scrolling && (!pointerElemChangedInterval || x !== lastAutoScrollX || y !== lastAutoScrollY)) {
          pointerElemChangedInterval && clearPointerElemChangedInterval(); // Detect for pointer elem change, emulating native DnD behaviour

          pointerElemChangedInterval = setInterval(function () {
            var newElem = getParentAutoScrollElement(document.elementFromPoint(x, y), true);

            if (newElem !== ogElemScroller) {
              ogElemScroller = newElem;
              clearAutoScrolls();
            }

            autoScroll(evt, _this.options, newElem, fallback);
          }, 10);
          lastAutoScrollX = x;
          lastAutoScrollY = y;
        }
      } else {
        // if DnD is enabled (and browser has good autoscrolling), first autoscroll will already scroll, so get parent autoscroll of first autoscroll
        if (!this.options.bubbleScroll || getParentAutoScrollElement(elem, true) === getWindowScrollingElement()) {
          clearAutoScrolls();
          return;
        }

        autoScroll(evt, this.options, getParentAutoScrollElement(elem, false), false);
      }
    }
  };
  return _extends(AutoScroll, {
    pluginName: 'scroll',
    initializeByDefault: true
  });
}

function clearAutoScrolls() {
  autoScrolls.forEach(function (autoScroll) {
    clearInterval(autoScroll.pid);
  });
  autoScrolls = [];
}

function clearPointerElemChangedInterval() {
  clearInterval(pointerElemChangedInterval);
}

var autoScroll = throttle(function (evt, options, rootEl, isFallback) {
  // Bug: https://bugzilla.mozilla.org/show_bug.cgi?id=505521
  if (!options.scroll) return;
  var x = (evt.touches ? evt.touches[0] : evt).clientX,
      y = (evt.touches ? evt.touches[0] : evt).clientY,
      sens = options.scrollSensitivity,
      speed = options.scrollSpeed,
      winScroller = getWindowScrollingElement();
  var scrollThisInstance = false,
      scrollCustomFn; // New scroll root, set scrollEl

  if (scrollRootEl !== rootEl) {
    scrollRootEl = rootEl;
    clearAutoScrolls();
    scrollEl = options.scroll;
    scrollCustomFn = options.scrollFn;

    if (scrollEl === true) {
      scrollEl = getParentAutoScrollElement(rootEl, true);
    }
  }

  var layersOut = 0;
  var currentParent = scrollEl;

  do {
    var el = currentParent,
        rect = getRect(el),
        top = rect.top,
        bottom = rect.bottom,
        left = rect.left,
        right = rect.right,
        width = rect.width,
        height = rect.height,
        canScrollX = void 0,
        canScrollY = void 0,
        scrollWidth = el.scrollWidth,
        scrollHeight = el.scrollHeight,
        elCSS = css(el),
        scrollPosX = el.scrollLeft,
        scrollPosY = el.scrollTop;

    if (el === winScroller) {
      canScrollX = width < scrollWidth && (elCSS.overflowX === 'auto' || elCSS.overflowX === 'scroll' || elCSS.overflowX === 'visible');
      canScrollY = height < scrollHeight && (elCSS.overflowY === 'auto' || elCSS.overflowY === 'scroll' || elCSS.overflowY === 'visible');
    } else {
      canScrollX = width < scrollWidth && (elCSS.overflowX === 'auto' || elCSS.overflowX === 'scroll');
      canScrollY = height < scrollHeight && (elCSS.overflowY === 'auto' || elCSS.overflowY === 'scroll');
    }

    var vx = canScrollX && (Math.abs(right - x) <= sens && scrollPosX + width < scrollWidth) - (Math.abs(left - x) <= sens && !!scrollPosX);
    var vy = canScrollY && (Math.abs(bottom - y) <= sens && scrollPosY + height < scrollHeight) - (Math.abs(top - y) <= sens && !!scrollPosY);

    if (!autoScrolls[layersOut]) {
      for (var i = 0; i <= layersOut; i++) {
        if (!autoScrolls[i]) {
          autoScrolls[i] = {};
        }
      }
    }

    if (autoScrolls[layersOut].vx != vx || autoScrolls[layersOut].vy != vy || autoScrolls[layersOut].el !== el) {
      autoScrolls[layersOut].el = el;
      autoScrolls[layersOut].vx = vx;
      autoScrolls[layersOut].vy = vy;
      clearInterval(autoScrolls[layersOut].pid);

      if (vx != 0 || vy != 0) {
        scrollThisInstance = true;
        /* jshint loopfunc:true */

        autoScrolls[layersOut].pid = setInterval(function () {
          // emulate drag over during autoscroll (fallback), emulating native DnD behaviour
          if (isFallback && this.layer === 0) {
            Sortable.active._onTouchMove(touchEvt$1); // To move ghost if it is positioned absolutely

          }

          var scrollOffsetY = autoScrolls[this.layer].vy ? autoScrolls[this.layer].vy * speed : 0;
          var scrollOffsetX = autoScrolls[this.layer].vx ? autoScrolls[this.layer].vx * speed : 0;

          if (typeof scrollCustomFn === 'function') {
            if (scrollCustomFn.call(Sortable.dragged.parentNode[expando], scrollOffsetX, scrollOffsetY, evt, touchEvt$1, autoScrolls[this.layer].el) !== 'continue') {
              return;
            }
          }

          scrollBy(autoScrolls[this.layer].el, scrollOffsetX, scrollOffsetY);
        }.bind({
          layer: layersOut
        }), 24);
      }
    }

    layersOut++;
  } while (options.bubbleScroll && currentParent !== winScroller && (currentParent = getParentAutoScrollElement(currentParent, false)));

  scrolling = scrollThisInstance; // in case another function catches scrolling as false in between when it is not
}, 30);

var drop = function drop(_ref) {
  var originalEvent = _ref.originalEvent,
      putSortable = _ref.putSortable,
      dragEl = _ref.dragEl,
      activeSortable = _ref.activeSortable,
      dispatchSortableEvent = _ref.dispatchSortableEvent,
      hideGhostForTarget = _ref.hideGhostForTarget,
      unhideGhostForTarget = _ref.unhideGhostForTarget;
  if (!originalEvent) return;
  var toSortable = putSortable || activeSortable;
  hideGhostForTarget();
  var touch = originalEvent.changedTouches && originalEvent.changedTouches.length ? originalEvent.changedTouches[0] : originalEvent;
  var target = document.elementFromPoint(touch.clientX, touch.clientY);
  unhideGhostForTarget();

  if (toSortable && !toSortable.el.contains(target)) {
    dispatchSortableEvent('spill');
    this.onSpill({
      dragEl: dragEl,
      putSortable: putSortable
    });
  }
};

function Revert() {}

Revert.prototype = {
  startIndex: null,
  dragStart: function dragStart(_ref2) {
    var oldDraggableIndex = _ref2.oldDraggableIndex;
    this.startIndex = oldDraggableIndex;
  },
  onSpill: function onSpill(_ref3) {
    var dragEl = _ref3.dragEl,
        putSortable = _ref3.putSortable;
    this.sortable.captureAnimationState();

    if (putSortable) {
      putSortable.captureAnimationState();
    }

    var nextSibling = getChild(this.sortable.el, this.startIndex, this.options);

    if (nextSibling) {
      this.sortable.el.insertBefore(dragEl, nextSibling);
    } else {
      this.sortable.el.appendChild(dragEl);
    }

    this.sortable.animateAll();

    if (putSortable) {
      putSortable.animateAll();
    }
  },
  drop: drop
};

_extends(Revert, {
  pluginName: 'revertOnSpill'
});

function Remove() {}

Remove.prototype = {
  onSpill: function onSpill(_ref4) {
    var dragEl = _ref4.dragEl,
        putSortable = _ref4.putSortable;
    var parentSortable = putSortable || this.sortable;
    parentSortable.captureAnimationState();
    dragEl.parentNode && dragEl.parentNode.removeChild(dragEl);
    parentSortable.animateAll();
  },
  drop: drop
};

_extends(Remove, {
  pluginName: 'removeOnSpill'
});

Sortable.mount(new AutoScrollPlugin());
Sortable.mount(Remove, Revert);

// Currently just sorts the doam and does not post to the server.
// Next:
// - specify class for handle, defaulting to .handle
// - default containerTarget to the ul that the controller is added to
// - support posting to the server to sort results.

var _default$5 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      Sortable.create(this.containerTarget, {
        handle: ".handle",
        animation: 150
      });
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$5, "targets", ["container"]);

var Rails = window.Rails;

var _default$4 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "refresh",
    value: function refresh(event) {
      event.preventDefault();
      var selectedOption = this.element.options[this.element.selectedIndex];
      var url = selectedOption.dataset.source;
      Rails.ajax({
        type: "GET",
        url: url,
        dataType: "application/js"
      });
    }
    /*
    When each option in a select has data-show and/or data-hide attributes
    specifying the ids (currently only one id supported) of elements to show or
    hide. Used for example when selecting an option should show a certain UI element
    and other options should hide it. Used e.g. on the AKI alerts filter form for the
    specific data option.
    */

  }, {
    key: "showhide",
    value: function showhide(event) {
      var _document$querySelect, _document$querySelect2;

      var selectedOption = this.element.options[this.element.selectedIndex];
      var idsToShow = selectedOption.dataset.show;
      var idsToHide = selectedOption.dataset.hide;
      (_document$querySelect = document.querySelector("#" + idsToShow)) === null || _document$querySelect === void 0 ? void 0 : _document$querySelect.classList.remove("hidden");
      (_document$querySelect2 = document.querySelector("#" + idsToHide)) === null || _document$querySelect2 === void 0 ? void 0 : _document$querySelect2.classList.add("hidden");
    }
  }]);

  return _default;
}(Controller);

// value = matchValue (eg "no" in the case of tristate Yes No Uknown radio
// groups).
// Example usage:
// div(data-controller="radio-reset" data-radio-reset-match-value="no")
//   input(type="radio" value="yes" ..)
//   input(type="radio" value="no" ..)
//   ...

var _default$3 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "reset_all",
    value: function reset_all(event) {
      var that = this;
      var radioInputs = Array.prototype.slice.call(this.element.querySelectorAll("input[type='radio']"));
      radioInputs.forEach(function (a) {
        if (a.value == that.matchValue) {
          a.checked = true;
        }
      });
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$3, "values", {
  match: String
});

var _default$2 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "showhide",
    // element we are going to show/hide
    // attributeToTest: Name of the boolean data attribute on the selected option that determines if
    //                  the displayable target shoule be visible or not

    /*
    For a SELECT, find the chosen option, and the data atribute we need (a boolean eg "true" whose
    name is in the attributeToTest value).  Hide or show the target element according to the boolean
    'test' attribute.
    */
    value: function showhide(event) {
      event.preventDefault();

      if (event.target.tagName.toUpperCase() == "SELECT") {
        var selectedOption = event.target.options[event.target.selectedIndex];
        var display = selectedOption.dataset[this.attributeToTestValue] == "true" ? "block" : "none";
        this.displayableTarget.style.display = display;
      }
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$2, "targets", ["displayable"]);

_defineProperty$1(_default$2, "values", {
  attributeToTest: String
});

var exports = {};
!function (e, t) {
  "object" == typeof exports && "object" == typeof module ? module.exports = t() : "function" == typeof define && define.amd ? define([], t) : "object" == typeof exports ? exports.SlimSelect = t() : e.SlimSelect = t();
}(window, function () {
  return n = {}, s.m = i = [function (e, t, i) {

    function n(e, t) {
      t = t || {
        bubbles: !1,
        cancelable: !1,
        detail: void 0
      };
      var i = document.createEvent("CustomEvent");
      return i.initCustomEvent(e, t.bubbles, t.cancelable, t.detail), i;
    }

    t.__esModule = !0, t.kebabCase = t.highlight = t.isValueInArrayOfObjects = t.debounce = t.putContent = t.ensureElementInView = t.hasClassInTree = void 0, t.hasClassInTree = function (e, t) {
      function n(e, t) {
        return t && e && e.classList && e.classList.contains(t) ? e : null;
      }

      return n(e, t) || function e(t, i) {
        return t && t !== document ? n(t, i) ? t : e(t.parentNode, i) : null;
      }(e, t);
    }, t.ensureElementInView = function (e, t) {
      var i = e.scrollTop + e.offsetTop,
          n = i + e.clientHeight,
          s = t.offsetTop,
          t = s + t.clientHeight;
      s < i ? e.scrollTop -= i - s : n < t && (e.scrollTop += t - n);
    }, t.putContent = function (e, t, i) {
      var n = e.offsetHeight,
          s = e.getBoundingClientRect(),
          e = i ? s.top : s.top - n,
          n = i ? s.bottom : s.bottom + n;
      return e <= 0 ? "below" : n >= window.innerHeight ? "above" : i ? t : "below";
    }, t.debounce = function (s, a, o) {
      var l;
      return void 0 === a && (a = 100), void 0 === o && (o = !1), function () {
        for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t];

        var i = self,
            n = o && !l;
        clearTimeout(l), l = setTimeout(function () {
          l = null, o || s.apply(i, e);
        }, a), n && s.apply(i, e);
      };
    }, t.isValueInArrayOfObjects = function (e, t, i) {
      if (!Array.isArray(e)) return e[t] === i;

      for (var n = 0, s = e; n < s.length; n++) {
        var a = s[n];
        if (a && a[t] && a[t] === i) return !0;
      }

      return !1;
    }, t.highlight = function (e, t, i) {
      var n = e,
          s = new RegExp("(" + t.trim() + ")(?![^<]*>[^<>]*</)", "i");
      if (!e.match(s)) return e;
      var a = e.match(s).index,
          t = a + e.match(s)[0].toString().length,
          t = e.substring(a, t);
      return n = n.replace(s, '<mark class="'.concat(i, '">').concat(t, "</mark>"));
    }, t.kebabCase = function (e) {
      var t = e.replace(/[A-Z\u00C0-\u00D6\u00D8-\u00DE]/g, function (e) {
        return "-" + e.toLowerCase();
      });
      return e[0] === e[0].toUpperCase() ? t.substring(1) : t;
    }, "function" != typeof (t = window).CustomEvent && (n.prototype = t.Event.prototype, t.CustomEvent = n);
  }, function (e, t, i) {

    t.__esModule = !0, t.validateOption = t.validateData = t.Data = void 0;
    var n = (s.prototype.newOption = function (e) {
      return {
        id: e.id || String(Math.floor(1e8 * Math.random())),
        value: e.value || "",
        text: e.text || "",
        innerHTML: e.innerHTML || "",
        selected: e.selected || !1,
        display: void 0 === e.display || e.display,
        disabled: e.disabled || !1,
        placeholder: e.placeholder || !1,
        class: e.class || void 0,
        data: e.data || {},
        mandatory: e.mandatory || !1
      };
    }, s.prototype.add = function (e) {
      this.data.push({
        id: String(Math.floor(1e8 * Math.random())),
        value: e.value,
        text: e.text,
        innerHTML: "",
        selected: !1,
        display: !0,
        disabled: !1,
        placeholder: !1,
        class: void 0,
        mandatory: e.mandatory,
        data: {}
      });
    }, s.prototype.parseSelectData = function () {
      this.data = [];

      for (var e = 0, t = this.main.select.element.childNodes; e < t.length; e++) {
        var i = t[e];

        if ("OPTGROUP" === i.nodeName) {
          for (var n = {
            label: i.label,
            options: []
          }, s = 0, a = i.childNodes; s < a.length; s++) {
            var o,
                l = a[s];
            "OPTION" === l.nodeName && (o = this.pullOptionData(l), n.options.push(o), o.placeholder && "" !== o.text.trim() && (this.main.config.placeholderText = o.text));
          }

          this.data.push(n);
        } else "OPTION" === i.nodeName && (o = this.pullOptionData(i), this.data.push(o), o.placeholder && "" !== o.text.trim() && (this.main.config.placeholderText = o.text));
      }
    }, s.prototype.pullOptionData = function (e) {
      return {
        id: !!e.dataset && e.dataset.id || String(Math.floor(1e8 * Math.random())),
        value: e.value,
        text: e.text,
        innerHTML: e.innerHTML,
        selected: e.selected,
        disabled: e.disabled,
        placeholder: "true" === e.dataset.placeholder,
        class: e.className,
        style: e.style.cssText,
        data: e.dataset,
        mandatory: !!e.dataset && "true" === e.dataset.mandatory
      };
    }, s.prototype.setSelectedFromSelect = function () {
      if (this.main.config.isMultiple) {
        for (var e = [], t = 0, i = this.main.select.element.options; t < i.length; t++) {
          var n = i[t];
          !n.selected || (n = this.getObjectFromData(n.value, "value")) && n.id && e.push(n.id);
        }

        this.setSelected(e, "id");
      } else {
        var s = this.main.select.element;
        -1 !== s.selectedIndex && (s = s.options[s.selectedIndex].value, this.setSelected(s, "value"));
      }
    }, s.prototype.setSelected = function (e, t) {
      void 0 === t && (t = "id");

      for (var i = 0, n = this.data; i < n.length; i++) {
        var s = n[i];

        if (s.hasOwnProperty("label")) {
          if (s.hasOwnProperty("options")) {
            var a = s.options;
            if (a) for (var o = 0, l = a; o < l.length; o++) {
              var r = l[o];
              r.placeholder || (r.selected = this.shouldBeSelected(r, e, t));
            }
          }
        } else s.selected = this.shouldBeSelected(s, e, t);
      }
    }, s.prototype.shouldBeSelected = function (e, t, i) {
      if (void 0 === i && (i = "id"), Array.isArray(t)) for (var n = 0, s = t; n < s.length; n++) {
        var a = s[n];
        if (i in e && String(e[i]) === String(a)) return !0;
      } else if (i in e && String(e[i]) === String(t)) return !0;
      return !1;
    }, s.prototype.getSelected = function () {
      for (var e = {
        text: "",
        placeholder: this.main.config.placeholderText
      }, t = [], i = 0, n = this.data; i < n.length; i++) {
        var s = n[i];

        if (s.hasOwnProperty("label")) {
          if (s.hasOwnProperty("options")) {
            var a = s.options;
            if (a) for (var o = 0, l = a; o < l.length; o++) {
              var r = l[o];
              r.selected && (this.main.config.isMultiple ? t.push(r) : e = r);
            }
          }
        } else s.selected && (this.main.config.isMultiple ? t.push(s) : e = s);
      }

      return this.main.config.isMultiple ? t : e;
    }, s.prototype.addToSelected = function (e, t) {
      if (void 0 === t && (t = "id"), this.main.config.isMultiple) {
        var i = [],
            n = this.getSelected();
        if (Array.isArray(n)) for (var s = 0, a = n; s < a.length; s++) {
          var o = a[s];
          i.push(o[t]);
        }
        i.push(e), this.setSelected(i, t);
      }
    }, s.prototype.removeFromSelected = function (e, t) {
      if (void 0 === t && (t = "id"), this.main.config.isMultiple) {
        for (var i = [], n = 0, s = this.getSelected(); n < s.length; n++) {
          var a = s[n];
          String(a[t]) !== String(e) && i.push(a[t]);
        }

        this.setSelected(i, t);
      }
    }, s.prototype.onDataChange = function () {
      this.main.onChange && this.isOnChangeEnabled && this.main.onChange(JSON.parse(JSON.stringify(this.getSelected())));
    }, s.prototype.getObjectFromData = function (e, t) {
      void 0 === t && (t = "id");

      for (var i = 0, n = this.data; i < n.length; i++) {
        var s = n[i];
        if (t in s && String(s[t]) === String(e)) return s;
        if (s.hasOwnProperty("options")) if (s.options) for (var a = 0, o = s.options; a < o.length; a++) {
          var l = o[a];
          if (String(l[t]) === String(e)) return l;
        }
      }

      return null;
    }, s.prototype.search = function (n) {
      var s, e;
      "" !== (this.searchValue = n).trim() ? (s = this.main.config.searchFilter, e = this.data.slice(0), n = n.trim(), e = e.map(function (e) {
        if (e.hasOwnProperty("options")) {
          var t = e,
              i = [];

          if (0 !== (i = t.options ? t.options.filter(function (e) {
            return s(e, n);
          }) : i).length) {
            t = Object.assign({}, t);
            return t.options = i, t;
          }
        }

        if (e.hasOwnProperty("text") && s(e, n)) return e;
        return null;
      }), this.filtered = e.filter(function (e) {
        return e;
      })) : this.filtered = null;
    }, s);

    function s(e) {
      this.contentOpen = !1, this.contentPosition = "below", this.isOnChangeEnabled = !0, this.main = e.main, this.searchValue = "", this.data = [], this.filtered = null, this.parseSelectData(), this.setSelectedFromSelect();
    }

    function r(e) {
      return void 0 !== e.text || (console.error("Data object option must have at least have a text value. Check object: " + JSON.stringify(e)), !1);
    }

    t.Data = n, t.validateData = function (e) {
      if (!e) return console.error("Data must be an array of objects"), !1;

      for (var t = 0, i = 0, n = e; i < n.length; i++) {
        var s = n[i];

        if (s.hasOwnProperty("label")) {
          if (s.hasOwnProperty("options")) {
            var a = s.options;
            if (a) for (var o = 0, l = a; o < l.length; o++) r(l[o]) || t++;
          }
        } else r(s) || t++;
      }

      return 0 === t;
    }, t.validateOption = r;
  }, function (e, t, i) {

    t.__esModule = !0;
    var n = i(3),
        s = i(4),
        a = i(5),
        r = i(1),
        o = i(0),
        i = (l.prototype.validate = function (e) {
      e = "string" == typeof e.select ? document.querySelector(e.select) : e.select;
      if (!e) throw new Error("Could not find select element");
      if ("SELECT" !== e.tagName) throw new Error("Element isnt of type select");
      return e;
    }, l.prototype.selected = function () {
      if (this.config.isMultiple) {
        for (var e = [], t = 0, i = s = this.data.getSelected(); t < i.length; t++) {
          var n = i[t];
          e.push(n.value);
        }

        return e;
      }

      var s;
      return (s = this.data.getSelected()) ? s.value : "";
    }, l.prototype.set = function (e, t, i, n) {
      void 0 === t && (t = "value"), void 0 === i && (i = !0), this.config.isMultiple && !Array.isArray(e) ? this.data.addToSelected(e, t) : this.data.setSelected(e, t), this.select.setValue(), this.data.onDataChange(), this.render(), (i = this.config.hideSelectedOption && this.config.isMultiple && this.data.getSelected().length === this.data.data.length ? !0 : i) && this.close();
    }, l.prototype.setSelected = function (e, t, i, n) {
      this.set(e, t = void 0 === t ? "value" : t, i = void 0 === i ? !0 : i, n = void 0 === n ? !0 : n);
    }, l.prototype.setData = function (e) {
      if ((0, r.validateData)(e)) {
        for (var t = JSON.parse(JSON.stringify(e)), i = this.data.getSelected(), n = 0; n < t.length; n++) t[n].value || t[n].placeholder || (t[n].value = t[n].text);

        if (this.config.isAjax && i) if (this.config.isMultiple) for (var s = 0, a = i.reverse(); s < a.length; s++) {
          var o = a[s];
          t.unshift(o);
        } else {
          t.unshift(i);

          for (n = 0; n < t.length; n++) t[n].placeholder || t[n].value !== i.value || t[n].text !== i.text || t.splice(n, 1);

          for (var l = !1, n = 0; n < t.length; n++) t[n].placeholder && (l = !0);

          l || t.unshift({
            text: "",
            placeholder: !0
          });
        }
        this.select.create(t), this.data.parseSelectData(), this.data.setSelectedFromSelect();
      } else console.error("Validation problem on: #" + this.select.element.id);
    }, l.prototype.addData = function (e) {
      (0, r.validateData)([e]) ? (this.data.add(this.data.newOption(e)), this.select.create(this.data.data), this.data.parseSelectData(), this.data.setSelectedFromSelect(), this.render()) : console.error("Validation problem on: #" + this.select.element.id);
    }, l.prototype.open = function () {
      var e,
          t = this;
      this.config.isEnabled && (this.data.contentOpen || this.config.hideSelectedOption && this.config.isMultiple && this.data.getSelected().length === this.data.data.length || (this.beforeOpen && this.beforeOpen(), this.config.isMultiple && this.slim.multiSelected ? this.slim.multiSelected.plus.classList.add("ss-cross") : this.slim.singleSelected && (this.slim.singleSelected.arrowIcon.arrow.classList.remove("arrow-down"), this.slim.singleSelected.arrowIcon.arrow.classList.add("arrow-up")), this.slim[this.config.isMultiple ? "multiSelected" : "singleSelected"].container.classList.add("above" === this.data.contentPosition ? this.config.openAbove : this.config.openBelow), this.config.addToBody && (e = this.slim.container.getBoundingClientRect(), this.slim.content.style.top = e.top + e.height + window.scrollY + "px", this.slim.content.style.left = e.left + window.scrollX + "px", this.slim.content.style.width = e.width + "px"), this.slim.content.classList.add(this.config.open), "up" === this.config.showContent.toLowerCase() || "down" !== this.config.showContent.toLowerCase() && "above" === (0, o.putContent)(this.slim.content, this.data.contentPosition, this.data.contentOpen) ? this.moveContentAbove() : this.moveContentBelow(), this.config.isMultiple || (e = this.data.getSelected()) && (e = e.id, (e = this.slim.list.querySelector('[data-id="' + e + '"]')) && (0, o.ensureElementInView)(this.slim.list, e)), setTimeout(function () {
        t.data.contentOpen = !0, t.config.searchFocus && t.slim.search.input.focus(), t.afterOpen && t.afterOpen();
      }, this.config.timeoutDelay)));
    }, l.prototype.close = function () {
      var e = this;
      this.data.contentOpen && (this.beforeClose && this.beforeClose(), this.config.isMultiple && this.slim.multiSelected ? (this.slim.multiSelected.container.classList.remove(this.config.openAbove), this.slim.multiSelected.container.classList.remove(this.config.openBelow), this.slim.multiSelected.plus.classList.remove("ss-cross")) : this.slim.singleSelected && (this.slim.singleSelected.container.classList.remove(this.config.openAbove), this.slim.singleSelected.container.classList.remove(this.config.openBelow), this.slim.singleSelected.arrowIcon.arrow.classList.add("arrow-down"), this.slim.singleSelected.arrowIcon.arrow.classList.remove("arrow-up")), this.slim.content.classList.remove(this.config.open), this.data.contentOpen = !1, this.search(""), setTimeout(function () {
        e.slim.content.removeAttribute("style"), e.data.contentPosition = "below", e.config.isMultiple && e.slim.multiSelected ? (e.slim.multiSelected.container.classList.remove(e.config.openAbove), e.slim.multiSelected.container.classList.remove(e.config.openBelow)) : e.slim.singleSelected && (e.slim.singleSelected.container.classList.remove(e.config.openAbove), e.slim.singleSelected.container.classList.remove(e.config.openBelow)), e.slim.search.input.blur(), e.afterClose && e.afterClose();
      }, this.config.timeoutDelay));
    }, l.prototype.moveContentAbove = function () {
      var e = 0;
      this.config.isMultiple && this.slim.multiSelected ? e = this.slim.multiSelected.container.offsetHeight : this.slim.singleSelected && (e = this.slim.singleSelected.container.offsetHeight);
      var t = e + this.slim.content.offsetHeight - 1;
      this.slim.content.style.margin = "-" + t + "px 0 0 0", this.slim.content.style.height = t - e + 1 + "px", this.slim.content.style.transformOrigin = "center bottom", this.data.contentPosition = "above", this.config.isMultiple && this.slim.multiSelected ? (this.slim.multiSelected.container.classList.remove(this.config.openBelow), this.slim.multiSelected.container.classList.add(this.config.openAbove)) : this.slim.singleSelected && (this.slim.singleSelected.container.classList.remove(this.config.openBelow), this.slim.singleSelected.container.classList.add(this.config.openAbove));
    }, l.prototype.moveContentBelow = function () {
      this.data.contentPosition = "below", this.config.isMultiple && this.slim.multiSelected ? (this.slim.multiSelected.container.classList.remove(this.config.openAbove), this.slim.multiSelected.container.classList.add(this.config.openBelow)) : this.slim.singleSelected && (this.slim.singleSelected.container.classList.remove(this.config.openAbove), this.slim.singleSelected.container.classList.add(this.config.openBelow));
    }, l.prototype.enable = function () {
      this.config.isEnabled = !0, this.config.isMultiple && this.slim.multiSelected ? this.slim.multiSelected.container.classList.remove(this.config.disabled) : this.slim.singleSelected && this.slim.singleSelected.container.classList.remove(this.config.disabled), this.select.triggerMutationObserver = !1, this.select.element.disabled = !1, this.slim.search.input.disabled = !1, this.select.triggerMutationObserver = !0;
    }, l.prototype.disable = function () {
      this.config.isEnabled = !1, this.config.isMultiple && this.slim.multiSelected ? this.slim.multiSelected.container.classList.add(this.config.disabled) : this.slim.singleSelected && this.slim.singleSelected.container.classList.add(this.config.disabled), this.select.triggerMutationObserver = !1, this.select.element.disabled = !0, this.slim.search.input.disabled = !0, this.select.triggerMutationObserver = !0;
    }, l.prototype.search = function (t) {
      var i;
      this.data.searchValue !== t && (this.slim.search.input.value = t, this.config.isAjax ? ((i = this).config.isSearching = !0, this.render(), this.ajax && this.ajax(t, function (e) {
        i.config.isSearching = !1, Array.isArray(e) ? (e.unshift({
          text: "",
          placeholder: !0
        }), i.setData(e), i.data.search(t), i.render()) : "string" == typeof e ? i.slim.options(e) : i.render();
      })) : (this.data.search(t), this.render()));
    }, l.prototype.setSearchText = function (e) {
      this.config.searchText = e;
    }, l.prototype.render = function () {
      this.config.isMultiple ? this.slim.values() : (this.slim.placeholder(), this.slim.deselect()), this.slim.options();
    }, l.prototype.destroy = function (e) {
      var t = (e = void 0 === e ? null : e) ? document.querySelector("." + e + ".ss-main") : this.slim.container,
          i = e ? document.querySelector("[data-ssid=".concat(e, "]")) : this.select.element;
      t && i && (document.removeEventListener("click", this.documentClick), "auto" === this.config.showContent && window.removeEventListener("scroll", this.windowScroll, !1), i.style.display = "", delete i.dataset.ssid, i.slim = null, t.parentElement && t.parentElement.removeChild(t), !this.config.addToBody || (e = e ? document.querySelector("." + e + ".ss-content") : this.slim.content) && document.body.removeChild(e));
    }, l);

    function l(e) {
      var t = this;
      this.ajax = null, this.addable = null, this.beforeOnChange = null, this.onChange = null, this.beforeOpen = null, this.afterOpen = null, this.beforeClose = null, this.afterClose = null, this.windowScroll = (0, o.debounce)(function (e) {
        t.data.contentOpen && ("above" === (0, o.putContent)(t.slim.content, t.data.contentPosition, t.data.contentOpen) ? t.moveContentAbove() : t.moveContentBelow());
      }), this.documentClick = function (e) {
        e.target && !(0, o.hasClassInTree)(e.target, t.config.id) && t.close();
      };
      var i = this.validate(e);
      i.dataset.ssid && this.destroy(i.dataset.ssid), e.ajax && (this.ajax = e.ajax), e.addable && (this.addable = e.addable), this.config = new n.Config({
        select: i,
        isAjax: !!e.ajax,
        showSearch: e.showSearch,
        searchPlaceholder: e.searchPlaceholder,
        searchText: e.searchText,
        searchingText: e.searchingText,
        searchFocus: e.searchFocus,
        searchHighlight: e.searchHighlight,
        searchFilter: e.searchFilter,
        closeOnSelect: e.closeOnSelect,
        showContent: e.showContent,
        placeholderText: e.placeholder,
        allowDeselect: e.allowDeselect,
        allowDeselectOption: e.allowDeselectOption,
        hideSelectedOption: e.hideSelectedOption,
        deselectLabel: e.deselectLabel,
        isEnabled: e.isEnabled,
        valuesUseText: e.valuesUseText,
        showOptionTooltips: e.showOptionTooltips,
        selectByGroup: e.selectByGroup,
        limit: e.limit,
        timeoutDelay: e.timeoutDelay,
        addToBody: e.addToBody
      }), this.select = new s.Select({
        select: i,
        main: this
      }), this.data = new r.Data({
        main: this
      }), this.slim = new a.Slim({
        main: this
      }), this.select.element.parentNode && this.select.element.parentNode.insertBefore(this.slim.container, this.select.element.nextSibling), e.data ? this.setData(e.data) : this.render(), document.addEventListener("click", this.documentClick), "auto" === this.config.showContent && window.addEventListener("scroll", this.windowScroll, !1), e.beforeOnChange && (this.beforeOnChange = e.beforeOnChange), e.onChange && (this.onChange = e.onChange), e.beforeOpen && (this.beforeOpen = e.beforeOpen), e.afterOpen && (this.afterOpen = e.afterOpen), e.beforeClose && (this.beforeClose = e.beforeClose), e.afterClose && (this.afterClose = e.afterClose), this.config.isEnabled || this.disable();
    }

    t.default = i;
  }, function (e, t, i) {

    t.__esModule = !0, t.Config = void 0;
    var n = (s.prototype.searchFilter = function (e, t) {
      return -1 !== e.text.toLowerCase().indexOf(t.toLowerCase());
    }, s);

    function s(e) {
      this.id = "", this.isMultiple = !1, this.isAjax = !1, this.isSearching = !1, this.showSearch = !0, this.searchFocus = !0, this.searchHighlight = !1, this.closeOnSelect = !0, this.showContent = "auto", this.searchPlaceholder = "Search", this.searchText = "No Results", this.searchingText = "Searching...", this.placeholderText = "Select Value", this.allowDeselect = !1, this.allowDeselectOption = !1, this.hideSelectedOption = !1, this.deselectLabel = "x", this.isEnabled = !0, this.valuesUseText = !1, this.showOptionTooltips = !1, this.selectByGroup = !1, this.limit = 0, this.timeoutDelay = 200, this.addToBody = !1, this.main = "ss-main", this.singleSelected = "ss-single-selected", this.arrow = "ss-arrow", this.multiSelected = "ss-multi-selected", this.add = "ss-add", this.plus = "ss-plus", this.values = "ss-values", this.value = "ss-value", this.valueText = "ss-value-text", this.valueDelete = "ss-value-delete", this.content = "ss-content", this.open = "ss-open", this.openAbove = "ss-open-above", this.openBelow = "ss-open-below", this.search = "ss-search", this.searchHighlighter = "ss-search-highlight", this.addable = "ss-addable", this.list = "ss-list", this.optgroup = "ss-optgroup", this.optgroupLabel = "ss-optgroup-label", this.optgroupLabelSelectable = "ss-optgroup-label-selectable", this.option = "ss-option", this.optionSelected = "ss-option-selected", this.highlighted = "ss-highlighted", this.disabled = "ss-disabled", this.hide = "ss-hide", this.id = "ss-" + Math.floor(1e5 * Math.random()), this.style = e.select.style.cssText, this.class = e.select.className.split(" "), this.isMultiple = e.select.multiple, this.isAjax = e.isAjax, this.showSearch = !1 !== e.showSearch, this.searchFocus = !1 !== e.searchFocus, this.searchHighlight = !0 === e.searchHighlight, this.closeOnSelect = !1 !== e.closeOnSelect, e.showContent && (this.showContent = e.showContent), this.isEnabled = !1 !== e.isEnabled, e.searchPlaceholder && (this.searchPlaceholder = e.searchPlaceholder), e.searchText && (this.searchText = e.searchText), e.searchingText && (this.searchingText = e.searchingText), e.placeholderText && (this.placeholderText = e.placeholderText), this.allowDeselect = !0 === e.allowDeselect, this.allowDeselectOption = !0 === e.allowDeselectOption, this.hideSelectedOption = !0 === e.hideSelectedOption, e.deselectLabel && (this.deselectLabel = e.deselectLabel), e.valuesUseText && (this.valuesUseText = e.valuesUseText), e.showOptionTooltips && (this.showOptionTooltips = e.showOptionTooltips), e.selectByGroup && (this.selectByGroup = e.selectByGroup), e.limit && (this.limit = e.limit), e.searchFilter && (this.searchFilter = e.searchFilter), null != e.timeoutDelay && (this.timeoutDelay = e.timeoutDelay), this.addToBody = !0 === e.addToBody;
    }

    t.Config = n;
  }, function (e, t, i) {

    t.__esModule = !0, t.Select = void 0;
    var n = i(0),
        i = (s.prototype.setValue = function () {
      if (this.main.data.getSelected()) {
        if (this.main.config.isMultiple) for (var e = this.main.data.getSelected(), t = 0, i = this.element.options; t < i.length; t++) {
          var n = i[t];
          n.selected = !1;

          for (var s = 0, a = e; s < a.length; s++) a[s].value === n.value && (n.selected = !0);
        } else {
          e = this.main.data.getSelected();
          this.element.value = e ? e.value : "";
        }
        this.main.data.isOnChangeEnabled = !1, this.element.dispatchEvent(new CustomEvent("change", {
          bubbles: !0
        })), this.main.data.isOnChangeEnabled = !0;
      }
    }, s.prototype.addAttributes = function () {
      this.element.tabIndex = -1, this.element.style.display = "none", this.element.dataset.ssid = this.main.config.id, this.element.setAttribute("aria-hidden", "true");
    }, s.prototype.addEventListeners = function () {
      var t = this;
      this.element.addEventListener("change", function (e) {
        t.main.data.setSelectedFromSelect(), t.main.render();
      });
    }, s.prototype.addMutationObserver = function () {
      var t = this;
      this.main.config.isAjax || (this.mutationObserver = new MutationObserver(function (e) {
        t.triggerMutationObserver && (t.main.data.parseSelectData(), t.main.data.setSelectedFromSelect(), t.main.render(), e.forEach(function (e) {
          "class" === e.attributeName && t.main.slim.updateContainerDivClass(t.main.slim.container);
        }));
      }), this.observeMutationObserver());
    }, s.prototype.observeMutationObserver = function () {
      this.mutationObserver && this.mutationObserver.observe(this.element, {
        attributes: !0,
        childList: !0,
        characterData: !0
      });
    }, s.prototype.disconnectMutationObserver = function () {
      this.mutationObserver && this.mutationObserver.disconnect();
    }, s.prototype.create = function (e) {
      this.element.innerHTML = "";

      for (var t = 0, i = e; t < i.length; t++) {
        var n = i[t];

        if (n.hasOwnProperty("options")) {
          var s = n,
              a = document.createElement("optgroup");
          if (a.label = s.label, s.options) for (var o = 0, l = s.options; o < l.length; o++) {
            var r = l[o];
            a.appendChild(this.createOption(r));
          }
          this.element.appendChild(a);
        } else this.element.appendChild(this.createOption(n));
      }
    }, s.prototype.createOption = function (t) {
      var i = document.createElement("option");
      return i.value = "" !== t.value ? t.value : t.text, i.innerHTML = t.innerHTML || t.text, t.selected && (i.selected = t.selected), !1 === t.display && (i.style.display = "none"), t.disabled && (i.disabled = !0), t.placeholder && i.setAttribute("data-placeholder", "true"), t.mandatory && i.setAttribute("data-mandatory", "true"), t.class && t.class.split(" ").forEach(function (e) {
        i.classList.add(e);
      }), t.data && "object" == typeof t.data && Object.keys(t.data).forEach(function (e) {
        i.setAttribute("data-" + (0, n.kebabCase)(e), t.data[e]);
      }), i;
    }, s);

    function s(e) {
      this.triggerMutationObserver = !0, this.element = e.select, this.main = e.main, this.element.disabled && (this.main.config.isEnabled = !1), this.addAttributes(), this.addEventListeners(), this.mutationObserver = null, this.addMutationObserver(), this.element.slim = e.main;
    }

    t.Select = i;
  }, function (e, t, i) {

    t.__esModule = !0, t.Slim = void 0;
    var n = i(0),
        o = i(1),
        i = (s.prototype.containerDiv = function () {
      var e = document.createElement("div");
      return e.style.cssText = this.main.config.style, this.updateContainerDivClass(e), e;
    }, s.prototype.updateContainerDivClass = function (e) {
      this.main.config.class = this.main.select.element.className.split(" "), e.className = "", e.classList.add(this.main.config.id), e.classList.add(this.main.config.main);

      for (var t = 0, i = this.main.config.class; t < i.length; t++) {
        var n = i[t];
        "" !== n.trim() && e.classList.add(n);
      }
    }, s.prototype.singleSelectedDiv = function () {
      var t = this,
          e = document.createElement("div");
      e.classList.add(this.main.config.singleSelected);
      var i = document.createElement("span");
      i.classList.add("placeholder"), e.appendChild(i);
      var n = document.createElement("span");
      n.innerHTML = this.main.config.deselectLabel, n.classList.add("ss-deselect"), n.onclick = function (e) {
        e.stopPropagation(), t.main.config.isEnabled && t.main.set("");
      }, e.appendChild(n);
      var s = document.createElement("span");
      s.classList.add(this.main.config.arrow);
      var a = document.createElement("span");
      return a.classList.add("arrow-down"), s.appendChild(a), e.appendChild(s), e.onclick = function () {
        t.main.config.isEnabled && (t.main.data.contentOpen ? t.main.close() : t.main.open());
      }, {
        container: e,
        placeholder: i,
        deselect: n,
        arrowIcon: {
          container: s,
          arrow: a
        }
      };
    }, s.prototype.placeholder = function () {
      var e,
          t = this.main.data.getSelected();
      null === t || t && t.placeholder ? ((e = document.createElement("span")).classList.add(this.main.config.disabled), e.innerHTML = this.main.config.placeholderText, this.singleSelected && (this.singleSelected.placeholder.innerHTML = e.outerHTML)) : (e = "", t && (e = t.innerHTML && !0 !== this.main.config.valuesUseText ? t.innerHTML : t.text), this.singleSelected && (this.singleSelected.placeholder.innerHTML = t ? e : ""));
    }, s.prototype.deselect = function () {
      this.singleSelected && (!this.main.config.allowDeselect || "" === this.main.selected() ? this.singleSelected.deselect.classList.add("ss-hide") : this.singleSelected.deselect.classList.remove("ss-hide"));
    }, s.prototype.multiSelectedDiv = function () {
      var t = this,
          e = document.createElement("div");
      e.classList.add(this.main.config.multiSelected);
      var i = document.createElement("div");
      i.classList.add(this.main.config.values), e.appendChild(i);
      var n = document.createElement("div");
      n.classList.add(this.main.config.add);
      var s = document.createElement("span");
      return s.classList.add(this.main.config.plus), s.onclick = function (e) {
        t.main.data.contentOpen && (t.main.close(), e.stopPropagation());
      }, n.appendChild(s), e.appendChild(n), e.onclick = function (e) {
        t.main.config.isEnabled && (e.target.classList.contains(t.main.config.valueDelete) || (t.main.data.contentOpen ? t.main.close() : t.main.open()));
      }, {
        container: e,
        values: i,
        add: n,
        plus: s
      };
    }, s.prototype.values = function () {
      if (this.multiSelected) {
        for (var e = this.multiSelected.values.childNodes, t = this.main.data.getSelected(), i = [], n = 0, s = e; n < s.length; n++) {
          for (var a = s[n], o = !0, l = 0, r = t; l < r.length; l++) {
            var c = r[l];
            String(c.id) === String(a.dataset.id) && (o = !1);
          }

          o && i.push(a);
        }

        for (var d = 0, h = i; d < h.length; d++) {
          var u = h[d];
          u.classList.add("ss-out"), this.multiSelected.values.removeChild(u);
        }

        for (var p, e = this.multiSelected.values.childNodes, c = 0; c < t.length; c++) {
          o = !1;

          for (var m = 0, f = e; m < f.length; m++) {
            a = f[m];
            String(t[c].id) === String(a.dataset.id) && (o = !0);
          }

          o || (0 !== e.length && HTMLElement.prototype.insertAdjacentElement ? 0 === c ? this.multiSelected.values.insertBefore(this.valueDiv(t[c]), e[c]) : e[c - 1].insertAdjacentElement("afterend", this.valueDiv(t[c])) : this.multiSelected.values.appendChild(this.valueDiv(t[c])));
        }

        0 === t.length && ((p = document.createElement("span")).classList.add(this.main.config.disabled), p.innerHTML = this.main.config.placeholderText, this.multiSelected.values.innerHTML = p.outerHTML);
      }
    }, s.prototype.valueDiv = function (s) {
      var a = this,
          e = document.createElement("div");
      e.classList.add(this.main.config.value), e.dataset.id = s.id;
      var t = document.createElement("span");
      return t.classList.add(this.main.config.valueText), t.innerHTML = s.innerHTML && !0 !== this.main.config.valuesUseText ? s.innerHTML : s.text, e.appendChild(t), s.mandatory || ((t = document.createElement("span")).classList.add(this.main.config.valueDelete), t.innerHTML = this.main.config.deselectLabel, t.onclick = function (e) {
        e.preventDefault(), e.stopPropagation();
        var t = !1;

        if (a.main.beforeOnChange || (t = !0), a.main.beforeOnChange) {
          for (var e = a.main.data.getSelected(), i = JSON.parse(JSON.stringify(e)), n = 0; n < i.length; n++) i[n].id === s.id && i.splice(n, 1);

          !1 !== a.main.beforeOnChange(i) && (t = !0);
        }

        t && (a.main.data.removeFromSelected(s.id, "id"), a.main.render(), a.main.select.setValue(), a.main.data.onDataChange());
      }, e.appendChild(t)), e;
    }, s.prototype.contentDiv = function () {
      var e = document.createElement("div");
      return e.classList.add(this.main.config.content), e;
    }, s.prototype.searchDiv = function () {
      var n = this,
          e = document.createElement("div"),
          s = document.createElement("input"),
          a = document.createElement("div");
      e.classList.add(this.main.config.search);
      var t = {
        container: e,
        input: s
      };
      return this.main.config.showSearch || (e.classList.add(this.main.config.hide), s.readOnly = !0), s.type = "search", s.placeholder = this.main.config.searchPlaceholder, s.tabIndex = 0, s.setAttribute("aria-label", this.main.config.searchPlaceholder), s.setAttribute("autocapitalize", "off"), s.setAttribute("autocomplete", "off"), s.setAttribute("autocorrect", "off"), s.onclick = function (e) {
        setTimeout(function () {
          "" === e.target.value && n.main.search("");
        }, 10);
      }, s.onkeydown = function (e) {
        "ArrowUp" === e.key ? (n.main.open(), n.highlightUp(), e.preventDefault()) : "ArrowDown" === e.key ? (n.main.open(), n.highlightDown(), e.preventDefault()) : "Tab" === e.key ? n.main.data.contentOpen ? n.main.close() : setTimeout(function () {
          n.main.close();
        }, n.main.config.timeoutDelay) : "Enter" === e.key && e.preventDefault();
      }, s.onkeyup = function (e) {
        var t = e.target;

        if ("Enter" === e.key) {
          if (n.main.addable && e.ctrlKey) return a.click(), e.preventDefault(), void e.stopPropagation();
          var i = n.list.querySelector("." + n.main.config.highlighted);
          i && i.click();
        } else "ArrowUp" === e.key || "ArrowDown" === e.key || ("Escape" === e.key ? n.main.close() : n.main.config.showSearch && n.main.data.contentOpen ? n.main.search(t.value) : s.value = "");

        e.preventDefault(), e.stopPropagation();
      }, s.onfocus = function () {
        n.main.open();
      }, e.appendChild(s), this.main.addable && (a.classList.add(this.main.config.addable), a.innerHTML = "+", a.onclick = function (e) {
        var t;
        n.main.addable && (e.preventDefault(), e.stopPropagation(), "" !== (e = n.search.input.value).trim() ? (e = n.main.addable(e), t = "", e && ("object" == typeof e ? (0, o.validateOption)(e) && (n.main.addData(e), t = e.value || e.text) : (n.main.addData(n.main.data.newOption({
          text: e,
          value: e
        })), t = e), n.main.search(""), setTimeout(function () {
          n.main.set(t, "value", !1, !1);
        }, 100), n.main.config.closeOnSelect && setTimeout(function () {
          n.main.close();
        }, 100))) : n.search.input.focus());
      }, e.appendChild(a), t.addable = a), t;
    }, s.prototype.highlightUp = function () {
      var e = this.list.querySelector("." + this.main.config.highlighted),
          t = null;
      if (e) for (t = e.previousSibling; null !== t && t.classList.contains(this.main.config.disabled);) t = t.previousSibling;else var i = this.list.querySelectorAll("." + this.main.config.option + ":not(." + this.main.config.disabled + ")"),
          t = i[i.length - 1];
      null !== (t = t && t.classList.contains(this.main.config.optgroupLabel) ? null : t) || (i = e.parentNode).classList.contains(this.main.config.optgroup) && (!i.previousSibling || (i = i.previousSibling.querySelectorAll("." + this.main.config.option + ":not(." + this.main.config.disabled + ")")).length && (t = i[i.length - 1])), t && (e && e.classList.remove(this.main.config.highlighted), t.classList.add(this.main.config.highlighted), (0, n.ensureElementInView)(this.list, t));
    }, s.prototype.highlightDown = function () {
      var e,
          t = this.list.querySelector("." + this.main.config.highlighted),
          i = null;
      if (t) for (i = t.nextSibling; null !== i && i.classList.contains(this.main.config.disabled);) i = i.nextSibling;else i = this.list.querySelector("." + this.main.config.option + ":not(." + this.main.config.disabled + ")");
      null !== i || null === t || (e = t.parentNode).classList.contains(this.main.config.optgroup) && e.nextSibling && (i = e.nextSibling.querySelector("." + this.main.config.option + ":not(." + this.main.config.disabled + ")")), i && (t && t.classList.remove(this.main.config.highlighted), i.classList.add(this.main.config.highlighted), (0, n.ensureElementInView)(this.list, i));
    }, s.prototype.listDiv = function () {
      var e = document.createElement("div");
      return e.classList.add(this.main.config.list), e.setAttribute("role", "listbox"), e;
    }, s.prototype.options = function (e) {
      void 0 === e && (e = "");
      var t = this.main.data.filtered || this.main.data.data;
      if ((this.list.innerHTML = "") !== e) return (i = document.createElement("div")).classList.add(this.main.config.option), i.classList.add(this.main.config.disabled), i.innerHTML = e, void this.list.appendChild(i);
      if (this.main.config.isAjax && this.main.config.isSearching) return (i = document.createElement("div")).classList.add(this.main.config.option), i.classList.add(this.main.config.disabled), i.innerHTML = this.main.config.searchingText, void this.list.appendChild(i);

      if (0 === t.length) {
        var i = document.createElement("div");
        return i.classList.add(this.main.config.option), i.classList.add(this.main.config.disabled), i.innerHTML = this.main.config.searchText, void this.list.appendChild(i);
      }

      for (var r = this, n = 0, s = t; n < s.length; n++) !function (e) {
        if (e.hasOwnProperty("label")) {
          var t = e,
              s = document.createElement("div");
          s.classList.add(r.main.config.optgroup);
          var i = document.createElement("div");
          i.classList.add(r.main.config.optgroupLabel), r.main.config.selectByGroup && r.main.config.isMultiple && i.classList.add(r.main.config.optgroupLabelSelectable), i.innerHTML = t.label, s.appendChild(i);
          t = t.options;

          if (t) {
            for (var a, n = 0, o = t; n < o.length; n++) {
              var l = o[n];
              s.appendChild(r.option(l));
            }

            r.main.config.selectByGroup && r.main.config.isMultiple && (a = r, i.addEventListener("click", function (e) {
              e.preventDefault(), e.stopPropagation();

              for (var t = 0, i = s.children; t < i.length; t++) {
                var n = i[t];
                -1 !== n.className.indexOf(a.main.config.option) && n.click();
              }
            }));
          }

          r.list.appendChild(s);
        } else r.list.appendChild(r.option(e));
      }(s[n]);
    }, s.prototype.option = function (o) {
      if (o.placeholder) {
        var e = document.createElement("div");
        return e.classList.add(this.main.config.option), e.classList.add(this.main.config.hide), e;
      }

      var t = document.createElement("div");
      t.classList.add(this.main.config.option), t.setAttribute("role", "option"), o.class && o.class.split(" ").forEach(function (e) {
        t.classList.add(e);
      }), o.style && (t.style.cssText = o.style);
      var l = this.main.data.getSelected();
      t.dataset.id = o.id, this.main.config.searchHighlight && this.main.slim && o.innerHTML && "" !== this.main.slim.search.input.value.trim() ? t.innerHTML = (0, n.highlight)(o.innerHTML, this.main.slim.search.input.value, this.main.config.searchHighlighter) : o.innerHTML && (t.innerHTML = o.innerHTML), this.main.config.showOptionTooltips && t.textContent && t.setAttribute("title", t.textContent);
      var r = this;
      t.addEventListener("click", function (e) {
        e.preventDefault(), e.stopPropagation();
        var t = this.dataset.id;

        if (!0 === o.selected && r.main.config.allowDeselectOption) {
          var i = !1;

          if (r.main.beforeOnChange && r.main.config.isMultiple || (i = !0), r.main.beforeOnChange && r.main.config.isMultiple) {
            for (var n = r.main.data.getSelected(), s = JSON.parse(JSON.stringify(n)), a = 0; a < s.length; a++) s[a].id === t && s.splice(a, 1);

            !1 !== r.main.beforeOnChange(s) && (i = !0);
          }

          i && (r.main.config.isMultiple ? (r.main.data.removeFromSelected(t, "id"), r.main.render(), r.main.select.setValue(), r.main.data.onDataChange()) : r.main.set(""));
        } else o.disabled || o.selected || r.main.config.limit && Array.isArray(l) && r.main.config.limit <= l.length || (r.main.beforeOnChange ? (n = void 0, (i = JSON.parse(JSON.stringify(r.main.data.getObjectFromData(t)))).selected = !0, r.main.config.isMultiple ? (n = JSON.parse(JSON.stringify(l))).push(i) : n = JSON.parse(JSON.stringify(i)), !1 !== r.main.beforeOnChange(n) && r.main.set(t, "id", r.main.config.closeOnSelect)) : r.main.set(t, "id", r.main.config.closeOnSelect));
      });
      e = l && (0, n.isValueInArrayOfObjects)(l, "id", o.id);
      return (o.disabled || e) && (t.onclick = null, r.main.config.allowDeselectOption || t.classList.add(this.main.config.disabled), r.main.config.hideSelectedOption && t.classList.add(this.main.config.hide)), e ? t.classList.add(this.main.config.optionSelected) : t.classList.remove(this.main.config.optionSelected), t;
    }, s);

    function s(e) {
      this.main = e.main, this.container = this.containerDiv(), this.content = this.contentDiv(), this.search = this.searchDiv(), this.list = this.listDiv(), this.options(), this.singleSelected = null, this.multiSelected = null, this.main.config.isMultiple ? (this.multiSelected = this.multiSelectedDiv(), this.multiSelected && this.container.appendChild(this.multiSelected.container)) : (this.singleSelected = this.singleSelectedDiv(), this.container.appendChild(this.singleSelected.container)), this.main.config.addToBody ? (this.content.classList.add(this.main.config.id), document.body.appendChild(this.content)) : this.container.appendChild(this.content), this.content.appendChild(this.search.container), this.content.appendChild(this.list);
    }

    t.Slim = i;
  }], s.c = n, s.d = function (e, t, i) {
    s.o(e, t) || Object.defineProperty(e, t, {
      enumerable: !0,
      get: i
    });
  }, s.r = function (e) {
    "undefined" != typeof Symbol && Symbol.toStringTag && Object.defineProperty(e, Symbol.toStringTag, {
      value: "Module"
    }), Object.defineProperty(e, "__esModule", {
      value: !0
    });
  }, s.t = function (t, e) {
    if (1 & e && (t = s(t)), 8 & e) return t;
    if (4 & e && "object" == typeof t && t && t.__esModule) return t;
    var i = Object.create(null);
    if (s.r(i), Object.defineProperty(i, "default", {
      enumerable: !0,
      value: t
    }), 2 & e && "string" != typeof t) for (var n in t) s.d(i, n, function (e) {
      return t[e];
    }.bind(null, n));
    return i;
  }, s.n = function (e) {
    var t = e && e.__esModule ? function () {
      return e.default;
    } : function () {
      return e;
    };
    return s.d(t, "a", t), t;
  }, s.o = function (e, t) {
    return Object.prototype.hasOwnProperty.call(e, t);
  }, s.p = "", s(s.s = 2).default;

  function s(e) {
    if (n[e]) return n[e].exports;
    var t = n[e] = {
      i: e,
      l: !1,
      exports: {}
    };
    return i[e].call(t.exports, t, t.exports, s), t.l = !0, t.exports;
  }

  var i, n;
});
var SlimSelect = exports.SlimSelect;

var _default$1 = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      this.slimselect = new SlimSelect(_objectSpread2({
        select: this.element
      }, this.optionsValue));
    }
  }, {
    key: "disconnect",
    value: function disconnect() {
      this.slimselect.destroy();
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default$1, "values", {
  options: Object
});

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);

  var _super = _createSuper(_default);

  function _default() {
    _classCallCheck(this, _default);

    return _super.apply(this, arguments);
  }

  _createClass(_default, [{
    key: "hideModal",
    // hide modal
    // action: "turbo-modal#hideModal"
    value: function hideModal() {
      this.element.parentElement.removeAttribute("src"); // Remove src reference from parent frame element
      // Without this, turbo won't re-open the modal on subsequent click

      this.modalTarget.remove();
    } // hide modal on successful form submission
    // action: "turbo:submit-end->turbo-modal#submitEnd"

  }, {
    key: "submitEnd",
    value: function submitEnd(e) {
      if (e.detail.success) {
        this.hideModal();
      }
    } // hide modal when clicking ESC
    // action: "keyup@window->turbo-modal#closeWithKeyboard"

  }, {
    key: "closeWithKeyboard",
    value: function closeWithKeyboard(e) {
      if (e.code == "Escape") {
        this.hideModal();
      }
    } // hide modal when clicking outside of modal
    // action: "click@window->turbo-modal#closeBackground"

  }, {
    key: "closeBackground",
    value: function closeBackground(e) {
      if (e && this.modalTarget.contains(e.target)) {
        return;
      }

      this.hideModal();
    }
  }]);

  return _default;
}(Controller);

_defineProperty$1(_default, "targets", ["modal"]);

session.drive = false; // Manually import stimulusjs controllers for now as we had problems with the stimulus-controllers
var application = Application.start();
application.register("toggle", _default$k);
application.register("hd-prescription-administration", _default$j);
application.register("home-delivery-modal", _default$i);
application.register("snippets", _default$h);
application.register("letters-form", _default$g);
application.register("prescriptions", _default$f);
application.register("charts", _default$e);
application.register("session", _default$d);
application.register("simple-toggle", _default$c);
application.register("tabs", _default$b);
application.register("pd-pet-chart", _default$a);
application.register("pathology-sparklines", _default$9);
application.register("collapsible", _default$8);
application.register("dependent-select", _default$7);
application.register("patient-attachments", _default$6);
application.register("sortable", _default$5);
application.register("select", _default$4);
application.register("radio-reset", _default$3);
application.register("conditional-display", _default$2);
application.register("slimselect", _default$1);
application.register("turbo-modal", _default);
window.Chartkick.use(window.Highcharts);

var adapters = {
  logger: self.console,
  WebSocket: self.WebSocket
};

//
//   ActionCable.logger.enabled = true
//
//   Example:
//
//   import * as ActionCable from '@rails/actioncable'
//
//   ActionCable.logger.enabled = true
//   ActionCable.logger.log('Connection Established.')
//

var logger = {
  log(...messages) {
    if (this.enabled) {
      messages.push(Date.now());
      adapters.logger.log("[ActionCable]", ...messages);
    }
  }

};

// revival reconnections if things go astray. Internal class, not intended for direct user manipulation.

const now = () => new Date().getTime();

const secondsSince = time => (now() - time) / 1000;

const clamp = (number, min, max) => Math.max(min, Math.min(max, number));

class ConnectionMonitor {
  constructor(connection) {
    this.visibilityDidChange = this.visibilityDidChange.bind(this);
    this.connection = connection;
    this.reconnectAttempts = 0;
  }

  start() {
    if (!this.isRunning()) {
      this.startedAt = now();
      delete this.stoppedAt;
      this.startPolling();
      addEventListener("visibilitychange", this.visibilityDidChange);
      logger.log(`ConnectionMonitor started. pollInterval = ${this.getPollInterval()} ms`);
    }
  }

  stop() {
    if (this.isRunning()) {
      this.stoppedAt = now();
      this.stopPolling();
      removeEventListener("visibilitychange", this.visibilityDidChange);
      logger.log("ConnectionMonitor stopped");
    }
  }

  isRunning() {
    return this.startedAt && !this.stoppedAt;
  }

  recordPing() {
    this.pingedAt = now();
  }

  recordConnect() {
    this.reconnectAttempts = 0;
    this.recordPing();
    delete this.disconnectedAt;
    logger.log("ConnectionMonitor recorded connect");
  }

  recordDisconnect() {
    this.disconnectedAt = now();
    logger.log("ConnectionMonitor recorded disconnect");
  } // Private


  startPolling() {
    this.stopPolling();
    this.poll();
  }

  stopPolling() {
    clearTimeout(this.pollTimeout);
  }

  poll() {
    this.pollTimeout = setTimeout(() => {
      this.reconnectIfStale();
      this.poll();
    }, this.getPollInterval());
  }

  getPollInterval() {
    const {
      min,
      max,
      multiplier
    } = this.constructor.pollInterval;
    const interval = multiplier * Math.log(this.reconnectAttempts + 1);
    return Math.round(clamp(interval, min, max) * 1000);
  }

  reconnectIfStale() {
    if (this.connectionIsStale()) {
      logger.log(`ConnectionMonitor detected stale connection. reconnectAttempts = ${this.reconnectAttempts}, pollInterval = ${this.getPollInterval()} ms, time disconnected = ${secondsSince(this.disconnectedAt)} s, stale threshold = ${this.constructor.staleThreshold} s`);
      this.reconnectAttempts++;

      if (this.disconnectedRecently()) {
        logger.log("ConnectionMonitor skipping reopening recent disconnect");
      } else {
        logger.log("ConnectionMonitor reopening");
        this.connection.reopen();
      }
    }
  }

  connectionIsStale() {
    return secondsSince(this.pingedAt ? this.pingedAt : this.startedAt) > this.constructor.staleThreshold;
  }

  disconnectedRecently() {
    return this.disconnectedAt && secondsSince(this.disconnectedAt) < this.constructor.staleThreshold;
  }

  visibilityDidChange() {
    if (document.visibilityState === "visible") {
      setTimeout(() => {
        if (this.connectionIsStale() || !this.connection.isOpen()) {
          logger.log(`ConnectionMonitor reopening stale connection on visibilitychange. visibilityState = ${document.visibilityState}`);
          this.connection.reopen();
        }
      }, 200);
    }
  }

}

ConnectionMonitor.pollInterval = {
  min: 3,
  max: 30,
  multiplier: 5
};
ConnectionMonitor.staleThreshold = 6; // Server::Connections::BEAT_INTERVAL * 2 (missed two pings)

var ConnectionMonitor$1 = ConnectionMonitor;

var INTERNAL = {
  "message_types": {
    "welcome": "welcome",
    "disconnect": "disconnect",
    "ping": "ping",
    "confirmation": "confirm_subscription",
    "rejection": "reject_subscription"
  },
  "disconnect_reasons": {
    "unauthorized": "unauthorized",
    "invalid_request": "invalid_request",
    "server_restart": "server_restart"
  },
  "default_mount_path": "/cable",
  "protocols": ["actioncable-v1-json", "actioncable-unsupported"]
};

const {
  message_types,
  protocols
} = INTERNAL;
const supportedProtocols = protocols.slice(0, protocols.length - 1);
const indexOf = [].indexOf;

class Connection {
  constructor(consumer) {
    this.open = this.open.bind(this);
    this.consumer = consumer;
    this.subscriptions = this.consumer.subscriptions;
    this.monitor = new ConnectionMonitor$1(this);
    this.disconnected = true;
  }

  send(data) {
    if (this.isOpen()) {
      this.webSocket.send(JSON.stringify(data));
      return true;
    } else {
      return false;
    }
  }

  open() {
    if (this.isActive()) {
      logger.log(`Attempted to open WebSocket, but existing socket is ${this.getState()}`);
      return false;
    } else {
      logger.log(`Opening WebSocket, current state is ${this.getState()}, subprotocols: ${protocols}`);

      if (this.webSocket) {
        this.uninstallEventHandlers();
      }

      this.webSocket = new adapters.WebSocket(this.consumer.url, protocols);
      this.installEventHandlers();
      this.monitor.start();
      return true;
    }
  }

  close({
    allowReconnect
  } = {
    allowReconnect: true
  }) {
    if (!allowReconnect) {
      this.monitor.stop();
    }

    if (this.isActive()) {
      return this.webSocket.close();
    }
  }

  reopen() {
    logger.log(`Reopening WebSocket, current state is ${this.getState()}`);

    if (this.isActive()) {
      try {
        return this.close();
      } catch (error) {
        logger.log("Failed to reopen WebSocket", error);
      } finally {
        logger.log(`Reopening WebSocket in ${this.constructor.reopenDelay}ms`);
        setTimeout(this.open, this.constructor.reopenDelay);
      }
    } else {
      return this.open();
    }
  }

  getProtocol() {
    if (this.webSocket) {
      return this.webSocket.protocol;
    }
  }

  isOpen() {
    return this.isState("open");
  }

  isActive() {
    return this.isState("open", "connecting");
  } // Private


  isProtocolSupported() {
    return indexOf.call(supportedProtocols, this.getProtocol()) >= 0;
  }

  isState(...states) {
    return indexOf.call(states, this.getState()) >= 0;
  }

  getState() {
    if (this.webSocket) {
      for (let state in adapters.WebSocket) {
        if (adapters.WebSocket[state] === this.webSocket.readyState) {
          return state.toLowerCase();
        }
      }
    }

    return null;
  }

  installEventHandlers() {
    for (let eventName in this.events) {
      const handler = this.events[eventName].bind(this);
      this.webSocket[`on${eventName}`] = handler;
    }
  }

  uninstallEventHandlers() {
    for (let eventName in this.events) {
      this.webSocket[`on${eventName}`] = function () {};
    }
  }

}

Connection.reopenDelay = 500;
Connection.prototype.events = {
  message(event) {
    if (!this.isProtocolSupported()) {
      return;
    }

    const {
      identifier,
      message,
      reason,
      reconnect,
      type
    } = JSON.parse(event.data);

    switch (type) {
      case message_types.welcome:
        this.monitor.recordConnect();
        return this.subscriptions.reload();

      case message_types.disconnect:
        logger.log(`Disconnecting. Reason: ${reason}`);
        return this.close({
          allowReconnect: reconnect
        });

      case message_types.ping:
        return this.monitor.recordPing();

      case message_types.confirmation:
        return this.subscriptions.notify(identifier, "connected");

      case message_types.rejection:
        return this.subscriptions.reject(identifier);

      default:
        return this.subscriptions.notify(identifier, "received", message);
    }
  },

  open() {
    logger.log(`WebSocket onopen event, using '${this.getProtocol()}' subprotocol`);
    this.disconnected = false;

    if (!this.isProtocolSupported()) {
      logger.log("Protocol is unsupported. Stopping monitor and disconnecting.");
      return this.close({
        allowReconnect: false
      });
    }
  },

  close(event) {
    logger.log("WebSocket onclose event");

    if (this.disconnected) {
      return;
    }

    this.disconnected = true;
    this.monitor.recordDisconnect();
    return this.subscriptions.notifyAll("disconnected", {
      willAttemptReconnect: this.monitor.isRunning()
    });
  },

  error() {
    logger.log("WebSocket onerror event");
  }

};
var Connection$1 = Connection;

// A new subscription is created through the ActionCable.Subscriptions instance available on the consumer.
// It provides a number of callbacks and a method for calling remote procedure calls on the corresponding
// Channel instance on the server side.
//
// An example demonstrates the basic functionality:
//
//   App.appearance = App.cable.subscriptions.create("AppearanceChannel", {
//     connected() {
//       // Called once the subscription has been successfully completed
//     },
//
//     disconnected({ willAttemptReconnect: boolean }) {
//       // Called when the client has disconnected with the server.
//       // The object will have an `willAttemptReconnect` property which
//       // says whether the client has the intention of attempting
//       // to reconnect.
//     },
//
//     appear() {
//       this.perform('appear', {appearing_on: this.appearingOn()})
//     },
//
//     away() {
//       this.perform('away')
//     },
//
//     appearingOn() {
//       $('main').data('appearing-on')
//     }
//   })
//
// The methods #appear and #away forward their intent to the remote AppearanceChannel instance on the server
// by calling the `perform` method with the first parameter being the action (which maps to AppearanceChannel#appear/away).
// The second parameter is a hash that'll get JSON encoded and made available on the server in the data parameter.
//
// This is how the server component would look:
//
//   class AppearanceChannel < ApplicationActionCable::Channel
//     def subscribed
//       current_user.appear
//     end
//
//     def unsubscribed
//       current_user.disappear
//     end
//
//     def appear(data)
//       current_user.appear on: data['appearing_on']
//     end
//
//     def away
//       current_user.away
//     end
//   end
//
// The "AppearanceChannel" name is automatically mapped between the client-side subscription creation and the server-side Ruby class name.
// The AppearanceChannel#appear/away public methods are exposed automatically to client-side invocation through the perform method.
const extend = function (object, properties) {
  if (properties != null) {
    for (let key in properties) {
      const value = properties[key];
      object[key] = value;
    }
  }

  return object;
};

class Subscription {
  constructor(consumer, params = {}, mixin) {
    this.consumer = consumer;
    this.identifier = JSON.stringify(params);
    extend(this, mixin);
  } // Perform a channel action with the optional data passed as an attribute


  perform(action, data = {}) {
    data.action = action;
    return this.send(data);
  }

  send(data) {
    return this.consumer.send({
      command: "message",
      identifier: this.identifier,
      data: JSON.stringify(data)
    });
  }

  unsubscribe() {
    return this.consumer.subscriptions.remove(this);
  }

}

// The only method intended to be triggered by the user is ActionCable.Subscriptions#create,
// and it should be called through the consumer like so:
//
//   App = {}
//   App.cable = ActionCable.createConsumer("ws://example.com/accounts/1")
//   App.appearance = App.cable.subscriptions.create("AppearanceChannel")
//
// For more details on how you'd configure an actual channel subscription, see ActionCable.Subscription.

class Subscriptions {
  constructor(consumer) {
    this.consumer = consumer;
    this.subscriptions = [];
  }

  create(channelName, mixin) {
    const channel = channelName;
    const params = typeof channel === "object" ? channel : {
      channel
    };
    const subscription = new Subscription(this.consumer, params, mixin);
    return this.add(subscription);
  } // Private


  add(subscription) {
    this.subscriptions.push(subscription);
    this.consumer.ensureActiveConnection();
    this.notify(subscription, "initialized");
    this.sendCommand(subscription, "subscribe");
    return subscription;
  }

  remove(subscription) {
    this.forget(subscription);

    if (!this.findAll(subscription.identifier).length) {
      this.sendCommand(subscription, "unsubscribe");
    }

    return subscription;
  }

  reject(identifier) {
    return this.findAll(identifier).map(subscription => {
      this.forget(subscription);
      this.notify(subscription, "rejected");
      return subscription;
    });
  }

  forget(subscription) {
    this.subscriptions = this.subscriptions.filter(s => s !== subscription);
    return subscription;
  }

  findAll(identifier) {
    return this.subscriptions.filter(s => s.identifier === identifier);
  }

  reload() {
    return this.subscriptions.map(subscription => this.sendCommand(subscription, "subscribe"));
  }

  notifyAll(callbackName, ...args) {
    return this.subscriptions.map(subscription => this.notify(subscription, callbackName, ...args));
  }

  notify(subscription, callbackName, ...args) {
    let subscriptions;

    if (typeof subscription === "string") {
      subscriptions = this.findAll(subscription);
    } else {
      subscriptions = [subscription];
    }

    return subscriptions.map(subscription => typeof subscription[callbackName] === "function" ? subscription[callbackName](...args) : undefined);
  }

  sendCommand(subscription, command) {
    const {
      identifier
    } = subscription;
    return this.consumer.send({
      command,
      identifier
    });
  }

}

// the ActionCable.ConnectionMonitor will ensure that its properly maintained through heartbeats and checking for stale updates.
// The Consumer instance is also the gateway to establishing subscriptions to desired channels through the #createSubscription
// method.
//
// The following example shows how this can be set up:
//
//   App = {}
//   App.cable = ActionCable.createConsumer("ws://example.com/accounts/1")
//   App.appearance = App.cable.subscriptions.create("AppearanceChannel")
//
// For more details on how you'd configure an actual channel subscription, see ActionCable.Subscription.
//
// When a consumer is created, it automatically connects with the server.
//
// To disconnect from the server, call
//
//   App.cable.disconnect()
//
// and to restart the connection:
//
//   App.cable.connect()
//
// Any channel subscriptions which existed prior to disconnecting will
// automatically resubscribe.

class Consumer {
  constructor(url) {
    this._url = url;
    this.subscriptions = new Subscriptions(this);
    this.connection = new Connection$1(this);
  }

  get url() {
    return createWebSocketURL(this._url);
  }

  send(data) {
    return this.connection.send(data);
  }

  connect() {
    return this.connection.open();
  }

  disconnect() {
    return this.connection.close({
      allowReconnect: false
    });
  }

  ensureActiveConnection() {
    if (!this.connection.isActive()) {
      return this.connection.open();
    }
  }

}
function createWebSocketURL(url) {
  if (typeof url === "function") {
    url = url();
  }

  if (url && !/^wss?:/i.test(url)) {
    const a = document.createElement("a");
    a.href = url; // Fix populating Location properties in IE. Otherwise, protocol will be blank.

    a.href = a.href;
    a.protocol = a.protocol.replace("http", "ws");
    return a.href;
  } else {
    return url;
  }
}

function createConsumer(url = getConfig("url") || INTERNAL.default_mount_path) {
  return new Consumer(url);
}
function getConfig(name) {
  const element = document.head.querySelector(`meta[name='action-cable-${name}']`);

  if (element) {
    return element.getAttribute("content");
  }
}

var index = /*#__PURE__*/Object.freeze({
	__proto__: null,
	Connection: Connection$1,
	ConnectionMonitor: ConnectionMonitor$1,
	Consumer: Consumer,
	INTERNAL: INTERNAL,
	Subscription: Subscription,
	Subscriptions: Subscriptions,
	adapters: adapters,
	createWebSocketURL: createWebSocketURL,
	logger: logger,
	createConsumer: createConsumer,
	getConfig: getConfig
});
