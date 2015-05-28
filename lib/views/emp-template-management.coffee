{CompositeDisposable} = require 'atom'
# fs = require 'fs'
# path = require 'path'
emp = require '../exports/emp'
fs_plus = require 'fs-plus'
CbbPackage = require '../util/emp_cbb_package'
fs = require 'fs'
path = require 'path'

templates_store_path = null

module.exports =
class EmpTemplateManagement
  templates_json: null
  packages:{}
  # package_list:[]
  default_package:null

  constructor: ->
    # console.log "constructor"

    # atom.project.package_path = path.join  atom.packages.resolvePackagePath(emp.PACKAGE_NAME)
    # console.log atom.config.get emp.EMP_TEMPLATES_KEY
    # console.log atom.project.templates_path
    @do_initial()

  do_initial: ->
    # if !templates_store_path = atom.project.templates_path
    atom.project.templates_path = atom.config.get emp.EMP_TEMPLATES_DEFAULT_KEY
      # atom.project.templates_path = path.join  atom.packages.resolvePackagePath(emp.PACKAGE_NAME) , emp.EMP_TEMPLATES_PATH
    templates_store_path = atom.project.templates_path
    # console.log "stsore_path: #{templates_store_path}"
    emp.mkdir_sync templates_store_path
    @templates_json = path.join templates_store_path, emp.EMP_TEMPLATE_JSON
    @packages = {}
    if fs.existsSync @templates_json
      json_data = fs.readFileSync @templates_json
      @templates_obj = JSON.parse json_data
      @initial_package()
    else
      @initialize_default()
    # console.log @templates_obj

  initialize_default: ->
    console.log "initial"
    # console.log "$1"
    @templates_obj = {templates:[], length:0,
    level:emp.EMP_JSON_ALL, atom_tool_setting:@initial_tool_setting()}
    @default_package = @create_new_package(emp.EMP_DEFAULT_PACKAGE)
    # @store_package(@default_package)


  # TODO
  initial_package: ->
    console.log "initialize packages"
    package_list = @get_pacakges_list()
    # console.log package_list
    # @default_package = @templates_obj[emp.EMP_DEFAULT_PACKAGE]
    @default_package = new CbbPackage(templates_store_path, @templates_obj[emp.EMP_DEFAULT_PACKAGE])
    @packages[emp.EMP_DEFAULT_PACKAGE] = @default_package
    for tmp_package in package_list
      unless tmp_package is emp.EMP_DEFAULT_PACKAGE
        @packages[tmp_package] = new CbbPackage templates_store_path,  @templates_obj[tmp_package]


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
  create_new_package: (name, desc, logo, type) ->
    # console.log name
    # console.log @packages
    if !@packages[name]
      tmp_package = new CbbPackage(templates_store_path, {name:name, desc:desc, logo:logo, type:type})
      @store_package(tmp_package)
      tmp_package
    else
      return false

  edit_package: (old_name, name, desc, logo, type, add_type, edit_type, del_type) ->
    # console.log @packages
    tmp_package = @packages[old_name]
    delete @packages[old_name]
    @templates_obj.templates = @templates_obj.templates.filter (tmp_pack) -> tmp_pack isnt old_name
    if tmp_package
      tmp_package.edit_detail({name:name, desc:desc, logo:logo, type:type, add_type:add_type,edit_type:edit_type, del_type:del_type})
      @store_package(tmp_package)
      tmp_package
    else
      return false

  refresh_package: (cbb_package)->

    @packages[cbb_package.name] = cbb_package
    # @templates_obj.templates.push cbb_package.name
    @templates_obj[cbb_package.name] = cbb_package.get_info()
    @refresh()

  # 保存创建修改
  store_package:(cbb_package)->
    @packages[cbb_package.name] = cbb_package
    @templates_obj.templates.push cbb_package.name
    @templates_obj[cbb_package.name] = cbb_package.get_info()
    @refresh()

  # 删除模板集得相关描述
  delete_package: (name)->
    # console.log name
    @templates_obj.templates = @templates_obj.templates.filter (ele) -> ele isnt name
    delete @packages[name]
    delete @templates_obj[name]
    @refresh()

  # 删除模板集的所有内容
  delete_package_detail:(name) ->
    tmp_obj = @templates_obj[name]
    tmp_dir = path.join templates_store_path, name
    fs_plus.removeSync(tmp_dir) unless !fs.existsSync tmp_dir
    @delete_package(name)

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


  add_element: (cbb_obj) ->
    # console.log "add_element"
    # console.log cbb_obj
    package_name = cbb_obj.own_package
    if own_pack = @packages[package_name]
      own_pack.add_element cbb_obj
    else
      @default_package.add_element(cbb_obj)

  edit_element: (ccb_obj, old_obj) ->
    # console.log "add_element"
    package_name = ccb_obj.own_package
    if own_pack = @packages[package_name]
      own_pack.edit_element ccb_obj, old_obj
    else
      @default_package.edit_element ccb_obj, old_obj
    # @refresh()

  get_pacakge: (name)->
    @packages[name]

  get_pacakges: ->
    @packages

  get_pacakges_list: ->
    @templates_obj.templates

  get_package_obj: (name)->
    @templates_obj[name]


  initial_tool_setting: ->
    tool_list = {1:{pack_name:emp.EMP_DEFAULT_PACKAGE, type_name:emp.EMP_DEFAULT_TYPE}}
    return tool_list

  get_tool_detail: () ->
    tool_list = @templates_obj.atom_tool_setting
    tool_list ?= @initial_tool_setting()

  refresh_tool_detail: (new_setting) ->
    # console.log "do refresh"
    @templates_obj.atom_tool_setting = new_setting
    @refresh()

  merge_package: (tmp_obj, tmp_entries)->
    tmp_pack_name = tmp_obj.pack
    tmp_obj = @get_pacakge(tmp_pack_name)
    tmp_obj ?= @create_new_package(tmp_pack_name, null, null, null)
    tmp_type_list = tmp_obj.add_type(tmp_obj.type)
    for name, obj of tmp_entries
      # console.log name
      tmp_data = obj.getData().toString('utf8')
      tmp_file_path = path.join templates_store_path,tmp_pack_name, name
      fs.writeFile tmp_file_path, tmp_data, (err) ->
         unless !err
           console.error err




  # merge_package1: (fa_path, tmp_obj, tmp_entries) ->
  #
  #   templates = tmp_obj.templates
  #   ori_templates = @get_pacakges_list()
  #   # @templates_obj
  #   templates.forEach (pack) ->
  #     if ori_templates.indexOf pack
  #       console.log "do"
  #
  #     else
  #       @templates_obj.templates.push pack
  #       @templates_obj[pack] = templates[pack]
  #       # @packages[pack] = new CbbPackage templates_store_path,  templates[pack]
  #       # @packages[pack].refresh()
  #       @copy_pack(templates[pack], fa_path, tmp_entries)
  #       @packages[pack] = new CbbPackage templates_store_path,  templates[pack]
  #
  #
  # copy_pack: (pack_obj, fa_path, tmp_entries) ->
  #   pack_path = path.join templates_store_path, pack_obj.name
  #   emp.mkdir_sync pack_path
  #   fa_path = path.join fa_path, pack_obj.name
  #   tmp_key = path.join fa_path, emp.EMP_TEMPLATE_JSON
  #
  #   store_path = path.join pack_path, emp.EMP_TEMPLATE_JSON
  #
  #
  #
  #   for tmp_type in pack_obj.type
  #     emp.mkdir_sync path.join(pack_path, tmp_type)


  #
  # merge_file: (fa_path, tmp_obj, tmp_entries) ->
  #
  #   if fa_path is emp.EMP_TEMPLATES_PATH
  #     console.log " ----"
  #   else
  #
  #
  #
  #
  #   templates = tmp_obj.templates
  #   ori_templates = @get_pacakges_list()



    #
    # @packages[cbb_package.name] = cbb_package
    # @templates_obj.templates.push cbb_package.name
    # @templates_obj[cbb_package.name] = cbb_package.get_info()


    # return tool_list #[count]
