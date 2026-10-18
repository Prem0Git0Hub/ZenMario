extends Control

# Game Over - displayed when the player dies


func _ready() -> void:
	get_tree().paused = false

	# Dark red tinted background
	var bg := ColorRect.new()
	bg.color = Color(0.25, 0.02, 0.02)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Center container
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	center.add_child(vbox)

	# GAME OVER title
	var title := Label.new()
	title.text = "GAME OVER"
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(1.0, 0.15, 0.15))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Level info
	var level_info := Label.new()
	level_info.text = "You fell on Level " + str(GameManager.current_level)
	level_info.add_theme_font_size_override("font_size", 24)
	level_info.add_theme_color_override("font_color", Color(0.8, 0.6, 0.6))
	level_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(level_info)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)

	# Try Again button
	var retry_btn := Button.new()
	retry_btn.text = "Try Again"
	retry_btn.custom_minimum_size = Vector2(200, 50)
	retry_btn.add_theme_font_size_override("font_size", 24)
	retry_btn.pressed.connect(_on_retry_pressed)
	var btn_center := CenterContainer.new()
	btn_center.add_child(retry_btn)
	vbox.add_child(btn_center)

	# Main Menu button
	var menu_btn := Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.custom_minimum_size = Vector2(200, 50)
	menu_btn.add_theme_font_size_override("font_size", 24)
	menu_btn.pressed.connect(_on_menu_pressed)
	var btn_center2 := CenterContainer.new()
	btn_center2.add_child(menu_btn)
	vbox.add_child(btn_center2)


func _on_retry_pressed() -> void:
	GameManager.restart_game()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
