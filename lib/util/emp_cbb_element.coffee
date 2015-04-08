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
  detail_image: null
  package_path: null
  element_path: null
  ele_json:null
  lv:emp.EMP_JSON_ELE

  constructor: (@name, @desc, @logo, @type, tmp_pack, @src_list, @detail_image)->
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
    {name:@name, version:@ver, element_path:@element_path_rel, desc: @desc,
    type: @type, logo:@logo, detail:@detail_image}

  # element json content
  get_json: ->
    if !@ele_json
      @ele_json = {name:@name, version:@ver, desc: @desc,
      type: @type, logo:@logo, html:@html, css:@css, lua:@css,
      available:@available, own_package: @own_package,
      source:@src_list_rel,detail:@detail_image,
      element_path:@element_path_rel, level:@lv}
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
    @element_path_rel = path.join @own_package, @type, @name
    emp.mkdir_sync_safe @element_path
    @template_json = path.join @element_path, emp.EMP_TEMPLATE_JSON
    @template_json_rel = path.join @element_path_rel, emp.EMP_TEMPLATE_JSON

    # if !@templates_obj?[cbb_root]?[cbb_type]?[cbb_name]
    #   if !@templates_obj
    #     @templates_obj = @new_templates_obj()

    @format_template()

    # @templates_obj[cbb_root][cbb_type][cbb_name] = cbb_obj
    # @templates_obj[cbb_root][cbb_type].length += 1
    # json_str = JSON.stringify(@templates_obj)
    # console.log @templates_json
    # console.log @templates_obj
    @refresh()

  format_template: (to_path) ->
    if @logo
      @logo = @copy_content_ch @logo
    if @html?.type is emp.EMP_FILE_TYPE
      @html.body = @copy_content_ch @html.body

    if @css?.type is emp.EMP_FILE_TYPE
      @css.body = @copy_content_ch @css.body
    if @lua?.type is emp.EMP_FILE_TYPE
      @lua.body = @copy_content_ch @lua.body

    if @detail_image
      @detail_image = @copy_content_ch @detail_image

    @src_list_rel = []
    if @src_list
      for tmp_file in @src_list
        @src_list_rel.push @copy_content_ch(tmp_file, emp.EMP_IMG_DIR)

    # if @logo
    #   @logo = @copy_content_ch(@logo, emp.EMP_LOGO_DIR)
    # if @html?.type is emp.EMP_FILE_TYPE
    #   @html.body = @copy_content_ch(@html.body, emp.EMP_HTML_DIR)
    #
    # if @css?.type is emp.EMP_FILE_TYPE
    #   @css.body = @copy_content_ch(@css.body,  emp.EMP_CSS_DIR)
    # if @lua?.type is emp.EMP_FILE_TYPE
    #   @lua.body = @copy_content_ch(@lua.body, emp.EMP_LUA_DIR)

  copy_content_ch: (f_path, add_path="") ->
    # console.log t_path
    # console.log f_path
    to_path = path.join @element_path, add_path
    to_path_rel = path.join @element_path_rel, add_path
    # console.log to_path
    emp.mkdir_sync(to_path)
    f_name = path.basename f_path
    f_con = fs.readFileSync f_path
    re_file = path.join to_path, f_name
    re_file_rel = path.join to_path_rel, f_name
    # force copy
    fs.writeFileSync re_file, f_con  #unless fs.existsSync(re_file)#, 'utf8'
    re_file_rel

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
