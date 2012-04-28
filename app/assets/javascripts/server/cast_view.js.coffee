Shake.ServerViews ||= {}

class CastMember extends Backbone.View
  tagName: 'span'
  className: 'cast-member'

  initialize: ->
    Shake.Game.Players.bind 'deliver', (data) =>
      if data.user_id == @options.model.get('user_id')
        @animate()

  animate: =>
    width = @$('img').width()
    @$('img').animate {width: 150, 100}, -> $(this).animate({width: width, 200})

  render: =>
    img = $('<img>').attr('src', @options.model.twitterAvatarUrl())
    $(@el).append img
    @

class Shake.ServerViews.Cast extends Backbone.View
  initialize: ->
    @options.players.bind "add", (player) =>
      if player.get('role') == 'cast'
        @addOne(player)
    
  render: =>
    @

  addOne: (player) =>
    playerView = new CastMember(model: player)
    $(@el).append playerView.render().el
