'use strict'

angular.module('ParsePartyApp.services')
.factory('_', (jsBridge) ->
	jsBridge.then (jsBridge) ->
		jsBridge.send 'thing ' + JSON.stringify(window._) + ' ' + JSON.stringify(_)
		return
	window._
)
