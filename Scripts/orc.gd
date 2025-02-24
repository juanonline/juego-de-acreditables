extends CharacterBody2D

@export var speed: float = 50.0
@export var attack_range: float = 20.0

@onready var player: Node2D = get_tree().get_first_node_in_group("player") # Asegúrate de que el jugador tenga el grupo "player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer

var is_attacking: bool = false
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if is_dead or is_attacking or not player:
		return

	var direction: Vector2 = (player.position - position).normalized()
	var distance: float = position.distance_to(player.position)

	if distance > attack_range:
		set_velocity(direction * speed)  # Usamos set_velocity en lugar de asignar velocity directamente
		animated_sprite.play("Orc_Walk")
	else:
		set_velocity(Vector2.ZERO)
		if not is_attacking:
			attack()

	move_and_slide()  # Ahora sí funcionará correctamente

func attack() -> void:
	is_attacking = true
	animated_sprite.play("Orc_Attack")
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	is_attacking = false

func take_damage() -> void:
	if is_dead:
		return
	animated_sprite.play("Orc_Hurt")
	await get_tree().create_timer(0.3).timeout  # Breve pausa antes de moverse

func die() -> void:
	is_dead = true
	animated_sprite.play("Orc_death")
	set_physics_process(false)
