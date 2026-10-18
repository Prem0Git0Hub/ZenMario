extends Node2D

## Level 5 - Dragon Boss Arena

var player_instance: CharacterBody2D
var dragon_instance: CharacterBody2D

var ammo_spawn_timer: float = 0.0
var ammo_spawn_interval: float = 5.0
var shield_spawn_timer: float = 0.0
var shield_spawn_interval: float = 10.0
var max_falling_coins: int = 4
var arena_left: float = 50.0
var arena_right: float = 1230.0
var floor_y: float = 650.0

var _ammo_coin_scene: PackedScene = preload("res://scenes/ammo_coin.tscn")
var _shield_coin_scene: PackedScene = preload("res://scenes/shield_coin.tscn")


func _ready() -> void:
	GameManager.init_level(5)
	_create_arena()
	_spawn_player()
	_spawn_dragon()
	_add_hud()
	_add_pause_menu()
	_setup_camera()


func _create_arena() -> void:
	# Dark dramatic arena background
	var bg := ColorRect.new()
	bg.name = "ArenaBackground"
	bg.color = Color(0.12, 0.05, 0.18)
	bg.size = Vector2(1280, 720)
	bg.z_index = -10
	add_child(bg)

	# Mountain/cavern silhouettes in background
	var cavern_wall := ColorRect.new()
	cavern_wall.color = Color(0.18, 0.08, 0.24)
	cavern_wall.position = Vector2(0, 400)
	cavern_wall.size = Vector2(1280, 320)
	cavern_wall.z_index = -9
	add_child(cavern_wall)

	# Arena Floor
	var floor_body := _create_platform(Vector2(640, floor_y), Vector2(1200, 40), Color(0.3, 0.15, 0.2))
	floor_body.name = "ArenaFloor"
	add_child(floor_body)

	# Left Wall
	var left_wall := _create_platform(Vector2(40, 360), Vector2(30, 720), Color(0.2, 0.1, 0.15))
	left_wall.name = "LeftWall"
	add_child(left_wall)

	# Right Wall
	var right_wall := _create_platform(Vector2(1240, 360), Vector2(30, 720), Color(0.2, 0.1, 0.15))
	right_wall.name = "RightWall"
	add_child(right_wall)

	# Two elevated platforms for tactical dodging and jumping
	var plat_left := _create_platform(Vector2(320, 500), Vector2(180, 20), Color(0.4, 0.2, 0.25))
	add_child(plat_left)

	var plat_right := _create_platform(Vector2(960, 500), Vector2(180, 20), Color(0.4, 0.2, 0.25))
	add_child(plat_right)


func _create_platform(pos: Vector2, size: Vector2, color: Color) -> StaticBody2D:
	var platform := StaticBody2D.new()
	platform.position = pos
	platform.collision_layer = 4   # Platforms
	platform.collision_mask = 0

	var col := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	col.shape = shape
	platform.add_child(col)

	var rect := ColorRect.new()
	rect.color = color
	rect.size = size
	rect.position = -size / 2.0
	platform.add_child(rect)

	return platform


func _spawn_player() -> void:
	var p_scene := preload("res://scenes/player.tscn")
	player_instance = p_scene.instantiate()
	player_instance.position = Vector2(200, floor_y - 20)
	add_child(player_instance)


func _spawn_dragon() -> void:
	var d_scene := preload("res://scenes/dragon_boss.tscn")
	dragon_instance = d_scene.instantiate()
	dragon_instance.position = Vector2(900, floor_y - 20)
	add_child(dragon_instance)


func _add_hud() -> void:
	var hud := preload("res://scenes/hud.tscn").instantiate()
	add_child(hud)


func _add_pause_menu() -> void:
	var pm := preload("res://scenes/pause_menu.tscn").instantiate()
	add_child(pm)


func _setup_camera() -> void:
	var camera := Camera2D.new()
	camera.name = "ArenaCamera"
	camera.position = Vector2(640, 360)
	add_child(camera)
	camera.make_current()


func _physics_process(delta: float) -> void:
	# --- Falling ammo coin spawner ---
	ammo_spawn_timer += delta
	if ammo_spawn_timer >= ammo_spawn_interval:
		ammo_spawn_timer = 0.0
		var current_ammo_coins := get_tree().get_nodes_in_group("ammo_coins")
		if current_ammo_coins.size() < max_falling_coins:
			_spawn_falling_ammo()

	# --- Falling shield coin spawner ---
	shield_spawn_timer += delta
	if shield_spawn_timer >= shield_spawn_interval:
		shield_spawn_timer = 0.0
		# Only spawn if player does NOT already have an active shield and none exist
		if not GameManager.has_shield:
			var current_shields := get_tree().get_nodes_in_group("shield_coins")
			if current_shields.is_empty():
				_spawn_falling_shield()


func _spawn_falling_ammo() -> void:
	var coin := _ammo_coin_scene.instantiate()
	coin.position = Vector2(randf_range(160, 1120), -20)
	coin.use_gravity = true
	add_child(coin)


func _spawn_falling_shield() -> void:
	var coin := _shield_coin_scene.instantiate()
	coin.position = Vector2(randf_range(160, 1120), -20)
	coin.use_gravity = true
	add_child(coin)
