extends "res://scripts/level_base.gd"

## Level 3 - Advanced Platforming (Stepped platform routes, fair jumping)


func _init() -> void:
	level_number = 3


func _build_level() -> void:
	# ------------------------------------------------------------------
	# Ground segments (total ~5600 px)
	# Fair gaps: 110 - 130 px (well within the 250 px max jump limit)
	# ------------------------------------------------------------------
	create_ground_segment(0, 1000)          # 0 – 1000
	# gap 110 px (1000 – 1110)
	create_ground_segment(1110, 950)        # 1110 – 2060
	# gap 120 px (2060 – 2180)
	create_ground_segment(2180, 950)        # 2180 – 3130
	# gap 125 px (3130 – 3255)
	create_ground_segment(3255, 950)        # 3255 – 4205
	# gap 120 px (4205 – 4325)
	create_ground_segment(4325, 1100)       # 4325 – 5425

	# ------------------------------------------------------------------
	# Stepped platforms (y=560, y=500, y=440 - intuitive stairs)
	# ------------------------------------------------------------------
	# Bridge over gap 1
	var p1 := create_platform(Vector2(1055, 540), Vector2(160, 20))
	level_container.add_child(p1)

	# Stepped sequence 1
	var p2 := create_platform(Vector2(1450, 560), Vector2(160, 20))
	level_container.add_child(p2)

	var p3 := create_platform(Vector2(1700, 500), Vector2(160, 20))
	level_container.add_child(p3)

	# Bridge over gap 2
	var p4 := create_platform(Vector2(2120, 540), Vector2(160, 20))
	level_container.add_child(p4)

	# Stepped sequence 2
	var p5 := create_platform(Vector2(2550, 560), Vector2(160, 20))
	level_container.add_child(p5)

	var p6 := create_platform(Vector2(2800, 500), Vector2(160, 20))
	level_container.add_child(p6)

	var p7 := create_platform(Vector2(3000, 450), Vector2(150, 20))
	level_container.add_child(p7)

	# Bridge over gap 3
	var p8 := create_platform(Vector2(3190, 540), Vector2(160, 20))
	level_container.add_child(p8)

	# High route near gap 4
	var p9 := create_platform(Vector2(3750, 550), Vector2(160, 20))
	level_container.add_child(p9)

	var p10 := create_platform(Vector2(4265, 540), Vector2(160, 20))
	level_container.add_child(p10)

	# ------------------------------------------------------------------
	# Enemies (balanced speeds and fair spacing)
	# ------------------------------------------------------------------
	add_enemy(Vector2(650, ground_y), 50)
	add_enemy(Vector2(1400, ground_y), 55)
	add_enemy(Vector2(1700, 480), 35)       # slow enemy on platform
	add_enemy(Vector2(2400, ground_y), 55)
	add_enemy(Vector2(2800, 480), 35)       # platform enemy
	add_enemy(Vector2(3500, ground_y), 60)
	add_enemy(Vector2(4600, ground_y), 60)

	# ------------------------------------------------------------------
	# Ammo coins
	# ------------------------------------------------------------------
	add_ammo_coin(Vector2(450, ground_y - 30))
	add_ammo_coin(Vector2(1700, 470))       # on stepped platform
	add_ammo_coin(Vector2(2500, ground_y - 30))
	add_ammo_coin(Vector2(3000, 420))       # on high platform
	add_ammo_coin(Vector2(3600, ground_y - 30))
	add_ammo_coin(Vector2(4700, ground_y - 30))

	# ------------------------------------------------------------------
	# Shield coins (only appears when player has no active shield)
	# ------------------------------------------------------------------
	add_shield_coin(Vector2(1300, ground_y - 30))
	add_shield_coin(Vector2(3450, ground_y - 30))

	# ------------------------------------------------------------------
	# Finish line
	# ------------------------------------------------------------------
	add_finish_line(5200)
