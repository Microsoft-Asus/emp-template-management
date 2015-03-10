{View} = require 'atom-space-pen-views'
{Range} = require 'atom'
emp = require '../exports/emp'
# {Subscriber} = require 'emissary'


module.exports =
class ComponmentEleView extends View
  # Subscriber.includeInto(this)
  snippets:null

  @content: ({name, version, path, desc, logo}) ->
    @li class:'two-lines cbb_li_view', click: 'do_click', =>
      # @div class:'avatar'
      @div class: 'temp_logo', =>
        # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
        @img outlet: 'logo_img', class: 'avatar', src: "#{logo}", #click:'image_format'
      @div class: 'temp_name', =>
        @h4 class:'name_header', "#{name}"
        @span class:'name_detail' ,"#{desc}"

  initialize: (@com) ->
    # It might be useful to either wrap @pack in a class that has a ::validate
    # method, or add a method here. At the moment I think all cases of malformed
    # package metadata are handled here and in ::content but belt and suspenders,
    # you know

  image_format: ->
    console.log 'image_format'
    console.log @logo_img.css('height')
    if @logo_img.css('height') is emp.LOGO_IMAGE_SIZE
      # @logo_img.css('height', logo_image_big_size)
      # @logo_img.css('width', logo_image_big_size)
      @logo_img.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @logo_img.css('height', emp.LOGO_IMAGE_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_SIZE)

  detached: ->
    # @unsubscribe()

  do_click: ->
    console.log @com
    if !@snippets
      html_temp = @com.html
      @snippets = fs.readFileSync html_temp, 'utf-8'
    console.log @snippets
    editor = atom.workspace.getActiveEditor()
    # console.log body_parser.parse file_con
    # snippetBody = '<${1:div}> asd $2 asd \n</${1:div}>$0'

    # tmpr = require atom.packages.activePackages.snippets.mainModulePath
    atom.packages.activePackages.snippets?.mainModule?.insert @snippets


    # if editor
    #   editor.insertText file_con, select:true,autoIndentNewline:true
    #   selections = editor.getSelections()
    #   console.log selections
    #   for selection in selections
    #     if not selection.isEmpty()
    #       range = selection.getBufferRange()
    #       console.log range
    #       selection.destroy()
    #
    #       # editor.addCursorAtBufferPosition(range.end)
    #       console.log range.start
    #
    #       # tmp_range = new Range([range.start.row, 0], [range.start.row, 3])
    #       # newSelection = editor.addSelectionForBufferRange(tmp_range)
    #       # selections.push newSelection
    #       # editor.focus()
    #       editor.addCursorAtBufferPosition(range.start)
