{Disposable, CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'
ert_md_file = 'ui_snippets_tutorial.md'



module.exports =
  class ErtUiGuide

    constructor: ->
      console.log "------ ui guide -----"
      @disposable = new CompositeDisposable()
      @disposable.add atom.commands.add "atom-workspace","emp-template-management:show-guide", => @show_guide()


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
