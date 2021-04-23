extends Node2D


func _ready():
	pass

func _physics_process(delta):
	pass
	#$Sprite/MarginContainer/VBoxContainer2/VBoxContainer/TextureButton 


func _on_TextureButton_pressed():
	get_tree().change_scene("res://lvl1.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()
