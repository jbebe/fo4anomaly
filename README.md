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


TODO:
	[SKIPPED] Use SubDoor01Left instead of the white submarine door? --> NO, because the wall plug is not suitable :(
	[DONE] SaugusSmokeMirageFX for gravity anomaly --> too slow, too big
	[DONE] Sparks01SaugusFoundry --> for fire anomaly
	npc.PushActorAway(npc, 0) for enabling ragdoll (or just force ragdoll phy)
	add flames to the anomaly: FlameThrowerProjectileSprayVaporizer01.nif
	FXSmokeStackSteam02Half for flame


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
