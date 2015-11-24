{$$, TextEditorView, View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'

global_callback = null

# cbb resource 的子项
module.exports =
class CbbSourceElementPanel extends View


  @content: (@fa_view, name)->
    @tr =>
      @td =>
        @span outlet: 'ele_name', class: 'text-info icon icon-diff-added', name
      @td class:'btn-td', align:"right", =>
        # @button class:'btn btn-info',click:'do_edit',"Edit"
        @button class:'btn btn-error',click:'do_remove',"Remove"

  initialize: (@fa_view, @name, @type)->


  do_remove: ->
    if @type is emp.EMP_DETAIL_ELE_VIEW
      # global_callback(@name)
      @fa_view.remove_detail_callback(@name)
    else
      @fa_view.remove_td_callback(@name)
    @destroy()

  # Tear down any state and detach
  destroy: ->
    @detach()
