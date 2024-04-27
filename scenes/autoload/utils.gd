extends Node


# Returns if float is in range 0,1
func dice_roll(num: float): 
	return randf() < num
