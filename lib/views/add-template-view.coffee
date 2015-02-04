# _ = require 'underscore-plus'
{$, $$, TextEditorView, ScrollView} = require 'atom'
# {Subscriber} = require 'emissary'
# fuzzaldrin = require 'fuzzaldrin'

# AvailableTemplateView = require './available-template-view'
# ErrorView = require './error-view'
remote = require 'remote'
dialog = remote.require 'dialog'
emp = require '../exports/emp'

g_select = null
g_editor = null

module.exports =
class InstalledTemplatePanel extends ScrollView
  # Subscriber.includeInto(this)

  @content: ->
    @div =>
      @section class: 'section', =>
        @div class: 'section-container', =>
          @div class: 'section-heading icon icon-package', =>
            @text 'Add Packages'
            @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'


          @div class: 'section-body', =>

              @div class: 'control-group', =>
                @div class: 'controls', =>
                  @label class: 'control-label', =>
                    @div class: 'info-label', "模板路径"
                    @div class: 'setting-description', "Root Dir Name"

                  @subview "template_path", new TextEditorView(mini: true,attributes: {id: 'template_path', type: 'string'},  placeholderText: ' Template Path')
                  @button class: 'control-btn btn btn-info', click:'select_path',' Chose Path '

            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "Name"
                  @div class: 'setting-description', "Root Dir Name"

                # @subview "template_name_editor", style:"display:none;", new TextEditorView(mini: true, attributes: {id: 'template_name', type: 'string'}, placeholderText: 'Application Name')
                @select outlet:"name_select", id: "tt", class: 'form-control', =>
                  for option in ["emp", "ebank", "boc", "gdb"]
                    @option value: option, option
                  @option value: emp.EMP_NAME_DEFAULT, emp.EMP_NAME_DEFAULT

            @div class: 'control-group', =>
              @div class: 'controls', =>
                @label class: 'control-label', =>
                  @div class: 'setting-title', "Version"
                  @div class: 'setting-description', "Root Dir Name"

                # @subview "template_name_editor", style:"display:none;", new TextEditorView(mini: true, attributes: {id: 'template_name', type: 'string'}, placeholderText: 'Application Name')
                @select outlet:"name_select", id: "tt", class: 'form-control', =>
                  for option in ["1.1", "1.2", "1.0"]
                    @option value: option, option
                  @option value: emp.EMP_NAME_DEFAULT, emp.EMP_NAME_DEFAULT


      @div class: 'footer-div', =>
        @div class: 'footer-detail', =>
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'do_cancel','  Cancel  '
          @button class: 'footer-btn btn btn-info inline-block-tight', click:'do_submit',' Ok '




  initialize: () ->
    super
    @packageViews = []

    # console.log @template_path_e.getEditor().getText()

    @template_path.getEditor().on 'contents-modified', =>
      console.log @template_path.getEditor().getText()

    # @option_default.on 'click', ->
    #   "click default"
    # console.log @template_name_editor
    # console.log @template_name_editor.show()
    #
    # g_select = @name_select
    # g_editor = @template_name_editor
    # @name_select.change (event, p2, p3) ->
    #   # console.log "val channge"
    #   console.log event
      # console.log p2
      # console.log p3
      # current_view = event.currentTargetView()
      # console.log event.targetView()
      # temp_editor = event.targetView().template_name_editor
      # console.log temp_editor
      # console.log event.targetView().name_select
      #
      # event.targetView().name_select.hide()
      # temp_editor.show()

      # console.log current_view
      # parent_view = current_view.parent()?[0]
      # console.log parent_view


      # tmp_name = g_select.val()
      # # console.log tmp_name
      # if tmp_name is emp.EMP_NAME_DEFAULT
      # #   # @emp_log_color_list.css('background-color', tmp_color)
      #
      #   g_select.hide()
      #   console.log g_editor
      #   console.log g_select
      #   g_editor.getModel().show()



      #   client_id = @emp_client_list.val()
      #   if client_id isnt @default_color_name
      #     log_map[client_id].set_color(tmp_color)
      # else
      #   @emp_log_color_list.css('background-color', @default_color_value)
        # @find('atom-text-editor[id]').views().forEach (editorView) =>
        #   # editor = editorView.getModel()
        #   console.log name
        #   name = editorView.attr('id')
        #   type = editorView.attr('type')
        #
        #   if name is 'template_name'
        #     editorView.show()
        # editor.setPlaceholderText("Default: #{defaultValue}")

      # @observe name, (value) =>
      #   if @isDefault(name)
      #     stringValue = ''
      #   else
      #     stringValue = @valueToString(value) ? ''
      #
      #   return if stringValue is editor.getText()
      #   return if _.isEqual(value, @parseValue(type, editor.getText()))
      #
      #   editorView.setText(stringValue)
      #
      # editor.onDidStopChanging =>
      #   @set(name, @parseValue(type, editor.getText()))

  detached: ->
    # @unsubscribe()
    console.log "----"

  select_path: (e, element)->
    tmp_path = @template_path.getEditor().getText()
    @promptForPath(@template_path, tmp_path)

  promptForPath: (fa_view, def_path) ->
    if def_path
      dialog.showOpenDialog title: 'Select', defaultPath:def_path, properties: ['openDirectory', 'createDirectory'], (pathsToOpen) =>
        @refresh_path( pathsToOpen, fa_view)
    else
      dialog.showOpenDialog title: 'Select', properties: ['openDirectory', 'createDirectory'], (pathsToOpen) =>
        @refresh_path( pathsToOpen, fa_view)

  refresh_path: (new_path, fa_view)->
    if new_path
      console.log new_path
      fa_view.getEditor().setText(new_path[0])
