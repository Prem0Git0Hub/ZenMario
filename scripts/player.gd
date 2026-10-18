extends CharacterBody2D

# --- Constants ---
const GRAVITY: float = 900.0
const JUMP_VELOCITY: float = -520.0
const AUTO_RUN_SPEED: float = 220.0
const MOVE_SPEED: float = 320.0
const SHOOT_COOLDOWN_TIME: float = 0.3
const INVINCIBLE_TIME: float = 1.5

# --- State ---
var facing_right: bool = true
var is_stunned: bool = false
var stun_timer: float = 0.0
var shoot_cooldown: float = 0.0
var invincible: bool = false
var invincible_timer: float = 0.0
var muzzle_flash_timer: float = 0.0
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

# --- Cached children ---
var _hurtbox: Area2D
var _camera: Camera2D

# --- Preloads ---
var _projectile_scene: PackedScene = preload("res://scenes/projectile.tscn")


func _ready() -> void:
	add_to_group("player")

	# --- Collision setup ---
	collision_layer = 1   # Layer 1: Player
	collision_mask = 4    # Layer 3: Platforms

	# --- Body CollisionShape2D ---
	var body_shape := CollisionShape2D.new()
	var rect_shape := RectangleShape2D.new()
	rect_shape.size = Vector2(28, 56)
	body_shape.shape = rect_shape
	body_shape.position = Vector2(0, -28)  # centered on body (origin at feet)
	add_child(body_shape)

	# --- Hurtbox (Area2D) ---
	_hurtbox = Area2D.new()
	_hurtbox.collision_layer = 0
	_hurtbox.collision_mask = 2   # Layer 2: Enemies/Dragon
	_hurtbox.monitoring = true

	var hurtbox_shape := CollisionShape2D.new()
	var hurt_rect := RectangleShape2D.new()
	hurt_rect.size = Vector2(30, 58)
	hurtbox_shape.shape = hurt_rect
	hurtbox_shape.position = Vector2(0, -28)
	_hurtbox.add_child(hurtbox_shape)
	add_child(_hurtbox)
	_hurtbox.body_entered.connect(_on_hurtbox_body_entered)

	# --- Camera2D (used in Levels 1-4) ---
	_camera = Camera2D.new()
	_camera.position_smoothing_enabled = true
	_camera.position_smoothing_speed = 5.0
	add_child(_camera)
	if GameManager.is_boss_level():
		_camera.enabled = false
	else:
		_camera.make_current()


func _physics_process(delta: float) -> void:
	# --- Stun timer ---
	if is_stunned:
		stun_timer -= delta
		if stun_timer <= 0.0:
			is_stunned = false
			stun_timer = 0.0

	# --- Invincibility timer & flash ---
	if invincible:
		invincible_timer -= delta
		# Flash by toggling alpha every 0.1s
		modulate.a = 0.3 if fmod(invincible_timer, 0.2) < 0.1 else 1.0
		if invincible_timer <= 0.0:
			invincible = false
			invincible_timer = 0.0
			modulate.a = 1.0

	# --- Shoot cooldown ---
	if shoot_cooldown > 0.0:
		shoot_cooldown -= delta

	# --- Muzzle flash ---
	if muzzle_flash_timer > 0.0:
		muzzle_flash_timer -= delta

	# --- Gravity & Floor detection ---
	if is_on_floor():
		coyote_timer = 0.15
	else:
		coyote_timer -= delta
		velocity.y += GRAVITY * delta
	velocity.y = minf(velocity.y, 1200.0)

	# --- Horizontal movement ---
	if GameManager.is_boss_level():
		# Free movement in boss level
		var dir: float = Input.get_axis("move_left", "move_right")
		velocity.x = dir * MOVE_SPEED
		if dir > 0.0:
			facing_right = true
		elif dir < 0.0:
			facing_right = false
	else:
		# Auto-run right in levels 1-4
		velocity.x = AUTO_RUN_SPEED

	# --- Override movement when stunned ---
	if is_stunned:
		velocity.x = 0.0

	# --- Jump with Buffer & Coyote Time ---
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = 0.15
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# Variable jump height cut when release early
	if Input.is_action_just_released("jump") and velocity.y < -150.0:
		velocity.y = -150.0

	# --- Shoot ---
	if Input.is_action_just_pressed("shoot") and shoot_cooldown <= 0.0:
		_shoot()

	# --- Special attack (boss level only) ---
	if Input.is_action_just_pressed("special_attack") and GameManager.is_boss_level():
		_special_attack()

	# --- Move ---
	move_and_slide()

	# --- Fall off screen ---
	if global_position.y > 800.0:
		if GameManager.is_boss_level():
			GameManager.take_damage_boss(20.0)
		else:
			GameManager.take_damage(1)
		# Respawn at a reasonable position if still alive
		if GameManager.player_health > 0 or GameManager.player_health_boss > 0.0:
			global_position = Vector2(global_position.x, 100.0)
			velocity = Vector2.ZERO

	queue_redraw()


