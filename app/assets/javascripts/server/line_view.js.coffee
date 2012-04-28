class Line extends Backbone.View
  tagName: 'li'

  render: =>
    @$el.text(@options.line.text)
    @

class Shake.ServerViews.Lines extends Backbone.View
  initialize: ->
  	@options.players.bind 'deliver', (data) =>
  	  @render data.lines

  render: (lines) =>
  	$(@el).empty()
  	_.each lines, (line) =>
  		lineView = new Line({line: line})
  		@$el.append lineView.render().el
