# global beforeEach, describe, it, assert, expect
"use strict"

describe 'Script Collection', ->
  beforeEach ->
    @ScriptCollection = new Editor.Collections.Script()
