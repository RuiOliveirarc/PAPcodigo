extends RichTextLabel

var dialogo=["Ola Bem-vindo ao tutorial"]
var pagina=0
func _ready():
	set_bbcode(dialogo[pagina])
	set_visible_characters(0)

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
