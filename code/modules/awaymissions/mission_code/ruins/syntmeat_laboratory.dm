/area/vision_change_area/syntmeat_laboratory
	poweralm = FALSE
	report_alerts = FALSE
	requires_power = TRUE
	has_gravity = TRUE
	there_can_be_many = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = list('sound/ambience/spooky/chill.ogg',\
						'sound/ambience/spooky/angels.ogg',\
						'sound/ambience/spooky/clank1.ogg',\
						'sound/ambience/spooky/decafinatd.ogg',\
						'sound/ambience/spooky/distantclank1.ogg',\
						'sound/ambience/spooky/groan3.ogg',\
						'sound/ambience/spooky/groan2.ogg',\
						'sound/ambience/spooky/metaldoor2.ogg',\
						'sound/ambience/spooky/metaldoor1.ogg',\
						'sound/ambience/spooky/howled_4.ogg',\
						'sound/ambience/spooky/ugrnd_ambient_banging_1.ogg',\
						'sound/ambience/spooky/ugrnd_ambient_banging_2.ogg',\
						'sound/ambience/spooky/ugrnd_drip_3.ogg',\
						'sound/ambience/spooky/ugrnd_drip_4.ogg',\
						'sound/ambience/spooky/ugrnd_drip_5.ogg',\
						'sound/ambience/spooky/ugrnd_drip_6.ogg',\
						'sound/ambience/spooky/ugrnd_drip_7.ogg')

	sound_environment = list('sound/ambience/spooky/argitoth.ogg',\
						'sound/ambience/spooky/crystal_underground.ogg',\
						'sound/ambience/spooky/moon_underground.ogg',\
						'sound/ambience/spooky/horror.ogg',\
						'sound/ambience/spooky/horror_2.ogg',\
						'sound/ambience/spooky/horror_3.ogg',\
						'sound/ambience/spooky/ominous_loop1.ogg',\
						'sound/ambience/spooky/burning_terror.ogg')
	max_ambience_cooldown = 60 SECONDS

/area/ruin/space/test ////////////////////////////не забыть удалить      ////// узнать какая цифра stat является BROKEN
	name = "Test area" /////////////////////////////////отбалансить хп и шанс отрубания у гориллы; отбалансить количество мясных зомбей и их хп/урон, скорость
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED //////////////////// добавить таблетку с полезным вирусом / рандомные полезные вирусы в холодос вирусологии
												///////// создать новые консоли/переписать прок для оверлеев под мапперские скины
		///// добавить объект "1000 и 1 андекдот"
///////// при использовании будет выпадать случайное число от 1 до 1001 с текстом
//////////"Вы прочитали анекдот [номер анекдота]" форс смеха/улыбки у игрокаы

/area/vision_change_area/syntmeat_laboratory/main_lab
	name = "Main laboratory"
	icon_state = "away1"
	var/battle = FALSE
	var/cooldown = FALSE
	var/list/naughty_mobs
	var/mob/living/simple_animal/hostile/skinner/boss

/area/vision_change_area/syntmeat_laboratory/entrence
	name = "Entrence"
	icon_state = "away2"

/area/vision_change_area/syntmeat_laboratory/kitchen
	name = "Kitchen"
	icon_state = "away3"

/area/vision_change_area/syntmeat_laboratory/dorms
	name = "Dorms"
	icon_state = "away4"

/area/vision_change_area/syntmeat_laboratory/check_point
	name = "Check point"
	icon_state = "away5"

/area/vision_change_area/syntmeat_laboratory/virology
	name = "Virology"
	icon_state = "away6"

/area/vision_change_area/syntmeat_laboratory/second_lab
	name = "Second laboratory"
	icon_state = "away7"

/area/vision_change_area/syntmeat_laboratory/maintenance
	name = "Maintenance"
	icon_state = "away8"

/area/vision_change_area/syntmeat_laboratory/outside
	name = "Outside"
	icon_state = "away9"
	has_gravity = FALSE
	ambientsounds = list('sound/ambience/spooky/bass_ambience.ogg')
	sound_environment = list('sound/ambience/spooky/space_loop1.ogg',\
							'sound/ambience/spooky/space_loop2.ogg',\
							'sound/ambience/spooky/space_loop3.ogg',\
							'sound/ambience/spooky/space_loop4.ogg',\
							'sound/ambience/spooky/space_loop5.ogg')

