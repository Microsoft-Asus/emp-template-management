EmpTmpManaWizardView = require './views/emp-template-management-view'
EmpTempManagement = require './views/emp-template-management'
EmpCbbView = require './views/componment-view'
QuickAddCbbView = require './views/quick-add-cbb-view'
EMPUiGuide = require './guide/cbb-ui-snippets-guide'
EmpKeymapsManView = require './help/emp-keymaps-management'
# provider =  require './ac_html/ehtml_provider'

empTmpManagementView = null
empKeyMapsManagement = null
emp = require './exports/emp'
fs = require 'fs'
path = require 'path'
default_uri = emp.EMP_TEMP_URI

# -------------------use for template management -------------------------
create_tmp_management = (params) ->
  empTmpManagementView = new EmpTmpManaWizardView(params)

open_panel = (panel_name, uri) ->
  empTmpManagementView ?= create_tmp_management({uri: default_uri})
  empTmpManagementView.showPanel(panel_name, {uri})

temp_deserializer =
  name: emp.TEMP_WIZARD_VIEW
  version: 1
  deserialize: (state) ->
    console.log "emp template  deserialize"
    create_tmp_management(state) if state.constructor is Object

# -------------------use for keymaps management -------------------------
create_keymap_man = (params) ->
  empKeyMapsManagement = new EmpKeymapsManView(params)

open_keymap_panel = (panel_name, uri) ->
  empKeyMapsManagement ?= create_keymap_man({uri: emp.EMP_KEYMAP_MAN})
  empKeyMapsManagement.showPanel(panel_name, {uri})

keymap_deserializer =
  name: emp.KEYMAP_WIZARD_VIEW
  version: 1
  deserialize: (state) ->
    console.log "emp keymap man  deserialize"
    create_keymap_man(state) if state.constructor is Object

atom.deserializers.add(temp_deserializer)
atom.deserializers.add(keymap_deserializer)

module.exports =
  config:
    showOnRightSide:
      type: 'boolean'
      default: true
    defaultStorePath:
      type:'string'
      default: path.join(atom.packages.resolvePackagePath(emp.PACKAGE_NAME), emp.EMP_TEMPLATES_PATH)
  #   cbb_type:
  #     title: '控件类型'
  #     description: '模板类型, 默认为控件, 可以自定义类型,在此处添加,重启管理器即可.'
  #     type: "string"
  #     default: emp.EMP_DEFAULT_TYPE, "package"
  #     order: 1



  activate: (state)->
    # console.log "emp active~:#{state}"
    # provider.loadCompletions()
    atom.workspace.addOpener (uri) ->
      # console.log "emp registerOpener: #{uri}"
      # console.log atom.workspace.activePane
      # console.log atom.workspace.activePane.itemForUri(configUri)
      # if uri is default_uri
      if uri.startsWith(default_uri)
        create_tmp_management({uri})
        if match = /template_management_wizard\/(.*)/gi.exec(uri)
          panel_name = match[1]
          panel_name = panel_name[0].toUpperCase() + panel_name.slice(1)
          # console.log panel_name
          open_panel(panel_name, uri)
        empTmpManagementView
      else
        if uri.startsWith emp.EMP_KEYMAP_MAN
          create_keymap_man({uri})

    snippets = require atom.packages.activePackages.snippets.mainModulePath
    atom.commands.add "atom-workspace",
      "emp-template-management:temp-management": -> atom.workspace.open(default_uri)
      "emp-template-management:snippets-management": -> atom.workspace.open(default_uri+"/"+emp.EMP_SHOW_UI_LIB)
      "emp-template-management:reload-snippets": ->
        snippets.loadAll()
        emp.show_info "刷新 Snippets 成功!"
      "emp-template-management:set-keymaps": ->
        console.log "key mps"
        atom.workspace.open emp.EMP_KEYMAP_MAN
      "emp-template-management:test-keymaps": ->
        emp.show_info "keymap  test!"

    @emp_temp_management = new EmpTempManagement()
    atom.project.cbb_management = @emp_temp_management
    # @doc 创建 cbb 视图
    @emp_componment_view = new EmpCbbView(state.emp_cbb_panel_state, @emp_temp_management)
    @emp_quick_add_view = new QuickAddCbbView(@emp_temp_management)
    @emp_ui_guide = new EMPUiGuide()

  serialize: ->
    emp_cbb_panel_state: @emp_componment_view.serialize()
    emp_quick_add_cbb_panel_state:@emp_quick_add_view.serialize()

  deactivate: ->
    @emp_componment_view.destroy()
    @emp_quick_add_view.destroy()
    @ertUiGuide.destroy()

  # getProvider: -> provider


  # @doc 创建 cbb 视图
  # create_cbb_panel: (state)->
  #   console.log "show cbb"
  #   unless @emp_componment_view
  #
  #
  #     # @emp_componment_view.show_toolbar()
  #   @emp_componment_view
