/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	S["all_underwear"] >> pref.all_underwear
	S["all_underwear_metadata"] >> pref.all_underwear_metadata
	S["backbag"]	>> pref.backbag
	S["pdachoice"]	>> pref.pdachoice
	S["communicator_visibility"]	>> pref.communicator_visibility
	S["ringtone"]	>> pref.ringtone

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	S["all_underwear"] << pref.all_underwear
	S["all_underwear_metadata"] << pref.all_underwear_metadata
	S["backbag"]	<< pref.backbag
	S["pdachoice"]	<< pref.pdachoice
	S["communicator_visibility"]	<< pref.communicator_visibility
	S["ringtone"]	<< pref.ringtone

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/equipment/copy_to_mob(var/mob/living/carbon/human/character)
	character.all_underwear.Cut()
	character.all_underwear_metadata.Cut()

	for(var/underwear_category_name in pref.all_underwear)
		var/datum/category_group/underwear/underwear_category = GLOB.global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = pref.all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
			if(pref.all_underwear_metadata[underwear_category_name])
				character.all_underwear_metadata[underwear_category_name] = pref.all_underwear_metadata[underwear_category_name]
		else
			pref.all_underwear -= underwear_category_name

	// TODO - Looks like this is duplicating the work of sanitize_character() if so, remove
	if(pref.backbag > 5 || pref.backbag < 1)
		pref.backbag = 1 //Same as above
	character.backbag = pref.backbag

	if(pref.pdachoice > 5 || pref.pdachoice < 1)
		pref.pdachoice = 1
	character.pdachoice = pref.pdachoice

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	if(!islist(pref.gear)) pref.gear = list()

	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in GLOB.global_underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.identifying_gender ? pref.identifying_gender : MALE))
					pref.all_underwear[WRC.name] = WRI.name
					break

	if(!istype(pref.all_underwear_metadata))
		pref.all_underwear_metadata = list()

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = GLOB.global_underwear.categories_by_name[underwear_category]
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[pref.all_underwear[underwear_category]]
			if(!UWI)
				pref.all_underwear -= underwear_category

	for(var/underwear_metadata in pref.all_underwear_metadata)
		if(!(underwear_metadata in pref.all_underwear))
			pref.all_underwear_metadata -= underwear_metadata
	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))
	pref.pdachoice	= sanitize_integer(pref.pdachoice, 1, pdachoicelist.len, initial(pref.pdachoice))
	pref.ringtone	= sanitize(pref.ringtone, 20)

/datum/category_item/player_setup_item/general/equipment/content()
	. = list()
	. += "<b>Equipment:</b><br>"
	for(var/datum/category_group/underwear/UWC in GLOB.global_underwear.categories)
		var/item_name = pref.all_underwear[UWC.name] ? pref.all_underwear[UWC.name] : "None"
		. += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a>"
		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				. += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_metadata(UWC.name, gt))]</a>"

		. += "<br>"
	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"
	. += "PDA Type: <a href='?src=\ref[src];change_pda=1'><b>[pdachoicelist[pref.pdachoice]]</b></a><br>"
	. += "Communicator Visibility: <a href='?src=\ref[src];toggle_comm_visibility=1'><b>[(pref.communicator_visibility) ? "Yes" : "No"]</b></a><br>"
	. += "Ringtone (leave blank for job default): <a href='?src=\ref[src];set_ringtone=1'><b>[pref.ringtone]</b></a><br>"

	return jointext(.,null)

/datum/category_item/player_setup_item/general/equipment/proc/get_metadata(var/underwear_category, var/datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/general/equipment/proc/set_metadata(var/underwear_category, var/datum/gear_tweak/gt, var/new_metadata)
	var/list/metadata = pref.all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata


/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference", backbaglist[pref.backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_pda"])
		var/new_pdachoice = input(user, "Choose your character's style of PDA:", "Character Preference", pdachoicelist[pref.pdachoice]) as null|anything in pdachoicelist
		if(!isnull(new_pdachoice) && CanUseTopic(user))
			pref.pdachoice = pdachoicelist.Find(new_pdachoice)
			return TOPIC_REFRESH

	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = GLOB.global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return
		var/datum/category_item/underwear/selected_underwear = input(user, "Choose underwear:", "Character Preference", pref.all_underwear[UWC.name]) as null|anything in UWC.items
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear[UWC.name] = selected_underwear.name
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["underwear"] && href_list["tweak"])
		var/underwear = href_list["underwear"]
		if(!(underwear in pref.all_underwear))
			return TOPIC_NOACTION
		var/datum/gear_tweak/gt = locate(href_list["tweak"])
		if(!gt)
			return TOPIC_NOACTION
		var/new_metadata = gt.get_metadata(usr, get_metadata(underwear, gt))
		if(new_metadata)
			set_metadata(underwear, gt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["toggle_comm_visibility"])
		if(CanUseTopic(user))
			pref.communicator_visibility = !pref.communicator_visibility
			return TOPIC_REFRESH
	else if(href_list["set_ringtone"])
		if(CanUseTopic(user))
			pref.ringtone = sanitize(input(user, "Please enter a new ringtone.", "Character Preference") as null|text, 20)
			return TOPIC_REFRESH

	return ..()