{View} = require 'atom-space-pen-views'
emp = require '../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'

logo_image_size = '48px'
logo_image_big_size = '156px'

module.exports =
class AvailablePackageView extends View

  @content: (@package_obj) ->
    console.log @package_obj
    # stars, downloads
    # lol wat
    # owner = AvailablePackageView::ownerFromRepository(repository)
    # console.log name, description, version, repository
    # owner = "jcrom"
    # description ?= ''
    # console.log emp.get_default_logo()
    unless tmp_logo= @package_obj.logo
      tmp_logo= emp.get_default_logo()

    unless tmp_desc = @package_obj.desc
      tmp_desc = emp.EMP_DEF_DESC

    @div class: 'available-package-view col-lg-8', =>
      @div class: 'stats pull-right', =>
        @span class: "stats-item", =>
          @span class: 'icon icon-versions'
          # @span class:'value', version

        # @span class: 'stats-item', =>
        #   @span class: 'icon icon-cloud-download'
        #   @span outlet: 'downloadCount', class: 'value'

      @div class: 'body', =>
        @h4 class: 'card-name', =>
          @a outlet: 'packageName', @package_obj.name
        @span outlet: 'packageDescription', class: 'package-description', tmp_desc

      @div class: 'meta', =>
        @div class: 'meta-user', =>
          # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
          @img outlet: 'logo_img', class: 'avatar', src: "#{tmp_logo}", click:'image_format'  # A transparent gif so there is no "broken border"
          # @a outlet: 'loginLink', class: 'author', href: "https://atom.io/users/#{owner}", owner
        @div class: 'meta-controls', =>
          # @div class: 'btn-group', =>
          #   @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'installButton', 'Install'
          @div outlet: 'buttons', class: 'btn-group', =>
            @button type: 'button', class: 'btn icon icon-gear', outlet: 'edit_button', click:'do_edit', 'Edit'
            @button type: 'button', class: 'btn icon icon-trashcan', outlet: 'uninstall_button', click:'do_uninstall', 'Uninstall'
            @button type: 'button', class: 'btn icon icon-playback-pause', outlet: 'enablement_utton', =>
              @span class: 'disable-text', 'Disable'
            @button type: 'button', class: 'btn status-indicator', tabindex: -1, outlet: 'statusIndicator'

  initialize: (@package_obj) ->
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
    console.log tmp_flag
    if tmp_flag
      console.log "do"
      @cbb_management.delete_package(@package_obj.name)


  show_alert: (replace_con, relative_path, editor) ->
    atom.confirm
      message: '警告'
      detailedMessage: '是否确定要删除该模板集?'
      buttons:
        '同时删除文件': -> return 1
        '是': -> return 2
        '否': -> return 3
