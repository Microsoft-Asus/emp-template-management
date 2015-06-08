{CompositeDisposable} = require 'atom'
{$, $$, TextEditorView, View} = require 'atom-space-pen-views'
# _ = require 'underscore-plus'

module.exports =
class TutorialPanel extends View
  @content: (msg)->
    @section class: 'section settings-panel', =>
      @div class: 'section-container', =>
        @div class: "block section-heading icon icon-gear", "Tutorial:#{msg}"
        @div class: 'section-body', =>
          @div class: 'control-group', =>
            @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "detail"
                  @div class: 'setting-description', "this is a description~"


  initialize: () ->
    @disposables = new CompositeDisposable()

  detached: ->
    @disposables.dispose()
