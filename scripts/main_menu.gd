extends Control

# Main Menu - Title screen with start button and controls info


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

	# Dark arcade background
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.08, 0.18)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Center container
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 14)
	center.add_child(vbox)

	# Spacer top
	var spacer_top := Control.new()
	spacer_top.custom_minimum_size = Vector2(0, 10)
	vbox.add_child(spacer_top)

	# Title
	var title := Label.new()
	title.text = "ZENMARIO"
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.15))
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Subtitle
	var subtitle := Label.new()
	subtitle.text = "2D Arcade Platformer & Dragon Arena"
	subtitle.add_theme_font_size_override("font_size", 22)
	subtitle.add_theme_color_override("font_color", Color(0.65, 0.85, 1.0))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)

	# Start button
	var start_btn := Button.new()
	start_btn.text = "START GAME"
	start_btn.custom_minimum_size = Vector2(220, 50)
	start_btn.add_theme_font_size_override("font_size", 24)
	start_btn.pressed.connect(_on_start_pressed)
	var btn_center := CenterContainer.new()
	btn_center.add_child(start_btn)
	vbox.add_child(btn_center)

	# Spacer
	var spacer2 := Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer2)

	# Controls header
	var controls_header := Label.new()
	controls_header.text = "— CONTROLS —"
	controls_header.add_theme_font_size_override("font_size", 20)
	controls_header.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))
	controls_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(controls_header)

	# Controls list
	var controls_box := VBoxContainer.new()
	controls_box.alignment = BoxContainer.ALIGNMENT_CENTER
	controls_box.add_theme_constant_override("separation", 6)
	vbox.add_child(controls_box)

	var controls := [
		"A / Left Arrow  —  Move Left (when permitted)",
		"D / Right Arrow  —  Move Right",
		"Space / W / Up Arrow  —  Jump",
		"Left Mouse Button or J  —  Shoot Blaster",
		"K  —  Special Attack (Level 5 Boss Arena when fully charged)",
		"Esc  —  Pause / Resume Game",
	]

	for line in controls:
		var lbl := Label.new()
		lbl.text = line
		lbl.add_theme_font_size_override("font_size", 16)
		lbl.add_theme_color_override("font_color", Color(0.8, 0.85, 0.95))
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		controls_box.add_child(lbl)


func _on_start_pressed() -> void:
	GameManager.load_level(1)
