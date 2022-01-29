Quest:

Stage 10:
	- [DONE] sid's bunker is closed  
	- [DONE] sid's door is closed
	- encounter with <monster> is available at <place>
		- [DONE] ambush
		- player fade, shooting, transition to bunker cell
		
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
