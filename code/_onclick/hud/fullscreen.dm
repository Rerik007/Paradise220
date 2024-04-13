/mob
	var/list/screens = list()

/mob/proc/overlay_fullscreen(category, type, severity)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if(!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, FALSE)
		screens[category] = screen = new type()
	else if((!severity || severity == screen.severity) && (!client || screen.screen_loc != "CENTER-7,CENTER-7" || screen.view == client.view))
		// doesn't need to be updated
		return screen

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity
	if(client && screen.should_show_to(src))
		screen.update_for_view(client.view)
		client.screen += screen

	if(screen.needs_offsetting)
		SET_PLANE_EXPLICIT(screen, PLANE_TO_TRUE(screen.plane), src)

	return screen


/mob/proc/clear_fullscreen(category, animated = 10)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, PROC_REF(clear_fullscreen_after_animate), screen), animated, TIMER_CLIENT_TIME)
	else
		if(client)
			client.screen -= screen
		qdel(screen)


/mob/proc/clear_fullscreen_after_animate(atom/movable/screen/fullscreen/screen)
	if(client)
		client.screen -= screen
	qdel(screen)


/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)


/datum/hud/proc/reload_fullscreen()
	if(mymob.client)
		var/atom/movable/screen/fullscreen/screen
		var/list/screens = mymob.screens
		for(var/category in screens)
			screen = screens[category]
			if(screen.should_show_to(mymob))
				screen.update_for_view(mymob.client.view)
				mymob.client.screen |= screen
			else
				mymob.client.screen -= screen

/mob/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	. = ..()
	if(!same_z_layer)
		relayer_fullscreens()

/mob/proc/relayer_fullscreens()
	var/turf/our_lad = get_turf(src)
	var/offset = GET_TURF_PLANE_OFFSET(our_lad)
	for(var/category in screens)
		var/atom/movable/screen/fullscreen/screen = screens[category]
		if(screen.needs_offsetting)
			screen.plane = GET_NEW_PLANE(initial(screen.plane), offset)

/atom/movable/screen/fullscreen
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/view = 7
	var/severity = 0
	var/show_when_dead = FALSE
	var/needs_offsetting = TRUE

/atom/movable/screen/fullscreen/proc/update_for_view(client_view)
	if (screen_loc == "CENTER-7,CENTER-7" && view != client_view)
		var/list/actualview = getviewsize(client_view)
		view = client_view
		transform = matrix(actualview[1]/FULLSCREEN_OVERLAY_RESOLUTION_X, 0, 0, 0, actualview[2]/FULLSCREEN_OVERLAY_RESOLUTION_Y, 0)

/atom/movable/screen/fullscreen/proc/should_show_to(mob/mymob)
	if(!show_when_dead && mymob.stat == DEAD)
		return FALSE
	return TRUE

/atom/movable/screen/fullscreen/Destroy()
	severity = 0
	return ..()

/atom/movable/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = UI_DAMAGE_LAYER

/atom/movable/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = UI_DAMAGE_LAYER

/atom/movable/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/atom/movable/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/impaired
	icon_state = "impairedoverlay"

/atom/movable/screen/fullscreen/flash
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/atom/movable/screen/fullscreen/flash/noise
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"

/atom/movable/screen/fullscreen/high
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"


/atom/movable/screen/fullscreen/payback
	icon_state = "payback"
	show_when_dead = TRUE


/atom/movable/screen/fullscreen/cinematic_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	plane = SPLASHSCREEN_PLANE
	layer = CINEMATIC_LAYER
	color = "#000000"
	show_when_dead = TRUE


/atom/movable/screen/fullscreen/lighting_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "flash"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	blend_mode = BLEND_OVERLAY
	show_when_dead = TRUE
	needs_offsetting = FALSE

//Provides darkness to the back of the lighting plane
/atom/movable/screen/fullscreen/lighting_backdrop/lit
	invisibility = INVISIBILITY_LIGHTING
	layer = BACKGROUND_LAYER+21
	color = "#000"

//Provides whiteness in case you don't see lights so everything is still visible
/atom/movable/screen/fullscreen/lighting_backdrop/unlit
	layer = BACKGROUND_LAYER+20

/atom/movable/screen/fullscreen/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	blend_mode = BLEND_ADD
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/fog
	icon = 'icons/mob/screen_fog.dmi'
	icon_state = "fog"
	color = "#FF0000"

/// An effect which tracks the cursor's location on the screen
/atom/movable/screen/fullscreen/cursor_catcher
	icon_state = "fullscreen_blocker" // Fullscreen semi transparent icon
	plane = HUD_PLANE
	mouse_opacity = MOUSE_OPACITY_ICON
	/// The mob whose cursor we are tracking.
	var/mob/owner
	/// Client view size of the scoping mob.
	var/list/view_list
	/// Pixel x we send to the scope component.
	var/given_x
	/// Pixel y we send to the scope component.
	var/given_y
	/// The turf we send to the scope component.
	var/turf/given_turf
	/// Mouse parameters, for calculation.
	var/mouse_params

/// Links this up with a mob
/atom/movable/screen/fullscreen/cursor_catcher/proc/assign_to_mob(mob/owner)
	src.owner = owner
	view_list = getviewsize(owner.client.view)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	calculate_params()

/// Update when the mob we're assigned to has moved
/atom/movable/screen/fullscreen/cursor_catcher/proc/on_move(atom/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(!given_turf)
		return
	var/x_offset = source.loc.x - oldloc.x
	var/y_offset = source.loc.y - oldloc.y
	given_turf = locate(given_turf.x + x_offset, given_turf.y + y_offset, given_turf.z)


/atom/movable/screen/fullscreen/cursor_catcher/MouseEntered(location, control, params)
	. = ..()
	MouseMove(location, control, params)
	if(usr == owner)
		calculate_params()

/atom/movable/screen/fullscreen/cursor_catcher/MouseMove(location, control, params)
	if(usr != owner)
		return
	mouse_params = params

/atom/movable/screen/fullscreen/cursor_catcher/proc/calculate_params()
	var/list/modifiers = params2list(mouse_params)
	var/icon_x = text2num(modifiers["icon-x"])
	var/icon_y = text2num(modifiers["icon-y"])
	var/our_x = round(icon_x / world.icon_size)
	var/our_y = round(icon_y / world.icon_size)
	given_turf = locate(owner.x + our_x - round(view_list[1] / 2), owner.y + our_y - round(view_list[2] / 2), owner.z)
	given_x = round(icon_x - world.icon_size * our_x, 1)
	given_y = round(icon_y - world.icon_size * our_y, 1)

#undef FULLSCREEN_LAYER
#undef BLIND_LAYER
#undef CRIT_LAYER
