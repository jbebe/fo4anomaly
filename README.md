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
