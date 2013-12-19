(function () {
  'use strict';
  angular.module('ParsePartyApp.directives').directive('codeMirror', [
    'cm1',
    'jsBridge',
    function (cm1, jsBridge) {
      return function (scope, el, attrs) {
        var cm, d, e, myCM;
        try {
          d = cm1._deferred;
          myCM = cm1.CodeMirror;
          el.css({
            width: '100%',
            height: '100%'
          });
          cm = myCM(el[0], {
            lineNumbers: true,
            autofocus: true,
            autoCloseBrackets: true
          });
          $('.CodeMirror').css({
            'width': '100%',
            'height': '100%'
          });
          d.resolve(cm);
        } catch (_error) {
          e = _error;
          jsBridge.then(function (jsBridge) {
            jsBridge.send(String(e));
          });
        }
      };
    }
  ]);
}.call(this));