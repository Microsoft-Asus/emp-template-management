{Disposable, CompositeDisposable} = require 'atom'
CSON = require 'cson'
toc = require 'markdown-toc'
open = require 'open'
emp = require '../exports/emp'
fs = require 'fs'
path = require 'path'
ert_md_file = 'ui_snippets_tutorial.md'
# roaster = require 'roaster'
hl = require('highlight').Highlight
marked = require('marked')

def_snippet_pack="eui"
default_val = "default"

ui_guide_md_file = "../../doc/gen_ui_snippet_guide.md"
ui_guide_html_file = "../../doc/gen_ui_snippet_guide.html"

cbb_guide_md_file = "../../doc/gen_cbb_guide.md"
cbb_guide_html_file = "../../doc/gen_cbb_guide.html"

temp_all = "../../doc/template/temp-all.cson"
html_top = "../../doc/parts/top.html"
html_bottom = "../../doc/parts/bottom.html"

show_html = true

cbb_html_title =
  {"top_head":"公共控件 API",
  "top_subtitle":"公共控件 API 展现目录"}

ui_html_title =
  {"top_head": "基础控件 API",
  "top_subtitle": "公共控件 API ,V5.3 之后支持"}

module.exports =
class ErtUiGuide

  constructor: ->
    console.log "------ ui guide -----"
    @cbb_management = atom.project.cbb_management
    temp_all_rel_path = path.join __dirname, temp_all

    # @temp_all = @get_con(temp_all)
    @temp_all_obj = CSON.parseCSONFile(temp_all_rel_path)
    @cbb_temp = @temp_all_obj["cbb-temp"]
    # console.log @temp_all_obj
    @temp_head_con = @cbb_temp.ui_head
    @temp_body_con = @cbb_temp.ui_body
    @temp_type_title = @cbb_temp.ui_type

    @temp_cbb_pack = @cbb_temp.package
    @temp_cbb_type = @cbb_temp.type
    @temp_cbb_template = @cbb_temp.template
    @temp_img = @cbb_temp.img
    # console.log @temp_all_obj

    @ui_md_file = path.join __dirname, ui_guide_md_file
    @ui_html_file = path.join __dirname, ui_guide_html_file
    @cbb_md_path = path.join __dirname, cbb_guide_md_file
    @cbb_html_path = path.join __dirname, cbb_guide_html_file

    @templates_path = atom.project.templates_path
    md_path = atom.packages.activePackages["markdown-preview"].mainModulePath
    md_base_dir = path.dirname md_path
    reder_path = path.join md_base_dir, 'renderer'
    @md_preview = require atom.packages.activePackages["markdown-preview"].mainModulePath
    @md_renderer = require reder_path

    html_top_path = path.join __dirname , html_top
    html_bottom_path = path.join __dirname , html_bottom
    @html_top_part = fs.readFileSync html_top_path, "utf-8"
    @html_bottom_part = fs.readFileSync html_bottom_path, "utf-8"

    @disposable = new CompositeDisposable()
    @disposable.add atom.commands.add("atom-workspace", {
      "emp-template-management:show-guide": => @show_ui_guide()
      "emp-template-management:show-guide-brw": => @show_ui_guide(show_html)
      "emp-template-management:show-cbb-guide": =>
        @templates_path = atom.project.templates_path
        @show_cbb_guide()
      "emp-template-management:show-cbb-guide-brw": =>
        @templates_path =  atom.project.templates_path
        @show_cbb_guide(show_html)
      "emp-template-management:refresh-guide": => @refresh_guide()
      "emp-template-management:test":=>@test()
      })

    # // Synchronous highlighting with highlight.js
    marked.setOptions({
      highlight:(code) =>
        re_code = hl(code)
        # console.log re_code
        return re_code
    })


  test: =>
    ui_md_con = @get_ui_guide()

    # converter = new pagedown.Converter()
    html_body = fs.readFileSync @ui_md_file, 'utf-8'
    # html_con = markdown.toHTML html_body
    # html_con = hl(html_con, false, true)
    # output_html = converter.makeHtml(html_body);
    # re_content = ""
    html_con = marked(html_body)

    title_con = '<header class="jumbotron subhead" id="overview">
            <div class="container"><h1>test</h1>
            <p class="lead">test2</p></div></header>'
    tmp_top = @html_top_part.replace(/\{\{header\}\}/ig, title_con).replace(/\{\{title\}\}/, "EMP API")
    re_content = tmp_top+html_con+@html_bottom_part

    # @md_renderer.toHTML html_body, @ui_html_file, "xml", (error, html_c) =>
    #   if error
    #     console.warn('Copying Markdown as HTML failed', error)
    #   else
    #     test_f = path.join __dirname,"../../doc/gen_ui_snippet_guide1.html"
    #     test_f2 = path.join __dirname,"../../doc/gen_ui_snippet_guide2.html"
    #     # fs.writeFileSync test_f, tmp_top+html_c+@html_bottom_part, 'utf-8'
    #     html = hl(html_c, false, true)
    #     fs.writeFileSync test_f2, tmp_top+html+@html_bottom_part, 'utf-8'
    #     fs.writeFileSync @ui_html_file, tmp_top+html_c+@html_bottom_part, 'utf-8'
    #     open(@ui_html_file)
    # output =
    #     top_part.replace(/\{\{header\}\}/, function() {
    #         if (argv.h) {
    #             return '<header class="jumbotron subhead" id="overview">' +
    #                    '<div class="container">' +
    #                    '<h1>' + tags.title  + '</h1>' +
    #                    '<p class="lead">' + tags.subtitle + '</p>' +
    #                    '</div></header>';
    #         } else {
    #             return "";
    #         }
    #     }).replace(/\{\{title\}\}/, tags.title === "TITLE HERE" ? "" : tags.title) +
    #     tocHtml +
    #     output +
    #     bottom_part;

    # console.log converter.makeHtml(re_con)
    fs.writeFileSync @ui_html_file, re_content, 'utf-8'
    open(@ui_html_file)

  refresh_guide: ->
    ui_md_con = @get_ui_guide()
    @gen_html(@ui_html_file, ui_md_con, ui_html_title)
    cbb_md_con = @get_cbb_guide()
    @gen_html(@cbb_html_path, cbb_md_con, cbb_html_title)
    emp.show_info "刷新 API 文档成功"

  show_ui_guide: (html_flag=false)->
    @show_guide(html_flag, @ui_md_file, @ui_html_file, cbb_html_title, => @get_ui_guide())

  show_cbb_guide: (html_flag=false)->
    @show_guide(html_flag, @cbb_md_path, @cbb_html_path, ui_html_title, => @get_cbb_guide())

  show_guide: (html_flag=false, md_file, html_file, html_title, callback)->
    if html_flag
      if fs.existsSync html_file
        open(html_file)
      else
        if fs.existsSync md_file
          re_content = fs.readFileSync md_file, 'utf-8'

          # @md_renderer.toHTML re_content, html_file, "HTML", (error, html) =>
          #   if error
          #     console.warn('Copying Markdown as HTML failed', error)
          #   else
          #     fs.writeFileSync html_file, html, 'utf-8'
          #     open(html_file)
        else
          re_content = callback()
        @gen_html(html_file, re_content, html_title)
        open(@ui_html_file)
    else
      if fs.existsSync md_file
        @md_preview.previewFile(@new_target(md_file))
      else
        callback()
        @md_preview.previewFile(@new_target(md_file))

  gen_html: (html_file, md_con, {top_head, top_subtitle})->
    html_con = marked(md_con)
    title_con = "<header class=\"jumbotron subhead\" id=\"overview\">
            <div class=\"container\"><h1>#{top_head}</h1>
            <p class=\"lead\">#{top_subtitle}</p></div></header>"
    tmp_top = @html_top_part.replace(/\{\{header\}\}/ig, title_con).replace(/\{\{title\}\}/, "EMP API")
    # tocHtml = '<div class="span3 bs-docs-sidebar"><ul class="nav nav-list bs-docs-sidenav" data-spy="affix">';
    re_content = tmp_top+html_con+@html_bottom_part

    fs.writeFileSync html_file, re_content, 'utf-8'

  # cbb guide
  get_cbb_guide: ()->
    console.log 'cbb guide'
    # console.log @cbb_management.get_pacakges_list()
    # console.log @cbb_management.get_pacakges()
    cbb_packages = @cbb_management.get_pacakges()
    re_content = ""
    re_content = re_content+@cbb_temp.head

    for key, cbb_pakcage of cbb_packages
      # console.log cbb_pakcage
      package_path = cbb_pakcage.package_path
      tmp_pack_con = @temp_cbb_pack.replace(/\$name/ig, key)

      tmp_logo = ""
      # console.log package_path
      # console.log cbb_pakcage.logo
      if cbb_pakcage.logo
        tmp_logo = path.join @templates_path, cbb_pakcage.logo
        tmp_logo = @get_img(tmp_logo)

      tmp_pack_con = tmp_pack_con.replace(/\$logo/ig, tmp_logo)
      tmp_pack_con = tmp_pack_con.replace(/\$desc/ig, cbb_pakcage.desc)
      re_content = re_content+tmp_pack_con

      tmp_type_list = cbb_pakcage.type_list
      tmp_type_objs = cbb_pakcage.obj_json
      for cbb_type in tmp_type_list
        # 添加 cbb type 描述
        tmp_type_con = @temp_cbb_type.replace(/\$name/ig, cbb_type)
        re_content = re_content+tmp_type_con
        if cbb_type_obj = tmp_type_objs[cbb_type]
          for cbb_name, cbb_temp_obj of cbb_type_obj
            #### $name\n$logo\n$desc\n$details
            tmp_temp_con = @get_cbb_template(package_path, cbb_type, cbb_name)
            re_content = re_content+tmp_temp_con

    md_toc = toc(re_content)
    # console.log re_content.content
    re_content = md_toc.content+"\n"+re_content
    fs.writeFileSync @cbb_md_path, re_content, 'utf-8'
    re_content
    # md_preview = require atom.packages.activePackages["markdown-preview"].mainModulePath
    # @md_preview.previewFile(@new_target(@cbb_md_path))

  get_cbb_template: (package_path, cbb_type, cbb_name) ->
    tmp_temp_con = ""
    # console.log temp_name
    # console.log cbb_type
    temp_json = path.join package_path, cbb_type, cbb_name, emp.EMP_TEMPLATE_JSON
    if fs.existsSync temp_json
      json_con = fs.readFileSync temp_json, 'utf-8'
      tmp_obj = JSON.parse json_con

      tmp_temp_con = @temp_cbb_template.replace(/\$name/ig, cbb_name)
      # console.log tmp_obj

      cbb_logo = ""
      if tmp_obj.logo
        tmp_logo = path.join @templates_path, tmp_obj.logo
        cbb_logo = @get_img(tmp_logo)
      tmp_temp_con = tmp_temp_con.replace(/\$logo/ig, cbb_logo)
      tmp_temp_con = tmp_temp_con.replace(/\$desc/ig, tmp_obj.desc)
      tmp_html = @get_cbb_ele_con(tmp_obj.html)
      tmp_css = @get_cbb_ele_con(tmp_obj.css)
      tmp_lua = @get_cbb_ele_con(tmp_obj.lua)
      # if tmp_html.trim() is ""
      tmp_temp_con = tmp_temp_con.replace(/\$body/ig, tmp_html)
      tmp_temp_con = tmp_temp_con.replace(/\$css/ig, tmp_css)
      tmp_temp_con = tmp_temp_con.replace(/\$lua/ig, tmp_lua)

      cbb_details_str = ""
      cbb_details =  tmp_obj.detail
      if cbb_details
        for cbb_detail in cbb_details
          tmp_detail_path = path.join @templates_path, cbb_detail
          tmp_detail = @get_img(tmp_detail_path)
          cbb_details_str = cbb_details_str+tmp_detail

      tmp_temp_con = tmp_temp_con.replace(/\$details/ig, cbb_details_str)
    tmp_temp_con
