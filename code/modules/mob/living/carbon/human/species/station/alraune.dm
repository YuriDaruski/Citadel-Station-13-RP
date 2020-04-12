/datum/species/alraune
	name = SPECIES_ALRAUNE
	name_plural = "Alraunes"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	num_alternate_languages = 3 //cit lore change
	slowdown = 1 //slow, they're plants. Not as slow as full diona.
	total_health = 100 //standard
	brute_mod = 1 //nothing special
	burn_mod = 1.5 //plants don't like fire
	radiation_mod = 0.7 //cit change: plants seem to be pretty resilient. shouldn't come up much.
	metabolic_rate = 0.75 // slow metabolism
	item_slowdown_mod = 0.25 //while they start slow, they don't get much slower
	bloodloss_rate = 0.1 //While they do bleed, they bleed out VERY slowly
	min_age = 18
	max_age = 500 //cit lore change
	health_hud_intensity = 1.5
	base_species = SPECIES_ALRAUNE
	selects_bodytype = TRUE

	body_temperature = T20C
	breath_type = "carbon_dioxide"
	poison_type = "phoron"
	exhale_type = "oxygen"

	// Heat and cold resistances are 20 degrees broader on the level 1 range, level 2 is default, level 3 is much weaker, halfway between L2 and normal L3.
	// Essentially, they can tolerate a broader range of comfortable temperatures, but suffer more at extremes.
	cold_level_1 = 240 //Default 260 - Lower is better
	cold_level_2 = 200 //Default 200
	cold_level_3 = 160 //Default 120
	cold_discomfort_level = 260	//they start feeling uncomfortable around the point where humans take damage

	heat_level_1 = 380 //Default 360 - Higher is better
	heat_level_2 = 400 //Default 400
	heat_level_3 = 700 //Default 1000
	heat_discomfort_level = 360

	breath_cold_level_1 = 240 //They don't have lungs, they breathe through their skin
	breath_cold_level_2 = 180 //sadly for them, their breath tolerance is no better than anyone else's.
	breath_cold_level_3 = 140 //mainly 'cause breath tolerance is more generous than body temp tolerance.

	breath_heat_level_1 = 400 //slightly better heat tolerance in air though. Slightly.
	breath_heat_level_2 = 450
	breath_heat_level_3 = 800 //lower incineration threshold though

	spawn_flags = SPECIES_CAN_JOIN
	flags = NO_SCAN | IS_PLANT | NO_MINOR_CUT
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	inherent_verbs = list(
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/carbon/human/proc/alraune_fruit_select,
		/mob/living/carbon/human/proc/tie_hair
		) //Give them the voremodes related to wrapping people in vines and sapping their fluids

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	flesh_color = "#9ee02c"
	blood_color = "#edf4d0" //sap!
	base_color = "#1a5600"

	reagent_tag = IS_ALRAUNE

	blurb = "Alraunes are an uncommon sight in space. Their bodies are reminiscent of that of plants, and yet they share many\
	traits with other humanoid beings, occasionally mimicking their forms to lure in prey.\
	\
	Most Alraune are rather opportunistic in nature, being primarily self-serving; however, this does not mean they are selfish or unable to empathise with others.\
	\
	They are highly adaptable both mentally and physically, but tend to have a collecting intra-species mindset."

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/plant),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/plant),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/plant),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/plant),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/plant),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/plant),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/plant),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/plant),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/plant),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/plant),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/plant) //cit change - unbreakable, can survive decapitation, but damage spreads to nearby neighbors when at max dmg.
		)

	// limited organs, 'cause they're simple
	has_organ = list(
		O_LIVER =    /obj/item/organ/internal/liver/alraune,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys/alraune,
		O_BRAIN =    /obj/item/organ/internal/brain/alraune,
		O_EYES =     /obj/item/organ/internal/eyes/alraune,
		A_FRUIT =    /obj/item/organ/internal/fruitgland,
		)

/datum/species/alraune/can_breathe_water()
	return TRUE //eh, why not? Aquatic plants are a thing.


