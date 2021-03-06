Shake.ServerViews ||= {}

class CastMember extends Backbone.View
  tagName: 'span'
  className: 'cast-member'

  initialize: ->
    Shake.Game.Players.bind 'deliver', (data) =>
      if data.user_id == @options.model.get('user_id')
        @animate('activate')
      else
        @animate('restore')

    Shake.Game.Players.bind 'veg', (data) =>
      if data.user_id == @options.model.get('user_id')
        @splat()

    Shake.Game.Players.bind 'flowers', (data) =>
      if data.user_id == @options.model.get('user_id')
        @flowers()

  animate: (state) =>
    width = @$('img').width()
    animateState = {bottom: 20}
    defaultState = {bottom: 0}
    if state == 'activate'
      $(@el).css animateState
    else
      $(@el).css defaultState

  render: =>
    img = $('<img>').attr('src', @options.model.twitterAvatarUrl()).addClass('avatar').bind 'load', =>
      @dimensions = {height: @$el.height(), width: @$el.width()}

    char = @options.model.get('character').toLowerCase()
    char += "-mac" if char == "porter"

    characterImg = $('<img>').attr('src', "/assets/characters/#{char}.png")
    characterImg.addClass('cast-character')
    $(@el).append(img)
    $(@el).append(characterImg)
    @

  splat: =>
  	top = Math.floor(Math.random() * ((@dimensions.height - 23) + 1))
  	left = Math.floor(Math.random() * ((@dimensions.width - 30) + 1))
  	@$el.append $('<img class="decoration splat" src="/assets/splat.png" />').css({left: left, top: top})
  	Shake.Sounds.playSound 'fart'

  flowers: =>
    noFlowers = @$el.find('.flower').length
    left = 20 * (noFlowers % 4)
    if (left > @dimensions.width)
      left = 0
    top = 23 * Math.floor(noFlowers / 4)
    @$el.append $('<img class="decoration flower" src="/assets/flowers.png" />').css({left: left, top: top})
    Shake.Sounds.playSound 'pop'

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