/area/vision_change_area/syntmeat_laboratory/near_asteroid
	name = "Space near the asteroid"
	icon_state = "away10"
	has_gravity = FALSE
	ambientsounds = list('sound/ambience/spooky/dark_ambient_ eerie.ogg',\
						'sound/ambience/spooky/deep_ominous_drone.ogg')
	sound_environment = list('sound/ambience/spooky/space_loop1.ogg',\
							'sound/ambience/spooky/space_loop2.ogg',\
							'sound/ambience/spooky/space_loop3.ogg',\
							'sound/ambience/spooky/space_loop4.ogg',\
							'sound/ambience/spooky/space_loop5.ogg')
	max_ambience_cooldown = 60 SECONDS

/area/vision_change_area/syntmeat_laboratory/self_destruct
	name = "Self destruct"
	icon_state = "away11"
	var/obj/machinery/syndicatebomb/our_bomb
	var/derp_has_fallen = FALSE //remove this?
	var/safe_faction = list()

/area/vision_change_area/syntmeat_laboratory/main_lab/proc/BlockBlastDoors()
	if(battle)
		return
	for(var/obj/machinery/door/poddoor/impassable/P in GLOB.airlocks)
		if(P.id_tag == "[name]" && !P.density && P.z == z && !P.operating)
			INVOKE_ASYNC(P, TYPE_PROC_REF(/obj/machinery/door, close))
	battle = TRUE
	for(var/mob/trapped_one as anything in naughty_mobs)
		to_chat(trapped_one, span_danger("НЕ ЗНАЮ ЧТО ТУТ БУДЕТ НАПИСАНО НО ЯВНО ЧТО-ТО БУДЕТ!!!!"))

/area/vision_change_area/syntmeat_laboratory/main_lab/proc/ready_or_not()
	SIGNAL_HANDLER
	for(var/mob/living/naughty as anything in naughty_mobs)
		if(naughty.is_dead() || !boss || boss.is_dead() || !naughty.mind)
			remove_from_naughty(naughty)

	if(length(naughty_mobs))
		BlockBlastDoors()

/area/vision_change_area/syntmeat_laboratory/main_lab/Entered(atom/movable/arrived)
	. = ..()
	if(!boss || boss.is_dead())
		return

	var/mob/living/living_mob = arrived
	if(ismecha(arrived))
		var/obj/mecha/mecha = arrived
		if(mecha.occupant)
			living_mob = mecha.occupant

	if(istype(arrived, /obj/structure/closet))
		for(var/mob/living/living in arrived)
			add_to_naughty(living)

	add_to_naughty(living_mob)

	if(cooldown)
		return
	cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(ready_or_not)), 4 SECONDS, TIMER_UNIQUE)

/area/vision_change_area/syntmeat_laboratory/main_lab/Exited(atom/movable/departed)
	. = ..()
	if(!boss || boss.is_dead())
		return
	var/mob/living/living_mob = departed
	if(ismecha(departed))
		var/obj/mecha/mecha = departed
		if(mecha.occupant)
			living_mob = mecha.occupant

	if(istype(departed, /obj/structure/closet))
		for(var/mob/living/living in departed)
			remove_from_naughty(living)

	remove_from_naughty(living_mob)

/area/vision_change_area/syntmeat_laboratory/main_lab/proc/add_to_naughty(mob/living/living_mob)
	if(!istype(living_mob))
		return FALSE
	if(!living_mob.mind || living_mob.is_dead())
		return FALSE
	LAZYADD(naughty_mobs, living_mob)
	RegisterSignal(living_mob, COMSIG_MOB_DEATH, PROC_REF(ready_or_not))
	return TRUE

/area/vision_change_area/syntmeat_laboratory/main_lab/proc/remove_from_naughty(mob/living/living_mob)
	if(!istype(living_mob))
		return FALSE
	if(living_mob in naughty_mobs)
		naughty_mobs.Remove(living_mob)
		UnregisterSignal(living_mob, COMSIG_MOB_DEATH)
		return TRUE

///////////////////////
////////////// PRINCIPAL SKINNER
///////////////////////

