# Anomalies of the Commonwealth


## Infos
|  |  |
|--|--|
| ESP name | AnomaliesOfTheCommonwealth.esp |
| Dependency | Fallout4.esm |
| Savegame | supported(?) |


## Debugging
	
1. Release file lock: `fcf`  
	(You can save ESP in CK now)
2. Reload ESP after saving in CK: `hlp AnomaliesOfTheCommonwealth.esp`  
3. Changed papyrus scripts: `reloadscript`

1. `coc aotcSidorovichBunker`

## What is an anomaly?

We are going to implement the Springboard anomaly.
The model itself is a water droplet effect that is looped for eternity.
When you approach it, a secondary alert sound plays, not the radiation but a high pitched beep.
But this beep only sounds when the player has a pip-boy.
When you approach it further, an image space effect plays for the player, making it more grainy and brighter.
When you're too close, the anomaly has a wind-type explosion and sound. 
This effect decreases the player's healt by some percent.
If you throw an unimportant thing in it, same explosion and it disappears.
If a creature dies in the anomaly, it later explodes into gibs but those won't interact with the anomaly anymore.
The anomaly is surrounded by leaves or dust particles.

## TODOs

1. Must-have before moving on:  
	**[PENDING]** fix everything at its current state  
	[SCRAPPED] create ash-pile after killing the player (easiest way to hide them)  
	[DOESNT WORK] try move player: player.ApplyHavokImpulse()  
	**[DONE]** try to explode player: player.Dismember()  
	**[DONE]** try this for finding closest anomalies: .FindAllReferencesOfType(anomaly, radius)  
	**[DONE]** add a blast pit under the anomaly  
	[DOESNT WORK] change to 3rd person when killing the player  
	[DOESNT WORK] switch to ragdoll when player is sucked in  
	FXBitsDebrisLeaves01 for effect instead of the white thingy
2. **[DONE]** move proximity sound script to player  
	give the script an input array of all the anomalies  
	calculate the closest one to the player  
	this way only one beeping will be played  
	(alternative ugly but faster):  
			keep a global 'distance' variable that everyone reads and writes
			if the current anomaly scripts sees that their own distance is closer or equal,play sound,
			otherwise, don't play a sound
			problem: if you're very far from the anomaly, the distances won't compare effectively
3. place anomalies in the commonwealth randomly  
	we need a script that manages this behavior: create an empty quest  
	find a way to safely place objects randomly on the ground: not too feasible  
	or just place them by hand so it's gonna be extra compatible  
4. **[WiP]** make the anomalies react to other NPC-s  
	instead of player, check for any creature that is too close to the anomalies  
	ugly hack: make npcs avoid the anomaly so that we don't have to do the hard work  
	quick test:  
	`placeatme abbot`  
	`setrelationshiprank player 4`  
	`setplayerteammate 1`  
5. make the anomalies react to something that the player throws  
	try this for throwing an object into the anomaly: OnGrab / OnRelease  
6. be surprised at first looking at an anomaly: .Say()  
7. Add Sidorovich to the weird looking cars and trees  
	Optionally remove the rad scorpions  
	Create the cellar of sidorovich  
	Create sidorovich as a speaking actor, voice lines, missions, etc.  

