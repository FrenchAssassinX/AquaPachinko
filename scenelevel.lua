--Objet gérant le changement de scène
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

function scene:create( event )
	local sceneGroup = self.view

	local function onButtonRestart()
		print("Bouton restart touché !")
		composer.removeScene("scenejeu")
		composer.gotoScene("scenejeu", "fade", 500)
	end
	buttonRestart = widget.newButton({
			label="Recommencer",
			labelColor = { default={255,255,255} },
			onRelease = onButtonRestart })
	buttonRestart.x = display.contentWidth/2
	buttonRestart.y = display.contentHeight/2 - 80

	local function onButtonNextLevel()
		print("Bouton next level touché !")
		currentLevel = currentLevel + 1
		print("currentLevel End = "..currentLevel)
		composer.removeScene("scenejeu")
		composer.gotoScene("scenejeu", "fade", 500)
	end
	buttonNextLevel = widget.newButton({
				label="Niveau suivant",
				labelColor = { default={255,255,255} },
				onRelease = onButtonNextLevel })
	buttonNextLevel.x = display.contentWidth/2
	buttonNextLevel.y = buttonRestart.y + buttonRestart.height

	local function onButtonMenu()
		print("Bouton menu touché !")
		composer.removeScene("scenejeu")
		composer.gotoScene("scenemenu", "fade", 500)
	end
	buttonMenu = widget.newButton({
				label="Menu principal",
				labelColor = { default={255,255,255} },
				onRelease = onButtonMenu })
	buttonMenu.x = display.contentWidth/2
	buttonMenu.y = buttonNextLevel.y + buttonNextLevel.height

	labelDernierScore = display.newText("Dernier score: 0", display.contentWidth/2, buttonMenu.y + buttonMenu.height)
	labelDernierScore.anchorY = 0

	labelMeilleurScore = display.newText("Meilleur score: 0", display.contentWidth/2, labelDernierScore.y + labelDernierScore.height + 5)
	labelMeilleurScore.anchorY = 0

	sceneGroup:insert( labelDernierScore )
	sceneGroup:insert( labelMeilleurScore )
	sceneGroup:insert( buttonRestart )
	sceneGroup:insert( buttonNextLevel )
	sceneGroup:insert( buttonMenu )

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