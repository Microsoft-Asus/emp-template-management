{Range} = require 'atom'
{$, $$, TextEditorView, View} = require 'atom-space-pen-views'
# fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'
# fs_plus = require 'fs-plus'
emp = require '../../exports/emp'
SniEle = require './snippet-ele-view'
fs = require 'fs'
path = require 'path'
head_parser = require '../../head-parser/index'
# css = require 'css'
# cheerio = require 'cheerio'
# templates_store_path = null

module.exports =
class CbbDetailView extends View
  insert_src_view: {}
  # insert_css_view:{}
  insert_lua_view: {}

  @content: (@ele_obj)->
    temp_path = atom.project.templates_path

    @div outlet:'cbb_detail_div', class:'cbb-detail-view  overlay from-top', =>
      @div class:'cbb_detail_panel panel', =>
        @h1 "Insert Cbb Templates", class: 'panel-heading'
        @div class:'bar_div', =>
          @button class: 'btn-warning btn  inline-block-tight btn_right', click: 'do_cancel', 'Cancel'

      @div class: 'cbb_detail_info', =>

        @div class:'div_box_r', =>
          @label class:'lab text-highlight',"模板名称:#{@ele_obj.name}"

        @div class:'div_box_bor', =>
          @label class:'text-highlight', "模板描述:"
          @label class:'', "#{@ele_obj.desc}"


        @div class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_html', type: 'checkbox', checked:'true'
            @text "Insert Html"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'html_tree'


          @div outlet:'snippet_html', =>
            @button "Show Html Snippet Detail", class:"btn", click:"show_html_detail"

        # @div outlet:'css_div',class: 'div_box_check',  =>
        #   @div class: 'checkbox_ucolumn', =>
        #
        #       @input outlet:'insert_css', type: 'checkbox', checked:'true'
        #       @text "Insert Css"
        #
        #       @input outlet:'insert_css_store', type: 'checkbox', checked:'true'
        #       @text " Remember my choice"
        #   @div class:'control-ol', =>
        #     @table class:'control-tab',outlet:'css_tree'
        #
        #   @div outlet:'snippet_css', =>
        #     @subview "insert_css_path", new TextEditorView(mini: true,attributes: {id: 'insert_css_path', type: 'string'},  placeholderText: ' Insert Css Path')
        #     @button "Chose Css Insert Path", class:"btn", click:"chose_css_path"
        #   #   @button "Show Css Snippet Detail", class:"btn", click:"show_css_detail"

        @div outlet:'lua_div',class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_lua', type: 'checkbox', checked:'true'
            @text "Insert Lua"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'lua_tree'

          @div outlet:'snippet_lua', =>
            @subview "insert_lua_path", new TextEditorView(mini: true,attributes: {id: 'insert_lua_path', type: 'string'},  placeholderText: ' Insert Lua Path')
            @button "Chose Lua Insert Path", class:"btn", click:"chose_lua_path"

        @div outlet:'src_div',class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_source', type: 'checkbox', checked:'true'
            @text "Insert Src"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'src_tree'
          @div outlet:'snippet_src', =>
            @subview "insert_src_path", new TextEditorView(mini: true,attributes: {id: 'insert_src_path', type: 'string'},  placeholderText: ' Insert Src Path')
            @button "Chose Src Insert Path", class:"btn", click:"chose_src_path"
          # @div outlet:'snippet_html', =>
          #   @button "Show Source Snippet Detail", class:"btn", click:"show_source_detail"

