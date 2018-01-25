/*
 * This file is part of the Php DDD Standard project.
 *
 * Copyright (c) 2017-present LIN3S <info@lin3s.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Beñat Espiña <benatespina@gmail.com>
 */

import 'picturefill';
import 'objectFitPolyfill';
import 'lin3s-front-foundation/dist/js/esm/polyfill/closest';

if (typeof Promise === 'undefined') {
  require('promise/lib/rejection-tracking').enable(); // eslint-disable-line no-undef
  window.Promise = require('promise/lib/es6-extensions.js'); // eslint-disable-line no-undef
}

if (typeof Array.from === 'undefined') {
  Array.from = require('array-from'); // eslint-disable-line no-undef
}

if (typeof Array.includes === 'undefined') {
  Array.includes = require('array-includes'); // eslint-disable-line no-undef
}

// fetch() polyfill for making API calls.
require('whatwg-fetch');


// TODO This is a temporal solution
if (!Array.prototype.find) {
  Array.prototype.find = function(predicate) { // eslint-disable-line no-extend-native
    if (this === null) {
      throw new TypeError('Array.prototype.find called on null or undefined');
    }
    if (typeof predicate !== 'function') {
      throw new TypeError('predicate must be a function');
    }
    const
      list = Object(this),
      length = list.length >>> 0,
      thisArg = arguments[1];
    let value;

    for (let i = 0; i < length; i++) {
      value = list[i];
      if (predicate.call(thisArg, value, i, list)) { // eslint-disable-line prefer-reflect
        return value;
      }
    }
    return undefined;
  };
}

if (!String.prototype.includes) {
  String.prototype.includes = function(search, start) { // eslint-disable-line no-extend-native
    if (typeof start !== 'number') {
      start = 0;
    }

    if (start + search.length > this.length) {
      return false;
    }

    return this.indexOf(search, start) !== -1;
  };
}

// https://developer.mozilla.org/es/docs/Web/JavaScript/Referencia/Objetos_globales/Math/trunc
Math.trunc = Math.trunc || function(x) {
  return x - x % 1;
};
