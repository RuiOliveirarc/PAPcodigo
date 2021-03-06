extends KinematicBody2D

var anim_mode= "idle"
var animation 
var facing_right = true
var vida = 3
var x = 0



const speed = 85
const gravity = 10
const jumpower = -250
const FLOOR = Vector2(0,-1)
const beam = preload("res://beam.tscn")

var velocity = Vector2()

var on_ground = false
var is_dead= false

func _physics_process(delta):
	
	if is_dead == false:
	
		#Virar o sprite para a direção que o personagem anda
		if facing_right == true:
			$Sprite.scale.x = 2
		else:
			$Sprite.scale.x = -2
		
		#andar para a direita (seta para direita)
		if Input.is_action_pressed("ui_right"):
			velocity.x=speed
			anim_mode="run"
			facing_right= true
			if sign($Position2D.position.x)== -1:
				$Position2D.position.x *= -1
			
		#andar para a esquerda (seta para esquerda)
		elif Input.is_action_pressed("ui_left"):
			velocity.x=-speed
			anim_mode="run"
			facing_right= false
			if sign($Position2D.position.x)== 1:
				$Position2D.position.x *= -1
		else:
			velocity.x=0
			
		#saltar(seta para cima)
		if Input.is_action_just_pressed("ui_up"):
			anim_mode="jump"
			if on_ground == true:
				velocity.y=jumpower
				on_ground=false
				
			
		#Lançar o poder(TAB)
		if Input.is_action_just_pressed("ui_focus_next"):
			anim_mode="tiro"
			var BEAM = beam.instance()
			if sign($Position2D.position.x) == 1:
				BEAM.direcao_beam(1)
			else:
				BEAM.direcao_beam(-1)
			get_parent().add_child(BEAM)
			BEAM.position=$Position2D.global_position
		
		velocity.y += gravity
		
		if is_on_floor():
			on_ground = true
		else:
			anim_mode= "fall"
			on_ground = false
		
		velocity = move_and_slide(velocity , FLOOR)
		
		
		
		#se o player tocar na cobra morre
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Snake" in get_slide_collision(i).collider.name:
					velocity.y=jumpower
					dead()
					get_slide_collision(i).collider.mudardirecaosnake()
	#animaçoes
		animation = anim_mode
		anim_mode= "idle"
		get_node("AnimationPlayer").play(animation)



#funcão para matar o player
func dead():
	#vidas
	vida -= 1
	if (vida==1):
		$vida_time.start()
	else:
		$vida_time2.start()
	
	get_node("Camera2D/vida_sprite").frame += 1
	if(vida == 0):
		is_dead=true
		anim_mode="die"
		animation = anim_mode
		get_node("AnimationPlayer").play(animation)
		velocity=Vector2(0,0)
		$CollisionShape2D.disabled=true
		$Timer.start()



func _on_Timer_timeout():
	get_node("AnimationPlayer").play("gameover")
	$Timer2.start()
	


func _on_falllzone_body_entered(body):
	dead()
	dead()
	dead()


func _on_Timer2_timeout():
	get_tree().reload_current_scene()
	#get_tree().change_scene("res://lvl1.tscn")


func _on_nextlvl_body_entered(body):
	get_tree().change_scene("res://lvl2.tscn")



func _on_lvl2hurt1_body_entered(body):
	dead()
	dead()
	dead()


func _on_Area2D_body_entered(body):
	dead()
	dead()
	dead()


func _on_vida_time_timeout():
	x += 1
	if( x % 2 == 0):
		get_node("Sprite").visible = true
	else:
		get_node("Sprite").visible = false
	if (x == 7):
		get_node("Sprite").visible = true
		x=0
		$vida_time.stop()
	else:
		$vida_time.start()



func _on_vida_time2_timeout():
	x += 1
	if( x % 2 == 0):
		get_node("Sprite").visible = true
	else:
		get_node("Sprite").visible = false
	if (x == 7):
		get_node("Sprite").visible = true
		x=0
		$vida_time2.stop()
	else:
		$vida_time2.start()



func _on_nextlvl2_body_entered(body):
	get_tree().change_scene("res://lvl3.tscn")
