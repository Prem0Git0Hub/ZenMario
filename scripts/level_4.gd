extends "res://scripts/level_base.gd"

## Level 4 - Pre-Boss Challenge (Exciting platforming, fully clearable)


func _init() -> void:
	level_number = 4


func _build_level() -> void:
	# ------------------------------------------------------------------
	# Ground segments (total ~5600 px)
	# Gaps: 120 - 140 px (tested and easily clearable with ~250 px max jump)
	# ------------------------------------------------------------------
	create_ground_segment(0, 950)           # 0 – 950
	# gap 120 px (950 – 1070)
	create_ground_segment(1070, 950)        # 1070 – 2020
	# gap 130 px (2020 – 2150)
	create_ground_segment(2150, 950)        # 2150 – 3100
	# gap 130 px (3100 – 3230)
	create_ground_segment(3230, 950)        # 3230 – 4180
	# gap 140 px (4180 – 4320)
	create_ground_segment(4320, 1200)       # 4320 – 5520

	# ------------------------------------------------------------------
	# Elevated platforms (generous widths: 170-200 px)
	# ------------------------------------------------------------------
	# Bridge over gap 1
	var p1 := create_platform(Vector2(1010, 550), Vector2(170, 20))
	level_container.add_child(p1)

	# Stepped platforms along section 2
	var p2 := create_platform(Vector2(1450, 560), Vector2(180, 20))
	level_container.add_child(p2)

	var p3 := create_platform(Vector2(1700, 500), Vector2(160, 20))
	level_container.add_child(p3)

	# Bridge over gap 2
	var p4 := create_platform(Vector2(2085, 540), Vector2(170, 20))
	level_container.add_child(p4)

	# Stepped sequence 2
	var p5 := create_platform(Vector2(2500, 560), Vector2(180, 20))
	level_container.add_child(p5)

	var p6 := create_platform(Vector2(2750, 500), Vector2(160, 20))
	level_container.add_child(p6)

	# Bridge over gap 3
	var p7 := create_platform(Vector2(3165, 540), Vector2(170, 20))
	level_container.add_child(p7)

	# Stepped sequence 3
	var p8 := create_platform(Vector2(3550, 560), Vector2(180, 20))
	level_container.add_child(p8)

	var p9 := create_platform(Vector2(3800, 500), Vector2(160, 20))
	level_container.add_child(p9)

	# Bridge over gap 4
	var p10 := create_platform(Vector2(4250, 540), Vector2(170, 20))
	level_container.add_child(p10)

	# ------------------------------------------------------------------
	# Enemies (balanced placement allowing clear line of sight to shoot)
	# ------------------------------------------------------------------
	add_enemy(Vector2(600, ground_y), 50)
	add_enemy(Vector2(1300, ground_y), 60)
	add_enemy(Vector2(1700, 480), 40)       # platform enemy
	add_enemy(Vector2(2350, ground_y), 60)
	add_enemy(Vector2(2750, 480), 40)       # platform enemy
	add_enemy(Vector2(3400, ground_y), 65)
	add_enemy(Vector2(3800, 480), 40)       # platform enemy
	add_enemy(Vector2(4600, ground_y), 65)

	# ------------------------------------------------------------------
	# Ammo coins (reward both ground and platform jumps)
	# ------------------------------------------------------------------
	add_ammo_coin(Vector2(400, ground_y - 30))
	add_ammo_coin(Vector2(1010, 520))       # on bridge platform
	add_ammo_coin(Vector2(1700, 470))       # on stepped platform
	add_ammo_coin(Vector2(2500, ground_y - 30))
	add_ammo_coin(Vector2(3165, 510))       # on bridge platform
	add_ammo_coin(Vector2(4500, ground_y - 30))

	# ------------------------------------------------------------------
	# Shield coins (only appears when player has no active shield)
	# ------------------------------------------------------------------
	add_shield_coin(Vector2(1450, ground_y - 30))
	add_shield_coin(Vector2(3550, ground_y - 30))

	# ------------------------------------------------------------------
	# Finish line (transition into Level 5 Dragon Arena)
	# ------------------------------------------------------------------
	add_finish_line(5300)
