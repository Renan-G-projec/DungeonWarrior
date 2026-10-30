# Ad Maiorem Dei Gloriam!
## Autoload: TransitionManager
extends CanvasLayer

var _transition_tween: Tween

# This function simply flash the game and on the flash calls the function middle_of_transition
# Can be used to switch scenes with lambdas i thiiink
func flash(middle_of_transition: Callable, fade_in: float =  0.2, fade_out: float = 0.2) -> void:
	if _transition_tween:
		_transition_tween.kill()
	_transition_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	
	_transition_tween.tween_property($ColorRect, "color", Color($ColorRect.color, 1.0), fade_in)
	_transition_tween.tween_callback(middle_of_transition)
	_transition_tween.tween_property($ColorRect, "color", Color($ColorRect.color, 0.0), fade_out)
