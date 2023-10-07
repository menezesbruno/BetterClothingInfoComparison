-- author: Bruno Menezes & Fred Davin
-- version: 0.2a (2023-10-07)
-- based on: 41+

-- These are the settings.
BCIC_SETTINGS = {
    options = {
        -- Progress Bar
        ShowConditionProgressBar          = true,
        ShowInsulationProgressBar         = true,
        ShowWindResistanceProgressBar     = true,
        ShowWaterResistanceProgressBar    = true,
        ShowBiteDefenseProgressBar        = true,
        ShowScratchDefenseProgressBar     = true,
        ShowBloodyLevelProgressBar        = true,
        ShowDirtynessProgressBar          = true,
        ShowWetnessProgressBar            = true,

        -- Comparison
        ShowHolesComparison               = true,
        ShowConditionComparison           = true,
        ShowInsulationComparison          = true,
        ShowWindResistanceComparison      = true,
        ShowWaterResistanceComparison     = true,
        ShowBiteDefenseComparison         = true,
        ShowScratchDefenseComparison      = true,
        ShowBulletDefenseComparison       = true,
        ShowRunSpeedModifierComparison    = true,
        ShowCombatSpeedModifierComparison = true,
        ShowClothingMaterial              = true
    },
    names = {
        -- Progress Bar
        ShowConditionProgressBar = "Show Condition Progress Bar",
        ShowInsulationProgressBar = "Show Insulation Progress Bar",
        ShowWindResistanceProgressBar = "Show Wind Resistance Progress Bar",
        ShowWaterResistanceProgressBar = "Show Water Resistance Progress Bar",
        ShowBiteDefenseProgressBar = "Show Bite Defense Progress Bar",
        ShowScratchDefenseProgressBar = "Show Scratch Defense Progress Bar",
        ShowBloodyLevelProgressBar = "Show Bloody Level Progress Bar",
        ShowDirtynessProgressBar = "Show Dirtyness Progress Bar",
        ShowWetnessProgressBar = "Show Wetness Progress Bar",

        -- Comparison
        ShowHolesComparison = "Show Holes Comparison",
        ShowConditionComparison = "Show Condition Comparison",
        ShowInsulationComparison = "Show Insulation Comparison",
        ShowWindResistanceComparison = "Show Wind Resistance Comparison",
        ShowWaterResistanceComparison = "Show Water Resistance Comparison",
        ShowBiteDefenseComparison = "Show Bite Defense Comparison",
        ShowScratchDefenseComparison = "Show Scratch Defense Comparison",
        ShowBulletDefenseComparison = "Show Bullet Defense Comparison",
        ShowRunSpeedModifierComparison = "Show Run Speed Modifier Comparison",
        ShowCombatSpeedModifierComparison = "Show Combat Speed Modifier Comparison",
        ShowClothingMaterial = "Show Clothing Material"
    },
    mod_id = "BetterClothingInfoComparison",
    mod_shortname = "Better Clothing Info Comparison",
}

-- Connecting the settings to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(BCIC_SETTINGS);

    -- Progress Bar
    ShowConditionProgressBar = settings:getData("showConditionProgressBar");
    ShowInsulationProgressBar = settings:getData("showInsulationProgressBar");
    ShowWindResistanceProgressBar = settings:getData("showWindResistanceProgressBar");
    ShowWaterResistanceProgressBar = settings:getData("showWaterResistanceProgressBar");
    ShowBiteDefenseProgressBar = settings:getData("showBiteDefenseProgressBar");
    ShowScratchDefenseProgressBar = settings:getData("showScratchDefenseProgressBar");
    ShowBloodyLevelProgressBar = settings:getData("ShowBloodyLevelProgressBar");
    ShowDirtynessProgressBar = settings:getData("showDirtynessProgressBar");
    ShowWetnessProgressBar = settings:getData("showWetnessProgressBar");

    --- Comparison
    ShowHolesComparison = settings:getData("showHolesComparison");
    ShowConditionComparison = settings:getData("showConditionComparison");
    ShowInsulationComparison = settings:getData("showInsulationComparison");
    ShowWindResistanceComparison = settings:getData("showWindResistanceComparison");
    ShowWaterResistanceComparison = settings:getData("showWaterResistanceComparison");
    ShowBiteDefenseComparison = settings:getData("showBiteDefenseComparison");
    ShowScratchDefenseComparison = settings:getData("showScratchDefenseComparison");
    ShowBulletDefenseComparison = settings:getData("showBulletDefenseComparison");
    ShowRunSpeedModifierComparison = settings:getData("showRunSpeedModifierComparison");
    ShowCombatSpeedModifierComparison = settings:getData("showCombatSpeedModifierComparison");
    ShowClothingMaterial = settings:getData("ShowClothingMaterial");
end
