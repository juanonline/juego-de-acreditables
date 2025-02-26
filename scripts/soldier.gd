extends CharacterBody2D

@export var animation_player: AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking = false

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Manejar salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Manejar ataque
	if Input.is_key_pressed(KEY_F) and not is_attacking:
		is_attacking = true
		animation_player.play("Attack")
		await animation_player.animation_finished
		is_attacking = false
		return  # No permitir movimiento mientras ataca

	# Manejar movimiento
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$Sprite2D.scale.x = -1 if direction < 0 else 1  # Voltear sprite si va a la izquierda
		_play_animation("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		_play_animation("Idle")

	move_and_slide()

func _play_animation(anim_name):
	if animation_player.current_animation != anim_name and not is_attacking:
		animation_player.play(anim_name)
