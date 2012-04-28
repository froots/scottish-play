
window.Shake.getVent = ->
  pusher = new Pusher('aa16fedd0ca224252c4d')
  Shake.Vent ||= pusher.subscribe('presence-shake-channel')
