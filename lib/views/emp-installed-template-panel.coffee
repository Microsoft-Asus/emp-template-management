# _ = require 'underscore-plus'
{$$, TextEditorView, View} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs'
emp = require '../exports/emp'
# {Subscriber} = require 'emissary'
# fuzzaldrin = require 'fuzzaldrin'

AvailableTemplateView = require './available-template-view'
# ErrorView = require './error-view'
templates_json = null

module.exports =
class InstalledTemplatePanel extends View
  # Subscriber.includeInto(this)

  @content: ->
    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-package', =>
            @text 'Installed Packages'
            @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'
          @div class: 'editor-container', =>
            @subview 'filterEditor', new TextEditorView(mini: true, placeholderText: 'Filter packages by name')

          # @div outlet: 'updateErrors'

          @section class: 'sub-section installed-packages', =>
            @h3 class: 'sub-section-heading icon icon-package', =>
              @text 'Installed Templates'
              @span outlet: 'templateCount', class:'section-heading-count', ' (…)'
            @div outlet: 'templatePackages', class: 'container package-container', =>
              @div class: 'alert alert-info loading-area icon icon-hourglass', "Loading packages…"



  initialize: () ->
    @packageViews = []

    # @filterEditor.getModel().onDidStopChanging => @matchPackages()
    if !templates_path = atom.project.templates_path
      atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
      templates_path =atom.project.templates_path
    templates_json = path.join templates_path, emp.EMP_TEMPLATES_JSON

    @loadTemplates1()

  refresh_detail:() ->
    console.log "do refresh"
    @loadTemplates1()

  loadTemplates1: ->
    console.log "loadTemplates1"
    @templatePackages.empty()



    # for pack, index in packages
    #   packageRow = $$ -> @div class: 'row'
    #   container.append(packageRow)
    #   packView = new AvailablePackageView(pack, @packageManager, {back: 'Packages'})
    #   packageViews.push(packView) # used for search filterin'
    #   packageRow.append(packView)

    if fs.existsSync templates_json
      json_data = fs.readFileSync templates_json
      templates_obj = JSON.parse json_data
      delete templates_obj.templates?[emp.EMP_DEFAULT_TYPE]?.length
      for name, obj of templates_obj.templates?[emp.EMP_DEFAULT_TYPE]
        tempRow = $$ -> @div class: 'row'
        @templatePackages.append tempRow
        # name, description, version, repository
        tempView = new AvailableTemplateView(obj)
        tempRow.append tempView




    # templates = [{name:"emp", description:"this is a test", version:"0.1"},
    #              {name:"ebank", description:"this is a ebank", version:"0.11"},
    #              {name:"gdb", description:"this is a gdb", version:"0.14"},
    #              {name:"boc", description:"this is a boc", version:"1.1"},
    #              {name:"other", description:"this is a other", version:"3.1"}
    #             ]
    # for template in templates
    #   tempRow = $$ -> @div class: 'row'
    #   @templatePackages.append tempRow
    #   # name, description, version, repository
    #   tempView = new AvailableTemplateView(template)
    #   tempRow.append tempView

  #
  #   packageViews

  detached: ->
    # @unsubscribe()

  # filterPackages: (packages) ->
  #   packages.dev = packages.dev.filter ({theme}) -> not theme
  #   packages.user = packages.user.filter ({theme}) -> not theme
  #   packages.core = packages.core.filter ({theme}) -> not theme
  #
  #   packages
  #
  #
  # loadTemplates: ->
  #   @templatesViews = []
  #   @packageManager.getInstalled()
  #     .then (packages) =>
  #       @packages =  @filterPackages(packages)
  #
  #       # @loadingMessage.hide()
  #       # TODO show empty mesage per section
  #       # @emptyMessage.show() if packages.length is 0
  #       @totalPackages.text " (#{@packages.user.length + @packages.core.length + @packages.dev.length})"
  #
  #       _.each @addPackageViews(@communityPackages, @packages.user), (v) => @packageViews.push(v)
  #       @communityCount.text " (#{@packages.user.length})"
  #
  #       @packages.core.forEach (p) ->
  #         # Assume core packages are in the atom org
  #         p.repository ?= "https://github.com/atom/#{p.name}"
  #
  #       _.each @addPackageViews(@corePackages, @packages.core), (v) => @packageViews.push(v)
  #       @coreCount.text " (#{@packages.core.length})"
  #
  #       _.each @addPackageViews(@devPackages, @packages.dev), (v) => @packageViews.push(v)
  #       @devCount.text " (#{@packages.dev.length})"
  #
  #     .catch (error) =>
  #       @loadingMessage.hide()
  #       @featuredErrors.append(new ErrorView(@packageManager, error))
  #
  # addPackageViews: (container, packages) ->
  #   container.empty()
  #   packageViews = []
  #
  #   packages.sort (left, right) ->
  #     leftStatus = atom.packages.isPackageDisabled(left.name)
  #     rightStatus = atom.packages.isPackageDisabled(right.name)
  #     if leftStatus == rightStatus
  #       return 0
  #     else if leftStatus > rightStatus
  #       return 1
  #     else
  #       return -1
  #
  #   for pack, index in packages
  #     packageRow = $$ -> @div class: 'row'
  #     container.append(packageRow)
  #     packView = new AvailablePackageView(pack, @packageManager, {back: 'Packages'})
  #     packageViews.push(packView) # used for search filterin'
  #     packageRow.append(packView)
  #
  #   packageViews
  #
  # filterPackageListByText: (text) ->
  #   return unless @packages
  #   active = fuzzaldrin.filter(@packageViews, text, key: 'filterText')
  #
  #   _.each @packageViews, (view) ->
  #     # should set an attribute on the view we can filter by it instead of doing
  #     # dumb jquery stuff
  #     view.hide().addClass('hidden')
  #   _.each active, (view) ->
  #     view.show().removeClass('hidden')
  #
  #   @totalPackages.text " (#{active.length}/#{@packageViews.length})"
  #   @updateSectionCounts()
  #
  # updateSectionCounts: ->
  #   filterText = @filterEditor.getModel().getText()
  #   if filterText is ''
  #     @totalPackages.text " (#{@packages.user.length + @packages.core.length + @packages.dev.length})"
  #     @communityCount.text " (#{@packages.user.length})"
  #     @coreCount.text " (#{@packages.core.length})"
  #     @devCount.text " (#{@packages.dev.length})"
  #   else
  #     community = @communityPackages.find('.available-package-view:not(.hidden)').length
  #     @communityCount.text " (#{community}/#{@packages.user.length})"
  #     dev = @devPackages.find('.available-package-view:not(.hidden)').length
  #     @devCount.text " (#{dev}/#{@packages.dev.length})"
  #     core = @corePackages.find('.available-package-view:not(.hidden)').length
  #     @coreCount.text " (#{core}/#{@packages.core.length})"
  #
  # matchPackages: ->
  #   filterText = @filterEditor.getModel().getText()
  #   @filterPackageListByText(filterText)
