Shake.ServerViews ||= {}

class AudienceMember extends Backbone.View
  tagName: 'span'

  initialize: ->
    Shake.Vent.bind 'client-player:hurl', (data) =>
      if data.user_id == @options.model.get('user_id')
        @animate()

  animate: =>
    @$('img').animate {width: 150}, -> $(this).animate({width: 100})

  render: =>
    img = $('<img>').attr('src', @options.model.twitterAvatarUrl())
    $(@el).append img
    @

class Shake.ServerViews.Audience extends Backbone.View
  initialize: ->
    @options.players.bind "add", (player) =>
      if player.get('role') == 'audience'
        @addOne(player)
    
  render: =>
    $(@el).append $('<h1>').text('audience')

  addOne: (player) =>
    playerView = new AudienceMember(model: player)
    $(@el).append playerView.render().el
