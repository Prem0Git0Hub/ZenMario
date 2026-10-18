extends Area2D

# --- Properties ---
var direction: Vector2 = Vector2.RIGHT
var speed: float = 600.0
var damage: float = 1.0
var lifetime: float = 3.0
var timer: float = 0.0


func _ready() -> void:
	add_to_group("projectiles")
	collision_layer = 8    # Layer 4: Projectiles
	collision_mask = 2     # Layer 2: Enemies/Dragon
	monitoring = true

	# --- CollisionShape2D ---
	var col_shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 6.0
	col_shape.shape = circle
	add_child(col_shape)

	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	timer += delta
	if timer >= lifetime:
		queue_free()
		return
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_hit"):
			body.take_hit(int(damage))
		queue_free()
		return
	if body.is_in_group("boss"):
		if body.has_method("take_hit"):
			body.take_hit(damage)
		GameManager.add_power(5.0)
		queue_free()
		return


func _draw() -> void:
	# --- Trail (behind the projectile) ---
	var trail_dir: Vector2 = -direction.normalized()
	for i in range(4):
		var offset: float = (i + 1) * 6.0
		var trail_radius: float = 4.0 - float(i) * 0.8
		var trail_alpha: float = 0.6 - float(i) * 0.15
		draw_circle(trail_dir * offset, trail_radius, Color(1.0, 0.85, 0.2, trail_alpha))

	# --- Main glow ---
	draw_circle(Vector2.ZERO, 6.0, Color(1.0, 0.9, 0.1, 1.0))

	# --- Bright center ---
	draw_circle(Vector2.ZERO, 3.0, Color(1.0, 1.0, 0.8, 1.0))
