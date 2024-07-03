/obj/effect/proc_holder/spell/second_wind
	name = "Второе дыхание"
	desc = "Creates a net between you and your nearby thralls that evenly shares all damage received."
	gain_desc = "You have gained the ability to share damage between you and your thralls."
	action_icon_state = "second_wind"
	human_req = TRUE
	clothes_req = FALSE
	invocation_type = "shout"
	invocation = "UMA BAKRUS!"
	base_cooldown = 40 SECONDS
	cooldown_min = 40 SECONDS

/obj/effect/proc_holder/spell/second_wind/create_new_targeting()
	return new /datum/spell_targeting/self

/obj/effect/proc_holder/spell/second_wind/cast(list/targets, mob/living/carbon/human/user = usr)
	user.adjustBruteLoss(-20, TRUE)
	user.adjustFireLoss(-20, TRUE)
	user.setStaminaLoss(0, TRUE)
	var/datum/status_effect/second_wind/second_wind = user.has_status_effect(STATUS_EFFECT_SECOND_WIND)
	if(!second_wind)
		user.apply_status_effect(STATUS_EFFECT_SECOND_WIND)
		return
	qdel(second_wind)
