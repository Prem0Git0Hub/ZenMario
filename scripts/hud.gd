extends CanvasLayer

# HUD - Dual-mode display that adapts based on GameManager.is_boss_level()

# --- Level 1-4 elements ---
var bg_panel: ColorRect
var level_label: Label
var health_label: Label
var ammo_label: Label
var shield_label: Label

# --- Level 5 (Boss) elements ---
var boss_container: Control

var player_hp_label: Label
var player_hp_bg: ColorRect
var player_hp_fill: ColorRect

var dragon_hp_label: Label
var dragon_hp_bg: ColorRect
var dragon_hp_fill: ColorRect

var power_label: Label
var power_bg: ColorRect
var power_fill: ColorRect

var boss_ammo_label: Label
var boss_shield_label: Label

var flash_timer: float = 0.0
var flash_on: bool = false


func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS

	_create_normal_hud()
	_create_boss_hud()

	GameManager.health_changed.connect(_on_health_changed)
	GameManager.health_boss_changed.connect(_on_health_boss_changed)
	GameManager.ammo_changed.connect(_on_ammo_changed)
	GameManager.shield_changed.connect(_on_shield_changed)
	GameManager.power_changed.connect(_on_power_changed)
	GameManager.dragon_health_changed.connect(_on_dragon_health_changed)
	GameManager.level_changed.connect(_on_level_changed)

	setup_hud()


func _create_normal_hud() -> void:
	bg_panel = ColorRect.new()
	bg_panel.color = Color(0.0, 0.0, 0.0, 0.55)
	bg_panel.position = Vector2(8, 8)
	bg_panel.size = Vector2(220, 130)
	add_child(bg_panel)

	level_label = Label.new()
	level_label.position = Vector2(16, 12)
	level_label.add_theme_font_size_override("font_size", 20)
	level_label.add_theme_color_override("font_color", Color.WHITE)
	level_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	level_label.add_theme_constant_override("shadow_offset_x", 2)
	level_label.add_theme_constant_override("shadow_offset_y", 2)
	level_label.text = "LEVEL 1"
	add_child(level_label)

	health_label = Label.new()
	health_label.position = Vector2(16, 40)
	health_label.add_theme_font_size_override("font_size", 20)
	health_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
	health_label.text = "HP: ♥♥♥"
	add_child(health_label)

	ammo_label = Label.new()
	ammo_label.position = Vector2(16, 68)
	ammo_label.add_theme_font_size_override("font_size", 20)
	ammo_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
	ammo_label.text = "AMMO: 10"
	add_child(ammo_label)

	shield_label = Label.new()
	shield_label.position = Vector2(16, 96)
	shield_label.add_theme_font_size_override("font_size", 20)
	shield_label.add_theme_color_override("font_color", Color.GRAY)
	shield_label.text = "SHIELD: ---"
	add_child(shield_label)


func _create_boss_hud() -> void:
	boss_container = Control.new()
	boss_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(boss_container)

	# --- Player HP bar (top-left) ---
	player_hp_label = Label.new()
	player_hp_label.position = Vector2(16, 8)
	player_hp_label.add_theme_font_size_override("font_size", 16)
	player_hp_label.add_theme_color_override("font_color", Color.WHITE)
	player_hp_label.text = "PLAYER HP"
	boss_container.add_child(player_hp_label)

	player_hp_bg = ColorRect.new()
	player_hp_bg.color = Color(0.2, 0.2, 0.2)
	player_hp_bg.position = Vector2(16, 30)
	player_hp_bg.size = Vector2(200, 20)
	boss_container.add_child(player_hp_bg)

	player_hp_fill = ColorRect.new()
	player_hp_fill.color = Color(0.1, 0.8, 0.1)
	player_hp_fill.position = Vector2(16, 30)
	player_hp_fill.size = Vector2(200, 20)
	boss_container.add_child(player_hp_fill)

	# --- Dragon HP bar (top-center) ---
	dragon_hp_label = Label.new()
	dragon_hp_label.position = Vector2(490, 8)
	dragon_hp_label.add_theme_font_size_override("font_size", 18)
	dragon_hp_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
	dragon_hp_label.text = "DRAGON HP"
	boss_container.add_child(dragon_hp_label)

	dragon_hp_bg = ColorRect.new()
	dragon_hp_bg.color = Color(0.25, 0.05, 0.05)
	dragon_hp_bg.position = Vector2(490, 32)
	dragon_hp_bg.size = Vector2(300, 25)
	boss_container.add_child(dragon_hp_bg)

	dragon_hp_fill = ColorRect.new()
	dragon_hp_fill.color = Color(0.8, 0.1, 0.1)
	dragon_hp_fill.position = Vector2(490, 32)
	dragon_hp_fill.size = Vector2(300, 25)
	boss_container.add_child(dragon_hp_fill)

	# --- Power bar (below dragon bar) ---
	power_label = Label.new()
	power_label.position = Vector2(530, 62)
	power_label.add_theme_font_size_override("font_size", 16)
	power_label.add_theme_color_override("font_color", Color(0.7, 0.4, 1.0))
	power_label.text = "POWER"
	boss_container.add_child(power_label)

	power_bg = ColorRect.new()
	power_bg.color = Color(0.15, 0.05, 0.25)
	power_bg.position = Vector2(530, 82)
	power_bg.size = Vector2(200, 15)
	boss_container.add_child(power_bg)

	power_fill = ColorRect.new()
	power_fill.color = Color(0.6, 0.2, 0.9)
	power_fill.position = Vector2(530, 82)
	power_fill.size = Vector2(0, 15)
	boss_container.add_child(power_fill)

	# --- Boss-mode ammo & shield (top-right) ---
	boss_ammo_label = Label.new()
	boss_ammo_label.position = Vector2(1080, 12)
	boss_ammo_label.add_theme_font_size_override("font_size", 20)
	boss_ammo_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
	boss_ammo_label.text = "AMMO: 10"
	boss_container.add_child(boss_ammo_label)

	boss_shield_label = Label.new()
	boss_shield_label.position = Vector2(1080, 40)
	boss_shield_label.add_theme_font_size_override("font_size", 20)
	boss_shield_label.add_theme_color_override("font_color", Color.GRAY)
	boss_shield_label.text = "SHIELD: ---"
	boss_container.add_child(boss_shield_label)


