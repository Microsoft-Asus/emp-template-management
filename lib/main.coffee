EmpTmpManaWizardView = require './views/emp-template-management-view'

empTmpManagementView = null
emp = require './exports/emp'


# -------------------use for template management -------------------------
create_tmp_management = (params) ->
  empTmpManagementView = new EmpTmpManaWizardView(params)

open_temp_wizard_panel = (params)->
  # console.log "open_temp_wizard_panel"
  atom.workspace.open(emp.EMP_TEMP_URI)
  # empTmpManagementView.add_new_panel()

temp_deserializer =
  name: emp.TEMP_WIZARD_VIEW
  version: 1
  deserialize: (state) ->
    console.log "emp template  deserialize"
    create_tmp_management(state) if state.constructor is Object

atom.deserializers.add(temp_deserializer)

module.exports =
  activate: (state)->
    # console.log "emp active~:#{state}"
    atom.workspace.addOpener (uri) ->
      # console.log "emp registerOpener: #{uri}"
      # console.log atom.workspace.activePane
      # console.log atom.workspace.activePane.itemForUri(configUri)
      if uri is emp.EMP_TEMP_URI
        create_tmp_management({uri})


    atom.commands.add "atom-workspace",
      "emp-template-management:temp-management", -> open_temp_wizard_panel(emp.DEFAULT_PANEL)

module.exports.open_temp_wizard = open_temp_wizard_panel
