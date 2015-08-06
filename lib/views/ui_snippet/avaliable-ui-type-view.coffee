{$$$, View} = require 'atom-space-pen-views'

emp = require '../../exports/emp'
path = require 'path'
fs = require 'fs'
UiSnippetElementView = require './element-ui-snippet-view'

module.exports =
class AvailableTypePanel extends View

  @content: (snippet_source, snippet_objs) ->
    # snippet_pack = path.basename snippet_file, emp.DEFAULT_SNIPPET_FILE_EXT
    @section outlet:'package_list', class: 'sub-section installed-packages', =>
      @div class: 'section-heading icon icon-package', =>
        @text "Snippets Type: #{snippet_source}"
        @span outlet: 'total_snippets', class:'section-heading-count', ' (…)'

      @div outlet: 'no_snippets_info', class: 'container package-container', =>
        @div class: 'alert alert-info loading-area icon icon-hourglass', "No UI Snippets"

      @table outlet:"snippets_table", class: 'package-snippets-table table native-key-bindings text', tabindex: -1, style:"display:none;", =>
        @thead =>
          @tr =>
            @th 'Edit'
            @th 'Trigger'
            @th 'Name'
            @th 'Body'
        @tbody outlet: 'snippets'

  initialize: (@snippet_source, @snippet_objs, @snippet_pack) ->
    # @snippet_pack = path.basename @snippet_file, emp.DEFAULT_SNIPPET_FILE_EXT
    # @cbb_management = atom.project.cbb_management
    # @snippet_css_path = path.join __dirname, '../../../css/'
    # @snippet_file_name = path.join @snippet_path , @snippet_file
    # console.log @snippet_file_name
    @no_snippets_info.hide()
    @snippets_table.show()
    # console.log @snippet_objs

    for name, tmp_obj of @snippet_objs
      tmp_new_view = new UiSnippetElementView(name, tmp_obj, @snippet_source, @snippet_pack)
      @snippets.append tmp_new_view


#
