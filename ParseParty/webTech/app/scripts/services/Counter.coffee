'use strict'
angular.module('ParsePartyApp.services')
.factory('Counter', () ->
	class Counter
		constructor: (args={}) ->

			@i = args.i ? NaN
			@end = args.end ? NaN

		incrimentSafelyTo: (new_i) ->
			# @i = if new_i? and new_i > @i then new_i else @i + 1
			if new_i? and new_i > @i
				@i = new_i
			else
				@i = @i + 1
			return

	Counter
)
