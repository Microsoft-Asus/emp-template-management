{$$, TextEditorView, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
path = require 'path'
fs = require 'fs'
CSON = require 'cson'
fuzzy_filter = require('fuzzaldrin').filter

emp = require '../exports/emp'
AvailableTypeView = require './ui_snippet/avaliable-ui-type-view'
UiSnippetElementView = require './ui_snippet/element-ui-snippet-view'

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

          @div class: 'editor-container', =>
            @subview "snippet_search", new TextEditorView(mini: true,attributes: {id: 'snippet_search', type: 'string'},  placeholderText: ' Search Snippets')
      @section class: 'section', =>
        @div outlet:"search_container", style:"display:none;", class: 'section-container', =>
          @section outlet:'package_list', class: 'sub-section installed-packages', =>
            @div class: 'section-heading icon icon-package', =>
              @text "Search Snippets"

            @div outlet: 'no_snippets_info', class: 'container package-container', =>
              @div class: 'alert alert-info loading-area icon icon-hourglass', "No UI Snippets"

            @table outlet:"snippets_table", class: 'package-snippets-table table native-key-bindings text', tabindex: -1, =>
              @thead =>
                @tr =>
                  @th 'Edit'
                  @th 'Trigger'
                  @th 'Name'
                  @th 'Body'
                  @tbody outlet: 'searched_snippets'

        @div outlet:"section_container", class: 'section-container'

  initialize: () ->
    @disposables = new CompositeDisposable()
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    # @snippet_sotre_path = path.join __dirname, '../../snippets/'
    @disposables.add atom.commands.add @snippet_search.element, 'core:confirm', =>
      @do_snippet_search()

  refresh_detail:([@snippet_path, @snippet_file, @snippet_pack]) ->
    @snippet_search.setText ""
    @section_container.show()
    @search_container.hide()

    # console.log @snippet_path, @snippet_file
    @snippet_file_name = path.join @snippet_path , @snippet_file

    @snippet_obj = {}
    if fs.existsSync @snippet_file_name
      file_ext = path.extname @snippet_file_name
      if file_ext is emp.JSON_SNIPPET_FILE_EXT
        json_data = fs.readFileSync @snippet_file_name
        @snippet_obj = JSON.parse json_data
      else
        @snippet_obj = CSON.parseCSONFile(@snippet_file_name)
      @section_container.empty()
      @source_arr = new Array()

      for snippet_source, snippet_objs of @snippet_obj
        @source_arr.push snippet_source
        tmp_type_panel = new AvailableTypeView(snippet_source, snippet_objs, @snippet_pack)
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
    [@snippet_sotre_path, @snippet_css_path, @snippet_img_path] = @cbb_management.get_snippet_path()
    tmp_path = path.join @snippet_css_path, @snippet_pack+".css"
    emp.create_editor(tmp_path, emp.EMP_GRAMMAR_CSS)

  dispose: ->
    @disposables.dispose()

  do_snippet_search: ->
    # console.log @snippet_obj
    search_key = 'name'
    query_snippet = @snippet_search.getText()?.trim()
    if query_snippet
      # console.log query_temp
      @section_container.hide()
      @search_container.show()

      all_snippet_list = @get_snippet_list()
      # console.log all_snippet_list
      filter_re = fuzzy_filter all_snippet_list, query_snippet, key: search_key
      # console.log filter_re
      if filter_re.length > 0
        @no_snippets_info.hide()
        @snippets_table.show()
        @load_search_snippets(filter_re)
      else
        @no_snippets_info.show()
        @snippets_table.hide()
    else
      # console.log "do search null"
      @section_container.show()
      @search_container.hide()

  load_search_snippets: (filter_snippets)->
    @searched_snippets.empty()
    for tmp_obj in filter_snippets
      # console.log tmp_obj
      tmp_new_view = new UiSnippetElementView(tmp_obj.name, tmp_obj.obj, tmp_obj.source, @snippet_pack)
      @searched_snippets.append tmp_new_view

  get_snippet_list: ->
    snippets_arr = new Array()
    for snippet_source, snippet_objs of @snippet_obj
      for tmp_name, tmp_obj of snippet_objs
        snippets_arr.push @new_snippet_obj(tmp_name, tmp_obj,snippet_source)
    snippets_arr

  new_snippet_obj: (tmp_name, tmp_obj, tmp_source)->
    {name:tmp_name, prefix: tmp_obj.prefix, obj:tmp_obj, source: tmp_source}
