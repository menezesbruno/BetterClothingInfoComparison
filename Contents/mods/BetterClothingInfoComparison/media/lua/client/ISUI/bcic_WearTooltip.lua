-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-10-07)
-- based on: 41+

ISInventoryPaneContextMenu.formatWearTooltip = function(tooltip, labelWidth, previous, new, multiplicationFactor,
                                                        labelTooltip, invertHC, lineBefore)
    local newLine = lineBefore and " <LINE>" or "";
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
    local plus = "";

    if previous > 0 and previous > new then
        hc = invertHC and getCore():getGoodHighlitedColor() or getCore():getBadHighlitedColor();
        plus = "";
    end
    if new > 0 and new > previous then
        hc = invertHC and getCore():getBadHighlitedColor() or getCore():getGoodHighlitedColor();
        plus = "+";
    end

    local text = string.format(newLine .. " <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ", hc:getR(), hc:getG(),
        hc:getB(), getText(labelTooltip), labelWidth + 10, new * multiplicationFactor, plus,
        new * multiplicationFactor - previous * multiplicationFactor);
    tooltip.description = tooltip.description .. text;
end

ISInventoryPaneContextMenu.doWearClothingTooltip = function(playerObj, newItem, currentItem, option)
    local replaceItems = {};
    local previousCondition = 0;
    local previousInsulation = 0;
    local previousWindResistance = 0;
    local previousBiteDefense = 0;
    local previousScratchDefense = 0;
    local previousHolesNumber = 0;
    local wornItems = playerObj:getWornItems()
    local bodyLocationGroup = wornItems:getBodyLocationGroup()
    local location = newItem:IsClothing() and newItem:getBodyLocation() or newItem:canBeEquipped()

    for i = 1, wornItems:size() do
        local wornItem = wornItems:get(i - 1)
        local item = wornItem:getItem()
        if (newItem:getBodyLocation() == wornItem:getLocation()) or
            bodyLocationGroup:isExclusive(location, wornItem:getLocation()) then
            if item ~= newItem and item ~= currentItem then
                table.insert(replaceItems, item);
            end
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

    local newCondition = 0;
    local newInsulation = 0;
    local newWindResistance = 0;
    local newBiteDefense = 0;
    local newScratchDefense = 0;
    local newHolesNumber = 0;

    if newItem:IsClothing() then
        newCondition = newItem:getCondition();
        newInsulation = newItem:getInsulation();
        newWindResistance = newItem:getWindresistance();
        newBiteDefense = newItem:getBiteDefense();
        newScratchDefense = newItem:getScratchDefense();
        newHolesNumber = newItem:getHolesNumber();
    end

    if #replaceItems == 0 and newCondition == 0 and newInsulation == 0 and newWindResistance == 0 and newBiteDefense ==
        0 and newScratchDefense == 0 and newHolesNumber == 0 and previousCondition == 0 and previousInsulation == 0 and
        previousWindResistance == 0 and previousBiteDefense == 0 and previousScratchDefense == 0 and previousHolesNumber ==
        0 then
        return nil
    end

    local tooltip = ISInventoryPaneContextMenu.addToolTip();
    tooltip.maxLineWidth = 1000

    if #replaceItems > 0 then
        tooltip.description = tooltip.description .. getText("Tooltip_ReplaceWornItems") .. " <LINE> <INDENT:20> ";
        for _, item in ipairs(replaceItems) do
            tooltip.description = tooltip.description .. item:getDisplayName() .. " <LINE> ";
        end
        tooltip.description = tooltip.description .. " <INDENT:0> ";
    end

    local font = ISToolTip.GetFont();

    local labelWidth = 0
    labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_weapon_Condition") .. ":"));
    labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_item_Insulation") .. ":"));
    labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_item_Windresist") .. ":"));
    labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_BiteDefense") .. ":"));
    labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_ScratchDefense") .. ":"));
    labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_clothing_holes") .. ":"));

    ISInventoryPaneContextMenu.formatWearTooltip(tooltip, labelWidth, previousCondition, newCondition, 10,
        "Tooltip_weapon_Condition", false, false);
    ISInventoryPaneContextMenu.formatWearTooltip(tooltip, labelWidth, previousInsulation, newInsulation, 100,
        "Tooltip_item_Insulation", false, false);
    ISInventoryPaneContextMenu.formatWearTooltip(tooltip, labelWidth, previousWindResistance, newWindResistance, 100,
        "Tooltip_item_Windresist", false, false);
    ISInventoryPaneContextMenu.formatWearTooltip(tooltip, labelWidth, previousBiteDefense, newBiteDefense, 1,
        "Tooltip_BiteDefense", false, false);
    ISInventoryPaneContextMenu.formatWearTooltip(tooltip, labelWidth, previousScratchDefense, newScratchDefense, 1,
        "Tooltip_ScratchDefense", false, false);
    ISInventoryPaneContextMenu.formatWearTooltip(tooltip, labelWidth, previousHolesNumber, newHolesNumber, 1,
        "Tooltip_clothing_holes", true, true);

    option.toolTip = tooltip;

    return replaceItems;
end
