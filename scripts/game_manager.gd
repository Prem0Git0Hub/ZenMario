extends Node

# --- State Properties ---
var current_level: int = 1
var player_health: int = 3
var player_health_boss: float = 100.0
var player_max_health_boss: float = 100.0
var ammo: int = 10
var start_ammo: int = 10
var max_ammo: int = 30
var has_shield: bool = false
var power_bar: float = 0.0
var power_bar_max: float = 100.0
var dragon_health: float = 200.0
var dragon_max_health: float = 200.0
var is_paused: bool = false

# --- Signals ---
signal health_changed(new_health: int)
signal health_boss_changed(new_health: float)
signal ammo_changed(new_ammo: int)
signal shield_changed(active: bool)
signal power_changed(new_power: float)
signal dragon_health_changed(new_health: float)
signal level_changed(level_num: int)

# --- Level path lookup ---
var _level_paths: Dictionary = {
	1: "res://scenes/level_1.tscn",
	2: "res://scenes/level_2.tscn",
	3: "res://scenes/level_3.tscn",
	4: "res://scenes/level_4.tscn",
	5: "res://scenes/boss_level.tscn",
}


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

	# --- Set up input actions programmatically ---
	_add_key_action("move_left", [65, 4194319])       # A, Left
	_add_key_action("move_right", [68, 4194321])       # D, Right
	_add_key_action("jump", [32, 87, 4194320])         # Space, W, Up
	_add_key_action("shoot", [74], [MOUSE_BUTTON_LEFT]) # J, LMB
	_add_key_action("special_attack", [75])            # K
	_add_key_action("pause", [4194305])                # Escape


func _add_key_action(action_name: String, keycodes: Array = [], mouse_buttons: Array = []) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	for keycode in keycodes:
		var ev := InputEventKey.new()
		ev.physical_keycode = keycode
		InputMap.action_add_event(action_name, ev)

	for btn in mouse_buttons:
		var ev := InputEventMouseButton.new()
		ev.button_index = btn
		InputMap.action_add_event(action_name, ev)




# --- Queries ---
func is_boss_level() -> bool:
	return current_level == 5


# --- Level Initialisation ---
func init_level(level_num: int) -> void:
	current_level = level_num
	player_health = 3
	player_health_boss = player_max_health_boss
	ammo = start_ammo
	has_shield = false
	power_bar = 0.0
	dragon_health = dragon_max_health
	is_paused = false

	health_changed.emit(player_health)
	health_boss_changed.emit(player_health_boss)
	ammo_changed.emit(ammo)
	shield_changed.emit(has_shield)
	power_changed.emit(power_bar)
	dragon_health_changed.emit(dragon_health)
	level_changed.emit(current_level)


# --- Damage (levels 1-4) ---
func take_damage(amount: int = 1) -> void:
	if has_shield:
		consume_shield()
		return
	player_health = clampi(player_health - amount, 0, 3)
	health_changed.emit(player_health)
	if player_health <= 0:
		game_over()


# --- Damage (level 5 / boss) ---
func take_damage_boss(amount: float = 10.0) -> void:
	if has_shield:
		consume_shield()
		return
	player_health_boss = clampf(player_health_boss - amount, 0.0, player_max_health_boss)
	health_boss_changed.emit(player_health_boss)
	if player_health_boss <= 0.0:
		game_over()


# --- Ammo ---
func collect_ammo(amount: int = 5) -> void:
	ammo = mini(ammo + amount, max_ammo)
	ammo_changed.emit(ammo)


func use_ammo() -> bool:
	if ammo > 0:
		ammo -= 1
		ammo_changed.emit(ammo)
		return true
	return false


# --- Shield ---
func activate_shield() -> void:
	has_shield = true
	shield_changed.emit(true)


func consume_shield() -> bool:
	if has_shield:
		has_shield = false
		shield_changed.emit(false)
		return true
	return false


# --- Power bar (level 5) ---
func add_power(amount: float) -> void:
	power_bar = minf(power_bar + amount, power_bar_max)
	power_changed.emit(power_bar)


func use_special_attack() -> bool:
	if power_bar >= power_bar_max:
		power_bar = 0.0
		power_changed.emit(power_bar)
		return true
	return false


# --- Dragon ---
func damage_dragon(amount: float) -> void:
	dragon_health = maxf(dragon_health - amount, 0.0)
	dragon_health_changed.emit(dragon_health)
	if dragon_health <= 0.0:
		victory()


# --- Scene management ---
func load_level(level_num: int) -> void:
	init_level(level_num)
	var path: String = _level_paths.get(level_num, _level_paths[1])
	get_tree().call_deferred("change_scene_to_file", path)


func next_level() -> void:
	if current_level < 5:
		load_level(current_level + 1)
	else:
		victory()


func game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func victory() -> void:
	get_tree().change_scene_to_file("res://scenes/victory.tscn")


func restart_game() -> void:
	is_paused = false
	get_tree().paused = false
	load_level(1)


func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
