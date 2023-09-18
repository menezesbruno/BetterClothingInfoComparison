ISInventoryPaneContextMenu.doWearClothingTooltip = function(playerObj, newItem, currentItem, option)
	local replaceItems = {};
    local previousCondition = 0;
    local previousInsulation = 0;
    local previousWindResistance = 0;
	local previousBiteDefense = 0;
	local previousScratchDefense = 0;
	local previousCombatModifier = 0;
	local previousHolesNumber = 0;
	local wornItems = playerObj:getWornItems()
	local bodyLocationGroup = wornItems:getBodyLocationGroup()
	local location = newItem:IsClothing() and newItem:getBodyLocation() or newItem:canBeEquipped()

    

	for i=1,wornItems:size() do
		local wornItem = wornItems:get(i-1)
		local item = wornItem:getItem()
		if (newItem:getBodyLocation() == wornItem:getLocation()) or bodyLocationGroup:isExclusive(location, wornItem:getLocation()) then
			if item ~= newItem and item ~= currentItem then
				table.insert(replaceItems, item);
			end
			if item:IsClothing() then                
				previousCondition = previousCondition + item:getCondition();
				previousInsulation = previousInsulation + item:getInsulation();
				previousWindResistance = previousWindResistance + item:getWindresistance();
				previousBiteDefense = previousBiteDefense + item:getBiteDefense();
				previousScratchDefense = previousScratchDefense + item:getScratchDefense();
				previousCombatModifier = previousCombatModifier + item:getCombatSpeedModifier();
                previousHolesNumber = previousHolesNumber + item:getHolesNumber();
			end
		end
	end

	local newCondition = 0;
	local newInsulation = 0;
	local newWindResistance = 0;
	local newBiteDefense = 0;
	local newScratchDefense = 0;
	local newCombatModifier = 0;
	local newHolesNumber = 0;

	if newItem:IsClothing() then
		newCondition = newItem:getCondition();
		newInsulation = newItem:getInsulation();
		newWindResistance = newItem:getWindresistance();
		newBiteDefense = newItem:getBiteDefense();
		newScratchDefense = newItem:getScratchDefense();
		newCombatModifier = newItem:getCombatSpeedModifier();
        newHolesNumber = newItem:getHolesNumber();
	end

	if #replaceItems == 0 and newCondition == 0 and newInsulation == 0 and newWindResistance == 0 and newBiteDefense == 0 and newScratchDefense == 0 and newHolesNumber == 0 and previousCondition == 0 and previousInsulation == 0 and previousWindResistance == 0 and previousBiteDefense == 0 and previousScratchDefense == 0 and previousHolesNumber == 0 then
		return nil
	end
	
	local tooltip = ISInventoryPaneContextMenu.addToolTip();
	tooltip.maxLineWidth = 1000

	if #replaceItems > 0 then
		tooltip.description = tooltip.description .. getText("Tooltip_ReplaceWornItems") .. " <LINE> <INDENT:20> ";
		for _,item in ipairs(replaceItems) do
			tooltip.description = tooltip.description .. item:getDisplayName() .. " <LINE> ";
		end
		tooltip.description = tooltip.description .. " <INDENT:0> ";
	end

	local font = ISToolTip.GetFont()

	local labelWidth = 0
	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_weapon_Condition") .. ":"));
	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_item_Insulation") .. ":"));
	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_item_Windresist") .. ":"));
	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_BiteDefense") .. ":"));
	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_ScratchDefense") .. ":"));
    --	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_CombatSpeed") .. ":"));
	labelWidth = math.max(labelWidth, getTextManager():MeasureStringX(font, getText("Tooltip_clothing_holes") .. ":"));

	local text;  
    
    -- condition
	if newCondition > 0 or previousCondition > 0 then
        local hc = getCore():getGoodHighlitedColor()
		local plus = "+";
		if previousCondition > 0 and previousCondition > newCondition then
            hc = getCore():getBadHighlitedColor()
			plus = "";
		end
		text = string.format(" <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ",
            hc:getR(), hc:getG(), hc:getB(), getText("Tooltip_weapon_Condition"), labelWidth + 10,
			newCondition * 10,
			plus,
			newCondition * 10 - previousCondition * 10);
		tooltip.description = tooltip.description .. text;
	end

    -- insulation
	if newInsulation > 0 or previousInsulation > 0 then
        local hc = getCore():getGoodHighlitedColor()
		local plus = "+";
		if previousInsulation > 0 and previousInsulation > newInsulation then
            hc = getCore():getBadHighlitedColor()
			plus = "";
		end
		text = string.format(" <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ",
            hc:getR(), hc:getG(), hc:getB(), getText("Tooltip_item_Insulation"), labelWidth + 10,
			newInsulation * 100,
			plus,
			newInsulation * 100 - previousInsulation * 100);
		tooltip.description = tooltip.description .. text;
	end

    -- wind resistance
	if newWindResistance > 0 or previousWindResistance > 0 then
        local hc = getCore():getGoodHighlitedColor()
		local plus = "+";
		if previousWindResistance > 0 and previousWindResistance > newWindResistance then
            hc = getCore():getBadHighlitedColor()
			plus = "";
		end
		text = string.format(" <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ",
            hc:getR(), hc:getG(), hc:getB(), getText("Tooltip_item_Windresist"), labelWidth + 10,
			newWindResistance * 100,
			plus,
			newWindResistance * 100 - previousWindResistance * 100);
		tooltip.description = tooltip.description .. text;
	end

	-- bite defense
	if newBiteDefense > 0 or previousBiteDefense > 0 then
        local hc = getCore():getGoodHighlitedColor()
		local plus = "+";
		if previousBiteDefense > 0 and previousBiteDefense > newBiteDefense then
            hc = getCore():getBadHighlitedColor()
			plus = "";
		end
		text = string.format(" <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ",
            hc:getR(), hc:getG(), hc:getB(), getText("Tooltip_BiteDefense"), labelWidth + 10,
			newBiteDefense,
			plus,
			newBiteDefense - previousBiteDefense);
		tooltip.description = tooltip.description .. text;
	end
	
	-- scratch defense
	if newScratchDefense > 0 or previousScratchDefense > 0 then
        local hc = getCore():getGoodHighlitedColor()
		local plus = "+";
		if previousScratchDefense > 0 and previousScratchDefense > newScratchDefense then
            hc = getCore():getBadHighlitedColor()
			plus = "";
		end
		text = string.format(" <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ",
            hc:getR(), hc:getG(), hc:getB(), getText("Tooltip_ScratchDefense"), labelWidth + 10,
			newScratchDefense,
			plus,
			newScratchDefense - previousScratchDefense);
		tooltip.description = tooltip.description .. text;
	end

--[[
	-- combat speed -- TODO: Better calcul!
	if previousCombatModifier > 0 and previousCombatModifier > newCombatModifier then
		text = " <RGB:0,1,0> " .. getText("Tooltip_CombatSpeed") .. ": +";
		text = " <RGB:1,0,0> " .. getText("Tooltip_CombatSpeed") .. ": ";
	end
	tooltip.description = tooltip.description ..  text .. newCombatModifier-previousCombatModifier;
--]]

    -- holes number
    if newHolesNumber > 0 or previousHolesNumber > 0 then
        local hc = getCore():getBadHighlitedColor()
        local plus = "+";
        if previousHolesNumber > 0 and previousHolesNumber > newHolesNumber then
            hc = getCore():getGoodHighlitedColor()
            plus = "";
        end
        text = string.format(" <LINE> <RGB:%.2f,%.2f,%.2f> %s: <SETX:%d> %d (%s%d) <LINE> ",
            hc:getR(), hc:getG(), hc:getB(), getText("Tooltip_clothing_holes"), labelWidth + 10,
            newHolesNumber,
            plus,
            newHolesNumber - previousHolesNumber);
        tooltip.description = tooltip.description .. text;
    end

	option.toolTip = tooltip;

	return replaceItems;
end