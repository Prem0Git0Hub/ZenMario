extends CharacterBody2D

## Large dragon boss for Level 5. Walks around the arena, jumps, and performs earthquake attacks.

enum State { IDLE, WALKING, JUMPING, EARTHQUAKE_WINDUP, EARTHQUAKE_LANDING, RECOVERY }

@export var max_health: float = 200.0
var health: float = 200.0
var speed: float = 120.0
var direction: float = -1.0
const GRAVITY: float = 980.0
const JUMP_VELOCITY: float = -500.0

var current_state: State = State.WALKING
var state_timer: float = 0.0

var attack_cooldown: float = 5.0
var attack_timer: float = 3.0
var jump_cooldown: float = 3.0
var jump_timer: float = 2.0
var windup_duration: float = 1.0
var recovery_duration: float = 1.5

var flash_timer: float = 0.0
var is_hit: bool = false
var was_airborne: bool = false

signal defeated
signal earthquake_impact(pos: Vector2)


func _ready() -> void:
	add_to_group("boss")
	collision_layer = 2
	collision_mask = 4

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(120, 80)
	shape.shape = rect
	shape.position = Vector2(0, -40)
	add_child(shape)

	health = GameManager.dragon_max_health
	max_health = GameManager.dragon_max_health


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		was_airborne = true

	# Handle flash timer
	if flash_timer > 0:
		flash_timer -= delta
		if flash_timer <= 0:
			is_hit = false

	# State machine
	match current_state:
		State.WALKING:
			_state_walking(delta)
		State.JUMPING:
			_state_jumping(delta)
		State.EARTHQUAKE_WINDUP:
			_state_earthquake_windup(delta)
		State.EARTHQUAKE_LANDING:
			_state_earthquake_landing(delta)
		State.RECOVERY:
			_state_recovery(delta)
		State.IDLE:
			velocity.x = 0

	move_and_slide()
	queue_redraw()


func _state_walking(delta: float) -> void:
	velocity.x = direction * speed

	# Reverse at arena edges
	if position.x < 100:
		direction = 1.0
	elif position.x > 1180:
		direction = -1.0

	# Attack timer
	attack_timer += delta
	if attack_timer >= attack_cooldown:
		_enter_state(State.EARTHQUAKE_WINDUP)
		return

	# Jump timer
	jump_timer += delta
	if jump_timer >= jump_cooldown and randf() < 0.3:
		_enter_state(State.JUMPING)


func _state_jumping(_delta: float) -> void:
	velocity.x = direction * speed * 0.5
	if is_on_floor() and was_airborne:
		was_airborne = false
		_enter_state(State.WALKING)


func _state_earthquake_windup(delta: float) -> void:
	velocity.x = 0
	state_timer -= delta
	if state_timer <= 0:
		velocity.y = JUMP_VELOCITY * 1.5
		was_airborne = true
		_enter_state(State.EARTHQUAKE_LANDING)


func _state_earthquake_landing(_delta: float) -> void:
	velocity.x = 0
	if is_on_floor() and was_airborne:
		was_airborne = false
		earthquake_impact.emit(global_position)

		# Shockwave damage
		var player := get_tree().get_first_node_in_group("player")
		if player and global_position.distance_to(player.global_position) < 500:
			if player.has_method("apply_stun"):
				player.apply_stun(1.0)
			GameManager.take_damage_boss(15.0)

		attack_timer = 0.0
		_enter_state(State.RECOVERY)


func _state_recovery(delta: float) -> void:
	velocity.x = 0
	state_timer -= delta
	if state_timer <= 0:
		_enter_state(State.WALKING)


func _enter_state(new_state: State) -> void:
	current_state = new_state
	match new_state:
		State.WALKING:
			jump_timer = 0.0
		State.JUMPING:
			velocity.y = JUMP_VELOCITY
			was_airborne = true
			jump_timer = 0.0
		State.EARTHQUAKE_WINDUP:
			state_timer = windup_duration
		State.EARTHQUAKE_LANDING:
			pass
		State.RECOVERY:
			state_timer = recovery_duration


func take_hit(damage: float) -> void:
	GameManager.damage_dragon(damage)
	health = GameManager.dragon_health
	flash_timer = 0.15
	is_hit = true
	if health <= 0:
		_die()


func take_special_hit(damage: float) -> void:
	take_hit(damage)


func _die() -> void:
	current_state = State.IDLE
	velocity = Vector2.ZERO
	defeated.emit()

	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.5)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 1.0)
	tween.tween_callback(queue_free)


func _draw() -> void:
	# Determine tint
	var tint := Color.WHITE
	if is_hit and flash_timer > 0:
		tint = Color(10, 10, 10, 1)  # Bright white flash

	# Body - dark red/maroon rectangle from (-60, -80) to (60, 0)
	var body_color := Color(0.45, 0.05, 0.05) * tint
	draw_rect(Rect2(-60, -80, 120, 80), body_color)

	# Head section - darker red, upper portion
	var head_color := Color(0.35, 0.03, 0.03) * tint
	draw_rect(Rect2(-60, -80, 40, 30), head_color)

	# Eye - yellow/orange
	var eye_color := Color(1.0, 0.8, 0.0) * tint
	draw_rect(Rect2(-50, -72, 8, 6), eye_color)

	# Pupil
	draw_rect(Rect2(-48, -70, 3, 3), Color.BLACK)

	# Triangular spikes on back (top of body)
	var spike_color := Color(0.55, 0.1, 0.05) * tint
	var spike_positions := [-30.0, -10.0, 10.0, 30.0]
	for sx in spike_positions:
		var spike_points := PackedVector2Array([
			Vector2(sx - 8, -80),
			Vector2(sx, -95),
			Vector2(sx + 8, -80)
		])
		draw_polygon(spike_points, PackedColorArray([spike_color, spike_color, spike_color]))

	# Wings - triangles on sides
	var wing_color := Color(0.5, 0.08, 0.08, 0.8) * tint
	# Left wing
	var left_wing := PackedVector2Array([
		Vector2(-60, -65),
		Vector2(-85, -90),
		Vector2(-60, -45)
	])
	draw_polygon(left_wing, PackedColorArray([wing_color, wing_color, wing_color]))
	# Right wing
	var right_wing := PackedVector2Array([
		Vector2(60, -65),
		Vector2(85, -90),
		Vector2(60, -45)
	])
	draw_polygon(right_wing, PackedColorArray([wing_color, wing_color, wing_color]))

	# Tail
	var tail_color := Color(0.4, 0.04, 0.04) * tint
	var tail_points := PackedVector2Array([
		Vector2(60, -20),
		Vector2(90, -30),
		Vector2(95, -15),
		Vector2(60, -5)
	])
	draw_polygon(tail_points, PackedColorArray([tail_color, tail_color, tail_color, tail_color]))

	# Earthquake windup pulsing glow
	if current_state == State.EARTHQUAKE_WINDUP:
		var pulse: float = absf(sin(state_timer * 8.0))
		var glow_color := Color(1.0, 0.0, 0.0, 0.3 * pulse)
		draw_rect(Rect2(-70, -90, 140, 100), glow_color)

	# Ground indicator during earthquake landing
	if current_state == State.EARTHQUAKE_LANDING:
		var indicator_color := Color(1.0, 0.3, 0.0, 0.5)
		draw_rect(Rect2(-80, -2, 160, 4), indicator_color)
