---@meta

--- Efface l'écran avec la couleur indiquée.
---@param color? integer Index de couleur (0 à 255).
function cls(color) end

--- Dessine un pixel.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param color? integer Index de couleur (0 à 255).
function pix(x, y, color) end

--- Trace une ligne.
---@param x1 number Position horizontale de départ.
---@param y1 number Position verticale de départ.
---@param x2 number Position horizontale d'arrivée.
---@param y2 number Position verticale d'arrivée.
---@param color? integer Index de couleur (0 à 255).
function line(x1, y1, x2, y2, color) end

--- Affiche un texte.
---@param text string Texte à afficher.
---@param x? number Position horizontale.
---@param y? number Position verticale.
---@param color? integer Index de couleur (0 à 255).
function print(text, x, y, color) end
