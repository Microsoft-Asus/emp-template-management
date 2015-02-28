{View} = require 'atom-space-pen-views'
emp = require '../exports/emp'
# {Subscriber} = require 'emissary'


module.exports =
class ComponmentEleView extends View
  # Subscriber.includeInto(this)

  @content: ({name, version, path, desc, logo}) ->
    @li class:'two-lines ccb_li_view', click: 'do_click', =>
      # @div class:'avatar'
      @div class: 'temp_logo', =>
        # @a outlet: 'avatarLink', href: "https://atom.io/users/#{owner}", =>
        @img outlet: 'logo_img', class: 'avatar', src: "#{logo}", #click:'image_format'
      @div class: 'temp_name', =>
        @h4 class:'name_header', "#{name}"
        @span class:'name_detail' ,"#{desc}"

  initialize: (@com) ->
    # It might be useful to either wrap @pack in a class that has a ::validate
    # method, or add a method here. At the moment I think all cases of malformed
    # package metadata are handled here and in ::content but belt and suspenders,
    # you know

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

  do_click: ->
    console.log @com
    html_temp = @com.html
    file_con = fs.readFileSync html_temp
    editor = atom.workspace.getActiveEditor()
    if editor
