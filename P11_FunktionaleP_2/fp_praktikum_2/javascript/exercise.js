//
// Functional JavaScript
//
"use strict";
//log("to", "console");

// Helpers
var add = (a, b) => a+b;
var sqr = (a) => a*a;

// Array.prototype.reduce with function parameter
// (the run-function is defined below)
run('[0, 1, 2, 3, 4].reduce( function(prev,curr){ return prev + curr; } )');

// ES6 version
run('[0, 1, 2, 3, 4].reduce( (prev, curr) => prev + curr )');

// Array.prototype.filter
run('[0, 1, 2, 3, 4].filter( (curr) => curr%2==0 )');

// Filtering with reduce
run('[0, 1, 2, 3, 4].reduce( (prev, curr) => curr%2==0 ? prev.concat(curr) : prev, [])');

// Array.prototype.map
run('[0, 1, 2, 3, 4].map( (curr) => curr*curr )');

// Mapping with reduce
// ...


// Curried version of reduce
run('var reduce = curry((fun,init,arr) => arr.reduce(fun, init));',false);
var reduce = curry((fun,init,arr) => arr.reduce(fun, init));

// Define sumlist with this version of reduce
run('var sumlist = reduce(add)(0);',false);
var sumlist = reduce(add)(0);

// Try sumlist
run('sumlist([1,2,3,4,5])');


// Curried version of map
run('var map = (fn) => reduce((prev, curr) => prev.concat(fn(curr)), []);',false);
var map = (fn) => reduce((prev, curr) => prev.concat(fn(curr)), []);

// Try this version of map
// ...


// Tail recursive factorial, partial recursive call
function factorial (n, res=1) {
  if (n < 2) return res;
  else return partial(factorial, n-1, n*res);
}

// Try the factorial function
run('typeof factorial(4)');
run('typeof factorial(4)()');
run('typeof factorial(4)()()');
run('typeof factorial(4)()()()');
run('factorial(4)()()()');


// Recursive tests for even and odd numbers
function iseven (n) { 
  if (n === 0) return true; 
  else return isodd(Math.abs(n) - 1); 
}
function isodd (n) { 
  if (n === 0) return false; 
  else return iseven(Math.abs(n) - 1); 
}

run('iseven(15)');
run('isodd(15)');


/** 
 *  Curry
 *  create a curried version of a function
 *  (source: Currying in JavaScript, medium.com)
 */
function curry (fn) {
  var arity = fn.length;
  return (function resolver () {
    var memory = Array.prototype.slice.call(arguments);
    return function () {
      var local = memory.slice(), next;
      Array.prototype.push.apply( local, arguments );
      next = local.length >= arity ? fn : resolver;
      return next.apply(null, local);
    };
  }());
}

/**
 *  Partial
 *  partial application of a function
 *  (based on: Functional JavaScript by Michael Fogus from O'Reilly)
 */
function partial (fun /*, pargs */) {
  var pargs = Array.prototype.slice.call(arguments,1);
  return function (/* arguments */) {
    var args = pargs.concat(Array.prototype.slice.call(arguments)); 
    return fun.apply(fun, args);
  }; 
}

/**
  *  Trampoline
  *  (based on: Functional JavaScript by Michael Fogus from O'Reilly)
  */
function trampoline (fun /*, arguments */) {
  var result = fun.apply(fun, Array.prototype.slice.call(arguments,1));
  // ... 
}

/**
  *  Helper to print statement and it's result
  */
function run (stmt, evaluate) {
  log('> '+stmt, 'span');
  if (evaluate!==false) log(eval(stmt));
}
