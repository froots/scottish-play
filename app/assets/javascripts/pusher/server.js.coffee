class window.Shake.Server
  init: ->
    vent = Shake.Vent
    vent.bind 'pusher:subscription_succeeded', ->
      vent.bind 'client-login', (d) ->
        Shake.players.push d
        console.log d