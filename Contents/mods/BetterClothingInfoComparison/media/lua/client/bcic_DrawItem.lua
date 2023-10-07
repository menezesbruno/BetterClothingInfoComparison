-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-10-07)
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
