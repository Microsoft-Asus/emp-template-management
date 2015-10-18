#cs macro defined
fs = require 'fs'
path = require 'path'
os = require 'os'
remote = require 'remote'
dialog = remote.require 'dialog'

module.exports =

  #  在 Cnfig 中保存数据
  EMP_APP_EXPORT_UI_PATH :'emp-template-management.Store-UI-Snippet-Export-Path'
  EMP_APP_IMPORT_UI_PATH :'emp-template-management.Store-UI-Snippet-Import-Path'
  EMP_APP_STORE_UI_PATH :'emp-template-management.Store-UI-Snippet-Path'

  PACKAGE_NAME:"emp-template-management"
  TOOL_FIRST:"1"
  TOOL_SECOND: "2"
  TOOL_THIRD: "3"
  TOOL_FOURTH: "4"

  # 默认的 snippet 保存导出/导入路径
  DEFAULT_SNIPPET_EXPORT_PATH:'snippets'
  DEFAULT_CSS_EXPORT_PATH:'css'

  # 默认的 source 类型
  DEFAULT_SNIPPET_SOURE_TYPE:'.source.xhtml'
  DEFAULT_SNIPPET_FILE_EXT: '.cson'
  DEFAULT_CSS_FILE_EXT: '.css'
  JSON_SNIPPET_FILE_EXT: '.json'

  # 默认代码段传参类型
  DEFAULT_SNIPPET_TYPE: '.emp.parameter'
  DEFAULT_SNIPPET_TYPE_KEY: 'type_list'

  EMP_DEFAULT_SNIPPETS:["emp-lua.cson", "eui.cson"]

  EMP_ALL_TYPE : "All Type"



  EMP_HTML_GRAMMAR:"source.xhtml"
  EMP_CSS_GRAMMAR:"source.css"
  EMP_LUA_GRAMMAR:"source.lua"

  # 创建模板临时文件路径
  EMP_TMP_TEMP_FILE_PATH:'tmp_file'
  EMP_TMP_TEMP_HTML:'tmp.xhtml'
  EMP_TMP_TEMP_CSS:'tmp.css'
  EMP_TMP_TEMP_LUA:'tmp.lua'
  EMP_TMP_TEMP_CSON:'tmp.cson'
  EMP_GRAMMAR_XHTML:'Emp View'
  EMP_GRAMMAR_CSS:'CSS'
  EMP_GRAMMAR_LUA:'LUA'

  EMP_OFF_CHA_LV_PATH:"channels"
  EMP_OFF_COM_LV_PATH:"common"
  EMP_OFF_ROOT_LV_PATH:"resource_dev"

  # 描述文件类型
  EMP_JSON_ALL:'0'
  EMP_JSON_PACK:'1'
  EMP_JSON_TYPE:'2'
  EMP_JSON_ELE:'3'

  # 默认的描述
  EMP_DEF_DESC: "这是一段默认的描述."
  EMP_DEF_PAC_DESC: "该模板集是默认的模板集."

  # 默认的警示
  EMP_NO_EMPTY: "该输入项不能为空!"
  EMP_DUPLICATE: "该输入项已经存在!"
  EMP_EXIST: "该添加项已经存在!"
  EMP_ADD_SUCCESS: "添加成功!"
  EMP_EDIT_SUCCESS: "编辑成功!"
  EMP_SAVE_SUCCESS: "保存成功!"
  EMP_EXP_SUCCESS: "导出成功!"
  EMP_IMPORT_SUCCESS: "导入成功!"
  EMP_NO_EMPTY_PATH: "输入地址项不能为空!"

  EMP_SRC_ELE_VIEW:"1"
  EMP_DETAIL_ELE_VIEW:"2"

  ENTERKEY:13
  ESCAPEKEY:27

  EMP_TEMP_URI : 'emp://template_management_wizard'
  EMP_KEYMAP_MAN : 'emp://keymaps_man'

  LOGO_IMAGE_SIZE : '48px'
  LOGO_IMAGE_BIG_SIZE : '156px'

  KEYMAP_WIZARD_VIEW: 'EmpKeymapsView'
  TEMP_WIZARD_VIEW: 'EmpTemplateView'
  DEFAULT_PANEL: 'OverView'

  EMP_TEMPLATE:'Template'
  EMP_UPLOAD:'Add Template'
  EMP_DOWNLOAD:'Download'
  EMP_Setting:'Cbb Tool Setting'
  EMP_SHOW_UI_LIB:'Show UI Snippets'
  EMP_UI_LIB:'Add UI Snippets'
  EMP_EXI:'Export/Inport'
  EMP_CONFIG:'Config'

  EMP_SNIPPET_DETAIL:'show_snippet_detail'

  EMP_CCB_PACK_DETAIL:'Cbb_pack_detail'
  EMP_CBB_ELE_DETAIL:'Cbb_ele_detail'

  EMP_NAME_DEFAULT: 'eui'
  EMP_DEFAULT_VER: '0.1'
  EMP_TEMPLATES_PATH:'templates'
  EMP_TEMPLATES_JSON: 'templates.json'
  EMP_TEMPLATE_JSON: 'template.json'
  EMP_ZIP_DETAIL: 'pack_detail.json'
  EMP_TEMPLATES_DEFAULT_KEY: 'emp-template-management.defaultStorePath'
  # EMP_TEMPLATES_USER_KEY: 'emp-template-management.userStorePath'


  EMP_LOGO_DIR:"logo"
  EMP_IMG_DIR:"image"
  EMP_HTML_DIR:"xhtml"
  EMP_CSS_DIR:"css"
  EMP_LUA_DIR:"lua"
  EMP_IMGS_DIR:"images"

  COMMON_DIR_LIST :["images", "css", "lua", "xhtml","channels"]
  OFF_CHA_DIR_LIST : ["xhtml", "css", "lua", "images", "json"]
  OFF_CHA_PLT_LIST:["wp", "iphone", "android", "common"]

  # 存储类型
  EMP_CON_TYPE: '0'
  EMP_FILE_TYPE: '1'

  EMP_DEFAULT_HTML_TEMP: "default.xhtml"
  EMP_DEFAULT_CSS_TEMP: "default.css"
  EMP_DEFAULT_LUA_TEMP: "default.lua"
  EMP_DEFAULT_LOGO: "images/logo/logo_s.png"


  # 代码根目录
  EMP_DEFAULT_PACKAGE: "default"
  # 代码类型
  EMP_DEFAULT_TYPE: "componment"

  # 代码列表
  EMP_CBB_LIST: "list_info"

  # 快速添加 报文类型
  EMP_QHTML:'0'
  EMP_QCSS:'1'
  EMP_QLUA:'2'

  # config key
  EMP_CBB_TYPE: 'emp-template-management.cbb_type'
  #保存模板添加过程中选中的 package
  EMP_ADD_TEMP_STORE_PACK:'emp-template-management.cbb_add_temp_pack'
  EMP_ADD_TEMP_STORE_TYPE:'emp-template-management.cbb_add_temp_type'


  # config value
  EMP_CPP_TYPE_DEF:[]

  # EMP APP Common Resource Path
  EMP_RESOURCE_PATH: "public/www/resource_dev/common/"

  EMP_TEMPLATE_CSS_NAME_HEAD : "ert_ui_"
  EMP_TEMPLATE_CSS_HEAD: "/* Copyright (c) 2015-2016 Beijing RYTong Information Technologies, Ltd.\r\n
  All rights reserved.\r\n
  No part of this source code may be copied, used, or modified\r\n
  without the express written consent of RYTong. \r\n
  This file is created by EMP Template Management.\r\n*/\r\n"

  STATIC_UI_CSS_TEMPLATE_DEST_PATH:"public/www/resource_dev/common/css/"



  new_templates_obj: ->
    tmp_obj = {templates:{}, length:0}
    if !emp_cbb_types = atom.config.get @EMP_CBB_TYPE
      atom.config.set @EMP_CBB_TYPE, @EMP_CPP_TYPE_DEF
      emp_cbb_types = @EMP_CPP_TYPE_DEF
    emp_cbb_types.push @EMP_DEFAULT_TYPE

    for cbb_type in emp_cbb_types
      tmp_obj.templates[cbb_type] = new Object(length:0)
    tmp_obj

  get_default_logo: ->
    path.join __dirname,'..', '..', @EMP_DEFAULT_LOGO

  get_default_path: () ->
    path.join atom.packages.resolvePackagePath(this.PACKAGE_NAME), this.EMP_TEMPLATES_PATH

  DEFAULT_SNIPPET_STORE_PATH:"store_snippet"
  get_default_snippet_path: () ->
    path.join atom.packages.resolvePackagePath(this.PACKAGE_NAME),this.DEFAULT_SNIPPET_STORE_PATH

  get_snippet_load_path: () ->
    path.join atom.packages.resolvePackagePath(this.PACKAGE_NAME),this.DEFAULT_SNIPPET_EXPORT_PATH

  get_pack_path: () ->
    path.join atom.packages.resolvePackagePath(this.PACKAGE_NAME)

  create_editor:(tmp_file_path, tmp_grammar, callback, content) ->
    changeFocus = true
    tmp_editor = atom.workspace.open(tmp_file_path, { changeFocus }).then (tmp_editor) =>
      gramers = @getGrammars(tmp_grammar)
      # console.log content
      unless content is undefined
        tmp_editor.setText(content) #unless !content
      tmp_editor.setGrammar(gramers[0]) unless gramers[0] is undefined
      callback(tmp_editor)

  # set the opened editor grammar, default is HTML
  getGrammars: (grammar_name)->
    grammars = atom.grammars.getGrammars().filter (grammar) ->
      (grammar isnt atom.grammars.nullGrammar) and
      grammar.name is grammar_name
    grammars


  get_project_path: ->
    project_path_list = atom.project.getPaths()
    project_path = project_path_list[0]
    editor = atom.workspace.getActiveTextEditor()
    if editor
      # 判断 project 有多个的情况
      efile_path = editor.getPath?()
      if project_path_list.length > 1
        for tmp_path in project_path_list
          relate_path = path.relative tmp_path, efile_path
          if relate_path.match(/^\.\..*/ig) isnt null
            project_path = tmp_path
            break
    project_path


