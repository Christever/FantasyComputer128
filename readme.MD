# FantasyComputer128

**FantasyComputer128** est un projet de création d'un ordinateur virtuel rétro, développé en Lua avec le framework [LÖVE2D](https://love2d.org/).

L'objectif est de concevoir une véritable petite machine virtuelle, avec son propre processeur, sa mémoire, son système vidéo et, à terme, son propre langage de programmation inspiré du BASIC des ordinateurs des années 1980.

LÖVE2D sert uniquement de support technique pour exécuter la simulation et afficher l'écran de l'ordinateur.

---

## 🎯 Objectifs du projet

- Simuler un ordinateur 8 bits.
- Concevoir un processeur avec son propre jeu d'instructions.
- Reproduire une architecture mémoire avec ROM, RAM et VRAM.
- Créer un système vidéo indépendant du processeur.
- Développer un système graphique en 256 couleurs.
- Créer ultérieurement un langage BASIC pour programmer la machine.
- Permettre à terme de développer de petits jeux directement sur cet ordinateur virtuel.

---

## ⚙️ Caractéristiques techniques

### Processeur

- **Architecture :** 8 bits personnalisée.
- **Fréquence cible :** 6 MHz.
- **Registres 8 bits :** A, B, C, D, E, H, L et F.
- **Registres 16 bits :** HL, DE, IX, IY, PC et SP.
- **Drapeaux :** Zero, Carry, Sign et Parity.
- Jeu d'instructions personnalisé.
- Gestion des cycles processeur.

Le processeur est inspiré des architectures classiques de l'époque, sans chercher à reproduire exactement un processeur existant.

### Mémoire

| Élément | Capacité |
|---|---:|
| ROM | 32 Ko |
| RAM | 128 Ko |
| VRAM | 64 Ko |
| Espace d'adressage CPU | 64 Ko |

La mémoire est organisée en banques de 16 Ko.

L'espace d'adressage du processeur est réparti ainsi :

| Adresse | Utilisation |
|---|---|
| `0x0000 - 0x3FFF` | ROM |
| `0x4000 - 0x7FFF` | RAM fixe |
| `0x8000 - 0xBFFF` | Fenêtre VRAM |
| `0xC000 - 0xFFFF` | RAM bancarisée |

### Vidéo

| Caractéristique | Valeur |
|---|---|
| Résolution | 320 × 200 pixels |
| Couleurs | 256 |
| Profondeur | 8 bits par pixel |
| Mémoire vidéo | 64 Ko |
| Taille d'un pixel | 1 octet |

Le système vidéo possède son propre moteur graphique, indépendant du processeur.

**Fonctionnalités graphiques disponibles :**

| Fonction | Description |
|---|---|
| `setPixel()` | Dessiner un pixel |
| `setColor()` | Définir la couleur graphique courante |
| `clear()` | Effacer l'écran |
| `drawLine()` | Dessiner une ligne |
| `drawRect()` | Dessiner un rectangle vide |
| `fillRect()` | Dessiner un rectangle plein |
| `drawCircle()` | Dessiner un cercle vide |
| `fillCircle()` | Dessiner un cercle plein |

L'affichage conserve le rapport d'aspect de l'image afin d'éviter toute déformation des pixels.

---

## 🛠️ Technologies utilisées

- [Lua](https://www.lua.org/)
- [LÖVE2D 11.5](https://love2d.org/)
- LuaJIT
- Visual Studio Code
- Git

---

## 📁 Architecture du projet

```text
FantasyComputer128/
│
├── main.lua
├── conf.lua
│
└── system/
    │
    ├── Memory.lua
    ├── MemoryTest.lua
    │
    ├── cpu/
    │   ├── CPU.lua
    │   ├── CPUTest.lua
    │   └── Instructions.lua
    │
    └── video/
        ├── Palette.lua
        ├── Video.lua
        └── VideoTest.lua
```

Chaque sous-système est conçu indépendamment afin de faciliter son développement et son évolution.

---

## 🚀 Installation et lancement

### Prérequis

- Linux, Windows ou macOS.
- LÖVE2D 11.5 ou version compatible.
- Git.

### Récupération du projet

```bash
git clone https://github.com/Christever/FantasyComputer128.git
```

Entrer dans le dossier :

```bash
cd FantasyComputer128
```

Lancer le programme :

```bash
love .
```

> Remplacer l'adresse GitHub par celle du dépôt si nécessaire.

---

## 📊 État du développement

**Projet en cours de développement.**

| Module | État |
|---|---|
| Architecture mémoire | Fonctionnelle |
| Bancs mémoire | Fonctionnels |
| Processeur 8 bits | En développement |
| Jeu d'instructions CPU | En développement |
| Palette graphique | Fonctionnelle |
| Mémoire vidéo | Fonctionnelle |
| Moteur graphique | Fonctionnel |
| Langage BASIC | À venir |
| Système d'entrée utilisateur | À venir |
| Son | À venir |

---

## 🗺️ Feuille de route

Les prochaines étapes envisagées :

1. Compléter le moteur graphique.
2. Ajouter les commandes graphiques de haut niveau.
3. Développer le système d'entrée utilisateur.
4. Finaliser le processeur et son jeu d'instructions.
5. Développer un langage BASIC adapté à la machine.
6. Créer un environnement de programmation intégré.
7. Réaliser les premiers jeux sur FantasyComputer128.

---

## 💡 Philosophie du projet

FantasyComputer128 est avant tout un projet d'apprentissage et d'expérimentation autour de l'architecture des ordinateurs 8 bits.

L'idée est de retrouver l'esprit des machines des années 1980 : une architecture simple, une mémoire organisée, des instructions machine, des commandes graphiques et la possibilité de programmer directement son ordinateur.

**L'objectif final : créer un ordinateur rétro virtuel, avec son propre matériel et son propre environnement de programmation.**