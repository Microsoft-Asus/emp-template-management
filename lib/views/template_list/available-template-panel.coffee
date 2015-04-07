# _ = require 'underscore-plus'
{View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'
# {Subscriber} = require 'emissary'
# shell = require 'shell'
logo_image_size = '48px'
logo_image_big_size = '156px'

module.exports =
class AvailableTemplatePanel extends View
  # Subscriber.includeInto(this)

  @content: (element) ->
    logo = element.logo
    if !logo
      logo = emp.get_default_logo()
    else
      logo = path.join(atom.project.templates_path, logo)

    # stars, downloads
    # lol wat
    # owner = AvailablePackageView::ownerFromRepository(repository)
    # console.log name, description, version, repository
    # owner = "jcrom"
    # description ?= ''
    @div class: 'row', =>
      @div class: 'available-package-view col-lg-8', =>
        @div class: 'stats pull-right', =>
          @span class: "stats-item", =>
            @span class: 'icon icon-versions'
            @span class:'value', element.version

          # @span class: 'stats-item', =>
          #   @span class: 'icon icon-cloud-download'
          #   @span outlet: 'downloadCount', class: 'value'

        @div class: 'body', =>
          @h4 class: 'card-name', =>
            @a outlet: 'packageName', element.name
          @span outlet: 'packageDescription', class: 'package-description', element.desc

        @div class: 'meta', =>
          @div class: 'meta-user', =>
            # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
            @img outlet: 'logo_img', class: 'avatar', src: "#{logo}", click:'image_format'  # A transparent gif so there is no "broken border"
            # @a outlet: 'loginLink', class: 'author', href: "https://atom.io/users/#{owner}", owner
          @div class: 'meta-controls', =>
            # @div class: 'btn-group', =>
            #   @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'installButton', 'Install'
            @div outlet: 'buttons', class: 'btn-group', =>
              @button type: 'button', class: 'btn icon icon-gear',           outlet: 'edit_button', click:'do_edit', 'Edit'
              @button type: 'button', class: 'btn icon icon-trashcan',       outlet: 'uninstall_button', click:'do_uninstall', 'Uninstall'
              # @button type: 'button', class: 'btn icon icon-playback-pause', outlet: 'enablement_utton', =>
              #   @span class: 'disable-text', 'Disable'
              # @button type: 'button', class: 'btn status-indicator', tabindex: -1, outlet: 'statusIndicator'

  initialize: (@element, @fa_view, @pack, @type) ->
    @cbb_management = atom.project.cbb_management

  image_format: ->
    console.log 'image_format'
    console.log @logo_img.css('height')
    if @logo_img.css('height') is emp.LOGO_IMAGE_SIZE
      # @logo_img.css('height', logo_image_big_size)
      # @logo_img.css('width', logo_image_big_size)
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
        # console.log "1"
        @pack.delete_element_detail(@element.name, @type)
        emp.show_info "删除成功！"
        @fa_view.refresh_detail()
      when 2
        # console.log "2"
        @pack.delete_element(@element.name, @type)
        emp.show_info "删除成功！"
        @fa_view.refresh_detail()
      else return

  show_alert: (replace_con, relative_path, editor) ->
    atom.confirm
      message: '警告'
      detailedMessage: '是否确定要删除该模板文件?'
      buttons:
        '同时删除文件': -> return 1
        '是': -> return 2
        '否': -> return 3

  do_edit: ->
    console.log "do_edit"
