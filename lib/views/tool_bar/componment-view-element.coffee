{$, View} = require 'atom-space-pen-views'
{Range} = require 'atom'
emp = require '../../exports/emp'
CbbDetailView = require './componment-detail-view'
fs = require 'fs'
path = require 'path'

# jsdom = require 'jsdom'
# cheer = require 'cheerio'
# clean_css = require 'clean-css'
# {Subscriber} = require 'emissary'
# css = require 'css'
# cheerio = require 'cheerio'


module.exports =
class ComponmentElementView extends View
  # Subscriber.includeInto(this)
  snippets:null

  @content: ({name, version, ele_path, desc, logo}) ->
    if !logo
      logo = emp.get_default_logo()
    else
      logo = path.join(atom.project.templates_path, logo)

    @li class:'two-lines cbb_li_view', click: 'do_click_panel', =>
      @div class: 'temp_logo', =>
        @img outlet: 'logo_img', class: 'avatar', src: "#{logo}"
      @div outlet:'temp_div', class: 'temp_name', =>
        @h4 class:'name_header', "#{name}"
        @span class:'name_detail' ,"#{desc}"
# click: 'do_click',


  initialize: (@com, @fa_view, @pack_name, @pack_type) ->
    @templates_path = atom.project.templates_path
    @ele_path = @com.element_path
    @ele_json = path.join @templates_path, @ele_path, emp.EMP_TEMPLATE_JSON
    # @logo_img.on 'dblclick', -> console.log "db click ------------"
    # @temp_div.on 'click', -> console.log "click -----"
    # @temp_div.on 'dbclick', -> console.log "div db click -----"

    # It might be useful to either wrap @pack in a class that has a ::validate
    # method, or add a method here. At the moment I think all cases of malformed
    # package metadata are handled here and in ::content but belt and suspenders,
    # you know

  image_format: ->
    # console.log 'image_format'
    # console.log @logo_img.css('height')
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

  # do_click: ->
  #   console.log @com
  #   editor = atom.workspace.getActiveEditor()
  #   if editor
  #     if !@html_snippet
  #       ele_json_data = fs.readFileSync @ele_json, 'utf-8'
  #       @snippet_obj = JSON.parse ele_json_data
  #
  #       html_obj = @snippet_obj.html
  #       css_obj = @snippet_obj.css
  #
  #       @html_snippet = @set_con(html_obj) unless @html_snippet
  #       @css_snippet = @set_con(css_obj) unless @css_snippet
  #     console.log @snippets
  #
  #     # console.log body_parser.parse file_con
  #     # snippetBody = '<${1:div}> asd $2 asd \n</${1:div}>$0'
  #     # tmpr = require atom.packages.activePackages.snippets.mainModulePath
  #     try
  #       if @css_snippet
  #         # console.log "has css"
  #         edit_text = editor.getText()
  #
  #         html_obj = cheerio.load edit_text
  #         re_css = html_obj('style').text()
  #         # console.log re_css
  #
  #         # re_style = $(edit_text).find 'style'
  #         # console.log $(edit_text).find 'style'
  #         # if re_style.length >0
  #         #   console.log
  #         #   re_css = re_style.get(0).innerHTML
  #         #   console.log re_css
  #         if re_css
  #           snippet_ast = css.parse @css_snippet
  #           snippet_rule_list = snippet_ast.stylesheet.rules
  #           snippet_arr = []
  #           for tmp_rule in snippet_rule_list
  #             # console.log
  #             snippet_arr.push tmp_rule.selectors.toString()
  #
  #
  #           re_ast = css.parse re_css
  #           console.log re_ast
  #           # console.log re_ast.stylesheet
  #
  #           rule_list = re_ast.stylesheet.rules
  #           tmp_arr = []
  #           for tmp_rule in rule_list
  #             # console.log
  #             tmp_arr.push tmp_rule.selectors.toString()
  #           # console.log tmp_arr
  #
  #           add_ast = {"type": "stylesheet", "sty  ele_json:null
  #             lv:emp.EMP_JSON_ELElesheet": {"rules": []}}
  #           add_arr = []
  #           for tmp_rule in snippet_rule_list
  #             # console.log tmp_rule
  #             if !(tmp_arr.indexOf(tmp_rule.selectors.toString())+1)
  #               # re_ast.stylesheet.rules.push tmp_rule
  #               add_arr.push tmp_rule
  #
  #           if add_arr.length >0
  #             add_ast = {"type": "stylesheet", "stylesheet": {"rules": add_arr}}
  #
  #             # console.log re_ast
  #             # console.log re_ast.stylesheet
  #             # console.log tmp_arr
  #             result = css.stringify(add_ast, { sourcemap: true })
  #             # console.log re_ast
  #             # console.log result.code
  #             # console.log line_count = editor.getLineCount()
  #             comment_flag = false
  #             for i in [0..line_count-1]
  #               line_con = editor.lineTextForBufferRow(i)
  #               console.log line_con
  #               console.log "--------#{i}"
  #               if match_re = line_con.match('<style>|<!-.*-->|<!--|-->')
  #                 if !comment_flag
  #                   if match_re[0] is "<style>"
  #                     # console.log "---------------------"
  #                     tmp_range = new Range([i+1, 0], [i+1, 0])
  #                     editor.setTextInBufferRange(tmp_range, "\n    "+result.code+"\n")
  #                     break
  #                   else if match_re[0] is '<!--'
  #                     comment_flag = true
  #                     # console.log "------------comment---------"
  #                     continue
  #                   else if match_re[0] is '-->'
  #                     comment_flag = false
  #
  #                 else if match_re[0] is '-->'
  #                   comment_flag = false
  #
  #
  #         # console.log editor.lineTextForBufferRow(0)
  #
  #         # if result.code isnt re_css
  #         #   html_obj('style').text("\n"+result.code+"\n")
  #         #   # console.log html_obj.html()
  #         #   editor.setText(html_obj.html())
  #
  #
  #     catch err
  #       console.error "insert snippets error "
  #       console.error err
  #
  #       # console.log editor.getText()
  #       # console.log $.parseHTML edit_text
  #
  #     atom.packages.activePackages.snippets?.mainModule?.insert @html_snippet
  #       # console.log escape edit_text

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
        tmp_path = path.join @templates_path, tmp_obj.body
        return fs.readFileSync tmp_path, 'utf-8'
    else
      return null

  do_click_panel: ->
    # console.log @com
    # console.log @pack_type
    if @com.type is @pack_type
      @detail_view = new CbbDetailView(@com, @pack_name)
      if @detail_view.bAlive
        @detail_view.show()
        @fa_view.store_ele_detail(@detail_view)
      else
        @detail_view.destroy()
    else
      emp.show_error("该模板配置错误,请通过编辑修改,或者Template Management 来校验!")
