{CompositeDisposable} = require 'atom'
# fs = require 'fs'
# path = require 'path'
emp = require '../exports/emp'

templates_store_path = null

module.exports =
class EmpTemplateManagement
  templates_json: null

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
    else
      @templates_obj = @new_templates_obj()
    console.log @templates_obj

  initialize: ->
    console.log "initial"

  refresh: ->
    if fs.existsSync @templates_json
      json_data = fs.readFileSync @templates_json
      @templates_obj = JSON.parse json_data
    @templates_obj

  new_templates_obj: ->
    tmp_obj = {templates:{}, length:0}
    if !emp_cbb_types = atom.config.get @EMP_CBB_TYPE
      atom.config.set @EMP_CBB_TYPE, @EMP_CPP_TYPE_DEF
      emp_cbb_types = @EMP_CPP_TYPE_DEF
    emp_cbb_types.push @EMP_DEFAULT_TYPE

    for cbb_type in emp_cbb_types
      tmp_obj.templates[cbb_type] = new Object(length:0)
    tmp_obj



  add_ccb_with_content: (ccb_obj)->
        # {name:cbb_name, version:emp.EMP_DEFAULT_VER, path:null, desc: cbb_desc,
        # type: cbb_type, logo:{type:emp.EMP_FILE_TYPE, con:cbb_logo}, html:{type:emp.EMP_CON_TYPE, con:ccb_con}, css:null, lua:null, available:true}

    template_store_path = path.join templates_store_path, ccb_obj.type, ccb_obj.name
    emp.mkdir_sync_safe template_store_path
    template_json = path.join template_store_path, emp.EMP_TEMPLATE_JSON
    
    if !@templates_obj?.templates[cbb_type][cbb_name]
      if !@templates_obj
        @templates_obj = @new_templates_obj()

      @format_template(template_store_path, ccb_obj)

      @templates_obj.templates[ccb_obj.type][ccb_obj.name] = ccb_obj
      @templates_obj.templates[ccb_obj.type].length += 1
      json_str = JSON.stringify(@templates_obj)
      console.log @templates_json
      console.log @templates_obj

      fs.writeFileSync @templates_json, json_str

      temp_str = JSON.stringify ccb_obj
      console.log template_json
      console.log temp_str
      fs.writeFileSync template_json, temp_str



  format_template: (to_path, temp_obj) ->
    if temp_obj.logo
      temp_obj.logo = @copy_content_ch(to_path, temp_obj.logo, emp.EMP_LOGO_DIR)
    else
      temp_obj.logo = path.join __dirname,'../../',emp.EMP_DEFAULT_LOGO
    if temp_obj.html_obj.type is emp.EMP_FILE_TYPE
      temp_obj.html_obj.body = @copy_content_ch(to_path, temp_obj.html_obj.body, emp.EMP_HTML_DIR)

    if temp_obj.css_obj.type is emp.EMP_FILE_TYPE
      temp_obj.css_obj.body = @copy_content_ch(to_path, temp_obj.css_obj.body,  emp.EMP_CSS_DIR)
    if temp_obj.lua_obj.type is emp.EMP_FILE_TYPE
      temp_obj.lua_obj.body = @copy_content_ch(to_path, temp_obj.lua_obj.body, emp.EMP_LUA_DIR)
    temp_obj

  copy_content_ch: (t_path, f_path, add_path="") ->
    # console.log t_path
    # console.log f_path
    to_path = path.join t_path, add_path
    # console.log to_path
    emp.mkdir_sync(to_path)
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    re_file = path.join to_path, f_name
    # force copy
    fs.writeFileSync re_file, f_con  #unless fs.existsSync(re_file)#, 'utf8'
    re_file

  create_file: (t_path, content, temp_name, add_path="") ->
    to_path = path.join t_path, add_path
    emp.mkdir_sync(to_path)
    re_file = path.join to_path, temp_name
    fs.writeFileSync re_file, content
