{View} = require 'atom-space-pen-views'
CbbToolPanel = require './cbb_setting/cbb-tool-setting-ele-panel'
emp = require '../exports/emp'

module.exports =
class CbbToolSettingPanel extends View
  @content: ->
    @div =>
      @form class: 'general-panel section', =>
        @div outlet: "loadingElement", class: 'alert alert-info loading-area icon icon-hourglass', "Loading settings"
      @section class: 'section settings-panel', =>
        @div outlet:"section_container", class: 'section-container', =>
          @div class: "block section-heading icon icon-gear", "CBB Toolbar Setting"
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  # @div class: 'setting-description', "保存全部"
                  @button click:'do_save_all', class:'btn',"Save All Changes"
          @div outlet:"section_container_detail"

          # @section outlet:'package_list', class: 'sub-section installed-packages', =>
          #   @h3 class: 'sub-section-heading icon icon-package', =>
          #     @text 'Installed Packages'
          #     @span outlet: 'templateCount', class:'section-heading-count', ' (…)'
          #   @div outlet: 'templatePackages', class: 'container package-container', =>
          #     @div class: 'alert alert-info loading-area icon icon-hourglass', "Loading packages…"

  initialize: (msg)->
    @loadingElement.remove()
    # @cbb_management = atom.project.cbb_management
    # # @packs = @cbb_management.get_pacakges()
    # @cbb_tools = @cbb_management.get_tool_detail()
    # # console.log @cbb_tools
    # # for tool_name, tool_obj of @cbb_tools
    #   # new CbbToolPanel(tool_name,tool_obj)
    #
    # tool_view_1 = new CbbToolPanel(emp.TOOL_FIRST, @cbb_tools[emp.TOOL_FIRST])
    # tool_view_2 = new CbbToolPanel(emp.TOOL_SECOND, @cbb_tools[emp.TOOL_SECOND])
    # tool_view_3 = new CbbToolPanel(emp.TOOL_THIRD, @cbb_tools[emp.TOOL_THIRD])
    # tool_view_4 = new CbbToolPanel(emp.TOOL_FOURTH, @cbb_tools[emp.TOOL_FOURTH])
    #
    # @tool_views = [tool_view_1,tool_view_2,tool_view_3,tool_view_4]
    #
    # for tool_view in @tool_views
    #   @section_container_detail.append tool_view

  refresh_detail:() ->
    # console.log "do refresh"
    @cbb_management = atom.project.cbb_management
    @cbb_tools = @cbb_management.get_tool_detail()
    @section_container_detail.empty()
    tool_view_1 = new CbbToolPanel(emp.TOOL_FIRST, @cbb_tools[emp.TOOL_FIRST])
    tool_view_2 = new CbbToolPanel(emp.TOOL_SECOND, @cbb_tools[emp.TOOL_SECOND])
    tool_view_3 = new CbbToolPanel(emp.TOOL_THIRD, @cbb_tools[emp.TOOL_THIRD])
    tool_view_4 = new CbbToolPanel(emp.TOOL_FOURTH, @cbb_tools[emp.TOOL_FOURTH])

    @tool_views = [tool_view_1,tool_view_2,tool_view_3,tool_view_4]

    for tool_view in @tool_views
      @section_container_detail.append tool_view




  do_save_all:  ->
    # console.log "do save all"
    for tool_view in @tool_views
      result = tool_view.get_setting_val()
      tmp_name = result.name
      @cbb_tools[tmp_name] = result.val
    @cbb_management.refresh_tool_detail @cbb_tools
    emp.show_info(emp.EMP_SAVE_SUCCESS)


  # check_diff: (new_obj)->
  #   # console.log new_obj
  #   # console.log @cbb_tools[new_obj.name]
  #   tmp_len = new_obj.length
  #   old_obj = @cbb_tools[new_obj.name]
  #   # console.log old_obj
  #   if tmp_name is null
  #     return false
  #   else if !old_obj
  #     return true
  #   else
  #     return tmp_name isnt old_obj.pack_name or new_obj.type_name isnt old_obj.type_name

    #
    # @append(new TutorialPanel(msg))
    # @append(new SettingsPanel('editor'))
