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
        local itemInfo = WorldDictionary.getItemInfoFromID(item:getRegistry_id()); -- fudeo nao achei
        if itemInfo ~= nil and itemInfo:getModOverrides() ~= nil then
            layout = layoutTooltip:addItem();
            if itemInfo:getModOverrides():size() == 1 then
                layout:setLabel("This item overrides: " ..
                                    WorldDictionary:getModNameFromID("" .. itemInfo:getModOverrides():get(0)), 0.5, 0.5,
                    0.5, 1.0);
            else
                layout:setLabel("This item overrides:", 0.5, 0.5, 0.5, 1.0);

                for i = 0, itemInfo:getModOverrides():size() - 1 do
                    layout = layoutTooltip:addItem();
                    layout:setLabel(" - " .. WorldDictionary:getModNameFromID("" .. itemInfo:getModOverrides():get(i)),
                        0.5, 0.5, 0.5, 1.0);
                end
            end
        end
    end

    if item:getTooltip() ~= null then
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

function setItemWithComparison(newItemValue, previousItemValue, label, layoutItem, layoutTooltip, decimal, reverse)
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
        setItemWithoutComparison(newItemValue, label, layoutItem, layoutTooltip, decimal);
    end
end

function setItemWithoutComparison(newItemValue, label, layoutItem, layoutTooltip, decimal)
    layoutItem = layoutTooltip:addItem();
    layoutItem:setLabel(getText(label) .. ":", 1.0, 1.0, 0.8, 1.0);
    layoutItem:setValue(string.format("%." .. decimal .. "f", newItemValue), 1.0, 1.0, 1.0, 1.0);
end

