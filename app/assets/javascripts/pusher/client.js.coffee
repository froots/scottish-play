class window.Shake.Client
  init: ->
    vent = Shake.Vent
    vent.bind 'pusher:subscription_succeeded', ->
      me = vent.members.me

      vent.trigger "client-login", me.info.name


