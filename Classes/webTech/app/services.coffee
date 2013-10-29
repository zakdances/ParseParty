#### js2coffee version 0.1.3
#### ---- main/services.js
'use strict'

# Services 

# Demonstrate how to register services
# In this case it is a simple value service.
angular.module('myApp.services', [])
# .value( 'version', '0.1' )
.factory('jsBridge', ['$q', ($q) ->

	deferred = $q.defer()

	onBridgeReady = (event) ->
		bridge 		= event.bridge
		bridge.init()
		deferred.resolve bridge

	document.addEventListener 'WebViewJavascriptBridgeReady', onBridgeReady, false

	deferred.promise
])
.factory('CMdi', ['$q', ($q) ->
	$q.defer() 
])
.factory('CMi', ['CMdi', (CMdi) ->
	CMdi.promise 
])
.factory('CM', [() ->
	CodeMirror
])
