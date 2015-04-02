{$, $$, View} = require 'atom'
# os = require 'os'
path = require 'path'
fs = require 'fs'
crypto = require 'crypto'
emp = require '../exports/emp'
ComponmentElementView = require './componment-view-element'

module.exports =
class EmpDebugAdpPackageView extends View
  active_panel: null


  @content: ->
    @div class:'cbb-view-resizer tool-panel', 'data-show-on-right-side': atom.config.get('emp-template-management.showOnRightSide'), =>
      @div class:'cbb-view-scroller', =>
        @div class: 'gen_panel', =>
          @ul class:'cbb-head-bar list-inline', tabindex: -1,=>
            @li class:'tab sortable', outlet:'tab1', click:'active_tab1', =>
              @div class:'title', "Tab1"
            @li class:'tab sortable', outlet:'tab2',click:'active_tab2',=>
              @div class:'title', "Tab2"
            @li class:'tab sortable', outlet:'tab3',click:'active_tab3',=>
              @div class:'title', "Tab3"
            @li class:'tab sortable', outlet:'tab4',click:'active_tab4',=>
              @div class:'title', "Tab4"
          #   @span class:'inline-block status-added icon icon-diff-added icon-btn-bor '
          #   @span class:'inline-block status-modified icon icon-diff-modified icon-btn-bor '
          #   @span class:'inline-block status-removed icon icon-diff-removed icon-btn-bor '
          #   @span class:'inline-block status-renamed icon icon-diff-renamed icon-btn '
          # @div class:'cbb-view-panel', =>
          @div class:'cbb-view-detail', =>

      # @div class:'cbb-view-scroller', =>
              @ol class: 'list-group cbb-view full-menu focusable-panel', tabindex: -1, outlet: 'list'

      @div class:'cbb-view-resize-handle'


  initialize: ->
    project_path = atom.project.getPath()
    # console.log "init"
    atom.commands.add "atom-workspace",
      "emp-template-management:cbb-panel": => @toggle()

    @active_tab1()
    this

  load_default_componment: ->
    @list.empty()

    @cbb_management = atom.project.cbb_management
    tool_setting = @cbb_management.get_tool_detail()

    first_setting = tool_setting[emp.TOOL_FIRST]

    pack = @cbb_management.get_pacakge first_setting.pack_name
    console.log pack
    ele_list = pack.get_element first_setting.type_name
    console.log ele_list
    # if fs.existsSync templates_json
    #   json_data = fs.readFileSync templates_json
    #   templates_obj = JSON.parse json_data
    #   delete templates_obj.templates?[emp.EMP_DEFAULT_TYPE]?.length

    console.log "templates obj"
    # console.log templates_obj.templates?[emp.EMP_DEFAULT_TYPE]

    for name, obj of ele_list
      # @list.append tempRow
      # name, description, version, repository
      tempView = new ComponmentElementView(obj)
      @list.append tempView

  attach: ->
    @load_default_componment()
    atom.workspace.addRightPanel(item: this)


  toggle: ->
    if @isVisible()
      @detach()
    else
      console.log "---- show ----"
      @show()

  show: ->

    @attach()
    # @

  serialize: ->
    ""

  show_toolbar: ->
    console.log "show_detail"
    # @emp_debugger_bar.show_view("test")

  active_tab1: ->
    # console.log "tab1"
    @active_panel?.removeClass('active')
    @active_panel=@tab1
    @active_panel.addClass('active')


  active_tab2: ->
    # console.log "tab2"
    @active_panel?.removeClass('active')
    @active_panel=@tab2
    @active_panel.addClass('active')

  active_tab3: ->
    # console.log "tab3"
    @active_panel?.removeClass('active')
    @active_panel=@tab3
    @active_panel.addClass('active')

  active_tab4: ->
    # console.log "tab4"
    @active_panel?.removeClass('active')
    @active_panel=@tab4
    @active_panel.addClass('active')
