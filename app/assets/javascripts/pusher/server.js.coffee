class window.Shake.Server
  init: ->
    vent = Shake.getVent()

    game = Shake.Game

    game.Players.bind 'add', (player) ->
      $('.dpl-actor').append $('<img>').attr('src', player.twitterAvatarUrl())

    vent.bind 'pusher:subscription_succeeded', =>
      vent.bind 'client-player:register', @onRegister

  onRegister: (user_id) =>
    Shake.Game.registerPlayer user_id