# {"name":"finish_close_button","version":"0.1","desc":"理财页面完成和退出按钮","type":"button","logo":"cmm_ui/button/finish_close_button/finish_close_button.png","html":{"type":"1","body":"cmm_ui/button/finish_close_button/tmp.xhtml"},"css":{"type":"1","body":"cmm_ui/button/finish_close_button/tmp.css"},"lua":null,"available":true,"own_package":"cmm_ui","source":["cmm_ui/button/finish_close_button/image/finish_bottom.png"],"detail":["cmm_ui/button/finish_close_button/finish_close_button.png"],"element_path":"cmm_ui/button/finish_close_button","level":"3"}
  get_cbb_ele_con:(ele_obj) ->
    result_con = ""
    # console.log ele_obj
    if ele_obj
      if ele_obj.type is emp.EMP_FILE_TYPE
        tmp_file = ele_obj.body
        file_path = path.join @templates_path, tmp_file
        # console.log file_path
        if fs.existsSync file_path
          result_con = fs.readFileSync file_path, 'utf-8'
      else
        result_con = ele_obj.body
    # console.log result_con
    result_con



  # ui guide
  get_ui_guide: () ->
    [@snippet_sotre_path, @snippet_css_path, @snippet_img_path] = @cbb_management.get_snippet_path()
    file_name = path.join @snippet_sotre_path, def_snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT
    # console.log file_name
    snippet_obj = {}
    if fs.existsSync file_name
      snippet_obj = CSON.parseCSONFile(file_name)

    re_content = ""
    re_content = re_content + @temp_head_con
    emp_params = snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
    type_list = emp_params?[emp.DEFAULT_SNIPPET_TYPE_KEY]
    # console.log type_list
    type_obj = {}
    if type_list
      for tmp_type in type_list
        type_obj[tmp_type] = {}
      if type_list.indexOf(default_val) is -1
        type_obj[default_val] = {}
    else
      type_obj[default_val] = {}
      
    # 删除文件中类型列表,为下面的循环做准备
    delete snippet_obj[emp.DEFAULT_SNIPPET_TYPE]
    for tmp_source, tmp_objs of snippet_obj
      for tmp_name, tmp_obj of tmp_objs
        tmp_type = tmp_obj.type
        if type_obj[tmp_type]
          type_obj[tmp_type][tmp_name]=tmp_obj
        else
          type_obj[tmp_type] = {}
          type_obj[tmp_type][tmp_name]=tmp_obj


    # console.log type_obj
    for type,type_obj_list of type_obj
      re_content = re_content + @temp_type_title.replace(/\$type/ig, type)
      for tmp_name, tmp_obj of type_obj_list
        temp_con = @temp_body_con.replace(/\$name/ig, tmp_name).replace(/\$desc/ig, tmp_obj.desc)

        # temp_con = temp_con.replace(/\$img/ig, tmp_img)
        temp_con = temp_con.replace(/\$prefix/ig, tmp_obj.prefix)
        temp_con = temp_con.replace(/\$body/ig, tmp_obj.body)

        tmp_imgs = tmp_obj.img
        imgs_str = ""
        if tmp_imgs
          # console.log tmp_imgs
          # console.log @snippet_img_path
          for tmp_img in tmp_imgs
            img_path = path.join @snippet_img_path, tmp_img
            # console.log img_path
            re_temp_img = @get_img(img_path)
            imgs_str = imgs_str+re_temp_img
        else
          imgs_str = "无\n"
        temp_con = temp_con.replace(/\$imgs/ig, imgs_str)
        re_content = re_content + temp_con

    md_toc = toc(re_content)
    # console.log re_content.content

    re_content = md_toc.content+"\n"+re_content
    fs.writeFileSync @ui_md_file, re_content, 'utf-8'
    re_content
    # @md_preview = require atom.packages.activePackages["markdown-preview"].mainModulePath
    # ert_md_path = path.join __dirname, '../../doc/',ert_md_file
    # md_state =  fs.existsSync ert_md_path
    # console.log md_state
    # if md_state
    # @md_preview.previewFile(@new_target(@ui_md_file))


  get_con: (file) ->
    re_con = ""
    if fs.existsSync file
      re_con = fs.readFileSync file,'utf-8'
    re_con


  new_target: (tmp_path) ->
    {target:{dataset: {path: tmp_path}}}

  get_img:(tmp_logo) ->
    @temp_img.replace(/\$img/ig, tmp_logo)
