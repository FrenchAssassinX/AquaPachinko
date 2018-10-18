--Objet gérant le changement de scène
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

-- Variables globales
dernierScore = 0
meilleurScore = 0
local labelDernierScore
local labelMeilleurScore
local logo

currentLevel = 0
listFish = {}
nbFish = 0
spawnFish = 0

--Zone de collision des différents poissons 
offsetRect_FishRed = { halfWidth=25, halfHeight=30, x=0, y=0, angle=90 }

function scene:create( event )
	local sceneGroup = self.view

	local function onButtonPlay()
		print("Bouton play touché !")
		currentLevel = 1
		composer.removeScene("scenejeu")
		composer.gotoScene("scenejeu", "fade", 500)
	end
	buttonPlay = widget.newButton({
			label="Jouer",
			labelColor = { default={255,255,255} },
			onRelease = onButtonPlay })
	buttonPlay.x = display.contentWidth/2
	buttonPlay.y = display.contentHeight/2

	logo = display.newImage("images/logo.png", display.contentWidth/2, buttonPlay.y - buttonPlay.height)
	logo.anchorY = 1
	labelDernierScore = display.newText("Dernier score: 0", display.contentWidth/2, buttonPlay.y + buttonPlay.height)
	labelDernierScore.anchorY = 0

	labelMeilleurScore = display.newText("Meilleur score: 0", display.contentWidth/2, labelDernierScore.y + labelDernierScore.height + 5)
	labelMeilleurScore.anchorY = 0

	sceneGroup:insert( labelDernierScore )
	sceneGroup:insert( labelMeilleurScore )
	sceneGroup:insert( buttonPlay )
	sceneGroup:insert( logo )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Exécuté avant que la scène ne vienne à l'écran
		labelDernierScore.text = ("Dernier score: "..dernierScore)
		if dernierScore > meilleurScore then
			meilleurScore = dernierScore
		end
		labelMeilleurScore.text = ("Meilleur Score: "..meilleurScore)
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