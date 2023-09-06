extends TextureButton

func _on_playButton_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