/datum/species/alraune/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.inStasisNow()) // if they're in stasis, they won't need this stuff.
		return

	//setting these here 'cause ugh the defines for life are in the wrong place to compile properly
	//set them back to HUMAN_MAX_OXYLOSS if we move the life defines to the defines folder at any point
	var/ALRAUNE_MAX_OXYLOSS = 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
	var/ALRAUNE_CRIT_MAX_OXYLOSS = ( 2.0 / 6) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 4 ticks. last_tick_duration = ~2.0 on average

	//They don't have lungs so breathe() will just return. Instead, they breathe through their skin.
	//This is mostly normal breath code with some tweaks that apply to their particular biology.

	var/datum/gas_mixture/breath = null
	var/fullysealed = FALSE //if they're wearing a fully sealed suit, their internals take priority.
	var/environmentalair = FALSE //if no sealed suit, internals take priority in low pressure environements

	if(H.wear_suit && (H.wear_suit.min_pressure_protection = 0) && H.head && (H.head.min_pressure_protection = 0))
		fullysealed = TRUE
	else // find out if local gas mixture is enough to override use of internals
		var/datum/gas_mixture/environment = H.loc.return_air()
		var/envpressure = environment.return_pressure()
		if(envpressure >= hazard_low_pressure)
			environmentalair = TRUE

	if(fullysealed || !environmentalair)
		breath = H.get_breath_from_internal()

	if(!breath) //No breath from internals so let's try to get air from our location
		// cut-down version of get_breath_from_environment - notably, gas masks provide no benefit
		var/datum/gas_mixture/environment2
		if(H.loc)
			environment2 = H.loc.return_air_for_internal_lifeform(H)

		if(environment2)
			breath = environment2.remove_volume(BREATH_VOLUME)
			H.handle_chemical_smoke(environment2) //handle chemical smoke while we're at it

	// NOW a crude copypasta of handle_breath. Leaving some things out that don't apply to plants.
	if(H.does_not_breathe)
		H.failed_last_breath = 0
		H.adjustOxyLoss(-5)
		return // if somehow they don't breathe, abort breathing.

	if(!breath || (breath.total_moles == 0))
		H.failed_last_breath = 1
		if(H.health > config_legacy.health_threshold_crit)
			H.adjustOxyLoss(ALRAUNE_MAX_OXYLOSS)
		else
			H.adjustOxyLoss(ALRAUNE_CRIT_MAX_OXYLOSS)

		H.oxygen_alert = max(H.oxygen_alert, 1)

		return // skip air processing if there's no air

	// now into the good stuff

	//var/safe_pressure_min = species.minimum_breath_pressure // Minimum safe partial pressure of breathable gas in kPa
	//just replace safe_pressure_min with minimum_breath_pressure, no need to declare a new var

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/inhaled_gas_used = 0

	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	var/inhaling
	var/poison
	var/exhaling

	var/failed_inhale = 0
	var/failed_exhale = 0

	inhaling = breath.gas[breath_type]
	poison = breath.gas[poison_type]
	exhaling = breath.gas[exhale_type]

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	// Not enough to breathe
	if((inhale_pp + exhaled_pp) < minimum_breath_pressure) //they can breathe either oxygen OR CO2
		if(prob(20))
			spawn(0) H.emote("gasp")

		var/ratio = (inhale_pp + exhaled_pp)/minimum_breath_pressure
		// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS (1) after all!)
		H.adjustOxyLoss(max(ALRAUNE_MAX_OXYLOSS*(1-ratio), 0))
		failed_inhale = 1

		H.oxygen_alert = max(H.oxygen_alert, 1)
	else
		// We're in safe limits
		H.oxygen_alert = 0

	inhaled_gas_used = inhaling/6
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards
	breath.adjust_gas_temp(exhale_type, inhaled_gas_used, H.bodytemperature, update = 0) //update afterwards

	//Now we handle CO2.
	if(inhale_pp > safe_exhaled_max * 0.7) // For a human, this would be too much exhaled gas in the air. But plants don't care.
		H.co2_alert = 1 // Give them the alert on the HUD. They'll be aware when the good stuff is present.

	else
		H.co2_alert = 0

	//do the CO2 buff stuff here

	var/co2buff = 0
	if(inhaling)
		co2buff = (CLAMP(inhale_pp, 0, minimum_breath_pressure))/minimum_breath_pressure //returns a value between 0 and 1.

	var/light_amount = fullysealed ? H.getlightlevel() : H.getlightlevel()/5 // if they're covered, they're not going to get much light on them.

	if(co2buff && !H.toxloss && light_amount >= 0.1) //if there's enough light and CO2 and you're not poisoned, heal. Note if you're wearing a sealed suit your heal rate will suck.
		H.adjustBruteLoss(-(light_amount * co2buff * 2)) //at a full partial pressure of CO2 and full light, you'll only heal half as fast as diona.
		H.adjustFireLoss(-(light_amount * co2buff)) //this won't let you tank environmental damage from fire. MAYBE cold until your body temp drops.

	if(H.nutrition < (200 + 400*co2buff)) //if no CO2, a fully lit tile gives them 1/tick up to 200. With CO2, potentially up to 600.
		H.nutrition += (light_amount*(1+co2buff*5))

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(H.reagents)
			H.reagents.add_reagent("toxin", CLAMP(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
			breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		H.phoron_alert = max(H.phoron_alert, 1)
	else
		H.phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas["sleeping_agent"])
		var/SA_pp = (breath.gas["sleeping_agent"] / breath.total_moles) * breath_pressure

		// Enough to make us paralysed for a bit
		if(SA_pp > SA_para_min)

			// 3 gives them one second to wake up and run away a bit!
			H.Paralyse(3)

			// Enough to make us sleep as well
			if(SA_pp > SA_sleep_min)
				H.Sleeping(5)

		// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
		else if(SA_pp > 0.15)
			if(prob(20))
				spawn(0) H.emote(pick("giggle", "laugh"))
		breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"]/6, update = 0) //update after

	// Were we able to breathe?
	if (failed_inhale || failed_exhale)
		H.failed_last_breath = 1
	else
		H.failed_last_breath = 0
		H.adjustOxyLoss(-5)


	// Hot air hurts :(
	if((breath.temperature < breath_cold_level_1 || breath.temperature > breath_heat_level_1) && !(COLD_RESISTANCE in H.mutations))

		if(breath.temperature <= breath_cold_level_1)
			if(prob(20))
				to_chat(H, "<span class='danger'>You feel icicles forming on your skin!</span>")
		else if(breath.temperature >= breath_heat_level_1)
			if(prob(20))
				to_chat(H, "<span class='danger'>You feel yourself smouldering in the heat!</span>")

		var/bodypart = pick(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
		if(breath.temperature >= breath_heat_level_1)
			if(breath.temperature < breath_heat_level_2)
				H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, bodypart, used_weapon = "Excessive Heat")
				H.fire_alert = max(H.fire_alert, 2)
			else if(breath.temperature < breath_heat_level_3)
				H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, bodypart, used_weapon = "Excessive Heat")
				H.fire_alert = max(H.fire_alert, 2)
			else
				H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, bodypart, used_weapon = "Excessive Heat")
				H.fire_alert = max(H.fire_alert, 2)

		else if(breath.temperature <= breath_cold_level_1)
			if(breath.temperature > breath_cold_level_2)
				H.apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, bodypart, used_weapon = "Excessive Cold")
				H.fire_alert = max(H.fire_alert, 1)
			else if(breath.temperature > breath_cold_level_3)
				H.apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, bodypart, used_weapon = "Excessive Cold")
				H.fire_alert = max(H.fire_alert, 1)
			else
				H.apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, bodypart, used_weapon = "Excessive Cold")
				H.fire_alert = max(H.fire_alert, 1)


		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - H.bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
		//world << "Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]"
		H.bodytemperature += temp_adj

	else if(breath.temperature >= heat_discomfort_level)
		get_environment_discomfort(src,"heat")
	else if(breath.temperature <= cold_discomfort_level)
		get_environment_discomfort(src,"cold")

	breath.update_values()
	return 1

