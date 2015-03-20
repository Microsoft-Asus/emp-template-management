emp = require '../exports/emp'

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
    console.log "constructor a new emp root"

    @name = @obj_json.name
    @logo = @obj_json.logo
    @desc = @obj_json.desc
    if !@type_list = @obj_json.type
      @type_list = []
      @type_list.push emp.EMP_DEFAULT_TYPE
    if !@package_path = @obj_json.path
      @package_path = path.join @store_path, @name

    emp.mkdir_sync_safe @package_path
    emp.mkdir_sync_safe path.join(@package_path, emp.EMP_DEFAULT_TYPE)
    @template_json = path.join @package_path, emp.EMP_TEMPLATE_JSON
    if fs.existsSync @template_json
      json_con = fs.readFileSync @template_json
      @obj_json = @templates_obj = JSON.parse json_con
    # console.log @obj_json
    if !@obj_json[emp.EMP_DEFAULT_TYPE]
      @obj_json[emp.EMP_DEFAULT_TYPE] = {}
    # console.log @obj_json

  refresh: ->
    # console.log @get_json()
    temp_str = JSON.stringify @get_json()
    # console.log @template_json
    # console.log temp_str
    fs.writeFileSync @template_json, temp_str

  # 包信息
  get_info: () ->
    console.log "package info"
    {name:@name, type:@type_list, path:@package_path, logo:@logo, desc:@desc, level:@lv}

  get_json: () ->
    if !@obj_json
      @obj_json = @get_info()
    else
      @obj_json


  # 添加子元素
  add_element: (ccb_obj) ->
    console.log "add_element"
    console.log  @obj_json
    console.log ccb_obj
    # TODO 如果已存在添加提醒
    if !@obj_json[ccb_obj.type]
      ccb_obj.type = emp.EMP_DEFAULT_TYPE

    ccb_obj.create(@package_path, @name)
    ccb_info = ccb_obj.get_info()
    @obj_json[ccb_obj.type][ccb_info.name] = ccb_info
    @refresh()
