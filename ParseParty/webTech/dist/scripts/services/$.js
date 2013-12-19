(function () {
  'use strict';
  angular.module('ParsePartyApp.services').factory('$', function () {
    return $;
  }).factory('JQuery', function () {
    return JQuery;
  }).factory('JQueryReady', [
    '$q',
    '$',
    function ($q, $) {
      var d;
      d = $q.defer();
      $(function () {
        return d.resolve($);
      });
      return d.promise;
    }
  ]);
}.call(this));