/obj/item/organ/internal/brain/alraune
	icon = 'icons/mob/species/alraune/organs.dmi'
	icon_state = "neurostroma"
	name = "neuro-stroma"
	desc = "A knot of fibrous plant matter."
	parent_organ = BP_TORSO // brains in their core

/obj/item/organ/internal/eyes/alraune
	icon = 'icons/mob/species/alraune/organs.dmi'
	icon_state = "photoreceptors"
	name = "photoreceptors"
	desc = "Bulbous and fleshy plant matter."

/obj/item/organ/internal/kidneys/alraune
	icon = 'icons/mob/species/alraune/organs.dmi'
	icon_state = "rhyzofilter"
	name = "rhyzofilter"
	desc = "A tangle of root nodules."

/obj/item/organ/internal/liver/alraune
	icon = 'icons/mob/species/alraune/organs.dmi'
	icon_state = "phytoextractor"
	name = "enzoretector"
	desc = "A bulbous gourd-like structure."

//Begin fruit gland and its code.
/obj/item/organ/internal/fruitgland //Amazing name, I know.
	icon = 'icons/mob/species/alraune/organs.dmi'
	icon_state = "phytoextractor"
	name = "fruit gland"
	desc = "A bulbous gourd-like structure."
	organ_tag = A_FRUIT
	var/generated_reagents = list("sugar" = 2) //This actually allows them. This could be anything, but sugar seems most fitting.
	var/usable_volume = 250 //Five fruit.
	var/transfer_amount = 50
	var/empty_message = list("Your have no fruit on you.", "You have a distinct lack of fruit..")
	var/full_message = list("You have a multitude of fruit that is ready for harvest!", "You have fruit that is ready to be picked!")
	var/emote_descriptor = list("fruit right off of the Alraune!", "a fruit from the Alraune!")
	var/verb_descriptor = list("grabs", "snatches", "picks")
	var/self_verb_descriptor = list("grab", "snatch", "pick")
	var/short_emote_descriptor = list("picks", "grabs")
	var/self_emote_descriptor = list("grab", "pick", "snatch")
	var/fruit_type = "apple"
	var/mob/organ_owner = null
	var/gen_cost = 0.5

