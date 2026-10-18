extends "res://scripts/level_base.gd"

## Level 2 - Increasing Challenge (Fun, fair, and completely clearable)


func _init() -> void:
	level_number = 2


func _build_level() -> void:
	# ------------------------------------------------------------------
	# Ground segments (total ~5200 px)
	# Max jump distance is ~250 px. All gaps are 90 - 120 px (generous margin!)
	# ------------------------------------------------------------------
	create_ground_segment(0, 1100)          # 0 – 1100
	# gap 100 px (1100 – 1200)
	create_ground_segment(1200, 1000)       # 1200 – 2200
	# gap 110 px (2200 – 2310)
	create_ground_segment(2310, 1000)       # 2310 – 3310
	# gap 120 px (3310 – 3430)
	create_ground_segment(3430, 950)        # 3430 – 4380
	# gap 110 px (4380 – 4490)
	create_ground_segment(4490, 900)        # 4490 – 5390

	# ------------------------------------------------------------------
	# Elevated platforms (easily reachable heights: y=560 and y=490)
	# ------------------------------------------------------------------
	# Step-up platform over ground 1
	var p1 := create_platform(Vector2(600, 560), Vector2(180, 20))
	level_container.add_child(p1)

	# Stepping stone platform bridging gap 1 (1100-1200) for an easy high route
	var p2 := create_platform(Vector2(1150, 530), Vector2(160, 20))
	level_container.add_child(p2)

	# Mid-level platform section (accessible from ground)
	var p3 := create_platform(Vector2(1600, 560), Vector2(200, 20))
	level_container.add_child(p3)

	var p4 := create_platform(Vector2(1850, 490), Vector2(160, 20))
	level_container.add_child(p4)

	# Stepping stone platform bridging gap 2 (2200-2310)
	var p5 := create_platform(Vector2(2255, 540), Vector2(160, 20))
	level_container.add_child(p5)

	# Low platform rewarding jumping
	var p6 := create_platform(Vector2(2800, 560), Vector2(180, 20))
	level_container.add_child(p6)

	# Stepping stone platform bridging gap 3 (3310-3430)
	var p7 := create_platform(Vector2(3370, 540), Vector2(160, 20))
	level_container.add_child(p7)

	# Platform near the end stretch
	var p8 := create_platform(Vector2(3900, 550), Vector2(180, 20))
	level_container.add_child(p8)

	# ------------------------------------------------------------------
	# Enemies (paced with fair reaction distance)
	# ------------------------------------------------------------------
	add_enemy(Vector2(750, ground_y), 45)
	add_enemy(Vector2(1450, ground_y), 50)
	add_enemy(Vector2(1650, 540), 35)       # slow enemy on platform
	add_enemy(Vector2(2650, ground_y), 50)
	add_enemy(Vector2(3650, ground_y), 50)
	add_enemy(Vector2(4750, ground_y), 55)

	# ------------------------------------------------------------------
	# Ammo coins (generous placements)
	# ------------------------------------------------------------------
	add_ammo_coin(Vector2(450, ground_y - 30))
	add_ammo_coin(Vector2(650, 530))        # on platform
	add_ammo_coin(Vector2(1850, 460))       # on higher platform
	add_ammo_coin(Vector2(2500, ground_y - 30))
	add_ammo_coin(Vector2(2850, 530))       # on platform
	add_ammo_coin(Vector2(4100, ground_y - 30))

	# ------------------------------------------------------------------
	# Shield coins (only appears when player has no active shield)
	# ------------------------------------------------------------------
	add_shield_coin(Vector2(1350, ground_y - 30))
	add_shield_coin(Vector2(3600, ground_y - 30))

	# ------------------------------------------------------------------
	# Finish line
	# ------------------------------------------------------------------
	add_finish_line(5100)
