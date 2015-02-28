EmpTmpManaWizardView = require './views/emp-template-management-view'
EmpCcbView = require './views/componment-view'

empTmpManagementView = null
emp = require './exports/emp'


# -------------------use for template management -------------------------
create_tmp_management = (params) ->
  empTmpManagementView = new EmpTmpManaWizardView(params)

open_temp_wizard_panel = (params)->
  # console.log "open_temp_wizard_panel"
  atom.workspace.open(emp.EMP_TEMP_URI)
  # empTmpManagementView.add_new_panel()

temp_deserializer =
  name: emp.TEMP_WIZARD_VIEW
  version: 1
  deserialize: (state) ->
    console.log "emp template  deserialize"
    create_tmp_management(state) if state.constructor is Object

atom.deserializers.add(temp_deserializer)



module.exports =
  config:
    showOnRightSide:
      type: 'boolean'
      default: true
  #   cbb_type:
  #     title: '控件类型'
  #     description: '模板类型, 默认为控件, 可以自定义类型,在此处添加,重启管理器即可.'
  #     type: "string"
  #     default: emp.EMP_DEFAULT_TYPE, "package"
  #     order: 1



  activate: (state)->
    # console.log "emp active~:#{state}"
    atom.workspace.addOpener (uri) ->
      # console.log "emp registerOpener: #{uri}"
      # console.log atom.workspace.activePane
      # console.log atom.workspace.activePane.itemForUri(configUri)
      if uri is emp.EMP_TEMP_URI
        create_tmp_management({uri})


    atom.commands.add "atom-workspace",
      "emp-template-management:temp-management": -> open_temp_wizard_panel(emp.DEFAULT_PANEL)

    # @doc 创建 ccb 视图
    @emp_componment_view = new EmpCcbView(state.emp_ccb_panel_state)

  serialize: ->
    emp_ccb_panel_state: @emp_componment_view.serialize()

  deactivate: ->
    @emp_componment_view.destroy()


  # @doc 创建 ccb 视图
  # create_ccb_panel: (state)->
  #   console.log "show ccb"
  #   unless @emp_componment_view
  #
  #
  #     # @emp_componment_view.show_toolbar()
  #   @emp_componment_view


module.exports.open_temp_wizard = open_temp_wizard_panel