/obj/item/organ/internal/fruitgland/New()
	..()
	create_reagents(usable_volume)


/obj/item/organ/internal/fruitgland/process()
	if(!owner) return
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	var/before_gen
	if(parent && generated_reagents && organ_owner) //Is it in the chest/an organ, has reagents, and is 'activated'
		before_gen = reagents.total_volume
		if(reagents.total_volume < reagents.maximum_volume)
			if(organ_owner.nutrition >= gen_cost)
				do_generation()

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(organ_owner, "<span class='notice'>[pick(empty_message)]</span>")
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(organ_owner, "<span class='warning'>[pick(full_message)]</span>")

/obj/item/organ/internal/fruitgland/proc/do_generation()
	organ_owner.nutrition -= gen_cost
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])


/mob/living/carbon/human/proc/alraune_fruit_select() //So if someone doesn't want fruit/vegetables, they don't have to select one.
	set name = "Select Fruit"
	set desc = "Select what fruit/vegetable you wish to grow."
	set category = "Abilities"
	var/obj/item/organ/internal/fruitgland/fruit_gland
	for(var/F in contents)
		if(istype(F, /obj/item/organ/internal/fruitgland))
			fruit_gland = F
			break

	if(fruit_gland)
		var/selection = input(src, "Choose your character's fruit type. Choosing nothing will result in a default of apples.", "Fruit Type", fruit_gland.fruit_type) as null|anything in acceptable_fruit_types
		if(selection)
			fruit_gland.fruit_type = selection
		verbs |= /mob/living/carbon/human/proc/alraune_fruit_pick
		verbs -= /mob/living/carbon/human/proc/alraune_fruit_select
		fruit_gland.organ_owner = src
		fruit_gland.emote_descriptor = list("fruit right off of [fruit_gland.organ_owner]!", "a fruit from [fruit_gland.organ_owner]!")

	else
		to_chat(src, "<span class='notice'>You lack the organ required to produce fruit.</span>")
		return

/mob/living/carbon/human/proc/alraune_fruit_pick()
	set name = "Pick Fruit"
	set desc = "Pick fruit off of [src]."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/organ/internal/fruitgland/fruit_gland
	for(var/I in contents)
		if(istype(I, /obj/item/organ/internal/fruitgland))
			fruit_gland = I
			break
	if (fruit_gland) //Do they have the gland?
		if(fruit_gland.reagents.total_volume < fruit_gland.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(fruit_gland.empty_message)]</span>")
			return

		var/datum/seed/S = plant_controller.seeds["[fruit_gland.fruit_type]"]
		S.harvest(usr,0,0,1)

		var/index = rand(0,2)

		if (usr != src)
			var/emote = fruit_gland.emote_descriptor[index]
			var/verb_desc = fruit_gland.verb_descriptor[index]
			var/self_verb_desc = fruit_gland.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] [pick(fruit_gland.short_emote_descriptor)] a fruit.</span>",
								"<span class='notice'>You [pick(fruit_gland.self_emote_descriptor)] a fruit.</span>")

		fruit_gland.reagents.remove_any(fruit_gland.transfer_amount)

//End of fruit gland code.

/datum/species/alraune/proc/produceCopy(var/datum/species/to_copy,var/list/traits,var/mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = all_species[to_copy]

	var/datum/species/alraune/new_copy = new()

	//Initials so it works with a simple path passed, or an instance
	new_copy.base_species = to_copy.name
	new_copy.icobase = to_copy.icobase
	new_copy.deform = to_copy.deform
	new_copy.tail = to_copy.tail
	new_copy.tail_animation = to_copy.tail_animation
	new_copy.icobase_tail = to_copy.icobase_tail
	new_copy.color_mult = to_copy.color_mult
	new_copy.primitive_form = to_copy.primitive_form
	new_copy.appearance_flags = to_copy.appearance_flags
	new_copy.flesh_color = to_copy.flesh_color
	new_copy.base_color = to_copy.base_color
	new_copy.blood_mask = to_copy.blood_mask
	new_copy.damage_mask = to_copy.damage_mask
	new_copy.damage_overlays = to_copy.damage_overlays

	//Set up a mob
	H.species = new_copy
	H.icon_state = lowertext(new_copy.get_bodytype())

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy

/datum/species/alraune/get_bodytype()
	return base_species

/datum/species/alraune/get_race_key()
	var/datum/species/real = all_species[base_species]
	return real.race_key