func setup_hud() -> void:
	var is_boss: bool = GameManager.is_boss_level()

	# Show/hide groups
	bg_panel.visible = not is_boss
	level_label.visible = not is_boss
	health_label.visible = not is_boss
	ammo_label.visible = not is_boss
	shield_label.visible = not is_boss
	boss_container.visible = is_boss

	if is_boss:
		_on_health_boss_changed(GameManager.player_health_boss)
		_on_dragon_health_changed(GameManager.dragon_health)
		_on_power_changed(GameManager.power_bar)
		_on_ammo_changed(GameManager.ammo)
		_on_shield_changed(GameManager.has_shield)
	else:
		if level_label:
			level_label.text = "LEVEL " + str(GameManager.current_level)
		_on_health_changed(GameManager.player_health)
		_on_ammo_changed(GameManager.ammo)
		_on_shield_changed(GameManager.has_shield)


func _process(delta: float) -> void:
	if not boss_container.visible:
		return
	if GameManager.power_bar >= GameManager.power_bar_max:
		flash_timer += delta
		if flash_timer >= 0.35:
			flash_timer = 0.0
			flash_on = not flash_on
		if flash_on:
			power_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
			power_fill.color = Color(1.0, 0.85, 0.0)
		else:
			power_label.add_theme_color_override("font_color", Color(0.7, 0.4, 1.0))
			power_fill.color = Color(0.6, 0.2, 0.9)
	else:
		flash_timer = 0.0
		flash_on = false
		power_label.add_theme_color_override("font_color", Color(0.7, 0.4, 1.0))
		power_fill.color = Color(0.6, 0.2, 0.9)


# ---------- Signal handlers ----------

func _on_health_changed(val: int) -> void:
	if not health_label:
		return
	var hearts := ""
	for i in range(val):
		hearts += "♥"
	health_label.text = "HP: " + hearts if val > 0 else "HP: DEAD"


func _on_health_boss_changed(val: float) -> void:
	if not player_hp_fill:
		return
	var ratio: float = clampf(val / GameManager.player_max_health_boss, 0.0, 1.0)
	player_hp_fill.size.x = 200.0 * ratio
	if ratio > 0.5:
		player_hp_fill.color = Color(0.1, 0.8, 0.1)
	elif ratio > 0.25:
		player_hp_fill.color = Color(1.0, 0.7, 0.0)
	else:
		player_hp_fill.color = Color(1.0, 0.15, 0.15)


func _on_ammo_changed(val: int) -> void:
	if ammo_label:
		if val <= 0:
			ammo_label.text = "AMMO: 0 [EMPTY]"
			ammo_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
		else:
			ammo_label.text = "AMMO: " + str(val)
			ammo_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))

	if boss_ammo_label:
		if val <= 0:
			boss_ammo_label.text = "AMMO: 0 [EMPTY]"
			boss_ammo_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
		else:
			boss_ammo_label.text = "AMMO: " + str(val)
			boss_ammo_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))


func _on_shield_changed(active: bool) -> void:
	if shield_label:
		if active:
			shield_label.text = "SHIELD: ACTIVE"
			shield_label.add_theme_color_override("font_color", Color(0.0, 1.0, 1.0))
		else:
			shield_label.text = "SHIELD: ---"
			shield_label.add_theme_color_override("font_color", Color.GRAY)

	if boss_shield_label:
		if active:
			boss_shield_label.text = "SHIELD: ACTIVE"
			boss_shield_label.add_theme_color_override("font_color", Color(0.0, 1.0, 1.0))
		else:
			boss_shield_label.text = "SHIELD: ---"
			boss_shield_label.add_theme_color_override("font_color", Color.GRAY)


func _on_power_changed(val: float) -> void:
	if not power_fill:
		return
	var ratio: float = clampf(val / GameManager.power_bar_max, 0.0, 1.0)
	power_fill.size.x = 200.0 * ratio
	if val >= GameManager.power_bar_max:
		power_label.text = "POWER - PRESS K!"
	else:
		power_label.text = "POWER"


func _on_dragon_health_changed(val: float) -> void:
	if not dragon_hp_fill:
		return
	var ratio: float = clampf(val / GameManager.dragon_max_health, 0.0, 1.0)
	dragon_hp_fill.size.x = 300.0 * ratio


func _on_level_changed(num: int) -> void:
	if level_label:
		level_label.text = "LEVEL " + str(num)
	setup_hud()
