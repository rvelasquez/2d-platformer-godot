# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a 2D platformer starter kit built with Godot 4.4. The project includes a complete platformer game system with player movement, collectibles, audio management, scene transitions, and two demo levels.

## Commands

- **Run the game**: Open in Godot Editor and press F5, or run `godot` from the command line
- **Build/Export**: Use the Godot Editor's export presets, or run `./build.sh` (requires environment variables for asset upload)
- **Import assets**: `godot --headless -e --quit-after 100`

## Architecture

### Core Systems

**Autoloaded Singletons** (defined in project.godot):
- `GameManager` - Handles score tracking and level transitions
- `SceneTransition` - Manages scene transitions with fade/scale animations
- `AudioManager` - Centralized audio playback for all sound effects
- `VirtualControllerScene` - Mobile controller support

**Main Components**:
- `player.gd` - Character controller with physics, animations, double jump, and respawn system
- `Coin.gd` - Collectible items with hover animation and pickup logic
- `LevelFinishDoor.gd` - Level completion trigger that loads next scene

### Scene Structure

- **Levels**: `Scenes/Levels/` - Contains Level_01.tscn and Level_02.tscn
- **Prefabs**: `Scenes/Prefabs/` - Reusable components (player, coins, doors)
- **Managers**: `Scenes/Managers/` - Autoloaded manager scenes

### Input System

Custom input actions defined in project.godot:
- `Left` - A key / left joystick
- `Right` - D key / right joystick  
- `Jump` - Space key / controller button A

### Audio System

All audio is managed through the `AudioManager` singleton with pre-loaded sound effects:
- Jump, coin pickup, death, respawn, and level complete sounds
- Access via `AudioManager.jump_sfx.play()` pattern

### Player Features

The player controller supports:
- Variable jump height and optional double jump (toggleable)
- Particle effects for movement trails and death
- Smooth scale tweening for jump feedback and death/respawn animations
- Collision detection with "Traps" group for death triggers

### Scene Transitions

The `SceneTransition` system provides:
- Fade or scale transition types (configurable per scene)
- Async loading with `SceneTransition.load_scene(target_scene)`
- Automatic reverse animation on scene load

### Mobile Support

Includes virtual joystick addon in `addons/virtual_joystick/` for mobile device support.

## Development Notes

- Scripts use export variables extensively for designer-friendly tweaking
- All major systems use groups for collision detection ("Player", "Traps")
- Death system uses spawn points marked with "%SpawnPoint" unique names
- Code includes comprehensive comments explaining functionality