{Range} = require 'atom'
{$, $$, TextEditorView, View} = require 'atom-space-pen-views'
# fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'

emp = require '../../exports/emp'
SniEle = require './snippet-ele-view'
fs = require 'fs'
path = require 'path'
# css = require 'css'
# cheerio = require 'cheerio'
# templates_store_path = null

module.exports =
class CbbDetailView extends View
  insert_src_view: {}
  insert_css_view:{}
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

        @div outlet:'css_div',class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>

              @input outlet:'insert_css', type: 'checkbox', checked:'true'
              @text "Insert Css"

              @input outlet:'insert_css_store', type: 'checkbox', checked:'true'
              @text " Remember my choice"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'css_tree'

          @div outlet:'snippet_css', =>
            @subview "insert_css_path", new TextEditorView(mini: true,attributes: {id: 'insert_css_path', type: 'string'},  placeholderText: ' Insert Css Path')
            @button "Chose Css Insert Path", class:"btn", click:"chose_css_path"
          #   @button "Show Css Snippet Detail", class:"btn", click:"show_css_detail"

        @div outlet:'lua_div',class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_lua', type: 'checkbox', checked:'true'
            @text "Insert Lua"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'lua_tree'

          @div outlet:'snippet_css', =>
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

  initialize: (@com) ->
    # @handle_event()
    # pack_select
    @cbb_management = atom.project.cbb_management
    @templates_path = atom.project.templates_path
    @ele_path = @com.element_path
    @ele_json = path.join @templates_path, @ele_path, emp.EMP_TEMPLATE_JSON

    ele_json_data = fs.readFileSync @ele_json, 'utf-8'
    @snippet_obj = JSON.parse ele_json_data

    @html_obj = @snippet_obj.html
    @css_obj = @snippet_obj.css
    @lua_obj = @snippet_obj.lua


    @html_snippet = @set_con(@html_obj)



    # console.log @snippet_obj

    @css_insert_flag = true
    if !@css_obj
      @css_div.hide()
      @css_insert_flag=false
    else
      @css_snippet = @set_con(@css_obj)
      if @css_obj.type isnt emp.EMP_CON_TYPE
      # @css_obj.body
      # for tmp_src in src_arr
        tmp_view = new SniEle(this, @css_obj.body)
        tmp_name = path.basename tmp_view

        @insert_css_view[tmp_name]= tmp_view
        @css_tree.append tmp_view

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
      if html_path = editor.getPath?()

        root_path = path.dirname path.dirname html_path
        css_path = path.join root_path, emp.EMP_CSS_DIR
        fs.stat css_path, (err, stat) =>
          if !err
            if stat?.isDirectory()
              @insert_css_path.setText css_path

        lua_path = path.join root_path, emp.EMP_LUA_DIR
        fs.stat lua_path, (err, stat) =>
          if !err
            if stat?.isDirectory()
              @insert_lua_path.setText lua_path

        src_path = path.join root_path, emp.EMP_IMGS_DIR
        fs.stat src_path, (err, stat) =>
          if !err
            if stat?.isDirectory()
              @insert_src_path.setText src_path



  chose_src_path: ->
    tmp_conf_path = @insert_src_path.getText()
    @do_select_path(@insert_src_path, tmp_conf_path)

  chose_css_path: ->
    tmp_conf_path = @insert_css_path.getText()
    @do_select_file(@insert_css_path, tmp_conf_path)

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

  refresh_panl: ->
    @initial_select()
    @cbb_name.setText ""
    @cbb_desc.setText ""
    @cbb_logo.setText ""
    # cbb_name = @cbb_name.getText()?.trim()
    @snippet?.val("")
    @snippet_css?.val("")
    # {name:cbb_name, version:emp.EMP_DEFAULT_VER, path:null, desc: cbb_desc,
    # type: cbb_type, logo:cbb_logo, html:{type:emp.EMP_CON_TYPE, body:ccb_con}, css:null, lua:null, available:true}

  do_cancel: ->
    @toggle()

  do_input: ->
    # console.log atom.workspace.getActivePaneItem()
    # console.log atom.workspace.getActivePane()
    # console.log @insert_html.val()
    # console.log @insert_html.prop('checked')
    console.log @com
    @do_input_snippet()



  do_input_snippet: ->
    console.log @com
    editor = atom.workspace.getActiveTextEditor()

    if editor
      try
        # console.log "css----"
        if @css_insert_flag
          unless !@insert_css.prop('checked')
              # console.log "has css"
            tmp_path = @insert_css_path.getText()
            if !tmp_path
              emp.show_error "插入Css地址不能为空!"
              return

            tmp_ext =  path.extname tmp_path
            if path.extname tmp_path

              if @css_obj.type is emp.EMP_CON_TYPE
                tmp_body = @css_obj.body
              else
                temp_path = path.join @templates_path, @css_obj.body
                tmp_body =  fs.readFileSync temp_path, 'utf-8'
              # console.log
              if fs.existsSync tmp_path
                fs.appendFileSync tmp_path,"\n"+tmp_body
              else
                fs.writeFileSync tmp_path,"\n"+tmp_body
            else
              emp.mkdir_sync_safe tmp_path
              css_obj = @snippet_obj.css

              if css_obj.type is emp.EMP_CON_TYPE
                emp.show_error "请指定需要插入的Css文件!"
                return
              else
                temp_path = path.join @templates_path, css_obj.body
                tmp_body =  fs.readFileSync temp_path, 'utf-8'
                tmp_name = path.basename temp_path
                tmp_re_file = path.join tmp_path, tmp_name
                # console.log tmp_re_file
                # console.log tmp_body
                if fs.existsSync tmp_re_file
                  tmp_flag = @show_alert("指定的 css 文件已经存在,请指定后续操作.")
                  switch tmp_flag
                    when 1
                      fs.appendFileSync tmp_re_file,"\n"+tmp_body
                    when 2
                      fs.writeFileSync tmp_re_file, tmp_body
                    else
                      return
                else
                  fs.writeFileSync tmp_re_file, tmp_body
        # console.log "lua----"
        if @lua_insert_flag
          unless !@insert_lua.prop('checked')

            # console.log "has css"
            tmp_path = @insert_lua_path.getText()
            if !tmp_path
              emp.show_error "插入Lua 地址不能为空!"
              return

            tmp_ext = path.extname tmp_path
            if path.extname tmp_path

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
        # console.log "src----"
        if @src_insert_flag
          unless !@insert_source.prop('checked')
            tmp_path = @insert_src_path.getText()
            # console.log tmp_path
            # console.log @src_obj
            for tmp_src in @src_obj
              temp_path = path.join @templates_path, tmp_src
              f_con = fs.readFileSync temp_path
              tmp_name = path.basename tmp_src
              tmp_re_file = path.join tmp_path, tmp_name
              # force copy
              fs.writeFileSync tmp_re_file, f_con

            # edit_text = editor.getText()
            #
            # html_obj = cheerio.load edit_text
            # re_css = html_obj('style').text()
            # # console.log re_css
            #
            # # re_style = $(edit_text).find 'style'
            # # console.log $(edit_text).find 'style'
            # # if re_style.length >0
            # #   console.log
            # #   re_css = re_style.get(0).innerHTML
            # #   console.log re_css
            # if re_css
            #   snippet_ast = css.parse @css_snippet
            #   snippet_rule_list = snippet_ast.stylesheet.rules
            #   snippet_arr = []
            #   for tmp_rule in snippet_rule_list
            #     # console.log
            #     snippet_arr.push tmp_rule.selectors.toString()
            #
            #
            #   re_ast = css.parse re_css
            #   console.log re_ast
            #   # console.log re_ast.stylesheet
            #
            #   rule_list = re_ast.stylesheet.rules
            #   tmp_arr = []
            #   for tmp_rule in rule_list
            #     # console.log
            #     tmp_arr.push tmp_rule.selectors.toString()
            #   # console.log tmp_arr
            #
            #   add_ast = {"type": "stylesheet", "sty  ele_json:null
            #     lv:emp.EMP_JSON_ELElesheet": {"rules": []}}
            #   add_arr = []
            #   for tmp_rule in snippet_rule_list
            #     # console.log tmp_rule
            #     if !(tmp_arr.indexOf(tmp_rule.selectors.toString())+1)
            #       # re_ast.stylesheet.rules.push tmp_rule
            #       add_arr.push tmp_rule
            #
            #   if add_arr.length >0
            #     add_ast = {"type": "stylesheet", "stylesheet": {"rules": add_arr}}
            #
            #     # console.log re_ast
            #     # console.log re_ast.stylesheet
            #     # console.log tmp_arr
            #     result = css.stringify(add_ast, { sourcemap: true })
            #     # console.log re_ast
            #     # console.log result.code
            #     # console.log line_count = editor.getLineCount()
            #     comment_flag = false
            #     for i in [0..line_count-1]
            #       line_con = editor.lineTextForBufferRow(i)
            #       console.log line_con
            #       console.log "--------#{i}"
            #       if match_re = line_con.match('<style>|<!-.*-->|<!--|-->')
            #         if !comment_flag
            #           if match_re[0] is "<style>"
            #             # console.log "---------------------"
            #             tmp_range = new Range([i+1, 0], [i+1, 0])
            #             editor.setTextInBufferRange(tmp_range, "\n    "+result.code+"\n")
            #             break
            #           else if match_re[0] is '<!--'
            #             comment_flag = true
            #             # console.log "------------comment---------"
            #             continue
            #           else if match_re[0] is '-->'
            #             comment_flag = false
            #
            #         else if match_re[0] is '-->'
            #           comment_flag = false
            #

      catch err
        console.error "insert snippets error "
        console.error err

        # console.log editor.getText()
        # console.log $.parseHTML edit_text
      unless !@insert_html.prop('checked')
        atom.packages.activePackages.snippets?.mainModule?.insert @html_snippet
        # console.log escape edit_text
    @toggle()

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



#
# parse_css: (con) ->
#   tmp_flag = ""
#   tmp_com_flag = false
#   tmp_dom = ''
#   flag=false
#   skip = 0
#   len = con.length
#   for tmp_c,i in con
#     if !skip
#       if tmp_c is '<' and con[i+1] is '!'
#         # tmp_flag = tmp_flag + tmp_c
#         tmp_flag = '<!--'
#         tmp_com_flag = true
#         skip=3
#       else if tmp_c is '-' and con[i+1] is '-' and con[i+2] is '>'
#         tmp_flag = '-->'
#         tmp_com_flag = false
#         skip = 2
#       else if tmp_c is '<'
#         tmp_dom = ''
#         tmp_con = con.slice i+1
#         tmp_skip = 0
#         for tmp_cc,o in tmp_con
#           if tmp_cc isnt '>'
#             tmp_dom = tmp_dom + tmp_cc
#             tmp_skip =
#
#     else
#       skip = skip -1
