Shake.ServerViews ||= {}

class CastMember extends Backbone.View
  tagName: 'span'

  initialize: ->
    Shake.Game.Players.on 'deliver', (user_id) =>
      if user_id == @options.model.get('user_id')
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
    $(@el).append $('<h1>').text('cast')

  addOne: (player) =>
    playerView = new CastMember(model: player)
    $(@el).append playerView.render().el
