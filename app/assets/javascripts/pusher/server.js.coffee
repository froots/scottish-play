class window.Shake.Server
  init: ->
    vent = Shake.Vent
    vent.bind 'pusher:subscription_succeeded', ->
      vent.bind 'client-login', (d) ->
        alert "#{d} has entered the theatre"
