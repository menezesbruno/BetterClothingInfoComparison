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

        self.tooltip:setWidth(50)
        self.tooltip:setMeasureOnly(true)
        self.item:DoTooltip(self.tooltip);
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

        self.item:DoTooltip(self.tooltip);
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

    formatTooltipInv(tooltipContext, nil, nil, nil, "Item Comparison", false);
    formatTooltipInv(tooltipContext, previousCondition, newCondition, 10, "Tooltip_weapon_Condition", false);
    formatTooltipInv(tooltipContext, previousInsulation, newInsulation, 100, "Tooltip_item_Insulation", false);
    formatTooltipInv(tooltipContext, previousWindResistance, newWindResistance, 100, "Tooltip_item_Windresist", false);
    formatTooltipInv(tooltipContext, previousBiteDefense, newBiteDefense, 1, "Tooltip_BiteDefense", false);
    formatTooltipInv(tooltipContext, previousScratchDefense, newScratchDefense, 1, "Tooltip_ScratchDefense", false);
    formatTooltipInv(tooltipContext, previousHolesNumber, newHolesNumber, 1, "Tooltip_clothing_holes", true);

    -- adjust window
    th = y_position;
    th = th + 20;
    tw = tw + 5;

    return tw, th;
end

function formatTooltipInv(tooltipContext, previous, new, multiplicationFactor, labelTooltip, invertHC)
    y_position = y_position + 15;
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

    tooltipContext:DrawText(tooltipContext:getFont(), getText(labelTooltip), label_x_position, y_position, hc:getR(),
        hc:getG(), hc:getB(), 1);
    tooltipContext:DrawText(tooltipContext:getFont(), text, value_x_position, y_position, hc:getR(), hc:getG(),
        hc:getB(), 1);
end
