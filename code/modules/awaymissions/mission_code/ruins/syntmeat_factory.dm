/area/ruin/space/syntmeat_factory
	poweralm = FALSE
	report_alerts = FALSE
	requires_power = TRUE

/area/ruin/space/syntmeat_factory/main_lab
	name = "Main lab"
	icon_state = "away1"
	var/battle = FALSE
	var/cooldown = FALSE
	var/list/naughty_mobs
	var/mob/living/simple_animal/hostile/derp_mob/boss

/area/ruin/space/syntmeat_factory/entrence
	name = "Entrence"
	icon_state = "away2"

/area/ruin/space/syntmeat_factory/kitchen
	name = "Kitchen"
	icon_state = "away3"

/area/ruin/space/syntmeat_factory/dorms
	name = "Dorms"
	icon_state = "away4"

/area/ruin/space/syntmeat_factory/self_destruct
	name = "Self destruct"
	icon_state = "away5"
	var/obj/machinery/syndicatebomb/our_bomb
	var/derp_has_fallen = FALSE //remove this?
	var/safe_faction = list()


/area/ruin/space/syntmeat_factory/main_lab/proc/UnlockBlastDoors()
	if(!battle)
		return
	battle = FALSE
	for(var/obj/machinery/door/poddoor/impassable/preopen/P in GLOB.airlocks)
		if(P.id_tag == "[name]" && P.density && !P.operating)
			addtimer(CALLBACK(P, TYPE_PROC_REF(/obj/machinery/door, open)), 3 SECONDS)

/area/ruin/space/syntmeat_factory/main_lab/proc/BlockBlastDoors()
	if(battle)
		return
	for(var/obj/machinery/door/poddoor/impassable/preopen/P in GLOB.airlocks)
		if(P.id_tag == "[name]" && !P.density && P.z == z && !P.operating)
			INVOKE_ASYNC(P, TYPE_PROC_REF(/obj/machinery/door, close))
	battle = TRUE
	for(var/mob/trapped_one as anything in naughty_mobs)
		to_chat(trapped_one, span_danger("НЕ ЗНАЮ ЧТО ТУТ БУДЕТ НАПИСАНО НО ЯВНО ЧТО-ТО БУДЕТ!!!!"))

/area/ruin/space/syntmeat_factory/main_lab/proc/ready_or_not()
	SIGNAL_HANDLER
	for(var/mob/living/naughty as anything in naughty_mobs)
		if(naughty.is_dead() || !boss || boss.is_dead() || !naughty.mind)
			remove_from_naughty(naughty)

	if(length(naughty_mobs))
		BlockBlastDoors()
	else
		UnlockBlastDoors()

/area/ruin/space/syntmeat_factory/main_lab/Entered(atom/movable/arrived)
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

/area/ruin/space/syntmeat_factory/main_lab/Exited(atom/movable/departed)
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

/area/ruin/space/syntmeat_factory/main_lab/proc/add_to_naughty(mob/living/living_mob)
	if(!istype(living_mob))
		return FALSE
	if(!living_mob.mind || living_mob.is_dead())
		return FALSE
	LAZYADD(naughty_mobs, living_mob)
	RegisterSignal(living_mob, COMSIG_MOB_DEATH, PROC_REF(ready_or_not))
	return TRUE

/area/ruin/space/syntmeat_factory/main_lab/proc/remove_from_naughty(mob/living/living_mob)
	if(!istype(living_mob))
		return FALSE
	if(living_mob in naughty_mobs)
		naughty_mobs.Remove(living_mob)
		UnregisterSignal(living_mob, COMSIG_MOB_DEATH)
		return TRUE

/mob/living/simple_animal/hostile/derp_mob
	name = "Santa Derp"
	icon = 'icons/mob/winter_mob.dmi'
	icon_state = "placeholder"
	icon_living = "placeholder"
	icon_dead = "placeholder"
	faction = list("hostile", "syndicate", "derp")
	speak_chance = 0
	turns_per_move = 5
	speed = 1
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
	var/area/ruin/space/syntmeat_factory/main_lab/bossfight_area

/mob/living/simple_animal/hostile/derp_mob/Initialize(mapload)
	. = ..()
	bossfight_area = get_area(src)
	if(istype(bossfight_area))
		bossfight_area.boss = src

/mob/living/simple_animal/hostile/derp_mob/death(gibbed)
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
			bossfight_area.ready_or_not()
	else
		bossfight_area.ready_or_not()

/mob/living/simple_animal/hostile/derp_mob/stage_1		//stage 1: slow melee
	maxHealth = 150
	health = 150
	desc = "GET THE FAT DERP!"
	next_stage = /mob/living/simple_animal/hostile/derp_mob/stage_2
	death_message = "<span class='danger'>HO HO HO! YOU THOUGHT IT WOULD BE THIS EASY?!?</span>"
	speed = 2
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/derp_mob/stage_2		//stage 2: slow ranged
	desc = "GET THE FAT DERP AGAIN!"
	next_stage = /mob/living/simple_animal/hostile/derp_mob/stage_3
	death_message = "<span class='danger'>YOU'VE BEEN VERY NAUGHTY! PREPARE TO DIE!</span>"
	maxHealth = 200		//DID YOU REALLY BELIEVE IT WOULD BE THIS EASY!??!!
	health = 200
	ranged = 1
	projectiletype = /obj/item/projectile/ornament
	retreat_distance = 5
	minimum_distance = 5

