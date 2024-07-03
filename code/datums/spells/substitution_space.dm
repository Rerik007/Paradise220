/obj/effect/proc_holder/spell/substitution
	name = "Подмена в космосе"
	desc = "Creates a net between you and your nearby thralls that evenly shares all damage received."
	gain_desc = "You have gained the ability to share damage between you and your thralls."
	action_icon_state = "substitution"
	human_req = FALSE
	clothes_req = FALSE
	base_cooldown = 40 SECONDS
	cooldown_min = 40 SECONDS
	centcom_cancast = FALSE

/obj/effect/proc_holder/spell/substitution/create_new_targeting()
	return new /datum/spell_targeting/self

/obj/effect/proc_holder/spell/substitution/cast(list/targets, mob/living/user = usr)
	var/turf/our_turf = get_turf(user)
	if(!istype(our_turf) || !length(SSmobs.clients_by_zlevel[our_turf.z]))
		to_chat(user, span_warning("There are no suitable targets in your place."))
		return
	var/list/target_list = list()
	for(var/mob/living/living_pick in SSmobs.clients_by_zlevel[our_turf.z])
		target_list += living_pick
	if(!length(target_list))
		to_chat(user, span_warning("There are no suitable targets in your place."))
		return
	var/mob/living/living_target = pick(target_list)
	var/turf/target_turf = get_turf(living_target)
	living_target.forceMove(our_turf)
	user.forceMove(target_turf)
	SEND_SOUND(living_target, 'sound/hallucinations/behind_you1.ogg')
	living_target.flash_eyes(2, TRUE, affect_silicon = TRUE) // flash to give them a second to lose track of who is who
