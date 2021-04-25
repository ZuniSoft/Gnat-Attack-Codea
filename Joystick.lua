-----------------
-- Gnat Attack --
-----------------

-- Keith Davis --
--  (c) 2021   --
--  ZuniSoft   --

Joystick = class()

function Joystick:init(x,y,id,ty)
    self.id=id
    self.ox=x
    self.oy=y
    self.cx=x
    self.cy=y
    self.dx=0
    self.dy=0
    self.type=ty
    self.c=20
end

function Joystick:draw()
    stroke(255)
    strokeWidth(2)
    fill(255,255,255,100)
    ellipse(self.ox,self.oy,150)
    if self.type=="move" then
        sx=sx+(self.cx-self.ox)/10
        sy=sy+(self.cy-self.oy)/10
    end
    if self.type=="shoot" then
        v1=vec2(self.cx-self.ox,self.cy-self.oy)
        v1=v1:normalize()
        if math.abs(v1.x+v1.y)>0 then
            self.dx=v1.x*8
            self.dy=v1.y*8
            self.c=self.c+1
            if self.c>12 then
                table.insert(m,vec4(sx,sy,self.dx,self.dy))
                self.c=0
            end
        end
    end
end

function Joystick:touched(t)
    for a,b in pairs(j) do
        if t.id==b.id then
            if t.state==MOVING then
                b.cx=t.x
                b.cy=t.y
            end
            if t.state==ENDED then
                table.remove(j,a)
            end
        end
    end
end
