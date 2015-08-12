{$, $$, View, TextEditorView} = require 'atom-space-pen-views'
ZipWriter = require("moxie-zip").ZipWriter
AdmZip = require('adm-zip')
emp = require '../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'

default_select_pack = "Export All"
# default_select_type = emp.EMP_DEFAULT_TYPE
project_path = null
tmp_export_store_path = null
templates_store_path = null
ext = ".zip"
fs = require 'fs'
fs_plus = require 'fs-plus'
path = require 'path'
default_export_snippets_path = "export_snippets"

module.exports =
class CbbPackImportView extends View
  @content: ->
    @div =>
      @form class: 'general-panel section', =>
        @div outlet: "loadingElement", class: 'alert alert-info loading-area icon icon-hourglass', "Loading settings"
      @section class: 'section settings-panel', =>
        @div outlet:"section_container", class: 'section-container', =>
          @div class: "block section-heading icon icon-gear", "CBB Export"
          @div class: 'section-body', =>
            @div outlet:'pack_div', class: 'control-group',  =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "Package Name"
              @div class: 'controls', =>
                @select outlet:"pack_select", id: "pack", class: 'form-control'

            @div outlet:'type_div', class: 'control-group',=>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "Type Name"
              @div class: 'controls', =>
                @select outlet:"type_select", id: "type", class: 'form-control'


            @div class:'control-btn-m', =>
              @subview "export_path", new TextEditorView(mini: true,attributes: {id: 'export_path', type: 'string'},  placeholderText: ' Export Path')
              # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
              @button class: 'control-btn btn btn-info', click:'select_export_path',' Chose Path '
              @button outlet:'export_btn', class:'control-btn btn btn-info', click:'do_export',  "Export"


      @section class: 'section settings-panel', =>
        @div outlet:"section_container", class: 'section-container', =>
          @div class: "block section-heading icon icon-gear", "Export UI Snippet"
          @div class: 'section-body', =>
            @div class: 'control-group',  =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "导出 UI Snippets"
                  @div class: 'setting-description', " 从 Emp Template Management 中导出 UI Snippets"
              @div class: 'controls', =>
                @select outlet:"ui_pack_select", id: "pack", class: 'form-control'

            @div class:'control-btn-m', =>
              @subview "ui_export_path", new TextEditorView(mini: true,attributes: {id: 'ui_export_path', type: 'string'},  placeholderText: ' UI Snippets Export Path')
              # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
              @button class: 'control-btn btn btn-info', click:'select_ui_export_path',' Chose Path '
              @button outlet:'export_btn', class:'control-btn btn btn-info', click:'do_ui_export',  "Export"

      @section class: 'section settings-panel', =>
        @div outlet:"section_container", class: 'section-container', =>
          @div class: "block section-heading icon icon-gear", "Import UI Snippets"
          @div class: 'section-body', =>

            @div class: 'control-group',=>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "导入 UI Snippets"
                  @div class: 'setting-description', " 从 UI Lib 中导入 UI Snippets"
              @div class: 'controls', =>
                @subview "ui_lib_path", new TextEditorView(mini: true,attributes: {id: 'ui_lib_path', type: 'string'},  placeholderText: ' UI Lib Path')

            @div class:'control-btn-m', =>
              @button class: 'control-btn btn btn-info', click:'select_ui_import_path',' Chose Path '
              @button class: 'control-btn btn btn-info', click:'import_snippets',' Import '

          # @div class: "block section-heading icon icon-gear", "Cbb Import"
          # @div class: 'section-body', =>
          #   @div class: 'control-group', =>
          #     @div class: 'controls', =>
          #       @label class: 'control-label', =>
          #         @div class: 'info-label', "导入模板包"
          #         @div class: 'setting-description', " Package Dir"
          #       # @div class: 'editor-container', =>
          #       @subview "package_path", new TextEditorView(mini: true,attributes: {id: 'package_path', type: 'string'},  placeholderText: ' Package Path')
          #       # @subview 'template_path', new TextEditorView(mini: true, placeholderText: ' Template Path')
          #       @button class: 'control-btn btn btn-info', click:'select_import_path',' Chose Path '
          #       @button class: 'control-btn btn btn-info', click:'do_import','Import Package '


          # @section outlet:'package_list', class: 'sub-section installed-packages', =>
          #   @h3 class: 'sub-section-heading icon icon-package', =>
          #     @text 'Installed Packages'
          #     @span outlet: 'templateCount', class:'section-heading-count', ' (…)'
          #   @div outlet: 'templatePackages', class: 'container package-container', =>
          #     @div class: 'alert alert-info loading-area icon icon-hourglass', "Loading packages…"

  initialize: (msg)->
    @loadingElement.remove()
    @cbb_management = atom.project.cbb_management
    @packs = @cbb_management.get_pacakges()
    @cbb_tools = @cbb_management.get_tool_detail()
    projectPath = atom.project.getPaths()[0]
    if project_path
      tmp_export_store_path = path.join project_path,"tmp"
      console.log tmp_export_store_path
      emp.mkdir_sync_safe tmp_export_store_path
    # 模板路径
    templates_store_path =atom.project.templates_path
    @cbb_management = atom.project.cbb_management
    # ui snippet 保存路径
    @snippet_sotre_path = path.join __dirname, '../../snippets/'
    @snippet_css_path = path.join __dirname, '../../css/'
    # console.log @cbb_tools
    # @do_initial()
    # @do_initial_ui_snippet()

    @packs = @cbb_management.get_pacakges()
    @pack_select.change (event) =>
      console.log "pack change"
      if (tmp_name = @pack_select.val()) isnt default_select_pack

        tmp_obj = @packs[tmp_name]
        type_list = tmp_obj?.get_type()
        @type_select.empty()
        @type_select.append @new_selec_option(default_select_pack)

        for tmp_type in type_list
          @type_select.append @new_option(tmp_type)
      else
        @type_select.empty()

  refresh_detail:() ->
    @do_initial()
    @do_initial_ui_snippet()

  do_initial: ()->
    @packs = @cbb_management.get_pacakges()
    @pack_select.empty()
    @pack_select.append @new_selec_option(default_select_pack)
    for name, obj of @packs
      @pack_select.append @new_option(name)
    @type_select.empty()


  do_initial_ui_snippet: ->
    console.log "do_initial_ui_snippet"
    # s使用保存的路径
    store_import_snippet_path = atom.config.get emp.EMP_APP_IMPORT_UI_PATH
    if store_import_snippet_path
      @ui_lib_path.setText store_import_snippet_path
    store_export_snippet_path = atom.config.get emp.EMP_APP_EXPORT_UI_PATH
    if store_export_snippet_path
      @ui_export_path.setText store_export_snippet_path


    fs.readdir @snippet_sotre_path, (err, files) =>
      if err
        console.error err
      else
        @ui_pack_select.empty()
        # console.log files
        @ui_pack_select.append @new_selec_option(default_select_pack)
        for tmp_file in files
          tmp_extname = path.extname tmp_file
          if tmp_extname is emp.DEFAULT_SNIPPET_FILE_EXT
            snippet_pack = path.basename tmp_file, tmp_extname
            @ui_pack_select.append @new_option(snippet_pack)
          # if path.extname(tmp_file) is emp.DEFAULT_SNIPPET_FILE_EXT
          #   tmp_type_panel = new AvailableSnippetView(@snippet_sotre_path, tmp_file)
          #   @section_container.append tmp_type_panel


  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selec_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name

  select_export_path: ->
    @do_select_path(@export_path)

  # 导出 UI Snippets 路径
  select_ui_export_path: ->
    @do_select_path(@ui_export_path)

  # 导入 UI Snippets 路径
  select_ui_import_path: ->
    tmp_snippets_path = @ui_lib_path.getText()
    @do_select_path(@ui_lib_path, tmp_snippets_path)

  select_import_path: ->
    @do_select_path(@package_path)

  do_select_path: (view, def_path)->
    dialog.showOpenDialog title: 'Select',  defaultPath:def_path, properties: ['openDirectory'], (logo_path) => # 'openDirectory'
      # console.log logo_path
      if logo_path
        path_state = fs.statSync logo_path[0]
        if path_state?.isDirectory()
          # @cbb_logo.setText
          console.log logo_path[0]
          view.setText logo_path[0]



  do_import: ->
    # console.log "do import"
    if pack_path = @package_path.getText()

      result = @show_alert(pack_path)
      if result
        console.log "do import"
        zip = new AdmZip(pack_path)
        zip_entries = zip.getEntries()
        console.log zip_entries
        tmp_entries = {}
        zip_entries.forEach (zip_entry)->
          # console.log zip_entry.toString()
          tmp_entries[zip_entry.entryName] = zip_entry
          # if zip_entry.entryName == "my_file.txt"
              #  console.log zip_entry.data.toString('utf8')
        pack_name = null
        if zip_entries.length > 0
          pack_name = zip_entries[0].entryName.split("\/")[0]
        console.log pack_name
        template_json = path.join pack_name,emp.EMP_ZIP_DETAIL

        console.log template_json
        fa_entry = tmp_entries[template_json]
        console.log fa_entry
        fa_data = fa_entry.getData().toString('utf8')
        console.log fa_data
        templates_obj = JSON.parse fa_data
        console.log templates_obj.level
        if templates_obj.level is emp.EMP_JSON_ALL
          console.log "merge all"
          @cbb_management.merge_package(templates_obj, tmp_entries)


        else if templates_obj.level is emp.EMP_JSON_PACK
          console.log "merge pack"
        else
          console.log 'merge type'


    else
      emp.show_error emp.EMP_NO_EMPTY_PATH


  do_export: ->
    # console.log "do export"
    exp_pack = @pack_select.val()
    exp_type = @type_select.val()
    if !export_store_path = @export_path.getText()?.trim()
      export_store_path = tmp_export_store_path
      unless export_store_path
        emp.show_error("导出地址不能为空!")
        return

    if exp_pack is default_select_pack
      zip_detail = {level:emp.EMP_JSON_ALL, pack:@cbb_management.get_pacakges_list()}
      @do_export_dir(export_store_path, templates_store_path, zip_detail)
    else if exp_type is default_select_pack
      zip_detail = {level:emp.EMP_JSON_PACK, pack:exp_pack, type:@packs[exp_pack].get_type()}
      template_dir = path.join templates_store_path, exp_pack
      @do_export_dir(export_store_path, template_dir, zip_detail)
    else
      zip_detail = {level:emp.EMP_JSON_TYPE, pack:exp_pack, type:exp_type}
      template_dir = path.join templates_store_path, exp_pack, exp_type
      @do_export_dir(export_store_path, template_dir, zip_detail)

  do_export_dir: (export_store_path, temp_stpre_path, zip_detail)->
    zip = new ZipWriter()
    base_export_name = path.basename(temp_stpre_path)

    if result = @zip_dir temp_stpre_path, base_export_name, zip_detail
      # console.log result
      for tmp_file in result
        zip.addFile(tmp_file.show_path, tmp_file.dest_path)

      tmp_dir = path.join base_export_name,emp.EMP_ZIP_DETAIL
      temp_str = JSON.stringify zip_detail, null, '\t'
      zip.addData tmp_dir, temp_str

      export_name = base_export_name + ext
      export_name = path.join export_store_path,export_name
      zip.saveAs export_name, () ->
        emp.show_info emp.EMP_EXP_SUCCESS + "\n 导出地址为:" + export_name
    else
      emp.show_warnning "没有可导出的内容!"

  # 导出 UI Snippets
  do_ui_export: ->
    console.log "ui export"
    exp_pack = @ui_pack_select.val()
    if !export_store_path = @ui_export_path.getText()?.trim()
      export_store_path = tmp_export_store_path
      unless export_store_path
        emp.show_error("导出地址不能为空!")
        return
    atom.config.set emp.EMP_APP_EXPORT_UI_PATH, export_store_path
    # console.log exp_pack

    @export_ui_snippet export_store_path, exp_pack
    emp.show_info emp.EMP_EXP_SUCCESS + "\n 导出地址为:" + export_store_path

  export_ui_snippet: (export_dir, exp_pack)->
    # if fs.existsSync export_dir
    tmp_export_path = path.join export_dir, default_export_snippets_path
    emp.mkdir_sync_safe tmp_export_path

    tmp_snippets_dest_path = path.join tmp_export_path, emp.DEFAULT_SNIPPET_EXPORT_PATH
    emp.mkdir_sync_safe tmp_snippets_dest_path
    tmp_css_dest_path = path.join tmp_export_path, emp.DEFAULT_CSS_EXPORT_PATH
    emp.mkdir_sync_safe tmp_css_dest_path

    if exp_pack is default_select_pack
      fs_plus.copySync  @snippet_sotre_path, tmp_snippets_dest_path
      fs_plus.copySync  @snippet_css_path, tmp_css_dest_path
    else
      tmp_snippet_src_file = exp_pack+emp.DEFAULT_SNIPPET_FILE_EXT
      tmp_css_src_file = exp_pack+emp.DEFAULT_CSS_FILE_EXT
      exp_pack_src = path.join @snippet_sotre_path, tmp_snippet_src_file
      exp_css_src = path.join @snippet_sotre_path, tmp_css_src_file
      exp_pack_dest = path.join tmp_snippets_dest_path, tmp_snippet_src_file
      exp_css_dest = path.join tmp_css_dest_path, tmp_css_src_file

      fs.exists exp_pack_src, (exists) ->
        if exists
          fs_buf = fs.readFileSync exp_pack_src
          fs.writeFileSync exp_pack_dest, fs_buf
        else
          console.info "no ui snippet"

      fs.exists exp_css_src, (exists) ->
        if exists
          fs_buf = fs.readFileSync exp_css_src
          fs.writeFileSync exp_css_dest, fs_buf
        else
          console.info "no ui snippet css"
    # @snippet_sotre_path = path.join __dirname, '../../snippets/'
    # @snippet_css_path = path.join __dirname, '../../css/'

  # 导入 ui snippet
  import_snippets: ->
    console.log "ui import"
    if !ui_lib_path = @ui_lib_path.getText()?.trim()
      # ui_lib_path = tmp_export_store_path
      emp.show_error("导出地址不能为空!")
      return
    atom.config.set emp.EMP_APP_IMPORT_UI_PATH, ui_lib_path
    # console.log ui_lib_path

    tmp_snippets_src_path = path.join ui_lib_path, emp.DEFAULT_SNIPPET_EXPORT_PATH
    tmp_css_src_path = path.join ui_lib_path, emp.DEFAULT_CSS_EXPORT_PATH
    tmp_export_src_path = path.join ui_lib_path, default_export_snippets_path

    if fs.existsSync tmp_snippets_src_path
      import_flag = @show_alert ui_lib_path
      if import_flag
        fs_plus.copySync tmp_snippets_src_path, @snippet_sotre_path
        unless !fs.existsSync tmp_css_src_path
          fs_plus.copySync tmp_css_src_path, @snippet_css_path
        @refresh_snippets()
        emp.show_info emp.EMP_IMPORT_SUCCESS

    else if fs.existsSync tmp_export_src_path
      tmp_snippets_src_path = path.join tmp_export_src_path, emp.DEFAULT_SNIPPET_EXPORT_PATH
      tmp_css_src_path = path.join tmp_export_src_path, emp.DEFAULT_CSS_EXPORT_PATH
      if fs.existsSync tmp_snippets_src_path
        import_flag = @show_alert tmp_export_src_path
        if import_flag
          fs_plus.copySync tmp_snippets_src_path, @snippet_sotre_path
          unless !fs.existsSync tmp_css_src_path
            fs_plus.copySync tmp_css_src_path, @snippet_css_path
          @refresh_snippets()
          emp.show_info emp.EMP_IMPORT_SUCCESS
      else
        emp.show_error("导入失败, 导入结构不是正确的的导出结构,请尝试查看导出后结构.")
    else
      emp.show_error("导入失败, 导入结构不是正确的的导出结构,请尝试查看导出后结构.")

  refresh_snippets: ->
    snippets = require atom.packages.activePackages.snippets.mainModulePath
    snippets.loadAll()

  show_alert: (path) ->
    atom.confirm
      message: '警告'
      detailedMessage: "是否确定要导入该模板集?\n #{path}"
      buttons:
        '是': -> return true
        '否': -> return false

  zip_dir: (dir, show) ->
    # console.log dir,show
    show ?= path.basename dir
    dir_acc = []
    re_acc = []
    if fs.existsSync dir
      read_re = fs.readdirSync dir
      for dir_name in read_re
        dir_acc.push [dir_name, dir, show]
      check_file(dir_acc, re_acc)

check_file  = (dir_acc, re_acc, type) ->
  if dir_acc.length isnt 0
    [dir_name, fa_path, show_path] = dir_acc.pop()
    # console.log "dir_name:#{dir_name}, fa_path:#{fa_path}"
    if dir_name.match(/^\..*/ig)
      check_file(dir_acc, re_acc)
    else
      dest_path = path.join fa_path, dir_name
      show_path = path.join show_path, dir_name
      tmp_state = fs.statSync(dest_path)
      # console.log  dest_path
      if tmp_state?.isDirectory()
        dir_children = fs.readdirSync dest_path
        tmp_acc = new Array()
        for tmp_dir in dir_children
          dir_acc.push [tmp_dir, dest_path, show_path]
        check_file(dir_acc.concat(tmp_acc), re_acc)
      else
        re_acc.push(resource_entry(dest_path, show_path, dir_name))
        check_file(dir_acc, re_acc, type)
  else
    re_acc

resource_entry = (dest_path, show_path, file_name) ->
  {dest_path:dest_path, show_path:show_path, name:file_name}
