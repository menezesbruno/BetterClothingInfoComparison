-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-09-30)
-- based on: 41+

require "ISUI/ISToolTipInv"
require "bcic_TooltipClothing"

local original_render = ISToolTipInv.render;

function bcic_DoTooltip(objTooltip, item)
    objTooltip:render();
    local var2 = objTooltip:getFont();
    local var3 = objTooltip:getLineSpacing();
    local var4 = 5;
    local var6;
    var6 = item:getName();
    objTooltip:DrawText(var2, var6, 5.0, var4, 1.0, 1.0, 0.8, 1.0);

    objTooltip:adjustWidth(5, var6);
    var4 = var4 + var3 + 5;

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

    var4 = layoutTooltip:render(5, var4, objTooltip);
    objTooltip:endLayout(layoutTooltip);
    var4 = var4 + 5;
    objTooltip:setHeight(var4);
    if objTooltip:getWidth() < 150.0 then
        objTooltip:setWidth(150.0);
    end
end

function DrawProgressBar(value, label, layoutItem, layoutTooltip, draw)
    if draw and (value > 0 or label == "Tooltip_weapon_Condition") then
        SetProgressBar(value, label, layoutItem, layoutTooltip);
    end
end

function SetProgressBar(value, label, layoutItem, layoutTooltip)
    layoutItem = layoutTooltip:addItem();
    layoutItem:setLabel(getText(label) .. ": ", 1.0, 1.0, 0.8, 1.0);
    if value > 0.8 then
        layoutItem:setProgress(value, 0.0, 0.6, 0.0, 0.7);
    elseif value > 0.6 then
        layoutItem:setProgress(value, 0.3, 0.6, 0.0, 0.7);
    elseif value > 0.4 then
        layoutItem:setProgress(value, 0.6, 0.6, 0.0, 0.7);
    elseif value > 0.2 then
        layoutItem:setProgress(value, 0.6, 0.3, 0.0, 0.7);
    else
        layoutItem:setProgress(value, 0.6, 0.0, 0.0, 0.7);
    end
end

function SetItemWithComparison(newItemValue, previousItemValue, label, layoutItem, layoutTooltip, decimal, reverse)
    local colorOne = reverse and 0.0 or 1.0;
    local colorZero = reverse and 1.0 or 0.0;

    if newItemValue ~= previousItemValue then
        layoutItem = layoutTooltip:addItem();
        if newItemValue > 0.0 or previousItemValue > 0.0 then
            layoutItem:setLabel(getText(label) .. ":", 1.0, 1.0, 0.8, 1.0);
            if newItemValue > previousItemValue then
                layoutItem:setValue(string.format("%." .. decimal .. "f", newItemValue) .. " (+" ..
                    string.format("%." .. decimal .. "f", newItemValue - previousItemValue) .. ")",
                    colorZero, colorOne, 0.0, 1.0);
            else
                layoutItem:setValue(string.format("%." .. decimal .. "f", newItemValue) .. " (-" ..
                    string.format("%." .. decimal .. "f", previousItemValue - newItemValue) .. ")",
                    colorOne, colorZero, 0.0, 1.0);
            end
        end
    elseif newItemValue ~= 0.0 then
        if newItemValue == 1 and (label == "Tooltip_RunSpeedModifier" or label == "Tooltip_CombatSpeedModifier") then
            return;
        end
        SetItemWithoutComparison(newItemValue, label, layoutItem, layoutTooltip, decimal);
    end
end

function SetItemWithoutComparison(newItemValue, label, layoutItem, layoutTooltip, decimal)
    layoutItem = layoutTooltip:addItem();
    layoutItem:setLabel(getText(label) .. ":", 1.0, 1.0, 0.8, 1.0);
    layoutItem:setValue(string.format("%." .. decimal .. "f", newItemValue), 1.0, 1.0, 1.0, 1.0);
end

function SetItemInfoAsText(newItemValue, label, layoutItem, layoutTooltip)
    layoutItem = layoutTooltip:addItem();
    layoutItem:setLabel(getText(label) .. ":", 1.0, 1.0, 0.8, 1.0);
    layoutItem:setValue(newItemValue, 1.0, 1.0, 1.0, 1.0);
end

function RenderTooltip(self, offsetX, offsetY)
    local mx = getMouseX() + 24 + offsetX;
    local my = getMouseY() + 24 + offsetY;
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

ISToolTipInv.render = ISToolTipInv.bcic_render;