/mob/living/simple_animal/hostile/skinner
	name = "Skinner"
	icon = 'icons/mob/winter_mob.dmi'
	icon_state = "placeholder"
	icon_living = "placeholder"
	icon_dead = "placeholder"
	faction = list("hostile", "undead")
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	maxHealth = 150		//if this seems low for a "boss", it's because you have to fight him multiple times, with him fully healing between stages
	health = 150
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	sentience_type = SENTIENCE_OTHER
	robust_searching = 1
	vision_range = 12
	melee_damage_lower = 3
	melee_damage_upper = 7
	var/next_stage = null
	var/death_message
	/// If TRUE you should spawn it only on special area, see bossfight_area
	var/with_area = TRUE

	var/area/vision_change_area/syntmeat_laboratory/main_lab/bossfight_area

/mob/living/simple_animal/hostile/skinner/Initialize(mapload)
	. = ..()
	if(with_area)
		bossfight_area = get_area(src)
		bossfight_area.boss = src

/mob/living/simple_animal/hostile/skinner/death(gibbed)
	. = ..(gibbed)
	if(!.)
		return FALSE // Only execute the below if we successfully died
	if(death_message)
		visible_message(death_message)
	if(next_stage)
		spawn(1 SECONDS)
			if(!QDELETED(src))
				new next_stage(get_turf(src))
				qdel(src)
			bossfight_area?.ready_or_not()
	else
		new /obj/effect/particle_effect/smoke/vomiting (get_turf(src))
		new /mob/living/simple_animal/hostile/living_limb_flesh (get_turf(src))
		new /mob/living/simple_animal/hostile/living_limb_flesh (get_turf(src))
		new /obj/item/reagent_containers/food/snacks/monstermeat/rotten/jumping (get_turf(src))
		new /obj/item/reagent_containers/food/snacks/monstermeat/rotten/jumping (get_turf(src))
		new /obj/item/nullrod/armblade (get_turf(src))
		gib(src)
		bossfight_area?.ready_or_not()

/mob/living/simple_animal/hostile/skinner/stage_1		//stage 1: weak melee
	desc = "GET THE FAT DERP!"
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "skinner"
	icon_living = "skinner"
	icon_dead = "skinner"
	maxHealth = 50
	health = 50
	next_stage = /mob/living/simple_animal/hostile/skinner/stage_2
	death_message = "<span class='danger'>HO HO HO! YOU THOUGHT IT WOULD BE THIS EASY?!?</span>"
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/skinner/stage_1/without_area
	with_area = FALSE
	next_stage = /mob/living/simple_animal/hostile/skinner/stage_2/without_area

/mob/living/simple_animal/hostile/skinner/stage_2		//stage 2: strong melee
	desc = "GET THE FAT DERP AGAIN!"
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "skinner_transform"
	icon_living = "skinner_transform"
	icon_dead = "skinner_transform"
	death_message = "<span class='danger'>YOU'VE BEEN VERY NAUGHTY! PREPARE TO DIE!</span>"
	maxHealth = 200		//DID YOU REALLY BELIEVE IT WOULD BE THIS EASY!??!! /// it really easy
	health = 200
	melee_damage_upper = 30
	sharp_attack = TRUE
	canmove = FALSE

/mob/living/simple_animal/hostile/skinner/stage_2/without_area
	with_area = FALSE

/mob/living/simple_animal/hostile/skinner/stage_2/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon), UPDATE_ICON_STATE), 1.5 SECONDS)
	addtimer(VARSET_CALLBACK(src, canmove, TRUE), 1 SECONDS)

/mob/living/simple_animal/hostile/skinner/stage_2/update_icon_state()
	icon_state = "skinner_monster"
	icon_living = "skinner_monster"

///////////////////////
////////////// SYNT MEAT MONKEY
///////////////////////

/mob/living/simple_animal/hostile/syntmeat_monkey
	name = "\improper meat boy"
	desc = "As tasty as normal cow."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stok_old"
	icon_living = "stok_old"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh = 4)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "царапает"
	death_sound = 'sound/goonstation/voice/monkey_scream.ogg'
	tts_seed = "Bounty"
	speak_chance = 2
	speak = list("Baaa!","ROOOOAAA RAAA!","Hee-haw.")
	speak_emote = list("screams","roars")
	emote_hear = list("screams")
	emote_see = list("scratches itself","waving its paws")
	health = 35
	maxHealth = 35
	flip_on_death = TRUE
	retaliate_only = TRUE
	melee_damage_lower = 7
	melee_damage_upper = 12

