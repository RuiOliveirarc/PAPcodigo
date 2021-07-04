extends KinematicBody2D

var anim_mode= "walk"
var animation 
var is_dead = false

const speed = 10
const gravity = 10
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = 1

var on_ground = false

func dead():
	is_dead=true
	velocity=Vector2(0,0)
	$CollisionShape2D.disabled= true
	$Timer.start()
	

func _physics_process(delta):
	if is_dead==false:
		#Virar o sprite para a direção que o inimigo anda 
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
		mudardirecaosnake()
	
	#se chegar a ponta do chao em vez de cair,vira para outro lado
	if $RayCast2D.is_colliding() ==false:
		mudardirecaosnake()
	
	#se a cobra tocar no player mata-o
	if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.dead() 
	
	
	#animacoes
	animation = anim_mode
	anim_mode= "walk"
	get_node("AnimationPlayer").play(animation)

func mudardirecaosnake():
	direction=direction * -1
	$RayCast2D.position.x *= -1

func _on_Timer_timeout():
	queue_free()


func _on_head_body_entered(body):
	if body.name=="player":
		dead()
