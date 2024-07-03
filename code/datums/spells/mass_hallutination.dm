
/obj/effect/proc_holder/spell/aoe/hallutination
	name = "Mass Hallutination"

	base_cooldown = 60 SECONDS
	cooldown_min = 20 SECONDS
	invocation = "AULIE OXIN HALUNES"
	invocation_type = "whisper"

	action_icon_state = "m_hallutination"
	aoe_range = 9


/obj/effect/proc_holder/spell/aoe/hallutination/create_new_targeting()
	var/datum/spell_targeting/aoe/T = new()
	T.allowed_type = /mob/living
	T.range = aoe_range
	return T


/obj/effect/proc_holder/spell/aoe/hallutination/cast(list/targets, mob/user = usr)
	for(var/mob/living/living_target as anything in targets)
		living_target.AdjustHallucinate(120 SECONDS)
		living_target.EyeBlind(3 SECONDS)
