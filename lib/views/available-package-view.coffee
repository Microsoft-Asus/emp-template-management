
{View} = require 'atom-space-pen-views'
emp = require '../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'
fs = require 'fs'
path = require 'path'

logo_image_size = '48px'
logo_image_big_size = '156px'

module.exports =
class AvailablePackageView extends View

  @content: (@fa_view, @package_obj) ->
    # console.log @package_obj
    temp_path = atom.project.templates_path
    if sLogo= @package_obj.logo
      sLogo = emp.get_sep_path sLogo
      sLogo = path.join temp_path,sLogo
      unless fs.existsSync sLogo
        sLogo= emp.get_default_logo()
    else
      sLogo= emp.get_default_logo()
    unless tmp_desc = @package_obj.desc
      tmp_desc = emp.EMP_DEF_DESC

    @div class: 'available-package-view col-lg-8', =>
      @div class: 'stats pull-right', =>
        @span class: "stats-item", =>
          @span class: 'icon icon-versions'
      @div class: 'body', =>
        @h4 class: 'card-name', =>
          @a outlet: 'packageName', click:'show_detail', @package_obj.name
        @span outlet: 'packageDescription', class: 'package-description', tmp_desc

      @div class: 'meta', =>
        @div class: 'meta-user', =>
          # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
          @img outlet: 'logo_img', class: 'avatar', src: "#{sLogo}", click:'image_format'  # A transparent gif so there is no "broken border"
          # @a outlet: 'loginLink', class: 'author', href: "https://atom.io/users/#{owner}", owner
        @div class: 'meta-controls', =>
          # @div class: 'btn-group', =>
          #   @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'installButton', 'Install'
          @div outlet: 'buttons', class: 'btn-group', =>
            @button type: 'button', class: 'btn icon icon-gear', outlet: 'edit_button', click:'do_edit_css', 'Edit Css'
            @button type: 'button', class: 'btn icon icon-gear', outlet: 'edit_button', click:'do_edit', 'Edit Pack'
            if @package_obj.name isnt emp.EMP_DEFAULT_PACKAGE
              @button type: 'button', class: 'btn icon icon-trashcan', outlet: 'uninstall_button', click:'do_uninstall', 'Uninstall'
            # @button type: 'button', class: 'btn icon icon-eye-watch', outlet: 'check_cbb', click:'do_cbb_check', 'Check CBB'
            @button type: 'button', class: 'btn icon icon-repo', outlet: 'detail_utton', click:'show_detail', 'Detail'

            # @button type: 'button', class: 'btn status-indicator', tabindex: -1, outlet: 'statusIndicator'

  initialize: (@fa_view, @package_obj) ->
    @cbb_management = atom.project.cbb_management



  image_format: ->
    # console.log 'image_format'
    # console.log @logo_img.css('height')
    if @logo_img.css('height') is emp.LOGO_IMAGE_SIZE
      @logo_img.css('height', emp.LOGO_IMAGE_BIG_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_BIG_SIZE)
    else
      @logo_img.css('height', emp.LOGO_IMAGE_SIZE)
      @logo_img.css('width', emp.LOGO_IMAGE_SIZE)



  detached: ->
    # @unsubscribe()

  do_uninstall: ->
    tmp_flag = @show_alert()
    # console.log tmp_flag
    switch tmp_flag
      when 1
        console.log "1"
        @cbb_management.delete_package_detail(@package_obj.name)
        emp.show_info "删除成功！"
        @fa_view.refresh_detail()
      when 2
        console.log "2"
        @cbb_management.delete_package(@package_obj.name)
        emp.show_info "删除成功！"
        @fa_view.refresh_detail()
      else return

  do_edit:->
    console.log 'do_edit'
    @fa_view.show_edit_panel(@package_obj)

  do_edit_css: ->
    css_file = @cbb_management.get_common_css(@package_obj.name)
    emp.create_editor(css_file, emp.EMP_GRAMMAR_CSS)

  do_cbb_check: ->
    console.log "do check"
    @package_obj.check_path()
    # @cbb_management.check_cbb_list(@package_obj.name)

  show_alert: (replace_con, relative_path, editor) ->
    atom.confirm
      message: '警告'
      detailedMessage: '是否确定要删除该模板集?'
      buttons:
        '同时删除文件': -> return 1
        '是': -> return 2
        '否': -> return 3

  show_detail:->
    @parents('.emp-template-management').view()?.showPanel(emp.EMP_CCB_PACK_DETAIL, {back: emp.EMP_TEMPLATE}, @package_obj)
