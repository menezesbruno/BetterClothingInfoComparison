-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-09-30)
-- based on: 41+

DrawItem = {}

function DrawItem:New(newItemValue, previousItemValue, label, layoutItem, layoutTooltip, decimal, reverse, isEquipped)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.newItemValue = newItemValue;
    o.previousItemValue = previousItemValue;
    o.label = label;
    o.layoutItem = layoutItem;
    o.layoutTooltip = layoutTooltip;
    o.decimal = decimal;
    o.reverse = reverse;
    o.isEquipped = isEquipped;
    return o;
end

function DrawItem:Render(draw)
    if draw then
        if 'string' == type(self.newItemValue) then
            DrawItemAsText(self);
        elseif 'number' == type(self.newItemValue) then
            DrawItemAsNumber(self);
        end
    end
end

function DrawItemAsText(self)
    SetItemInfoAsText(self.newItemValue, self.label, self.layoutItem, self.layoutTooltip);
end

function DrawItemAsNumber(self)
    if self.label == "Tooltip_RunSpeedModifier" or self.label == "Tooltip_CombatSpeedModifier" then
        if self.isEquipped and self.newItemValue ~= 1.0 then
            SetItemWithoutComparison(self.newItemValue, self.label, self.layoutItem, self.layoutTooltip, self
                .decimal);
        end
        if not self.isEquipped then
            SetItemWithComparison(self.newItemValue, self.previousItemValue, self.label, self.layoutItem,
                self.layoutTooltip, self.decimal, self.reverse);
        end
        return;
    end

    if self.isEquipped and self.newItemValue ~= 0.0 then
        SetItemWithoutComparison(self.newItemValue, self.label, self.layoutItem, self.layoutTooltip, self
            .decimal);
        return;
    end

    if not self.isEquipped then
        SetItemWithComparison(self.newItemValue, self.previousItemValue, self.label, self.layoutItem,
            self.layoutTooltip, self.decimal, self.reverse);
        return;
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
