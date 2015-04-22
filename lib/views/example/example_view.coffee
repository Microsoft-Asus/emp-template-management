{$, $$, $$$, View} = require 'atom-space-pen-views'
require './space-pen-extensions'

module.exports =
class ExampleView  extends View
  @content: (html) =>
    @div class: 'example', =>
      @exampleHtml html

  initialize: (html)->
    console.log html
