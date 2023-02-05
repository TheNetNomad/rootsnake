extends Label


var score = 0


func add_score(score_increase):
	score += score_increase
	text = str(score)
