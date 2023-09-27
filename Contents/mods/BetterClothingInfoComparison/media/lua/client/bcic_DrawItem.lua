-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-09-25)
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
    if draw and (self.newItemValue ~= 1 and (self.label ~= "Tooltip_RunSpeedModifier" or self.label ~= "Tooltip_CombatSpeedModifier")) then
        if self.isEquipped and self.newItemValue ~= 0.0 then
            SetItemWithoutComparison(self.newItemValue, self.label, self.layoutItem, self.layoutTooltip, self.decimal);
        elseif not self.isEquipped then
            SetItemWithComparison(self.newItemValue, self.previousItemValue, self.label, self.layoutItem,
                self.layoutTooltip, self.decimal, self.reverse);
        end
    end
end
