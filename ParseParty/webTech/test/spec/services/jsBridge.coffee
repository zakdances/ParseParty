'use strict'

describe 'Service: Jsbridge', () ->

  # load the service's module
  beforeEach module 'parsePartyApp'

  # instantiate service
  Jsbridge = {}
  beforeEach inject (_Jsbridge_) ->
    Jsbridge = _Jsbridge_

  it 'should do something', () ->
    expect(!!Jsbridge).toBe true
