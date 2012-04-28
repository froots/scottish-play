class window.Shake.Server
  init: ->
    vent = Shake.getVent()
    vent.bind 'pusher:subscription_succeeded', ->
      vent.bind 'client-player:register', (user_id) ->
        Shake.Game.players.push user_id
