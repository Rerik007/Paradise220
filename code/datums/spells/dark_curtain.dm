/obj/effect/proc_holder/spell/aoe/dark_curtain
	name = "тёмная завеса"
	desc = "Extinguishes most nearby light sources."
	clothes_req = FALSE
	aoe_range = 5
	base_cooldown = 35 SECONDS
	human_req = FALSE
	action_icon_state = "ns_veil"


/obj/effect/proc_holder/spell/aoe/dark_curtain/create_new_targeting()
	var/datum/spell_targeting/aoe/turf/T = new()
	T.range = aoe_range
	return T


/obj/effect/proc_holder/spell/aoe/dark_curtain/cast(list/targets, mob/user = usr)
	to_chat(user, "<span class='shadowling'>You silently disable all nearby lights.</span>")
	for(var/turf/T in targets)
		T.extinguish_light()
		for(var/atom/A in T.contents)
			A.extinguish_light()
