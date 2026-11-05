---@meta

--- Modifie une couleur de la palette.
---@param index integer Index de couleur (0 à 255).
---@param r number Rouge (0 à 255).
---@param g number Vert (0 à 255).
---@param b number Bleu (0 à 255).
function palette(index, r, g, b) end

--- Efface l'écran avec la couleur indiquée.
---@param color? integer Index de couleur (0 à 255).
function cls(color) end

---Definit la couleur
---@param color integer
function color(color) end

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

--- Dessine un rectangle plein.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function rect_fill(x, y, width, height, color) end

--- Dessine un rectangle sans remplissage.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function rect(x, y, width, height, color) end

--- Dessine un cercle plein
---@param cx integer centre X
---@param cy integer centre Y
---@param radius integer rayon
---@param color? integer numéro de la couleur
function circle(cx, cy, radius, color) end

--- Dessine un cercle plein
---@param cx integer centre X
---@param cy integer centre Y
---@param radius integer rayon
---@param color? integer numéro de la couleur
function circle_fill(cx, cy, radius, color) end

--- Dessine une ellipse sans remplissage.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function ellipse(x, y, width, height, color) end

--- Dessine une ellipse pleine.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function ellipse_fill(x, y, width, height, color) end

--- Dessine le contour d'un triangle.
---@param x1 number Coordonnée X du premier sommet.
---@param y1 number Coordonnée Y du premier sommet.
---@param x2 number Coordonnée X du deuxième sommet.
---@param y2 number Coordonnée Y du deuxième sommet.
---@param x3 number Coordonnée X du troisième sommet.
---@param y3 number Coordonnée Y du troisième sommet.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function triangle(x1, y1, x2, y2, x3, y3, colorIndex) end

--- Dessine un triangle plein
---@param x1 number Coordonnée X du premier sommet.
---@param y1 number Coordonnée Y du premier sommet.
---@param x2 number Coordonnée X du deuxième sommet.
---@param y2 number Coordonnée Y du deuxième sommet.
---@param x3 number Coordonnée X du troisième sommet.
---@param y3 number Coordonnée Y du troisième sommet.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function triangle_fill(x1, y1, x2, y2, x3, y3, colorIndex) end

--- Dessine un polygone vide (convexe ou concave).
---@param points table Liste de sommets { x = number, y = number }.
---@param color? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function polygone(points, color) end

--- Dessine un polygone plein (convexe ou concave).
---@param points table Liste de sommets { x = number, y = number }.
---@param color? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function polygone_fill(points, color) end
