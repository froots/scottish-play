Shake.ServerViews ||= {}

class AudienceMember extends Backbone.View
  tagName: 'span'
  className: 'audience-member'

  initialize: ->
    Shake.Vent.bind 'client-player:hurl', (data) =>
      if data.user_id == @options.model.get('user_id')
        @animate(data.object)

  animate: (obj) =>
    animateAttrs = {width: 100, right: 0, bottom: 0}
    if obj == 'veg'
      @$('.tomato').animate animateAttrs, 400, (-> $(this).css({width: 0, right: 10, bottom: 10}))
    if obj == 'flowers'
      @$('.flowers').animate animateAttrs, 400, (-> $(this).css({width: 0, right: 10, bottom: 10}))

  render: =>
    img = $('<img>').attr('src', @options.model.twitterAvatarUrl())
    tomato = $('<img>').addClass('tomato').attr('src', '/assets/tomato.png')
    flowers = $('<img>').addClass('flowers').attr('src', '/assets/flowers.png')

    $(@el).append img
    $(@el).append tomato
    $(@el).append flowers
    @

class Shake.ServerViews.Audience extends Backbone.View
  initialize: ->
    @options.players.bind "add", (player) =>
      if player.get('role') == 'audience'
        @addOne(player)
    
  render: =>
    @

  addOne: (player) =>
    playerView = new AudienceMember(model: player)
    $(@el).append playerView.render().el
