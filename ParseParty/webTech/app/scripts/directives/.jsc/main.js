// Generated by CoffeeScript 1.6.3
(function() {
  'use strict';
  angular.module('ParsePartyApp.directives').directive('codeMirror', function(cmDeferred, jsBridge) {
    return function(scope, el, attrs) {
      var cm, d, e;
      d = cmDeferred;
      el.css({
        'width': '100%',
        'height': '100%'
      });
      try {
        cm = CM(el[0], {
          lineNumbers: true,
          autofocus: true,
          autoCloseBrackets: true
        });
        $('.CodeMirror').css({
          'width': '100%',
          'height': '100%'
        });
      } catch (_error) {
        e = _error;
        console.log(String(e));
      }
      d.resolve(cm);
    };
  });

}).call(this);
