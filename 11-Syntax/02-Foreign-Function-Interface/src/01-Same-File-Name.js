export const basicValue = 4.0;

export function basicEffect() {
  return 4.0;
}

export function basicCurriedFunction(number) {
  return number * 4.0;
}

export function threeArgCurriedFunction(arg1) {
  return function(arg2) {
    return function(arg3) {
      // body of function
      return arg1 * arg2 * arg3;
    };
  };
}

export function curriedFunctionProducingEffect(string) {
  return function() {
    return string;
  };
}

export function threeArgUncurriedFunction(a, b, c) {
  return a + b + c;
}

export function twoArgUncurriedEffectfulFunction(a, b) {
  return a + b + ((Math.random() * 10) | 0);
}

var twoArgFunction = function(arg1, arg2) {
  console.log(arg1 + " " + arg2);
};

export {twoArgFunction as twoArgCurriedFunctionImpl};
