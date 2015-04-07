{$$,View} = require 'atom'
emp = require '../../exports/emp'

# default_select_pack = null
# default_select_type = null
default_select_pack = emp.EMP_DEFAULT_PACKAGE
default_select_type = emp.EMP_DEFAULT_TYPE

module.exports =
class CbbToolSettingPanel extends View
  edit_flag:false

  @content: (count, @tool)->
    @section outlet:'package_list', class: 'sub-section installed-packages', =>
      @h3 class: 'sub-section-heading icon icon-package', =>
        @text 'Cbb Tool Setting:'
        @span outlet: 'templateCount', class:'section-heading-count', " (#{count})"
      @div outlet: 'tmp_contrainer', class: 'container package-container', =>
        @div class: 'section-body', =>
          @button outlet:'add_btn', class:'btn', click:'do_add',style:'display:none', "Add new setting"
          @button outlet:'remove_btn', class:'btn', click:'do_remove', style:'display:none',  "Remove this setting"
          # @div outlet:'loading_btn', class: 'alert alert-info loading-area icon icon-hourglass', click:'do_add', "Add new setting"
          @div outlet:'control_div', style:'display:none', =>
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


  initialize: (@count, @tool)->
    # console.log "setting panel"
    # @tmp_contrainer.empty()
    if @tool
      default_select_pack = @tool.pack_name
      default_select_type = @tool.type_name
      @show_view()
      @do_initial()
    else if count is emp.TOOL_FIRST
      @show_view()
      @remove_btn.show()
      @do_initial()
    else
      # console.log "do nothin"
      @hide_view()
      @add_btn.show()



  do_initial: ()->
    @cbb_management = atom.project.cbb_management
    @packs = @cbb_management.get_pacakges()
    # console.log @packs

    @pack_select.change (event) =>
      # edit_flag=true
      # console.log @logo_select
      # console.log @logo_select.val()
      tmp_name = @pack_select.val()
      # console.log  @pack_select.val()

      tmp_obj = @packs[tmp_name]
      # console.log tmp_obj
      type_list = tmp_obj.get_type()
      @type_select.empty()

      for tmp_type in type_list
        if tmp_type is default_select_type
          @type_select.append @new_selec_option(tmp_type)
        else
          @type_select.append @new_option(tmp_type)

    # @type_select.change (event) =>
    #   edit_flag=true

    # tmp_flag = false
    @pack_select.empty()
    for name, obj of @packs
      if name is default_select_pack
        @pack_select.append @new_selec_option(name)
      else
        @pack_select.append @new_option(name)

    console.log @packs
    # console.log default_select_pack
    tmp_pack = @packs[default_select_pack]
    console.log tmp_pack
    type_list = tmp_pack.get_type()

    # tmp_flag = false
    @type_select.empty()
    for tmp_type in type_list
      if tmp_type is default_select_type
        @type_select.append @new_selec_option(tmp_type)
      else
        @type_select.append @new_option(tmp_type)


  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selec_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name


  show_view: ->
    @add_btn.hide()
    @control_div.show()
    @do_initial()
    # @pack_div.show()
    # @type_div.show()
    # @remove_btn.show()

  hide_view: ->
    @control_div.hide()
    # @pack_div.hide()
    # @type_div.hide()
    @pack_select.empty()
    @type_select.empty()
    @add_btn.show()
    @remove_btn.hide()



  do_add: ->
    console.log "do add"
    @remove_btn.show()
    @show_view()

  do_save: ->
    console.log "do save"
    console.log edit_flag


  do_remove: ->
    console.log "do remove"
    @hide_view()

  get_setting_val: ->
    {name: @count, pack_name:@pack_select.val(), type_name: @type_select.val()}

  # if !emp_cbb_types = atom.config.get emp.EMP_CBB_TYPE
  #   atom.config.set emp.EMP_CBB_TYPE, emp.EMP_CPP_TYPE_DEF
  #   emp_cbb_types = emp.EMP_CPP_TYPE_DEF
  # for option in emp_cbb_types
  #   @option value: option, option
  # @option selected:'select', value: emp.EMP_DEFAULT_TYPE, emp.EMP_DEFAULT_TYPE
