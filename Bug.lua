-----------------
-- Gnat Attack --
-----------------

-- Keith Davis --
--  (c) 2021   --
--  ZuniSoft   --

Bug = class()

function Bug:init(max_x, max_y)
    self.max_x = max_x
    self.max_y = max_y
    self.a = math.floor(math.pi * 2)
    self.position = vec2(math.floor(max_x), math.floor(max_y))
    self.v = vec2(math.cos(self.a), math.sin(self.a))
    self.locRect = Rectangle(self.position.x, self.position.y, 12, 12)
    self.startled = false
end

function Bug:update(neighbors)
    self:rule1(neighbors)
    self:rule2(neighbors)
    self:rule3(neighbors)
    self:rule4(neighbors)
    if math.abs(self.v.x) > SWARM_MAX_SPEED then
        self.v.x = self.v.x * (SWARM_MAX_SPEED / math.abs(self.v.x))
    end
    if math.abs(self.v.y) > SWARM_MAX_SPEED then
        self.v.y = self.v.y * (SWARM_MAX_SPEED / math.abs(self.v.y))
    end
end

function Bug:rule1(neighbors)
    -- Move to 'center of mass' of neighbors
    if not neighbors then
        return vec2(0, 0)
    end
    local p = vec2()
    for i, n in pairs(neighbors) do
        p = p + n.position
    end
    local m = p / #neighbors
    if self.startled then
        self.v = self.v - (m - self.position) * 0.007
    else
        self.v = self.v + (m - self.position) * 0.001
    end
end

function Bug:rule2(neighbors)
    -- Don't crowd neighbors
    if not neighbors then
        return vec2(0, 0)
    end
    local c = vec2()
    for i, n in pairs(neighbors) do
        if self:vectorDist(n.position - self.position) < 30 then
            c = c + (self.position - n.position)
        end
    end
    self.v = self.v + c * 0.01
end
 
function Bug:rule3(neighbors)
    -- Match velocity of neighbors
    if not neighbors then
        return vec2(0, 0)
    end
    local v = vec2()
    for i, n in pairs(neighbors) do
        v = v + n.v
    end    
    local m = v / #neighbors
    self.v =self.v + m * 0.01
end   
 
function Bug:rule4(neighbors)
    -- Stay within screen bounds
    local v = vec2(0, 0)
    if self.position.x < 0 then
        v.x = 1
    end
    if self.position.x > self.max_x then
        v.x = -1
    end
    if self.position.y < 0 then
        v.y = 1
    end
    if self.position.y > self.max_y then
        v.y = -1
    end
    self.v = self.v + (v * 0.9) 
end

function Bug:vectorDistSquared(v)
    return v.x^2 + v.y^2
end

function Bug:vectorDist(v)
    return (self:vectorDistSquared(v))^0.5
end
