{$, $$, ScrollView,TextEditorView} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'
emp = require '../exports/emp'
default_select_pack = emp.EMP_DEFAULT_PACKAGE
default_select_type = emp.EMP_DEFAULT_TYPE

module.exports =
class InstalledTemplatePanel extends ScrollView
  @content: ->
    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-package', =>
            @text 'Add UI Snippets'
            @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'

          # # 包图标
          # @div class: 'section-body', =>
          #   @div class: 'control-group', =>
          #     @div class: 'controls', =>
          #       @label class: 'control-label', =>
          #         @div class: 'setting-title', "Logo"
          #         @div class: 'setting-description', "缩略图"
          #
          #     @div class: 'controls', =>
          #       @div class:'controle-logo', =>
          #         @div class: 'meta-user', =>
          #           @img outlet:"logo_image", class: 'avatar', src:"#{logo_img}"
          #         @div class:'meta-controls', =>
          #           @div class:'btn-group', =>
          #             @select outlet:"logo_select", id: "logo", class: 'form-control', =>
          #               # for option in ["emp", "ebank", "boc", "gdb"]
          #               @option value: "#{emp.EMP_NAME_DEFAULT}", emp.EMP_NAME_DEFAULT
          #             @button class: 'control-btn btn btn-info', click:'select_logo',' Chose Other Logo '

              # @div class: 'controls', =>
              #   @subview "detail_img_text", new TextEditorView(mini: true,attributes: {id: 'detail_img_text', type: 'string'},  placeholderText: ' detail img')
              #   @div class:'btn-box-n', =>
              #     @button class:'btn btn-error', click:'remove_all_detail',"Remove All"
              #     @button class:'btn btn-info', click:'chose_detail_f',"Chose File"
              #     @button class:'btn btn-info', click:'chose_detail_d',"Chose Dir"
              #     @button class:'btn btn-info', click:'add_image_detail_btn',"Add"

          # 模板所属类别
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板类别"
                  @div class: 'setting-description', "模板所属类别(例如 button,input)."
                # @div class: 'editor-container', =>
              @div outlet:'snippet_pack_sel_div', class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-description', "默认的的模板类别."
                @select outlet:"snippet_pack_sel", id: "snippet_pack_sel", class: 'form-control', =>
                # for option in ["emp", "ebank", "boc", "gdb"]
                  # @option value: "#{emp.EMP_NAME_DEFAULT}", emp.EMP_NAME_DEFAULT
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-description', "增加新的模板类别."
                @subview "snippet_pack", new TextEditorView(mini: true,attributes: {id: 'snippet_pack', type: 'string'},  placeholderText: ' Snippets  description')

          # 模板描述
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板名称*"
                  @div class: 'setting-description', "模板名称(描述)(Snippets  Name),不要重复."
                # @div class: 'editor-container', =>
                @subview "snippet_name", new TextEditorView(mini: true,attributes: {id: 'snippet_name', type: 'string'},  placeholderText: ' Snippets  Name')

          # snippet 生效的文件
          @div outlet:'snippet_scope_div', class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板生效范围选择器*"
                  @div class: 'setting-description', "新添加模板类别是添加.(Snippet scope selector).默认为#{emp.DEFAULT_SNIPPET_SOURE_TYPE}"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "snippet_scope", new TextEditorView(mini: true,attributes: {id: 'snippet_scope', type: 'string'},  placeholderText: 'Snippet scope selector (ex: `.source.js`)')

          # snippet 触发标示
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板 tab 触发条件*"
                  @div class: 'setting-description', "Snippets Tab Activation"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "snippet_tab", new TextEditorView(mini: true,attributes: {id: 'snippet_tab', type: 'string'},  placeholderText: 'Snippets Tab Activation')


          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板内容*"
                  @div class: 'setting-description', "Snippets Body"
                # @subview "snippet_body", new TextEditorView(mini: true,attributes: {id: 'snippet_body', type: 'string'},  placeholderText: ' Snippet Body')
                @textarea "", class: "snippet_area native-key-bindings editor-colors", rows: 8, outlet: "snippet_body", placeholder: "Snippet Body"
                @button class: 'control-btn btn btn-info', click:'create_body',' Create File '
                @button class: 'control-btn btn btn-info', click:'edit_body',' Edit File '

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板样式*"
                  @div class: 'setting-description', "Snippets Body"
                # @subview "snippet_body", new TextEditorView(mini: true,attributes: {id: 'snippet_body', type: 'string'},  placeholderText: ' Snippet Body')
                @textarea "", class: "snippet_area native-key-bindings editor-colors", rows: 8, outlet: "snippet_css", placeholder: "Snippet Css"



      @div class: 'footer-div', =>
        @div class: 'footer-detail', =>
          @button outlet:"cancel_btn", class: 'footer-btn btn btn-info inline-block-tight', style:"display:none;", click:'do_cancel','  Cancel  '
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'create_snippet',' Ok '

  initialize: () ->
    super
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    @snippet_sotre_path = atom.project.snippets_path
    @snippet_css_path = path.join __dirname, '../../css/'
    emp.mkdir_sync_safe @snippet_sotre_path
    emp.mkdir_sync_safe @snippet_css_path

    @snippet_pack.getModel().getBuffer().onDidStopChanging =>
      console.log "modified text"
      console.log @snippet_pack.getText()
      if @snippet_pack.getText()
        @snippet_pack_sel_div.hide()
        # @snippet_scope_div.show()
      else
        @snippet_pack_sel_div.show()
        # @snippet_scope_div.hide()

  refresh_detail: (edit_data)->
    console.log 'refresh_detail'
    snippet_def_pack = emp.EMP_NAME_DEFAULT
    @edit_flag = false
    if edit_data
      console.log edit_data
      @cancel_btn.show()
      @edit_flag = true

      [@edit_name, @edit_body, @edit_css, @edit_prefix,
      @edit_source, @edit_pack] = edit_data

      @snippet_name.setText(@edit_name)
      @snippet_tab.setText(@edit_prefix)
      @snippet_scope.setText(@edit_source)
      @snippet_body.context.value = @edit_body
      @snippet_css.context.value = @edit_css
      # console.log snippet_body
      snippet_def_pack = @edit_pack
      @snippet_pack.setText("")
    else
      @cancel_btn.hide()
      @cleanup()

    fs.readdir @snippet_sotre_path, (err, files) =>
      if err
        console.error err
      else
        @snippet_pack_sel.empty()
        if snippet_def_pack is emp.EMP_NAME_DEFAULT
          tmp_sel_option = @new_selected_option(emp.EMP_NAME_DEFAULT)
          @snippet_pack_sel.append tmp_sel_option
        else
          tmp_sel_option = @new_option(emp.EMP_NAME_DEFAULT)
          @snippet_pack_sel.append tmp_sel_option
        console.log files
        for tmp_file in files
          if path.extname(tmp_file) is emp.DEFAULT_SNIPPET_FILE_EXT
            tmp_option_val = path.basename tmp_file, emp.DEFAULT_SNIPPET_FILE_EXT
            if tmp_option_val is snippet_def_pack
              tmp_option = @new_selected_option(tmp_option_val)
              @snippet_pack_sel.append tmp_option
            else
              tmp_option = @new_option(tmp_option_val)
              @snippet_pack_sel.append tmp_option

  # do create  -----------------------------------------------------------------
  create_snippet: ->
    # 判断是否为编辑
    if @edit_flag
      @do_edit_snippet()
    else
      @do_create_snippet()

  do_create_snippet: ->
    console.log " create snippet"
    unless snippet_pack = @snippet_pack.getText()?.trim()
      snippet_pack = @snippet_pack_sel.val()
    console.log snippet_pack

    if !snippet_name = @snippet_name.getText()?.trim()
      emp.show_error "模板名称不能为空!"
      return

    if !snippet_tab = @snippet_tab.getText()?.trim()
      emp.show_error "模板触发条件不能为空!"
      return

    if !snippet_source = @snippet_scope.getText()?.trim()
      emp.show_error "模板选择器不能为空!"
      return
    snippet_body = @snippet_body.context.value
    snippet_css = @snippet_css.context.value
    console.log snippet_body

    file_name = @snippet_sotre_path + snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    snippet_json = {}
    snippet_json[snippet_source] = {}
    if fs.existsSync file_name
      json_data = fs.readFileSync file_name
      snippet_json = JSON.parse json_data
      if snippet_json[snippet_source]?[snippet_name]
        ck_flag = emp.show_alert "Warnning", "该代码段已经存在,是否要覆盖原有代码段."
        if !ck_flag
          return
    # console.log file_name
    snippet_json[snippet_source]?[snippet_name] = {
      'prefix': snippet_tab
      'body':snippet_body
      'css': snippet_css
    }
    fs.writeFile(file_name, JSON.stringify(snippet_json, null, '\t') , (error) ->
        if error
          console.log error
        else
          console.log 'the snippet was succesfully saved to ' + file_name
      )
    # console.log file_name
    snippets = require atom.packages.activePackages.snippets.mainModulePath
    snippets.loadAll()
    emp.show_info "添加基础控件成功."
    @cleanup()


  # do edit  -------------------------------------------------------------------
  do_edit_snippet: ->
    console.log " create snippet"
      # [@edit_name, @edit_body, @edit_css, @edit_prefix,
      # @edit_source, @edit_pack]

    unless snippet_pack = @snippet_pack.getText()?.trim()
      snippet_pack = @snippet_pack_sel.val()
    console.log snippet_pack

    if !snippet_name = @snippet_name.getText()?.trim()
      emp.show_error "模板名称不能为空!"
      return

    if !snippet_tab = @snippet_tab.getText()?.trim()
      emp.show_error "模板触发条件不能为空!"
      return

    if !snippet_source = @snippet_scope.getText()?.trim()
      emp.show_error "模板选择器不能为空!"
      return
    snippet_body = @snippet_body.context.value
    snippet_css = @snippet_css.context.value
    console.log snippet_body

    if snippet_pack isnt @edit_pack
      @delete_element()
    # else if snippet_source isnt @edit_source

    file_name = @snippet_sotre_path + snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    snippet_json = {}
    snippet_json[snippet_source] = {}

    if fs.existsSync file_name
      json_data = fs.readFileSync file_name
      snippet_json = JSON.parse json_data
      if (snippet_source isnt @edit_source) or (snippet_name isnt @edit_name)
        delete snippet_json[@edit_source]?[@edit_name]

    # console.log file_name
    snippet_json[snippet_source]?[snippet_name] = {
      'prefix': snippet_tab
      'body':snippet_body
      'css': snippet_css
    }
    fs.writeFile(file_name, JSON.stringify(snippet_json, null, '\t') , (error) ->
        if error
          console.log error
        else
          console.log 'the snippet was succesfully saved to ' + file_name
      )
    # console.log file_name
    snippets = require atom.packages.activePackages.snippets.mainModulePath
    snippets.loadAll()
    emp.show_info "编辑基础控件成功."
    @cleanup()
    @do_cancel()


  delete_element: ()->
    edit_file = @snippet_sotre_path + @edit_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    if fs.existsSync edit_file
      json_data = fs.readFileSync edit_file
      snippet_json = JSON.parse json_data
      delete snippet_json[@edit_source]?[@edit_name]

    fs.writeFile(edit_file, JSON.stringify(snippet_json, null, '\t') , (error) ->
        if error
          console.log error
        else
          console.log 'the old snippet was deleted. '
      )

  cleanup: ->
    @snippet_name.setText('')
    @snippet_tab.setText('')
    @snippet_scope.setText('')
    @snippet_body.context.value = ''
    @snippet_css.context.value = ''
    @snippet_pack.setText("")
    @snippet_scope.setText(emp.DEFAULT_SNIPPET_SOURE_TYPE)

  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selected_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name

