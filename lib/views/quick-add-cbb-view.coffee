{View} = require 'atom'
{$$, TextEditorView} = require 'atom-space-pen-views'
# fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'

emp = require '../exports/emp'
label_hide = "报文内容:--------------------点击显示--------------------"
label_show = "报文内容(点击隐藏):"
templates_store_path = null
templates_obj = null

module.exports =
class QuickAddCbbView extends View

  @content: ->
    @div class:'quick-add overlay from-top', =>
      @div class:'panel', =>
        @h1 "快速创建公共模板", class: 'panel-heading'
      @div  class:'div_snippet', =>
        @ul class:'list-tree has-collapsable-children', click:'collapsable_text', =>
          @li outlet:'root_li', class:'list-nested-item', =>
            @div class:'list-item', =>
              @label outlet:'snippet_label', label_show
        @textarea "", class: "snippet native-key-bindings editor-colors", rows: 8, outlet: "snippet", placeholder: "模板内容"
      @div class:'div_box_r', =>
        @label class:'lab',"模板名称:"
        @subview "cbb_name", new TextEditorView(mini:true, placeholderText: 'Snippet name')

      @div class:'div_box_r', =>
        @label class:'lab', "模板描述:"
        @subview "cbb_desc", new TextEditorView(mini:true, placeholderText: 'Snippet desc')
      @div class:'div_box', =>
        @label class:'lab', "模板类型:"
        @select outlet:"type_select", id: "type", class: 'form-control snippet_select', =>
          if !emp_cbb_types = atom.config.get emp.EMP_CBB_TYPE
            atom.config.set emp.EMP_CBB_TYPE, emp.EMP_CPP_TYPE_DEF
            emp_cbb_types = emp.EMP_CPP_TYPE_DEF
          for option in emp_cbb_types
            @option value: option, option
          @option selected:'select', value: emp.EMP_DEFAULT_TYPE, emp.EMP_DEFAULT_TYPE
      @div class:'div_logo', =>
        @div class:'div_box', =>
          @label class:'lab',"模板图标:"
          # @span "", class: "input-group-btn", =>
          @button "Add", class:"btn", click:"select_logo"
        @subview "cbb_logo", new TextEditorView(mini:true, placeholderText: 'Snippet Logo')
        @img outlet: 'logo_img', class: 'avatar', src: "", style:"display:none;", click:'image_format'

      #
      # @div "", class: "input-group snippetScopeGroup", =>
      #   @subview "cbb_logo", new TextEditorView(mini:true, placeholderText: 'Snippet scope selector (ex: `.source.js`)')
      #   @span "", class: "input-group-btn", =>
      #     @button "?", class:"btn", outlet:"sourceHelp"
      @button "Done", class: "createSnippetButton btn btn-primary", click:'create_snippet'

  initialize: (@emp_temp_management) ->
    @handle_event()
    atom.commands.add "atom-workspace",
      "emp-template-management:quick-add-cbb": => @toggle()

    if !templates_store_path = atom.project.templates_path
      atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
      templates_store_path =atom.project.templates_path
    # console.log "stsore_path: #{templates_store_path}"
    emp.mkdir_sync templates_store_path
    @templates_json = path.join templates_store_path, emp.EMP_TEMPLATES_JSON
    # console.log templates_json


  handle_event: ->
    @validate_fields()
    window.addEventListener 'resize', =>
      @set_textarea_hight()
    @on 'keydown', (e) =>
      if e.which is emp.ESCAPEKEY
        @detach()
    fields = [ @snippet, @cbb_name, @cbb_desc]
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
    validate = (input, el) ->
      if input is 0
        el.addClass "invalid"
        el.removeClass "valid"
      else
        el.removeClass "invalid"
        el.addClass "valid"
    validate snippet, @snippet
    validate cbb_name, @cbb_name
    validate cbb_desc, @cbb_desc


  set_textarea_hight: ->
    @snippet.css "max-height", (window.innerHeight * 0.8 ) + "px"

  toggle: ->
    if @isVisible()
      @detach()
    else
      @show()

  show: ->
    console.log " show this "
    editor = atom.workspace.getActiveEditor()
    if editor
      selection = editor.getSelection().getText()
      if selection.length > 0
        @set_snippet(selection)
    atom.workspace.addTopPanel(item: this)
    @snippet.focus()

  set_snippet: (text)->
    # console.log @snippet
    if @snippet.isHidden()
      @snippet.show()
    @snippet.context.value = text


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
      if !@root_li.hasClass('collapsed')
        @root_li.removeClass('expanded').addClass('collapsed')
      @snippet_label.text(label_hide)
    else
      @snippet.show()
      if @root_li.hasClass('collapsed')
        @root_li.removeClass('collapsed').addClass('expanded')
      @snippet_label.text(label_show)

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

  # 点击后改变图片尺寸,方便查看
  image_format: ->
    # console.log 'image_format'
    # console.log @logo_img.css('height')
    if @logo_img.css('height') is emp.LOGO_IMAGE_SIZE
      @logo_img.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @logo_img.css('height', emp.LOGO_IMAGE_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_SIZE)

  # 生成 cbb 模板
  create_snippet: ->
    console.log "button down"
    cbb_name = @cbb_name.getText()?.trim()
    cbb_type = emp.EMP_DEFAULT_TYPE
    template_store_path = path.join templates_store_path, cbb_type, cbb_name
    template_json = path.join template_store_path, emp.EMP_TEMPLATE_JSON
    temp_obj = null
    templates_obj = null
    try
      fs_data = fs.readFileSync @templates_json
      templates_obj = JSON.parse fs_data
    catch
      templates_obj = null

    # console.log templates_obj
    if !templates_obj?.templates[cbb_type][cbb_name]
      if !templates_obj
        templates_obj = emp.new_templates_obj()
      emp.mkdir_sync_safe template_store_path
      temp_obj = @new_template_obj(cbb_name, template_store_path)
      @format_template(template_store_path, temp_obj)

      templates_obj.templates[cbb_type][cbb_name] = temp_obj
      templates_obj.templates[cbb_type].length += 1
      json_str = JSON.stringify(templates_obj)
      console.log @templates_json
      console.log templates_obj

      fs.writeFileSync @templates_json, json_str

      temp_str = JSON.stringify temp_obj
      console.log template_json
      console.log temp_str
      fs.writeFileSync template_json, temp_str
      emp.show_info("添加模板 完成~")
      @destroy()
    else
      console.log "exist -------"
      emp.show_info("该模板已经存在~")

  create_snippet: ->
    console.log "button down"
    cbb_name = @cbb_name.getText()?.trim()
    cbb_type = emp.EMP_DEFAULT_TYPE
    ccb_obj = @new_template_obj()
    @emp_temp_management.add_ccb_with_content(ccb_obj)
    emp.show_info("添加模板 完成~")
    @destroy()

  new_template_obj: ()->
    cbb_desc = @cbb_desc.getText()?.trim()
    cbb_logo = @cbb_logo.getText()?.trim()
    cbb_name = @cbb_name.getText()?.trim()
    ccb_con = @snippet?.val()
    cbb_type = emp.EMP_DEFAULT_TYPE

    {name:cbb_name, version:emp.EMP_DEFAULT_VER, path:null, desc: cbb_desc,
    type: cbb_type, logo:cbb_logo, html:{type:emp.EMP_CON_TYPE, body:ccb_con}, css:null, lua:null, available:true}



  format_template: (to_path, temp_obj) ->
    if temp_obj.logo
      temp_obj.logo = @copy_content_ch(to_path, temp_obj.logo, emp.EMP_LOGO_DIR)
    else
      temp_obj.logo = path.join __dirname,'../../',emp.EMP_DEFAULT_LOGO
    if html_con = @snippet?.val()
      temp_obj.html = @create_file(to_path, html_con, emp.EMP_DEFAULT_HTML_TEMP, emp.EMP_HTML_DIR)
    if css_con = @snippet_css?.val()
      temp_obj.css = @create_file(to_path, css_con, emp.EMP_DEFAULT_CSS_TEMP, emp.EMP_CSS_DIR)
    if lua_con = @snippet_lua?.val()
      temp_obj.lua = @create_file(to_path, lua_con, emp.EMP_DEFAULT_LUA_TEMP, emp.EMP_LUA_DIR)
    temp_obj

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

  create_file: (t_path, content, temp_name, add_path="") ->
    to_path = path.join t_path, add_path
    emp.mkdir_sync(to_path)
    re_file = path.join to_path, temp_name
    fs.writeFileSync re_file, content
