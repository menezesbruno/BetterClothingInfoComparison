-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-09-30)
-- based on: 41+

require "ISUI/ISToolTipInv"

local original_render = ISToolTipInv.render;

function ISToolTipInv:bcic_render()
    if not self.item:IsClothing() then
        original_render(self);
        return;
    end

    -- we render the tool tip for inventory item only if there's no context menu showed
    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
        RenderTooltip(self, 0, 0);
    end
end

function RenderTooltip(self)
    local mx = getMouseX() + 24;
    local my = getMouseY() + 24;
    if not self.followMouse then
        mx = self:getX()
        my = self:getY()
        if self.anchorBottomLeft then
            mx = self.anchorBottomLeft.x
            my = self.anchorBottomLeft.y
        end
    end

    self.tooltip:setX(mx + 11);
    self.tooltip:setY(my);

    self.tooltip:setWidth(50)
    self.tooltip:setMeasureOnly(true)

    if self.item:IsClothing() then
        bcic_DoTooltip(self.tooltip, self.item); -- CONSEGUIR PEGAR O SELF.ITEM DENTRO DO DoTooltip PARA PODERMOS ELIMINAR ESSE RENDER
    else
        self.item:DoTooltip(self.tooltip);
    end

    self.tooltip:setMeasureOnly(false)

    -- clampy x, y

    local myCore = getCore();
    local maxX = myCore:getScreenWidth();
    local maxY = myCore:getScreenHeight();

    local tw = self.tooltip:getWidth();
    local th = self.tooltip:getHeight();

    self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)));
    if not self.followMouse and self.anchorBottomLeft then
        self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)));
    else
        self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)));
    end

    self:setX(self.tooltip:getX() - 11);
    self:setY(self.tooltip:getY());
    self:setWidth(tw + 11);
    self:setHeight(th);

    if self.followMouse then
        self:adjustPositionToAvoidOverlap({
            x = mx - 24 * 2,
            y = my - 24 * 2,
            width = 24 * 2,
            height = 24 * 2
        })
    end

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r,
        self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);

    if self.item:IsClothing() then
        bcic_DoTooltip(self.tooltip, self.item); -- CONSEGUIR PEGAR O SELF.ITEM DENTRO DO DoTooltip PARA PODERMOS ELIMINAR ESSE RENDER
    else
        self.item:DoTooltip(self.tooltip);
    end
end

function bcic_DoTooltip(objTooltip, item)
    objTooltip:render();
    local fontType = objTooltip:getFont();
    local lineSpacing = objTooltip:getLineSpacing();
    local offsetY = 11;

    local positionX = 75;
    local positionY = 25 + offsetY;
    local itemName = item:getName();
    objTooltip:DrawText(fontType, itemName, positionX, positionY, 1.0, 1.0, 0.8, 1.0);

    objTooltip:adjustWidth(5, itemName);
    positionY = positionY + offsetY + 25;

    local layoutTooltip = objTooltip:beginLayout();
    layoutTooltip:setMinLabelWidth(80);
    local layout = layoutTooltip:addItem();
    layout:setLabel(getText("Tooltip_item_Weight") .. ":", 1, 1, 0.8, 1);
    local var16 = item:isEquipped();
    local var17;
    local var10001;
    if not item:IsWeapon() and not item:IsClothing() and not item:IsDrainable() and
        not string.match(item:getFullType(), "Walkie") then
        var17 = item:getUnequippedWeight();
        if var17 > 0.0 and var17 < 0.01 then
            var17 = 0.01;
        end
        layout:setValueRightNoPlus(var17);
    elseif var16 then
        var10001 = item:getCleanString(item:getEquippedWeight());
        layout:setValue(var10001 .. "    (" .. item:getCleanString(item:getUnequippedWeight()) .. " " ..
            getText("Tooltip_item_Unequipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    elseif item:getAttachedSlot() > -1 then
        var10001 = item:getCleanString(item:getHotbarEquippedWeight());
        layout:setValue(var10001 .. "    (" .. item:getCleanString(item:getUnequippedWeight()) .. " " ..
            getText("Tooltip_item_Unequipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    else
        var10001 = item:getCleanString(item:getUnequippedWeight());
        layout:setValue(var10001 .. "    (" .. item:getCleanString(item:getEquippedWeight()) .. " " ..
            getText("Tooltip_item_Equipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    end

    DoTooltipClothing(objTooltip, item, layoutTooltip)

    if getCore():getOptionShowItemModInfo() and not item:isVanilla() then
        layout = layoutTooltip:addItem();
        layout:setLabel("Mod: " .. item:getModName(), 0.392, 0.584, 0.929, 1.0);
        -- local itemInfo = WorldDictionary.getItemInfoFromID(item:getRegistry_id()); -- fudeo nao achei
        -- if itemInfo ~= nil and itemInfo:getModOverrides() ~= nil then
        --     layout = layoutTooltip:addItem();
        --     if itemInfo:getModOverrides():size() == 1 then
        --         layout:setLabel("This item overrides: " ..
        --             WorldDictionary:getModNameFromID("" .. itemInfo:getModOverrides():get(0)), 0.5, 0.5,
        --             0.5, 1.0);
        --     else
        --         layout:setLabel("This item overrides:", 0.5, 0.5, 0.5, 1.0);

        --         for i = 0, itemInfo:getModOverrides():size() - 1 do
        --             layout = layoutTooltip:addItem();
        --             layout:setLabel(" - " .. WorldDictionary:getModNameFromID("" .. itemInfo:getModOverrides():get(i)),
        --                 0.5, 0.5, 0.5, 1.0);
        --         end
        --     end
        -- end
    end

    if item:getTooltip() ~= nil then
        layout = layoutTooltip:addItem();
        layout:setLabel(getText(item.tooltip), 1.0, 1.0, 0.8, 1.0);
    end

    positionY = layoutTooltip:render(5, positionY, objTooltip);
    objTooltip:endLayout(layoutTooltip);
    positionY = positionY + 5;
    objTooltip:setHeight(positionY);
    if objTooltip:getWidth() < 150.0 then
        objTooltip:setWidth(150.0);
    end
end

ISToolTipInv.render = ISToolTipInv.bcic_render;
