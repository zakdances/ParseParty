(function () {
  'use strict';
  angular.module('ParsePartyApp.services').factory('jsBridge', [
    '$q',
    function ($q) {
      var d, onBridgeReady;
      d = $q.defer();
      onBridgeReady = function (event) {
        var bridge;
        bridge = event.bridge;
        bridge.init();
        return d.resolve(bridge);
      };
      document.addEventListener('WebViewJavascriptBridgeReady', onBridgeReady, false);
      return d.promise;
    }
  ]);
}.call(this));