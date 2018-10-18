local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.pause()
--Permet de voir la physique des objets à l'écran
--physics.setDrawMode("debug")
physics.setDrawMode("hybrid")

local globalView
local racket
local ball
local score
local nbBalls
local labelScore
local labelBall
local OnCollisionFinalZone

local soundBump = audio.loadSound("sound/bump.wav")
local soundRacket = audio.loadSound("sound/raquette.wav")

--Options de l'image
local sheetOptions = {
    width = 64,
    height = 64,
    numFrames = 4
}
--Déclaration des sprite sheet
local sheet_fishRed = graphics.newImageSheet( "images/sprites-fishRed-swim.png", sheetOptions )
-- sequences table
local sequences_fishRed = {
    -- consecutive frames sequence
    {
        name = "swim",
        start = 1,
        count = 4,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
}

function AddScore( pScore )
	score = score + pScore
	print("Score : "..score)
	labelScore.text = "Score : "..tostring(score)
end

--Fonctions permettant de gérer le déplacement et le balancement de la raquette
function RacketRight()
	transition.to( racket, { time=2000, x=display.screenOriginX + display.actualContentWidth, rotation=10, onComplete=RacketLeft } )
end

function RacketLeft()
	transition.to( racket, { time=2000, x=display.screenOriginX, rotation=-10, onComplete=RacketRight } )
end

--Fonctions permettant de gérer le déplacements des poissons
function FishRight(myFish)
	local myDelay
	if myFish.isDead == false then
		if myFish.startLevel == true then
			myFish:scale(1,1)
			myDelay = math.random(100,1000)
		else
			myFish:scale(-1,1)
			myDelay = 0
		end
		transition.moveTo( myFish, { time=math.random(2400,2800), delay=myDelay, x=display.screenOriginX + (display.actualContentWidth - display.actualContentWidth/10), onComplete=FishLeft } )
	end
end

function FishLeft(myFish)
	if myFish.isDead == false then
		myFish:scale(-1,1)
		transition.moveTo( myFish, { time=math.random(2400,2800), x=display.screenOriginX + display.actualContentWidth/10, onComplete=FishRight } )
	end
end

function BubbleTop(pBall,pX)
	transition.to( pBall, { time=3000, y=display.actualContentHeight-485, onComplete=BubbleRemove } )
end

function BubbleRemove(pBall)
	pBall:removeSelf()
end

function CreateFish(pSheet, pSequence, pType, pX, pY)
	local myFish =  display.newSprite( pSheet, pSequence )
	myFish.type = pType
	myFish.x = pX
	myFish.y = pY
	myFish.isDead = false
	table.insert(listFish, myFish)
	return myFish
end

function NextLevel(currentLevel)
	currentLevel = currentLevel + 1
end

function CreateLevel()
	print("Créé le niveau")

	local lin, col, x, y
	local colWidth = display.actualContentWidth/(5+1)

	x = display.screenOriginX + colWidth
	y = display.screenOriginY + 100

	local function OnTouchTarget(self, event)
		if event.phase == "began" then
			print("Cible touchée !")
			audio.play(soundBump)
			self:removeSelf()
			self.isDead = true
			AddScore(10)
		end
	end

	if currentLevel == 1 then
		fishRed1 = CreateFish( sheet_fishRed, sequences_fishRed, "FishRed", x, y )
		fishRed1.startLevel = true
		physics.addBody( fishRed1, "dynamic", { density=1, friction=0.3, bounce=1, box=offsetRect_FishRed } )
		fishRed1:play()
		fishRed1.collision = OnTouchTarget
		fishRed1:addEventListener( "collision" )
		globalView:insert(fishRed1)
		nbFish = nbFish + 1

		fishRed2 = CreateFish( sheet_fishRed, sequences_fishRed, "FishRed", x - fishRed1.x, y + fishRed1.y )
		fishRed2.startLevel = true
		physics.addBody( fishRed2, "dynamic", { density=1, friction=0.3, bounce=1, box=offsetRect_FishRed } )
		fishRed2:play()
		fishRed2.collision = OnTouchTarget
		fishRed2:addEventListener( "collision" )
		globalView:insert(fishRed2)
		nbFish = nbFish + 1

		fishRed3 = CreateFish( sheet_fishRed, sequences_fishRed, "FishRed", x + fishRed1.x, y + fishRed2.y )
		fishRed3.startLevel = true
		physics.addBody( fishRed3, "dynamic", { density=1, friction=0.3, bounce=1, box=offsetRect_FishRed } )
		fishRed3:play()
		fishRed3.collision = OnTouchTarget
		fishRed3:addEventListener( "collision" )
		globalView:insert(fishRed3)
		nbFish = nbFish + 1

		fishRed4 = CreateFish( sheet_fishRed, sequences_fishRed, "FishRed", x + fishRed3.x, y + fishRed3.y )
		fishRed4.startLevel = true
		physics.addBody( fishRed4, "dynamic", { density=1, friction=0.3, bounce=1, box=offsetRect_FishRed } )
		fishRed4:play()
		fishRed4.collision = OnTouchTarget
		fishRed4:addEventListener( "collision" )
		globalView:insert(fishRed4)
		nbFish = nbFish + 1
	end

	if currentLevel == 2 then
		for lin = 1,5 do
			for col = 1,5 do
				local target = display.newImageRect("images/fishBlue.png", 20, 20)
				target.x = x
				target.y = y
				physics.addBody( target, "static", { density=1, friction=0.3, bounce=1, radius=8 } )
				target.collision = OnTouchTarget
				target:addEventListener( "collision" )
				globalView:insert(target)
				x = x + colWidth
			end
			y = y + 50
			x = display.screenOriginX + colWidth
		end
	end

	--Remet score à 0 et les autres valeurs par défaut
	score = 0
	nbBalls = 3
end

function AddBall( pX )
	if ball ~= nil then
		print("Balle déjà à l'écran")
		return
	end
	ball = display.newCircle( pX,display.actualContentHeight, 10 )
	ball.anchorY = 0
	physics.addBody( ball, "dynamic", { density=1.0, friction=0.3, bounce=1.0, radius=10 } )
	--ball:applyAngularImpulse( 100 )
	ball.collision = OnCollisionFinalZone
	BubbleTop(ball)
	globalView:insert(ball)
end

function scene:create( event )
	local sceneGroup = self.view
	globalView = sceneGroup

	local decor = display.newImageRect( "images/decor.png", 320, 480 )
	decor.x = display.contentWidth/2
	decor.y = display.contentHeight/2
	-- Fonction touche de l'écran
	function OnTouchDecor(event)
		AddBall(event.x)
	end
	decor:addEventListener("tap",OnTouchDecor)
	--Ajout décor
	sceneGroup:insert( decor )

	racket = display.newRoundedRect( 0,0,70,18,5 )
	racket.anchorY = 1
	racket.y = display.screenOriginY + racket.height + 5 
	racket.x = display.screenOriginX
	physics.addBody( racket, "static", { bounce=1.0 } )
	--Raquette
	local function OnTouchRacket(self, event)
		if event.phase == "began" then
			audio.play(soundRacket)
			AddScore(50)
		end
	end
	racket.collision = OnTouchRacket
	racket:addEventListener("collision")

	local wallLeft = display.newRect(display.screenOriginX-1, display.screenOriginY, 1, display.actualContentHeight)
	wallLeft.anchorX = 1
	wallLeft.anchorY = 0
	physics.addBody( wallLeft, "static", { bounce=0.5 } )

	local wallRight = display.newRect(display.screenOriginX + display.actualContentWidth + 1, display.screenOriginY, 1, display.actualContentHeight)
	wallRight.anchorX = 0
	wallRight.anchorY= 0
	physics.addBody( wallRight, "static", { bounce=0.5 } )

	local finalZone = display.newRect(display.contentWidth/2, display.screenOriginY+5, display.actualContentWidth, 10)
	finalZone.anchorY = 1
	physics.addBody( finalZone, "static", { isSensor=true } )
	-- Fonction détectant la collision
	function OnCollisionFinalZone(self, event)
		print("Touche la zone de fin !")
		--print("currentLevel Start = "..currentLevel)
		ball = nil

		-- Retire la balle et incrémente le compteur
		nbBalls = nbBalls - 1
		if nbBalls > 1 then
			labelBall.text = "Balles : "..tostring(nbBalls)
		else
		    labelBall.text = "Balle : "..tostring(nbBalls)
		end
		--[[if nbBalls == 0 then
			dernierScore = score
			transition.cancel(racket)
			transition.cancel(fish)
			composer.gotoScene("scenelevel", "fade", 500)
		end]]
	end
	finalZone.collision = OnCollisionFinalZone
	-- Ajoute l'évènement collision
	finalZone:addEventListener( "collision" )

	labelScore = display.newText("Score : 0", display.screenOriginX+display.actualContentWidth - 5, 5)
	labelScore.anchorX = 1
	labelScore.anchorY = 0

	labelBall = display.newText("Balles : 3", display.actualContentWidth - labelScore.width, 5)
	labelBall.anchorX = 1
	labelBall.anchorY = 0

	sceneGroup:insert( racket )
	sceneGroup:insert( wallLeft )
	sceneGroup:insert( wallRight)
	sceneGroup:insert( finalZone )
	sceneGroup:insert( labelScore )
	sceneGroup:insert( labelBall )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Exécuté avant que la scène ne vienne à l'écran
		CreateLevel()
		RacketRight()
		if nbFish > 0 then
			FishRight(fishRed1)
			FishRight(fishRed2)
			FishRight(fishRed3)
			FishRight(fishRed4)
		end
		fishRed1.startLevel = false
		fishRed2.startLevel = false
		fishRed3.startLevel = false
		fishRed4.startLevel = false
		physics.start()
	elseif phase == "did" then
		-- Exécuté une fois que la scène est à l'écran
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
    -- Exécuté juste avant que la scène ne disparaisse de l'écran
	elseif phase == "did" then
		-- Exécuté après que la scène ai disparu de l'écran
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
  -- Exécuté à la suppression de la scène de la mémoire
	-- Supprimez ici les objets que vous avez créés
end

---------------------------------------------------------------------------------

-- Branchement des événements
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene