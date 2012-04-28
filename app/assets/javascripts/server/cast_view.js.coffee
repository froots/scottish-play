Shake.ServerViews ||= {}

class Shake.ServerViews.Cast extends Backbone.View

  render: ->
    $(@el).append $("<h1>").text('cast')
