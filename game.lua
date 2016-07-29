local composer = require( "composer" )
local scene = composer.newScene()

local physics = require( "physics" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- starting the player because scope
local player
-- width and thingies cuz scop
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight
local leftTouch = false
local rightTouch = false

local function touchReset ( )
    leftTouch = false
    rightTouch = false
end

local function screenTouch( event )
    local x = event.x
    local y = event.y

    -- print("boop")
    if event.phase == "began" then
        if (x > screenWidth * 0.5 ) then
            rightTouch = true
        elseif ( x <= screenWidth ) then
            leftTouch = true
        end
    end
    
    if (event.phase == "ended") then
        touchReset( )
    end
end

-- player initialization
local function playerInit( )
    player = display.newImage("ship.png", screenWidth * 0.5, screenHeight * 0.8 )
    physics.addBody( player )
    player.gravityScale = 0
    player.lock = screenHeight * 0.8
    player.SpeedLimiter = 200
end

-- player functions i guess?
local function playerStep( )
    local y = player.y

    -- y-axis lock
    local function playerLock( y )
        local lock = player.lock
            if y ~= lock then
                y = lock
            end
        return y
    end
    player.y = playerLock( y )

    local function playerSpeed( )
        local limiter = player.SpeedLimiter
        local maxSpeed = limiter
        local minSpeed = -limiter
        local xVel, yVel = player:getLinearVelocity()

        if xVel > maxSpeed then
            xVel = maxSpeed
        end

        if xVel < minSpeed then
            xVel = minSpeed
        end

        print(xVel, yVel)
        return xVel, yVel
    end
    local a, b = playerSpeed()
    player:setLinearVelocity( a, b )
    print(a, b)

end

-- step event
local function step( event )
    playerStep( )

end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.start( )
    physics.pause( )
    
    -- the player
    playerInit( )
    sceneGroup:insert( player )
    
    -- barrier sizes
    local barrierW = 10
    local barrierH = screenHeight
    local barrierX = barrierW * 0.5
    local barrierY = barrierH * 0.5
    local barrierColor = { 1, 1, 1, 1 }
    -- left barrier
    local leftB = display.newRect( barrierX, barrierY, barrierW, barrierH )
    leftB:setFillColor( unpack(barrierColor) )
    sceneGroup:insert( leftB )
    physics.addBody( leftB, "static" )
    -- right barrier
    local rightB = display.newRect( screenWidth - barrierX, barrierY, barrierW, barrierH )
    rightB:setFillColor( unpack(barrierColor) )
    sceneGroup:insert( rightB )
    physics.addBody( rightB, "static" )

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- Go ´phshsyhsucs
        physics.start( )

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        physics.stop( )

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

display.currentStage:addEventListener( "touch", screenTouch )
Runtime:addEventListener( "enterFrame", step )

return scene