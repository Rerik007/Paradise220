/obj/effect/proc_holder/spell/touch/infecting_touch
	name = "заражающее касание"

	base_cooldown = 60 SECONDS
	cooldown_min = 20 SECONDS
	invocation = "AULIE OXIN HALUNES"
	invocation_type = "whisper"
	hand_path = /obj/item/melee/touch_attack/infecting_touch

	action_icon_state = "infect_touch"


/obj/item/melee/touch_attack/infecting_touch
	name = "infecting touch"
	desc = "It's time to start infects around."
	catchphrase = "NWOLC EGNEVER"
	icon_state = "cluwnecurse"
	item_state = "cluwnecurse"


/obj/item/melee/touch_attack/infecting_touch/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !ishuman(target) || !iscarbon(user) || user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED)) //clowning around after touching yourself would unsurprisingly, be bad
		return

	if(iswizard(target))
		to_chat(user, "<span class='warning'>The spell has no effect on [target].</span>")
		return

	var/datum/effect_system/smoke_spread/s = new
	s.set_up(5, FALSE, target)
	s.start()

	var/virus_type = pick(
		/datum/disease/virus/advance,
		/datum/disease/virus/anxiety,
		/datum/disease/virus/beesease,
		/datum/disease/virus/brainrot,
		/datum/disease/virus/cold,
		/datum/disease/virus/flu,
		/datum/disease/virus/fluspanish,
		/datum/disease/virus/fake_gbs,
		/datum/disease/virus/loyalty,
		/datum/disease/virus/lycan,
		/datum/disease/virus/magnitis,
		/datum/disease/virus/pierrot_throat,
		/datum/disease/virus/pierrot_throat/advanced,
		/datum/disease/virus/tuberculosis,
		/datum/disease/virus/wizarditis,
	)

	var/datum/disease/virus/virus
	if(virus_type == /datum/disease/virus/advance)
		//creates only contagious viruses, that are always visible in Pandemic
		virus = CreateRandomVirus(count_of_symptoms = rand(4, 6), resistance = rand(0,11), stealth = pick(0,0,1,1,2),
							stage_rate = rand(-11,5), transmittable = rand(5,9), severity = rand(0,5))
	else
		virus = new virus_type()

	var/mob/living/carbon/human/human_target = target
	if(istype(virus, /datum/disease/virus/advance))
		var/datum/disease/virus/advance/old_virus = locate() in human_target.diseases
		if(old_virus)
			old_virus.cure(need_immunity = FALSE)

	virus.Contract(human_target, is_carrier = TRUE)

	return ..()

