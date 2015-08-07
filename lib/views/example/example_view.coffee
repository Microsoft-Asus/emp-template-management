{$, $$, $$$, View} = require 'atom-space-pen-views'
require './space-pen-extensions'

module.exports =
class ExampleView  extends View
  @content: (html, spec_grammar) =>
    @div class: 'example', =>
      @exampleHtml html, spec_grammar

  initialize: (html)->
    # console.log html
