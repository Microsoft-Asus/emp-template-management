emp = require '../exports/emp'

module.exports =
class EmpCbbEle

  name:null
  ver: emp.EMP_DEFAULT_VER
  desc: null
  type: emp.EMP_DEFAULT_TYPE
  own_package: emp.EMP_DEFAULT_PACKAGE
  logo: null
  html: null
  css: null
  lua: null
  available: true
  detail_image: []
  package_path: null
  element_path: null
  ele_json:null
  lv:emp.EMP_JSON_ELE

  constructor: (@name, @desc, @logo, @type, tmp_pack)->
    console.log "constructor a new emp cbb element"
    # if !tmp_pack
    #   @check_cbb_name()
    # else
    @own_package = tmp_pack

  refresh: ->
    temp_str = JSON.stringify @get_json()
    fs.writeFileSync @template_json, temp_str

  # element information
  get_info: ->
    {name:@name, version:@ver, element_path:@element_path, desc: @desc,
    type: @type, logo:@logo}

  # element json content
  get_json: ->
    if !@ele_json
      @ele_json = {name:@name, version:@ver, desc: @desc,
      type: @type, logo:@logo, html:@html, css:@css, lua:@css,
      available:@available, own_package: @own_package,
      images:@detail_image, package_path:@package_path,
      element_path:@element_path, level:@lv}
    else
      @ele_json

  #  判断控件名称, 如果控件名称为 atom textarea, 则第一个空格前为大分类
  #  前提是大分类已经存在
  check_cbb_name: () ->
    re_cbb = @name.split ' '
    re_len = re_cbb.length
    if re_len > 1
      @own_package = re_cbb[0]
      re_cbb.shift()
      @name = re_cbb.join ' '
    # {root:root_name, name:re_name}



  create: (@package_path, @own_package)->
        # {name:cbb_name, version:emp.EMP_DEFAULT_VER, path:null, desc: cbb_desc,
        # type: cbb_type, logo:{type:emp.EMP_FILE_TYPE, con:cbb_logo}, html:{type:emp.EMP_CON_TYPE, con:ccb_con}, css:null, lua:null, available:true}

    @element_path = path.join @package_path, @type, @name
    emp.mkdir_sync_safe @element_path
    @template_json = path.join @element_path, emp.EMP_TEMPLATE_JSON

    # if !@templates_obj?[cbb_root]?[cbb_type]?[cbb_name]
    #   if !@templates_obj
    #     @templates_obj = @new_templates_obj()

    @format_template(@element_path)

    # @templates_obj[cbb_root][cbb_type][cbb_name] = cbb_obj
    # @templates_obj[cbb_root][cbb_type].length += 1
    # json_str = JSON.stringify(@templates_obj)
    # console.log @templates_json
    # console.log @templates_obj


    @refresh()

  format_template: (to_path) ->
    if @logo
      @logo = @copy_content_ch(to_path, @logo, emp.EMP_LOGO_DIR)
    else
      @logo = path.join __dirname,'../../',emp.EMP_DEFAULT_LOGO
    if @html?.type is emp.EMP_FILE_TYPE
      @html.body = @copy_content_ch(to_path, @html.body, emp.EMP_HTML_DIR)

    if @css?.type is emp.EMP_FILE_TYPE
      @css.body = @copy_content_ch(to_path, @css.body,  emp.EMP_CSS_DIR)
    if @lua?.type is emp.EMP_FILE_TYPE
      @lua.body = @copy_content_ch(to_path, @lua.body, emp.EMP_LUA_DIR)

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

  set_con: (tmp_con, ctype) ->
    tmp_obj = @new_con_obj(tmp_con)
    switch ctype
      when emp.EMP_QHTML then @html = tmp_obj
      when emp.EMP_QCSS then @css = tmp_obj
      when emp.EMP_QLUA then @lua = tmp_obj

  set_file: (tmp_file, ctype) ->
    tmp_obj = @new_file_obj(tmp_file)
    switch ctype
      when emp.EMP_QHTML then @html = tmp_obj
      when emp.EMP_QCSS then @css = tmp_obj
      when emp.EMP_QLUA then @lua = tmp_obj

  new_con_obj:(tmp_con) ->
    {type:emp.EMP_CON_TYPE, body:tmp_con}

  new_file_obj:(tmp_file) ->
    {type:emp.EMP_FILE_TYPE, body:tmp_file}
