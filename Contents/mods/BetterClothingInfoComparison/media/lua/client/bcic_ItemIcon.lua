-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-09-30)
-- based on: 41+

ItemIcon = {}

function ItemIcon:New(texture, positionX, positionY, width, height, transparency)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.texture = texture;
    o.positionX = positionX;
    o.positionY = positionY;
    o.width = width;
    o.height = height;
    o.transparency = transparency;
    return o;
end

function ItemIcon:Render(objectTooltip, draw)
    if draw then
        objectTooltip:DrawTextureScaled(self.texture, self.positionX, self.positionY, self.width, self.height,
            self.transparency);
    end
end