module.exports.mk_node_name = (node_name="") ->
  default_name = " -sname "
  tmp_re = node_name.split("@")
  def_node_name = "atom_js" + Math.round(Math.random()*100)
  def_host = " "
  if tmp_re.length >1
    # console.log "node name has HOST~"
    if valid_ip(tmp_re[1])
      default_name = " -name "
      def_host = get_def_host()
      def_node_name = def_node_name + "@" +def_host
  # console.log def_host
  re_name = default_name + def_node_name
  {name:def_node_name, node_name: re_name}

get_def_host = ->
  add_list = os.networkInterfaces()
  tmp_address = ''
  for key,val of add_list
    # console.log val
    for tmp_obj in val
      if !tmp_obj.internal and tmp_obj.family is 'IPv4'
        tmp_address = tmp_obj.address
        break

  tmp_address


module.exports.show_error = (err_msg) ->
  atom.confirm
    message:"Error"
    detailedMessage:err_msg
    buttons:["Ok"]

module.exports.show_warnning = (warn_msg) ->
  atom.confirm
    message:"Warnning"
    detailedMessage:warn_msg
    buttons:["Ok"]

module.exports.show_info = (info_msg) ->
  atom.confirm
    message:"Info"
    detailedMessage:info_msg
    buttons:["Ok"]

