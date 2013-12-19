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
  angular.module('ParsePartyApp.services').factory('CMOperation', [
    '$q',
    'jsBridge',
    function ($q, jsBridge) {
      var CMOperation;
      CMOperation = function () {
        function CMOperation(_cm, type) {
          var _this = this;
          this._cm = _cm;
          if (type == null) {
            type = 'none';
          }
          if (!this._cm) {
            throw 'ERROR: An operation must be initialized with a CodeMirror wrapper as the first and only argument. ' + JSON.stringify(this._cm) + ' is invalid.';
          }
          this.type = function () {
            return type;
          };
          this._d = $q.defer();
          this.p = this._d.promise.then(function (arg) {
            jsBridge.then(function (jsBridge) {
              jsBridge.send(_this.type() + ' op starting...');
            });
            return arg;
          });
          this.p.then(function () {
          }, function (error) {
            jsBridge.then(function (jsBridge) {
              jsBridge.send(_this.type() + '\'s deferred rejected with error: ' + error);
            });
            return error;
          });
          this.p['finally'](function () {
            jsBridge.then(function (jsBridge) {
              return jsBridge.send(_this.type() + ' op has completed.');
            });
          });
        }
        CMOperation.errorPromise = function (e, d) {
          if (d == null) {
            d = $q.defer();
          }
          jsBridge.then(function (jsBridge) {
            jsBridge.send(String(e));
          });
          d.reject(String(e));
          return d.promise;
        };
        return CMOperation;
      }();
      return CMOperation;
    }
  ]).factory('CMRangeOp', [
    'CMOperation',
    '$q',
    'jsBridge',
    function (CMOperation, $q, jsBridge) {
      var CMRangeOp;
      CMRangeOp = function (_super) {
        __extends(CMRangeOp, _super);
        function CMRangeOp(cm) {
          CMRangeOp.__super__.constructor.call(this, cm);
          this.type = function () {
            return 'range';
          };
          this.p = this.p.then(function (_arg) {
            var c, e, r, s, type;
            r = _arg.range, s = _arg.string, e = _arg.event, type = _arg.type, c = _arg.commit;
            return function (p, cs, oldString, data) {
              var args, d;
              try {
                r = function () {
                  if (r && r.location != null && r.length != null) {
                    return new CSRange(r);
                  } else {
                    throw 'ERROR: Requested range ' + JSON.stringify(r) + ' is invalid.';
                  }
                }();
                cs = cm.getRange(r);
                if (s != null && s !== cs) {
                  d = $q.defer();
                  p = d.promise;
                  cm.signals.change.next().then(function () {
                    d.resolve();
                  });
                  args = {};
                  args.string = s;
                  args.range = r;
                  if (e) {
                    args.event = e;
                  }
                  cm.operation(function () {
                    cm.replaceCharacters(args);
                  });
                  oldString = cs;
                  cs = cm.getRange(new CSRange(r.location, s.length));
                } else if (s != null) {
                  jsBridge.then(function (jsBridge) {
                    jsBridge.send('Doc content is the same. Ignoring.');
                  });
                }
                data.type = type;
                data.commit = c;
                data.string = cs;
                if (oldString != null) {
                  data.oldString = oldString;
                }
                p = (p != null ? p : $q.when()).then(function () {
                  return data;
                });
              } catch (_error) {
                e = _error;
                return CMOperation.errorPromise(e);
              }
              return p;
            }(null, null, null, {});
          });
        }
        return CMRangeOp;
      }(CMOperation);
      return CMRangeOp;
    }
  ]).factory('CMParseRangeOp', [
    'CMOperation',
    'jsBridge',
    function (CMOperation, jsBridge) {
      var CMParseRangeOp;
      CMParseRangeOp = function (_super) {
        __extends(CMParseRangeOp, _super);
        function CMParseRangeOp(cm) {
          CMParseRangeOp.__super__.constructor.call(this, cm);
          this.type = function () {
            return 'parse';
          };
          this.p = this.p.then(function (_arg) {
            var c, data, e, parseData, r, range, tokens, type;
            r = _arg.range, type = _arg.type, c = _arg.commit;
            try {
              r = function () {
                if (r) {
                  return new CSRange(r);
                } else {
                  throw 'ERROR: Range ' + JSON.stringify(r) + ' is invalid.';
                }
              }();
              parseData = cm.parse(r);
              tokens = parseData.tokens;
              range = cm.constructor.globalRangeOfTokens(tokens);
              data = {};
              data.type = type;
              data.commit = c;
              data.tokens = tokens;
            } catch (_error) {
              e = _error;
              return CMOperation.errorPromise(e);
            }
            return data;
          });
        }
        return CMParseRangeOp;
      }(CMOperation);
      return CMParseRangeOp;
    }
  ]).factory('CMSelectedRangesOp', [
    'CMOperation',
    '$q',
    'jsBridge',
    function (CMOperation, $q, jsBridge) {
      var CMSelectedRangesOp;
      CMSelectedRangesOp = function (_super) {
        __extends(CMSelectedRangesOp, _super);
        function CMSelectedRangesOp(cm) {
          CMSelectedRangesOp.__super__.constructor.call(this, cm);
          this.type = function () {
            return 'selectedRanges';
          };
          this.p = this.p.then(function (_arg) {
            var c, crs, d, e, oldRanges, p, r, rs, type;
            rs = _arg.ranges, type = _arg.type, c = _arg.commit;
            try {
              p = null;
              crs = cm.selectedRanges();
              if (rs) {
                r = rs[0];
                if (r && r.location != null && r.length != null && (r.direction === 'up' || r.direction === 'down')) {
                  r = new CSRange(r);
                  if (!cm.constructor.areSelectedRangesEqual(r, crs)) {
                    d = $q.defer();
                    p = d.promise;
                    cm.signals.cursorActivity.next().then(function () {
                      d.resolve();
                    });
                    oldRanges = crs;
                    crs = cm.selectedRanges(r);
                  }
                } else {
                  throw 'ERROR: Range ' + JSON.stringify(r) + ' is not a valid range.';
                }
              }
              p = function (data) {
                data.type = type;
                data.commit = c;
                data.ranges = [].concat(crs);
                if (oldRanges) {
                  data.oldRanges = [].concat(oldRanges);
                }
                return (p != null ? p : $q.when()).then(function (arg) {
                  return data;
                });
              }({});
            } catch (_error) {
              e = _error;
              return CMOperation.errorPromise(e);
            }
            return p;
          });
        }
        return CMSelectedRangesOp;
      }(CMOperation);
      return CMSelectedRangesOp;
    }
  ]).factory('CMModeOp', [
    'CMOperation',
    'jsBridge',
    function (CMOperation, jsBridge) {
      var CMModeOp_;
      CMModeOp_ = function (_super) {
        __extends(CMModeOp_, _super);
        function CMModeOp_(cm) {
          CMModeOp_.__super__.constructor.call(this, cm);
          this.type = function () {
            return 'mode';
          };
          this.p = this.p.then(function (_arg) {
            var currentMode, data, e, fromMode, m, type;
            m = _arg.mode, type = _arg.type;
            try {
              if (m === 'scss') {
                m = 'text/x-scss';
              }
              currentMode = cm.getMode().name;
              if (m !== currentMode) {
                cm.setOption('mode', m);
                fromMode = currentMode;
                jsBridge.then(function (jsBridge) {
                  jsBridge.send('mode changed to ' + cm.getMode().name);
                });
              }
              data = {};
              data.type = type;
              data.mode = cm.getMode().name;
              if (fromMode) {
                data.fromMode = fromMode;
              }
            } catch (_error) {
              e = _error;
              return CMOperation.errorPromise(e);
            }
            return data;
          });
        }
        return CMModeOp_;
      }(CMOperation);
      return CMModeOp_;
    }
  ]).factory('CMTokenizeOp', [
    'CMOperation',
    'jsBridge',
    function (CMOperation, jsBridge) {
      var CMTokenizeOp;
      CMTokenizeOp = function (_super) {
        __extends(CMTokenizeOp, _super);
        function CMTokenizeOp(cm) {
          CMTokenizeOp.__super__.constructor.call(this, cm);
          this.type = function () {
            return 'tokenize';
          };
          this.p = this.p.then(function (_arg) {
            var data, e, m, s, type;
            m = _arg.mode, s = _arg.string, type = _arg.type;
            try {
              if (s == null) {
                throw 'ERROR: String ' + JSON.stringify(s) + ' is not valid.';
              }
              if (m == null) {
                throw 'ERROR: Mode ' + JSON.stringify(m) + ' is not valid.';
              }
              data = {};
              data.type = type;
              data.tokens = cm.tokenize(s, m);
            } catch (_error) {
              e = _error;
              return CMOperation.errorPromise(e);
            }
            return data;
          });
        }
        return CMTokenizeOp;
      }(CMOperation);
      return CMTokenizeOp;
    }
  ]).factory('CMDocLengthOp', [
    'CMOperation',
    'jsBridge',
    function (CMOperation, jsBridge) {
      var CMDocLengthOp;
      CMDocLengthOp = function (_super) {
        __extends(CMDocLengthOp, _super);
        function CMDocLengthOp(cm) {
          CMDocLengthOp.__super__.constructor.call(this, cm);
          this.type = function () {
            return 'docLength';
          };
          this.p = this.p.then(function (_arg) {
            var data, e, type;
            type = _arg.type;
            try {
              data = {};
              data.type = type;
              data.length = cm.doc.getValue().length;
            } catch (_error) {
              e = _error;
              return CMOperation.errorPromise(e);
            }
            return data;
          });
        }
        return CMDocLengthOp;
      }(CMOperation);
      return CMDocLengthOp;
    }
  ]);
}.call(this));