function DoTooltipClothing(objTooltip, item, layoutTooltip)
    local layoutItem;
    if not item:isCosmetic() then
        local conditionState = item:getCondition() / item:getConditionMax();
        setProgressBar(conditionState, "Tooltip_weapon_Condition", layoutItem, layoutTooltip);
        setProgressBar(item:getInsulation(), "Tooltip_item_Insulation", layoutItem, layoutTooltip);
        setProgressBar(item:getWindresistance(), "Tooltip_item_Windresist", layoutItem, layoutTooltip);
        setProgressBar(item:getWaterResistance(), "Tooltip_item_Waterresist", layoutItem, layoutTooltip);
    end

    if item:getBloodlevel() ~= 0.0 then
        local bloodState = item:getBloodlevel() / 100.0;
        setProgressBar(bloodState, "Tooltip_clothing_bloody", layoutItem, layoutTooltip);
    end

    if item:getDirtyness() >= 1.0 then
        local dirtynessState = item:getDirtyness() / 100.0;
        setProgressBar(dirtynessState, "Tooltip_clothing_dirty", layoutItem, layoutTooltip);
    end

    if item:getWetness() ~= 0.0 then
        local wetnessState = item:getWetness() / 100.0;
        setProgressBar(wetnessState, "Tooltip_clothing_wet", layoutItem, layoutTooltip);
    end

    -- NAO APARECER CASO FOR ACESSORIO(COMESTIC)??
    local newHolesNumber = item:getHolesNumber();
    local newCondition = item:getCondition();
    local newInsulation = item:getInsulation();
    local newWindresistance = item:getWindresistance();
    local newWaterResistance = item:getWaterResistance();
    local newBiteDefense = item:getBiteDefense();
    local newScratchDefense = item:getScratchDefense();
    local newBulletDefense = item:getBulletDefense();
    local newRunSpeedModifier = item:getRunSpeedModifier();
    local newCombatSpeedModifier = item:getCombatSpeedModifier();

    if not item:isEquipped() and objTooltip:getCharacter() ~= nil then
        local previousHolesNumber = 0.0;
        local previousCondition = 0.0;
        local previousInsulation = 0.0;
        local previousWindresistance = 0.0;
        local previousWaterResistance = 0.0;
        local previousBiteDefense = 0.0;
        local previousScratchDefense = 0.0;
        local previousBulletDefense = 0.0;
        local previousRunSpeedModifier = 0.0;
        local previousCombatSpeedModifier = 0.0;

        local wornItems = objTooltip:getCharacter():getWornItems();
        for i = 0, wornItems:size() - 1 do
            local wormItem = wornItems:get(i);
            if (item:getBodyLocation() == wormItem:getLocation()) or
                wornItems:getBodyLocationGroup():isExclusive(item:getBodyLocation(), wormItem:getLocation()) then
                previousHolesNumber = previousHolesNumber + wormItem:getItem():getHolesNumber();
                previousCondition = previousCondition + wormItem:getItem():getCondition();
                previousInsulation = previousInsulation + wormItem:getItem():getInsulation();
                previousWindresistance = previousWindresistance + wormItem:getItem():getWindresistance();
                previousWaterResistance = previousWaterResistance + wormItem:getItem():getWaterResistance();
                previousBiteDefense = previousBiteDefense + wormItem:getItem():getBiteDefense();
                previousScratchDefense = previousScratchDefense + wormItem:getItem():getScratchDefense();
                previousBulletDefense = previousBulletDefense + wormItem:getItem():getBulletDefense();
                previousRunSpeedModifier = previousRunSpeedModifier + wormItem:getItem():getRunSpeedModifier();
                previousCombatSpeedModifier = previousCombatSpeedModifier + wormItem:getItem():getCombatSpeedModifier();
            end
        end

        setItemWithComparison(newHolesNumber, previousHolesNumber, "Tooltip_clothing_holes", layoutItem, layoutTooltip,
            0, true);
        setItemWithComparison(newCondition * 10, previousCondition * 10, "Tooltip_weapon_Condition", layoutItem,
            layoutTooltip, 0, false);
        setItemWithComparison(newInsulation * 100, previousInsulation * 100, "Tooltip_item_Insulation", layoutItem,
            layoutTooltip, 0, false);
        setItemWithComparison(newWindresistance * 100, previousWindresistance * 100, "Tooltip_item_Windresist",
            layoutItem, layoutTooltip, 0, false);
        setItemWithComparison(newWaterResistance * 100, previousWaterResistance * 100, "Tooltip_item_Waterresist",
            layoutItem, layoutTooltip, 0, false);
        setItemWithComparison(newBiteDefense, previousBiteDefense, "Tooltip_BiteDefense", layoutItem, layoutTooltip, 0,
            false);
        setItemWithComparison(newScratchDefense, previousScratchDefense, "Tooltip_ScratchDefense", layoutItem,
            layoutTooltip, 0, false);
        setItemWithComparison(newBulletDefense, previousBulletDefense, "Tooltip_BulletDefense", layoutItem,
            layoutTooltip, 0, false);

        previousRunSpeedModifier = previousRunSpeedModifier == 0 and 1.0 or previousRunSpeedModifier;
        previousCombatSpeedModifier = previousCombatSpeedModifier == 0 and 1.0 or previousCombatSpeedModifier;
        setItemWithComparison(newRunSpeedModifier, previousRunSpeedModifier, "Tooltip_RunSpeedModifier", layoutItem,
            layoutTooltip, 2, false);
        setItemWithComparison(newCombatSpeedModifier, previousCombatSpeedModifier, "Tooltip_CombatSpeedModifier",
            layoutItem, layoutTooltip, 2, false);

    else
        if newHolesNumber ~= 0.0 then
            setItemWithoutComparison(newHolesNumber, "Tooltip_clothing_holes", layoutItem, layoutTooltip, 0);
        end
        if newCondition ~= 0.0 then
            setItemWithoutComparison(newCondition * 10, "Tooltip_weapon_Condition", layoutItem, layoutTooltip, 0);
        end
        if newInsulation ~= 0.0 then
            setItemWithoutComparison(newInsulation * 100, "Tooltip_item_Insulation", layoutItem, layoutTooltip, 0);
        end
        if newWindresistance ~= 0.0 then
            setItemWithoutComparison(newWindresistance * 100, "Tooltip_item_Windresist", layoutItem, layoutTooltip, 0);
        end
        if newWaterResistance ~= 0.0 then
            setItemWithoutComparison(newWaterResistance * 100, "Tooltip_item_Waterresist", layoutItem, layoutTooltip, 0);
        end
        if newBiteDefense ~= 0.0 then
            setItemWithoutComparison(newBiteDefense, "Tooltip_BiteDefense", layoutItem, layoutTooltip, 0);
        end
        if newScratchDefense ~= 0.0 then
            setItemWithoutComparison(newScratchDefense, "Tooltip_ScratchDefense", layoutItem, layoutTooltip, 0);
        end
        if newBulletDefense ~= 0.0 then
            setItemWithoutComparison(newBulletDefense, "Tooltip_BulletDefense", layoutItem, layoutTooltip, 0);
        end
        if newRunSpeedModifier ~= 0.0 then
            setItemWithoutComparison(newRunSpeedModifier, "Tooltip_RunSpeedModifier", layoutItem, layoutTooltip, 2);
        end
        if newCombatSpeedModifier ~= 0.0 then
            setItemWithoutComparison(newCombatSpeedModifier, "Tooltip_CombatSpeedModifier", layoutItem, layoutTooltip, 2);
        end
    end

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

        self.tooltip:setWidth(50)
        self.tooltip:setMeasureOnly(true)
        -- self.item:DoTooltip(self.tooltip);
        bcic_DoTooltip(self.tooltip, self.item); -- CONSEGUIR PEGAR O SELF.ITEM DENTRO DO DoTooltip PARA PODERMOS ELIMINAR ESSE RENDER
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
        --  self.item:DoTooltip(self.tooltip);
        bcic_DoTooltip(self.tooltip, self.item);
    end
