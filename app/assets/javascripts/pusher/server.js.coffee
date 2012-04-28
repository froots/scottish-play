class window.Shake.Server
  vent = null
  
  init: ->
    vent = Shake.getVent()

    game = Shake.Game

    game.Players.bind 'add', (player) ->
      $('.dpl-actor').append $('<img>').attr('src', player.twitterAvatarUrl())

    vent.bind 'pusher:subscription_succeeded', =>
      vent.bind 'client-player:register', @onRegister

  onRegister: (user_id) =>
    Shake.Game.registerPlayer user_id

  startGame: ->
    vent.trigger('client-scene:start', 'starting')
    Shake.Game.loadNextParagraph()
    character = Shake.Game.getCurrentCharacter()
    vent.trigger('client-player:deliver', { user_id: character.get('actor'), lines: Shake.Game.currentParagraph.lines })