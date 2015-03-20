{CompositeDisposable} = require 'atom'
# fs = require 'fs'
# path = require 'path'
emp = require '../exports/emp'
CbbPackage = require '../util/emp_cbb_package'

templates_store_path = null

module.exports =
class EmpTemplateManagement
  templates_json: null
  packages:{}
  default_package:null

  constructor: ->
    console.log "constructor"
    if !templates_store_path = atom.project.templates_path
      atom.project.templates_path = path.join __dirname, '../../', emp.EMP_TEMPLATES_PATH
      templates_store_path =atom.project.templates_path
    console.log "stsore_path: #{templates_store_path}"
    emp.mkdir_sync templates_store_path
    @templates_json = path.join templates_store_path, emp.EMP_TEMPLATES_JSON

    if fs.existsSync @templates_json
      json_data = fs.readFileSync @templates_json
      @templates_obj = JSON.parse json_data
      @initial_package()
    else
      @initialize()
    console.log @templates_obj

  initialize: ->
    console.log "initial"
    # console.log "$1"
    @templates_obj = {templates:[], length:0, level:emp.EMP_JSON_ALL}
    @default_package = @create_new_package(emp.EMP_DEFAULT_PACKAGE)
    # @store_package(@default_package)


  # TODO
  initial_package: ->
    console.log "initialize packages"
    @packages = @get_pacakges()
    console.log @packages
    # @default_package = @templates_obj[emp.EMP_DEFAULT_PACKAGE]
    @default_package = new CbbPackage(templates_store_path, @templates_obj[emp.EMP_DEFAULT_PACKAGE])

    # temp_str = JSON.stringify @default_package
    # console.log temp_str

    # if !emp_cbb_types = atom.config.get emp.EMP_CBB_TYPE
    #   atom.config.set emp.EMP_CBB_TYPE, emp.EMP_CPP_TYPE_DEF
    #   emp_cbb_types = emp.EMP_CPP_TYPE_DEF
    # # console.log emp_cbb_types
    # emp_cbb_types.push emp.EMP_DEFAULT_TYPE
    # for tmp_root in tmp_obj.templates
    #   if !tmp_obj.tmp_root
    #     tmp_obj.tmp_root = {}
    #   for cbb_type in emp_cbb_types
    #     tmp_obj.tmp_root[cbb_type] = new Object(length:0)
    #     tmp_obj.tmp_root[cbb_type][emp.EMP_CBB_LIST]=[]
    #   tmp_obj
    # tmp_obj

  # 判断模板集是否存在
  check_exist_cbb: (name) ->
    if @packages[name]
      true
    else
      false

  # 创建新的 package 集
  create_new_package: (name, desc, logo) ->
    if !@packages[name]
      tmp_package = new CbbPackage(templates_store_path, {name:name, desc:desc, logo:logo})
      @store_package(tmp_package)
      tmp_package
    else
      return false

  # 保存创建修改
  store_package:(cbb_package)->
    @packages[cbb_package.name] = cbb_package
    @templates_obj.templates.push cbb_package.name
    @templates_obj[cbb_package.name] = cbb_package.get_info()
    @refresh()

  delete_package: (name)->
    @templates_obj.templates = @templates_obj.templates.filter (ele) -> ele isnt name
    delete @templates_obj[name]
    @refresh()

  refresh: ->
    temp_str = JSON.stringify @templates_obj
    # console.log template_json
    # console.log temp_str
    fs.writeFileSync @templates_json, temp_str

  reread: ->
    if fs.existsSync @templates_json
      json_data = fs.readFileSync @templates_json
      @templates_obj = JSON.parse json_data
    @templates_obj


  add_element: (ccb_obj) ->
    console.log "add_element"
    package_name = ccb_obj.own_package
    if own_pack = @packages[package_name]
      own_pack.add_element ccb_obj
    else
      @default_package.add_element(ccb_obj)
    # @refresh()

  get_pacakges: ->
    packages = @templates_obj.templates

  get_package_obj: (name)->
    @templates_obj[name]



  # add_ccb_with_content: (cbb_obj)->
  #       # {name:cbb_name, version:emp.EMP_DEFAULT_VER, path:null, desc: cbb_desc,
  #       # type: cbb_type, logo:{type:emp.EMP_FILE_TYPE, con:cbb_logo}, html:{type:emp.EMP_CON_TYPE, con:ccb_con}, css:null, lua:null, available:true}
  #   re_arr = @check_cbb_name(cbb_obj.name)
  #
  #   cbb_name = re_arr.name
  #   cbb_root = re_arr.root
  #   cbb_type = cbb_obj.type
  #   template_store_path = path.join templates_store_path, cbb_root, cbb_type, cbb_name
  #   emp.mkdir_sync_safe template_store_path
  #   template_json = path.join template_store_path, emp.EMP_TEMPLATE_JSON
  #
  #   if !@templates_obj?[cbb_root]?[cbb_type]?[cbb_name]
  #     if !@templates_obj
  #       @templates_obj = @new_templates_obj()
  #
  #     @format_template(template_store_path, cbb_obj)
  #
  #     @templates_obj[cbb_root][cbb_type][cbb_name] = cbb_obj
  #     # @templates_obj[cbb_root][cbb_type].length += 1
  #     json_str = JSON.stringify(@templates_obj)
  #     console.log @templates_json
  #     console.log @templates_obj
  #
  #     fs.writeFileSync @templates_json, json_str
  #
  #     temp_str = JSON.stringify cbb_obj
  #     console.log template_json
  #     console.log temp_str
  #     fs.writeFileSync template_json, temp_str
  #
  #
  #
  # format_template: (to_path, temp_obj) ->
  #   if temp_obj.logo
  #     temp_obj.logo = @copy_content_ch(to_path, temp_obj.logo, emp.EMP_LOGO_DIR)
  #   else
  #     temp_obj.logo = path.join __dirname,'../../',emp.EMP_DEFAULT_LOGO
  #   if temp_obj.html?.type is emp.EMP_FILE_TYPE
  #     temp_obj.html.body = @copy_content_ch(to_path, temp_obj.html.body, emp.EMP_HTML_DIR)
  #
  #   if temp_obj.css?.type is emp.EMP_FILE_TYPE
  #     temp_obj.css.body = @copy_content_ch(to_path, temp_obj.css.body,  emp.EMP_CSS_DIR)
  #   if temp_obj.lua?.type is emp.EMP_FILE_TYPE
  #     temp_obj.lua.body = @copy_content_ch(to_path, temp_obj.lua.body, emp.EMP_LUA_DIR)
  #   temp_obj
  #
  # copy_content_ch: (t_path, f_path, add_path="") ->
  #   # console.log t_path
  #   # console.log f_path
  #   to_path = path.join t_path, add_path
  #   # console.log to_path
  #   emp.mkdir_sync(to_path)
  #   f_name = path.basename f_path
  #   f_con = fs.readFileSync f_path
  #   re_file = path.join to_path, f_name
  #   # force copy
  #   fs.writeFileSync re_file, f_con  #unless fs.existsSync(re_file)#, 'utf8'
  #   re_file
  #
  # create_file: (t_path, content, temp_name, add_path="") ->
  #   to_path = path.join t_path, add_path
  #   emp.mkdir_sync(to_path)
  #   re_file = path.join to_path, temp_name
  #   fs.writeFileSync re_file, content