/mob/living/simple_animal/hostile/syntmeat_monkey/proc/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

///////////////////////
////////////// SELF DESTRUCT
///////////////////////

/area/vision_change_area/syntmeat_laboratory/self_destruct/Entered(mob/living/bourgeois)
	. = ..()
	if(!derp_has_fallen && istype(bourgeois) && !faction_check(bourgeois.faction, safe_faction))
		derp_has_fallen = TRUE
		add_game_logs("[key_name(bourgeois)] entered [src], without authorization. Self-destruction mechanism activated")
		our_bomb.payload?.adminlog = "[our_bomb] detonated in [src]. Self-destruction activated by [key_name(bourgeois)]!"
		our_bomb.activate()
		for(var/obj/machinery/power/apc/propaganda in GLOB.apcs)
			if(propaganda.z == our_bomb.z && get_dist(get_turf(our_bomb), propaganda) < 50)
				playsound(propaganda, 'sound/effects/self_destruct_17sec.ogg', 100)


#define NONACTIVE_STATE "hatch"
#define ACTIVATING_STATE "unfloored"
#define DEACTIVATING_STATE "floored"
#define IDLE_STATE "base"

/obj/machinery/syndicatebomb/syntmeat
	name = "self destruct device"
	desc = "High explosive. Don't touch." ///// звук для сирены 'sound/effects/alarm_30sec.ogg'
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_hatch"
	minimum_timer = 30
	timer_set = 30
	payload = /obj/item/bombcore/syntmeat
	can_unanchor = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_ABSTRACT
	var/activate_state = null

/obj/machinery/syndicatebomb/syntmeat/Initialize(mapload) // derp, place it in target area
	. = ..()
	var/area/vision_change_area/syntmeat_laboratory/self_destruct/our_area = get_area(src)
	if(istype(our_area))
		our_area.our_bomb = src

/obj/machinery/syndicatebomb/syntmeat/activate()
	. = ..()
	invisibility = 0
	animate_on()

/obj/machinery/syndicatebomb/syntmeat/proc/animate_on()
	sleep(2 SECONDS)
	activate_state = ACTIVATING_STATE
	update_icon(UPDATE_ICON_STATE)
	sleep(3 SECONDS)
	activate_state = IDLE_STATE
	update_icon(UPDATE_ICON_STATE)

/obj/machinery/syndicatebomb/syntmeat/proc/animate_off()
	sleep(2 SECONDS)
	activate_state = DEACTIVATING_STATE
	update_icon(UPDATE_ICON_STATE)
	sleep(3 SECONDS)
	activate_state = NONACTIVE_STATE
	update_icon(UPDATE_ICON_STATE)


/obj/machinery/syndicatebomb/syntmeat/update_icon_state()
	if(activate_state)
		icon_state = "nuclearbomb_[activate_state]"

#undef NONACTIVE_STATE
#undef ACTIVATING_STATE
#undef DEACTIVATING_STATE
#undef IDLE_STATE

/obj/item/bombcore/syntmeat
	range_heavy = 20
	range_medium = 35
	range_light = 45
	range_flame = 30
	admin_log = TRUE
	ignorecap = TRUE
	special_deletes = TRUE

/obj/item/bombcore/syntmeat/delete_unnecessary(center)
	for(var/atom/A as anything in range(35, center))
		if(isliving(A))
			var/mob/living/mob = A
			mob.gib()
		if(istype(A, /obj/structure/closet))
			for(var/obj/item/I in A.contents)
				qdel(I)
			qdel(A)
		if(istype(A, /obj/structure/safe) || istype(A, /obj/item/gun))
			qdel(A)

/obj/item/bombcore/syntmeat/defuse()
	var/obj/machinery/syndicatebomb/syntmeat/C = loc
	C.animate_off()
	new /obj/effect/decal/cleanable/ash(get_turf(loc))
	new /obj/effect/particle_effect/smoke(get_turf(loc))
	playsound(src, 'sound/effects/empulse.ogg', 80)

