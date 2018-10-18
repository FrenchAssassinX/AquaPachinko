local composer = require "composer"

display.setStatusBar( display.HiddenStatusBar )

local musique = audio.loadStream( "musiques/maintheme.ogg" )

audio.play( musique, { loop=-1 } )

composer.gotoScene( "scenemenu" )