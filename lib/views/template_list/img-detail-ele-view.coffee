# {Disposable, CompositeDisposable} = require 'atom'
{$$, TextEditorView, View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'

global_callback = null

module.exports =
class ImgSourceElementPanel extends View


  @content: (@fa_view, name)->
    @tr =>
      @td =>
        @span outlet: 'ele_name', class: 'text-info icon icon-diff-added', name
      @td class:'btn-td', align:"right", =>
        # @button class:'btn btn-info',click:'do_edit',"Edit"
        @button class:'btn btn-error',click:'do_remove',"Remove"

  initialize: (@fa_view, @name)->
    # @disposable = new CompositeDisposable
    @ele_name.on "click" ,=>
      @fa_view.show_detail_img(@name)


  do_remove: ->
    @fa_view.remove_detail_callback(@name)

  show_detail: ->


  # Tear down any state and detach
  destroy: ->
    # @disposable?.dispose()
    @detach()

  # dispose: ->
  #   @disposable?.dispose()
