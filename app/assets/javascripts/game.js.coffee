class Player extends Backbone.Model
  defaults:
    user_id: ''
    role: ''
    character: null

  initialize: ->
    @bind 'change', =>
      @updateClient("player:assignRole", {role: @get('role'), character: @get('character')})

  twitterAvatarUrl: =>
    "http://twitter.com/api/users/profile_image/#{@get('user_id')}?size=bigger"

  assignRole: (role, character) =>
    if character
      @set({role, character})
    else
      @set({role})

  
  updateClient: (eventName, data) =>
    vent = Shake.Vent
    data.user_id = @get('user_id')
    vent.trigger "client-#{eventName}", data

class Players extends Backbone.Collection
  model: Player
  

class Character extends Backbone.Model
  defaults:
    actor: null

class Characters extends Backbone.Collection
  model: Character
  
  withoutActors: ->
    @select (c) -> !c.get('actor')
  
  
Game = {}
Game.Characters = new Characters
Game.Scene = {}
Game.Players = new Players

Game.registerPlayer = (user_id) ->
  player = new Player({user_id})
  
  freeCharacters = Game.Characters.withoutActors()
  if _.any(freeCharacters)
    character = freeCharacters.pop()
    character.set({actor: user_id})
    player.assignRole('cast', character.get('name'))
  else
    player.assignRole('audience')
  Game.Players.add player

Game.loadNextParagraph = ->
  Game.currentParagraph = Game.Scene.paragraphs.pop()
  
  while Game.currentParagraph.character_id == null
    Game.currentParagraph = Game.Scene.paragraphs.pop()

  Game.currentParagraph != null

Game.getCurrentCharacter = ->
  Game.Characters.get Shake.Game.currentParagraph.character_id

window.Shake.Game = Game
