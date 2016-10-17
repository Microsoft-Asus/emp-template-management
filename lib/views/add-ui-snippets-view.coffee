{Disposable, CompositeDisposable} = require 'atom'
{$, $$, ScrollView,TextEditorView} = require 'atom-space-pen-views'
path = require 'path'
CSON = require 'cson'
fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'
emp = require '../exports/emp'
ImgSourceElementPanel = require './template_list/img-detail-ele-view'
default_val = 'default'



module.exports =
class InstalledTemplatePanel extends ScrollView
  # EMP_UI_LIB:'Add UI Snippets'
  @content: ->
    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-package', =>
            @text 'Add UI Snippets'
            # @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'

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

          # # 模板所属框架
          # @div class: 'section-body', =>
          #   @div class: 'control-group', =>
          #     @div class: 'controls', =>
          #       @label class: 'control-label', =>
          #         @div class: 'info-label', "模板框架"
          #         @div class: 'setting-description', "模板所属框架(例如 eui)."
          #       # @div class: 'editor-container', =>
          #     @div outlet:'snippet_frame_sel_div', class: 'controls', =>
          #       @label class: 'control-label', =>
          #         @div class: 'setting-description', "默认的的模板框架."
          #       @select outlet:"snippet_frame_sel", id: "snippet_frame_sel", class: 'form-control', =>
          #       # for option in ["emp", "ebank", "boc", "gdb"]
          #         # @option value: "#{emp.EMP_NAME_DEFAULT}", emp.EMP_NAME_DEFAULT
          #     @div class: 'controls', =>
          #       @label class: 'control-label', =>
          #         @div class: 'setting-description', "增加新的模板框架."
          #       @subview "snippet_frame", new TextEditorView(mini: true,attributes: {id: 'snippet_frame', type: 'string'},  placeholderText: ' Snippets  Frame')



          # 模板所属框架类别
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板框架类型"
                  @div class: 'setting-description', "模板所属框架(例如 默认为 eui)."
                # @div class: 'editor-container', =>
              @div outlet:'snippet_pack_sel_div', class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-description', "默认的的模板框架."
                @select outlet:"snippet_pack_sel", id: "snippet_pack_sel", class: 'form-control', =>
                # for option in ["emp", "ebank", "boc", "gdb"]
                  # @option value: "#{emp.EMP_NAME_DEFAULT}", emp.EMP_NAME_DEFAULT
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-description', "增加新的模板框架."
                @subview "snippet_pack", new TextEditorView(mini: true,attributes: {id: 'snippet_pack', type: 'string'},  placeholderText: ' Snippets  description')

          # 模板所属类别
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板类型"
                  @div class: 'setting-description', "模板所属类别(例如 button,input)."
                # @div class: 'editor-container', =>
              @div outlet:'snippet_type_sel_div', class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-description', "默认的的模板类别."
                @select outlet:"snippet_type_sel", id: "snippet_type_sel", class: 'form-control', =>
                # for option in ["emp", "ebank", "boc", "gdb"]
                  # @option value: "#{emp.EMP_NAME_DEFAULT}", emp.EMP_NAME_DEFAULT
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-description', "增加新的模板类别."
                @subview "snippet_type", new TextEditorView(mini: true,attributes: {id: 'snippet_type', type: 'string'},  placeholderText: ' Snippets  description')


          # 模板描述
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板名称*"
                  @div class: 'setting-description', "模板名称(描述)(Snippets  Name),不要重复."
                # @div class: 'editor-container', =>
              @div class: 'controls', =>
                @subview "snippet_name", new TextEditorView(mini: true,attributes: {id: 'snippet_name', type: 'string'},  placeholderText: ' Snippets  Name')

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

          # snippet 生效的文件
          @div outlet:'snippet_scope_div', class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板生效范围选择器*"
                  @div class: 'setting-description', "新添加模板的识别类别, 通过范围选择器來选择 snippet
                  的生效范围.(Snippet scope selector).例如想要添加一段 Erlang 代码内生效的 Snippet, 那么 选择器应该写为 `.source.erlang`, 如果是 lua 的,则为`.source.lua`, 同理,如果为 Emp 的页面, 则可以写为#{emp.DEFAULT_SNIPPET_SOURE_TYPE}.默认为#{emp.DEFAULT_SNIPPET_SOURE_TYPE}"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "snippet_scope", new TextEditorView(mini: true,attributes: {id: 'snippet_scope', type: 'string'},  placeholderText: 'Snippet scope selector (ex: `.source.js`)')


          # 模板说明
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板文字说明*"
                  @div class: 'setting-description', "模板的功能性描述."
                # @div class: 'editor-container', =>
                @textarea "", class: "snippet_area native-key-bindings editor-colors", rows: 8, outlet: "snippet_desc", placeholder: "Snippet Description."

          #  模板内容
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板内容*"
                  @div class: 'setting-description', "Snippets Body"
                # @subview "snippet_body", new TextEditorView(mini: true,attributes: {id: 'snippet_body', type: 'string'},  placeholderText: ' Snippet Body')
                @textarea "", class: "snippet_area native-key-bindings editor-colors", rows: 8, outlet: "snippet_body", placeholder: "Snippet Body"

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板样式*"
                  @div class: 'setting-description', "Snippets Css"
                # @subview "snippet_body", new TextEditorView(mini: true,attributes: {id: 'snippet_body', type: 'string'},  placeholderText: ' Snippet Body')
                # @textarea "", class: "snippet_area native-key-bindings editor-colors", rows: 8, outlet: "snippet_css", placeholder: "Snippet Css"
                # @button class: 'control-btn btn btn-info', click:'create_body',' Create File '
              @div class: 'controls', =>
                @button class: 'control-btn btn btn-info', click:'edit_css',' Edit Common Css File '


          # 模板图片
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板图例*"
                  @div class: 'setting-description', "模板实际效果图例."
              @div class:'control-ol', =>
                @table class:'control-tab',outlet:'image_detail_tree'
              # @div class: 'controls', =>
              #   @div class:'btn-box-n', =>
              #     @button class:'btn btn-info', click:'chose_detail',"Chose Detail"
              @div class: 'controls', =>
                @subview "snippet_img", new TextEditorView(mini: true,attributes: {id: 'snippet_img', type: 'string'},  placeholderText: 'Snippets  Images')
                @div class:'btn-box-n', =>
                  @button class:'btn btn-error', click:'remove_all_detail',"Remove All"
                  @button class:'btn btn-info', click:'chose_detail_f',"Chose File"
                  @button class:'btn btn-info', click:'chose_detail_d',"Chose Dir"
                  @button class:'btn btn-info', click:'add_image_detail_btn',"Add"

                @div outlet:'detail_div', style:"display:none;",class: 'meta_detail', => #style:"display:none;",
                  tmp_log = emp.get_default_logo()
                  console.log tmp_log
                  @img outlet:"detail_img", class: 'avatar', src:"#{tmp_log}"


                # @div class: 'editor-container', =>
              # @div class: 'controls', =>
              #   @subview "snippet_img", new TextEditorView(mini: true,attributes: {id: 'snippet_img', type: 'string'},  placeholderText: ' Snippets  Images')

      @div class: 'footer-div', =>
        @div class: 'footer-detail', =>
          @button outlet:"cancel_btn", class: 'footer-btn btn btn-info inline-block-tight', style:"display:none;", click:'do_cancel','  Cancel  '
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'create_snippet',' Ok '

  initialize: () ->
    super
    @packageViews = []
    @temp_frame = {}
    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    @disposable = new CompositeDisposable

    @snippet_pack.getModel().getBuffer().onDidStopChanging =>
      # console.log "modified text"
      # console.log @snippet_pack.getText()
      if @snippet_pack.getText()
        @snippet_pack_sel_div.hide()
        @snippet_type_sel_div.hide()
      else
        @snippet_pack_sel_div.show()
        @snippet_type_sel_div.show()


    @snippet_pack_sel.change (event) =>
      @snippet_type_sel.empty()
      snippet_pack = @snippet_pack_sel.val()
      type_list = @get_emp_params(snippet_pack)
      console.log type_list
      for tmp_key in type_list
        tmp_option = @new_option(tmp_key)
        @snippet_type_sel.append tmp_option

    @snippet_type.getModel().getBuffer().onDidStopChanging =>
      if @snippet_type.getText()
        @snippet_type_sel_div.hide()
        # @snippet_scope_div.show()
      else
        @snippet_type_sel_div.show()

    @disposable.add atom.commands.add @snippet_img.element, 'core:confirm', =>
      tmp_path = @snippet_img.getText()
      @add_image_detail(tmp_path)

  dispose: ->
    @disposable?.dispose()

  refresh_detail: (edit_data)->
    # console.log 'refresh_detail'
    # 设置 ui snippet 存储路径

    @default_snippet_store_path = atom.config.get(emp.EMP_APP_STORE_UI_PATH)
    [@snippet_sotre_path, @snippet_css_path, @snippet_img_path] = @cbb_management.get_snippet_path()
    snippet_def_pack = emp.EMP_NAME_DEFAULT
    snippet_def_type = default_val
    @edit_flag = false
    if edit_data
      # console.log edit_data
      if edit_data.length <= 2
        @cancel_btn.show()
        [@edit_pack, @edit_source] = edit_data
        snippet_def_pack = @edit_pack
        @snippet_pack.setText("")
        @snippet_type.setText("")
        unless !@edit_source
          @snippet_scope.setText(@edit_source)
      else
        @cancel_btn.show()
        @edit_flag = true

        [@edit_name, @edit_source, @edit_pack, tmp_obj] = edit_data
        {body, prefix, desc, type, img} = tmp_obj

        # [@edit_name, @edit_body, @edit_css, @edit_prefix,
        # @edit_source, @edit_pack] = edit_data

        @snippet_name.setText(@edit_name)
        @snippet_tab.setText(prefix)
        @snippet_scope.setText(@edit_source)
        for tmp_img in img
          tmp_path = path.join @snippet_img_path, tmp_img
          @add_image_detail(tmp_path)
        @snippet_body.context.value = body
        @snippet_desc.context.value = desc
        # @snippet_css.context.value = @edit_css
        # console.log snippet_body
        snippet_def_pack = @edit_pack
        snippet_def_type = type
        @snippet_pack.setText("")
        @snippet_type.setText("")
    else
      @cancel_btn.hide()
      @cleanup()

    fs.readdir @snippet_sotre_path, (err, files) =>
      if err
        console.error err
      else
    #
    #     for tmp_dir in files
    #       tmp_all_dir = path.join @snippet_sotre_path,tmp_dir
    #       tmp_state = fs.statSync(tmp_all_dir)
    #
    #       if tmp_state?.isDirectory()
    #         @temp_frame[tmp_dir]=[]
    #
    #         dir_children = fs.readdirSync tmp_all_dir
    #         # own_frame = path.basename tmp_all_dir
    #         for tmp_file in dir_children
    #           @temp_frame[tmp_dir].push tmp_file
    #       else
    #         @temp_frame[default_val].push tmp_dir
    #
    #
    #     # snippet_frame
    #     @snippet_frame_sel.empty()
    #     @snippet_pack_sel.empty()
    #     for tmp_frame, type_list of @temp_frame
    #       if tmp_frame is  default_val
    #         tmp_option = @new_selected_option(tmp_frame)
    #         @snippet_frame_sel.append tmp_option
    #
    #         for tmp_file in type_list
    #           if path.extname(tmp_file) is emp.DEFAULT_SNIPPET_FILE_EXT
    #             tmp_option_val = path.basename tmp_file, emp.DEFAULT_SNIPPET_FILE_EXT
    #             if tmp_option_val is snippet_def_pack
    #               selected_flag = true
    #               tmp_option = @new_selected_option(tmp_option_val)
    #               @snippet_pack_sel.append tmp_option
    #             else
    #               tmp_option = @new_option(tmp_option_val)
    #               @snippet_pack_sel.append tmp_option
    #
    #
    #       else
    #         tmp_option = @new_option(tmp_frame)
    #         @snippet_frame_sel.append tmp_option



        @snippet_pack_sel.empty()
        @snippet_type_sel.empty()
        # console.log files
        selected_flag = false
        for tmp_file in files
          if path.extname(tmp_file) is emp.DEFAULT_SNIPPET_FILE_EXT
            tmp_option_val = path.basename tmp_file, emp.DEFAULT_SNIPPET_FILE_EXT
            if tmp_option_val is snippet_def_pack
              selected_flag = true
              tmp_option = @new_selected_option(tmp_option_val)
              @snippet_pack_sel.append tmp_option

              type_list = @get_emp_params(tmp_option_val, tmp_file)
              # console.log type_list
              for tmp_key in type_list
                if tmp_key is snippet_def_type
                  tmp_option = @new_selected_option(tmp_key)
                  @snippet_type_sel.append tmp_option
                else
                  tmp_option = @new_option(tmp_key)
                  @snippet_type_sel.append tmp_option
            else
              tmp_option = @new_option(tmp_option_val)
              @snippet_pack_sel.append tmp_option

        unless selected_flag
          if snippet_def_pack is emp.EMP_NAME_DEFAULT
            tmp_sel_option = @new_selected_option(emp.EMP_NAME_DEFAULT)
            @snippet_pack_sel.append tmp_sel_option
            type_list = @get_emp_params(tmp_option_val, tmp_file)
            # console.log type_list
            for tmp_key in type_list
              if tmp_key is snippet_def_type
                tmp_option = @new_selected_option(tmp_key)
                @snippet_type_sel.append tmp_option
              else
                tmp_option = @new_option(tmp_key)
                @snippet_type_sel.append tmp_option

          else
            tmp_sel_option = @new_option(emp.EMP_NAME_DEFAULT)
            @snippet_pack_sel.append tmp_sel_option

  get_emp_params: (snippet_pack, tmp_name) ->
    snippet_obj = {}
    file_name = ''
    if tmp_name
      file_name = path.join @snippet_sotre_path, tmp_name
    else
      file_name = path.join @snippet_sotre_path, snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT

    if !snippet_obj = @temp_frame[snippet_pack]
      file_ext = path.extname file_name
      if fs.existsSync file_name
        if file_ext is emp.JSON_SNIPPET_FILE_EXT
          json_data = fs.readFileSync file_name
          snippet_obj = JSON.parse json_data
        else
          snippet_obj = CSON.parseCSONFile(file_name)
      @temp_frame[snippet_pack] = snippet_obj

    # console.log snippet_obj
    # console.log snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
    if emp_params = snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
      tmp_re = emp_params[emp.DEFAULT_SNIPPET_TYPE_KEY]
      if tmp_re?.length >0
        tmp_re
      else
        [default_val]
    else
      snippet_obj[emp.DEFAULT_SNIPPET_TYPE]={}
      snippet_obj[emp.DEFAULT_SNIPPET_TYPE][emp.DEFAULT_SNIPPET_TYPE_KEY]=[default_val]
      [default_val]


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
    # console.log snippet_pack

    unless snippet_type = @snippet_type.getText()?.trim()
      snippet_type = @snippet_type_sel.val()
    # console.log snippet_type

    if !snippet_name = @snippet_name.getText()?.trim()
      emp.show_error "模板名称不能为空!"
      return

    if !snippet_tab = @snippet_tab.getText()?.trim()
      emp.show_error "模板触发条件不能为空!"
      return

    if !snippet_source = @snippet_scope.getText()?.trim()
      emp.show_error "模板选择器不能为空!"
      return

    if !snippet_info =  @snippet_desc.context.value?.trim()
      emp.show_error "模板文字描述不能为空!"
      return

    snippet_body = @snippet_body.context.value
    # snippet_css = @snippet_css.context.value
    console.log snippet_body
    snippet_obj = null
    file_name = path.join @snippet_sotre_path, snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    if !snippet_obj = @temp_frame[snippet_pack]
      snippet_obj = {}
      snippet_obj[snippet_source] = {}
      file_ext = path.extname file_name
      if fs.existsSync file_name
        if file_ext is emp.JSON_SNIPPET_FILE_EXT
          json_data = fs.readFileSync file_name
          snippet_obj = JSON.parse json_data
        else
          snippet_obj = CSON.parseCSONFile(file_name)

    if snippet_obj[snippet_source]?[snippet_name]
      ck_flag = emp.show_alert "Warnning", "该代码段已经存在,是否要覆盖原有代码段."
      if !ck_flag
        return
      else
        delete snippet_obj[snippet_source]?[snippet_name]
    img_list = new Array()
    for key, tmp_ of @image_detail
      tmp_spath = @copy_content(key, @snippet_img_path, snippet_pack)
      img_list.push tmp_spath

      # @snippet_img_path

    # console.log file_name
    # console.log snippet_source
    if !snippet_obj[snippet_source]
      snippet_obj[snippet_source] = {}
    snippet_obj[snippet_source][snippet_name] = {
      'prefix': snippet_tab
      'body':snippet_body
      'desc':snippet_info
      'type':snippet_type
      'img':img_list
      # 'css': snippet_css
    }
    # console.log snippet_obj


    # 更新类型列表
    tmp_params = snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
    if tmp_type_list = tmp_params?[emp.DEFAULT_SNIPPET_TYPE_KEY]
      if tmp_type_list.indexOf(snippet_type) is -1
        tmp_type_list.push snippet_type
        snippet_obj[emp.DEFAULT_SNIPPET_TYPE][emp.DEFAULT_SNIPPET_TYPE] = tmp_type_list
    else
      tmp_type_list = [snippet_type]
      snippet_obj[emp.DEFAULT_SNIPPET_TYPE] = {}
      snippet_obj[emp.DEFAULT_SNIPPET_TYPE][emp.DEFAULT_SNIPPET_TYPE] = tmp_type_list

    snippet_cson_str = ''
    if file_ext is emp.JSON_SNIPPET_FILE_EXT
      snippet_cson_str = JSON.stringify(snippet_obj, null, '\t')
    else
      snippet_cson_str = CSON.stringify(snippet_obj, null, '\t')

    # console.log file_name
    # console.log snippet_cson_str
    fs.writeFile(file_name, snippet_cson_str, (error) ->
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

  copy_content: (f_path, to_path, add_path) ->
    # console.log t_path
    # console.log f_path
    to_path = path.join to_path, add_path
    to_path_rel = path.relative @snippet_img_path, to_path
    # to_path_rel = path.join to_path_rel, add_path

    emp.mkdir_sync(to_path)
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    # force copy
    re_name = @get_new_name(to_path, f_name)
    # console.log re_name
    re_file = path.join to_path, re_name
    re_file_rel = path.join to_path_rel, re_name
    fs.writeFileSync re_file, f_con  #unless fs.existsSync(re_file)#, 'utf8'
    re_file_rel

  get_new_name:(to_path, f_name) ->
    ext_name = path.extname f_name
    f_name = emp.get_random(1000000)+ext_name
    f_name = @check_exist_img(to_path, f_name, ext_name)
    f_name

  check_exist_img: (to_path, f_name, ext_name) ->
    # console.log to_path
    re_file = path.join to_path, f_name
    if fs.existsSync re_file
      f_name = emp.get_random(1000000)+ext_name
      @check_exist_img(to_path, f_name, ext_name)
    else
      f_name

  # do edit  -------------------------------------------------------------------
  do_edit_snippet: ->
    console.log " create snippet"
      # [@edit_name, @edit_body, @edit_css, @edit_prefix,
      # @edit_source, @edit_pack]

    unless snippet_pack = @snippet_pack.getText()?.trim()
      snippet_pack = @snippet_pack_sel.val()
    # console.log snippet_pack

    unless snippet_type = @snippet_type.getText()?.trim()
      snippet_type = @snippet_type_sel.val()
    # console.log snippet_type

    if !snippet_name = @snippet_name.getText()?.trim()
      emp.show_error "模板名称不能为空!"
      return

    if !snippet_tab = @snippet_tab.getText()?.trim()
      emp.show_error "模板触发条件不能为空!"
      return

    if !snippet_source = @snippet_scope.getText()?.trim()
      emp.show_error "模板选择器不能为空!"
      return

    if !snippet_info =  @snippet_desc.context.value?.trim()
      emp.show_error "模板文字描述不能为空!"
      return

    snippet_body = @snippet_body.context.value
    # snippet_css = @snippet_css.context.value
    # console.log snippet_body

    if snippet_pack isnt @edit_pack
      @delete_element()
    # else if snippet_source isnt @edit_source

    file_name = path.join @snippet_sotre_path, snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    if !snippet_obj = @temp_frame[snippet_pack]
      snippet_obj = {}
      snippet_obj[snippet_source] = {}

      file_ext = path.extname file_name
      if fs.existsSync file_name
        if file_ext is emp.JSON_SNIPPET_FILE_EXT
          json_data = fs.readFileSync file_name
          snippet_obj = JSON.parse json_data
        else
          snippet_obj = CSON.parseCSONFile(file_name)

    if (snippet_source isnt @edit_source) or (snippet_name isnt @edit_name)
      delete snippet_obj[@edit_source]?[@edit_name]

    img_list = new Array()
    for key, tmp_ of @image_detail
      tmp_spath = @copy_content(key, @snippet_img_path, snippet_pack)
      img_list.push tmp_spath

      # @snippet_img_path

    # console.log file_name
    snippet_obj[snippet_source]?[snippet_name] = {
      'prefix': snippet_tab
      'body':snippet_body
      'desc':snippet_info
      'type':snippet_type
      'img':img_list
      # 'css': snippet_css
    }
    # 更新类型列表
    tmp_params = snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
    if tmp_type_list = tmp_params?[emp.DEFAULT_SNIPPET_TYPE_KEY]
      if tmp_type_list.indexOf(snippet_type) is -1
        tmp_type_list.push snippet_type
        snippet_obj[emp.DEFAULT_SNIPPET_TYPE][emp.DEFAULT_SNIPPET_TYPE] = tmp_type_list
    else
      tmp_type_list = [snippet_type]
      snippet_obj[emp.DEFAULT_SNIPPET_TYPE] = {}
      snippet_obj[emp.DEFAULT_SNIPPET_TYPE][emp.DEFAULT_SNIPPET_TYPE] = tmp_type_list

    snippet_cson_str = ''
    if file_ext is emp.JSON_SNIPPET_FILE_EXT
      snippet_cson_str = JSON.stringify(snippet_obj, null, '\t')
    else
      snippet_cson_str = CSON.stringify(snippet_obj, null, '\t')

    fs.writeFile(file_name, snippet_cson_str, (error) ->
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
    edit_file = path.join @snippet_sotre_path, @edit_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    snippet_cson_str = ''
    if fs.existsSync edit_file
      snippet_obj = {}
      file_ext = path.extname edit_file
      if file_ext is emp.JSON_SNIPPET_FILE_EXT
        json_data = fs.readFileSync edit_file
        snippet_obj = JSON.parse json_data
        delete snippet_obj[@edit_source]?[@edit_name]
        snippet_cson_str = JSON.stringify(snippet_obj, null, '\t')
      else
        snippet_obj = CSON.parseCSONFile(edit_file)
        delete snippet_obj[@edit_source]?[@edit_name]
        snippet_cson_str = CSON.stringify(snippet_obj, null, '\t')

    fs.writeFile(edit_file,  snippet_cson_str, (error) ->
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
    @snippet_desc.context.value = ''
    # @snippet_css.context.value = ''
    @snippet_pack.setText("")
    @snippet_type.setText("")
    @snippet_scope.setText(emp.DEFAULT_SNIPPET_SOURE_TYPE)
    for key, tmp_view of @image_detail
      tmp_view.destroy()
    @image_detail={}
    @snippet_img.setText ""
    # @temp_frame = {}
    # @temp_frame[default_val] = []

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

  edit_css: ->
    tmp_file = @initial_css_file()
    @create_editor(tmp_file, emp.EMP_GRAMMAR_CSS)
    # , (tmp_editor) =>
                    # do nothing
                    # console.log "nothing"
                    # tmp_editor.onDidSave (event) =>
                    #   # console.log event
                    #   tmp_body = tmp_editor.getText()
                      # @snippet_body_text = tmp_body
                      # @snippet_body.context.value = tmp_body
                  # ," ")

  initial_css_file: ->
    snippet_pack = ''
    unless snippet_pack = @snippet_pack.getText()?.trim()
      snippet_pack = @snippet_pack_sel.val()
    tmp_path = path.join @snippet_css_path, snippet_pack+".css"



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

# --------------------- add detail images -------------
  # 添加图例
  add_image_detail_btn:() ->
    if tmp_path = @snippet_img.getText()
      @add_image_detail(tmp_path)

  add_image_detail: (tmp_path)->
    console.log tmp_path
    # console.log "add image detail"
    # if tmp_path = @snippet_img.getText()
    fs.stat tmp_path, (err, stats) =>
      if err
        console.log err

      if stats?.isFile()
        unless @image_detail[tmp_path]
          tmp_view = new ImgSourceElementPanel(this, tmp_path)
          @image_detail[tmp_path] = tmp_view
          @image_detail_tree.append tmp_view

      else if stats?.isDirectory()
        fs.readdir tmp_path, (err, files) =>
          if err
            console.log "no exist files"
          else
            src_files = files.filter((ele)-> !ele.match(/^\./ig))
            for tmp_file in src_files
              tmp_name = path.join tmp_path, tmp_file
              unless @image_detail[tmp_name]
                tmp_state = fs.statSync tmp_name
                if tmp_state?.isFile()
                  tmp_view = new ImgSourceElementPanel(this, tmp_name)
                  @image_detail[tmp_name] = tmp_view
                  @image_detail_tree.append tmp_view

  show_detail_img: (img) ->
    # @detail_img.attr("src", img)
    # @logo_image.attr("src", tmp_path)
    @detail_img.attr("src", img)
    @detail_div.show()


  remove_detail_callback: (name)->
    delete @image_detail[name]

  chose_detail_f: ->
    emp.chose_detail_f (text) =>
      @snippet_img.setText text

  chose_detail_d: ->
    emp.chose_detail_d (text) =>
      @snippet_img.setText text
