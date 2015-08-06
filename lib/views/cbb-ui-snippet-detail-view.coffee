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
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'block section-heading icon icon-package','Installed Packages'

      @section class: 'section', =>
        @div outlet:"section_container", class: 'section-container'

  initialize: () ->
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    @snippet_sotre_path = path.join __dirname, '../../snippets/'


  refresh_detail:([@snippet_path, @snippet_file, @snippet_pack]) ->
    console.log @snippet_path, @snippet_file
    @snippet_file_name = path.join @snippet_path , @snippet_file

    # tmp_type_panel = new AvailableTypeView(@snippet_path, @snippet_file)
    # fs.readdir @snippet_sotre_path, (err, files) =>
    #   if err
    #     console.error err
    #   else
    #     @section_container.empty()
    #     console.log files
    #     for tmp_file in files
    #       if path.extname(tmp_file) is emp.DEFAULT_SNIPPET_FILE_EXT
    #
    #         @section_container.append tmp_type_panel

    snippet_obj = {}
    if fs.existsSync @snippet_file_name

      file_ext = path.extname @snippet_file_name
      if file_ext is emp.JSON_SNIPPET_FILE_EXT
        json_data = fs.readFileSync @snippet_file_name
        snippet_obj = JSON.parse json_data
      else
        snippet_obj = CSON.parseCSONFile(@snippet_file_name)


      console.log snippet_obj
      @section_container.empty()
      for snippet_source, snippet_objs of snippet_obj
        console.log snippet_source
        console.log snippet_objs
        tmp_type_panel = new AvailableTypeView(snippet_source, snippet_objs, @snippet_pack)
        # @add_snippets(snippet_objs, snippet_source)
        # @section_container.
        @section_container.append tmp_type_panel

  # add_snippets: (snippet_objs, snippet_source) ->
  #   for name, tmp_obj of snippet_objs
  #     tmp_new_view = new UiSnippetElementView(name, tmp_obj, snippet_source, @snippet_pack)
  #     @snippets.append tmp_new_view
