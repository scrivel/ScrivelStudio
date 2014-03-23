# global beforeEach, describe, it, assert, expect
"use strict"

describe 'Words View', ->
  beforeEach ->
    @WordsView = new Editor.Views.Words();
