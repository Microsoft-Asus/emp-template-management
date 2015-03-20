{$, $$, ScrollView} = require 'atom'
remote = require 'remote'
dialog = remote.require 'dialog'
fs = require 'fs'
path = require 'path'

emp = require '../exports/emp'
GeneralPanel = require './general-panel'
InstalledTemplateView = require './emp-installed-template-panel'
AddTemplateView = require './add-template-view'

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
      console.log "click~~~~"
      @showPanel($(e.target).closest('li').attr('name'))

    @addCorePanel emp.DEFAULT_PANEL, 'paintcan', -> new GeneralPanel("1")
    @addCorePanel emp.EMP_TEMPLATE, 'package', -> new InstalledTemplateView("2")
    @addCorePanel emp.EMP_UPLOAD, 'plus', -> new AddTemplateView("3")
    @addCorePanel emp.EMP_INSTALL, 'cloud-download', -> new GeneralPanel("4")
    @addCorePanel emp.EMP_MANAGE, 'settings', -> new GeneralPanel("5")

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

  getOrCreatePanel: (name) ->
    panel = @panelsByName?[name]
    unless panel?
      if callback = @panelCreateCallbacks?[name]
        panel = callback()
        @panelsByName ?= {}
        @panelsByName[name] = panel
        delete @panelCreateCallbacks[name]
    panel

  showPanel: (name, opts) ->
    if panel = @getOrCreatePanel(name)
      panel.refresh_detail?()
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
    "Create An Emp App Wizard"

  getIconName: ->
    "tools"

  getURI: ->
    @uri


  isEqual: (other) ->
    other instanceof EmpTmpManagementView


  remove_loading: ->
    @loadingElement.remove()

  do_cancel: ->
    # console.log "do_submit "
    atom.workspace.getActivePane().destroyActiveItem()

  do_submit: ->
    # console.log "do do_submit"
    try
      unless @app_name = @app_name_editor.getEditor().getText().trim()
        throw("工程名称不能为空！")
      unless @app_dir = @app_path.getEditor().getText().trim()
        throw("工程路径不能为空！")
      atom.config.set(emp.EMP_APP_WIZARD_APP_P, @app_dir)
      if @ewp_dir = @ewp_path.getEditor().getText().trim()
        atom.config.set(emp.EMP_APP_WIZARD_EWP_P, @ewp_dir)
      else
        @ewp_dir = ""
      console.log  @app_name
      atom.config.set(emp.EMP_TMPORARY_APP_NAME, @app_name)

      @mk_app_dir(@app_dir, @app_name)
      # console.log  "111111"
      emp.show_info("创建app 完成~")
      # console.log  "222222"
      atom.open options =
        pathsToOpen: [@app_dir]
        devMode: false

      atom.workspaceView.trigger 'core:close'
    catch e
      console.error e
      emp.show_error(e)

  mk_app_dir:(app_path, app_name) ->
    base_name = path.basename(app_path)
    to_path = ''
    if base_name is app_name
      emp.mk_dirs_sync(app_path)
      to_path = app_path
      @app_dir = to_path
    else
      to_path = path.join(app_path, app_name)
      emp.mk_dirs_sync(to_path)
      @app_dir = to_path

    # console.log re
    basic_dir = path.join __dirname, '../../', emp.STATIC_APP_TEMPLATE, @app_version
    @copy_template(to_path, basic_dir)

  copy_template: (to_path, basic_dir)->
    # console.log "copy  template`````--------"
    # console.log to_path
    # console.log basic_dir
    files = fs.readdirSync(basic_dir)
    for template in files
      f_path = path.join basic_dir, template
      t_path = path.join to_path, @string_replace(template)
      if fs.lstatSync(f_path).isDirectory()
        emp.mkdir_sync(t_path)
        @copy_template(t_path, f_path)
      else
        @copy_content(t_path, f_path)


  string_replace: (str) ->
    map = [{'k':/\$\{app\}/ig,'v':@app_name}, {'k':/\$\{ecl_ewp\}/ig,'v':@ewp_dir}]
    for o in map
      str = str.replace(o.k, o.v)
    str

  copy_content: (t_path, f_path)->
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path, 'utf8'
    nf_con = @string_replace(f_con)
    fs.writeFileSync(t_path, nf_con, 'utf8')
    if f_name is 'iewp' or f_name is 'configure'
      tmp_os = emp.get_emp_os()
      if tmp_os is emp.OS_DARWIN or tmp_os is emp.OS_LINUX
        fs.chmodSync(t_path, 493);

#
# module.exports =
# class EmpTemplateManagementView
#   constructor: (serializeState) ->
#     # Create root element
#     @element = document.createElement('div')
#     @element.classList.add('emp-template-management')
#
#     # Create message element
#     message = document.createElement('div')
#     message.textContent = "The EmpTemplateManagement package is Alive! It's ALIVE!"
#     message.classList.add('message')
#     @element.appendChild(message)
#
#   # Returns an object that can be retrieved when package is activated
#   serialize: ->
#
#   # Tear down any state and detach
#   destroy: ->
#     @element.remove()
#
#   getElement: ->
#     @element
