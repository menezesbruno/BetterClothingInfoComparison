-- author: Bruno Menezes
-- version: 0.1a (2023-09-19)
-- based on: 41+
require "ISUI/ISToolTipInv"

-- set width for pixel for fonts
local PX_LETTER = 8;
local font_name = UIFont.Medium;
local font_size = getCore():getOptionTooltipFont();

if font_size == "Large" then
    PX_LETTER = 9;
    font_name = UIFont.Large;
elseif font_size == "Small" then
    PX_LETTER = 6;
    font_name = UIFont.Small;
end

-- get UI language and add fix for wider Russian fonts
local current_lang = tostring(Translator.getLanguage());
if current_lang == "RU" then
    if font_size == "Large" then
        PX_LETTER = 10;
    elseif font_size == "Small" then
        PX_LETTER = 6.5;
    end
end

local lineHeight = getTextManager():getFontFromEnum(font_name):getLineHeight();
local y_position = 0;
local label_x_position = 5;
local value_x_position = (string.len(getText("Tooltip_RunSpeedModifier")) + 3) * PX_LETTER;
local original_render = ISToolTipInv.render;
-- local original_DoTooltip = InventoryItem.DoTooltip;

function bcic_DoTooltip(objTooltip, item)
    objTooltip:render();
    local var2 = objTooltip:getFont();
    local var3 = objTooltip:getLineSpacing();
    local var4 = 5;
    local var5 = "";
    local var6;
    if var5 == "" then
        var6 = item:getName();
        objTooltip:DrawText(var2, var6, 5.0, var4, 1.0, 1.0, 0.8, 1.0);
    elseif this.OffAgeMax < 1000000000 and item.Age >= item.OffAgeMax then
        var6 = getText("IGUI_FoodNaming", var5, item.name);
        objTooltip:DrawText(var2, var6, 5.0, var4, 1.0, 0.1, 0.1, 1.0);
    else
        var6 = getText("IGUI_FoodNaming", var5, item.name);
        objTooltip:DrawText(var2, var6, 5.0, var4, 1.0, 1.0, 0.8, 1.0);
    end

    objTooltip:adjustWidth(5, var6);
    var4 = var4 + var3 + 5;

    local var14 = objTooltip:beginLayout();
    var14:setMinLabelWidth(80);
    local var15 = var14:addItem();
    var15:setLabel(getText("Tooltip_item_Weight") .. ":", 1, 1, 0.8, 1);
    local var16 = item:isEquipped();
    local var17;
    local var10001;
    if not item:IsWeapon() and not item:IsClothing() and not item:IsDrainable() and
        not item:getFullType():contains("Walkie") then
        var17 = item:getUnequippedWeight();
        if var17 > 0.0 and var17 < 0.01 then
            var17 = 0.01;
        end
        var15:setValueRightNoPlus(var17);
    elseif var16 then
        var10001 = item:getCleanString(item:getEquippedWeight());
        var15:setValue(var10001 .. "    (" .. item:getCleanString(item:getUnequippedWeight()) .. " " ..
                           getText("Tooltip_item_Unequipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    elseif item:getAttachedSlot() > -1 then
        var10001 = item:getCleanString(item:getHotbarEquippedWeight());
        var15:setValue(var10001 .. "    (" .. item:getCleanString(item:getUnequippedWeight()) .. " " ..
                           getText("Tooltip_item_Unequipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    else
        var10001 = item:getCleanString(item:getUnequippedWeight());
        var15:setValue(var10001 .. "    (" .. item:getCleanString(item:getEquippedWeight()) .. " " ..
                           getText("Tooltip_item_Equipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    end

    -- item:DoTooltip(objTooltip, var14);
    DoTooltipClothing(objTooltip, item, var14)

    -- if item:getConditionMax() > 0 and item:getMechanicType() > 0 then
    --     var15 = var14:addItem();
    --     var15:setLabel(getText("Tooltip_weapon_Condition") .. ":", 1, 1, 0.8, 1);
    --     var15:setValue(item:getCondition() .. " / " .. item:getConditionMax(), 1, 1, 0.8, 1);
    -- end

    if item:getTooltip() ~= null then
        var15 = var14:addItem();
        var15:setLabel(getText(item.tooltip), 1.0, 1.0, 0.8, 1.0);
    end

    var4 = var14:render(5, var4, objTooltip);
    objTooltip:endLayout(var14);
    var4 = var4 + 5;
    objTooltip:setHeight(var4);
    if objTooltip:getWidth() < 150.0 then
        objTooltip:setWidth(150.0);
    end
end

function setProgressBar(value, label, layoutItem, layoutTooltip)
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

function setComparisonItem(newItemValue, previousItemValue, label, layoutItem, layoutTooltip)
    if newItemValue ~= previousItemValue then
        layoutItem = layoutTooltip:addItem();
        if newItemValue > 0.0 or previousItemValue > 0.0 then
            layoutItem:setLabel(getText(label) .. ":", 1.0, 1.0, 0.8, 1.0);
            if newItemValue > previousItemValue then
                layoutItem:setValue(
                    math.floor(newItemValue) .. " (+" .. math.floor(newItemValue - previousItemValue) .. ")", 0.0, 1.0,
                    0.0, 1.0);
            else
                layoutItem:setValue(
                    math.floor(newItemValue) .. " (-" .. math.floor(previousItemValue - newItemValue) .. ")", 1.0, 0.0,
                    0.0, 1.0);
            end
        end
    elseif newItemValue ~= 0.0 then
        layoutItem = layoutTooltip:addItem();
        layoutItem:setLabel(getText(label) .. ":", 1.0, 1.0, 0.8, 1.0);
        layoutItem:setValue("" .. math.floor(newItemValue), 1.0, 1.0, 1.0, 1.0);
    end
end

function DoTooltipClothing(objTooltip, item, var2)
    local var3; -- layoutItem
    -- local var12; -- temp
    if not item:isCosmetic() then
        local conditionState = item:getCondition() / item:getConditionMax();
        setProgressBar(conditionState, "Tooltip_weapon_Condition", var3, var2);
        setProgressBar(item:getInsulation(), "Tooltip_item_Insulation", var3, var2);
        setProgressBar(item:getWindresistance(), "Tooltip_item_Windresist", var3, var2);
        setProgressBar(item:getWaterResistance(), "Tooltip_item_Waterresist", var3, var2);
    end

    if item:getBloodlevel() ~= 0.0 then
        local bloodState = item:getBloodlevel() / 100.0;
        setProgressBar(bloodState, "Tooltip_clothing_bloody", var3, var2);
    end

    if item:getDirtyness() >= 1.0 then
        local dirtynessState = item:getDirtyness() / 100.0;
        setProgressBar(dirtynessState, "Tooltip_clothing_dirty", var3, var2);
    end

    if item:getWetness() ~= 0.0 then
        local wetnessState = item:getWetness() / 100.0;
        setProgressBar(wetnessState, "Tooltip_clothing_wet", var3, var2);
    end

    local var13 = 0;
    local var14 = item:getVisual(); -- ItemVisual
    local var15; -- temp
    for var15 = 0, BloodBodyPartType.MAX:index() - 1 do -- VER COM BRUNINHO OPINIAO DELE SOBRE VALOR DE I
        if var14:getHole(BloodBodyPartType.FromIndex(var15)) > 0.0 then
            var13 = var13 + 1;
        end
    end

    if var13 > 0 then
        var3 = var2:addItem();
        var3:setLabel(getText("Tooltip_clothing_holes") + ":", 1.0, 1.0, 0.8, 1.0);
        var3:setValueRightNoPlus(var13);
    end

    if not item:isEquipped() and objTooltip:getCharacter() ~= nil then
        local previousCondition = 0.0;
        local previousBiteDefense = 0.0;
        local previousScratchDefense = 0.0;
        local previousBulletDefense = 0.0;
        local wornItems = objTooltip:getCharacter():getWornItems(); -- WornItens

        local var19;
        for var19 = 0, wornItems:size() - 1 do
            local wormItem = wornItems:get(var19);
            if (item:getBodyLocation() == wormItem:getLocation()) or
                wornItems:getBodyLocationGroup():isExclusive(item:getBodyLocation(), wormItem:getLocation()) then
                previousCondition = previousCondition + wormItem:getItem():getCondition();
                previousBiteDefense = previousBiteDefense + wormItem:getItem():getBiteDefense();
                previousScratchDefense = previousScratchDefense + wormItem:getItem():getScratchDefense();
                previousBulletDefense = previousBulletDefense + wormItem:getItem():getBulletDefense();
            end
        end

        local newCondition = item:getCondition();
        local newBiteDefense = item:getBiteDefense();
        local newScratchDefense = item:getScratchDefense();
        local newBulletDefense = item:getBulletDefense();
        setComparisonItem(newCondition * 10, previousCondition * 10, "Tooltip_weapon_Condition", var3, var2);
        setComparisonItem(newBiteDefense, previousBiteDefense, "Tooltip_BiteDefense", var3, var2);
        setComparisonItem(newScratchDefense, previousScratchDefense, "Tooltip_ScratchDefense", var3, var2);
        setComparisonItem(newBulletDefense, previousBulletDefense, "Tooltip_BulletDefense", var3, var2);

    end
    -- else {
    --     if (this.getBiteDefense() != 0.0F) {
    --         var3 = var2.addItem();
    --         var3.setLabel(Translator.getText("Tooltip_BiteDefense") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var3.setValueRightNoPlus((int)this.getBiteDefense());
    --     }

    --     if (this.getScratchDefense() != 0.0F) {
    --         var3 = var2.addItem();
    --         var3.setLabel(Translator.getText("Tooltip_ScratchDefense") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var3.setValueRightNoPlus((int)this.getScratchDefense());
    --     }

    --     if (this.getBulletDefense() != 0.0F) {
    --         var3 = var2.addItem();
    --         var3.setLabel(Translator.getText("Tooltip_BulletDefense") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var3.setValueRightNoPlus((int)this.getBulletDefense());
    --     }
    -- }

    -- if (this.getRunSpeedModifier() != 1.0F) {
    --     var3 = var2.addItem();
    --     var3.setLabel(Translator.getText("Tooltip_RunSpeedModifier") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var3.setValueRightNoPlus(this.getRunSpeedModifier());
    -- }

    -- if (this.getCombatSpeedModifier() != 1.0F) {
    --     var3 = var2.addItem();
    --     var3.setLabel(Translator.getText("Tooltip_CombatSpeedModifier") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var3.setValueRightNoPlus(this.getCombatSpeedModifier());
    -- }

    -- if (Core.bDebug && DebugOptions.instance.TooltipInfo.getValue()) {
    --     if (this.bloodLevel != 0.0F) {
    --         var3 = var2.addItem();
    --         var3.setLabel("DBG: bloodLevel:", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var15 = (int)Math.ceil((double)this.bloodLevel);
    --         var3.setValueRight(var15, false);
    --     }

    --     if (this.dirtyness != 0.0F) {
    --         var3 = var2.addItem();
    --         var3.setLabel("DBG: dirtyness:", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var15 = (int)Math.ceil((double)this.dirtyness);
    --         var3.setValueRight(var15, false);
    --     }

    --     if (this.wetness != 0.0F) {
    --         var3 = var2.addItem();
    --         var3.setLabel("DBG: wetness:", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var15 = (int)Math.ceil((double)this.wetness);
    --         var3.setValueRight(var15, false);
    --     }
    -- }

end

function ISToolTipInv:bcic_render()
    -- render the original method if the item isn't Clothing
    if not self.item:IsClothing() then
        original_render(self);
        return;
    end

    -- we render the tool tip for inventory item only if there's no context menu showed
    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
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

        self.tooltip:setWidth(50);
        self.tooltip:setMeasureOnly(true);
        -- self.item:DoTooltip(self.tooltip);
        bcic_DoTooltip(self.tooltip, self.item);
        self.tooltip:setMeasureOnly(false)

        local myCore = getCore();
        local maxX = myCore:getScreenWidth();
        local maxY = myCore:getScreenHeight();

        local tw = self.tooltip:getWidth();
        local th = self.tooltip:getHeight();

        if self.followMouse then
            self:adjustPositionToAvoidOverlap({
                x = mx - 24 * 2,
                y = my - 24 * 2,
                width = 24 * 2,
                height = 24 * 2
            });
        end

        self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r,
            self.backgroundColor.g, self.backgroundColor.b);
        self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
            self.borderColor.b);

        local playerObj = self.tooltip:getCharacter();
        if self.item:IsClothing() and not self.item:isEquipped() then
            tw, th = RenderTooltipClothing(self.tooltip, self.item, tw, th, playerObj);
        end

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

        -- self.item:DoTooltip(self.tooltip);
        bcic_DoTooltip(self.tooltip, self.item);
    end
end

ISToolTipInv.render = ISToolTipInv.bcic_render;

function RenderTooltipClothing(tooltipContext, itemContext, tw, th, playerObj)
    y_position = tooltipContext:getHeight() + lineHeight * 0.2;

    -- AVALIAR NECESSIDADE DE INCLUIR REPLACE_ITEMS
    local previousCondition = 0;
    local previousInsulation = 0;
    local previousWindResistance = 0;
    local previousBiteDefense = 0;
    local previousScratchDefense = 0;
    local previousHolesNumber = 0;
    local wornItems = playerObj:getWornItems();
    local bodyLocationGroup = wornItems:getBodyLocationGroup()
    local location = itemContext:IsClothing() and itemContext:getBodyLocation() or itemContext:canBeEquipped()

    for i = 1, wornItems:size() do
        local wornItem = wornItems:get(i - 1)
        local item = wornItem:getItem()
        if (itemContext:getBodyLocation() == wornItem:getLocation()) or
            bodyLocationGroup:isExclusive(location, wornItem:getLocation()) then
            if item:IsClothing() then
                previousCondition = previousCondition + item:getCondition();
                previousInsulation = previousInsulation + item:getInsulation();
                previousWindResistance = previousWindResistance + item:getWindresistance();
                previousBiteDefense = previousBiteDefense + item:getBiteDefense();
                previousScratchDefense = previousScratchDefense + item:getScratchDefense();
                previousHolesNumber = previousHolesNumber + item:getHolesNumber();
            end
        end
    end

    local newCondition = itemContext:getCondition();
    local newInsulation = itemContext:getInsulation();
    local newWindResistance = itemContext:getWindresistance();
    local newBiteDefense = itemContext:getBiteDefense();
    local newScratchDefense = itemContext:getScratchDefense();
    local newHolesNumber = itemContext:getHolesNumber();

    drawTooltipInv(tooltipContext, nil, nil, nil, "Tooltip_item_Comparison", false);
    drawTooltipInv(tooltipContext, previousCondition, newCondition, 10, "Tooltip_weapon_Condition", false);
    drawTooltipInv(tooltipContext, previousInsulation, newInsulation, 100, "Tooltip_item_Insulation", false);
    drawTooltipInv(tooltipContext, previousWindResistance, newWindResistance, 100, "Tooltip_item_Windresist", false);
    drawTooltipInv(tooltipContext, previousBiteDefense, newBiteDefense, 1, "Tooltip_BiteDefense", false);
    drawTooltipInv(tooltipContext, previousScratchDefense, newScratchDefense, 1, "Tooltip_ScratchDefense", false);
    drawTooltipInv(tooltipContext, previousHolesNumber, newHolesNumber, 1, "Tooltip_clothing_holes", true);

    -- adjust window
    th = y_position;
    th = th + 20;
    tw = tw + 5;

    return tw, th;
end

function formatTooltipInv(previous, new, multiplicationFactor, invertHC)
    local text = "";
    local hc = {
        getR = function()
            return 224;
        end,
        getG = function()
            return 224;
        end,
        getB = function()
            return 224;
        end
    }

    if previous ~= nil or new ~= nil then
        local plus = "";
        if previous > 0 and previous > new then
            hc = invertHC and getCore():getGoodHighlitedColor() or getCore():getBadHighlitedColor();
            plus = "";
        end
        if new > 0 and new > previous then
            hc = invertHC and getCore():getBadHighlitedColor() or getCore():getGoodHighlitedColor();
            plus = "+";
        end
        text = string.format("%d (%s%d)", new * multiplicationFactor, plus,
            new * multiplicationFactor - previous * multiplicationFactor);
    end

    return {
        data = text,
        hcR = hc:getR(),
        hcG = hc:getG(),
        hcB = hc:getB()
    }
end

function drawTooltipInv(tooltipContext, previous, new, multiplicationFactor, labelTooltip, invertHC)
    y_position = y_position + 15;

    local formatText = formatTooltipInv(previous, new, multiplicationFactor, invertHC);

    tooltipContext:DrawText(tooltipContext:getFont(), getText(labelTooltip), label_x_position, y_position,
        formatText.hcR, formatText.hcG, formatText.hcB, 1);
    tooltipContext:DrawText(tooltipContext:getFont(), formatText.data, value_x_position, y_position, formatText.hcR,
        formatText.hcG, formatText.hcB, 1);
end
