{$$,View} = require 'atom'
emp = require '../../exports/emp'
default_select_pack = emp.EMP_DEFAULT_PACKAGE
default_select_type = emp.EMP_DEFAULT_TYPE

module.exports =
class CbbToolSettingOptionView extends View
  @content: ()->
    @div class: 'section-body section-body-bottom', =>
      @button outlet:'remove_btn', class:'btn', click:'do_remove',  "Remove this setting"
      @div outlet:'control_div', =>
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


  initialize: (@default_pack, @default_type, @fa_view, @view_id, flag)->
    if flag
      @hide_view()

    @cbb_management = atom.project.cbb_management
    @packs = @cbb_management.get_pacakges()

    @pack_select.change (event) =>
      tmp_name = @pack_select.val()
      tmp_obj = @packs[tmp_name]
      type_list = tmp_obj.get_type()
      @type_select.empty()
      for tmp_type in type_list
        if tmp_type is @default_pack
          @type_select.append @new_selec_option(tmp_type)
        else
          @type_select.append @new_option(tmp_type)

    @pack_select.empty()
    for name, obj of @packs
      if name is @default_pack
        @pack_select.append @new_selec_option(name)
      else
        @pack_select.append @new_option(name)

    tmp_pack = @packs[@default_pack]
    # console.log tmp_pack
    type_list = tmp_pack.get_type()
    @type_select.empty()
    for tmp_type in type_list
      if tmp_type is @default_type
        @type_select.append @new_selec_option(tmp_type)
      else
        @type_select.append @new_option(tmp_type)

  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selec_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name

  hide_view: ->
    @remove_btn.hide()


  do_remove: ->
    @fa_view.remove_element(@view_id)
    @destroy()

  destroy: ->
    @detach()

  get_option_val: ->
    {pack_name:@pack_select.val(), type_name: @type_select.val()}
