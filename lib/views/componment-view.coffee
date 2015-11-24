{CompositeDisposable} = require 'atom'
# {View} = require 'atom'
{$, $$, View, TextEditorView} = require 'atom-space-pen-views'
# os = require 'os'
path = require 'path'
fs = require 'fs'
crypto = require 'crypto'
emp = require '../exports/emp'
fuzzy_filter = require('fuzzaldrin').filter
ComponmentElementView = require './tool_bar/componment-view-element'

# CBB 边栏
module.exports = class EmpDebugAdpPackageView extends View


  @content: ->
    @div oulet:'cbb_tool_view', class:'cbb-view-resizer tool-panel', 'data-show-on-right-side': atom.config.get('emp-template-management.showOnRightSide'), =>
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
          @div class:'cbb-filter', =>
            @subview "template_name", new TextEditorView(mini: true,attributes: {id: 'template_name', type: 'string'},  placeholderText: ' Template Name')

          # @div class:'cbb-view-scroller', =>
          @div outlet:'template_list', class:'cbb-view-detail', =>
            @ol class: 'list-group cbb-view full-menu focusable-panel', tabindex: -1, outlet: 'list'
          @div outlet:'query_template_list', class:'cbb-view-detail', style:"display:none;", =>
            @ol class: 'list-group cbb-view full-menu focusable-panel', tabindex: -1, outlet: 'query_ol_list'

          @div class: 'cbb-footor', =>
            @ul class:'eul' ,=>
              @li outlet:"emp_footor_btn", class:'eli curr',click: 'hide_view', "Hide"

      @div class:'cbb-view-resize-handle', mousedown: 'resizeStarted'


  initialize: ->
    @active_panel=null
    @first_show = true
    @cbb_management = atom.project.cbb_management
    @disposables = new CompositeDisposable()
    # project_path = atom.project.getPath()
    # console.log "init"
    @disposables.add atom.commands.add "atom-workspace",
      "emp-template-management:cbb-panel": => @toggle()
    @active_tab1()
    @disposables.add atom.commands.add @template_name.element, 'core:confirm', =>
      @do_temp_search()

    @template_name.getModel().onDidStopChanging =>
      # console.log "change ------------"
      @do_temp_search()

    this

  # ----------------------------------------------------------------------------
  # @doc 为 CBB Tool Bar 添加查询功能
  do_temp_search: ->
    query_temp = @template_name.getText()?.trim()
    if query_temp
      # console.log query_temp
      all_temp_list = @get_temp_list()
      # console.log all_temp_list
      filter_re = fuzzy_filter all_temp_list, query_temp, key:'name'
      # # console.log filter_re
      @load_search_templates(filter_re)
      @template_list.hide()
      @query_template_list.show()
    else
      # console.log "do search null"
      @template_list.show()
      @query_template_list.hide()

  cancel_search: ->
    @template_name.setText("")
    # @template_list.show()
    # @query_template_list.hide()

  get_temp_list: ->
    temp_list = new Array()
    cbb_packages = @cbb_management.get_pacakges()
    # console.log cbb_packages
    for pack_name, pack_obj of cbb_packages
      tmp_type_list = pack_obj.type_list
      for tmp_type in tmp_type_list
        for  tmp_name, tmp_obj of  pack_obj.get_element(tmp_type)
          temp_list.push @new_temp(pack_name, tmp_name, tmp_type, tmp_obj)

    temp_list

  new_temp:(pack_name, tmp_name, tmp_type, tmp_obj) ->
    {name:tmp_name, type:tmp_type, obj:tmp_obj, pack:pack_name}

  load_search_templates: (temp_list)->
    # console.log temp_list
    @query_ol_list.empty()
    if temp_list
      if temp_list.length > 0
        for tmp_obj in temp_list
          tempView = new ComponmentElementView(tmp_obj.obj, this, tmp_obj.pack)
          @query_ol_list.append tempView
      else
        tempView = $$ ->
              @li class:'two-lines cbb_li_view', "No Search Result"
        @query_ol_list.append tempView
    else
        tempView = $$ ->
              @li class:'two-lines cbb_li_view', "No Search Result"
        @query_ol_list.append tempView

  # ----------------------------------------------------------------------------

  load_default_componment: (tab_index)->
    @list.empty()
    # console.log tab_index
    tool_setting = @cbb_management.get_tool_detail()
    tab_setting = tool_setting[tab_index]
    # console.log tab_setting
    if tab_setting
      for key, val of tab_setting
        # 如果为 all 则显示全部的
        if key is emp.EMP_ALL_PACKAGE
          cbb_packages = @cbb_management.get_pacakges()
          # console.log cbb_packages
          for pack_name, pack_obj of cbb_packages
            tmp_type_list = pack_obj.type_list
            for tmp_type in tmp_type_list
              for name, obj of  pack_obj.get_element(tmp_type)
                tempView = new ComponmentElementView(obj, this, pack_name)
                @list.append tempView
        else
          pack = @cbb_management.get_pacakge key
          # console.log pack
          if pack_obj
            for tmp_type in val
              # 判断是否为显示全部类型
              if tmp_type is emp.EMP_ALL_TYPE
                tmp_type_list = pack_obj.type_list
                for tmp_type_ele in tmp_type_list
                  for  name, obj of  pack_obj.get_element(tmp_type)
                    tempView = new ComponmentElementView(obj, this, key)
                    @list.append tempView
              else
                ele_list = pack_obj.get_element tmp_type
                # console.log ele_list
                # console.log templates_obj.templates?[emp.EMP_DEFAULT_TYPE]
                if tmp_type
                  for name, obj of ele_list
                    tempView = new ComponmentElementView(obj, this, key)
                    @list.append tempView
    else
        tempView = $$ ->
              @li class:'two-lines cbb_li_view', "No Setting"
        @list.append tempView

  attach: ->
    # @load_default_componment()
    atom.workspace.addRightPanel(item: this)


  toggle: ->
    # console.log "---- toggle ----"
    if @first_show
      @first_show = false
      if @isVisible()
        @detach()
      else
        @attach()
    else
      if @isVisible()
        this.hide()
      else
        this.show()

  detached: ->
    @disposables.dispose()

  serialize: ->
    ""

  show_toolbar: ->
    console.log "show_detail"
    # @emp_debugger_bar.show_view("test")

  active_tab1: ->
    # console.log "tab1"
    @cancel_search()
    @active_panel?.removeClass('active')
    @active_panel=@tab1
    @active_panel.addClass('active')
    @load_default_componment(emp.TOOL_FIRST)


  active_tab2: ->
    @cancel_search()
    # console.log "tab2"
    @active_panel?.removeClass('active')
    @active_panel=@tab2
    @active_panel.addClass('active')
    @load_default_componment(emp.TOOL_SECOND)

  active_tab3: ->
    @cancel_search()
    # console.log "tab3"
    @active_panel?.removeClass('active')
    @active_panel=@tab3
    @active_panel.addClass('active')
    @load_default_componment(emp.TOOL_THIRD)

  active_tab4: ->
    @cancel_search()
    # console.log "tab4"
    @active_panel?.removeClass('active')
    @active_panel=@tab4
    @active_panel.addClass('active')
    @load_default_componment(emp.TOOL_FOURTH)


  #日志界面高度计算处理
  resizeStarted: ->
    $(document).on('mousemove', @resizeTreeView)
    $(document).on('mouseup', @resizeStopped)

  resizeStopped: ->
    $(document).off('mousemove', @resizeTreeView)
    $(document).off('mouseup', @resizeStopped)

  resizeTreeView: (e) =>
    # console.log e
    {pageX, which} = e
    return @resizeStopped() unless which is 1
    tmp_width = $(document.body).width()-pageX

    return if tmp_width < 200
    @width(tmp_width)
    # @cbb_tool_view.css("max-width", tmp_width)

  # store_ele_detail: (@store_detail)=>

  store_ele_detail: (new_detail_view)=>
    unless !@store_detail
      @store_detail.destroy()
    @store_detail = new_detail_view

  # 隐藏当前页面
  hide_view: ->
    this.hide()
