(function () {
  'use strict';
  angular.module('ParsePartyApp', [
    'ngRoute',
    'ParsePartyApp.filters',
    'ParsePartyApp.services',
    'ParsePartyApp.directives',
    'ParsePartyApp.controllers'
  ]);
  angular.module('ParsePartyApp.controllers', []);
  angular.module('ParsePartyApp.directives', []);
  angular.module('ParsePartyApp.services', []);
  angular.module('ParsePartyApp.filters', []);
  angular.module('ParsePartyApp').config([
    '$routeProvider',
    'routes',
    function ($routeProvider, routes) {
      var r;
      $routeProvider.when('/', {
        template: '<div code-mirror="5" style="width: 100%; height: 100%;"></div>',
        controller: 'MyCtrl1',
        resolve: function () {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = routes.length; _i < _len; _i++) {
            r = routes[_i];
            if (r.controller === 'MyCtrl1') {
              _results.push(r.resolve);
            }
          }
          return _results;
        }()[0]
      });
    }
  ]);
}.call(this));