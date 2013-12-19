'use strict'
angular.module('ParsePartyApp.services')
.factory('jsBridge', ($q) ->

	d = $q.defer()

	onBridgeReady = (event) ->
		bridge 		= event.bridge
		bridge.init()
		d.resolve bridge

	document.addEventListener 'WebViewJavascriptBridgeReady', onBridgeReady, false

	d.promise
)