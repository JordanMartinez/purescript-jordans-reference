// don't forget to add this line here!
"use strict";

exports.basicValue = 4.0;

exports.basicCurriedFunction = function(number) {
  return number * 4.0;
};

exports.basicEffect = function() {
  return 4.0;
};

exports.threeArgCurriedFunction = function(arg1) {
  return function(arg2) {
    return function(arg3) {
      // body of function
      return arg1 * arg2 * arg3;
    };
  };
};

exports.curriedFunctionProducingEffect = function(string) {
  return function() {
    return string;
  };
};

exports.basicUncurriedFunction = function(fn) {
  return function(arg1) {
    return function(arg2) {
      return fn(arg1)(arg2)();
    };
  };
};

var twoArgFunction = function(arg1, arg2) {
  console.log(arg1 + " " + arg2);
};

exports.twoArgCurriedFunctionImpl = twoArgFunction;
