{Disposable, CompositeDisposable} = require 'atom'
CSON = require 'cson'
emp = require '../exports/emp'
fs = require 'fs'
path = require 'path'
ert_md_file = 'ui_snippets_tutorial.md'

def_snippet_pack="eui"
temp_head = "../../doc/template/temp-head.md"
temp_body = "../../doc/template/temp-body.md"
temp_type_title = "\r\n## $type 基础控件\r\n"
temp_img = "![]($img)\r\n"
default_val = "default"
tmp_re_file = "../../doc/tmp_re.md"

module.exports =
class ErtUiGuide

  constructor: ->
    console.log "------ ui guide -----"
    @cbb_management = atom.project.cbb_management
    temp_head_rel_path = path.join __dirname, temp_head
    temp_body_rel_path = path.join __dirname, temp_body
    @temp_head_con = @get_con(temp_head_rel_path)
    @temp_body_con = @get_con(temp_body_rel_path)
    @tmp_store_file = path.join __dirname, tmp_re_file


    @disposable = new CompositeDisposable()
    @disposable.add atom.commands.add "atom-workspace","emp-template-management:show-guide", =>
      @get_guide()
      # @show_guide()



  show_guide: ->
    console.log "show guide ++++++ "
    md_preview = require atom.packages.activePackages["markdown-preview"].mainModulePath
    ert_md_path = path.join __dirname, '../../doc/',ert_md_file
    md_state =  fs.existsSync ert_md_path
    # console.log md_state
    if md_state
      md_preview.previewFile(@new_target(ert_md_path))


  new_target: (tmp_path) ->
    {target:{dataset: {path: tmp_path}}}


  get_guide: () ->
    [@snippet_sotre_path, @snippet_css_path, @snippet_img_path] = @cbb_management.get_snippet_path()
    file_name = path.join @snippet_sotre_path, def_snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    snippet_obj = {}
    if fs.existsSync file_name
      snippet_obj = CSON.parseCSONFile(file_name)

    re_content = re_content + @temp_head_con
    emp_params = snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
    type_list = emp_params?[emp.DEFAULT_SNIPPET_TYPE_KEY]
    if type_list
      type_obj = {}
      for tmp_type in type_list
        type_obj[tmp_type] = {}
      if type_list.indexOf(default_val) is -1
        type_obj[default_val] = {}

      delete snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
      for tmp_source, tmp_objs of snippet_obj
        for tmp_name, tmp_obj of tmp_objs
          tmp_type = tmp_obj.type
          if type_obj[tmp_type]
            type_obj[tmp_type][tmp_name]=tmp_obj
          else
            type_obj[default_val][tmp_name]=tmp_obj

    for type , type_obj_list of type_obj
      re_content = re_content + temp_type_title.replace(/\$type/ig, type)
      for tmp_name, tmp_obj of type_obj_list
        temp_con = @temp_body_con.replace(/\$name/ig, tmp_name).replace(/\$desc/ig, tmp_obj.desc)



        # temp_con = temp_con.replace(/\$img/ig, tmp_img)
        temp_con = temp_con.replace(/\$prefix/ig, tmp_obj.prefix)
        temp_con = temp_con.replace(/\$body/ig, tmp_obj.body)

        tmp_imgs = tmp_obj.img
        imgs_str = ""
        if tmp_imgs
          console.log tmp_imgs
          console.log @snippet_img_path
          for tmp_img in tmp_imgs
            img_path = path.join @snippet_img_path, tmp_img
            console.log img_path
            re_temp_img = temp_img.replace(/\$img/ig, img_path)
            imgs_str = imgs_str+re_temp_img
        else
          imgs_str = "无"

        temp_con = temp_con.replace(/\$imgs/ig, imgs_str)
        re_content = re_content + temp_con


    fs.writeFileSync @tmp_store_file, re_content, 'utf-8'

    md_preview = require atom.packages.activePackages["markdown-preview"].mainModulePath
    # ert_md_path = path.join __dirname, '../../doc/',ert_md_file
    # md_state =  fs.existsSync ert_md_path
    # console.log md_state
    # if md_state
    md_preview.previewFile(@new_target(@tmp_store_file))







  get_con: (file) ->
    re_con = ""
    if fs.existsSync file
      re_con = fs.readFileSync file,'utf-8'
    re_con
