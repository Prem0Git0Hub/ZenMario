# 🍄 Zenmario — 2D Retro Arcade Platformer & Dragon Arena (Godot 4)

**Zenmario** is a complete, playable 2D platformer inspired by classic Super Mario-style arcade games, built in **Godot 4 Standard Edition (GDScript)**. It features an arcade blaster, limited ammunition, collectible ammo and shield coins, four forward-running levels with balanced jump curves, and an epic Level 5 Dragon Boss arena battle.

---

## 🎨 ART & ASSET RECREATION GUIDE (Character & Backgrounds)

> 📢 **NOTICE FOR ARTISTS & DEVELOPERS:**  
> The current game uses clean, geometric, lightweight programmatic placeholders (`_draw()` / `ColorRect`) for instant playability on low-end PCs.  
> **Follow this guide to recreate the character and backgrounds with custom art and sprites.**

### 1. Recreating the Player Character (Zenmario)
Currently, `scripts/player.gd` renders Zenmario using `_draw()` (blue torso, visor, eyes, blaster arm, muzzle flash, cyan shield aura).

To replace the placeholder with custom pixel art / sprites:
1. **Prepare Sprite Frames:**
   - Create or import sprite sheets for:
     - `idle` (standing / aiming)
     - `run` (4–8 frame running animation)
     - `jump` (launch, peak, fall frames)
     - `shoot` (blaster arm recoil / muzzle flash)
     - `stun` (earthquake dazed frame)
   - Standard recommended sprite resolution: **32×32** or **32×48** pixels.
2. **Implement in Godot:**
   - Open `scenes/player.tscn`.
   - Add an `AnimatedSprite2D` node (or `Sprite2D` with an `AnimationPlayer`).
   - Position the sprite with its feet centered at `(0, 0)` so it aligns perfectly with the `CollisionShape2D` (size: 28×56, centered at `(0, -28)`).
   - In `scripts/player.gd`, comment out or remove the body drawing inside `_draw()` while keeping the dynamic effects (such as the cyan shield aura and muzzle flash circle).
   - In `_physics_process()`, call `animated_sprite.play("run")`, `animated_sprite.play("jump")`, etc., based on `is_on_floor()`, `velocity.x`, and `is_stunned`.

### 2. Recreating the Backgrounds
Currently, `scripts/level_base.gd` uses a `CanvasLayer` with a light blue `ColorRect` for Levels 1–4, and `scripts/boss_level.gd` uses a dark purple `ColorRect` for the Level 5 arena.

To create lush, layered parallax backgrounds:
1. **Levels 1–4 (Auto-Running Stages):**
   - In `level_base.gd`, replace `_create_background()` with a `ParallaxBackground` containing multiple `ParallaxLayer` nodes:
     - **Layer 1 (Far - Slow Scroll):** Distant sky and sun/moon (motion scale: `0.05, 0.0`).
     - **Layer 2 (Mid-Far - Clouds/Mountains):** Retro hills and fluffy clouds (motion scale: `0.2, 0.0`, repeatable mirroring at width `1280`).
     - **Layer 3 (Mid - Treeline/Foliage):** Bushes and pipes/fences (motion scale: `0.5, 0.0`).
2. **Level 5 (Dragon Boss Arena):**
   - In `boss_level.gd`, replace the `ArenaBackground` with a custom retro castle / lava cavern illustration:
     - Torch-lit brick dungeon walls
     - Distant glowing lava pits or dragon lair silhouettes
     - Foreground stone arena pillars at left and right boundaries

### 3. Recreating Enemies & Dragon Boss
- **Patrol Enemies (`enemy.gd`):** Replace the red rectangle in `scenes/enemy.tscn` with a walking Goomba/Koopa-style creature sprite.
- **Dragon Boss (`dragon_boss.gd`):** Replace the multi-polygon dragon with a large animated boss sprite (idle, walk, jump, earthquake windup glow, and slam impact frames).

---

## 🕹️ Controls

| Action | Primary Key | Secondary Key |
| :--- | :--- | :--- |
| **Move Left** | `A` | `Left Arrow` *(Active in Level 5 Arena)* |
| **Move Right** | `D` | `Right Arrow` |
| **Jump** | `Space` | `W` / `Up Arrow` |
| **Shoot Blaster** | `Left Mouse Button` | `J` |
| **Special Power Attack** | `K` | *(Level 5 Arena only, when meter is full)* |
| **Pause / Resume** | `Escape` | |

---

## 🚀 Latest Updates & Refinements

### 1. Jump Physics & Movement Overhaul
- **Increased Jump Impulse:** Enhanced to `-520 px/s` with tuned gravity (`900 px/s²`), boosting vertical jump height to **150 px** and maximum horizontal jump reach to **~254 px**.
- **Coyote Time (0.15s):** Jump input is granted for 0.15s after stepping off an edge, eliminating missed jumps when running off ledge boundaries.
- **Jump Buffering (0.15s):** Pressing jump right before touching down executes immediately upon landing.
- **Variable Jump Height:** Tap jump for short hops or hold down for full-height arcs.

### 2. Fair & Clearable Level Platforming
- **Level 2 Gaps Calibrated:** Gaps reduced from 180–200 px down to a safe, comfortable **100–120 px** (giving over 130 px of safety margin under max jump capability).
- **Accessible Platform Heights:** Platforms lowered to stepped heights (`y=560` and `y=490`), preventing unreachable jumps.
- **Safety Bridge Platforms:** Wide 160 px bridge platforms placed over gaps across Levels 2–4, ensuring players always have clear ground-to-ground or stepped-platform routes.

### 3. Smart Shield Coin Appearance
- **Coins Hide While Shielded:** Picking up a shield coin protects the player and immediately hides all upcoming shield coins in the level (`visible = false`, collision disabled).
- **Coins Reappear When Shield is Lost:** The moment an enemy collision consumes the shield, remaining shield coins immediately become visible and collectible again!

---

## 🎮 Game Structure & Levels

| Stage | Name | Style | Objective |
| :---: | :--- | :--- | :--- |
| **Level 1** | Beginner | Auto-Run | Learn running, jumping, shooting, and coin collection |
| **Level 2** | Increasing Challenge | Auto-Run | Navigate stepped platforms, wide gaps, and enemy patrols |
| **Level 3** | Advanced Platforming | Auto-Run | Precision jumps, elevated coin paths, and faster foes |
| **Level 4** | Pre-Boss Challenge | Auto-Run | Test your reflexes and manage ammunition before the arena |
| **Level 5** | Dragon Boss Arena | Free Movement | Battle the walking Dragon, dodge shockwaves, and fire Special Attack |

---

## 🛠️ How to Run Locally

1. Open **Godot Engine 4.x** (Standard edition).
2. Click **Import** $\rightarrow$ select `project.godot` inside this folder.
3. Click **Import & Edit**.
4. Press **F5** to play!

*(Or on Windows, double-click `PLAY_ZENMARIO.bat` in the project root).*

---

## 📄 License & Credits

Developed with Godot Engine 4.x. Pure GDScript with zero external runtime dependencies.
