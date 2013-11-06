root = exports ? this

class NSRange
	constructor: (@location=0, @length=0) ->

	maxEdge: () ->
		@location + @length
	# intersectsWith: () ->
	# 	return

class NSAttributedRange extends NSRange
	constructor: (@location=0, @length=0, @attributes={}) ->

	# maxEdge: () ->
	# 	@location + @length

root.NSRange 			= NSRange
root.NSAttributedRange 	= NSAttributedRange