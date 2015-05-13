{View, Range} = require 'atom'
{$, $$, TextEditorView} = require 'atom-space-pen-views'
# fs = require 'fs'
remote = require 'remote'
dialog = remote.require 'dialog'

emp = require '../../exports/emp'
SniEle = require './snippet-ele-view'
css = require 'css'
cheerio = require 'cheerio'
# templates_store_path = null

module.exports =
class CbbDetailView extends View
  insert_src_view: {}

  @content: (@ele_obj)->
    temp_path = atom.project.templates_path

    @div outlet:'cbb_detail_div', class:'cbb-detail-view  overlay from-top', =>
      @div class:'cbb_detail_panel panel', =>
        @h1 "Insert Cbb Templates", class: 'panel-heading'

      @div class: 'cbb_detail_info', =>

        @div class:'div_box_r', =>
          @label class:'lab text-highlight',"模板名称:#{@ele_obj.name}"

        @div class:'div_box_bor', =>
          @label class:'text-highlight', "模板描述:"
          @label class:'', "#{@ele_obj.desc}"


        @div class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_html', type: 'checkbox', checked:'true'
            @text "Insert Html"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'html_tree'


          @div outlet:'snippet_html', =>
            @button "Show Html Snippet Detail", class:"btn", click:"show_html_detail"

        @div class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_css', type: 'checkbox', checked:'true'
            @text "Insert Css"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'css_tree'

          @div outlet:'snippet_html', =>
            @button "Show Css Snippet Detail", class:"btn", click:"show_css_detail"

        @div class: 'div_box_check',  =>
          @div class: 'checkbox_ucolumn', =>
            @input outlet:'insert_source', type: 'checkbox', checked:'true'
            @text "Insert Src"
          @div class:'control-ol', =>
            @table class:'control-tab',outlet:'src_tree'

          # @div outlet:'snippet_html', =>
          #   @button "Show Source Snippet Detail", class:"btn", click:"show_source_detail"


        @div class:'div_logo', =>
          @div class:'div_box', =>
            @label class:'lab',"模板示例:"
            # @span "", class: "input-group-btn", =>
        for tmp_detail_img in @ele_obj.detail
          tmp_img_path = path.join temp_path, tmp_detail_img
          @img outlet: 'logo_img', class: 'avatar_detail', src: "#{tmp_img_path}"

      @div class:'div_box_bor'
      @div class:'cbb_detail_foot', =>
        @button "Done", class: "createSnippetButton btn btn-primary", click:'do_input'
        @button "Cancel", class: "createSnippetButton btn btn-primary", click:'do_cancel'

  initialize: (@com) ->
    # @handle_event()
    # pack_select
    @cbb_management = atom.project.cbb_management
    @templates_path = atom.project.templates_path
    @ele_path = @com.element_path
    @ele_json = path.join @templates_path, @ele_path, emp.EMP_TEMPLATE_JSON

    ele_json_data = fs.readFileSync @ele_json, 'utf-8'
    @snippet_obj = JSON.parse ele_json_data

    html_obj = @snippet_obj.html
    css_obj = @snippet_obj.css

    @html_snippet = @set_con(html_obj)
    @css_snippet = @set_con(css_obj)

    console.log @snippet_obj

    # SniEle
    src_arr = @snippet_obj.source
    for tmp_src in src_arr
      tmp_view = new SniEle(this, tmp_src)
      tmp_name = path.basename tmp_view

      @insert_src_view[tmp_name]= tmp_view
      @src_tree.append tmp_view

    @on 'keydown', (e) =>
      console.log "key down"
      if e.which is emp.ESCAPEKEY
        @detach()

    @on 'core:cancel', (e) =>
      console.log "cancel"
    # @on 'focus': (event) =>
    #   # @editorView.focus()
    #   console.log "focus-----"
    # @on 'unfocus': (e) =>
    #   console.log "f out"

    # @initial_select()
    #
    # @snippet_css.hide()
    # @snippet.show()
    # console.log @packs

    # @insert_source.on 'click', =>
    #   console.log "------lll------"
    #   if !@insert_source.prop('checked')
    #     # @src_tree.disable()
    #     # @src_tree.attr('disabled', 'disabled')
    #     for tmp_name, tmp_obj of @insert_src_view
    #       tmp_obj.disable()
    #
    #   else
    #     @src_tree.enable()

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
    # fields = [ @snippet, @cbb_name, @cbb_desc, @snippet_css]
    # # @cbb_name, @cbb_desc, @cbb_else,
    # for field in fields
    #   field.on 'core:confirm', (event) =>
    #     @create_snippet()
    #   field.on 'keyup', =>
    #     @validate_fields()
    # # @sourceHelp.click =>
    # #   @sourceHelpView.toggle()



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
    # editor = atom.workspace.getActiveEditor()
    # if editor
    #   selection = editor.getSelection().getText()
    #   if selection.length > 0
    #     @set_snippet(type, selection)
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
    if @logo_img.css('height') isnt emp.LOGO_IMAGE_BIG_SIZE
      @logo_img.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @logo_img.css('height')
      @logo_img.css('width')

  image_format2: (e, element)->
    tmp_view = $(element).view()
    if @img_detail.css('height') is emp.LOGO_IMAGE_SIZE
      @img_detail.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @img_detail.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @img_detail.css('height', emp.LOGO_IMAGE_SIZE)
      @img_detail.css('width', emp.LOGO_IMAGE_SIZE)



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

  do_input: ->
    console.log atom.workspace.getActivePaneItem()
    console.log atom.workspace.getActivePane()
    # console.log @insert_html.val()
    # console.log @insert_html.prop('checked')
    console.log @com
    @do_input_snippet()
    @toggle()


  do_input_snippet: ->
    console.log @com
    editor = atom.workspace.getActiveEditor()

    if editor
      #
      # if !@html_snippet
      #   ele_json_data = fs.readFileSync @ele_json, 'utf-8'
      #   @snippet_obj = JSON.parse ele_json_data
      #
      #   html_obj = @snippet_obj.html
      #   css_obj = @snippet_obj.css
      #
      #   @html_snippet = @set_con(html_obj) unless @html_snippet
      #   @css_snippet = @set_con(css_obj) unless @css_snippet
      # console.log @snippets
      try
        unless !@insert_css.prop('checked')
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
              console.log re_ast
              # console.log re_ast.stylesheet

              rule_list = re_ast.stylesheet.rules
              tmp_arr = []
              for tmp_rule in rule_list
                # console.log
                tmp_arr.push tmp_rule.selectors.toString()
              # console.log tmp_arr

              add_ast = {"type": "stylesheet", "sty  ele_json:null
                lv:emp.EMP_JSON_ELElesheet": {"rules": []}}
              add_arr = []
              for tmp_rule in snippet_rule_list
                # console.log tmp_rule
                if !(tmp_arr.indexOf(tmp_rule.selectors.toString())+1)
                  # re_ast.stylesheet.rules.push tmp_rule
                  add_arr.push tmp_rule

              if add_arr.length >0
                add_ast = {"type": "stylesheet", "stylesheet": {"rules": add_arr}}

                # console.log re_ast
                # console.log re_ast.stylesheet
                # console.log tmp_arr
                result = css.stringify(add_ast, { sourcemap: true })
                # console.log re_ast
                # console.log result.code
                # console.log line_count = editor.getLineCount()
                comment_flag = false
                for i in [0..line_count-1]
                  line_con = editor.lineTextForBufferRow(i)
                  console.log line_con
                  console.log "--------#{i}"
                  if match_re = line_con.match('<style>|<!-.*-->|<!--|-->')
                    if !comment_flag
                      if match_re[0] is "<style>"
                        # console.log "---------------------"
                        tmp_range = new Range([i+1, 0], [i+1, 0])
                        editor.setTextInBufferRange(tmp_range, "\n    "+result.code+"\n")
                        break
                      else if match_re[0] is '<!--'
                        comment_flag = true
                        # console.log "------------comment---------"
                        continue
                      else if match_re[0] is '-->'
                        comment_flag = false

                    else if match_re[0] is '-->'
                      comment_flag = false

      catch err
        console.error "insert snippets error "
        console.error err

        # console.log editor.getText()
        # console.log $.parseHTML edit_text
      unless !@insert_html.prop('checked')
        atom.packages.activePackages.snippets?.mainModule?.insert @html_snippet
        # console.log escape edit_text

  set_con: (tmp_obj) ->
    if tmp_obj
      if tmp_obj.type is emp.EMP_CON_TYPE
        return tmp_obj.body
      else
        tmp_path = path.join @templates_path, tmp_obj.body
        return fs.readFileSync tmp_path, 'utf-8'
    else
      return null

  show_html_detail: ->
    console.log "show_html_detail"

  show_css_detail: ->
    console.log "show_css_detail"


  show_source_detail: ->
    console.log "show_source_detail"
