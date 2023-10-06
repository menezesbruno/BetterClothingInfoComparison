-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-10-06)
-- based on: 41+

function DoTooltipClothing(objTooltip, item, layoutTooltip)
    if item:isCosmetic() then
        return;
    end

    local layoutItem;

    -- New Item
    local newItemHolesNumber = item:getHolesNumber();
    local newItemCondition = item:getCondition();
    local newItemInsulation = item:getInsulation();
    local newItemWindresistance = item:getWindresistance();
    local newItemWaterResistance = item:getWaterResistance();
    local newItemBiteDefense = item:getBiteDefense();
    local newItemScratchDefense = item:getScratchDefense();
    local newItemBulletDefense = item:getBulletDefense();
    local newItemRunSpeedModifier = item:getRunSpeedModifier();
    local newItemCombatSpeedModifier = item:getCombatSpeedModifier();
    local newItemClothingMaterial = item:getFabricType();

    -- Previous Item
    local previousItemHolesNumber = 0.0;
    local previousItemCondition = 0.0;
    local previousItemInsulation = 0.0;
    local previousItemWindResistance = 0.0;
    local previousItemWaterResistance = 0.0;
    local previousItemBiteDefense = 0.0;
    local previousItemScratchDefense = 0.0;
    local previousItemBulletDefense = 0.0;
    local previousItemRunSpeedModifier = 0.0;
    local previousItemCombatSpeedModifier = 0.0;

    -- ProgressBar
    local conditionState = newItemCondition / item:getConditionMax();
    DrawProgressBar(conditionState, "Tooltip_weapon_Condition", layoutItem, layoutTooltip,
        BCIC_SETTINGS.options.ShowConditionProgressBar);
    DrawProgressBar(newItemInsulation, "Tooltip_item_Insulation", layoutItem, layoutTooltip,
        BCIC_SETTINGS.options.ShowInsulationProgressBar);
    DrawProgressBar(newItemWindresistance, "Tooltip_item_Windresist", layoutItem, layoutTooltip,
        BCIC_SETTINGS.options.ShowWindResistanceProgressBar);
    DrawProgressBar(newItemWaterResistance, "Tooltip_item_Waterresist", layoutItem, layoutTooltip,
        BCIC_SETTINGS.options.ShowWaterResistanceProgressBar);
    DrawProgressBar(newItemBiteDefense / 100, "Tooltip_BiteDefense", layoutItem, layoutTooltip,
        BCIC_SETTINGS.options.ShowBiteDefenseProgressBar);
    DrawProgressBar(newItemScratchDefense / 100, "Tooltip_ScratchDefense", layoutItem, layoutTooltip,
        BCIC_SETTINGS.options.ShowScratchDefenseProgressBar);

    if item:getBloodlevel() ~= 0.0 then
        local bloodState = item:getBloodlevel() / 100.0;
        DrawProgressBar(bloodState, "Tooltip_clothing_bloody", layoutItem, layoutTooltip,
            BCIC_SETTINGS.options.ShowBloodyLevelProgressBar);
    end

    if item:getDirtyness() >= 1.0 then
        local dirtynessState = item:getDirtyness() / 100.0;
        DrawProgressBar(dirtynessState, "Tooltip_clothing_dirty", layoutItem, layoutTooltip,
            BCIC_SETTINGS.options.ShowDirtynessProgressBar);
    end

    if item:getWetness() ~= 0.0 then
        local wetnessState = item:getWetness() / 100.0;
        DrawProgressBar(wetnessState, "Tooltip_clothing_wet", layoutItem, layoutTooltip,
            BCIC_SETTINGS.options.ShowWetnessProgressBar);
    end
    -- End ProgressBar

    if not item:isEquipped() and objTooltip:getCharacter() ~= nil then
        local wornItems = objTooltip:getCharacter():getWornItems();
        local bodyLocationGroup = wornItems:getBodyLocationGroup();
        local location = item:getBodyLocation();

        for i = 1, wornItems:size() do
            local wornItemInventory = wornItems:get(i - 1);
            local wornItem = wornItemInventory:getItem();
            local bodyLocationComparer = false;

            if bodyLocationGroup ~= nil then
                bodyLocationComparer = bodyLocationGroup:isExclusive(location, wornItemInventory:getLocation());
            end

            if wornItem:IsClothing() and (location == wornItemInventory:getLocation() or bodyLocationComparer) then
                previousItemHolesNumber = previousItemHolesNumber + wornItem:getHolesNumber();
                previousItemCondition = previousItemCondition + wornItem:getCondition();
                previousItemInsulation = previousItemInsulation + wornItem:getInsulation();
                previousItemWindResistance = previousItemWindResistance + wornItem:getWindresistance();
                previousItemWaterResistance = previousItemWaterResistance + wornItem:getWaterResistance();
                previousItemBiteDefense = previousItemBiteDefense + wornItem:getBiteDefense();
                previousItemScratchDefense = previousItemScratchDefense + wornItem:getScratchDefense();
                previousItemBulletDefense = previousItemBulletDefense + wornItem:getBulletDefense();
                previousItemRunSpeedModifier = previousItemRunSpeedModifier + wornItem:getRunSpeedModifier();
                previousItemCombatSpeedModifier = previousItemCombatSpeedModifier + wornItem:getCombatSpeedModifier();
            end
        end
    end

    previousItemRunSpeedModifier = previousItemRunSpeedModifier == 0 and 1.0 or previousItemRunSpeedModifier;
    previousItemCombatSpeedModifier = (previousItemCombatSpeedModifier == 0 or previousItemCombatSpeedModifier > 1) and
        1.0 or previousItemCombatSpeedModifier;

    local holesComparison = DrawItem:New(newItemHolesNumber, previousItemHolesNumber, "Tooltip_clothing_holes",
        layoutItem, layoutTooltip, 0, true, item:isEquipped());

    local conditionComparison = DrawItem:New(newItemCondition * 10, previousItemCondition * 10,
        "Tooltip_weapon_Condition", layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local insulationComparison = DrawItem:New(newItemInsulation * 100, previousItemInsulation * 100,
        "Tooltip_item_Insulation", layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local windResistanceComparison = DrawItem:New(newItemWindresistance * 100, previousItemWindResistance * 100,
        "Tooltip_item_Windresist", layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local waterResistanceComparison = DrawItem:New(newItemWaterResistance * 100, previousItemWaterResistance * 100,
        "Tooltip_item_Waterresist", layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local biteDefenseComparison = DrawItem:New(newItemBiteDefense, previousItemBiteDefense, "Tooltip_BiteDefense",
        layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local scratchDefenseComparison = DrawItem:New(newItemScratchDefense, previousItemScratchDefense,
        "Tooltip_ScratchDefense", layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local bulletDefenseComparison = DrawItem:New(newItemBulletDefense, previousItemBulletDefense, "Tooltip_BulletDefense",
        layoutItem, layoutTooltip, 0, false, item:isEquipped());

    local runSpeedModifier = DrawItem:New(newItemRunSpeedModifier, previousItemRunSpeedModifier,
        "Tooltip_RunSpeedModifier", layoutItem, layoutTooltip, 2, false, item:isEquipped());

    local combatSpeedModifier = DrawItem:New(newItemCombatSpeedModifier, previousItemCombatSpeedModifier,
        "Tooltip_CombatSpeedModifier", layoutItem, layoutTooltip, 2, false, item:isEquipped());

    local clothingMaterial = DrawItem:New(newItemClothingMaterial, nil, "IGUI_ItemCat_Material", layoutItem,
        layoutTooltip, nil, nil, nil);

    holesComparison:Render(BCIC_SETTINGS.options.ShowHolesComparison);
    conditionComparison:Render(BCIC_SETTINGS.options.ShowConditionComparison);
    insulationComparison:Render(BCIC_SETTINGS.options.ShowInsulationComparison);
    windResistanceComparison:Render(BCIC_SETTINGS.options.ShowWindResistanceComparison);
    waterResistanceComparison:Render(BCIC_SETTINGS.options.ShowWaterResistanceComparison);
    biteDefenseComparison:Render(BCIC_SETTINGS.options.ShowBiteDefenseComparison);
    scratchDefenseComparison:Render(BCIC_SETTINGS.options.ShowScratchDefenseComparison);
    bulletDefenseComparison:Render(BCIC_SETTINGS.options.ShowBulletDefenseComparison);
    runSpeedModifier:Render(BCIC_SETTINGS.options.ShowRunSpeedModifierComparison);
    combatSpeedModifier:Render(BCIC_SETTINGS.options.ShowCombatSpeedModifierComparison);
    clothingMaterial:Render(BCIC_SETTINGS.options.ShowClothingMaterial);
end
