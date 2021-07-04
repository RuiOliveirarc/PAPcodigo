extends KinematicBody2D

var anim_mode= "bot_walk"
var animation 

const beam = preload("res://beam.tscn")
const speed = 50
const gravity = 10
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = 1
var on_ground = false
var posicaobeam = 1

func _physics_process(delta):
	if direction == 1:
		$Sprite.flip_h=false
	else:
		$Sprite.flip_h=true
	
	
	velocity.x=speed * direction
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity , FLOOR)
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		
	
	
	#se tocar na parede vira para o outro lado
	if is_on_wall():
		inverter()
		
	if $RayCast2D.is_colliding() ==false:
		inverter()
	
	
	animacao()


func _on_detetarplayer_body_entered(body):
	if body.name=="player":
		bot_disparar()
	
func bot_disparar():
	anim_mode="bot_tiro"
	var BEAM = beam.instance()
	if sign($Position2D.position.x) == 1:
		BEAM.direcao_beam(1)
	else:
		BEAM.direcao_beam(-1)
	get_parent().add_child(BEAM)
	BEAM.position=$Position2D.global_position
	animacao()
	
func inverter():
	direction=direction * -1
	$RayCast2D.position.x *= -1
	$Position2D.position.x *= -1
	$detetarplayer.position*=-1
	
func animacao():
	animation = anim_mode
	anim_mode= "bot_walk"
	get_node("AnimationPlayer").play(animation)
	
func dead():
	velocity=Vector2(0,0)
	$CollisionShape2D.disabled= true
	$deadtimer.start()


func _on_deadtimer_timeout():
	queue_free()
