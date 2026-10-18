extends CharacterBody2D

## Basic enemy that patrols on platforms.

@export var health: int = 1
@export var speed: float = 60.0
@export var damage: int = 1
var direction: float = -1.0
const GRAVITY: float = 980.0
var is_dead: bool = false

signal defeated


func _ready() -> void:
	add_to_group("enemies")
	collision_layer = 2
	collision_mask = 4

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(28, 28)
	shape.shape = rect
	shape.position = Vector2(0, -14)
	add_child(shape)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = direction * speed
	move_and_slide()

	if is_on_wall():
		direction *= -1

	queue_redraw()


func take_hit(amount: int = 1) -> void:
	health -= amount
	if health <= 0:
		_die()


func _die() -> void:
	is_dead = true
	defeated.emit()
	velocity = Vector2.ZERO

	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 0, 0, 0.5), 0.2)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0.0), 0.2)
	tween.tween_callback(queue_free)


func _draw() -> void:
	var alpha := 1.0
	if is_dead:
		alpha = 0.4

	# Body
	var body_color := Color(0.8, 0.15, 0.15, alpha)
	draw_rect(Rect2(-14, -28, 28, 28), body_color)

	# Eyes - darker red
	var eye_color := Color(0.4, 0.05, 0.05, alpha)
	draw_rect(Rect2(-8, -24, 5, 5), eye_color)
	draw_rect(Rect2(3, -24, 5, 5), eye_color)

	# Angry eyebrows
	var brow_color := Color(0.3, 0.0, 0.0, alpha)
	draw_rect(Rect2(-9, -26, 7, 2), brow_color)
	draw_rect(Rect2(2, -26, 7, 2), brow_color)
