_ = require 'underscore-plus'
{$, $$$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
EditPackageView = require './package-edit-view'
path = require 'path'

module.exports =
class PackageKeymapsView extends View
  @content: ->
    @div class: 'panels', outlet: 'panels', =>
      @div =>
        @section class: 'section', =>
          @div class: 'section-heading icon icon-keyboard', 'Keybindings'
          @table class: 'package-keymap-table table native-key-bindings text', tabindex: -1, =>
            @thead =>
              @tr =>
                @th 'Keystroke'
                @th 'Command'
                @th 'Selector'
            @tbody outlet: 'key_binding_items'

  initialize: ->
    @item_length = 0
    @edit_view = new EditPackageView()
    @on 'click', '.copy-icon', ({target}) =>
      key_binding = $(target).closest('tr').data('key_binding')
      @write_key_binding_to_clipboard(key_binding)

    @on 'click', '.edit-icon', ({target}) =>
      key_binding = $(target).closest('tr').data('key_binding')
      @write_key_binding_to_clipboard(key_binding)
      @edit_view.show_view(@pack, key_binding)
      console.log "edit this keymap "

  add_items: (@pack, key_binding_arr)->
    @key_binding_items.empty()
    for key_binding in key_binding_arr
      key_binding_view = @new_item(key_binding)
      key_binding_view = $(key_binding_view)
      key_binding_view.data('key_binding', key_binding)
      @key_binding_items.append(key_binding_view)

    unless (@item_length=@key_binding_items.children().length) > 0
      defaukt_view = $$$ ->
        @tr =>
          @td "NA"
          @td "NA"
          @td "NA"
      defaukt_view = $(defaukt_view)
      @key_binding_items.append(defaukt_view)
    # console.log @item_length
    @item_length

  new_item: ({command, keystrokes, selector})->
    $$$ ->
      @tr =>
        @td =>
          @span class: 'icon icon-gear edit-icon'
          @span class: 'icon icon-clippy copy-icon'
          @span keystrokes
        @td command
        @td selector



  items_length: ->
    @key_binding_items.children().lengt

  write_key_binding_to_clipboard: ({selector, keystrokes, command}) ->
    keymap_extension = path.extname(atom.keymaps.getUserKeymapPath())
    if keymap_extension is '.cson'
      content = """
        '#{selector}':
          '#{keystrokes}': '#{command}'
      """
    else
      content = """
        "#{selector}": {
          "#{keystrokes}": "#{command}"
        }
      """
    atom.clipboard.write(content)
