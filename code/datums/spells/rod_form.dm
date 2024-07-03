/// The base distance a wizard rod will go without upgrades.
#define BASE_WIZ_ROD_RANGE 15

/obj/effect/proc_holder/spell/rod_form
	name = "Rod Form"
	desc = "Take on the form of an immovable rod, destroying all in your path."
	clothes_req = TRUE
	human_req = FALSE
	base_cooldown = 1 MINUTES
	cooldown_min = 20 SECONDS
	invocation = "CLANG!"
	invocation_type = "shout"
	action_icon_state = "immrod"
	centcom_cancast = FALSE
	sound = 'sound/effects/whoosh.ogg'
	/// The max distance the rod goes on cast
	var/rod_max_distance = BASE_WIZ_ROD_RANGE
	/// Rod speed
	var/rod_delay = 2
	/// Rod type
	var/rod_type = /obj/effect/immovablerod/wizard


/obj/effect/proc_holder/spell/rod_form/create_new_targeting()
	return new /datum/spell_targeting/self


/obj/effect/proc_holder/spell/rod_form/cast(list/targets, mob/user = usr)
	var/turf/start = get_turf(user)
	if(!start || start != user.loc)
		to_chat(user, span_warning("You cannot summon a rod in the ether, the spell fizzles out!"))
		revert_cast()
		return FALSE

	var/flight_dist = rod_max_distance + spell_level * 3
	var/turf/distant_turf = get_ranged_target_turf(start, user.dir, flight_dist)
	new rod_type(start, distant_turf, null, rod_delay, FALSE, user, flight_dist)

/obj/effect/proc_holder/spell/rod_form/drake
	name = "Fiery Race"
	action_icon_state = "drake_rod"
	rod_type = /obj/effect/immovablerod/wizard/drake
	clothes_req = FALSE
	human_req = TRUE
	base_cooldown = 30 SECONDS
	rod_delay = 1
	rod_max_distance = 6


/**
 * Wizard Version of the Immovable Rod
 */
/obj/effect/immovablerod/wizard
	notify = FALSE
	/// The wizard who's piloting our rod.
	var/mob/living/wizard
	/// The distance the rod will go.
	var/max_distance = BASE_WIZ_ROD_RANGE
	/// The turf the rod started from, to calcuate distance.
	var/turf/start_turf


/obj/effect/immovablerod/wizard/Initialize(mapload, atom/target_atom, atom/specific_target, move_delay = 1, force_looping = FALSE, mob/living/wizard, max_distance = BASE_WIZ_ROD_RANGE)
	. = ..()
	if(wizard)
		set_wizard(wizard)
	src.start_turf = get_turf(src)
	src.max_distance = max_distance


/obj/effect/immovablerod/wizard/Destroy(force)
	start_turf = null
	if(wizard)
		eject_wizard()
	return ..()


/obj/effect/immovablerod/wizard/Move(atom/newloc, direct = NONE, glide_size_override = 0, update_dir = TRUE)
	if(get_dist(start_turf, get_turf(src)) >= max_distance)
		qdel(src)
		return
	return ..()


/// Should never happen, but better safe than sorry
/obj/effect/immovablerod/wizard/penetrate(mob/living/smeared_mob)
	if(smeared_mob == wizard)
		return
	return ..()


/**
 * Set wizard as our_wizard, placing them in the rod
 * and preparing them for travel.
 */
/obj/effect/immovablerod/wizard/proc/set_wizard(mob/living/wizard)
	setDir(wizard.dir)
	src.wizard = wizard
	wizard.forceMove(src)
	wizard.status_flags |= GODMODE
	ADD_TRAIT(wizard, TRAIT_NO_TRANSFORM, UNIQUE_TRAIT_SOURCE(src))


/**
 * Eject our current wizard, removing them from the rod
 * and fixing all of the variables we changed.
 */
/obj/effect/immovablerod/wizard/proc/eject_wizard()
	if(QDELETED(wizard))
		wizard = null
		return
	REMOVE_TRAIT(wizard, TRAIT_NO_TRANSFORM, UNIQUE_TRAIT_SOURCE(src))
	wizard.status_flags &= ~GODMODE
	wizard.forceMove(get_turf(src))
	wizard = null

/obj/effect/immovablerod/wizard/drake
	icon = 'icons/mob/lavaland/64x64megafauna.dmi'
	icon_state = "dragon"
	max_distance = 6

/obj/effect/immovablerod/wizard/drake/special_rod_attack(mob/living/carbon/human/smeared_human)
	smeared_human.adjustFireLoss(30)
	smeared_human.adjust_fire_stacks(3)
	smeared_human.IgniteMob()

/obj/effect/immovablerod/wizard/drake/ex_rod_act(mob/living/carbon/human/smeared_human)
	return

#undef BASE_WIZ_ROD_RANGE

