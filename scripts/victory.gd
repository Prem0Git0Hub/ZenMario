extends Control

# Victory - shown when the dragon boss is defeated

var color_time: float = 0.0
var title_label: Label


func _ready() -> void:
	get_tree().paused = false

	# Dark blue/purple background
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.04, 0.2)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Center container
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	center.add_child(vbox)

	# VICTORY title
	title_label = Label.new()
	title_label.text = "VICTORY!"
	title_label.add_theme_font_size_override("font_size", 72)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)

	# Subtitle
	var subtitle := Label.new()
	subtitle.text = "You defeated the Dragon!"
	subtitle.add_theme_font_size_override("font_size", 28)
	subtitle.add_theme_color_override("font_color", Color(0.9, 0.75, 1.0))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	# Congratulations
	var congrats := Label.new()
	congrats.text = "Congratulations, brave hero!\nYou have conquered Zenmario!"
	congrats.add_theme_font_size_override("font_size", 20)
	congrats.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
	congrats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(congrats)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	vbox.add_child(spacer)

	# Play Again button
	var play_btn := Button.new()
	play_btn.text = "Play Again"
	play_btn.custom_minimum_size = Vector2(200, 50)
	play_btn.add_theme_font_size_override("font_size", 24)
	play_btn.pressed.connect(_on_play_again_pressed)
	var btn_center := CenterContainer.new()
	btn_center.add_child(play_btn)
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


func _process(delta: float) -> void:
	# Animated color cycling on the title
	color_time += delta * 1.5
	var r := (sin(color_time) + 1.0) * 0.5
	var g := (sin(color_time + 2.0) + 1.0) * 0.35 + 0.5
	var b := (sin(color_time + 4.0) + 1.0) * 0.3
	title_label.add_theme_color_override("font_color", Color(r, g, b))


func _on_play_again_pressed() -> void:
	GameManager.restart_game()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
