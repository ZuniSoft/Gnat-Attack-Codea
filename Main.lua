-----------------
-- Gnat Attack --
-----------------

-- Keith Davis --
--  (c) 2021   --
--  ZuniSoft   --

SWARM_SIZE = 20
SWARM_MAX_SPEED = 6

function setup()
    viewer.mode = FULLSCREEN_NO_BUTTONS
    -- set player position
    sx,sy = WIDTH / 2, HEIGHT / 2
    -- tables
    j = {}
    m = {}
    bugs = {}
    -- initialize swarm
    for i = 1, SWARM_SIZE, 1 do
        table.insert(bugs, Bug(WIDTH, HEIGHT))
    end
end

function draw()
    -- checks
    checkBulletCollisions()
    -- background color
    background(89, 142, 35)
    -- joysticks    
    for a,b in pairs(j) do
        b:draw()
    end
    -- move bullets and remove if gone off screen
    fill(253, 252, 252)
    stroke(236, 76, 67, 66)
    for a,b in pairs(m) do
        ellipse(b.x,b.y,16)
        fill(227, 206, 111)
        ellipse(b.x,b.y,14)
        fill(217, 103, 96)
        ellipse(b.x,b.y,12)
        fill(255, 168, 0)
        ellipse(b.x,b.y,10)
        b.x=b.x+b.z
        b.y=b.y+b.w
        if b.x<0 or b.x>WIDTH or b.y<0 or b.y>HEIGHT then
            table.remove(m,a)
        end
    end
    -- keep player within screen bounds and draw
    if sx > WIDTH - 10 then
        sx = WIDTH - 10
    end
    if sx < 10 then
        sx = 10
    end
    if sy > HEIGHT then
        sy = HEIGHT
    end
    if sy < 36 then
        sy = 36
    end
    fill(0, 99)
    stroke(236, 76, 67, 0)
    ellipse(sx,sy-30,34)
    sprite(asset.builtin.Planet_Cute.Character_Boy,sx,sy,64)
    -- draw gnats
    local neighbors = {}
    for i, p in pairs(bugs) do
        for j, b in pairs(bugs) do
            if b ~= p then
                table.insert(neighbors, b)
            end
        end
        p:update(neighbors)
    end
    for i, p in pairs(bugs) do
        p.position = p.position + p.v
        p.locRect.x = p.position.x
        p.locRect.y = p.position.y
        if math.fmod(math.floor(p.position.x), 2) == 0 or math.fmod(math.floor(p.position.y), 2) == 0 then
            sprite(asset.builtin.Platformer_Art.Battor_Flap_1,p.position.x, p.position.y, 16,16)
        else
            sprite(asset.builtin.Platformer_Art.Battor_Flap_2,p.position.x,p.position.y, 16,16)
        end
    end
    sprite(asset.builtin.Cargo_Bot.Background_Fade, WIDTH/2,HEIGHT/2, WIDTH*2.5, HEIGHT*2.5)
end

function checkBulletCollisions()
    local i,b,a,c
    for i, b in pairs(bugs) do
        for a, c in pairs(m) do
            local mLocRect = Rectangle(c.x, c.y, 5, 5)
            if b.locRect:intersects(mLocRect) then
                table.remove(bugs, i)
                table.remove(m, a)
                sound(SOUND_PICKUP, 8648, 0.15) --coin sound
                sound(SOUND_POWERUP, 8650, 0.08)--buzz
            end
            -- uncomment if things are too easy
            --[[b.startled = true
            tween.delay(1, function()
                b.startled = false
            end)]]
        end
    end
end

function touched(t)
    if t.state==BEGAN then
        if t.x<WIDTH/2 then
            for a,b in pairs(j) do
                if b.type=="move" then
                    return
                end
            end
            table.insert(j,Joystick(t.x,t.y,t.id,"move"))
            else
            table.insert(j,Joystick(t.x,t.y,t.id,"shoot"))
        end
    end
    for a,b in pairs(j) do
        b:touched(t)
    end
end
