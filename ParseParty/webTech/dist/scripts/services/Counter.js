(function () {
  'use strict';
  angular.module('ParsePartyApp.services').factory('Counter', function () {
    var Counter;
    Counter = function () {
      function Counter(args) {
        var _ref, _ref1;
        if (args == null) {
          args = {};
        }
        this.i = (_ref = args.i) != null ? _ref : NaN;
        this.end = (_ref1 = args.end) != null ? _ref1 : NaN;
      }
      Counter.prototype.incrimentSafelyTo = function (new_i) {
        if (new_i != null && new_i > this.i) {
          this.i = new_i;
        } else {
          this.i = this.i + 1;
        }
      };
      return Counter;
    }();
    return Counter;
  });
}.call(this));