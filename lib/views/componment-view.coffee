{$, $$, View} = require 'atom'
# os = require 'os'
path = require 'path'
fs = require 'fs'
crypto = require 'crypto'
emp = require '../exports/emp'
ComponmentElementView = require './componment-view-element'

module.exports =
class EmpDebugAdpPackageView extends View

  @content: ->
    @div class:'cbb-view-resizer tool-panel', 'data-show-on-right-side': atom.config.get('emp-template-management.showOnRightSide'), =>
      @div class:'cbb-view-scroller', =>
        @div class: 'gen_panel', =>
          @div class:'cbb-head-bar', =>
            @span class:'inline-block status-added icon icon-diff-added icon-btn-bor '
            @span class:'inline-block status-modified icon icon-diff-modified icon-btn-bor '
            @span class:'inline-block status-removed icon icon-diff-removed icon-btn-bor '
            @span class:'inline-block status-renamed icon icon-diff-renamed icon-btn '
          @div class:'cbb-view-panel', =>
            @div class:'cbb-view-detail', =>
          #
          # @div class:'cbb-head-bottom', "test"

      # @div class:'cbb-view-scroller', =>
              @ol class: 'list-group cbb-view full-menu focusable-panel', tabindex: -1, outlet: 'list'
                # @li =>
                #
                #   @ol class:'list-group', =>
                    # @li class:'two-lines cbb_li_view', =>
                    #   # @div class:'avatar'
                    #   @div class: 'temp_logo', =>
                    #     # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
                    #     @img outlet: 'logo_img', class: 'avatar', src: "/work/code/ide/packages/emp-template-management/templates/test/logo.png", click:'image_format'
                    #   @div class: 'temp_name', =>
                    #     @h4 class:'name_header', "name"
                    #     @span class:'name_detail' ,"this si a desc ----- desc, this si a desc ----- desc1, this si a desc ----- desc2,this si a desc ----- desc3"
                    # @li class:'two-lines cbb_li_view', =>
                    #   # @div class:'avatar'
                    #   @div class: 'temp_logo', =>
                    #     # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
                    #     @img outlet: 'logo_img', class: 'avatar', src: "/work/code/ide/packages/emp-template-management/templates/test/logo.png", click:'image_format'
                    #   @div class: 'temp_name', =>
                    #     @h4 class:'name_header', "name2"
                    #     @span class:'name_detail' ,"this si a desc ----- desc, this si a desc ----- desc1, this si a desc ----- desc2,this si a desc ----- desc3"
                    # @li class:'two-lines cbb_li_view', =>
                    #   # @div class:'avatar'
                    #   @div class: 'temp_logo', =>
                    #     # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
                    #     @img outlet: 'logo_img', class: 'avatar', src: "/work/code/ide/packages/emp-template-management/templates/test/logo.png", click:'image_format'
                    #   @div class: 'temp_name', =>
                    #     @h4 class:'name_header', "name3"
                    #     @span class:'name_detail' ,"this si a desc ----- desc, this si a desc ----- desc1, this si a desc ----- desc2,this si a desc ----- desc3"

      @div class:'cbb-view-resize-handle'


  initialize: ->
    # unless tmp_offline_path = atom.config.get(emp.EMP_OFFLINE_RELATE_DIR)
      # tmp_offline_path = emp.EMP_OFFLINE_RELATE_PATH_V


    # @emp_package_all_view = new PackageAllView()
    project_path = atom.project.getPath()
    console.log "init"
    atom.commands.add "atom-workspace",
      "emp-template-management:cbb-panel": => @toggle()

    # if !templates_path = atom.project.templates_path
    #   atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
    #   templates_path =atom.project.templates_path
    # templates_json = path.join templates_path, emp.EMP_TEMPLATES_JSON

    # @load_default_componment()
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