end

-- function ISToolTipInv:bcic_render()
--     -- render the original method if the item isn't Clothing
--     if not self.item:IsClothing() then
--         original_render(self);
--         return;
--     end

--     -- we render the tool tip for inventory item only if there's no context menu showed
--     if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
--         local mx = getMouseX() + 24;
--         local my = getMouseY() + 24;

--         if not self.followMouse then
--             mx = self:getX()
--             my = self:getY()
--             if self.anchorBottomLeft then
--                 mx = self.anchorBottomLeft.x
--                 my = self.anchorBottomLeft.y
--             end
--         end

--         self.tooltip:setX(mx + 11);
--         self.tooltip:setY(my);

--         self.tooltip:setWidth(50);
--         self.tooltip:setMeasureOnly(true);
--         -- self.item:DoTooltip(self.tooltip);
--         bcic_DoTooltip(self.tooltip, self.item); -- CONSEGUIR PEGAR O SELF.ITEM DENTRO DO DoTooltip PARA PODERMOS ELIMINAR ESSE RENDER
--         self.tooltip:setMeasureOnly(false)

--         local myCore = getCore();
--         local maxX = myCore:getScreenWidth();
--         local maxY = myCore:getScreenHeight();

--         local tw = self.tooltip:getWidth();
--         local th = self.tooltip:getHeight();

--         if self.followMouse then
--             self:adjustPositionToAvoidOverlap({
--                 x = mx - 24 * 2,
--                 y = my - 24 * 2,
--                 width = 24 * 2,
--                 height = 24 * 2
--             });
--         end

--         self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r,
--             self.backgroundColor.g, self.backgroundColor.b);
--         self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
--             self.borderColor.b);

--         self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)));
--         if not self.followMouse and self.anchorBottomLeft then
--             self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)));
--         else
--             self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)));
--         end

--         self:setX(self.tooltip:getX() - 11);
--         self:setY(self.tooltip:getY());
--         self:setWidth(tw + 11);
--         self:setHeight(th);

--         bcic_DoTooltip(self.tooltip, self.item);
--     end
-- end

ISToolTipInv.render = ISToolTipInv.bcic_render;
