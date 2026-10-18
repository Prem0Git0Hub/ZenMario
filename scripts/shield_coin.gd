extends Area2D

## Collectible shield coin. Only appears when player has no active shield.

var collected: bool = false
var bob_time: float = 0.0
@export var use_gravity: bool = false
const GRAVITY: float = 400.0
var fall_speed: float = 0.0
var lifetime: float = 10.0
var timer: float = 0.0

var _col_shape: CollisionShape2D


func _ready() -> void:
	add_to_group("shield_coins")
	collision_layer = 16
	collision_mask = 1
	monitoring = true

	_col_shape = CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 12
	_col_shape.shape = circle
	add_child(_col_shape)

	body_entered.connect(_on_body_entered)

	# Connect to GameManager shield signal: coin cannot appear until shield is lost
	GameManager.shield_changed.connect(_on_shield_state_changed)
	_update_visibility_from_shield(GameManager.has_shield)


func _on_shield_state_changed(active: bool) -> void:
	_update_visibility_from_shield(active)


func _update_visibility_from_shield(has_active_shield: bool) -> void:
	if use_gravity:
		return  # Boss arena falling coins are controlled by level spawner

	# In platform levels: coin cannot appear if player already has an active shield!
	if has_active_shield:
		visible = false
		monitoring = false
		if _col_shape:
			_col_shape.set_deferred("disabled", true)
	else:
		if not collected:
			visible = true
			monitoring = true
			if _col_shape:
				_col_shape.set_deferred("disabled", false)


func _physics_process(delta: float) -> void:
	if collected or not visible:
		return

	bob_time += delta

	if use_gravity:
		fall_speed += GRAVITY * delta
		position.y += fall_speed * delta
		timer += delta
		if timer >= lifetime or position.y > 800:
			queue_free()

	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body.is_in_group("player"):
		if GameManager.has_shield:
			return
		collected = true
		GameManager.activate_shield()
		queue_free()


func _draw() -> void:
	if not visible:
		return

	var bob_offset := sin(bob_time * 3.0) * 2.0
	var center := Vector2(0, bob_offset)

	# Cyan filled outer circle
	draw_circle(center, 12, Color(0.0, 0.9, 0.9))

	# Darker cyan outline
	draw_arc(center, 12, 0, TAU, 32, Color(0.0, 0.6, 0.6), 2.0)

	# Bright inner core
	draw_circle(center, 7, Color(0.6, 1.0, 1.0))

	# Shield diamond icon in center
	var diamond := PackedVector2Array([
		Vector2(center.x, center.y - 5),
		Vector2(center.x + 4, center.y),
		Vector2(center.x, center.y + 5),
		Vector2(center.x - 4, center.y)
	])
	draw_colored_polygon(diamond, Color(0.0, 0.4, 0.5))
