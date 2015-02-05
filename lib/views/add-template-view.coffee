# _ = require 'underscore-plus'
{$, $$, TextEditorView, ScrollView} = require 'atom'
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
    console.log index
    console.log logo_imgs
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
                @subview "template_path", new TextEditorView(mini: true,attributes: {id: 'template_path', type: 'string'},  placeholderText: ' Template Path')
                @button class: 'control-btn btn btn-info', click:'select_path',' Chose Path '

          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板名称"
                  @div class: 'setting-description', "Template Package Name"
                @subview "template_name", new TextEditorView(mini: true,attributes: {id: 'template_name', type: 'string'},  placeholderText: ' Template Name')


          @div class: 'section-body', =>
            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'info-label', "模板版本"
                  @div class: 'setting-description', "默认为0.1, 每次+0.1"
              @div class: 'controls', =>
                # @div class: 'editor-container', =>
                @subview "template_ver", new TextEditorView(mini: true,attributes: {id: 'template_ver', type: 'string'},  placeholderText: ' Template Version')

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
      else
        templates_obj = JSON.parse data

    #
    # if fs.existsSync templates_json
    #   console.log "exists"
    #   fs.readFileSync templates_json
    #   templates_obj = JSON.parse templates_json

    # console.log @template_path_e.getEditor().getText()

    @template_path.getEditor().on 'contents-modified', =>
      console.log @template_path.getEditor().getText()

    @logo_select.change (event) =>
      # console.log @logo_select
      console.log @logo_select.val()
      console.log @logo_image.attr("src", @logo_select.val())
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
    tmp_path = @template_path.getEditor().getText()
    @promptForPath(@template_path, @template_name, @template_ver, @logo_select, tmp_path)

  promptForPath: (path_view, name_view, ver_view, log_view, def_path) ->
    if def_path
      dialog.showOpenDialog title: 'Select', defaultPath:def_path, properties: ['openDirectory', 'createDirectory'], (pathsToOpen) =>
        @refresh_path( pathsToOpen, path_view, name_view, ver_view, log_view)
    else
      dialog.showOpenDialog title: 'Select', properties: ['openDirectory', 'createDirectory'], (pathsToOpen) =>
        @refresh_path( pathsToOpen, path_view, name_view, ver_view, log_view)

  refresh_path: (new_paths, path_view, name_view, ver_view, log_view)->
    if new_paths
      console.log new_paths
      new_path = new_paths[0]
      path_view.getEditor().setText(new_path)
      path_state = fs.statSync new_path

      if path_state?.isDirectory()
        console.log "----------------"
        name = path.basename new_path
        name_view.getEditor().setText(name)
        ver_view.getEditor().setText(emp.EMP_DEFAULT_VER)

        logo_path =  path.join new_path,emp.EMP_LOGO_DIR
        fs.readdir logo_path, (err, files) =>
          if err
            console.log "no exist"
          else
            logo_images = files.filter((ele)-> !ele.match(/^\./ig))
            console.log logo_images
            for logo in logo_images
              tmp_opt = document.createElement 'option'
              tmp_opt.text = logo
              tmp_opt.value = path.join logo_path, logo
              console.log tmp_opt
              log_view.append tmp_opt
            # console.log log_view





  do_submit: ->
    console.log "do_submit"
    temp_path = @template_path.getEditor().getText()?.trim()
    temp_name = @template_name.getEditor().getText()?.trim()
    temp_ver = @template_ver.getEditor().getText()?.trim()
    temp_desc = @template_desc.getEditor().getText()?.trim()

    template_store_path = path.join templates_store_path, temp_name
    template_json = path.join template_store_path, emp.EMP_TEMPLATE_JSON
    temp_obj = null
    # if fs.existsSync templates_json

    if !templates_obj?.templates[temp_name]
      if !templates_obj
        templates_obj = @new_templates_obj()
        temp_obj = @new_template_obj(temp_name, temp_ver, temp_path, temp_desc)
      else
        temp_obj = @new_template_obj(temp_name, temp_ver, temp_path, temp_desc)

      console.log "-----------"
      templates_obj.templates[temp_name] = temp_obj
      templates_obj.length += 1
      json_str = JSON.stringify(templates_obj)

      fs.writeFileSync templates_json, json_str
      emp.mkdir_sync template_store_path
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
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    fs.writeFileSync t_path, f_con #, 'utf8'



  new_template_obj: (name, ver, path, desc, logo)->
    {name:name, version:ver, path:path, desc: desc, logo:logo}

  new_templates_obj: ->
    {templates:{}, length:0}