# --------------------
  initial_create_tmp_file: ->
    tmp_path = path.join @templates_store_path, emp.EMP_TMP_TEMP_FILE_PATH

    if !fs.existsSync tmp_path
      emp.mkdir_sync_safe tmp_path

    tmp_path

  # 编辑时,取消编辑
  do_cancel: ->
    @parents('.emp-template-management').view()?.showPanel(emp.EMP_SHOW_UI_LIB)


  # 创建 snippet body
  create_body: ->
    console.log "create html"
    tmp_path = @initial_create_tmp_file()
    tmp_file = path.join tmp_path, emp.EMP_TMP_TEMP_CSON
    @create_editor(tmp_file, emp.EMP_GRAMMAR_XHTML, (tmp_editor) =>
                    tmp_editor.onDidSave (event) =>
                      # console.log event
                      tmp_body = tmp_editor.getText()
                      # @snippet_body_text = tmp_body
                      @snippet_body.context.value = tmp_body
                  ," ")


  edit_body: ->
    @edit_temp_file(@template_html, emp.EMP_GRAMMAR_XHTML)


  edit_temp_file: (tmp_view, grammar) ->
    tmp_file = tmp_view.getText()
    if tmp_file
      @create_editor(tmp_file, grammar, @callback_save_snippet)
    else
      emp.show_error "没有可编辑的文件, 请先选择或者创建模板文件!"

  callback_save_snippet:(tmp_editor) ->
    tmp_editor.onDidSave (event) =>
      # console.log event
      tmp_body = tmp_editor.getText()
      # @snippet_body_text = tmp_body
      @snippet_body.setText(tmp_body)

  create_editor:(tmp_file_path, tmp_grammar, callback, content) ->
    changeFocus = true
    tmp_editor = atom.workspace.open(tmp_file_path, { changeFocus }).then (tmp_editor) =>
      gramers = @getGrammars()
      console.log content
      unless content is undefined
        tmp_editor.setText(content) #unless !content
      tmp_editor.setGrammar(gramers[0]) unless gramers[0] is undefined
      callback(tmp_editor)

  # set the opened editor grammar, default is HTML
  getGrammars: (grammar_name)->
    grammars = atom.grammars.getGrammars().filter (grammar) ->
      (grammar isnt atom.grammars.nullGrammar) and
      grammar.name is 'CoffeeScript'
    grammars
