{$$, TextEditorView, View} = require 'atom-space-pen-views'
remote = require 'remote'
dialog = remote.require 'dialog'
fs = require 'fs'
path = require 'path'

emp = require '../../exports/emp'
CbbEleView = require './table-element-view'
# EmpCbbPackage = require '../../util/emp_ccb_package'

module.exports =
class AddPackagePanel extends View
  # Subscriber.includeInto(this)
  type_view:{}
  edit_type:{}
  add_type:[]
  delete_type:[]
  editing_view:null
  add_flag: true


  @content: ->
    logo_img = emp.get_default_logo()

    @section outlet:'add_package_panel', class: 'sub-section installed-packages', style:"display: none;", =>#none
      @div class: 'section-container', =>
        @div class: 'section-heading icon icon-package', =>
          @text 'Add Packages'
          @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'

        @div class: 'section-body', =>
          @div class: 'control-group', =>
            @div class: 'controls', =>
              @label class: 'control-label', =>
                @div class: 'info-label', "模板集合名称"
                @div class: 'setting-description', "分类模板的根级路径"
              # @div class: 'editor-container', =>
              @subview "package_name", new TextEditorView(mini: true,attributes: {id: 'package_name', type: 'string'},  placeholderText: ' Package Name')

        @div class: 'section-body', =>
          @div class: 'control-group', =>
            @div class: 'controls', =>
              @label class: 'control-label', =>
                @div class: 'info-label', "描述"
                @div class: 'setting-description', "为你的模板集合添加描述"
            @div class: 'controls', =>
              # @div class: 'editor-container', =>
              @subview "package_desc", new TextEditorView(mini: true,attributes: {id: 'package_desc', type: 'string'},  placeholderText: ' Package Describtion')

        @div class: 'section-body', =>
          @div class: 'control-group', =>
            @div class: 'controls', =>
              @label class: 'control-label', =>
                @div class: 'info-label', "子类型"
                @div class: 'setting-description', "为你的模板集合添加子类型, 默认存在的子类型为 '组件(componment)', 您可以添加更多类型到该集合中.那么之后您添加模板就可以分类到该子类型下."
            @div class:'control-ol', =>
              @table class:'control-tab',outlet:'ccb_tree'
            @div outlet:'ele_add_panel', class: 'controls', =>
              @subview "package_type_add", new TextEditorView(mini: true,attributes: {id: 'package_type_add', type: 'string'},  placeholderText: ' Type Name')
            # @div class:'controls', =>
              @div class:'btn-box-n', =>
                @button class:'btn btn-info', click:'do_add_type',"Add"

            @div outlet:'ele_edit_panel', class: 'controls', style:"display:none;", =>
              @subview "package_type_edit", new TextEditorView(mini: true,attributes: {id: 'package_type_edit', type: 'string'},  placeholderText: ' Type Name')
            # @div class:'controls', =>
              @div class:'btn-box-n', =>
                @button class:'btn btn-info', click:'do_cancel_edit',"Cancel"
                @button class:'btn btn-info', click:'over_edit',"Edit"

        @div class: 'section-body', =>
          @div class: 'control-group', =>
            @div class: 'controls', =>
              @label class: 'control-label', =>
                @div class: 'setting-title', "Logo"
                @div class: 'setting-description', "缩略图"

            @div class: 'controls', =>
              @div class:'controle-logo', =>
                @div class: 'meta-user', =>
                  @img outlet:"logo_image", class: 'avatar', src:""
                @div class:'meta-controls', =>
                  @div class:'btn-group', =>
                    @select outlet:"logo_select", id: "logo", class: 'form-control', =>
                      # @option value: emp.EMP_NAME_DEFAULT, emp.EMP_NAME_DEFAULT
                    @button class: 'control-btn btn btn-info', click:'select_logo',' Chose Other Logo '

        @div class: 'section-body', =>
          @div class: 'control-foot ', =>
            @button class: 'control-btn btn btn-info', click:'do_cancel', "Cancel"
            @button class: 'control-btn btn btn-info', click:'do_ok',"Ok"


  initialize: (@fa_view) ->
    console.log "add package pane;"
    @cbb_management = atom.project.cbb_management
    @logo_img = emp.get_default_logo()
    @logo_select.change (event) =>
      if @logo_select.val() is emp.EMP_NAME_DEFAULT
        @logo_image.attr("src", @logo_img)
      else
        @logo_image.attr("src", @logo_select.val())
    @initial_input()

  initial_input: ->
    def_type = emp.EMP_CPP_TYPE_DEF
    # def_type.push "test"
    # def_type.push "test1"
    # def_type.push "test2"
    # def_type.push emp.EMP_DEFAULT_TYPE
    @type_view = {}
    @ccb_tree.empty()

    # 默认类型
    def_view = new CbbEleView(this, emp.EMP_DEFAULT_TYPE, true)
    @type_view[emp.EMP_DEFAULT_TYPE]= def_view
    @ccb_tree.append def_view

    for tmp_name in def_type
      tmp_view = new CbbEleView(this, tmp_name)
      @type_view[tmp_name]= tmp_view
      @ccb_tree.append tmp_view

    @package_name.setText ""
    @package_desc.setText ""
    @package_type_add.setText ""
    @package_type_edit.setText ""

    # 设置默认图片
    @logo_select.empty()
    def_opt = document.createElement 'option'
    def_opt.text = path.basename emp.EMP_NAME_DEFAULT
    def_opt.value = emp.EMP_NAME_DEFAULT
    def_opt.selected = "selected"
    @logo_select.append def_opt
    @logo_image.attr("src", @logo_img)


  set_add_flag:(tmp_flag=true)->
    @add_flag=tmp_flag


  #用于编辑时设置初始值
  set_edit_state: (tmp_obj)->
    console.log tmp_obj
    @initial_input()

    @set_add_flag(false)
    @package_name.setText(tmp_obj.name)
    @package_desc.setText(tmp_obj.desc) unless !tmp_obj.desc
    @old_name = tmp_obj.name

    if tmp_obj.logo
      tmp_opt = document.createElement 'option'
      tmp_opt.text = path.basename tmp_obj.logo
      tmp_opt.value = tmp_obj.logo
      # console.log tmp_opt
      tmp_opt.selected = "selected"
      # tmp_opt.attr('selected', true)
      @logo_select.append tmp_opt
      @logo_image.attr("src", tmp_obj.logo)

    type_list = tmp_obj.type_list

    for tmp_type in type_list
      unless tmp_type is emp.EMP_DEFAULT_TYPE
        tmp_view = new CbbEleView(this, tmp_type)
        @type_view[tmp_type]= tmp_view
        @ccb_tree.append tmp_view


  # 按键回调
  do_cancel: ()->
    @fa_view.cancel_add_panel()

  do_ok: ->
    # if @add_flag
    @do_submit_add()
    # else
      # @do_submit_edit()

  do_submit_edit: ->
    console.log "this is  edit!"
    @set_add_flag()


  do_submit_add: ->
    # console.log "do ok"
    if !tmp_name = @package_name.getText()?.trim()
      emp.show_warnning emp.EMP_NO_EMPTY
    tmp_desc = @package_desc.getText()?.trim()
    tmp_logo = null
    if @logo_select.val() isnt emp.EMP_NAME_DEFAULT
      tmp_logo = @logo_select.val()

    type_list = []
    for tmp_type of @type_view
      type_list.push tmp_type
    # console.log type_list
    # console.log @cbb_management.check_exist_cbb()

    if !@add_flag
      tmp_obj = @cbb_management.edit_package(@old_name,
        tmp_name, tmp_desc, tmp_logo, type_list,
        @add_type, @edit_type, @delete_type)
      emp.show_info emp.EMP_EDIT_SUCCESS
      # @do_cancel()
      @fa_view.success_add_panel()
      @initial_input()
    else if @cbb_management.check_exist_cbb()
      emp.show_warnning emp.EMP_EXIST
      return
    else
      tmp_obj = @cbb_management.create_new_package(tmp_name, tmp_desc, tmp_logo, type_list)
      emp.show_info emp.EMP_ADD_SUCCESS
      # @do_cancel()
      @fa_view.success_add_panel()
      @initial_input()

  # 取消对类型编辑
  do_cancel_edit: ->
    @ele_add_panel.show()
    @ele_edit_panel.hide()

  # 完成对类型编辑
  over_edit: ->
    new_name = @package_type_edit.getText()
    # console.log new_name

    old_name = @editing_view.name
    # 如果是新增加的
    if @add_type.filter((tmp_type) -> tmp_type is old_name)
      @add_type = @add_type.filter (tmp_type) -> tmp_type isnt old_name
      @add_type.push new_name

      delete @type_view[old_name]
      @type_view[new_name]=@editing_view
      @editing_view.over_edit_callback new_name
    else

      if !origin_name = @edit_type[@editing_view.name]
        origin_name = @editing_view.name

      if old_name isnt new_name
        # edit_type
        @edit_type[new_name] = origin_name
        delete @type_view[old_name]
        @type_view[new_name]=@editing_view

        # 完成编辑后回调子级
        @editing_view.over_edit_callback new_name

    @editing_view = null
    # console.log @type_view

    # 隐藏编辑窗口
    @do_cancel_edit()

  # 增加新的类型
  do_add_type: ->
    # console.log @type_view add_type
    tmp_text = @package_type_add.getText().trim()
    if !tmp_text
      emp.show_warnning emp.EMP_NO_EMPTY
      return
    if !@type_view[tmp_text]
      tmp_view = new CbbEleView(this, tmp_text)
      @type_view[tmp_text]= tmp_view
      @ccb_tree.append tmp_view
      if @delete_type.filter((tmp_type) -> tmp_type is tmp_text)
        @delete_type = @delete_type.filter (tmp_type) -> tmp_type isnt tmp_text
      else
        @add_type.push tmp_text
    else
      emp.show_warnning emp.EMP_DUPLICATE


  # 选择添加模板集的 logo
  select_logo: (e, element)->
    dialog.showOpenDialog title: 'Select', properties: ['openFile'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        if path_state?.isFile()
          # @cbb_logo.setText logo_path[0]
          @logo_image.attr "src", logo_path[0]
          @logo_image.show()

          tmp_opt = document.createElement 'option'
          tmp_opt.text = path.basename logo_path[0]
          tmp_opt.value = logo_path[0]
          console.log tmp_opt
          tmp_opt.selected = "selected"
          # tmp_opt.attr('selected', true)
          @logo_select.append tmp_opt


# ----------------------------------------------
  # 用于其他方法的回调方法
  remove_td_callback: (name) ->
    console.log @type_view
    console.log name
    delete @type_view[name]

    if old_name = @edit_type[name]
      @delete_type.push old_name
      delete @edit_type[name]
    else if @add_type.filter((tmp_type) -> tmp_type is name)
      @add_type = @add_type.filter (tmp_type) -> tmp_type isnt name

    else
      @delete_type.push name

  #在子级点击 element编辑 时的回调
  do_edit_callback: (name)->
    @ele_add_panel.hide()
    @ele_edit_panel.show()
    @package_type_edit.setText name
    @editing_view = @type_view[name]
    @package_type_edit.focus()
