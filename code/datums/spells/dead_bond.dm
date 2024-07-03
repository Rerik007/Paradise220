/obj/effect/proc_holder/spell/dead_bond
	name = "Армия мёртвых"
	desc = "Creates a net between you and your nearby friends that evenly shares all damage received."
	gain_desc = "You have gained the ability to share damage between you and your friends."
	action_icon_state = "dead_bond"
	human_req = FALSE
	clothes_req = FALSE
	invocation_type = "shout"
	invocation = "NECREM IMORTIUM!"
	base_cooldown = 2 MINUTES
	cooldown_min = 1 MINUTES

/obj/effect/proc_holder/spell/dead_bond/create_new_targeting()
	return new /datum/spell_targeting/self

/obj/effect/proc_holder/spell/dead_bond/cast(list/targets, mob/living/user = usr)
	var/datum/status_effect/wizard_net/wizard_net = user.has_status_effect(STATUS_EFFECT_WIZARD_NET)
	if(!wizard_net)
		user.apply_status_effect(STATUS_EFFECT_WIZARD_NET)
		return
	qdel(wizard_net)
