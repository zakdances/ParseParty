'use strict'

describe 'Service: Parsecodemirror', () ->

  # load the service's module
  beforeEach module 'parsePartyApp'

  # instantiate service
  Parsecodemirror = {}
  beforeEach inject (_Parsecodemirror_) ->
    Parsecodemirror = _Parsecodemirror_

  it 'should do something', () ->
    expect(!!Parsecodemirror).toBe true
