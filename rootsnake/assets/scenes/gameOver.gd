extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabel.text = str(Globals.globalScore)
	if Globals.globalScore > Globals.highScore:
		Globals.highScore = Globals.globalScore
	$HiscoreLabel.text = str(Globals.highScore)
	$CauseLabel.text = Globals.causeOfDeath


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RetryButton_pressed():
	get_tree().change_scene("res://assets/scenes/MechanicTest.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
