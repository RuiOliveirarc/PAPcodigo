extends Area2D


const SPEED = 250
var velocity = Vector2()
var direcao = 1

func _ready():
	pass 

func direcao_beam(dir):
	direcao = dir
	if dir == -1:
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direcao
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_beam_body_entered(body):
	if "player" in body.name:
		body.dead()
	queue_free()
