extends Area2D

## Collectible ammunition coin.

@export var ammo_amount: int = 5
@export var use_gravity: bool = false
const GRAVITY: float = 400.0
var fall_speed: float = 0.0
var lifetime: float = 10.0
var timer: float = 0.0
var collected: bool = false
var bob_time: float = 0.0


func _ready() -> void:
	add_to_group("ammo_coins")
	collision_layer = 16
	collision_mask = 1
	monitoring = true

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 12
	shape.shape = circle
	add_child(shape)

	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if collected:
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
		collected = true
		GameManager.collect_ammo(ammo_amount)
		queue_free()


func _draw() -> void:
	var bob_offset := sin(bob_time * 3.0) * 2.0
	var center := Vector2(0, bob_offset)

	# Gold filled outer circle
	draw_circle(center, 12, Color(1.0, 0.84, 0.0))

	# Darker gold outline
	draw_arc(center, 12, 0, TAU, 32, Color(0.8, 0.6, 0.0), 2.0)

	# Bright inner core
	draw_circle(center, 7, Color(1.0, 0.95, 0.4))

	# Small dark bullet icon in center
	draw_rect(Rect2(center.x - 2, center.y - 4, 4, 8), Color(0.4, 0.3, 0.0))