module.exports.self_info = (title_msg, detail_msg) ->
  atom.confirm
    message:title_msg
    detailedMessage:detail_msg
    buttons:["Ok"]

module.exports.show_alert = (text_title, text_msg) ->
  atom.confirm
    message: "#{text_title}"
    detailedMessage: "#{text_msg}"
    buttons:
      '否': -> return 0
      '是': -> return 1

module.exports.show_alert_cancel = (text_title, text_msg) ->
  atom.confirm
    message: "#{text_title}"
    detailedMessage: "#{text_msg}"
    buttons:
      '是': -> return 1
      '否': -> return 0
      '取消': -> return 2


module.exports.isEmpty = (obj) ->
    for key,name of obj
        false;
    true;

module.exports.get_emp_os = () ->
  if !atom.project.emp_os
    atom.project.emp_os = os.platform().toLowerCase()
  atom.project.emp_os


module.exports.mkdir_sync = (tmp_dir) ->
  if !fs.existsSync(tmp_dir)
    fs.mkdirSync(tmp_dir);


module.exports.mkdirs_sync = (root_dir, dir_list) ->
  for dir in dir_list
    tmp_dir = root_dir+dir
    if !fs.existsSync(tmp_dir)
      fs.mkdirSync(tmp_dir);

mkdir_sync_safe = (tmp_dir) ->
   if !fs.existsSync(tmp_dir)
     mkdir_sync_safe(path.dirname tmp_dir)
     fs.mkdirSync(tmp_dir);

mk_dirs_sync = (p, made) ->
  # default mode is 0777

  # mask = ~process.umask()
  #
  # mode = 0777 & (~process.umask()) unless mode
  made = null unless made
  # mode = parseInt(mode, 8) unless typeof mode isnt 'string'
  p = path.resolve(p)
  try
      fs.mkdirSync(p)
      made = made || p
  catch err0
    switch err0.code
        when 'ENOENT'
          made = mk_dirs_sync(path.dirname(p), made)
          mk_dirs_sync(p, made)

        # // In the case of any other error, just see if there's a dir
        # // there already.  If so, then hooray!  If not, then something
        # // is borked.
        else
          stat = null
          try
              stat = fs.statSync(p)
          catch err1
              throw err0
          unless stat.isDirectory()
            throw err0
  made

# 添加资源描述图片
module.exports.chose_detail_f = (callback)->
  @chose_detail(['openFile'], callback)

module.exports.chose_detail_d = (callback)->
  @chose_detail(['openFile', 'openDirectory'], callback)

module.exports.chose_detail = (opts=['openFile', "openDirectory"], callback)->
  dialog.showOpenDialog title: 'Select', properties: opts, (img_path) =>
    if img_path
      if callback
        callback(img_path[0])

module.exports.get_random = (range) ->
  Math.round(Math.random()*range)

module.exports.get_sep_path = (tmp_path='') ->
  path_ele = tmp_path.split /[/\\]/ig
  path_ele.join path.sep



valid_ip = (ip_add)->
    # console.log ip_add
    ip_add.match(///^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$///ig)


module.exports.mk_dirs_sync = mk_dirs_sync
module.exports.valid_ip = valid_ip
module.exports.mkdir_sync_safe = mkdir_sync_safe
