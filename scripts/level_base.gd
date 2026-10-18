extends Node2D
class_name LevelBase

var level_number: int = 1
var ground_y: float = 650.0
var player_instance: CharacterBody2D
var level_container: Node2D


func _ready() -> void:
	GameManager.init_level(level_number)
	_create_background()
	level_container = Node2D.new()
	level_container.name = "LevelContainer"
	add_child(level_container)
	_build_level()
	_spawn_player()
	_add_hud()
	_add_pause_menu()
	_add_kill_zone()


func _create_background() -> void:
	var canvas_bg := CanvasLayer.new()
	canvas_bg.name = "BackgroundLayer"
	canvas_bg.layer = -10
	var sky := ColorRect.new()
	sky.name = "Sky"
	sky.color = Color(0.53, 0.81, 0.98)  # Light blue sky
	sky.size = Vector2(1280, 720)
	canvas_bg.add_child(sky)
	add_child(canvas_bg)


func _build_level() -> void:
	# Virtual – override in subclass
	pass


func _spawn_player() -> void:
	var scene = preload("res://scenes/player.tscn")
	player_instance = scene.instantiate()
	player_instance.position = Vector2(100, ground_y)
	add_child(player_instance)


func _add_hud() -> void:
	var hud = preload("res://scenes/hud.tscn").instantiate()
	add_child(hud)


func _add_pause_menu() -> void:
	var pm = preload("res://scenes/pause_menu.tscn").instantiate()
	add_child(pm)


func _add_kill_zone() -> void:
	var kill_zone = Area2D.new()
	kill_zone.name = "KillZone"
	kill_zone.position = Vector2(10000, 800)
	kill_zone.collision_layer = 0
	kill_zone.collision_mask = 1
	kill_zone.monitoring = true

	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20000, 40)
	col.shape = shape
	kill_zone.add_child(col)

	kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	add_child(kill_zone)


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.take_damage(3)


# ---------------------------------------------------------------------------
# Helper: create a platform (StaticBody2D)
# ---------------------------------------------------------------------------
func create_platform(pos: Vector2, size: Vector2, color: Color = Color(0.4, 0.25, 0.1)) -> StaticBody2D:
	var platform = StaticBody2D.new()
	platform.position = pos
	platform.collision_layer = 4
	platform.collision_mask = 0

	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size
	col.shape = shape
	platform.add_child(col)

	var rect = ColorRect.new()
	rect.color = color
	rect.size = size
	rect.position = -size / 2
	platform.add_child(rect)

	return platform


# ---------------------------------------------------------------------------
# Helper: create a ground segment (centered at x_start + width/2, ground_y)
# ---------------------------------------------------------------------------
func create_ground_segment(x_start: float, width: float) -> void:
	var platform = create_platform(
		Vector2(x_start + width / 2.0, ground_y),
		Vector2(width, 40),
		Color(0.35, 0.22, 0.08)
	)
	platform.name = "Ground_%d" % int(x_start)
	level_container.add_child(platform)


# ---------------------------------------------------------------------------
# Helper: add an enemy
# ---------------------------------------------------------------------------
func add_enemy(pos: Vector2, speed: float = 60.0) -> void:
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	enemy.position = pos
	enemy.speed = speed
	level_container.add_child(enemy)


# ---------------------------------------------------------------------------
# Helper: add an ammo coin
# ---------------------------------------------------------------------------
func add_ammo_coin(pos: Vector2, amount: int = 5) -> void:
	var coin = preload("res://scenes/ammo_coin.tscn").instantiate()
	coin.position = pos
	coin.ammo_amount = amount
	level_container.add_child(coin)


# ---------------------------------------------------------------------------
# Helper: add a shield coin
# ---------------------------------------------------------------------------
func add_shield_coin(pos: Vector2) -> void:
	var coin = preload("res://scenes/shield_coin.tscn").instantiate()
	coin.position = pos
	level_container.add_child(coin)


# ---------------------------------------------------------------------------
# Helper: add a finish line
# ---------------------------------------------------------------------------
func add_finish_line(x_pos: float) -> void:
	var finish = Area2D.new()
	finish.name = "FinishLine"
	finish.position = Vector2(x_pos, ground_y - 200)
	finish.collision_layer = 0
	finish.collision_mask = 1
	finish.monitoring = true

	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(30, 400)
	col.shape = shape
	finish.add_child(col)

	# Visual indicator – tall green rectangle
	var rect = ColorRect.new()
	rect.color = Color(0.1, 0.85, 0.2, 0.85)
	rect.size = Vector2(30, 400)
	rect.position = Vector2(-15, -200)
	finish.add_child(rect)

	# Checkered stripe overlay
	var stripe = ColorRect.new()
	stripe.color = Color(1, 1, 1, 0.4)
	stripe.size = Vector2(30, 40)
	stripe.position = Vector2(-15, -200)
	finish.add_child(stripe)

	var stripe2 = ColorRect.new()
	stripe2.color = Color(1, 1, 1, 0.4)
	stripe2.size = Vector2(30, 40)
	stripe2.position = Vector2(-15, -120)
	finish.add_child(stripe2)

	var stripe3 = ColorRect.new()
	stripe3.color = Color(1, 1, 1, 0.4)
	stripe3.size = Vector2(30, 40)
	stripe3.position = Vector2(-15, -40)
	finish.add_child(stripe3)

	finish.body_entered.connect(_on_finish_line_body_entered)
	level_container.add_child(finish)


func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.next_level()
