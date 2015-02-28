# _ = require 'underscore-plus'
# {TextEditorView} = require 'atom-space-pen-views'
# {ScrollView} = require 'atom'

{$, $$, ScrollView} = require 'atom'
{TextEditorView} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
# {Subscriber} = require 'emissary'
# fuzzaldrin = require 'fuzzaldrin'

# AvailableTemplateView = require './available-template-view'
# ErrorView = require './error-view'
remote = require 'remote'
dialog = remote.require 'dialog'
emp = require '../exports/emp'
templates_store_path = null
templates_json = null
templates_obj = null

module.exports =
class InstalledTemplatePanel extends ScrollView
  # Subscriber.includeInto(this)

  @content: ->
    logo_path =  path.join __dirname, '../../images/logo'
    logo_imgs = fs.readdirSync(logo_path).filter((ele)-> !ele.match(/^\./ig))
    index = Math.round Math.random()*(logo_imgs.length-1)
    # console.log index
    # console.log logo_imgs
    logo_img = path.join logo_path,logo_imgs[index]

    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-package', =>
            @text 'Add Packages'
            @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'


          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板路径"
                  @div class: 'setting-description', "Root Dir Name"
                # @div class: 'editor-container', =>
                @subview "template_path", new TextEditorView(mini: true,attributes: {id: 'template_path', type: 'string'},  placeholderText: ' Template Path')
                # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
                @button class: 'control-btn btn btn-info', click:'select_path',' Chose Path '

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板名称"
                  @div class: 'setting-description', "Template Package Name"
                # @div class: 'editor-container', =>
                @subview "template_name", new TextEditorView(mini: true,attributes: {id: 'template_name', type: 'string'},  placeholderText: ' Template Name')

          # 包版本号
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板版本"
                  @div class: 'setting-description', "默认为0.1, 每次+0.1"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                # @div class: 'editor-container', =>
                @subview "template_ver", new TextEditorView(mini: true,attributes: {id: 'template_ver', type: 'string'},  placeholderText: ' Template Version')

          # 包类型
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板类型"
                  @div class: 'setting-description', "目前分为控件"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @select outlet:"type_select", id: "type", class: 'form-control', =>

                  if !emp_cbb_types = atom.config.get emp.EMP_CBB_TYPE
                    atom.config.set emp.EMP_CBB_TYPE, emp.EMP_CPP_TYPE_DEF
                    emp_cbb_types = emp.EMP_CPP_TYPE_DEF
                  for option in emp_cbb_types
                    @option value: option, option
                  @option selected:'select', value: emp.EMP_DEFAULT_TYPE, emp.EMP_DEFAULT_TYPE

          # 包图标
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "Logo"
                  @div class: 'setting-description', "缩略图"

              @div class: 'controls', =>
                @div class:'controle-logo', =>
                  @div class: 'meta-user', =>
                    @img outlet:"logo_image", class: 'avatar', src:"#{logo_img}"
                  @div class:'meta-controls', =>
                    @div class:'btn-group', =>
                      @select outlet:"logo_select", id: "logo", class: 'form-control', =>
                        # for option in ["emp", "ebank", "boc", "gdb"]
                        @option value: "#{logo_img}", emp.EMP_NAME_DEFAULT
                      @button class: 'control-btn btn btn-info', click:'select_path',' Chose Other Logo '

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "描述"
                  @div class: 'setting-description', "为你的模板添加描述"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "template_desc", new TextEditorView(mini: true,attributes: {id: 'template_desc', type: 'string'},  placeholderText: ' Template Describtion')

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板报文"
                  @div class: 'setting-description', "模板插入的报文实体"
                # @div class: 'editor-container', =>
                @subview "template_html", new TextEditorView(mini: true,attributes: {id: 'template_html', type: 'string'},  placeholderText: ' Template Html Content')
                # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
                @button class: 'control-btn btn btn-info', click:'select_html',' Chose File '

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板样式"
                  @div class: 'setting-description', "模板插入的样式实体"
                # @div class: 'editor-container', =>
                @subview "template_css", new TextEditorView(mini: true,attributes: {id: 'template_css', type: 'string'},  placeholderText: ' Template Css Style')
                # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
                @button class: 'control-btn btn btn-info', click:'select_css',' Chose File '

            # @div class: 'control-group', =>
            #   @div class: 'controls', =>
            #     @label class: 'control-label', =>
            #       @div class: 'setting-title', "Name"
            #       @div class: 'setting-description', "Root Dir Name"
            #
            #     # @subview "template_name_editor", style:"display:none;", new TextEditorView(mini: true, attributes: {id: 'template_name', type: 'string'}, placeholderText: 'Application Name')
            #     @select outlet:"name_select", id: "tt", class: 'form-control', =>
            #       for option in ["emp", "ebank", "boc", "gdb"]
            #         @option value: option, option
            #       @option value: emp.EMP_NAME_DEFAULT, emp.EMP_NAME_DEFAULT

            # @div class: 'control-group', =>
            #   @div class: 'controls', =>
            #     @label class: 'control-label', =>
            #       @div class: 'setting-title', "Version"
            #       @div class: 'setting-description', "Root Dir Name"
            #
            #     # @subview "template_name_editor", style:"display:none;", new TextEditorView(mini: true, attributes: {id: 'template_name', type: 'string'}, placeholderText: 'Application Name')
            #     @select outlet:"name_select", id: "tt", class: 'form-control', =>
            #       for option in ["1.1", "1.2", "1.0"]
            #         @option value: option, option
            #       @option value: emp.EMP_NAME_DEFAULT, emp.EMP_NAME_DEFAULT


      @div class: 'footer-div', =>
        @div class: 'footer-detail', =>
          # @button class: 'footer-btn btn btn-info inline-block-tight', click:'do_cancel','  Cancel  '
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'do_submit',' Ok '

  initialize: () ->
    super
    @packageViews = []
    if !templates_store_path = atom.project.templates_path
      atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
      templates_store_path =atom.project.templates_path
    console.log "store_path: #{templates_store_path}"
    emp.mkdir_sync templates_store_path
    templates_json = path.join templates_store_path, emp.EMP_TEMPLATES_JSON
    console.log templates_json
    fs.readFile templates_json, (err, data) ->
      if err
        console.log "no exist"
        templates_obj = null
      else
        templates_obj = JSON.parse data

    #
    # if fs.existsSync templates_json
    #   console.log "exists"
    #   fs.readFileSync templates_json
    #   templates_obj = JSON.parse templates_json

    # console.log @template_path_e.getEditor().getText()

    # @template_path.getModel().onDidStopChanging =>
    # # @template_path.getEditor().on 'contents-modified', =>
    #   console.log @template_path.getText()

    @logo_select.change (event) =>
      # console.log @logo_select
      # console.log @logo_select.val()
      @logo_image.attr("src", @logo_select.val())
      # console.log @logo_image

    # @option_default.on 'click', ->
    #   "click default"
    # console.log @template_name_editor
    # console.log @template_name_editor.show()
    #
    # g_select = @name_select
    # g_editor = @template_name_editor
    # @name_select.change (event, p2, p3) ->
    #   # console.log "val channge"
    #   console.log event
      # console.log p2
      # console.log p3
      # current_view = event.currentTargetView()
      # console.log event.targetView()
      # temp_editor = event.targetView().template_name_editor
      # console.log temp_editor
      # console.log event.targetView().name_select
      #
      # event.targetView().name_select.hide()
      # temp_editor.show()

      # console.log current_view
      # parent_view = current_view.parent()?[0]
      # console.log parent_view


      # tmp_name = g_select.val()
      # # console.log tmp_name
      # if tmp_name is emp.EMP_NAME_DEFAULT
      # #   # @emp_log_color_list.css('background-color', tmp_color)
      #
      #   g_select.hide()
      #   console.log g_editor
      #   console.log g_select
      #   g_editor.getModel().show()



      #   client_id = @emp_client_list.val()
      #   if client_id isnt @default_color_name
      #     log_map[client_id].set_color(tmp_color)
      # else
      #   @emp_log_color_list.css('background-color', @default_color_value)
        # @find('atom-text-editor[id]').views().forEach (editorView) =>
        #   # editor = editorView.getModel()
        #   console.log name
        #   name = editorView.attr('id')
        #   type = editorView.attr('type')
        #
        #   if name is 'template_name'
        #     editorView.show()
        # editor.setPlaceholderText("Default: #{defaultValue}")

      # @observe name, (value) =>
      #   if @isDefault(name)
      #     stringValue = ''
      #   else
      #     stringValue = @valueToString(value) ? ''
      #
      #   return if stringValue is editor.getText()
      #   return if _.isEqual(value, @parseValue(type, editor.getText()))
      #
      #   editorView.setText(stringValue)
      #
      # editor.onDidStopChanging =>
      #   @set(name, @parseValue(type, editor.getText()))

  detached: ->
    # @unsubscribe()
    console.log "----"

  select_path: (e, element)->
    tmp_path = @template_path.getText()
    view_set = {path:@template_path,name:@template_name,ver:@template_ver,logo:@logo_select,html:@template_html,css:@template_css}
    @prompt_for_path(view_set, tmp_path)

  prompt_for_path: (view_set, def_path) ->
    if def_path
      dialog.showOpenDialog title: 'Select', defaultPath:def_path, properties: ['openDirectory', 'createDirectory'], (paths_to_open) =>
        @refresh_path( paths_to_open, view_set)
    else
      dialog.showOpenDialog title: 'Select', properties: ['openDirectory', 'createDirectory'], (paths_to_open) =>
        @refresh_path( paths_to_open, view_set)

  refresh_path: (new_paths, view_set)->
    if new_paths
      console.log new_paths
      new_path = new_paths[0]
      view_set.path.setText(new_path)
      path_state = fs.statSync new_path

      if path_state?.isDirectory()
        console.log "----------------"
        name = path.basename new_path
        view_set.name.setText(name)
        view_set.ver.setText(emp.EMP_DEFAULT_VER)

        html_path = path.join new_path, emp.EMP_HTML_DIR
        fs.readdir html_path, (err, files) =>
          if err
            console.log "no exist html files"
          else
            html_files = files.filter((ele)-> !ele.match(/^\./ig))
            if html_files?.length
              view_set.html.setText(path.join html_path,html_files[0])

        css_path = path.join new_path, emp.EMP_CSS_DIR
        fs.readdir css_path, (err, files) =>
          if err
            console.log "no exist css file"
          else
            css_files = files.filter((ele)-> !ele.match(/^\./ig))
            if css_files?.length
              view_set.css.setText(path.join css_path, css_files[0])

        logo_path =  path.join new_path,emp.EMP_LOGO_DIR
        fs.readdir logo_path, (err, files) =>
          if err
            console.log "no exist"
          else
            logo_images = files.filter((ele)-> !ele.match(/^\./ig))
            # console.log logo_images
            for logo in logo_images
              tmp_opt = document.createElement 'option'
              tmp_opt.text = logo
              tmp_opt.value = path.join logo_path, logo
              # console.log tmp_opt
              view_set.logo.append tmp_opt
            # console.log log_view

  # callback function for button
  select_html: (e, element)->
    console.log "select html"
    tmp_con = @template_html.getText()
    @prompt_for_file(@template_html, tmp_con)

  select_css: (e, element)->
    console.log "select css"
    # console.log element
    tmp_con = @template_css.getText()
    @prompt_for_file(@template_css, tmp_con)

  prompt_for_file: (file_view, tmp_con) ->
    if tmp_con
      dialog.showOpenDialog title: 'Select', defaultPath:tmp_con, properties: ['openDirectory', 'openFile'], (paths_to_open) =>
        # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
        @refresh_editor(file_view, paths_to_open)
    else
      dialog.showOpenDialog title: 'Select', properties: ['openDirectory', 'openFile'], (paths_to_open) =>
        # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
        @refresh_editor(file_view, paths_to_open)

  refresh_editor: (file_view, new_paths) ->
    if new_paths
      console.log new_paths
      new_path = new_paths[0]
      file_view.setText(new_path)

  do_submit: ->
    console.log "do_submit"
    temp_path = @template_path.getText()?.trim()
    temp_name = @template_name.getText()?.trim()
    temp_type = @type_select.val()
    # console.log temp_type

    # console.log temp_logo

    template_store_path = path.join templates_store_path, temp_name
    template_json = path.join template_store_path, emp.EMP_TEMPLATE_JSON
    temp_obj = null
    # if fs.existsSync templates_json

    if !templates_obj?.templates[temp_type][temp_name]
      if !templates_obj
        templates_obj = @new_templates_obj()

      pre_logo_path = @logo_select.val()
      logo_basename = path.basename pre_logo_path
      template_logo_path = path.join template_store_path, logo_basename
      emp.mkdir_sync template_store_path
      if !fs.existsSync(template_logo_path)#, 'utf8'
        tmp_con = fs.readFileSync pre_logo_path
        fs.writeFileSync template_logo_path, tmp_con

      temp_obj = @new_template_obj(temp_name, template_store_path, template_logo_path)
      console.log templates_obj
      templates_obj.templates[temp_type][temp_name] = temp_obj
      templates_obj.templates[temp_type].length += 1
      json_str = JSON.stringify(templates_obj)
      fs.writeFileSync templates_json, json_str

      temp_str = JSON.stringify temp_obj
      fs.writeFileSync template_json, temp_str
      @copy_template(template_store_path, temp_path)
      emp.show_info("添加模板 完成~")
    else
      console.log "exist -------"
      emp.show_info("该模板已经存在~")

  copy_template: (to_path, basic_dir)->
    # console.log "copy  template`````--------"
    # console.log to_path
    # console.log basic_dir
    files = fs.readdirSync(basic_dir)
    for template in files
      if !template.match(/^\./ig)
        f_path = path.join basic_dir, template
        t_path = path.join to_path, template
        if fs.lstatSync(f_path).isDirectory()
          emp.mkdir_sync(t_path)
          @copy_template(t_path, f_path)
        else
          @copy_content(t_path, f_path)


  # string_replace: (str) ->
  #   map = [{'k':/\$\{app\}/ig,'v':@app_name}, {'k':/\$\{ecl_ewp\}/ig,'v':@ewp_dir}]
  #   for o in map
  #     str = str.replace(o.k, o.v)
  #   str

  copy_content: (t_path, f_path)->
    # console.log "copy file: #{t_path}, #{f_path}"
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    fs.writeFileSync t_path, f_con  unless fs.existsSync(path.join t_path, f_name)#, 'utf8'

  new_template_obj: (name, path, logo)->
    ver = @template_ver.getText()?.trim()
    desc = @template_desc.getText()?.trim()
    html_temp = @template_html.getText()?.trim()
    css_temp = @template_css.getText()?.trim()
    # logo = @logo_select.val()

    {name:name, version:ver, path:path, desc: desc, logo:logo, html:html_temp, css:css_temp, available:true}

  new_templates_obj: ->
    tmp_obj = {templates:{}, length:0}
    if !emp_cbb_types = atom.config.get emp.EMP_CBB_TYPE
      atom.config.set emp.EMP_CBB_TYPE, emp.EMP_CPP_TYPE_DEF
      emp_cbb_types = emp.EMP_CPP_TYPE_DEF
    emp_cbb_types.push emp.EMP_DEFAULT_TYPE

    for cbb_type in emp_cbb_types
      tmp_obj.templates[cbb_type] = new Object(length:0)
    tmp_obj