TODOs:
* [SKIPPED] Use SubDoor01Left instead of the white submarine door? --> NO, because the wall plug is not suitable :(
* [DONE] SaugusSmokeMirageFX for gravity anomaly --> too slow, too big
* [DONE] Sparks01SaugusFoundry --> for fire anomaly
* [DONE] npc.PushActorAway(npc, 0) for enabling ragdoll (or just force ragdoll phy)
* [DONE] add flames to the anomaly: FlameThrowerProjectileSprayVaporizer01.nif
* [DONE] FXSmokeStackSteam02Half for flame
* Clean-up scripts where we use PlaceAt but dont delete later
* Add a flag for the anomalies so that NPCs try to avoid it instead of running into them
* create vis and mesh precombines for all modified cells if neccessary

Sidorovich voice lines

Badbye\trader_script1b_1: go on, get out of my sight
Badbye\trader_script1b_2: dont just stand there like an idiot, give me what you got and scram
Badbye\trader_script1b_3: are you drunk or something
Badbye\trader_script1b_4: did you dose off or something
Badbye\trader_script1b_5: whats with you today ?
Badbye\trader_script1b_6: get lost, marked one
Badbye\trader_tutorial_rejection_3: okay thats it, go now

BadLoot\trader_script1c_6: ah man dog food is more valuable than this
BadLoot\trader_script1c_7: what the heck are you bringing me in all this crap for?
BadLoot\trader_script1c_8: what is this shit ?
BadLoot\trader_script1c_9: did i not make myself clear ? i need real stuff

Goodbye\esc_trader_bye_1: good luck
Goodbye\esc_trader_bye_2: see you around ! hopefully
Goodbye\esc_trader_bye_3: well, take care !
Goodbye\esc_trader_bye_5: well, good hunting stalker
Goodbye\trader3c: good hunting stalker

GoodbyeObject\esc_trader_bye_give_habar: hey ! where are you going ? give me the case
GoodbyeObject\esc_trader_bye_habar_1: hurry up with that case, alright ?
GoodbyeObject\esc_trader_bye_habar_2: bring me that case as soon as you find it
GoodbyeObject\esc_trader_bye_habar_3: dont forget, i still need that case
GoodbyeObject\trader3a: where are you going without a weapon, retard !

GoodLoot\trader_script1c_1: not bad, some pretty good stuff youve got there
GoodLoot\trader_script1c_2: alright, well, drop by if you get anymore
GoodLoot\trader_script1c_3: thats my boy ! you made my day
GoodLoot\trader_script1c_4: now thats the way to go

GreetAgain\trader_script1a_1: well, hello there
GreetAgain\trader_script1a_2: so youre back
GreetAgain\trader_script1a_3: you got the loot ?
GreetAgain\trader_script1a_4: got anything valuable ?
GreetAgain\trader_script1a_5: what have you got here ?
GreetAgain\trader_script1a_6: how is it going stalker
GreetAgain\trader3b: hey ! come over here ! i give you a few things

Greeting\esc_trader_greet_1: got anything good ?
Greeting\esc_trader_greet_2: how is it going ?
Greeting\esc_trader_greet_3: well, hello there
Greeting\esc_trader_greet_4: whats you got in there
Greeting\esc_trader_greet_first: ni- nice to see you. so. shall we talk business ?
Greeting\esc_trader_meet_11: hello merc ! tell me ! what brings you here ?
Greeting\esc_trader_meet_1111: 
	hmm. i see so many stalkers in the area its a pain to remember them all. 
	any reason i should strain my brain for you ?

GreetingObject\esc_trader_greet_habar: so you got it after all ! i know i could count on you
GreetingObject\esc_trader_meet_22: 
	thanks for returning the case merc. now i can settle up with my client.
	reason ive survived in the zone as long as i have is that i always keep my word.
	you screw a client in this place and you are pretty likely to find a knife in your back real soon.
	anyway. enough about me. about your stalker. he was here. his name is Fang and he was looking for tube amplifiers
	and some other electronic crap and im not an expert in that sort of thing.
	i sold them the amp but i didnt have the other stuff he was after so i told them to visit the dig that is at the garbage
	recently some stalkers at the garbage have dug up whole buried equipment from after the accident at the Chernobyl NPP
	and now the place is filled with all kinds of ancient components. look for them there.
	and remember if you want to trade im your man.
GreetingObject\esc_trader_meet_44: hey merc ! im still waiting on that case

Idle\esc_trader_meet_55: so what are you after ?
Idle\esc_trader_wait_1: dont just stand there, eh ?
Idle\esc_trader_wait_2: come on ! tell me what you got for me !
Idle\esc_trader_wait_3: relax. dont be shy. what brings you here ?
Idle\esc_trader_wait_4: hello ! anyone home ?
Idle\trader1b: what are you standing there for ? come closer ! i dont bite

IdleObject\esc_trader_habar_greet_1: got any news about that thing we talked about ?
IdleObject\esc_trader_habar_greet_2: got that case for me ?
IdleObject\esc_trader_habar_greet_3: how is that case business going along ?
IdleObject\esc_trader_habar_request: okay merc, ill be waiting for you, and the case.

ShootAt\trader_tutorial_rejection_5: marked one ! what the hell ?

escape_trader_jobs_6: 
	listen, marked one ! ive done some thinking and heres what id like to offer. 
	generally speaking what you really need is to find strelok, right ?
escape_trader_jobs_611:
	anyway, heres the thing about strelok. theres a stalker that goes by this name.
	they say hes found a path to the northern reaches of the zone.
	that is a virgin area, real goldmine for artifacts, yeah.
	anyway, i can help you find him. however as you can imagine it wont be a free ride.
	you will have to work it off. but in the long run well both benefit.
	youre going to waste that strelok fellow and find what happened to you and ill find...
	well i mean ill get my share of our mutual profit.
	so what do you say? deal?
escape_trader_jobs_61111: 
	alright, listen. you mean business, i can see that. i mean we need guys like you.
	were doing sorta investigation with some other traders. 
	we want to open up a path to the north to the center of the zone.
	and here in the center something or someone is trying to hamper our progress.
	how the heck this strelok managed to sneak through i dont know.
	you see theres this one area where your brain starts boiling.
	an eerie place. anyway. to cut a long story short a couple of guys have been spying on those grunts for me 
	not far from here. apparently the ones at the aggroprom research institute have dug up something.
	something major. im positive is has to do something with the center of the zone. 
	anyway, whatever theyve dug up its secured somewhere in the third floor of the intitute. 
	and we really need this stuff. you know what i mean ?
escape_trader_jobs_6111111:
	once you have the briefcase, dont bring it here. take it straight to the barman. 
	he runs the stalker bar at 100 rads. i upload the coordinates and all the data you need to your pda. clear?
escape_trader_jobs_611111111:
	youll need to go north to the garbage then turn west. youll end up at the aggroprom research institute after a few kilometers.
	and be careful. the radiation level is way too high at the garbage. so i suggest you invest in some antirad or some vodka.
	well, good luck.
escape_trader_start_dialog_111:
	got a job for you, marked one. i want you to find this stalker called nimble. 
	he was carrying some very important information. he disappeared somwehere near the bridge.
	find him. dead or alive, i dont care. i need the flash drive with the info. 
	visit wolf from the local camp and ask him. he certainly knows where that guy can be. 
escape_trader_start_dialog_3:
	the choice is yours. either i brainwash you like i usually do with all the rookies 
	or i treat you like a real stalker and i give you a mission straight away.
esc_trader_about_other_1: 
	let me explain this again for you. 
	you bring me the loot stalkers that the military are squabbling over and i answer all your questions.
esc_trader_call:
	-radio-
esc_trader_meet_111111:
	now were talking business, i like that. heres the thing. ive been here for a while. 
	my business is up and running. i get different orders here and there and people trust me.
	i have a problem with my last order. and the trouble is that the client is very important.
	the loot hes after is unique. everything was going fine. 
	stalkers would get the loot from inside the zone and the army boys were supposed to get it through the cordon.
	well the two parties started beakering over something and now the whole place gone crazy.
	result is, the stalkers are fighting the military and nobodys got a clue where the loot is.
	and that doesnt suit me at all because the order needs to be completed. 
	so. help me get the case with the loot and i tell all about your stalker and his components.
	deal?
esc_trader_meet_11111111:
	visit the stalkers by the enbankment. they set up some sort of base there 
	and thats where theyre holding captive military commander kolletsky.
	i dont care what you do with that base. i dont care if those fruitcakes want to continue playing modern robin hood's merry men.
	all i want is that case the loot thats inside it. for starters, try talking to valarian, the stalker leader. 
	ill let them know youre coming on my behalf.
esc_trader_meet_2222:
	if you need anything else, youre always welcome here. 
	im extending you a lifetime store discount for helping me deal with the military.
esc_trader_start_pda:
	-radio-
trader_dialog1:
	-radio-
trader_monolog1:
	so marked one i saved you. and im not going to pretend i did it to win favors upstairs. 
	you do some jobs for me, and were even. besides, keeping you busy might be a good way to deal with your amnesia.
	and ill see what i can find out about your problem. 
	i dont give a shit why you want to find this strelok guy and i mind my own business.
	if you want to kill him, hell, you must have your reasons.
trader_monolog2:
	okay. so i learned a few things about strelok. he was a stalker. they say he found a way to the northern part of the zone.
	id love to know how we got there because those parts are virgin and rich with artifacts.
	anyway. me and the other traders will help you find him and then maybe youll find that hidden path. 
	it would be good for all of us. youll finish strelok and well explore the way up north. 
	im sure its risky as hell but as they say no pain no gain. 
trader_pda_1:
	-radio-
trader_pda_fox:
	-radio-
trader_tutorial_anomalies_1:
	-radio-
trader_tutorial_binocular:
	yeah, marked one. dont forget to use the binoculars. they will help you see enemies before they see you. 
	and also avoid getting deep in shit. its got a built in target indicator. 
	the highlighting colors match those on the visor. red is the enemy, yellow means netural, green is a friend.
	thats it. good luck.
trader_tutorial_pda_1:
	this is your personal pda. this useful device will help you survive in the zone. 
	and if you do die, others will know where and how. 
	haha. just kidding. here. let me remind you how to use it.
trader_tutorial_pda_11:
	the contact section contains a list of stalkers within 50 meters of you.
	you can see a brief description, rank, group allegiations and probable attitude towards you here.
	remember that while youre neutral the way other stalker feel towards you depends on you alone.
	note how someones attitude changes when you help them.
trader_tutorial_pda_12:
	be careful if enemies are around. theyre marked red on the visor. 
	friends are green and neutrals are yellow.
	oh and pdas of dead stalkers are grey. help if youre into looting corpses.
	what else. oh yeah theres a diary too.
trader_tutorial_pda_13:
	well. uhh. what is that to say about it.
	all the information you need is noted in the journal. 
	and news too. even what im telling you right now can be found in this section.
	then theres a rating section.
trader_tutorial_pda_14:
	you can see the top 20 stalkers i know. i refresh this info from time to time 
	to keep up the competitive spritit. haha.
	maybe youll be at the top of this list some day. who knows.
	your own achivements are noted in the stats section.
trader_tutorial_pda_14_1:
	its pretty much self explanatory.
	and then we have the encyclopedia.
trader_tutorial_pda_15:
	it contains information about the zone
	and survival advice which you find or are given by other stalkers.
	thats basically it, i think.
trader_tutorial_pda_15_1:
	oh, one more thing. your pda model has a wide frequency radio wave scanner with an inbuilt encoder. 
	its radius of operation is about 400 meters. so you can even enter submilitary comms. 
	mine has a working radius of 30 kilometers. so i can always get in touch with you.
	ill give you the tasks and the latest news. initially ill give you advice too. 
	so. is everything clear or should i repeat?
trader_tutorial_pda_2:
	your tasks can be found in the first section of the pda.
trader_tutorial_pda_3:
	most tasks have buttons which allow you to access additional information on the task.
trader_tutorial_pda_4:
	remember. each new task is automatically shown on your minimap.
trader_tutorial_pda_4_1:
	so if youre not interested in that task you should switch to the previous one. 
	there is also a separate section for your own tasks and notes on the map.
trader_tutorial_pda_5:
	moving on. the second section on the pda is the map.
trader_tutorial_pda_6:
	buttons above the map allow  you to zoom in and out. 
trader_tutorial_pda_7:
	erm. oh ! you can also center the map on yourself. and what else ?
trader_tutorial_pda_8:
	you can add or remove your own notes from the map.
trader_tutorial_pda_9:
	im sure youll work it out. its not very complicated.
	the pda also has a contact section.
trader_tutorial_pda_on_1:
	first off, switch your pda on and listen carefully because i dont like to repeat myself.
trader_tutorial_pda_on_2:
	come on, switch on your pda. have you forgot how to do it? ah. dont piss me off.
trader_tutorial_pda_on_3:
	turn it on. come on what are you waiting for ?
trader_tutorial_pda_on_4:
	push the R button moron
trader_tutorial_rejection_1:
	well talk after you finish the mission
trader_tutorial_rejection_2:
	get your mission. stop wasting time.
trader_tutorial_rejection_4:
	youre not a zombie are you ? youre weird that for sure.


Quest:

Stage 10:
	- sid's bunker is closed
	- sid's door is closed
	- encounter with <monster> is available at <place>
		
Stage 20:
	- <monster> cannot be killed so eventually the player scripted-dies
	- player health set to 10%
	- make player invincible
	- disable inputs
	- fade screen to black
	- gunshot sounds in the distance
	- remove <monster> from map

Stage 30:
	- coc to bunker
	- set start sidorovich idle
		well, hello there
		how is it going
		so. shall we talk business ?
	- move player to sid
	- wake up at sidorovich, blackout fades out
	- wait for scene to start automatically
	<dialogue (Tools/aotc/sid01.drawio)>
	- if speech check works, goto Stage 50

Stage 40:
	- set sid's idle to "waiting for case":
		hurry up with that case, alright ?
		dont forget, i still need that case
		im still waiting on that case
	- Unlock sid's door, unlock the external door too
	- Mission started, you have to find Nimble at the bridge
	- There will be an anomaly field and Nimble in the middle
	- He has a case that you have to take to succeed
	- Go to the Bobrov brothers, namely Yefim Bobrov because his brother might be at the Brewery at the time of the quest
	monolog: Things are good! I think you have helped [not only Travis, but] Vadim as well. | Have a good day.
	- Case is removed from you it just disappears, you can't find it on Yefim's body
	- goto Stage 50

Stage 50: TBD...
	- Unlock sid's door, unlock the external door
	- set sid's idle to default idle:
		so youre back
		got anything valuable ?
		what have you got here ?
		how is it going ?
		what brings you here ?
	- goto Stage 1000
	<dialogue (Tools/aotc/sid02.drawio)>

Stage 1000:
	- Add lots of xp for completing the quest
