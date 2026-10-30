# Ad Maiorem Dei Gloriam!
@abstract class_name WeaponBase
extends Node2D

@export var is_heavy: bool = false
@abstract func attack()
signal attacked()
