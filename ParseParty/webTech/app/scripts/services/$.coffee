'use strict'

angular.module('ParsePartyApp.services')
.factory('$', () ->
	$
)
.factory('JQuery', () ->
	JQuery
)
.factory('JQueryReady', ($q, $) ->
	d = $q.defer()
	$ ->
		d.resolve $
	d.promise
)