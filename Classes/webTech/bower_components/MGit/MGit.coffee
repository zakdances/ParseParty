root = exports ? this



class MGITRepository
	constructor: (@commits=[], @capacity=100) ->

	stageAndCommit: (change) ->
		@commits.shift() if @commits.length >= @capacity
		@commits.push change




class UUID
	constructor: (@UUIDString=UUID._generateUUIDString()) ->

	@_generateUUIDString: () ->
		uuid.v1()

class Commit # refererd to as a "change" before it's been merged
	constructor: (@id=new UUID()) ->
		@synced = false

	# Subclasses should override this method to create a new change from a JSON string or object.
	@fromJSON: (data) ->

	# Subclasses should override this method to serialization the change/commit to JSON.
	toJSON: () ->







