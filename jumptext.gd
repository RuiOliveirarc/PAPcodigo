extends RichTextLabel

var dialogo=["Clique na seta para cima para saltar!!!"]
var pagina=0
func _ready():
	set_bbcode(dialogo[pagina])
	set_visible_characters(0)
	
	


func timer_jumptext():
	$jumptextTimer.start()

func _on_jumptextTimer_timeout():
	set_visible_characters(get_visible_characters()+1)


func _on_jumptextarea_body_entered(body):
	timer_jumptext()
