extends CanvasLayer

# Pause Menu - overlay with resume, restart, and main menu options

var panel: ColorRect


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20

	# Semi-transparent dark overlay
	panel = ColorRect.new()
	panel.color = Color(0.0, 0.0, 0.0, 0.65)
	panel.position = Vector2.ZERO
	panel.size = Vector2(1280, 720)
	add_child(panel)

	# Center container for the menu items
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	center.add_child(vbox)

	# "PAUSED" label
	var pause_label := Label.new()
	pause_label.text = "PAUSED"
	pause_label.add_theme_font_size_override("font_size", 48)
	pause_label.add_theme_color_override("font_color", Color.WHITE)
	pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(pause_label)

	# Resume button
	var resume_btn := Button.new()
	resume_btn.text = "Resume"
	resume_btn.custom_minimum_size = Vector2(180, 45)
	resume_btn.add_theme_font_size_override("font_size", 22)
	resume_btn.pressed.connect(_on_resume)
	vbox.add_child(resume_btn)

	# Restart button
	var restart_btn := Button.new()
	restart_btn.text = "Restart"
	restart_btn.custom_minimum_size = Vector2(180, 45)
	restart_btn.add_theme_font_size_override("font_size", 22)
	restart_btn.pressed.connect(_on_restart)
	vbox.add_child(restart_btn)

	# Main Menu button
	var menu_btn := Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.custom_minimum_size = Vector2(180, 45)
	menu_btn.add_theme_font_size_override("font_size", 22)
	menu_btn.pressed.connect(_on_main_menu)
	vbox.add_child(menu_btn)

	# Start hidden
	panel.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func toggle_pause() -> void:
	GameManager.toggle_pause()
	panel.visible = GameManager.is_paused


func _on_resume() -> void:
	toggle_pause()


func _on_restart() -> void:
	panel.visible = false
	GameManager.restart_game()


func _on_main_menu() -> void:
	GameManager.is_paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
