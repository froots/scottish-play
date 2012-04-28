Shake.ServerViews ||= {}

class Shake.ServerViews.Feed extends Backbone.View
  tagName: 'ul'
    
  initialize: ->
    Shake.Vent.bind 'client-player:hurl', (data) =>
      feedItem = $('<li>').text "@#{data.user_id} hurled a #{data.object}"
      $(@el).prepend feedItem

    Shake.Vent.bind 'client-player:register', (data) =>
      feedItem = $('<li>').text "@#{data.user_id} entered the theatre"
      $(@el).prepend feedItem

  render: =>
    @
