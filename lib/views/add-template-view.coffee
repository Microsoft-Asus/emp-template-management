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
CbbEle = require '../util/emp_cbb_element'
templates_store_path = null
templates_json = null
templates_obj = null
default_select_pack = emp.EMP_DEFAULT_PACKAGE

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
                  @div class: 'info-label', "模板所属包"
                  @div class: 'setting-description', "插件包所属选择"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @select outlet:"pack_select", id: "pack", class: 'form-control'

          # 包类型
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板类型"
                  @div class: 'setting-description', "目前分为控件"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @select outlet:"type_select", id: "type", class: 'form-control'

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
                      @button class: 'control-btn btn btn-info', click:'select_logo',' Chose Other Logo '

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

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "描述"
                  @div class: 'setting-description', "为你的模板添加描述"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "template_desc", new TextEditorView(mini: true,attributes: {id: 'template_desc', type: 'string'},  placeholderText: ' Template Describtion')
                # @textarea "", class: "native-key-bindings editor-colors", rows: 8, outlet: "template_desc", placeholder: "Template Describtion"

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
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'create_snippet',' Ok '

  initialize: () ->
    super
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @packs = @cbb_management.get_pacakges()

    if !templates_store_path = atom.project.templates_path
      atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
      templates_store_path =atom.project.templates_path
    # console.log "stsore_path: #{templates_store_path}"
    emp.mkdir_sync templates_store_path
    templates_json = path.join templates_store_path, emp.EMP_TEMPLATE_JSON

    @cbb_management = atom.project.cbb_management
    # console.log templates_json
    fs.readFile templates_json, (err, data) ->
      if err
        console.log "no exist"
        templates_obj = null
      else
        templates_obj = JSON.parse data


    @logo_select.change (event) =>
      @logo_image.attr("src", @logo_select.val())
    @do_initial()

  do_initial: ()->
    @pack_select.change (event) =>
      tmp_name = @pack_select.val()
      tmp_obj = @packs[tmp_name]
      type_list = tmp_obj.get_type()
      @type_select.empty()
      for tmp_type in type_list
        @type_select.append @new_option(tmp_type)

    @pack_select.empty()
    for name, obj of @packs
      if name is default_select_pack
        @pack_select.append @new_selec_option(name)
      else
        @pack_select.append @new_option(name)
    # console.log @packs
    tmp_pack = @packs[default_select_pack]
    # console.log tmp_pack
    type_list = tmp_pack.get_type()
    @type_select.empty()
    for tmp_type in type_list
      @type_select.append @new_option(tmp_type)

  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selec_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name

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

  # btn callback for logo
  select_logo: (e, element)->
    tmp_path = @template_logo.getText()
    dialog.showOpenDialog title: 'Select', properties: ['openDirectory', 'openFile'], (logo_path) =>
      # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
      path_state = fs.statSync logo_path
      if path_state?.isDirectory()
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
              @logo_select.append tmp_opt
      else
        tmp_opt = document.createElement 'option'
        tmp_opt.text = path.basename logo_path
        tmp_opt.value = path.join logo_path, logo_path
        @logo_select.append tmp_opt

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
        templates_obj = emp.new_templates_obj()

      emp.mkdir_sync template_store_path
      temp_obj = @new_template_obj(temp_name, template_store_path)
      # console.log templates_obj
      # console.log temp_obj
      if temp_path
        @copy_template(template_store_path, temp_path)

      @format_template(template_store_path, temp_obj)
      # console.log temp_obj

      templates_obj.templates[temp_type][temp_name] = temp_obj
      templates_obj.templates[temp_type].length += 1
      json_str = JSON.stringify(templates_obj)
      fs.writeFileSync templates_json, json_str

      temp_str = JSON.stringify temp_obj
      fs.writeFileSync template_json, temp_str

      emp.show_info("添加模板 完成~")
    else
      console.log "exist -------"
      emp.show_info("该模板已经存在~")

  format_template: (to_path, temp_obj) ->
    if temp_obj.logo
      temp_obj.logo = @copy_content_ch(to_path, temp_obj.logo, emp.EMP_LOGO_DIR)
    if temp_obj.html
      temp_obj.html = @copy_content_ch(to_path, temp_obj.html, emp.EMP_HTML_DIR)
    if temp_obj.css
      temp_obj.css = @copy_content_ch(to_path, temp_obj.css, emp.EMP_CSS_DIR)
    if temp_obj.lua
      temp_obj.lua = @copy_content_ch(to_path, temp_obj.lua, emp.EMP_LUA_DIR)
    temp_obj

  copy_template: (to_path, basic_dir)->

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

  copy_content_ch: (t_path, f_path, add_path="") ->
    # console.log t_path
    # console.log f_path
    to_path = path.join t_path, add_path
    # console.log to_path
    emp.mkdir_sync(to_path)
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    re_file = path.join to_path, f_name
    # force copy
    fs.writeFileSync re_file, f_con  #unless fs.existsSync(re_file)#, 'utf8'
    re_file

  copy_content: (t_path, f_path)->
    # console.log "copy file: #{t_path}, #{f_path}"
    # f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    # re_file = path.join t_path, f_name
    # force copy
    fs.writeFileSync t_path, f_con  #unless fs.existsSync(re_file)#, 'utf8'

  new_template_obj: (name, path)->
    logo = @logo_select.val()
    ver = @template_ver.getText()?.trim()
    desc = @template_desc.getText()?.trim()
    html_temp = @template_html.getText()?.trim()
    css_temp = @template_css.getText()?.trim()
    # logo = @logo_select.val()

    {name:name, version:ver, path:path, desc: desc, logo:logo, html:html_temp, css:css_temp, available:true}

  create_snippet: ->
    console.log "button down"
    cbb_name = @template_name.getText()?.trim()
    cbb_obj = @new_template_obj2(cbb_name)
    console.log cbb_obj
    @cbb_management.add_element(cbb_obj)
    emp.show_info("添加模板 完成~")
    # @destroy()

  new_template_obj2: (cbb_name)->
    cbb_desc = @template_desc.getText()?.trim()
    cbb_logo = @logo_select.val()
    # cbb_name = @cbb_name.getText()?.trim()
    cbb_html = @template_html.getText()?.trim()
    cbb_css = @template_css.getText()?.trim()
    cbb_pack = @pack_select.val()
    cbb_type = @type_select.val()
    console.log cbb_type
    cbb_obj = new CbbEle(cbb_name, cbb_desc, cbb_logo, cbb_type, cbb_pack)
    cbb_obj.set_file cbb_html, emp.EMP_QHTML
    cbb_obj.set_file cbb_css, emp.EMP_QCSS
    cbb_obj
