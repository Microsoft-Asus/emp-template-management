{$, $$, ScrollView} = require 'atom'
{TextEditorView} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'
emp = require '../exports/emp'
CbbEle = require '../util/emp_cbb_element'
CbbSrcEleView = require './template_list/cbb-source-ele-view'
default_select_pack = emp.EMP_DEFAULT_PACKAGE

module.exports =
class InstalledTemplatePanel extends ScrollView
  # Subscriber.includeInto(this)
  source_files:{}
  image_detail:{}

  @content: ->
    logo_path =  path.join __dirname, '../../images/logo'
    logo_imgs = fs.readdirSync(logo_path).filter((ele)-> !ele.match(/^\./ig))
    index = Math.round Math.random()*(logo_imgs.length-1)
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
          # 描述
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "描述"
                  @div class: 'setting-description', "为你的模板添加描述"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "template_desc", new TextEditorView(mini: true,attributes: {id: 'template_desc', type: 'string'},  placeholderText: ' Template Describtion')
          # # 包版本号
          # @div class: 'section-body', =>
          #   @div class: 'control-group', =>
          #     @div class: 'controls', =>
          #       @label class: 'control-label', =>
          #         @div class: 'info-label', "模板版本"
          #         @div class: 'setting-description', "默认为0.1, 每次+0.1"
          #     @div class: 'controls', =>
          #       # @div class: 'editor-container', =>
          #       # @div class: 'editor-container', =>
          #       @subview "template_ver", new TextEditorView(mini: true,attributes: {id: 'template_ver', type: 'string'},  placeholderText: ' Template Version')

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
                  @div class: 'info-label', "模板脚本"
                  @div class: 'setting-description', "模板插入的脚本"
                # @div class: 'editor-container', =>
                @subview "template_lua", new TextEditorView(mini: true,attributes: {id: 'template_lua', type: 'string'},  placeholderText: ' Template Lua Script')
                # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
                @button class: 'control-btn btn btn-info', click:'select_lua',' Chose File '

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

          # 实际样式
          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "Detail Image"
                  @div class: 'setting-description', "模板实际效果展示图"
              @div class:'control-ol', =>
                @table class:'control-tab',outlet:'image_detail_tree'

              @div class: 'controls', =>
                @div class:'controle-logo', =>
                  @div class: 'meta-user', =>
                    @img outlet:"detail_image", class: 'avatar', src:""
              # @div class: 'controls', =>
              #   @div class:'btn-box-n', =>
              #     @button class:'btn btn-info', click:'chose_detail',"Chose Detail"
              @div class: 'controls', =>
                @subview "detail_img_text", new TextEditorView(mini: true,attributes: {id: 'detail_img_text', type: 'string'},  placeholderText: ' detail img')
                @div class:'btn-box-n', =>
                  @button class:'btn btn-error', click:'remove_all_detail',"Remove All"
                  @button class:'btn btn-info', click:'chose_detail_f',"Chose File"
                  @button class:'btn btn-info', click:'chose_detail_d',"Chose Dir"
                  @button class:'btn btn-info', click:'add_image_detail_btn',"Add"

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "资源文件"
                  @div class: 'setting-description', "为你的模板添加资源文件"
              @div class:'control-ol', =>
                @table class:'control-tab',outlet:'cbb_tree'
              @div class: 'controls', =>
                @subview "source_file", new TextEditorView(mini: true,attributes: {id: 'source_file', type: 'string'},  placeholderText: ' Source Files')
                @div class:'btn-box-n', =>
                  @button class:'btn btn-error', click:'remove_all',"Remove All"
                  @button class:'btn btn-info', click:'select_source_f',"Chose File"
                  @button class:'btn btn-info', click:'select_source_d',"Chose Dir"
                  @button class:'btn btn-info', click:'add_source_btn',"Add"

      @div class: 'footer-div', =>
        @div class: 'footer-detail', =>
          # @button class: 'footer-btn btn btn-info inline-block-tight', click:'do_cancel','  Cancel  '
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'create_snippet',' Ok '

  initialize: () ->
    super
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @packs = @cbb_management.get_pacakges()

    # @cbb_management = atom.project.cbb_management
    # console.log templates_json

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

  refresh_detail: ->
    console.log 'refresh_detail'
    @packs = @cbb_management.get_pacakges()
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
    view_set = {path:@template_path,name:@template_name,logo:@logo_select,html:@template_html,css:@template_css, lua:@template_lua}
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
        # view_set.ver.setText(emp.EMP_DEFAULT_VER)

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

        lua_path = path.join new_path, emp.EMP_LUA_DIR
        fs.readdir lua_path, (err, files) =>
          if err
            console.log "no exist lua file"
          else
            lua_files = files.filter((ele)-> !ele.match(/^\./ig))
            if lua_files?.length
              view_set.lua.setText(path.join lua_path, lua_files[0])

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

        src_path =  path.join new_path,emp.EMP_IMG_DIR
        @image_detail = {}
        @cbb_tree.empty()

        @image_detail_tree.empty()
        @source_files = {}
        @image_detail = {}
        @add_source(src_path)

  # callback function for button
  select_html: (e, element)->
    # console.log "select html"
    tmp_con = @template_html.getText()
    @prompt_for_file(@template_html, tmp_con)

  select_css: (e, element)->
    # console.log "select css"
    # console.log element
    tmp_con = @template_css.getText()
    @prompt_for_file(@template_css, tmp_con)

  select_lua: (e, element) ->
    tmp_con = @template_lua.getText()
    @prompt_for_file(@template_lua, tmp_con)

  # btn callback for logo
  select_logo: (e, element)->
    # tmp_path = @template_logo.getText()
    dialog.showOpenDialog title: 'Select', properties: ['openFile'], (logo_path) =>
      # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
      # console.log logo_path
      unless !logo_path
        tmp_path = logo_path[0]
        path_state = fs.statSync tmp_path
        # if path_state?.isDirectory()
        #   fs.readdir tmp_path, (err, files) =>
        #     if err
        #       console.log "no exist"
        #     else
        #       logo_images = files.filter((ele)-> !ele.match(/^\./ig))
        #       # console.log logo_images
        #       for logo in logo_images
        #         tmp_opt = document.createElement 'option'
        #         tmp_opt.text = logo
        #         tmp_opt.value = path.join tmp_path, logo
        #         # console.log tmp_opt
        #         @logo_select.append tmp_opt
        # else
        tmp_opt = document.createElement 'option'
        tmp_opt.text = path.basename tmp_path
        tmp_opt.value = logo_path
        @logo_select.append tmp_opt

  prompt_for_file: (file_view, tmp_con) ->
    if tmp_con
      dialog.showOpenDialog title: 'Select', defaultPath:tmp_con, properties: ['openFile'], (paths_to_open) =>
        # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
        @refresh_editor(file_view, paths_to_open)
    else
      dialog.showOpenDialog title: 'Select', properties: ['openFile'], (paths_to_open) =>
        # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
        @refresh_editor(file_view, paths_to_open)

  refresh_editor: (file_view, new_paths) ->
    if new_paths
      # console.log new_paths
      new_path = new_paths[0]
      file_view.setText(new_path)

  create_snippet: ->
    # console.log "button down"
    if !@template_name.getText()
      emp.show_error "模板名称不能为空"
      return

    cbb_name = @template_name.getText()?.trim()
    cbb_obj = @new_template_obj(cbb_name)
    # console.log cbb_obj
    @cbb_management.add_element(cbb_obj)
    emp.show_info("添加模板 完成~")
    # @destroy()

  new_template_obj: (cbb_name)->
    cbb_desc = @template_desc.getText()?.trim()
    cbb_logo = @logo_select.val()
    # cbb_name = @cbb_name.getText()?.trim()
    cbb_html = @template_html.getText()?.trim()
    cbb_css = @template_css.getText()?.trim()
    cbb_lua = @template_lua.getText()?.trim()
    cbb_pack = @pack_select.val()
    cbb_type = @type_select.val()
    # cbb_detail_img = @detail_image.attr("src")
    # @source_file
    source_list = []
    for tmp_name, tmp_view of @source_files
      source_list.push tmp_name

    tmp_img_list = []
    for tmp_name, tmp_view of @image_detail
      tmp_img_list.push tmp_name
    # console.log cbb_type
    cbb_obj = new CbbEle(cbb_name, cbb_desc, cbb_logo, cbb_type, cbb_pack, tmp_img_list, source_list)
    cbb_obj.set_file cbb_html, emp.EMP_QHTML
    cbb_obj.set_file cbb_css, emp.EMP_QCSS
    cbb_obj.set_file cbb_lua, emp.EMP_QLUA
    cbb_obj

  # 添加资源文件
  add_source_btn: () ->
    @add_source()

  add_source: (tmp_path)->
    # console.log "add source"
    if tmp_path ?= @source_file.getText()
      # console.log tmp_path
      fs.stat tmp_path, (err, stats) =>
        if err
          console.log err

        if stats?.isFile()
          unless @source_files[tmp_path]
            tmp_view = new CbbSrcEleView(this, tmp_path)
            @source_files[tmp_path] = tmp_view
            @cbb_tree.append tmp_view

        else if stats?.isDirectory()
          fs.readdir tmp_path, (err, files) =>
            if err
              console.log "no exist files"
            else
              # console.log files
              src_files = files.filter((ele)-> !ele.match(/^\./ig))
              # console.log src_files
              for tmp_file in src_files
                tmp_name = path.join tmp_path, tmp_file
                unless @source_files[tmp_name]
                  tmp_state = fs.statSync tmp_name
                  if tmp_state?.isFile()
                    tmp_view = new CbbSrcEleView(this, tmp_name)
                    @source_files[tmp_name] = tmp_view
                    @cbb_tree.append tmp_view

  # remove  callback
  remove_td_callback: (name)->
    delete @source_files[name]

  select_source_f: ->
    @select_source(['openFile'])

  select_source_d: ->
    @select_source(['openFile', "openDirectory"])

  select_source: (opts=['openFile', "openDirectory"])->
    # console.log "select source"
    dialog.showOpenDialog title: 'Select', properties: opts, (src_path) => # 'openDirectory'
      # console.log logo_path
      if src_path
        @source_file.setText src_path[0]


  # 删除所有添加的资源
  remove_all: ->
    for tmp_name, tmp_view of @source_files
      tmp_view.destroy()
    @source_files ={}

  #
  add_image_detail_btn:() ->
    @add_image_detail()

  add_image_detail: ()->
    # console.log "add image detail"
    if tmp_path = @detail_img_text.getText()
      fs.stat tmp_path, (err, stats) =>
        if err
          console.log err

        if stats?.isFile()
          unless @image_detail[tmp_path]
            tmp_view = new CbbSrcEleView(this, tmp_path, emp.EMP_DETAIL_ELE_VIEW)
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
                    tmp_view = new CbbSrcEleView(this, tmp_name, emp.EMP_DETAIL_ELE_VIEW)
                    @image_detail[tmp_name] = tmp_view
                    @image_detail_tree.append tmp_view

  # 添加资源描述图片
  chose_detail_f: ->
    @chose_detail(['openFile'])

  chose_detail_d: ->
    @chose_detail(['openFile', 'openDirectory'])

  chose_detail: (opts=['openFile', "openDirectory"])->
    # console.log "select detail"
    dialog.showOpenDialog title: 'Select', properties: opts, (img_path) => # 'openDirectory'
      # console.log logo_path
      # console.log @detail_image.attr("src")
      if img_path
        # @detail_image.attr("src", img_path[0])
        @detail_img_text.setText img_path[0]

  remove_all_detail: ->
    for tmp_name, tmp_view of @image_detail
      tmp_view.destroy()
    @image_detail ={}

  remove_detail_callback: (name)->
    delete @image_detail[name]
