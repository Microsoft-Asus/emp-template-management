{$, View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'
CSON = require 'cson'
path = require 'path'
fs = require 'fs'

module.exports =
class UiSnippetElementView extends View

  @content: (name, {body, css, prefix}=tmp_obj, snippet_source, snippet_pack) ->
    name ?= ''
    prefix ?= ''
    body = body?.replace(/\t/g, '\\t').replace(/\n/g, '\\n') ? ''

    @tr =>
      @td =>
        @button class: 'control-btn btn btn-error', click:'do_del',' Del'
        @button class: 'control-btn btn btn-info', click:'do_edit',' Edit'
      @td class: 'snippet-prefix', prefix
      @td name
      @td class: 'snippet-body', body

  initialize: (@name, @tmp_obj, @snippet_source, @snippet_pack) ->
    {@body, @css, @prefix} = @tmp_obj
    @name ?= ''
    @body ?= ''
    @css ?= ''
    @prefix ?= ''


  do_edit: (e, element) ->
    console.log "do_edit"
    @parents('.emp-ui-snippets-management').view()?.showPanel(emp.EMP_UI_LIB, {}, [@name, @body, @css, @prefix, @snippet_source, @snippet_pack])

  do_del: (e, element) ->
    @snippet_sotre_path = atom.project.snippets_path
    file_name = @snippet_sotre_path + @snippet_pack + emp.DEFAULT_SNIPPET_FILE_EXT

    snippet_cson_str = ''
    if fs.existsSync file_name
      snippet_obj = {}
      file_ext = path.extname file_name
      if file_ext is emp.JSON_SNIPPET_FILE_EXT
        json_data = fs.readFileSync file_name
        snippet_obj = JSON.parse json_data
        delete snippet_obj[@snippet_source]?[@name]
        snippet_cson_str = JSON.stringify(snippet_obj, null, '\t')
      else
        snippet_obj = CSON.parseCSONFile(file_name)
        delete snippet_obj[@snippet_source]?[@name]
        snippet_cson_str = CSON.stringify(snippet_obj, null, '\t')

    fs.writeFile(file_name,  snippet_cson_str, (error) ->
        if error
          console.log error
        else
          console.log 'the old snippet was deleted. '
      )
    emp.show_info "删除基础控件成功."
    @detach()
#
