{$$, TextEditorView, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'
emp = require '../../exports/emp'
fuzzy_filter = require('fuzzaldrin').filter

AvailableTypePanel = require './available-type-panel'
AvailableTemplatePanel = require './available-template-panel'

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
        @div class: 'section-container', =>
          @section outlet:'package_list', class: 'sub-section installed-packages', =>
            @div class: 'section-heading icon icon-package', =>
              @text "Search Templates: "
              # @span outlet: 'total_temp', class:'section-heading-count', ' (…)'
            @div class: 'container package-container', =>
              # @div class: 'alert alert-info loading-area icon icon-hourglass', "No CBB Element"
              @subview "temp_search", new TextEditorView(mini: true,attributes: {id: 'temp_search', type: 'string'},  placeholderText: ' Template Name')
        @div outlet:"search_container", style:"display:none;", class: 'section-container', =>
          @section class: 'sub-section installed-packages', =>
            @div class: 'section-heading icon icon-package', =>
              @text "Search Result"
            @div outlet: 'template_element', class: 'container package-container', =>
              @div class: 'alert alert-info loading-area icon icon-hourglass', "No CBB Element"



        @div outlet:"section_container", class: 'section-container'

  initialize: () ->
    @disposables = new CompositeDisposable()
    @packageViews = []
    @cbb_management = atom.project.cbb_management
    @disposables.add atom.commands.add @temp_search.element, 'core:confirm', =>
      @do_temp_search()

  refresh_detail:(@pack) ->
    # console.log "do refresh"
    # console.log @pack
    @title.text("#{_.undasherize(_.uncamelcase(@pack.name))}")
    @temp_search.setText ""
    @loadTemplates()
    @section_container.show()
    @search_container.hide()

  loadTemplates: ->
    # console.log "loadTemplates1"
    @section_container.empty()
    type_list = @pack.type_list
    # console.log type_list
    for tmp_type in type_list
      tmp_type_panel = new AvailableTypePanel(tmp_type, @pack)
      @section_container.append tmp_type_panel

  detached: ->
    # @unsubscribe()

  dispose: ->
    @disposables.dispose()

  beforeShow: (opts) ->
    if opts?.back
      @breadcrumb.text(opts.back).on 'click', () =>
        @parents('.emp-template-management').view()?.showPanel(opts.back)
    else
      @breadcrumbContainer.hide()


  do_temp_search: ->
    query_temp = @temp_search.getText()?.trim()
    if query_temp
      # console.log query_temp
      all_temp_list = @get_temp_list()
      # console.log all_temp_list
      filter_re = fuzzy_filter all_temp_list, query_temp, key:'name'
      # console.log filter_re
      @load_search_templates(filter_re)
      @section_container.hide()
      @search_container.show()
    else
      # console.log "do search null"
      @section_container.show()
      @search_container.hide()

  load_search_templates: (filter_re)->
    @template_element.empty()
    @template_element.empty()
    for ele_obj in filter_re
      ele_panel = new AvailableTemplatePanel(ele_obj.obj, this, @pack, ele_obj.type)
      @template_element.append ele_panel

  get_temp_list: ->
    temp_list = new Array()
    for tmp_type in @pack.type_list
      for  tmp_name, tmp_obj of  @pack.get_element(tmp_type)
        temp_list.push @new_temp(tmp_name, tmp_type, tmp_obj)
    temp_list

  new_temp:(tmp_name, tmp_type, tmp_obj) ->
    {name:tmp_name, type:tmp_type, obj:tmp_obj}
