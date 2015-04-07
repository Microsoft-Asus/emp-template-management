emp = require '../exports/emp'
fs_plus = require 'fs-plus'

module.exports =
class EmpCbbPackage
  name:null
  logo:null
  desc:null
  type_list: []
  package_path: null
  template_json: null
  obj_json:null
  lv: emp.EMP_JSON_PACK

  constructor: (@store_path, @obj_json) ->
    # console.log "constructor a new emp root"
    # console.log @obj_json
    @cbb_management = atom.project.cbb_management
    @name = @obj_json.name
    @logo = @obj_json.logo
    @desc = @obj_json.desc
    if !@type_list = @obj_json.type
      @type_list = []
    # console.log @type_list
    if !(@type_list.indexOf(emp.EMP_DEFAULT_TYPE)+1)
      # console.log "push"
      @type_list.push emp.EMP_DEFAULT_TYPE
    if !@package_path = @obj_json.path
      @package_path = path.join @store_path, @name

    emp.mkdir_sync_safe @package_path
    for tmp_dir in @type_list
      emp.mkdir_sync_safe path.join(@package_path, tmp_dir)
    @template_json = path.join @package_path, emp.EMP_TEMPLATE_JSON
    if fs.existsSync @template_json
      json_con = fs.readFileSync @template_json
      @obj_json = JSON.parse json_con
    # console.log @obj_json
    if !@obj_json[emp.EMP_DEFAULT_TYPE]
      @obj_json[emp.EMP_DEFAULT_TYPE] = {}
    # console.log @obj_json

  refresh: ->
    # console.log @get_json()
    temp_str = JSON.stringify @get_json()
    fs.writeFileSync @template_json, temp_str

  # 包信息
  get_info: () ->
    # console.log "package info"
    {name:@name, type:@type_list, path:@package_path, logo:@logo, desc:@desc, level:@lv}

  get_json: () ->
    if !@obj_json
      @obj_json = @get_info()
    else
      @obj_json

  get_element: (tmp_type)->
    return @obj_json[tmp_type]

  get_type: ->
    return @type_list

  add_type: (tmp_type) ->
    if !(@type_list.indexOf(tmp_type)+1)
      @type_list.push tmp_type
      @obj_json.type.push tmp_type
      emp.mkdir_sync_safe path.join(@package_path, tmp_type)
      if fs.existsSync @template_json
        @refresh()
      @cbb_management.refresh_package(this)

  # 添加子元素
  add_element: (ccb_obj) ->
    console.log "add_element"
    # console.log  @obj_json
    # console.log ccb_obj
    # TODO 如果已存在添加提醒
    if !(@obj_json.type.indexOf(ccb_obj.type)+1)
      ccb_obj.type = emp.EMP_DEFAULT_TYPE
    else if !@obj_json[ccb_obj.type]
      @obj_json[ccb_obj.type] = {}

    ccb_obj.create(@package_path, @name)
    ccb_info = ccb_obj.get_info()
    @obj_json[ccb_obj.type][ccb_info.name] = ccb_info
    @refresh()

  edit_detail: (new_obj)->

    @logo = new_obj.logo
    @desc = new_obj.desc

    @obj_json.logo = @logo
    @obj_json.desc = @desc
    @obj_json.type = new_obj.type
    @type_list = new_obj.type

    if @name isnt new_obj.name
      @name = new_obj.name
      @obj_json.name = @name

      if fs.existsSync @package_path
        new_package_path = path.join @store_path, @name
        fs_plus.move @package_path,new_package_path
        @package_path = new_package_path

    for tmp_type in new_obj.add_type
      tmp_type_dir = path.join @package_path,tmp_type
      fs.exists tmp_type_dir, (exists) ->
        if !exists
          fs.mkdir tmp_type_dir, (err) ->
            console.log err unless !err

    for tmp_type in new_obj.del_type
      tmp_type_dir = path.join @package_path,tmp_type
      fs.exists tmp_type_dir, (exists) ->
        if exists
          fs_plus.remove tmp_type_dir,(err) ->
            console.log err unless !err

    for new_type, old_type in new_obj.edit_type
      tmp_old_dir = path.join @package_path,old_type
      fs.exists tmp_old_dir, (exists) ->
        tmp_new_type = path.join @package_path,new_type
        if exists
          fs_plus.move tmp_old_dir,tmp_new_type
        else
          fs.mkdir tmp_new_type, (err) ->
            console.log err unless !err

    if fs.existsSync @template_json
      @refresh()

  # 删除模板集得相关描述
  delete_element: (name, type)->
    # console.log name
    delete @obj_json[type][name]
    @refresh()

  # 删除模板元素的所有内容
  delete_element_detail:(name, type) ->
    # console.log name
    ele_obj = @obj_json[type][name]
    tmp_dir = ele_obj.element_path
    fs_plus.removeSync(tmp_dir) unless !fs.existsSync tmp_dir
    @delete_element(name, type)
    # @delete_package(name)
