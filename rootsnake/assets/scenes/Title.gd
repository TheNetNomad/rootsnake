extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://assets/scenes/MechanicTest.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	var credits = get_node("CreditsButton/CreditsTextureRect")
	if credits.visible:
		credits.visible = false
	else:
		credits.visible = true
	#get_node("CreditsButton/CreditsTextureRect").visible = true
