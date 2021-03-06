class window.Shake.Server
  vent = null
  
  init: ->
    vent = Shake.getVent()
    game = Shake.Game
    @scores = {}

    vent.bind 'pusher:subscription_succeeded', =>
      vent.bind 'client-player:register', @onRegister
      vent.bind 'client-player:exeunt', @onNextPlayer
      vent.bind 'client-player:hurl', @onHurl
      
      Shake.Game.Players.bindScores()

  onRegister: (data) =>
    Shake.Game.registerPlayer {user_id: data.user_id}

  startGame: ->
    vent.trigger('client-scene:start', 'starting')
    Shake.Game.Paragraphs = _.clone(window.Data.Paragraphs)
    Shake.Game.loadNextParagraph()
    @sendCurrentParagraph()

  sendCurrentParagraph: ->
    character = Shake.Game.getCurrentCharacter()
    data = { user_id: character.get('actor'), lines: Shake.Game.currentParagraph.lines }

    console.log 'sending paragraph to', data.user_id
    vent.trigger('client-player:deliver', data)
    Shake.Game.Players.trigger 'deliver', data

  onNextPlayer: =>
    if Shake.Game.loadNextParagraph()
      @sendCurrentParagraph()
    else
      @endGame

  onHurl: (data) =>
    console.log data.user_id, 'hurled', data.object

  endGame: ->
    vent.trigger('client-scene:end', Shake.Game.Players.scores)
