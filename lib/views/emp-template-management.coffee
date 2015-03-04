EmpTemplateManagementView = require './emp-template-management-view'
{CompositeDisposable} = require 'atom'

module.exports = EmpTemplateManagement =
  empTemplateManagementView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @empTemplateManagementView = new EmpTemplateManagementView(state.empTemplateManagementViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @empTemplateManagementView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'emp-template-management:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @empTemplateManagementView.destroy()

  serialize: ->
    empTemplateManagementViewState: @empTemplateManagementView.serialize()

  toggle: ->
    console.log 'EmpTemplateManagement was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
