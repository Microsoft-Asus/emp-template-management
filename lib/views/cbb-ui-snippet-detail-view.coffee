{$$, TextEditorView, View} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
CSON = require 'cson'
emp = require '../exports/emp'
AvailableTypeView = require './ui_snippet/avaliable-ui-type-view'

module.exports =
class InstalledTemplatePanel extends View
  @content: ->
    @div =>
      @ol outlet: 'breadcrumbContainer', class: 'native-key-bindings breadcrumb', tabindex: -1, =>
        @li =>
          @a outlet: 'breadcrumb'
        @li class: 'active', =>
          @a outlet: 'title'
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'block section-heading icon icon-package','Installed Packages'

          @div class: 'editor-container', =>
            @button class: 'control-btn btn btn-info', click:'do_add_new_snippet',' Add New Snippets'
            @button class: 'control-btn btn btn-info', click:'do_edit_css',' Edit Css'

      @section class: 'section', =>
        @div outlet:"section_container", class: 'section-container'

  initialize: () ->
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    # @snippet_sotre_path = path.join __dirname, '../../snippets/'

  refresh_detail:([@snippet_path, @snippet_file, @snippet_pack]) ->
    # console.log @snippet_path, @snippet_file
    @snippet_file_name = path.join @snippet_path , @snippet_file

    snippet_obj = {}
    if fs.existsSync @snippet_file_name

      file_ext = path.extname @snippet_file_name
      if file_ext is emp.JSON_SNIPPET_FILE_EXT
        json_data = fs.readFileSync @snippet_file_name
        snippet_obj = JSON.parse json_data
      else
        snippet_obj = CSON.parseCSONFile(@snippet_file_name)

      # console.log snippet_obj
      @section_container.empty()
      @source_arr = new Array()
      for snippet_source, snippet_objs of snippet_obj
        # console.log snippet_source
        # console.log snippet_objs
        @source_arr.push snippet_source
        tmp_type_panel = new AvailableTypeView(snippet_source, snippet_objs, @snippet_pack)
        # @add_snippets(snippet_objs, snippet_source)
        # @section_container.
        @section_container.append tmp_type_panel

  beforeShow: (opts) ->
    if opts?.back
      @breadcrumb.text(opts.back).on 'click', () =>
        @parents('.emp-template-management').view()?.showPanel(opts.back)
    else
      @breadcrumbContainer.hide()

  do_add_new_snippet: ->
    if @source_arr.length is 1
      @parents('.emp-template-management').view()?.showPanel(emp.EMP_UI_LIB, {}, [@snippet_pack, @source_arr[0]])
    else
      @parents('.emp-template-management').view()?.showPanel(emp.EMP_UI_LIB, {}, [@snippet_pack])


  do_edit_css: ->
    # 设置 ui snippet 存储路径
    [@snippet_sotre_path, @snippet_css_path] = @cbb_management.get_snippet_path()
    tmp_path = path.join @snippet_css_path, @snippet_pack+".css"
    emp.create_editor(tmp_path, emp.EMP_GRAMMAR_CSS)

  # add_snippets: (snippet_objs, snippet_source) ->
  #   for name, tmp_obj of snippet_objs
  #     tmp_new_view = new UiSnippetElementView(name, tmp_obj, snippet_source, @snippet_pack)
  #     @snippets.append tmp_new_view