# div_logo
        @div class:'div_box_check', =>
          @div class:'div_box', =>
            @label class:'lab',"模板示例:"
            # @span "", class: "input-group-btn", =>
          @div class:'div_box', =>
            for tmp_detail_img in @ele_obj.detail
              tmp_img_path = path.join temp_path, tmp_detail_img
              @img outlet: 'logo_img', class: 'avatar_detail', src: "#{tmp_img_path}"

      @div class:'div_box_bor'
      @div class:'cbb_detail_foot', =>
        @button "Done", class: "createSnippetButton btn btn-primary", click:'do_input'
        @button "Cancel", class: "createSnippetButton btn-warning btn btn-primary", click:'do_cancel'
        # @button "test", class: "createSnippetButton btn-warning btn btn-primary", click:'do_test'

  initialize: (@com, @pack_name) ->
    # @handle_event()
    # console.log @com
    # console.log @pack_name
    # pack_select
    @cbb_management = atom.project.cbb_management
    @templates_path = atom.project.templates_path
    @css_com_file = @cbb_management.get_common_css(@pack_name)

    @css_com_file_name = path.basename @css_com_file
    @ele_path = @com.element_path
    @ele_json = path.join @templates_path, @ele_path, emp.EMP_TEMPLATE_JSON

    ele_json_data = fs.readFileSync @ele_json, 'utf-8'
    @snippet_obj = JSON.parse ele_json_data

    @html_obj = @snippet_obj.html
    @css_obj = @snippet_obj.css
    @lua_obj = @snippet_obj.lua


    @html_snippet = @set_con(@html_obj)



    # console.log @snippet_obj

    # @css_insert_flag = true
    # if !@css_obj
    #   @css_div.hide()
    #   @css_insert_flag=false
    # else
    #   @css_snippet = @set_con(@css_obj)
    #   if @css_obj.type isnt emp.EMP_CON_TYPE
    #   # @css_obj.body
    #   # for tmp_src in src_arr
    #     tmp_view = new SniEle(this, @css_obj.body)
    #     tmp_name = path.basename tmp_view
    #
    #     @insert_css_view[tmp_name]= tmp_view
    #     @css_tree.append tmp_view

    @lua_insert_flag = true
    if !@lua_obj
      @lua_div.hide()
      @lua_insert_flag = false
    else

      @lua_snippet = @set_con(@lua_obj)
      if @lua_obj.type isnt emp.EMP_CON_TYPE
        tmp_view = new SniEle(this, @lua_obj.body)
        tmp_name = path.basename tmp_view

        @insert_lua_view[tmp_name]= tmp_view
        @lua_tree.append tmp_view

    # SniEle
    @src_obj = @snippet_obj.source
    @src_insert_flag = true

    if !@src_obj
      @src_div.hide()
      @src_insert_flag = false
    else
      for tmp_src in @src_obj
        tmp_view = new SniEle(this, tmp_src)
        tmp_name = path.basename tmp_view

        @insert_src_view[tmp_name]= tmp_view
        @src_tree.append tmp_view

    @on 'keydown', (e) =>
      # console.log "key down"
      if e.which is emp.ESCAPEKEY
        @detach()

    @on 'core:cancel', (e) =>
      console.log "cancel"




    editor = atom.workspace.getActiveTextEditor()
    if editor
      tmp_project_path = atom.project.getPaths()[0]
      console.log tmp_project_path
      tmp_common_path = path.join tmp_project_path, emp.EMP_RESOURCE_PATH

      if fs.existsSync tmp_common_path
        src_path = path.join tmp_common_path, emp.EMP_IMGS_DIR
        @insert_src_path.setText src_path
        @css_path = path.join tmp_common_path, emp.EMP_CSS_DIR
        # @insert_css_path.setText css_path


      if html_path = editor.getPath?()

        root_path = path.dirname path.dirname html_path
        # css_path = path.join root_path, emp.EMP_CSS_DIR
        # fs.stat css_path, (err, stat) =>
        #   if !err
        #     if stat?.isDirectory()
        #       @insert_css_path.setText css_path

        # console.log html_path
        # console.log root_path
        lua_path = path.join root_path, emp.EMP_LUA_DIR
        # fs.stat lua_path, (err, stat) =>
        #   if !err
        #     if stat?.isDirectory()
        @insert_lua_path.setText lua_path

        # src_path = path.join root_path, emp.EMP_IMGS_DIR
        # # fs.stat src_path, (err, stat) =>
        # #   if !err
        # #     if stat?.isDirectory()
        # @insert_src_path.setText src_path




  chose_src_path: ->
    tmp_conf_path = @insert_src_path.getText()
    @do_select_path(@insert_src_path, tmp_conf_path)

  # chose_css_path: ->
  #   tmp_conf_path = @insert_css_path.getText()
  #   @do_select_file(@insert_css_path, tmp_conf_path)

  chose_lua_path: ->
    tmp_conf_path = @insert_lua_path.getText()
    @do_select_file(@insert_lua_path, tmp_conf_path)

  do_select_path: (view, def_path)->
    dialog.showOpenDialog title: 'Select', defaultPath:def_path, properties: ['openDirectory'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        if path_state?.isDirectory()
          # @cbb_logo.setText
          console.log logo_path[0]
          view.setText logo_path[0]

  do_select_file: (view, def_path)->
    dialog.showOpenDialog title: 'Select', defaultPath:def_path, properties: ['openDirectory', 'openFile'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        # if path_state?.isDirectory()
          # @cbb_logo.setText
          # console.log logo_path[0]
        view.setText logo_path[0]


  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selec_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name


  handle_event: ->
    @validate_fields()
    # window.addEventListener 'resize', =>
    #   @set_textarea_hight()
    @on 'keydown', (e) =>
      if e.which is emp.ESCAPEKEY
        @detach()

  toggle: (type)->
    if @isVisible()
      @detach()
    else
      @show(type)

  show: (type)->
    console.log " show this "
    # editor = atom.workspace.getActiveEditor()
    # if editor
    #   selection = editor.getSelection().getText()
    #   if selection.length > 0
    #     @set_snippet(type, selection)
    atom.workspace.addTopPanel(item: this)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  do_cancel: ->
    @toggle()

  do_input: ->
    # console.log atom.workspace.getActivePaneItem()
    # console.log atom.workspace.getActivePane()
    # console.log @insert_html.val()
    # console.log @insert_html.prop('checked')
    # console.log @com
    @do_input_snippet()



  do_input_snippet: ->
    # console.log @com
    editor = atom.workspace.getActiveTextEditor()

    if editor
      try

        project_path = atom.project.getPaths()[0]
        # console.log @css_com_file_name
        dest_dir = path.join project_path, emp.STATIC_UI_CSS_TEMPLATE_DEST_PATH
        if !fs.existsSync dest_dir
          emp.mkdir_sync_safe dest_dir
        dest_path = path.join dest_dir, @css_com_file_name
        # console.log @css_com_file
        # console.log dest_path
        # fs_plus.copySync  @css_com_file, dest_dir
        if fs.existsSync @css_com_file
          css_con = fs.readFileSync @css_com_file, 'utf8'
          fs.writeFileSync(dest_path, css_con, 'utf8')
        else
          console.error "不存在公共的样式文件."

        if @lua_insert_flag
          unless !@insert_lua.prop('checked')

            # console.log "has css"
            tmp_path = @insert_lua_path.getText()
            if !tmp_path
              emp.show_error "插入Lua 地址不能为空!"
              return

            # tmp_ext = path.extname tmp_path
            if path.extname tmp_path
              tmp_dir = path.dirname tmp_path
              emp.mkdir_sync_safe tmp_dir

              if @lua_obj.type is emp.EMP_CON_TYPE
                tmp_body = @lua_obj.body
              else
                temp_path = path.join @templates_path, @lua_obj.body
                tmp_body =  fs.readFileSync temp_path, 'utf-8'
              if fs.existsSync temp_path
                fs.appendFileSync tmp_path,"\n"+tmp_body
              else
                fs.writeFileSync tmp_path,"\n"+tmp_body
            else
              emp.mkdir_sync_safe tmp_path
              # lua_obj = @snippet_obj.lua
              if @lua_obj.type is emp.EMP_CON_TYPE
                emp.show_error "请指定需要插入的Lua文件!"
                return
              else
                temp_path = path.join @templates_path, @lua_obj.body
                tmp_body =  fs.readFileSync temp_path, 'utf-8'
                tmp_name = path.basename temp_path
                tmp_re_file = path.join tmp_path, tmp_name
                # console.log tmp_re_file
                # console.log tmp_body
                if fs.existsSync tmp_re_file
                  tmp_flag = @show_alert("指定的 lua 文件已经存在,请指定后续操作.")
                  switch tmp_flag
                    when 1
                      fs.appendFileSync tmp_re_file,"\n"+tmp_body
                    when 2
                      fs.writeFileSync tmp_re_file, tmp_body
                    else return
                else
                  fs.writeFileSync tmp_re_file, tmp_body
        if @src_insert_flag
          unless !@insert_source.prop('checked')
            tmp_path = @insert_src_path.getText()
            emp.mkdir_sync_safe tmp_path

            for tmp_src in @src_obj
              temp_path = path.join @templates_path, tmp_src
              f_con = fs.readFileSync temp_path
              tmp_name = path.basename tmp_src
              tmp_re_file = path.join tmp_path, tmp_name
              # force copy
              fs.writeFileSync tmp_re_file, f_con


        # 插入外联脚本 样式
        # tmp_editor = atom.workspace.getActiveTextEditor()
        # if tmp_editor
        #   debug_text = tmp_editor.getText()
        #   re_text = head_parser.insert debug_text, @css_com_file_name
        #   console.log re_text

      catch err
        console.error "insert snippets error "
        console.error err

      unless !@insert_html.prop('checked')
        atom.packages.activePackages.snippets?.mainModule?.insert @html_snippet
        # console.log escape edit_text
    @toggle()

  do_test: ->
    tmp_editor = atom.workspace.getActiveTextEditor()
    if tmp_editor
      debug_text = tmp_editor.getText()
      re_text = head_parser.insert debug_text, @css_com_file_name
      console.log re_text

  set_con: (tmp_obj) ->
    if tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
        return tmp_obj.body
      else
        tmp_path = path.join @templates_path, tmp_obj.body
        return fs.readFileSync tmp_path, 'utf-8'
    else
      return null

  show_html_detail: ->
    console.log "show_html_detail"

  show_css_detail: ->
    console.log "show_css_detail"


  show_source_detail: ->
    console.log "show_source_detail"


  show_alert: (msg) ->
    atom.confirm
      message: '警告'
      detailedMessage:msg
      buttons:
        '取消': -> return 3
        '替换': -> return 2
        '合并': -> return 1
