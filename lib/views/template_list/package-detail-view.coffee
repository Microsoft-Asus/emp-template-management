{$$, TextEditorView, View} = require 'atom-space-pen-views'
_ = require 'underscore-plus'
emp = require '../../exports/emp'
# EmpAddPackPanel = require './template_list/add-package-panel'
# {Subscriber} = require 'emissary'
# fuzzaldrin = require 'fuzzaldrin'


AvailableTypePanel = require './available-type-panel'

# AvailablePackageView = require './available-package-view'
# ErrorView = require './error-view'
# templates_json = null

module.exports =
class PackageDetailPanel extends View
  # Subscriber.includeInto(this)

  @content: ->
    @div =>
      @ol outlet: 'breadcrumbContainer', class: 'native-key-bindings breadcrumb', tabindex: -1, =>
        @li =>
          @a outlet: 'breadcrumb'
        @li class: 'active', =>
          @a outlet: 'title'

      @section class: 'section', =>
        @div outlet:"section_container", class: 'section-container'

          # @div class: 'editor-container', =>
          #   # @subview 'filterEditor', new TextEditorView(mini: true, placeholderText: 'Filter packages by name')
          #   @button class: 'control-btn btn btn-info', click:'show_add_panel',' Add New Package'
            # @button class: 'control-btn btn btn-info', click:'show_add_panel',' Add New Package'
          # @div outlet: 'updateErrors'

          # @section outlet:'package_list', class: 'sub-section installed-packages', =>
          #   @h3 class: 'sub-section-heading icon icon-package', =>
          #     @text 'Installed Packages'
          #     @span outlet: 'templateCount', class:'section-heading-count', ' (…)'
          #   @div outlet: 'templatePackages', class: 'container package-container', =>
          #     @div class: 'alert alert-info loading-area icon icon-hourglass', "Loading packages…"



  initialize: () ->
    @packageViews = []
    @cbb_management = atom.project.cbb_management

    # if !templates_path = atom.project.templates_path
    #   atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
    #   templates_path =atom.project.templates_path

    # @loadTemplates()

  matchPackages: () ->
    # console.log @filterEditor
    # console.log @filterEditor.getText()
    console.log "matchPackagesmatchPackagesmatchPackages"

  refresh_detail:(@pack) ->
    # console.log "do refresh"
    @title.text("#{_.undasherize(_.uncamelcase(@pack.name))}")
    @loadTemplates()

  loadTemplates: ->
    # console.log "loadTemplates1"
    @section_container.empty()

    # for pack, index in packages
    #   packageRow = $$ -> @div class: 'row'
    #   container.append(packageRow)
    #   packView = new AvailablePackageView(pack, @packageManager, {back: 'Packages'})
    #   packageViews.push(packView) # used for search filterin'
    #   packageRow.append(packView)
    packages = @cbb_management.get_pacakges()
    console.log @pack
    type_list = @pack.type_list
    console.log type_list
    for tmp_type in @pack.type_list
      tmp_type_panel = new AvailableTypePanel(tmp_type, @pack)
      @section_container.append tmp_type_panel



    #
    # console.log packages
    # for ccb_name,ccb_obj of packages
    #   # tmp_obj = @cbb_management.get_package_obj(ccb_name)
    #   tempRow = $$ -> @div class: 'row'
    #   @templatePackages.append tempRow
    #   # name, description, version, repository
    #   # tempView = new AvailableTemplateView(tmp_obj)
    #   tempView = new AvailablePackageView(this, ccb_obj)
    #   tempRow.append tempView

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
    @cancel_add_panel()
    @refresh_detail()


  detached: ->
    # @unsubscribe()

  beforeShow: (opts) ->
    if opts?.back
      @breadcrumb.text(opts.back).on 'click', () =>
        @parents('.emp-template-management').view()?.showPanel(opts.back)
    else
      @breadcrumbContainer.hide()
