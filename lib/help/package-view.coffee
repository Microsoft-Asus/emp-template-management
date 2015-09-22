{$, $$$, View} = require 'atom-space-pen-views'
_ = require 'underscore-plus'
emp = require '../exports/emp'
remote = require 'remote'
dialog = remote.require 'dialog'
path = require 'path'
fs = require 'fs'

module.exports =
class PackageView extends View

  @content: ({name, description, version, repository}) ->
    # console.log name, description, version, repository
    # temp_path = atom.project.templates_path
    # if tmp_logo= @package_obj.logo
    #   tmp_logo = path.join temp_path,tmp_logo
    # else
    #   tmp_logo= emp.get_default_logo()
    # unless tmp_desc = @package_obj.desc
    #   tmp_desc = emp.EMP_DEF_DESC
    # owner = ''
    owner = owner_from_repository(repository)
    description ?= ''

    @div outlet:'pack_card', click:'show_keymaps', class: 'package-card available-package-view col-lg-8', =>
      @div class: 'stats pull-right', =>
        @span class: "stats-item", =>
          @span class: 'icon icon-versions'
          @span outlet: 'versionValue', class: 'value', String(version)

      @div class: 'body', =>
        @h4 class: 'card-name', =>
          @a outlet: 'packageName', name
          @span ' '
        @span outlet: 'packageDescription', class: 'package-description', description
        @div outlet: 'packageMessage', class: 'package-message'

      @div class: 'meta', =>
        @div class: 'meta-user', =>
          @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
            @img outlet: 'avatar', class: 'avatar', src: 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7' # A transparent gif so there is no "broken border"
          @a outlet: 'loginLink', class: 'author', href: "https://atom.io/users/#{owner}", owner
        # @div class: 'meta-controls', =>
        #   @div class: 'btn-toolbar', =>
        #     @div outlet: 'updateButtonGroup', class: 'btn-group', =>
        #       @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'updateButton', 'Update'
        #     @div outlet: 'installAlternativeButtonGroup', class: 'btn-group', =>
        #       @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'installAlternativeButton', 'Install Alternative'
        #     @div outlet: 'installButtonGroup', class: 'btn-group', =>
        #       @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'installButton', 'Install'
        #     @div outlet: 'packageActionButtonGroup', class: 'btn-group', =>
        #       @button type: 'button', class: 'btn icon icon-gear settings',             outlet: 'settingsButton', 'Settings'
        #       @button type: 'button', class: 'btn icon icon-trashcan uninstall-button', outlet: 'uninstallButton', 'Uninstall'
        #       @button type: 'button', class: 'btn icon icon-playback-pause enablement', outlet: 'enablementButton', =>
        #         @span class: 'disable-text', 'Disable'
        #       @button type: 'button', class: 'btn status-indicator', tabindex: -1, outlet: 'statusIndicator'


      # @div class: 'meta', =>
      #   @div class: 'meta-user', =>
      #     # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
      #     @img outlet: 'logo_img', class: 'avatar', src: "#{tmp_logo}", click:'image_format'  # A transparent gif so there is no "broken border"
      #     # @a outlet: 'loginLink', class: 'author', href: "https://atom.io/users/#{owner}", owner
      #   @div class: 'meta-controls', =>
      #     # @div class: 'btn-group', =>
      #     #   @button type: 'button', class: 'btn btn-info icon icon-cloud-download install-button', outlet: 'installButton', 'Install'
      #     @div outlet: 'buttons', class: 'btn-group', =>
      #       @button type: 'button', class: 'btn icon icon-gear', outlet: 'edit_button', click:'do_edit_css', 'Edit Css'
      #       @button type: 'button', class: 'btn icon icon-gear', outlet: 'edit_button', click:'do_edit', 'Edit Pack'
      #       if @package_obj.name isnt emp.EMP_DEFAULT_PACKAGE
      #         @button type: 'button', class: 'btn icon icon-trashcan', outlet: 'uninstall_button', click:'do_uninstall', 'Uninstall'
      #       @button type: 'button', class: 'btn icon icon-repo', outlet: 'detail_utton', click:'show_detail', 'Detail'
      #       # @button type: 'button', class: 'btn status-indicator', tabindex: -1, outlet: 'statusIndicator'

  initialize: (@pack, @package_manager, @keymaps_view) ->
    {@name, description, version, @repository}=@pack
    @cbb_management = atom.project.cbb_management
    # console.log @pack
    @loadPackage()

  loadPackage: ->
    if loadedPackage = atom.packages.getLoadedPackage(@pack.name)
      @pack = loadedPackage
      # console.log @pack



  show_keymaps: ->
    console.log "show keymaps #{name}"
    other_platform_pattern = new RegExp("\\.platform-(?!#{_.escapeRegExp(process.platform)}\\b)")

    new_key_binding = new Array()
    for key_binding in atom.keymaps.getKeyBindings()
      {command, keystrokes, selector} = key_binding
      continue unless command?.indexOf?("#{@name}:") is 0
      continue if other_platform_pattern.test(selector)
      new_key_binding.push key_binding

    item_length = @keymaps_view.add_items(@pack, new_key_binding)
    # unless item_length < 1
    #   @load_keymap_file()


  load_keymap_file: ->
    if pack_path = @pack.path
      keymaps_file = path.join pack_path, 'keymaps', @name+".cson"
      console.log keymaps_file
      if fs.existsSync keymaps_file
        keyma_obj = atom.keymaps.readKeymap(keymaps_file)
        console.log keyma_obj

  detached: ->
    # @unsubscribe()

owner_from_repository = (repository) ->
  return '' unless repository
  loginRegex = /github\.com\/([\w-]+)\/.+/
  if typeof(repository) is "string"
    repo = repository
  else
    repo = repository.url
    if repo.match 'git@github'
      repoName = repo.split(':')[1]
      repo = "https://github.com/#{repoName}"
  repo.match(loginRegex)?[1] ? ''
