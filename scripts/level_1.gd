extends "res://scripts/level_base.gd"

## Level 1 - Beginner (Introduction to movement, jumping, shooting, and coins)


func _init() -> void:
	level_number = 1


func _build_level() -> void:
	# ------------------------------------------------------------------
	# Ground segments (total ~4800 px)
	# Easy, beginner-friendly gaps: 80 - 100 px
	# ------------------------------------------------------------------
	create_ground_segment(0, 1200)          # 0 – 1200
	# gap 80 px (1200 – 1280)
	create_ground_segment(1280, 1200)       # 1280 – 2480
	# gap 100 px (2480 – 2580)
	create_ground_segment(2580, 1100)       # 2580 – 3680
	# gap 90 px (3680 – 3770)
	create_ground_segment(3770, 1200)       # 3770 – 4970

	# ------------------------------------------------------------------
	# Elevated platforms (accessible heights: y=560 and y=500)
	# ------------------------------------------------------------------
	var p1 := create_platform(Vector2(800, 560), Vector2(200, 20))
	level_container.add_child(p1)

	var p2 := create_platform(Vector2(1700, 560), Vector2(220, 20))
	level_container.add_child(p2)

	var p3 := create_platform(Vector2(2000, 500), Vector2(180, 20))
	level_container.add_child(p3)

	var p4 := create_platform(Vector2(3100, 560), Vector2(200, 20))
	level_container.add_child(p4)

	# ------------------------------------------------------------------
	# Enemies (3 slow, easily dispatchable enemies)
	# ------------------------------------------------------------------
	add_enemy(Vector2(900, ground_y), 35)
	add_enemy(Vector2(1900, ground_y), 40)
	add_enemy(Vector2(3300, ground_y), 40)
	add_enemy(Vector2(4200, ground_y), 40)

	# ------------------------------------------------------------------
	# Ammo coins (generous supplies)
	# ------------------------------------------------------------------
	add_ammo_coin(Vector2(450, ground_y - 30))
	add_ammo_coin(Vector2(850, 530))
	add_ammo_coin(Vector2(1750, 530))
	add_ammo_coin(Vector2(2000, 470))
	add_ammo_coin(Vector2(2800, ground_y - 30))
	add_ammo_coin(Vector2(3850, ground_y - 30))

	# ------------------------------------------------------------------
	# Shield coins (only appears when player has no active shield)
	# ------------------------------------------------------------------
	add_shield_coin(Vector2(1400, ground_y - 30))
	add_shield_coin(Vector2(3500, ground_y - 30))

	# ------------------------------------------------------------------
	# Finish line
	# ------------------------------------------------------------------
	add_finish_line(4700)
