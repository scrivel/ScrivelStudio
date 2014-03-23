# global beforeEach, describe, it, assert, expect
"use strict"

describe 'Words Model', ->
  beforeEach ->
    @WordsModel = new Editor.Models.Words();
