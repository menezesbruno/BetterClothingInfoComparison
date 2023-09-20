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
            self:adjustPositionToAvoidOverlap({ x = mx - 24 * 2, y = my - 24 * 2, width = 24 * 2, height = 24 * 2 });
        end

        self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r,
            self.backgroundColor.g, self.backgroundColor.b);
        self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
            self.borderColor.b);

        if self.item:IsClothing() then
            tw, th = RenderTooltipClothing(self.tooltip, self.item, tw, th);
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

function RenderTooltipClothing(tooltipContext, itemContext, tw, th)
    y_position = tooltipContext:getHeight() + lineHeight * 0.2;

    -- item statistcs
    RenderInfo("Item Statistcs", nil, nil, tooltipContext);

    -- condition
    RenderInfo("Tooltip_weapon_Condition", itemContext:getCondition(), itemContext:getConditionMax(), tooltipContext);

    -- insulation
    RenderInfo("Tooltip_item_Insulation", itemContext:getInsulation(), nil, tooltipContext);

    --wind resistance
    RenderInfo("Tooltip_item_Windresist", itemContext:getWindresistance(), nil, tooltipContext);

    -- adjust window
    th = y_position;
    th = th + 20;
    tw = tw + 5;

    return tw, th;
end

function RenderInfo(label, value1, value2, tooltipContext)
    y_position = y_position + 15;
    label = getText(label);
    value1 = GetValue(value1);
    value2 = GetValue(value2);

    local value = "";
    
    if value1 ~= nil and value2 ~= nil then
        label = label .. ":";
        value = tostring(value1) .. " / " .. tostring(value2);
    elseif value1 ~= nil and value2 == nil then
        label = label .. ":";
        value = value1;
    elseif value1 == nil and value2 ~= nil then
        label = label .. ":";
        value = value2;
    end

    tooltipContext:DrawText(tooltipContext:getFont(), label, label_x_position, y_position, 1, 1, 0.8, 1);
    tooltipContext:DrawText(tooltipContext:getFont(), value, value_x_position, y_position, 1, 1, 0.8, 1);
end

function GetValue(value)
    if value == nil then
        return nil;
    elseif value < 1 then
        return tostring(math.floor((value * 100) + 0.5));
    else
        return value;
    end
end
