extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_button_4_pressed() -> void:
	$CreditsMenu.visible = true
	$CenterContainer/VBoxContainer/Button.visible = false
	$CenterContainer/VBoxContainer/Button2.visible = false
	$CenterContainer/VBoxContainer/Button3.visible = false
	$CenterContainer/VBoxContainer/Button4.visible = false
	


func _on_back_pressed() -> void:
	$CreditsMenu.visible = false
	$CenterContainer/VBoxContainer/Button.visible = true
	$CenterContainer/VBoxContainer/Button2.visible = true
	$CenterContainer/VBoxContainer/Button3.visible = true
	$CenterContainer/VBoxContainer/Button4.visible = true
