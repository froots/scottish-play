Shake.ServerViews ||= {}

class Shake.ServerViews.Feed extends Backbone.View
  render: ->
    $(@el).append $('<h1>').text 'feed'

