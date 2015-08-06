{$$, TextEditorView, View} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
emp = require '../exports/emp'
# AvailableTypeView = require './ui_snippet/avaliable-ui-type-view'
AvailableSnippetView = require './ui_snippet/avaliable-ui-snippet-view'

module.exports =
class InstalledTemplatePanel extends View
  @content: ->
    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'block section-heading icon icon-package','Installed Snippets'

          @section class: 'sub-section installed-packages', =>
            @h3 class: 'sub-section-heading icon icon-package', =>
              @text 'Installed Snippets'

            @div outlet: 'section_container', class: 'container package-container', =>
              @div class: 'alert alert-info loading-area icon icon-hourglass', "Loading packages…"


  initialize: () ->
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    @snippet_sotre_path = path.join __dirname, '../../snippets/'
    @snippet_css_path = path.join __dirname, '../../css/'
    emp.mkdir_sync_safe @snippet_sotre_path
    emp.mkdir_sync_safe @snippet_css_path

  refresh_detail:() ->
    @load_snippets()

  load_snippets: ->
    fs.readdir @snippet_sotre_path, (err, files) =>
      if err
        console.error err
      else
        @section_container.empty()
        console.log files
        for tmp_file in files
          if path.extname(tmp_file) is emp.DEFAULT_SNIPPET_FILE_EXT
            tmp_type_panel = new AvailableSnippetView(@snippet_sotre_path, tmp_file)
            @section_container.append tmp_type_panel

  # 添加新的 package 类别
  show_add_panel: ->
    console.log 'show_add_panel'
    @package_list.hide()
    @add_package_panel.show()

  show_edit_panel: (tmp_obj)->
    @add_package_panel.set_edit_state(tmp_obj)
    @show_add_panel()


  cancel_add_panel: ->
    @package_list.show()
    @add_package_panel.hide()

  success_add_panel: ->
    @refresh_detail()
