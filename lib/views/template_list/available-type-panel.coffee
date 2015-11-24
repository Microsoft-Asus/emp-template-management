# _ = require 'underscore-plus'
{View} = require 'atom-space-pen-views'
emp = require '../../exports/emp'
# {Subscriber} = require 'emissary'
# shell = require 'shell'
logo_image_size = '48px'
logo_image_big_size = '156px'

AvailableTemplatePanel = require './available-template-panel'

# package 下的 type 集合, 该集合下位 template 的具体内容
module.exports =
class AvailableTypePanel extends View
  # Subscriber.includeInto(this)

  @content: (type, pack) ->
    @section outlet:'package_list', class: 'sub-section installed-packages', =>
      # @h3 class: 'sub-section-heading icon icon-package', =>
      #   @text 'Packages:type'
      #   @span outlet: 'templateCount', class:'section-heading-count', ' (…)'
      @div class: 'section-heading icon icon-package', =>
        @text "Packages Type: #{type}"
        @span outlet: 'totalPackages', class:'section-heading-count', ' (…)'

      @div outlet: 'template_element', class: 'container package-container', =>
        @div class: 'alert alert-info loading-area icon icon-hourglass', "No CBB Element"


  initialize: (@type, @pack) ->
    @ele_panels = []
    # @cbb_management = atom.project.cbb_management
    @refresh_detail()

  refresh_detail:() ->
    # console.log "do refresh"
    # @title.text("#{_.undasherize(_.uncamelcase(@pack.name))}")
    @loadTemplates()

  loadTemplates: ->
    # console.log "loadTemplates1"
    if ele_list = @pack.get_element(@type)
      @template_element.empty()
      # console.log ele_list
      for ele, ele_obj of ele_list
        # console.log ele_obj
        ele_panel = new AvailableTemplatePanel(ele_obj, this, @pack, @type)
        @ele_panels.push ele_panel
        @template_element.append ele_panel



    # for pack, index in packages
    #   packageRow = $$ -> @div class: 'row'
    #   container.append(packageRow)
    #   packView = new AvailablePackageView(pack, @packageManager, {back: 'Packages'})
    #   packageViews.push(packView) # used for search filterin'
    #   packageRow.append(packView)
    # packages = @cbb_management.get_pacakges()
    # console.log @pack

    #
    # console.log packages
    # for ccb_name,ccb_obj of packages
    #   # tmp_obj = @cbb_management.get_package_obj(ccb_name)
    #   tempRow = $$ -> @div class: 'row'
    #   @templatePackages.append tempRow
    #   # name, description, version, repository
    #   # tempView = new AvailableTemplateView(tmp_obj)
    #   tempView = new AvailablePackageView(this, ccb_obj)
    #   tempRow.append tempView
