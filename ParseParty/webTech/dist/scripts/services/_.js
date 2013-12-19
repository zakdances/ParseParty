(function () {
  'use strict';
  angular.module('ParsePartyApp.services').factory('_', [
    'jsBridge',
    function (jsBridge) {
      jsBridge.then(function (jsBridge) {
        jsBridge.send('thing ' + JSON.stringify(window._) + ' ' + JSON.stringify(_));
      });
      return window._;
    }
  ]);
}.call(this));