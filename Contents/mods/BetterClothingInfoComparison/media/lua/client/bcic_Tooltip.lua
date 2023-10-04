-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-10-04)
-- based on: 41+

require "ISUI/ISToolTipInv"
require "bcic_TooltipClothing"

local original_render = ISToolTipInv.render;

function bcic_DoTooltip(objTooltip, item)
    objTooltip:render();
    local tooltipFont = objTooltip:getFont();
    local tooltipLineSpacing = objTooltip:getLineSpacing();
    local padding = 5;

    local itemName = item:getName();
    objTooltip:DrawText(tooltipFont, itemName, 5.0, padding, 1.0, 1.0, 0.8, 1.0);

    objTooltip:adjustWidth(5, itemName);
    padding = padding + tooltipLineSpacing + 5;

    local layoutTooltip = objTooltip:beginLayout();
    layoutTooltip:setMinLabelWidth(80);
    local layout = layoutTooltip:addItem();
    layout:setLabel(getText("Tooltip_item_Weight") .. ":", 1, 1, 0.8, 1);

    if item:isEquipped() then
        local equippedWeight = item:getCleanString(item:getEquippedWeight());
        layout:setValue(equippedWeight .. "    (" .. item:getCleanString(item:getUnequippedWeight()) .. " " ..
            getText("Tooltip_item_Unequipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    elseif item:getAttachedSlot() > -1 then
        local equippedWeight = item:getCleanString(item:getHotbarEquippedWeight());
        layout:setValue(equippedWeight .. "    (" .. item:getCleanString(item:getUnequippedWeight()) .. " " ..
            getText("Tooltip_item_Unequipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    else
        local unequippedWeight = item:getCleanString(item:getUnequippedWeight());
        layout:setValue(unequippedWeight .. "    (" .. item:getCleanString(item:getEquippedWeight()) .. " " ..
            getText("Tooltip_item_Equipped") .. ")", 1.0, 1.0, 1.0, 1.0);
    end

    local weightOfStack = objTooltip:getWeightOfStack();
    if weightOfStack > 0.0 then
        layout = layoutTooltip:addItem();
        layout:setLabel(getText("Tooltip_item_StackWeight") .. ":", 1.0, 1.0, 0.8, 1.0);
        
        if weightOfStack > 0.0 and weightOfStack < 0.01 then
            weightOfStack = 0.01;
        end

        layout:setValueRightNoPlus(weightOfStack);
    end

    -- if (Core.bDebug && DebugOptions.instance.TooltipInfo.getValue()) {
    --     var15 = var14.addItem();
    --     var15.setLabel("getActualWeight()", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.getActualWeight());
    --     var15 = var14.addItem();
    --     var15.setLabel("getWeight()", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.getWeight());
    --     var15 = var14.addItem();
    --     var15.setLabel("getEquippedWeight()", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.getEquippedWeight());
    --     var15 = var14.addItem();
    --     var15.setLabel("getUnequippedWeight()", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.getUnequippedWeight());
    --     var15 = var14.addItem();
    --     var15.setLabel("getContentsWeight()", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.getContentsWeight());
    --     if (this instanceof Key || "Doorknob".equals(this.type)) {
    --         var15 = var14.addItem();
    --         var15.setLabel("DBG: keyId", 1.0F, 1.0F, 0.8F, 1.0F);
    --         var15.setValueRightNoPlus(this.getKeyId());
    --     }

    --     var15 = var14.addItem();
    --     var15.setLabel("ID", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.id);
    --     var15 = var14.addItem();
    --     var15.setLabel("DictionaryID", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRightNoPlus(this.registry_id);
    --     ClothingItem var21 = this.getClothingItem();
    --     if (var21 != null) {
    --         var15 = var14.addItem();
    --         var15.setLabel("ClothingItem", 1.0F, 1.0F, 1.0F, 1.0F);
    --         var15.setValue(this.getClothingItem().m_Name, 1.0F, 1.0F, 1.0F, 1.0F);
    --     }
    -- }

    -- if (this.getFatigueChange() != 0.0F) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_item_Fatigue") + ": ", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValueRight((int)(this.getFatigueChange() * 100.0F), false);
    -- }

    -- ColorInfo var11;
    -- if (this instanceof DrainableComboItem) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("IGUI_invpanel_Remaining") + ": ", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var17 = ((DrainableComboItem)this).getUsedDelta();
    --     var11 = new ColorInfo();
    --     Core.getInstance().getBadHighlitedColor().interp(Core.getInstance().getGoodHighlitedColor(), var17, var11);
    --     var15.setProgress(var17, var11.getR(), var11.getG(), var11.getB(), 1.0F);
    -- }

    -- if (this.isTaintedWater() && SandboxOptions.instance.EnableTaintedWaterText.getValue()) {
    --     var15 = var14.addItem();
    --     if (this.isCookable()) {
    --         var15.setLabel(Translator.getText("Tooltip_item_TaintedWater"), 1.0F, 0.5F, 0.5F, 1.0F);
    --     } else {
    --         var15.setLabel(Translator.getText("Tooltip_item_TaintedWater_Plastic"), 1.0F, 0.5F, 0.5F, 1.0F);
    --     }
    -- }

    DoTooltipClothing(objTooltip, item, layoutTooltip);

    -- if (this.getRemoteControlID() != -1) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_TrapControllerID"), 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValue(Integer.toString(this.getRemoteControlID()), 1.0F, 1.0F, 0.8F, 1.0F);
    -- }

    -- if (!FixingManager.getFixes(this).isEmpty()) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_weapon_Repaired") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --     if (this.getHaveBeenRepaired() == 1) {
    --         var15.setValue(Translator.getText("Tooltip_never"), 1.0F, 1.0F, 1.0F, 1.0F);
    --     } else {
    --         var15.setValue(this.getHaveBeenRepaired() - 1 + "x", 1.0F, 1.0F, 1.0F, 1.0F);
    --     }
    -- }

    -- if (this.isEquippedNoSprint()) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_CantSprintEquipped"), 1.0F, 0.1F, 0.1F, 1.0F);
    -- }

    -- if (this.isWet()) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_Wetness") + ": ", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var17 = this.getWetCooldown() / 10000.0F;
    --     var11 = new ColorInfo();
    --     Core.getInstance().getGoodHighlitedColor().interp(Core.getInstance().getBadHighlitedColor(), var17, var11);
    --     var15.setProgress(var17, var11.getR(), var11.getG(), var11.getB(), 1.0F);
    -- }

    -- if (this.getMaxCapacity() > 0) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_container_Capacity") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var17 = (float)this.getMaxCapacity();
    --     if (this.isConditionAffectsCapacity()) {
    --         var17 = VehiclePart.getNumberByCondition((float)this.getMaxCapacity(), (float)this.getCondition(), 5.0F);
    --     }

    --     if (this.getItemCapacity() > -1.0F) {
    --         var15.setValue(this.getItemCapacity() + " / " + var17, 1.0F, 1.0F, 0.8F, 1.0F);
    --     } else {
    --         var15.setValue("0 / " + var17, 1.0F, 1.0F, 0.8F, 1.0F);
    --     }
    -- }

    -- if (this.getConditionMax() > 0 && this.getMechanicType() > 0) {
    --     var15 = var14.addItem();
    --     var15.setLabel(Translator.getText("Tooltip_weapon_Condition") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --     var15.setValue(this.getCondition() + " / " + this.getConditionMax(), 1.0F, 1.0F, 0.8F, 1.0F);
    -- }

    -- if (this.isRecordedMedia()) {
    --     MediaData var22 = this.getMediaData();
    --     if (var22 != null) {
    --         if (var22.getTranslatedTitle() != null) {
    --             var15 = var14.addItem();
    --             var15.setLabel(Translator.getText("Tooltip_media_title") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --             var15.setValue(var22.getTranslatedTitle(), 1.0F, 1.0F, 1.0F, 1.0F);
    --             if (var22.getTranslatedSubTitle() != null) {
    --                 var15 = var14.addItem();
    --                 var15.setLabel("", 1.0F, 1.0F, 0.8F, 1.0F);
    --                 var15.setValue(var22.getTranslatedSubTitle(), 1.0F, 1.0F, 1.0F, 1.0F);
    --             }
    --         }

    --         if (var22.getTranslatedAuthor() != null) {
    --             var15 = var14.addItem();
    --             var15.setLabel(Translator.getText("Tooltip_media_author") + ":", 1.0F, 1.0F, 0.8F, 1.0F);
    --             var15.setValue(var22.getTranslatedAuthor(), 1.0F, 1.0F, 1.0F, 1.0F);
    --         }
    --     }
    -- }

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
        layout:setLabel(getText(item:getTooltip()), 1.0, 1.0, 0.8, 1.0);
    end

    padding = layoutTooltip:render(5, padding, objTooltip);
    objTooltip:endLayout(layoutTooltip);
    padding = padding + 5;
    objTooltip:setHeight(padding);
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

    if self.item ~= nil and self.tooltip ~= nil and self.item:IsClothing() then
        bcic_DoTooltip(self.tooltip, self.item);
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

    if self.item ~= nil and self.tooltip ~= nil and self.item:IsClothing() then
        bcic_DoTooltip(self.tooltip, self.item);
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
