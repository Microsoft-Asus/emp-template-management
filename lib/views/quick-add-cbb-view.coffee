{View} = require 'atom'
{$$, TextEditorView} = require 'atom-space-pen-views'
fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'

emp = require '../exports/emp'
label_hide = "报文内容:--------------------点击显示--------------------"
label_show = "报文内容(点击隐藏):"

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
      @div class:'div_box', =>
        @label class:'lab', "模板名称:"
        @subview "cbb_name", new TextEditorView(mini:true, placeholderText: 'Snippet name')
      @div =>
        @label "模板名称:"
        @subview "cbb_name", new TextEditorView(mini:true, placeholderText: 'Snippet name')

      @div class:'div_box', =>
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
        @label "模板图标:"
        @div class:'div_box', =>
          @subview "cbb_logo", new TextEditorView(mini:true, placeholderText: 'Snippet Logo')
          @span "", class: "input-group-btn", =>
            @button "Add", class:"btn", click:"select_logo"
      #
      # @div "", class: "input-group snippetScopeGroup", =>
      #   @subview "cbb_logo", new TextEditorView(mini:true, placeholderText: 'Snippet scope selector (ex: `.source.js`)')
      #   @span "", class: "input-group-btn", =>
      #     @button "?", class:"btn", outlet:"sourceHelp"
      @button "Done", class: "createSnippetButton btn btn-primary", click:'create_snippet'

  initialize: (@com) ->
    @handle_event()
    atom.commands.add "atom-workspace",
      "emp-template-management:quick-add-cbb": => @toggle()

  handle_event: ->
    @validate_fields()
    window.addEventListener 'resize', =>
      @set_textarea_hight()
    @on 'keydown', (e) =>
      if e.which is emp.ESCAPEKEY
        @detach()
    fields = [ @snippet,@cbb_name, @cbb_desc]
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
  create_snippet: ->
    console.log "button down"


  # btn callback
  collapsable_text: ->
    # console.log 'collapsable_text ---'
    # console.log @snippet_label
    # console.log @snippet_label.text()
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
      # @refresh_path( paths_to_open, path_view, name_view, ver_view, logo_view) cbb_logo
      console.log logo_path
      path_state = fs.statSync logo_path[0]
      if path_state?.isFile()
        @cbb_logo.setText logo_path[0]
        # fs.readdir logo_path, (err, files) =>
        #   if err
        #     console.log "no exist"
        #   else
        #     logo_images = files.filter((ele)-> !ele.match(/^\./ig))
        #     # console.log logo_images
        #     for logo in logo_images
        #       tmp_opt = document.createElement 'option'
        #       tmp_opt.text = logo
        #       tmp_opt.value = path.join logo_path, logo
        #       # console.log tmp_opt
        #       @logo_select.append tmp_opt
