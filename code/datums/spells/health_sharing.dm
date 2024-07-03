/obj/effect/proc_holder/spell/health_sharing
	name = "обмен здоровьем"
	desc = "This spell triggers a curse on a target, causing them to wield an unremovable horse head mask. They will speak like a horse! Any masks they are wearing will be disintegrated. This spell does not require robes."
	school = "transmutation"
	base_cooldown = 30 SECONDS
	cooldown_min = 10 SECONDS
	clothes_req = FALSE
	human_req = TRUE
	stat_allowed = CONSCIOUS

	selection_activated_message = "<span class='notice'>You start to quietly neigh an incantation. Click on or near a target to cast the spell.</span>"
	selection_deactivated_message = "<span class='notice'>You stop neighing to yourself.</span>"

	action_icon_state = "health_sharing"
	need_active_overlay = TRUE


/obj/effect/proc_holder/spell/health_sharing/create_new_targeting()
	var/datum/spell_targeting/click/T = new()
	T.selection_type = SPELL_SELECTION_RANGE
	return T


/obj/effect/proc_holder/spell/health_sharing/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!length(targets))
		user.balloon_alert(user, "рядом нет подходящих целей!")
		return

	var/mob/living/carbon/human/target = targets[1]
	var/bruteloss = user.getBruteLoss()
	var/oxyloss = user.getOxyLoss()
	var/fireloss = user.getFireLoss()
	var/toxloss = user.getToxLoss()
	var/cloneloss = user.getCloneLoss()
	var/brainloss = user.getBrainLoss()
	var/staminaloss = user.getStaminaLoss()
	user.adjustBruteLoss(-bruteloss + target.getBruteLoss(), FALSE)
	user.adjustFireLoss(-fireloss + target.getFireLoss(), FALSE)
	user.setOxyLoss(target.getOxyLoss(), FALSE)
	user.setToxLoss(target.getToxLoss(), FALSE)
	user.setCloneLoss(target.getCloneLoss(), FALSE)
	user.setBrainLoss(target.getBrainLoss(), FALSE)
	user.setStaminaLoss(target.getStaminaLoss(), FALSE)
	user.updatehealth("health sharing")
	target.adjustBruteLoss(-target.getBruteLoss() + bruteloss, FALSE)
	target.adjustFireLoss(-target.getFireLoss() + fireloss, FALSE)
	target.setOxyLoss(oxyloss, FALSE)
	target.setToxLoss(toxloss, FALSE)
	target.setCloneLoss(cloneloss, FALSE)
	target.setBrainLoss(brainloss, FALSE)
	target.setStaminaLoss(staminaloss, FALSE)
	target.updatehealth("health sharing")

	target.flash_eyes()

