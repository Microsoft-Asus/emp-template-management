# _ = require 'underscore-plus'
{$$, TextEditorView, View} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
emp = require '../exports/emp'
EmpAddPackPanel = require './template_list/add-package-panel'
AvailablePackageView = require './available-package-view'
templates_json = null

module.exports =
class InstalledTemplatePanel extends View
  @content: ->
    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-code', 'Snippets'
          @table class: 'package-snippets-table table native-key-bindings text', tabindex: -1, =>
            @thead =>
              @tr =>
                @th 'Trigger'
                @th 'Name'
                @th 'Body'
            @tbody outlet: 'snippets'

  initialize: () ->
    @packageViews = []
    # @add_package_panel = new EmpAddPackPanel(this)
    # @package_list.after @add_package_panel
    # @cbb_management = atom.project.cbb_management
    # @loadTemplates1()

    @cbb_management = atom.project.cbb_management
    @templates_store_path = atom.project.templates_path
    @snippet_sotre_path = path.join __dirname, '../../snippets/'
    @snippet_css_path = path.join __dirname, '../../css/'
    emp.mkdir_sync_safe @snippet_sotre_path
    emp.mkdir_sync_safe @snippet_css_path

  matchPackages: () ->
    # console.log @filterEditor
    # console.log @filterEditor.getText()
    console.log "matchPackagesmatchPackagesmatchPackages"

  refresh_detail:() ->
    # console.log "do refresh"
    # @cbb_management.do_initialize()
    # @cancel_add_panel()
    # @loadTemplates1()

  loadTemplates1: ->
    @templatePackages.empty()
    packages = @cbb_management.get_pacakges()
    for ccb_name,ccb_obj of packages
      tempRow = $$ -> @div class: 'row'
      @templatePackages.append tempRow
      tempView = new AvailablePackageView(this, ccb_obj)
      tempRow.append tempView

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

  detached: ->
    # @unsubscribe()
