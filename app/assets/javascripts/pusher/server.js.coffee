class window.Shake.Server
  init: ->
    vent = Shake.Vent
    vent.bind 'pusher:subscription_succeeded', ->
      vent.bind 'client-player:register', (user_id) ->
        alert user_id
        #Shake.Game.players.push user_id
