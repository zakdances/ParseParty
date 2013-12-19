'use strict'

describe 'Service: Main', () ->

  # load the service's module
  beforeEach module 'parsePartyApp'

  # instantiate service
  Main = {}
  beforeEach inject (_Main_) ->
    Main = _Main_

  it 'should do something', () ->
    expect(!!Main).toBe true
