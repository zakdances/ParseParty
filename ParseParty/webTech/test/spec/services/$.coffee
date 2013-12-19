'use strict'

describe 'Service: ', () ->

  # load the service's module
  beforeEach module 'parsePartyApp'

  # instantiate service
   = {}
  beforeEach inject (__) ->
     = __

  it 'should do something', () ->
    expect(!!).toBe true
