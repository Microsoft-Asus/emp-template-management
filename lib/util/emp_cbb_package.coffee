emp = require '../exports/emp'

module.exports =
class EmpCbbPackage
  templates_json: null
  name:null
  logo:null
  type_list: []
  package_path: null
  template_json: null
  obj_json:null



  constructor: (@store_path, @name, @obj_json)->
    console.log "constructor a new emp root"

    @type_list.push emp.EMP_DEFAULT_TYPE
    @package_path = path.join @store_path, @name
    emp.mkdir_sync_safe @package_path
    emp.mkdir_sync_safe path.join(@package_path, emp.EMP_DEFAULT_TYPE)
    @template_json = path.join @package_path, emp.EMP_TEMPLATE_JSON
    if !@obj_json
      @obj_json = {name:@name, type:@type_list, path:@package_path, logo:@logo}
      @obj_json[emp.EMP_DEFAULT_TYPE] = {}


  refresh: ->
    temp_str = JSON.stringify @get_json()
    console.log @template_json
    console.log temp_str
    fs.writeFileSync @template_json, temp_str



  # 包信息
  get_info: () ->
    console.log "package info"
    {name:@name, type:@type_list, path:@package_path, logo:@logo}

  get_json: () ->
    if !@obj_json
      @obj_json = {name:@name, type:@type_list, path:@package_path, logo:@logo}
    else
      @obj_json


  # 添加子元素
  add_element: (ccb_obj) ->
    if @obj_json[ccb_obj.type]
      # TODO 如果已存在添加提醒
      ccb_obj.create(@package_path, @name)
      ccb_info = ccb_obj.get_info()
      @obj_json[ccb_obj.type][ccb_info.name] = ccb_info

    @refresh()
