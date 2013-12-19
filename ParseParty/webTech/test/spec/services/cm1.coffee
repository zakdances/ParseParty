'use strict'

describe 'Service: Cm1', () ->

  # load the service's module
  beforeEach module 'parsePartyApp'

  # instantiate service
  Cm1 = {}
  beforeEach inject (_Cm1_) ->
    Cm1 = _Cm1_

  it 'should do something', () ->
    expect(!!Cm1).toBe true
