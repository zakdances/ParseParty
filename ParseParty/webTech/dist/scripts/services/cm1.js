(function () {
  'use strict';
  var __hasProp = {}.hasOwnProperty, __extends = function (child, parent) {
      for (var key in parent) {
        if (__hasProp.call(parent, key))
          child[key] = parent[key];
      }
      function ctor() {
        this.constructor = child;
      }
      ctor.prototype = parent.prototype;
      child.prototype = new ctor();
      child.__super__ = parent.prototype;
      return child;
    };
  angular.module('ParsePartyApp.services').factory('cm1', [
    'CodeMirrorWrapper',
    '$q',
    'jsBridge',
    function (CodeMirrorWrapper, $q, jsBridge) {
      var MyCM, e, instance;
      MyCM = function (_super) {
        __extends(MyCM, _super);
        function MyCM() {
          var _this = this;
          MyCM.__super__.constructor.call(this, { CodeMirror: CodeMirror });
          this._deferred = $q.defer();
          this.ready = this._deferred.promise.then(function (cm) {
            _this.cm(cm);
            return _this;
          });
        }
        return MyCM;
      }(CodeMirrorWrapper);
      try {
        instance = new MyCM();
      } catch (_error) {
        e = _error;
        jsBridge.then(function (jsBridge) {
          jsBridge.send('cm1 making error: ' + String(e));
        });
      }
      return instance;
    }
  ]).factory('cm1OpsQueue', [
    '$q',
    'CMOpsQueue',
    'jsBridge',
    function ($q, CMOpsQueue, jsBridge) {
      return new CMOpsQueue();
    }
  ]).factory('CMOpsQueue', [
    '$q',
    'jsBridge',
    function ($q, jsBridge) {
      var CMOpsQueue_;
      CMOpsQueue_ = function () {
        function CMOpsQueue_() {
          this._lastOp = null;
        }
        CMOpsQueue_.prototype.lastOp = function (op) {
          if (op) {
            this._lastOp = op.p;
          }
          if (this._lastOp) {
            return this._lastOp;
          } else {
            return $q.when();
          }
        };
        CMOpsQueue_.prototype.swapOut = function (op) {
          var lastOp;
          lastOp = this.lastOp();
          this.lastOp(op);
          return lastOp;
        };
        return CMOpsQueue_;
      }();
      return CMOpsQueue_;
    }
  ]).factory('cm1Repo', [
    '$q',
    'jsBridge',
    function ($q, jsBridge) {
      var CM1Repo_;
      CM1Repo_ = function (_super) {
        __extends(CM1Repo_, _super);
        function CM1Repo_() {
          CM1Repo_.__super__.constructor.call(this, 100);
        }
        return CM1Repo_;
      }(MGITRepository);
      return new CM1Repo_();
    }
  ]);
}.call(this));