{$, $$, ScrollView, TextEditorView} = require 'atom-space-pen-views'
{Disposable, CompositeDisposable} = require 'atom'
CSON = require 'cson'
toc = require 'markdown-toc'
open = require 'open'
emp = require '../exports/emp'
fs = require 'fs'
path = require 'path'

remote = require 'remote'
dialog = remote.require 'dialog'
fs_plus = require 'fs-plus'
fuzzaldrin = require 'fuzzaldrin'

setting_pack_main_path = ''
setting_pack_dir = ''
PackageManager =  ''
ownerFromRepository = ''
packageComparatorAscending = ''
List = ''
ListView = ''
PackageView = ''
PackageKeymapsView = ''

module.exports =
class EmpKeymapsManView extends ScrollView

  @content: ->
    @div class: 'emp-template-management pane-item', tabindex: -1, =>

      @div class: 'panels', outlet: 'panels', =>
        @section class: 'section', =>
          @div class: 'section-container', =>
            @div class: 'section-heading icon icon-package', =>
              @text 'Installed Packages'
              @span outlet: 'totalPackages', class: 'section-heading-count badge badge-flexible', '…'
            @div class: 'editor-container', =>
              @subview 'filterEditor', new TextEditorView(mini: true, placeholderText: 'Filter packages by name')

            @section class: 'sub-section installed-packages', =>
              @h3 class: 'sub-section-heading icon icon-package', =>
                @text 'Community Packages'
                @span outlet: 'communityCount', class: 'section-heading-count badge badge-flexible', '…'
              @div outlet: 'communityPackages', class: 'container package-container', =>
                @div class: 'alert alert-info loading-area icon icon-hourglass', "Loading packages…"

  initialize: ({@uri}={}) ->
    super

    setting_pack_main_path = atom.packages.activePackages["settings-view"].mainModulePath
    setting_pack_dir = path.dirname setting_pack_main_path
    PackageManager =  require path.join(setting_pack_dir, 'package-manager')
    {ownerFromRepository, packageComparatorAscending} =  require path.join(setting_pack_dir, 'utils')
    List =  require path.join(setting_pack_dir, 'list')
    ListView =  require path.join(setting_pack_dir, 'list-view')
    PackageView =  require './package-view'
    PackageKeymapsView =  require './package-keymaps-view'

    @package_manager = new PackageManager()

    @keymaps_view = new PackageKeymapsView()
    @panels.after @keymaps_view
    @filterEditor.getModel().onDidStopChanging => @match_packages()
    @items =
      user: new List('name')
    @item_views =
      user: new ListView(@items.user, @communityPackages, @createPackageCard)

    @load_packages()

  load_packages: ->
    @package_manager.getInstalled()
      .then (packages) =>
        @packages = @sortPackages(@filterPackages(packages))

        @communityPackages.find('.alert.loading-area').remove()
        @items.user.setItems(@packages.user)

      .catch (error) =>
        console.error error.message, error.stack
        @loadingMessage.hide()
        @featuredErrors.append(new ErrorView(@package_manager, error))

  sortPackages: (packages) ->
    packages.user.sort(packageComparatorAscending)
    packages

  filterPackages: (packages) ->
    packages.user = packages.user.filter ({theme}) -> not theme

    for package_type in ['user']
      for pack in packages[package_type]
        # console.log pack
        pack.owner = ownerFromRepository(pack.repository)

    packages

  createPackageCard: (pack) =>
    packageRow = $$ -> @div class: 'row'
    packView = new PackageView(pack, @package_manager, @keymaps_view)
    packageRow.append(packView)
    packageRow

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    deserializer: emp.KEYMAP_WIZARD_VIEW
    version: 1
    activePanelName: emp.KEYMAP_WIZARD_VIEW
    uri: @uri


  focus: ->
    # super
    @filterEditor.focus()

  getUri: ->
    @uri

  getTitle: ->
    "Create An EMP App Wizard"

  isEqual: (other) ->
    other instanceof EmpKeymapsManView

  match_packages: ->
    filterText = @filterEditor.getModel().getText()
    @filter_package_list_by_text(filterText)

  filter_package_list_by_text: (text) ->
    return unless @packages

    for package_type in ['user']
      all_views = @item_views[package_type].getViews()
      active_views = @item_views[package_type].filterViews (pack) ->
        return true if text is ''
        # owner = pack.owner ? ownerFromRepository(pack.repository)
        filterText = "#{pack.name}" ##{owner}
        fuzzaldrin.score(filterText, text) > 0

      for view in all_views when view
        view.find('.package-card').hide().addClass('hidden')
      for view in active_views when view
        view.find('.package-card').show().removeClass('hidden')
