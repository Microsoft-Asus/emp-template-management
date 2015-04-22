{$, $$, ScrollView} = require 'atom'
remote = require 'remote'
dialog = remote.require 'dialog'
fs = require 'fs'
path = require 'path'

emp = require '../exports/emp'
GeneralPanel = require './general-panel'
InstalledTemplateView = require './emp-installed-template-panel'
AddTemplateView = require './add-template-view'
PackageDetailView = require './template_list/package-detail-view'
ElementDetailView = require './template_list/element-detail-view'
CbbToolSettingPanel = require './cbb-tool-setting-view'
CbbPackImportView = require './cbb-pack-import-view'
CbbConfigView = require './cbb-config-view'

module.exports =
class EmpTmpManagementView extends ScrollView

  @content: ->
    @div class: 'emp-template-management pane-item', tabindex: -1, =>
      @div class: 'config-menu', outlet: 'sidebar', =>
        @div outlet:"emp_logo", class: 'atom-banner'
        # @div outlet: "loadingElement", class: 'alert alert-info loading-area icon icon-hourglass', "Loading config"
        @ul class: 'panels-menu nav nav-pills nav-stacked', outlet: 'panelMenu', =>
          @div class: 'panel-menu-separator', outlet: 'menuSeparator'
        # @div class: 'panel-menu-separator', outlet: 'menuSeparator'
        @div class: 'button-area', =>
          @button class: 'btn btn-default icon icon-link-external', outlet: 'openDotAtom', 'Open ~/.template'
      @div class: 'panels', outlet: 'panels'


  initialize: ({@uri, activePanelName}={}) ->
    super
    console.log "temp wizard view"
    # if @default_app_path = atom.config.get(emp.EMP_APP_WIZARD_APP_P)
    #   # console.log "exist"
    #   @app_path.getEditor().setText(@default_app_path)
    # if tmp_ewp_path = atom.config.get(emp.EMP_APP_WIZARD_EWP_P)
    #   # console.log "exist ewp"
    #   @default_ewp_path = tmp_ewp_path
    #   @ewp_path.getEditor().setText(@default_ewp_path)
    # else
    #   @ewp_path.getEditor().setText(@default_ewp_path)
    # @focus()
    @panelToShow = activePanelName

    process.nextTick => @initializePanels()

  initializePanels: ->
    return if @panels.size > 0
    # console.log  atom.project.cbb_management


    @panelsByName = {}
    @on 'click', '.panels-menu li a, .panels-packages li a', (e) =>
      @showPanel($(e.target).closest('li').attr('name'))

    @addCorePanel emp.DEFAULT_PANEL, 'paintcan', -> new GeneralPanel("1")
    @addCorePanel emp.EMP_TEMPLATE, 'package', -> new InstalledTemplateView("2")
    @addCorePanel emp.EMP_UPLOAD, 'plus', -> new AddTemplateView("3")
    @addCorePanel emp.EMP_Setting, 'keyboard', -> new CbbToolSettingPanel("4")
    @addCorePanel emp.EMP_EXI, 'cloud-download', -> new CbbPackImportView("5")
    @addCorePanel emp.EMP_CONFIG, 'gear', -> new CbbConfigView("6")

    # @addCorePanel emp.EMP_MANAGE, 'settings', -> new GeneralPanel("5")

    @addOtherPanel emp.EMP_CCB_PACK_DETAIL, -> new PackageDetailView()
    @addOtherPanel emp.EMP_CBB_ELE_DETAIL, -> new ElementDetailView()
    # @cbb_management = atom.project.cbb_management
    # packages = @cbb_management.get_pacakges()
    #
    # @addPackagePanel(pack) for p_name, pack in packages

    @showPanel(@panelToShow) if @panelToShow
    @showPanel(emp.DEFAULT_PANEL) unless @activePanelName
    @sidebar.width(@sidebar.width()) if @isOnDom()

  addCorePanel: (name, iconName, panel) ->
    panelMenuItem = $$ ->
      @li name: name, =>
        @a class: "icon icon-#{iconName}", name
    @menuSeparator.before(panelMenuItem)
    @addPanel(name, panelMenuItem, panel)

  addPanel: (name, panelMenuItem, panelCreateCallback) ->
    @panelCreateCallbacks ?= {}
    @panelCreateCallbacks[name] = panelCreateCallback
    @showPanel(name) if @panelToShow is name

  addOtherPanel: (name, panelCreateCallback) ->
    # @panelDetail ? = {}
    @addPanel name, null, =>
      panelCreateCallback()



  getOrCreatePanel: (name) ->
    panel = @panelsByName?[name]
    unless panel?
      if callback = @panelCreateCallbacks?[name]
        panel = callback()
        @panelsByName ?= {}
        @panelsByName[name] = panel
        delete @panelCreateCallbacks[name]
    panel

  showPanel: (name, opts, detail) ->
    if panel = @getOrCreatePanel(name)
      panel.refresh_detail?(detail)
      @panels.children().hide()
      @panels.append(panel) unless $.contains(@panels[0], panel[0])
      panel.beforeShow?(opts)
      panel.show()
      panel.focus()
      @makePanelMenuActive(name)
      @activePanelName = name
      @panelToShow = null
    else
      @panelToShow = name

  makePanelMenuActive: (name) ->
    @sidebar.find('.active').removeClass('active')
    @sidebar.find("[name='#{name}']").addClass('active')


  # Returns an object that can be retrieved when package is activated
  serialize: ->
    deserializer: emp.TEMP_WIZARD_VIEW
    version: 1
    activePanelName: @activePanelName ? @panelToShow
    uri: @uri

  detached: ->
    @unsubscribe()

  focus: ->
    super
    # Pass focus to panel that is currently visible
    for panel in @panels.children()
      child = $(panel)
      if child.isVisible()
        if view = child.view()
          view.focus()
        else
          child.focus()
        return

  getUri: ->
    @uri

  getTitle: ->
    "Template Management View"

  getIconName: ->
    "tools"

  getURI: ->
    @uri


  isEqual: (other) ->
    other instanceof EmpTmpManagementView


  remove_loading: ->
    @loadingElement.remove()
