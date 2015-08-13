{View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'
path = require 'path'
fs_plus = require 'fs-plus'
# AvailableTypeView = require './ui_snippet/avaliable-ui-type-view'


module.exports =
class AvailablePackageView extends View

  @content: (snippet_path, snippet_file) ->
    snippet_pack = path.basename snippet_file, emp.DEFAULT_SNIPPET_FILE_EXT
    @div class: 'available-package-view col-lg-8', =>
      @div class: 'stats pull-right', =>
        @span class: "stats-item", =>
          @span class: 'icon icon-versions'
      @div class: 'body', =>
        @h4 class: 'card-name', =>
          @a outlet: 'packageName', click:'show_detail', snippet_pack
        # @span outlet: 'packageDescription', class: 'package-description', tmp_desc

      @div class: 'meta', =>
        @div class: 'meta-controls', =>
          @div outlet: 'buttons', class: 'btn-group', =>
            if emp.EMP_DEFAULT_SNIPPETS.indexOf(snippet_file) < 0
              @button type: 'button', class: 'btn icon icon-trashcan', outlet: 'uninstall_button', click:'do_uninstall', 'Uninstall'
            @button type: 'button', class: 'btn icon icon-repo', click:'edit_css', 'Edit Css File'
            @button type: 'button', class: 'btn icon icon-repo', click:'show_detail', 'Detail'

  initialize: (@snippet_path, @snippet_file) ->
    @snippet_pack = path.basename snippet_file, emp.DEFAULT_SNIPPET_FILE_EXT
    # @snippet_css_path = path.join __dirname, '../../../css/'
    @cbb_management = atom.project.cbb_management
    # 设置 ui snippet 存储路径
    [@snippet_sotre_path, @snippet_css_path] = @cbb_management.get_snippet_path()

  do_uninstall: ->
    tmp_flag = @show_alert()
    @snippet_file_name = path.join @snippet_path , @snippet_file
    # console.log tmp_flag
    switch tmp_flag
      when 1
        # console.log "1"
        fs_plus.removeSync(@snippet_file_name) unless !fs.existsSync @snippet_file_name
        snippets = require atom.packages.activePackages.snippets.mainModulePath
        snippets.loadAll()
        emp.show_info "删除成功！"
      else return

  edit_css: ->
    tmp_file = path.join @snippet_css_path, @snippet_pack+".css"
    # console.log tmp_file
    @create_editor(tmp_file, emp.EMP_GRAMMAR_CSS)

  create_editor:(tmp_file_path, tmp_grammar, callback, content) ->
    changeFocus = true
    tmp_editor = atom.workspace.open(tmp_file_path, { changeFocus }).then (tmp_editor) =>
      gramers = @getGrammars()
      console.log content
      unless content is undefined
        tmp_editor.setText(content) #unless !content
      tmp_editor.setGrammar(gramers[0]) unless gramers[0] is undefined
      callback(tmp_editor)

  # set the opened editor grammar, default is HTML
  getGrammars: (grammar_name)->
    grammars = atom.grammars.getGrammars().filter (grammar) ->
      (grammar isnt atom.grammars.nullGrammar) and
      grammar.name is 'CoffeeScript'
    grammars

  show_alert: (replace_con, relative_path, editor) ->
    atom.confirm
      message: '警告'
      detailedMessage: '是否确定要删除该模板集?'
      buttons:
        '是': -> return 1
        '否': -> return 0


  show_detail:->
    @parents('.emp-template-management').view()?.showPanel(emp.EMP_SNIPPET_DETAIL, {back: emp.EMP_SHOW_UI_LIB}, [@snippet_path, @snippet_file, @snippet_pack])