///////////////////////
////////////// CHEMICALS
///////////////////////

/datum/chemical_reaction/syntiflesh2
	name = "Syntiflesh 2.0"
	id = "syntiflesh2"
	result = null
	required_reagents = list("blood" = 5, "meatocreatadone" = 5)
	result_amount = 1

/datum/chemical_reaction/syntiflesh2/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)

/datum/chemical_reaction/livingflesh
	name = "Living flesh"
	id = "livingflesh"
	min_temp = 1000
	result = null
	required_reagents = list("mutagen" = 25, "meatocreatadone" = 25)
	result_amount = 1

/datum/chemical_reaction/livingflesh/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /mob/living/simple_animal/hostile/living_limb_flesh(location)

/datum/reagent/medicine/meatocreatadone
	data = list("diseases" = null)
	name = "Meatocreatadone"
	id = "meatocreatadone"
	description = "A plasma mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 265K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#4e0303"
	taste_description = "bitterness"
	can_synth = FALSE
	heart_rate_stop = 0  ////// нужно ли это логгировать?

/obj/item/reagent_containers/glass/beaker/large/meatocreatadone
	list_reagents = list("meatocreatadone" = 100)

///////////////////////
////////////// GASEOUS VIRUS
///////////////////////

/obj/effect/viral_gas
	name = "cloud of gas"
	icon_state = "mustard"
	layer = ABOVE_MOB_LAYER
	alpha = 180
	var/virus = /datum/disease/virus/cadaver
	var/chance_of_infection = 20

/obj/effect/viral_gas/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop/virus, probability = chance_of_infection, flags = CALTROP_BYPASS_WALKERS, virus_type = virus)

/obj/effect/viral_gas/is_cleanable()
	if(!QDELETED(src))
		return TRUE

/obj/effect/viral_gas/water_act(volume, temperature, source, method)
	. = ..()
	qdel(src)

/obj/item/reagent_containers/food/pill/random_syntmeat_virus
	spawned_disease = /datum/disease/virus/advance/syntmeat_random

/datum/disease/virus/advance/syntmeat_random
	var/static/list/random_symptoms = list(
		/datum/symptom/voice_change,
		/datum/symptom/mind_restoration,
		/datum/symptom/sensory_restoration,
		/datum/symptom/vomit/projectile,
		/datum/symptom/shedding,
		/datum/symptom/laugh,
		/datum/symptom/love,
		/datum/symptom/damage_converter,
		/datum/symptom/oxygen,
		/datum/symptom/painkiller,
		/datum/symptom/epinephrine,
		/datum/symptom/itching,
		/datum/symptom/dizzy,
		/datum/symptom/limb_throw,
		/datum/symptom/bones,
		/datum/symptom/moan,
	)

/datum/disease/virus/advance/syntmeat_random/New()
	var/list/random_symptoms_copy = random_symptoms.Copy()
	for(var/i in 1 to rand(4, 6))
		var/datum/symptom/symptom_path = pick_n_take(random_symptoms_copy)
		symptoms += new symptom_path
	..()
	name = capitalize(pick(GLOB.adjectives)) + " " + capitalize(pick(GLOB.nouns + GLOB.verbs))


/obj/item/reagent_containers/food/pill/jungle_fever
	spawned_disease = /datum/disease/virus/transformation/jungle_fever

/obj/item/reagent_containers/food/pill/anxiety
	spawned_disease = /datum/disease/virus/anxiety

/obj/item/reagent_containers/food/pill/beesease
	spawned_disease = /datum/disease/virus/beesease

/obj/item/reagent_containers/food/pill/food_poisoning
	spawned_disease = /datum/disease/food_poisoning

/obj/item/reagent_containers/food/pill/vampire
	spawned_disease = /datum/disease/vampire

/obj/item/reagent_containers/food/pill/fake_gbs
	spawned_disease = /datum/disease/virus/fake_gbs

/obj/item/reagent_containers/food/pill/pierrot_throat
	spawned_disease = /datum/disease/virus/pierrot_throat

/obj/item/reagent_containers/food/pill/pre_loyalty
	spawned_disease = /datum/disease/virus/advance/preset/pre_loyalty
