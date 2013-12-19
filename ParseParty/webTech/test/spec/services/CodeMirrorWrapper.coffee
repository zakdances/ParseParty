'use strict'

describe 'Service: Codemirrorwrapper', () ->

  # load the service's module
  beforeEach module 'parsePartyApp'

  # instantiate service
  Codemirrorwrapper = {}
  beforeEach inject (_Codemirrorwrapper_) ->
    Codemirrorwrapper = _Codemirrorwrapper_

  it 'should do something', () ->
    expect(!!Codemirrorwrapper).toBe true
