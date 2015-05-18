{View} = require 'atom'
{$, $$, TextEditorView} = require 'atom-space-pen-views'
# fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'
fs = require 'fs'
path = require 'path'

emp = require '../exports/emp'
CbbEle = require '../util/emp_cbb_element'
label_hide = "报文内容:--------------------点击显示--------------------"
label_show = "报文内容(点击隐藏):"
css_label_hide = "模板样式内容:--------------------点击显示--------------------"
css_label_show = "模板样式内容(点击隐藏):"
# templates_store_path = null
templates_obj = null
default_select_pack = emp.EMP_DEFAULT_PACKAGE
default_select_type = emp.EMP_DEFAULT_TYPE
CSS_FLAG="css"

module.exports =
class QuickAddCbbView extends View

  @content: ->
    @div class:'quick-add overlay from-top', =>
      @div class:'quick_add_panel panel', =>
        @h1 "快速创建公共模板", class: 'panel-heading'
      @div class: 'quick_add_info', =>
        @div  class:'div_snippet', =>
          @ul class:'list-tree has-collapsable-children', click:'collapsable_text', =>
            @li outlet:'root_li', class:'list-nested-item', =>
              @div class:'list-item', =>
                @label outlet:'snippet_label', label_show
          @textarea "", class: "snippet native-key-bindings editor-colors", rows: 8, outlet: "snippet", placeholder: "模板内容"
        @div  class:'div_snippet', =>
          @ul class:'list-tree has-collapsable-children', click:'collapsable_css', =>
            @li outlet:'root_li_css', class:'list-nested-item', =>
              @div class:'list-item', =>
                @label outlet:'css_label', css_label_show
          @textarea "", class: "snippet native-key-bindings editor-colors", rows: 8, outlet: "snippet_css", placeholder: "模板样式内容"
        @div class:'div_box_r', =>
          @label class:'lab',"模板名称:"
          @subview "cbb_name", new TextEditorView(mini:true, placeholderText: 'Snippet name')

        @div class:'div_box_r', =>
          @label class:'lab', "模板描述:"
          @subview "cbb_desc", new TextEditorView(mini:true, placeholderText: 'Snippet desc')

        @div class:'div_box', =>
          @label class:'lab', "模板包:"
          @select outlet:"pack_select", id: "type", class: 'form-control snippet_select'
        @div class:'div_box', =>
          @label class:'lab', "模板类型:"
          @select outlet:"type_select", id: "type", class: 'form-control snippet_select'
        @div class:'div_logo', =>
          @div class:'div_box', =>
            @label class:'lab',"模板图标:"
            # @span "", class: "input-group-btn", =>
            @button "Add", class:"btn", click:"select_logo"
          @subview "cbb_logo", new TextEditorView(mini:true, placeholderText: 'Snippet Logo')
          @img outlet: 'logo_img', class: 'avatar', src: "", style:"display:none;", click:'image_format'
        @div class:'div_logo', =>
          @div class:'div_box', =>
            @label class:'lab',"模板详情图片:"
            # @span "", class: "input-group-btn", =>
            @button "Add", class:"btn", click:"select_detail"
          @subview "cbb_img_detail", new TextEditorView(mini:true, placeholderText: 'Snippet Logo')
          @img outlet: 'img_detail', class: 'avatar', src: "", style:"display:none;", click:'image_format2'
      #
      # @div "", class: "input-group snippetScopeGroup", =>
      #   @subview "cbb_logo", new TextEditorView(mini:true, placeholderText: 'Snippet scope selector (ex: `.source.js`)')
      #   @span "", class: "input-group-btn", =>
      #     @button "?", class:"btn", outlet:"sourceHelp"
      @div class:'quick_add_foot', =>
        @button "Done", class: "createSnippetButton btn btn-primary", click:'create_snippet'
        @button "Cancel", class: "createSnippetButton btn btn-primary", click:'do_cancel'
        @button "Refresh", class: "createSnippetButton btn btn-primary", click:'refresh_panl'

  initialize: (@emp_temp_management) ->
    @handle_event()
    atom.commands.add "atom-workspace",
      "emp-template-management:quick-add-cbb": => @toggle()
      "emp-template-management:quick-add-cbb-css": => @toggle(CSS_FLAG)

    # pack_select
    @cbb_management = atom.project.cbb_management
    @initial_select()

    @snippet_css.hide()
    @snippet.show()
    # console.log @packs


  initial_select: ->
    @packs = @cbb_management.get_pacakges()
    @pack_select.change (event) =>
      tmp_name = @pack_select.val()
      # console.log  @pack_select.val()
      tmp_obj = @packs[tmp_name]
      # console.log tmp_obj
      type_list = tmp_obj.get_type()
      @type_select.empty()

      for tmp_type in type_list
        if tmp_type is default_select_type
          @type_select.append @new_selec_option(tmp_type)
        else
          @type_select.append @new_option(tmp_type)

    @pack_select.empty()
    for name, obj of @packs
      if name is default_select_pack
        @pack_select.append @new_selec_option(name)
      else
        @pack_select.append @new_option(name)
    tmp_pack = @packs[default_select_pack]
    type_list = tmp_pack.get_type()

    @type_select.empty()
    for tmp_type in type_list
      if tmp_type is default_select_type
        @type_select.append @new_selec_option(tmp_type)
      else
        @type_select.append @new_option(tmp_type)


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
    fields = [ @snippet, @cbb_name, @cbb_desc, @snippet_css]
    # @cbb_name, @cbb_desc, @cbb_else,
    for field in fields
      field.on 'core:confirm', (event) =>
        @create_snippet()
      field.on 'keyup', =>
        @validate_fields()
    # @sourceHelp.click =>
    #   @sourceHelpView.toggle()


  validate_fields: ->
    cbb_name = @cbb_name.getText().length
    cbb_desc = @cbb_desc.getText().length
    snippet = @snippet.val().length
    snippet_css = @snippet_css.val().length
    validate = (input, el) ->
      if input is 0
        el.addClass "invalid"
        el.removeClass "valid"
      else
        el.removeClass "invalid"
        el.addClass "valid"
    validate snippet, @snippet
    validate snippet_css, @snippet_css
    validate cbb_name, @cbb_name
    validate cbb_desc, @cbb_desc



  set_textarea_hight: ->
    # console.log "set textarea"
    @snippet.css "max-height", (window.innerHeight * 0.8 ) + "px"

  toggle: (type)->
    if @isVisible()
      @detach()
    else
      @show(type)

  show: (type)->
    console.log " show this "
    editor = atom.workspace.getActiveEditor()
    if editor
      selection = editor.getSelection().getText()
      if selection.length > 0
        @set_snippet(type, selection)
    atom.workspace.addTopPanel(item: this)


  set_snippet: (type, text)->
    # console.log @snippet
    switch type
      when CSS_FLAG
        @snippet_css.context.value = text
        @snippet_css.show()
        @snippet.hide()
        @snippet_css.focus()
      else
        @snippet.context.value = text
        @snippet_css.hide()
        @snippet.show()
        @snippet.focus()


  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  # btn callback
  collapsable_text: ->
    # console.log 'collapsable_text ---'
    if @snippet.isVisible()
      @snippet.hide()
      if !@root_li_css.hasClass('collapsed')
        @root_li_css.removeClass('expanded').addClass('collapsed')
      @snippet_label.text(label_hide)
    else
      @snippet.show()
      if @root_li_css.hasClass('collapsed')
        @root_li_css.removeClass('collapsed').addClass('expanded')
      @snippet_label.text(label_show)

  collapsable_css: ->
    if @snippet_css.isVisible()
      @snippet_css.hide()
      if !@root_li.hasClass('collapsed')
        @root_li.removeClass('expanded').addClass('collapsed')
      @css_label.text(css_label_hide)
    else
      @snippet_css.show()
      if @root_li.hasClass('collapsed')
        @root_li.removeClass('collapsed').addClass('expanded')
      @css_label.text(css_label_show)

  # btn callback for logo
  select_logo: (e, element)->
    dialog.showOpenDialog title: 'Select', properties: ['openFile'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        if path_state?.isFile()
          @cbb_logo.setText logo_path[0]
          @logo_img.attr "src", logo_path[0]
          @logo_img.show()

  select_detail: (e, element)->
    dialog.showOpenDialog title: 'Select', properties: ['openFile'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        if path_state?.isFile()
          @cbb_img_detail.setText logo_path[0]
          @img_detail.attr "src", logo_path[0]
          @img_detail.show()

  # 点击后改变图片尺寸,方便查看
  image_format: (e, element)->
    # console.log 'image_format'
    # console.log @logo_img.css('height')
    if @logo_img.css('height') is emp.LOGO_IMAGE_SIZE
      @logo_img.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @logo_img.css('height', emp.LOGO_IMAGE_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_SIZE)

  image_format2: (e, element)->
    tmp_view = $(element).view()
    if @img_detail.css('height') is emp.LOGO_IMAGE_SIZE
      @img_detail.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @img_detail.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @img_detail.css('height', emp.LOGO_IMAGE_SIZE)
      @img_detail.css('width', emp.LOGO_IMAGE_SIZE)
  # # 生成 cbb 模板
  # create_snippet1: ->
  #   console.log "button down"
  #   cbb_name = @cbb_name.getText()?.trim()
  #   cbb_type = emp.EMP_DEFAULT_TYPE
  #   template_store_path = path.join templates_store_path, cbb_type, cbb_name
  #   template_json = path.join template_store_path, emp.EMP_TEMPLATE_JSON
  #   temp_obj = null
  #   templates_obj = null
  #   try
  #     fs_data = fs.readFileSync @templates_json
  #     templates_obj = JSON.parse fs_data
  #   catch
  #     templates_obj = null
  #
  #   # console.log templates_obj
  #   if !templates_obj?.templates[cbb_type][cbb_name]
  #     if !templates_obj
  #       templates_obj = emp.new_templates_obj()
  #     emp.mkdir_sync_safe template_store_path
  #     temp_obj = @new_template_obj(cbb_name, template_store_path)
  #     @format_template(template_store_path, temp_obj)
  #
  #     templates_obj.templates[cbb_type][cbb_name] = temp_obj
  #     templates_obj.templates[cbb_type].length += 1
  #     json_str = JSON.stringify(templates_obj)
  #     console.log @templates_json
  #     console.log templates_obj
  #
  #     fs.writeFileSync @templates_json, json_str
  #
  #     temp_str = JSON.stringify temp_obj
  #     console.log template_json
  #     console.log temp_str
  #     fs.writeFileSync template_json, temp_str
  #     emp.show_info("添加模板 完成~")
  #     @destroy()
  #   else
  #     console.log "exist -------"
  #     emp.show_info("该模板已经存在~")

  create_snippet: ->
    console.log "button down"
    cbb_name = @cbb_name.getText()?.trim()
    cbb_type = emp.EMP_DEFAULT_TYPE
    cbb_obj = @new_template_obj(cbb_name)
    console.log cbb_obj
    @emp_temp_management.add_element(cbb_obj)
    emp.show_info("添加模板 完成~")
    @refresh_panl()
    @destroy()

  new_template_obj: (cbb_name)->
    cbb_desc = @cbb_desc.getText()?.trim()
    cbb_logo = @cbb_logo.getText()?.trim()
    cbb_img_detail = null
    unless !(cbb_img_detail = @cbb_img_detail.getText()?.trim())
      cbb_img_detail = [cbb_img_detail]
    console.log cbb_img_detail
    # cbb_name = @cbb_name.getText()?.trim()
    cbb_con = @snippet?.val()
    cbb_css = @snippet_css?.val()
    cbb_pack = @pack_select.val()
    cbb_type = @type_select.val()
    cbb_obj = new CbbEle(cbb_name, cbb_desc, cbb_logo, cbb_type, cbb_pack, cbb_img_detail)
    cbb_obj.set_con cbb_con, emp.EMP_QHTML
    cbb_obj.set_con cbb_css, emp.EMP_QCSS
    cbb_obj

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
