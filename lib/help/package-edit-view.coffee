{$, $$, TextEditorView, View} = require 'atom-space-pen-views'
remote = require 'remote'
dialog = remote.require 'dialog'
emp = require '../exports/emp'
fs = require 'fs'
path = require 'path'
CSON = require 'CSON'
_ = require 'underscore-plus'

module.exports =
class EditPackageView extends View
  insert_src_view: {}
  # insert_css_view:{}
  insert_lua_view: {}
  @content: ()->

    @div outlet:'cbb_detail_div', class:'cbb-detail-view overlay from-top', =>
      @div class:'cbb_detail_panel panel', =>
        @h1 "Edit KeyMaps' Detail", class: 'panel-heading'
        @div class:'bar_div', =>
          @button class: 'btn-warning btn  inline-block-tight btn_right', click: 'do_cancel', 'Cancel'

      @div class: 'pack_detail_info', =>
        @div class:'div_box_r', =>
          @h4 class:'lab text-highlight', "模板名称:"
        @div class:'div_box_r', =>
          @label outlet:"pack_name", class:'lab text-highlight', "default"

        # @div class:'div_box_bor', =>
        #   @label class:'text-highlight', "模板描述:"
        #   @label class:'', "asd"

        @div class: 'pack_detail_info',  =>
          @div class: 'div_box_r', =>
            @h4 class:'lab text-highlight',"KeyMap"

          @div =>
            @subview "keymap_text", new TextEditorView(mini: true,attributes: {id: 'keymap_text', type: 'string'},  placeholderText: ' Insert Key Map')

        @div class: 'pack_detail_info',  =>
          @div class: 'div_box_r', =>
            @h4 class:'lab text-highlight',"Selector"

          @div outlet:'snippet_lua', =>
            @label outlet:'selector_val', class:'text-highlight',"llllll"

        @div class: 'cbb_detail_info',  =>
          @div class: 'div_box_r', =>
            @h4 class:'lab text-highlight',"command"

          @div outlet:'snippet_lua', =>
            @label outlet:'command_val', class:'text-highlight', "jjjjjjj"

      @div class:'cbb_detail_foot', =>
        @button "Done", class: "createSnippetButton btn btn-primary", click:'do_input'
        @button "Cancel", class: "createSnippetButton btn-warning btn btn-primary", click:'do_cancel'
        # @button "test", class: "createSnippetButton btn-warning btn btn-primary", click:'do_test'

  initialize: () ->
    # console.log @com
    # console.log @pack_name
    @cbb_management = atom.project.cbb_management

    # @other_platform_pattern = new RegExp("\\.platform-(?!#{_.escapeRegExp(process.platform)}\\b)")

    # new_key_binding = new Array()
    # for key_binding in atom.keymaps.getKeyBindings()
    #   {command, keystrokes, selector} = key_binding
    #   continue unless command?.indexOf?("#{@name}:") is 0
    #   continue if other_platform_pattern.test(selector)

  handle_event: ->
    @validate_fields()
    @on 'keydown', (e) =>
      if e.which is emp.ESCAPEKEY
        @detach()

  toggle: (type)->
    if @isVisible()
      @detach()
    else
      @show_view(type)

  show_view: (@pack, key_binding)->
    # console.log " show this "
    # console.log pack
    if @hasParent()
      @show()
    else
      atom.workspace.addTopPanel(item: this)
    @refresh_show_view(key_binding)

  refresh_show_view: ({@selector, @keystrokes, @command})->
    @pack_name.text @pack.name
    @selector_val.text @selector
    @command_val.text @command
    @keymap_text.setText @keystrokes

  hide_view: ()->
    @hide()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  do_cancel: ->
    @destroy()

  do_input: ->
    if keymap_text = @keymap_text.getText()?.trim()
      console.log keymap_text
      @refresh_keymap_file(keymap_text)
    else
      emp.show_error "快捷键不能为空"
    @destroy()


  refresh_keymap_file: (new_keystrokes)->
    # console.log  @pack.hasKeymaps()
    # if @pack.hasKeymaps()
    if @pack.keymaps
      for [keymap_path, keymaps] in @pack.keymaps
        # console.log keymap_path
        if tmp_selector = keymaps[@selector]
          if tmp_selector[@keystrokes]
            delete tmp_selector[@keystrokes]
            tmp_selector[new_keystrokes] = @command
            new_keymaps_str = CSON.stringify keymaps
            console.log "ready to write."
            fs.writeFile keymap_path, new_keymaps_str, 'utf-8', (err) =>
              if err
                console.error err
      # console.log @pack.keymaps
      @pack.deactivateKeymaps()
      @pack.activateKeymaps()


    # if pack_path = @pack.path
    #   keymaps_file = path.join pack_path, 'keymaps', @name+".cson"
    #   console.log keymaps_file
    #   if fs.existsSync keymaps_file
    #     keyma_obj = atom.keymaps.readKeymap(keymaps_file)
    #     console.log keyma_obj


  show_alert: (msg) ->
    atom.confirm
      message: '警告'
      detailedMessage:msg
      buttons:
        '取消': -> return 3
        '替换': -> return 2
        '合并': -> return 1
