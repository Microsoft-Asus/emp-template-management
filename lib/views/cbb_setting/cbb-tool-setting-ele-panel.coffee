{$$,View} = require 'atom'
emp = require '../../exports/emp'
CBBToolEleOptionView = require './cbb-tool-setting-ele-option-view'
# default_select_pack = null
# default_select_type = null
default_select_pack = emp.EMP_DEFAULT_PACKAGE
default_select_type = emp.EMP_DEFAULT_TYPE

module.exports =
class CbbToolSettingPanel extends View
  edit_flag:false
  # store_select:{}
  add_count:1

  @content: (count, @tool)->
    @section outlet:'package_list', class: 'sub-section-low-bottom installed-packages', =>
      @h3 class: 'sub-section-heading icon icon-package', =>
        @text 'Cbb Tool Setting:'
        @span outlet: 'templateCount', class:'section-heading-count', " (#{count})"
      @div outlet: 'tmp_contrainer', class: 'container package-container', =>
        @div class: 'section-body section-body-bottom', =>
          @button class:'btn', click:'do_add', "Add new setting"

# style:'display:none'
  initialize: (@count, @tool)->
    # console.log "setting panel"
    @store_select = {}
    if @tool
      @do_initial(@tool)

    else if @count is emp.TOOL_FIRST
      tmp_view = new CBBToolEleOptionView(key, tmp_type, this, @add_count, true)
      @store_select[@add_count] = tmp_view
      @add_count += 1
      @tmp_contrainer.append tmp_view

  do_initial: (@tool)->
    for key, val of @tool
      for tmp_type in val
        tmp_view = new CBBToolEleOptionView(key, tmp_type, this, @add_count)
        @store_select[@add_count] = tmp_view
        @add_count += 1
        @tmp_contrainer.append tmp_view

  new_option: (name)->
    $$ ->
      @option value: name, name

  new_selec_option: (name) ->
    $$ ->
      @option selected:'select', value: name, name

  do_add: ->
    console.log "do add"
    tmp_view = new CBBToolEleOptionView(default_select_pack, default_select_type, this, @add_count)
    @store_select[@add_count] = tmp_view
    @add_count += 1
    @tmp_contrainer.append tmp_view

  get_setting_val: ->
    tmp_len = 0
    tmp_re_list = {}

    for c_id, tmp_view of @store_select
      tmp_re = tmp_view.get_option_val()
      tmp_len+=1
      if tmp_type_list = tmp_re_list[tmp_re.pack_name]
        tmp_type = tmp_re.type_name
        unless tmp_type_list.indexOf(tmp_type) >= 0
          tmp_re_list[tmp_re.pack_name].push tmp_type
      else
        tmp_re_list[tmp_re.pack_name] = [tmp_re.type_name]

    {name: @count, val:tmp_re_list, length:tmp_len}

  remove_element: (view_id) ->
    delete @store_select[view_id]
