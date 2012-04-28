class window.Shake.Soundplayer
  #baseDir = 'http://www.beano.com/content/audio/'
  baseDir = '/audio/'

  playSound: (sound) ->
  	soundFile = baseDir + sound + '.ogg'
  	$('<div class="jplayer" />').appendTo('body').jPlayer({
  		supplied: 'ogv',
  		oggSupport: true
	  }).jPlayer("setMedia", {ogv: soundFile}).jPlayer("play")