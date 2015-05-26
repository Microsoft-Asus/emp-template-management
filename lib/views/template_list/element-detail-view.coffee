{$$, TextEditorView, View} = require 'atom-space-pen-views'
_ = require 'underscore-plus'
ExampleView = require '../example/example_view'

emp = require '../../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'
CbbEle = require '../../util/emp_cbb_element'
AvailableTypePanel = require './available-type-panel'
# CbbEle = require '../util/emp_cbb_element'
CbbSrcEleView = require './cbb-source-ele-view'
fs = require 'fs'
path = require 'path'

module.exports =
class ElementDetailPanel extends View
  source_files:{}
  image_detail:{}

  @content: ->
    @div =>
      @ol outlet: 'breadcrumbContainer', class: 'native-key-bindings breadcrumb', tabindex: -1, =>
        @li =>
          @a outlet: 'breadcrumb'

        @li class: 'active', =>
          @a outlet: 'title'
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-package', =>
            @text 'Edit Snippet'
            @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'

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
                @label outlet:'html_body_label', class: 'control-label', =>
                  @div class: 'info-label', "模板报文"
                  @div class: 'setting-description', "模板插入的报文实体"
                # @div class: 'editor-container', =>
              @div outlet: 'html_body', class:'controls'
                # @subview "template_html", new TextEditorView(mini: true,attributes: {id: 'template_html', type: 'string'},  placeholderText: ' Template Html Content')
                # # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
              @button class: 'control-btn btn btn-info', click:'edit_html',' Edit'

                # @exampleHtml '''<div> </div>'''

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板样式"
                  @div class: 'setting-description', "模板插入的样式实体"
                # @div class: 'editor-container', =>
              @div outlet: 'css_body', class:'controls'
                # @subview "template_css", new TextEditorView(mini: true,attributes: {id: 'template_css', type: 'string'},  placeholderText: ' Template Css Style')
                # # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
                # @button class: 'control-btn btn btn-info', click:'select_css',' Chose File '
              @button class: 'control-btn btn btn-info', click:'edit_css',' Edit'

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板脚本"
                  @div class: 'setting-description', "模板插入的脚本"
              @div outlet: 'lua_body', class:'controls'
                # @subview "template_css", new TextEditorView(mini: true,attributes: {id: 'template_css', type: 'string'},  placeholderText: ' Template Css Style')
                # # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
                # @button class: 'control-btn btn btn-info', click:'select_css',' Chose File '
              @button class: 'control-btn btn btn-info', click:'edit_lua',' Edit'

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
                    @img outlet:"logo_image", class: 'avatar', src:""
                  @div class:'meta-controls', =>
                    @div class:'btn-group', =>
                      @select outlet:"logo_select", id: "logo", class: 'form-control'
                        # for option in ["emp", "ebank", "boc", "gdb"]
                        # @option value: "#{logo_img}", emp.EMP_NAME_DEFAULT
                      @button class: 'control-btn btn btn-info', click:'select_logo',' Chose Other Logo '

          # 实际样式图片
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
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'do_cancel','  Cancel  '
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'save_snippet',' Ok '


  initialize: () ->
    @packageViews = []
    @cbb_management = atom.project.cbb_management

    @template_path = atom.project.templates_path
    @logo_select.change (event) =>
      @logo_image.attr("src", @logo_select.val())


  refresh_detail:({@element, @pack}) ->
    # console.log "do refresh"

    @title.text("#{_.undasherize(_.uncamelcase(@element.name))} Detail")
    # console.log @element
    @templates_path = atom.project.templates_path
    @ele_path = @element.element_path
    @ele_json = path.join @templates_path, @ele_path, emp.EMP_TEMPLATE_JSON
    ele_json_data = fs.readFileSync @ele_json, 'utf-8'
    @snippet_obj = JSON.parse ele_json_data
    # console.log @snippet_obj

    @template_name.setText(@element.name)
    @template_desc.setText(@element.desc)
    @initial_logo()
    @do_initial_select(@pack.name, @element.type)
    @initial_source_list(@snippet_obj.source)
    @initial_detail_list(@snippet_obj.detail)
    @initial_html()
    @initial_css()

  initial_html: ->
    tmp_obj = @snippet_obj.html
    tmp_body = ""
    if tmp_obj.type is emp.EMP_CON_TYPE
       tmp_body = tmp_obj.body
    else
      # TODO 改为文件显示
      tmp_path = path.join @templates_path, tmp_obj.body
      tmp_body = fs.readFileSync tmp_path, 'utf-8'

    @html_body.empty()
    re_body = new ExampleView(tmp_body)

    # console.log re_body
    @html_body.append re_body

  initial_css: ->
    tmp_obj = @snippet_obj.css
    tmp_body = ""
    unless !tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
         tmp_body = tmp_obj.body
      else
        # TODO 改为文件显示
        tmp_path = path.join @templates_path, tmp_obj.body
        tmp_body = fs.readFileSync tmp_path, 'utf-8'

      @css_body.empty()
      re_body = new ExampleView(tmp_body)

      # console.log re_body
      @css_body.append re_body

  initial_lua: ->
    tmp_obj = @snippet_obj.lua
    tmp_body = ""
    if tmp_obj.type is emp.EMP_CON_TYPE
       tmp_body = tmp_obj.body
    else
      # TODO 改为文件显示
      tmp_path = path.join @templates_path, tmp_obj.body
      tmp_body = fs.readFileSync tmp_path, 'utf-8'

    @lua_body.empty()
    re_body = new ExampleView(tmp_body)

    # console.log re_body
    @lua_body.append re_body

  # 初始化 logo
  initial_logo: ->
    @logo_select.empty()
    @logo_image.attr("src", "")

    if tmp_logo = @snippet_obj.logo
      text = path.basename tmp_logo
      value = path.join @templates_path, tmp_logo
    else
      value = emp.get_default_logo()
      text = path.basename value
    @logo_select.append @new_selec_option(text, value)
    @logo_image.attr("src", value)


  # 初始化 资源文件列表
  initial_source_list: (src_files=[])->
    @cbb_tree.empty()
    for tmp_file in src_files
      tmp_name = path.join @templates_path, tmp_file
      tmp_view = new CbbSrcEleView(this, tmp_name)
      @source_files[tmp_name] = tmp_view
      @cbb_tree.append tmp_view

  # 初始化 描述图片列表
  initial_detail_list: (detail_list=[]) ->
    @image_detail_tree.empty()
    for tmp_file in detail_list
      tmp_name = path.join @templates_path, tmp_file
      tmp_view = new CbbSrcEleView(this, tmp_name, emp.EMP_DETAIL_ELE_VIEW )
      @image_detail[tmp_name] = tmp_view
      @image_detail_tree.append tmp_view

  do_initial_select: (default_pack, default_type)->
    @packs = @cbb_management.get_pacakges()
    @pack_select.change (event) =>
      tmp_name = @pack_select.val()
      tmp_obj = @packs[tmp_name]
      type_list = tmp_obj.get_type()
      @type_select.empty()
      for tmp_type in type_list
        @type_select.append @new_option(tmp_type)

    @pack_select.empty()
    for name, obj of @packs
      if name is default_pack
        @pack_select.append @new_selec_option(name)
      else
        @pack_select.append @new_option(name)
    # console.log @packs
    tmp_pack = @packs[default_pack]
    # console.log tmp_pack
    type_list = tmp_pack.get_type()
    @type_select.empty()
    for tmp_type in type_list
      if tmp_type is default_type
        @type_select.append @new_selec_option(tmp_type)
      else
        @type_select.append @new_option(tmp_type)

  new_option: (name, value=name)->
    $$ ->
      @option value: value, name

  new_selec_option: (name, value=name) ->
    $$ ->
      @option selected:'select', value: value, name


  detached: ->
    # @unsubscribe()

  beforeShow: (@opts) ->
    # console.log @opts
    if @opts?.back
      @breadcrumb.text(@pack.name).on 'click', () =>
        @parents('.emp-template-management').view()?.showPanel(@opts.back, {back: emp.EMP_TEMPLATE}, @pack)
    else
      @breadcrumbContainer.hide()

  do_cancel: ->
    @parents('.emp-template-management').view()?.showPanel(@opts.back, {back: emp.EMP_TEMPLATE}, @pack)


  # btn callback for logo
  select_logo: (e, element)->
    # tmp_path = @template_logo.getText()
    dialog.showOpenDialog title: 'Select', properties: ['openFile'], (logo_path) =>
      # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view)
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
        #         # tmp_opt.selected = "selected"
        # else
        tmp_opt = document.createElement 'option'
        tmp_opt.text = path.basename tmp_path
        tmp_opt.value = logo_path
        tmp_opt.selected = "selected"
        @logo_select.append tmp_opt

        @logo_image.attr("src", logo_path)


  # 添加资源文件
  add_source_btn: () ->
    @add_source()

  add_source: (tmp_path)->
    console.log "add source"
    # tmp_path ?= @source_file.getText()
    # console.log tmp_path
    if tmp_path ?= @source_file.getText()
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
              src_files = files.filter((ele)-> !ele.match(/^\./ig))
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
    console.log "select source"
    dialog.showOpenDialog title: 'Select', properties: opts, (src_path) => # 'openDirectory'
      # console.log logo_path
      if src_path
        @source_file.setText src_path[0]


  # 删除所有添加的资源
  remove_all: ->
    for tmp_name, tmp_view of @source_files
      tmp_view.destroy()
    @source_files ={}

  #添加 描述图片
  add_image_detail_btn:() ->
    @add_image_detail()

  add_image_detail: ()->
    console.log "add image detail"
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
    console.log "select detail"
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

  # 编辑模板
  edit_html: ->
    console.log 'edit_html'
    tmp_obj = @snippet_obj.html
    tmp_editor = null
    unless !tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
        tmp_body = tmp_obj.body
        # tmp_editor = atom.workspace.openSync()
        # @store_info(tmp_editor, tmp_body)
        tmp_editor = @create_editor(get_tmp_file(), tmp_body)
        tmp_editor.onDidSave (event) =>
          console.log event
          tmp_body = tmp_editor.getText()
          @snippet_obj.html.body = tmp_body
          @html_body.empty()
          re_body = new ExampleView(tmp_body)
          @html_body.append re_body
      else
        # TODO 改为文件显示
        tmp_path = path.join @templates_path, tmp_obj.body
        tmp_editor = @create_editor(tmp_path)
        tmp_editor.onDidSave (event) =>
          console.log event
          tmp_body = tmp_editor.getText()
          @html_body.empty()
          re_body = new ExampleView(tmp_body)
          @html_body.append re_body

  # 编辑样式模板
  edit_css: ->
    console.log "edit_css"
    tmp_obj = @snippet_obj.css
    tmp_editor = null
    if tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
        tmp_body = tmp_obj.body
        # tmp_editor = atom.workspace.openSync()
        console.log tmp_body
        tmp_editor = @create_editor(get_tmp_file(), tmp_body)
        # @store_info(tmp_editor, tmp_body)
        tmp_editor.onDidSave (event) =>
          console.log event
          tmp_body = fs.readFileSync event.path, 'utf-8'
          @snippet_obj.css.body = tmp_body
          @css_body.empty()
          re_body = new ExampleView(tmp_body)
          @css_body.append re_body
      else
        # TODO 改为文件显示
        tmp_path = path.join @templates_path, tmp_obj.body
        tmp_editor = @create_editor(tmp_path)

        tmp_editor.onDidSave (e) ->
          console.log e
          tmp_body = tmp_editor.getText()
          @css_body.empty()
          re_body = new ExampleView(tmp_body)
          @css_body.append re_body
    else
      emp.show_error 'no css style file!'

  # 编辑样式模板
  edit_lua: ->
    console.log "edit_lua"
    tmp_obj = @snippet_obj.lua
    tmp_editor = null
    if tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
        tmp_body = tmp_obj.body
        # tmp_editor = atom.workspace.openSync()

        tmp_editor = @create_editor(get_tmp_file(), tmp_body)
        # @store_info(tmp_editor, tmp_body)
        tmp_editor.onDidSave (event) =>
          console.log event
          tmp_body = fs.readFileSync event.path, 'utf-8'
          @snippet_obj.lua.body = tmp_body

      else
        # TODO 改为文件显示
        tmp_path = path.join @templates_path, tmp_obj.body
        tmp_editor = @create_editor(tmp_path)
    else
      emp.show_error 'no lua script!'


  create_editor:(tmp_file_path, content) ->
    changeFocus = true
    tmp_editor = atom.workspace.openSync(tmp_file_path, { changeFocus })
    gramers = @getGrammars()

    tmp_editor.setText(content) #unless !content
    tmp_editor.setGrammar(gramers[0]) unless gramers[0] is undefined
    return tmp_editor

  store_info: (tmp_editor, content)->
    tmp_editor.setText(content)
    gramers = @getGrammars()
    tmp_editor.setGrammar(gramers[0]) unless gramers[0] is undefined

  # set the opened editor grammar, default is HTML
  getGrammars: ->
    grammars = atom.syntax.getGrammars().filter (grammar) ->
      (grammar isnt atom.syntax.nullGrammar) and
      grammar.name is 'HTML'
    grammars

  save_snippet: ->
    console.log "do save"
    if !@template_name.getText()
      emp.show_error "模板名称不能为空"
      return

    cbb_name = @template_name.getText()?.trim()

    old_pack = @pack.name
    old_type = @snippet_obj.type
    old_name = @snippet_obj.name

    cbb_pack = @pack_select.val()
    cbb_type = @type_select.val()

    if (cbb_pack isnt old_pack) or (cbb_type isnt old_type) or (cbb_name isnt old_name)
      console.log "do_con"
      cbb_obj = @new_template_obj(cbb_name, cbb_pack, cbb_type)
      # console.log cbb_obj
      @cbb_management.add_element(cbb_obj)
      @pack.delete_element_detail(@snippet_obj.name, old_type)
    else
      cbb_obj = @new_template_obj(cbb_name, cbb_pack, cbb_type)
      # console.log cbb_obj
      @cbb_management.add_element(cbb_obj)
    emp.show_info("修改模板 完成~")
    @parents('.emp-template-management').view()?.showPanel(@opts.back, {back: emp.EMP_TEMPLATE}, @pack)
    # @destroy()

  new_template_obj: (cbb_name, cbb_pack, cbb_type)->
    cbb_desc = @template_desc.getText()?.trim()
    cbb_logo = @logo_select.val()
    # cbb_name = @cbb_name.getText()?.trim()

    # @source_file
    source_list = []
    for tmp_name, tmp_view of @source_files
      source_list.push tmp_name

    tmp_img_list = []
    for tmp_name, tmp_view of @image_detail
      tmp_img_list.push tmp_name
    # console.log cbb_type

    cbb_obj = new CbbEle(cbb_name, cbb_desc, cbb_logo, cbb_type, cbb_pack, tmp_img_list, source_list)

    cbb_html = @snippet_obj.html.body
    tmp_html_type = @snippet_obj.html.type
    if tmp_html_type is emp.EMP_FILE_TYPE
      cbb_obj.set_file path.join(@template_path, cbb_html), emp.EMP_QHTML
    else
      cbb_obj.set_con cbb_html, emp.EMP_QHTML

    unless !@snippet_obj.css
      cbb_css = @snippet_obj.css.body
      tmp_css_type = @snippet_obj.css.type
      if tmp_css_type is emp.EMP_FILE_TYPE
        cbb_obj.set_file path.join(@template_path, cbb_css), emp.EMP_QCSS
      else
        cbb_obj.set_con cbb_css, emp.EMP_QCSS
      cbb_obj

    unless !@snippet_obj.lua
      cbb_lua = @snippet_obj.lua.body
      tmp_lua_type = @snippet_obj.lua.type
      if tmp_lua_type is emp.EMP_FILE_TYPE
        cbb_obj.set_file path.join(@template_path, cbb_lua), emp.EMP_QLUA
      else
        cbb_obj.set_con cbb_lua, emp.EMP_QLUA
      cbb_obj

get_tmp_file =() ->
  path.join __dirname, "../../../tmp.txt"
