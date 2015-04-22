{$$, TextEditorView, View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'


module.exports =
class CbbElementPanel extends View


  @content: (@fa_view, name, hide_flag)->
    @tr =>
      @td =>
        @span outlet: 'ele_name', class: 'text-info icon icon-diff-added', name
      if !hide_flag
        @td class:'btn-td', align:"right", =>
          @button class:'btn btn-info',click:'do_edit',"Edit"
          @button class:'btn btn-error',click:'do_remove',"Remove"

  initialize: (@fa_view, @name)->

  do_edit: ->
    @fa_view.do_edit_callback(@name)

  # 在父级编辑完成编辑后回调
  over_edit_callback: (@name)->
    # console.log @ele_name
    @ele_name.text @name


  do_remove: ->
    @fa_view.remove_td_callback(@name)
    @destroy()

  # Tear down any state and detach
  destroy: ->
    @detach()
