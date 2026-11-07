---@meta

------------------ ECRAN ------------------

--- Retourne la largeur de l'écran.
---@return integer
function f_screen_width() end

--- Retourne la hauteur de l'écran.
---@return integer
function f_screen_height() end

--- Modifie une couleur de la palette.
---@param index integer Index de couleur (0 à 255).
---@param r number Rouge (0 à 255).
---@param g number Vert (0 à 255).
---@param b number Bleu (0 à 255).
function f_palette(index, r, g, b) end

--- Efface l'écran avec la couleur indiquée.
---@param color? integer Index de couleur (0 à 255).
function f_cls(color) end

---Definit la couleur
---@param color integer
function f_color(color) end

-----------------------  FORMES BASE --------------------------------

--- Dessine un pixel.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param color? integer Index de couleur (0 à 255).
function f_pixel(x, y, color) end

--- Trace une ligne.
---@param x1 number Position horizontale de départ.
---@param y1 number Position verticale de départ.
---@param x2 number Position horizontale d'arrivée.
---@param y2 number Position verticale d'arrivée.
---@param color? integer Index de couleur (0 à 255).
function f_line(x1, y1, x2, y2, color) end

--- Affiche un texte.
---@param text string Texte à afficher.
---@param x? number Position horizontale.
---@param y? number Position verticale.
---@param color? integer Index de couleur (0 à 255).
function f_print(text, x, y, color) end

--- Dessine un rectangle plein.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function f_rect_fill(x, y, width, height, color) end

--- Dessine un rectangle sans remplissage.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function f_rect(x, y, width, height, color) end

--- Dessine un cercle plein
---@param cx integer centre X
---@param cy integer centre Y
---@param radius integer rayon
---@param color? integer numéro de la couleur
function f_circle(cx, cy, radius, color) end

--- Dessine un cercle plein
---@param cx integer centre X
---@param cy integer centre Y
---@param radius integer rayon
---@param color? integer numéro de la couleur
function f_circle_fill(cx, cy, radius, color) end

--- Dessine une ellipse sans remplissage.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function f_ellipse(x, y, width, height, color) end

--- Dessine une ellipse pleine.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param width number Largeur.
---@param height number Hauteur.
---@param color? integer Index de couleur (0 à 255).
function f_ellipse_fill(x, y, width, height, color) end

--- Dessine le contour d'un triangle.
---@param x1 number Coordonnée X du premier sommet.
---@param y1 number Coordonnée Y du premier sommet.
---@param x2 number Coordonnée X du deuxième sommet.
---@param y2 number Coordonnée Y du deuxième sommet.
---@param x3 number Coordonnée X du troisième sommet.
---@param y3 number Coordonnée Y du troisième sommet.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function f_triangle(x1, y1, x2, y2, x3, y3, colorIndex) end

--- Dessine un triangle plein
---@param x1 number Coordonnée X du premier sommet.
---@param y1 number Coordonnée Y du premier sommet.
---@param x2 number Coordonnée X du deuxième sommet.
---@param y2 number Coordonnée Y du deuxième sommet.
---@param x3 number Coordonnée X du troisième sommet.
---@param y3 number Coordonnée Y du troisième sommet.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function f_triangle_fill(x1, y1, x2, y2, x3, y3, colorIndex) end

--- Dessine un polygone vide (convexe ou concave).
---@param points table Liste de sommets { x = number, y = number }.
---@param color? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function f_polygone(points, color) end

--- Dessine un polygone plein (convexe ou concave).
---@param points table Liste de sommets { x = number, y = number }.
---@param color? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function f_polygone_fill(points, color) end

---------------------- SPRITES --------------------------------

---@param width number Largeur du sprite.
---@param height number Hauteur du sprite.
---@param colorIndex number|nil Couleur initiale.
---@return Sprite
function f_sprite(width, height, colorIndex) end

--- Affiche un sprite ou un sprite provenant d'une spritesheet.
---@param sprite Sprite|SpriteSheet|Animation
---@param x number Position horizontale.
---@param y number Position verticale.
---@param flipX boolean|nil Retourne horizontalement.
---@param flipY boolean|nil Retourne verticalement.
---@param index integer|nil Index du sprite dans la spritesheet.
function f_spr(sprite, x, y, flipX, flipY, index) end

---@param path string Chemin de l'image.
---@param spriteWidth number Largeur d'un sprite.
---@param spriteHeight number Hauteur d'un sprite.
---@return SpriteSheet
function f_spritesheet(path, spriteWidth, spriteHeight) end

--- Récupère un sprite depuis une spritesheet.
---@param sheet SpriteSheet
---@param index integer
---@return Sprite|nil
function f_get_sprite(sheet, index) end

----------------- ANIMATION ------------------------------------

--- Crée une animation à partir d'une spritesheet.
---@param spriteSheet SpriteSheet Feuille de sprites.
---@param firstFrame integer Première image.
---@param lastFrame integer Dernière image.
---@param fps number Images par seconde.
---@return Animation
function f_animation(spriteSheet, firstFrame, lastFrame, fps) end

--- Met une animation en pause.
---@param anim Animation
function f_stop_anim(anim) end

--- Démarre ou reprend une animation.
---@param anim Animation
function f_play_anim(anim) end

--- Réinitialise une animation.
---@param anim Animation
function f_reset_anim(anim) end

---Modifie la vitesse d'une animation
---@param anim Animation
---@param fps integer >0
function f_set_anim_speed(anim, fps) end

---@overload fun(spriteSheet: SpriteSheet, firstFrame: integer, lastFrame: integer, fps: number, mode?: "loop"|"once"): Animation
---@overload fun(spriteSheet: SpriteSheet, frames: integer[], fps: number, mode?: "loop"|"once"): Animation
---@param spriteSheet SpriteSheet
---@param frames integer|integer[]
---@param lastFrameOrFps number
---@param fpsOrMode number|"loop"|"once"|nil
---@param mode nil|"loop"|"once"
---@return Animation
function f_animation(spriteSheet, frames, lastFrameOrFps, fpsOrMode, mode) end

---------------------- INPUTS ---------------------------------


--- Vérifie si une commande est maintenue.
---@param button Button
---@return boolean
function f_btn(button) end

--- Vérifie si une commande vient d'être pressée.
---@param button Button
---@return boolean
function f_btnp(button) end

--- Vérifie si une commande vient d'être relâchée.
---@param button Button
---@return boolean
function f_btnr(button) end

--- Retourne la valeur d'un axe analogique.
---@param joystickIndex integer
---@param axis string
---@return number
function f_axis(joystickIndex, axis) end

--- Retourne une direction numérique à partir d'un axe analogique.
---@param joystickIndex integer
---@param axis string
---@return integer
function f_direction(joystickIndex, axis) end

--- Retourne le nombre de manettes connectées.
---@return integer
function f_joystickCount() end

--- Vérifie si une manette est connectée.
---@param joystickIndex integer
---@return boolean
function f_joystickConnected(joystickIndex) end

----------------------  MEMOIRE  ------------------------------
--- Lit un octet à une adresse mémoire.
---@param address integer Adresse CPU (0 à 65535)
---@return integer
function f_peek(address) end

--- Écrit un octet à une adresse mémoire.
---@param address integer Adresse CPU (0 à 65535)
---@param value integer Valeur (0 à 255)
function f_poke(address, value) end

------------------------CARTOUCHE ----------------------

---  Chargement d'une cartouche
---@param path string  Chemin de la cartouche
function f_load_cartridge(path) end

--- Retourne la liste des cartouches disponibles.*
---@return table
function f_get_cartridges() end
