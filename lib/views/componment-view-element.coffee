{$, View} = require 'atom-space-pen-views'
{Range} = require 'atom'
emp = require '../exports/emp'
# jsdom = require 'jsdom'
# cheer = require 'cheerio'
# clean_css = require 'clean-css'
# {Subscriber} = require 'emissary'
css = require 'css'
cheerio = require 'cheerio'


module.exports =
class ComponmentEleView extends View
  # Subscriber.includeInto(this)
  snippets:null

  @content: ({name, version, path, desc, logo}) ->
    @li class:'two-lines cbb_li_view', click: 'do_click', =>
      @div class: 'temp_logo', =>
        @img outlet: 'logo_img', class: 'avatar', src: "#{logo}"
      @div class: 'temp_name', =>
        @h4 class:'name_header', "#{name}"
        @span class:'name_detail' ,"#{desc}"

  initialize: (@com) ->
    @ele_path = @com.element_path
    @ele_json = path.join @ele_path, emp.EMP_TEMPLATE_JSON

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
      @logo_img.css('        @textarea "", class: "snippet native-key-bindings editor-colors", rows: 8, outlet: "snippet", placeholder: "模板内容"height', emp.LOGO_IMAGE_BIG_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @logo_img.css('height', emp.LOGO_IMAGE_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_SIZE)

  detached: ->
    # @unsubscribe()

  do_click: ->
    console.log @com
    if !@html_snippet
      ele_json_data = fs.readFileSync @ele_json, 'utf-8'
      @snippet_obj = JSON.parse ele_json_data

      html_obj = @snippet_obj.html
      css_obj = @snippet_obj.css

      @html_snippet = @set_con(html_obj)
      @css_snippet = @set_con(css_obj)
    console.log @snippets
    editor = atom.workspace.getActiveEditor()
    # console.log body_parser.parse file_con
    # snippetBody = '<${1:div}> asd $2 asd \n</${1:div}>$0'
    # tmpr = require atom.packages.activePackages.snippets.mainModulePath
    try
      if @css_snippet
        # console.log "has css"
        edit_text = editor.getText()

        html_obj = cheerio.load edit_text
        re_css = html_obj('style').text()
        # console.log re_css

        # re_style = $(edit_text).find 'style'
        # console.log $(edit_text).find 'style'
        # if re_style.length >0
        #   console.log
        #   re_css = re_style.get(0).innerHTML
        #   console.log re_css
        if re_css
          snippet_ast = css.parse @css_snippet
          snippet_rule_list = snippet_ast.stylesheet.rules
          snippet_arr = []
          for tmp_rule in snippet_rule_list
            # console.log
            snippet_arr.push tmp_rule.selectors.toString()


          re_ast = css.parse re_css
          # console.log re_ast
          # console.log re_ast.stylesheet
          rule_list = re_ast.stylesheet.rules
          tmp_arr = []
          for tmp_rule in rule_list
            # console.log
            tmp_arr.push tmp_rule.selectors.toString()
          # console.log tmp_arr

          for tmp_rule in snippet_rule_list
            # console.log tmp_rule
            if !(tmp_arr.indexOf(tmp_rule.selectors.toString())+1)
              re_ast.stylesheet.rules.push tmp_rule


          # console.log re_ast
          # console.log re_ast.stylesheet

          # console.log tmp_arr
          result = css.stringify(re_ast, { sourcemap: true })
          # console.log re_ast
          # console.log result.code
          if result.code isnt re_css
            html_obj('style').text("\n"+result.code+"\n")
            # console.log html_obj.html()
            editor.setText(html_obj.html())


    catch err
      console.error "insert snippets error "
      console.error err

      # console.log editor.getText()
      # console.log $.parseHTML edit_text

    atom.packages.activePackages.snippets?.mainModule?.insert @html_snippet
      # console.log escape edit_text

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

  set_con: (tmp_obj) ->
    if tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
        return tmp_obj.body
      else
        return fs.readFileSync tmp_obj.body, 'utf-8'
    else
      return null