/mob/living/simple_animal/hostile/derp_mob/stage_3		//stage 3: fast rapidfire ranged
	desc = "WHY WON'T DERP DIE ALREADY!?" //sorry
	next_stage = /mob/living/simple_animal/hostile/derp_mob/stage_4
	death_message = "<span class='danger'>FACE MY FINAL FORM AND KNOW DESPAIR!</span>"
	maxHealth = 250
	health = 250
	ranged = 1
	rapid = 3
	speed = 0	//he's lost some weight from the fighting
	projectiletype = /obj/item/projectile/ornament
	retreat_distance = 3
	minimum_distance = 3

/mob/living/simple_animal/hostile/derp_mob/stage_4		//stage 4: fast spinebreaker
	name = "Final Form DERP"
	desc = "WHAT THE HELL IS DERP!?! WHY WON'T DERP STAY DEAD!?!" //sorry again derp
	maxHealth = 250
	health = 250
	speed = 0	//he's lost some weight from the fighting

	environment_smash = 2		//naughty walls must be punished too
	melee_damage_lower = 20
	melee_damage_upper = 30		//that's gonna leave a mark, for sure

/mob/living/simple_animal/hostile/derp_mob/stage_4/death(gibbed)
	. = ..()
	if(!.)
		return FALSE
	to_chat(world, "<span class='notice'><hr></span>") //Миру не стоит как по мне
	to_chat(world, "<span class='notice'>THE FAT DERP HAS FALLEN!</span>")
	to_chat(world, "<span class='notice'>SANTA DERP HAS BEEN DEFEATED!</span>")
	to_chat(world, "<span class='notice'><hr></span>")
	//derp, remove below, clusterbuster good, but xmas clusterbusters are bad
	var/obj/item/grenade/clusterbuster/xmas/X = new /obj/item/grenade/clusterbuster/xmas(get_turf(src))
	var/obj/item/grenade/clusterbuster/xmas/Y = new /obj/item/grenade/clusterbuster/xmas(get_turf(src))
	X.prime()
	Y.prime()

/area/ruin/space/syntmeat_factory/self_destruct/Entered(mob/living/bourgeois)
	. = ..()
	if(!derp_has_fallen && istype(bourgeois) && !faction_check(bourgeois.faction, safe_faction))
		derp_has_fallen = TRUE
		add_game_logs("[key_name(bourgeois)] entered [src], without authorization. Self-destruction mechanism activated")
		our_bomb.payload?.adminlog = "[our_bomb] detonated in [src]. Self-destruction activated by [key_name(bourgeois)]!"
		our_bomb.activate()
		for(var/obj/machinery/power/apc/propaganda in GLOB.apcs)
			if(propaganda.z == our_bomb.z && get_dist(get_turf(our_bomb), propaganda) < 50)
				playsound(propaganda, 'sound/effects/self_destruct_17sec.ogg', 100)

/obj/machinery/syndicatebomb/syntmeat
	name = "self destruct device"
	desc = "High explosive. Don't touch."
	minimum_timer = 17 // why 17, derp?
	timer_set = 17
	payload = /obj/item/bombcore/syntmeat
	can_unanchor = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_ABSTRACT

/obj/machinery/syndicatebomb/syntmeat/Initialize(mapload) // derp, place it in target area
	. = ..()
	var/area/ruin/space/syntmeat_factory/self_destruct/our_area = get_area(src)
	if(!istype(our_area))
		our_area.our_bomb = src

/obj/machinery/syndicatebomb/syntmeat/activate()
	. = ..()
	invisibility = 0
	alpha = 0
	animate(src, 2 SECONDS, alpha = 255)
	// анимации появления тут. 2 строчки выше делают чтобы она становилось чёткой в 2 секунды, удалить наверное.

/obj/item/bombcore/syntmeat
	range_heavy = 20
	range_medium = 35
	range_light = 45
	range_flame = 30
	admin_log = TRUE

/obj/item/bombcore/syntmeat/detonate()
	if(adminlog)
		message_admins(adminlog)
		add_game_logs(adminlog)
	var/center = get_turf(src)
	explosion(center, range_heavy, range_medium, range_light, flame_range = range_flame, adminlog = admin_log, ignorecap = 1, cause = fingerprintslast)
	delete_unnecessary(center)
	if(istype(loc, /obj/machinery/syndicatebomb))
		qdel(loc)
	qdel(src)

/obj/item/bombcore/syntmeat/proc/delete_unnecessary(center)
	for(var/atom/A in range(35, center))
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
	var/obj/item/bombcore/syntmeat/C = loc
	new /obj/effect/decal/cleanable/ash(get_turf(loc))
	new /obj/effect/particle_effect/smoke(get_turf(loc))
	playsound(src, 'sound/effects/empulse.ogg', 80)
	qdel(C)
