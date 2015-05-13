{$$, TextEditorView, View} = require 'atom-space-pen-views'
_ = require 'underscore-plus'
emp = require '../../exports/emp'

AvailableTypePanel = require './available-type-panel'

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

  initialize: () ->
    @packageViews = []
    @cbb_management = atom.project.cbb_management

  matchPackages: () ->
    # console.log @filterEditor
    # console.log @filterEditor.getText()
    console.log "matchPackagesmatchPackagesmatchPackages"

  refresh_detail:(@pack) ->
    console.log "do refresh"
    # console.log @pack
    @title.text("#{_.undasherize(_.uncamelcase(@pack.name))}")
    @loadTemplates()

  loadTemplates: ->
    # console.log "loadTemplates1"
    @section_container.empty()
    packages = @cbb_management.get_pacakges()
    # console.log @pack
    type_list = @pack.type_list
    # console.log type_list
    for tmp_type in @pack.type_list
      tmp_type_panel = new AvailableTypePanel(tmp_type, @pack)
      @section_container.append tmp_type_panel

  detached: ->
    # @unsubscribe()

  beforeShow: (opts) ->
    if opts?.back
      @breadcrumb.text(opts.back).on 'click', () =>
        @parents('.emp-template-management').view()?.showPanel(opts.back)
    else
      @breadcrumbContainer.hide()
