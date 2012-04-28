class window.Shake.Server
  vent = null
  
  init: ->
    vent = Shake.getVent()

    game = Shake.Game

    game.Players.bind 'add', (player) ->
      $('.dpl-actor').append $('<img>').attr('src', player.twitterAvatarUrl())

    vent.bind 'pusher:subscription_succeeded', =>
      vent.bind 'client-player:register', @onRegister
      vent.bind 'client-player:exunt', @onNextPlayer
      vent.bind 'client-player:hurl', @onHurl

  onRegister: (user_id) =>
    Shake.Game.registerPlayer user_id

  startGame: ->
    vent.trigger('client-scene:start', 'starting')
    Shake.Game.loadNextParagraph()
    @sendCurrentParagraph()

  sendCurrentParagraph: ->
    character = Shake.Game.getCurrentCharacter()
    console.log 'sending paragraph to', character.get('actor')
    vent.trigger('client-player:deliver', { user_id: character.get('actor'), lines: Shake.Game.currentParagraph.lines })

  onNextPlayer: =>
    if Shake.Game.loadNextParagraph()
      @sendCurrentParagraph()
    else
      @endGame

  onHurl: (data) =>
    console.log data.user_id, 'hurled', data.object

  endGame: ->
    vent.trigger('client-scene:end', {})