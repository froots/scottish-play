do ->
  pusher = new Pusher('aa16fedd0ca224252c4d')
  window.Shake.Vent = pusher.subscribe('presence-shake-channel')