func _shoot() -> void:
	if not GameManager.use_ammo():
		return
	shoot_cooldown = SHOOT_COOLDOWN_TIME
	muzzle_flash_timer = 0.1

	var proj: Node = _projectile_scene.instantiate()
	proj.direction = Vector2.RIGHT if facing_right else Vector2.LEFT
	var offset_x: float = 20.0 if facing_right else -20.0
	proj.global_position = global_position + Vector2(offset_x, -5.0)
	get_tree().current_scene.add_child(proj)


func _special_attack() -> void:
	if GameManager.use_special_attack():
		# Deal damage to all bosses
		var bosses := get_tree().get_nodes_in_group("boss")
		for boss_node in bosses:
			if boss_node.has_method("take_special_hit"):
				boss_node.take_special_hit(50.0)
		# Brief visual flash
		modulate = Color(2.0, 2.0, 3.0, 1.0)
		await get_tree().create_timer(0.15).timeout
		modulate = Color(1.0, 1.0, 1.0, 1.0)


func apply_stun(duration: float) -> void:
	is_stunned = true
	stun_timer = duration


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if invincible:
		return
	if body.is_in_group("enemies") or body.is_in_group("boss"):
		if GameManager.is_boss_level():
			GameManager.take_damage_boss(10.0)
		else:
			GameManager.take_damage(1)
		invincible = true
		invincible_timer = INVINCIBLE_TIME
		# Kill regular enemies on contact
		if body.is_in_group("enemies") and body.has_method("take_hit"):
			body.take_hit(1)


func _draw() -> void:
	var alpha: float = 0.4 if invincible else 1.0

	# --- Body rectangle (origin at feet, draw upward) ---
	var body_rect := Rect2(-14, -56, 28, 56)
	draw_rect(body_rect, Color(0.2, 0.4, 0.9, alpha))

	# --- Face / visor area ---
	var face_rect := Rect2(-10, -50, 20, 14)
	draw_rect(face_rect, Color(0.4, 0.6, 1.0, alpha))

	# --- Eyes ---
	var left_eye_x: float = -5.0
	var right_eye_x: float = 5.0
	var eye_y: float = -43.0
	# White parts
	draw_circle(Vector2(left_eye_x, eye_y), 3.0, Color(1.0, 1.0, 1.0, alpha))
	draw_circle(Vector2(right_eye_x, eye_y), 3.0, Color(1.0, 1.0, 1.0, alpha))
	# Pupils — shift based on facing direction
	var pupil_offset: float = 1.5 if facing_right else -1.5
	draw_circle(Vector2(left_eye_x + pupil_offset, eye_y), 1.5, Color(0.0, 0.0, 0.0, alpha))
	draw_circle(Vector2(right_eye_x + pupil_offset, eye_y), 1.5, Color(0.0, 0.0, 0.0, alpha))

	# --- Blaster arm ---
	var blaster_x: float = 16.0 if facing_right else -16.0
	var blaster_rect: Rect2
	if facing_right:
		blaster_rect = Rect2(14, -24, 12, 6)
	else:
		blaster_rect = Rect2(-26, -24, 12, 6)
	draw_rect(blaster_rect, Color(0.5, 0.5, 0.6, alpha))

	# --- Muzzle flash ---
	if muzzle_flash_timer > 0.0:
		var muzzle_x: float = 30.0 if facing_right else -30.0
		draw_circle(Vector2(muzzle_x, -21.0), 5.0, Color(1.0, 1.0, 0.3, alpha))

	# --- Shield aura ---
	if GameManager.has_shield:
		draw_arc(Vector2(0, -28), 34.0, 0.0, TAU, 32, Color(0.0, 1.0, 1.0, 0.35 * alpha), 2.0)
		draw_circle(Vector2(0, -28), 34.0, Color(0.0, 1.0, 1.0, 0.12 * alpha))
