{$, $$, View, TextEditorView} = require 'atom-space-pen-views'
fs_plus = require 'fs-plus'
emp = require '../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'
fs = require 'fs'
path = require 'path'

module.exports =
class CbbConfigView extends View
  @content: ->


    @div =>
      @form class: 'general-panel section', =>
        @div outlet: "loadingElement", class: 'alert alert-info loading-area icon icon-hourglass', "Loading settings"
      @section class: 'section settings-panel', =>
        @div outlet:"section_container", class: 'section-container', =>
          @div class: "block section-heading icon icon-gear", "CBB Config"
          @div class: 'section-body', =>

            @div class: 'control-group',=>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "CBB 模板存储路径"
                  @div class: 'setting-description', "设置模板存储路径"
              @div class: 'controls', =>
                @subview "store_path", new TextEditorView(mini: true,attributes: {id: 'store_path', type: 'string'},  placeholderText: ' Sotre Path')

            @div class:'control-btn-m', =>
              @button class: 'control-btn btn btn-info', click:'select_temp_path',' Chose Path '
              @button class: 'control-btn btn btn-info', click:'set_default',' 恢复默认路径 '
              @button outlet:'set_btn', class:'control-btn btn btn-info', click:'set_cbb_store_path', "设为模板存储路径"

      @section class: 'section settings-panel', =>
        @div class: 'section-container', =>
          @div class: "block section-heading icon icon-gear", "UI Snippets Config"
          @div class: 'section-body', =>

            @div class: 'control-group',=>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "UI Snippets存储路径"
                  @div class: 'setting-description', "设置 UI Snippets 同步存储路径"
              @div class: 'controls', =>
                @subview "ui_lib_path", new TextEditorView(mini: true,attributes: {id: 'ui_lib_path', type: 'string'},  placeholderText: ' UI Lib Path')

            @div class:'control-btn-m', =>
              @button class: 'control-btn btn btn-info', click:'select_snippet_path',' Chose Path '
              @button class: 'control-btn btn btn-info', click:'set_snippet_default',' 恢复默认路径 '
              @button outlet:'set_btn', class:'control-btn btn btn-info', click:'do_set_snippet', "设为模板存储路径"


  initialize: (msg)->
    @loadingElement.remove()
    @cbb_management = atom.project.cbb_management
    # @packs = @cbb_management.get_pacakges()
    # @cbb_tools = @cbb_management.get_tool_detail()
    # project_path = atom.project.getPath()
    # tmp_export_store_path = path.join project_path,"tmp"
    # 模板路径
    templates_store_path =atom.project.templates_path
    # console.log tmp_export_store_path
    # emp.mkdir_sync_safe tmp_export_store_path
    # console.log atom.config.get emp.EMP_TEMPLATES_DEFAULT_KEY
    @default_store_path = atom.config.get emp.EMP_TEMPLATES_DEFAULT_KEY
    @store_path.setText @default_store_path

    # console.log @cbb_tools
    # @do_initial()

  # callback for show panel
  refresh_detail: ->
    # console.log "refresh_detail"
    @default_store_path = atom.config.get emp.EMP_TEMPLATES_DEFAULT_KEY
    # console.log @default_store_path
    @store_path.setText @default_store_path
    # 设置 ui snippet 存储路径
    @default_snippet_store_path = atom.config.get(emp.EMP_APP_STORE_UI_PATH)
    # console.log atom.config.get(emp.EMP_APP_STORE_UI_PATH)
    unless @default_snippet_store_path
      @default_snippet_store_path = emp.get_default_snippet_path()
      # console.log @default_snippet_store_path
    @ui_lib_path.setText @default_snippet_store_path

  # 设置模板存储路径为初始默认路径
  set_default: ->
    reset_default_path = emp.get_default_path()
    tmp_conf_path = @store_path.getText()
    # if tmp_conf_path is reset_default_path
    #   emp.show_warnning "修改路径与原路径相同,不做改变"
    #   return
    unless @show_def_alert(reset_default_path, tmp_conf_path)
      return

    @store_path.setText(reset_default_path)
    atom.config.set emp.EMP_TEMPLATES_DEFAULT_KEY, reset_default_path
    @cbb_management.do_initialize()

  set_cbb_store_path: ->
    if tmp_conf_path = @store_path.getText()?.trim()
      # if tmp_conf_path is @default_store_path
      #   emp.show_warnning "修改路径与原路径相同,改变取消"
      #   return
      # console.log tmp_conf_path
      return unless @show_set_alert(tmp_conf_path)

      # console.log "do set"
      unless fs.existsSync tmp_conf_path
        if @show_exist_path_alert(tmp_conf_path)
          emp.mkdir_sync_safe tmp_conf_path

      tmp_json = path.join tmp_conf_path, emp.EMP_TEMPLATE_JSON
      unless fs.existsSync tmp_json
        if @show_exist_temp_alert(tmp_conf_path)
          # console.log " do copy"
          # console.log @default_store_path
          # console.log tmp_conf_path
          fs_plus.copySync  @default_store_path, tmp_conf_path

      atom.config.set emp.EMP_TEMPLATES_DEFAULT_KEY, tmp_conf_path
      @cbb_management.do_initialize()
      emp.show_info "修改默认路径成功"
    else
      emp.show_error "路径不能为空!"

  # 设置 snippet 默认路径
  set_snippet_default: ->
    def_path = emp.get_default_snippet_path()
    atom.config.set(emp.EMP_APP_STORE_UI_PATH, def_path)
    @ui_lib_path.setText def_path
    # @refresh_snippets()
    @cbb_management.check_ui_snippet_link()
    emp.show_info "修改默认路径成功"

  do_set_snippet: ->
    if snippet_path = @ui_lib_path.getText()?.trim()
      def_path = emp.get_default_snippet_path()
      # store_path = emp.get_snippet_store_path()
      if fs.existsSync snippet_path
        atom.config.set(emp.EMP_APP_STORE_UI_PATH, snippet_path)
        # @refresh_snippets()
        @cbb_management.check_ui_snippet_link()
        emp.show_info "修改路径成功"
      else
        emp.show_error "该路径不存在,请另行选择!"
    else
      emp.show_error "路径不能为空!"

  # refresh_snippets: ->
  #   @cbb_management.check_ui_snippet_link()
  #   snippets = require atom.packages.activePackages.snippets.mainModulePath
  #   snippets.loadAll()

  select_temp_path: ->
    tmp_conf_path = @store_path.getText()
    @do_select_path(@store_path, tmp_conf_path)

  # 选择 snippet 路径
  select_snippet_path: ->
    tmp_conf_path = @ui_lib_path.getText()
    @do_select_path(@ui_lib_path, tmp_conf_path)

  do_select_path: (view, def_path)->
    dialog.showOpenDialog title: 'Select', defaultPath:def_path, properties: ['openDirectory'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        if path_state?.isDirectory()
          # @cbb_logo.setText
          console.log logo_path[0]
          view.setText logo_path[0]
  # 流程提示
  show_exist_temp_alert:(path) ->
    atom.confirm
      message: '警告'
      detailedMessage: "检查到以下路径为空路径,是否拷贝原路径的模板到当前路径下?\n\r
      从:#{@default_store_path}\n\r 拷贝到:#{path}"
      buttons:
        '是': -> return true
        '否': -> return false

  show_exist_path_alert:(path) ->
    atom.confirm
      message: '警告'
      detailedMessage: "检查到以下路径并不存在, 是否要创建?\n #{path}"
      buttons:
        '是': -> return true
        '否': -> return false

  show_set_alert:(path) ->
    atom.confirm
      message: '警告'
      detailedMessage: "是否设置以下路径为默认路径?\n #{path}"
      buttons:
        '是': -> return true
        '否': -> return false

  show_def_alert:(path, org_path) ->
    atom.confirm
      message: '警告'
      detailedMessage: "是否重置路径为默认路径?\n默认路径:#{path}\n\r当前路径:#{org_path}"
      buttons:
        '是': -> return true
        '否': -> return false
