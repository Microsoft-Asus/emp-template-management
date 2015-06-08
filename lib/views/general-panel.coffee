{View} = require 'atom-space-pen-views'
TutorialPanel = require './tutorial-panel'

module.exports =
class GeneralPanel extends View
  @content: ->
    @div =>
      @form class: 'general-panel section', =>
        @div outlet: "loadingElement", class: 'alert alert-info loading-area icon icon-hourglass', "Loading settings"

  initialize: (msg)->
    @loadingElement.remove()
    #
    @append(new TutorialPanel(msg))
    # @append(new SettingsPanel('editor'))
