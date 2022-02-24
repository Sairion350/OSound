ScriptName OSoundScript Extends OStimAddon
import outils 

OSoundPlayer audioplayer

bool property active auto 

ODatabaseScript odatabase 
bool ov_loaded

Event OnInit()
	audioplayer = (self as quest) as OSoundPlayer

	RegisteredEvents = stringarray("OStim_AnimationChanged", "OStim_PreStart", "OStim_End", "OStim_Start", "OStim_SceneChanged")
	RequiredVersion = 27
	InstallAddon("OSound")
	
	odatabase = ostim.GetODatabase()
	ostim.muteosa = true
	ov_loaded = OUtils.IsModLoaded("ovoice.esp")




	int[] list = ostim.SoundFormNumberWhitelist  
	if (list.Length < 2 )

			list = PapyrusUtil.IntArray(0)
			list = PapyrusUtil.PushInt(list, 20)
			list = PapyrusUtil.PushInt(list, 25)
			list = PapyrusUtil.PushInt(list, 10)
			list = PapyrusUtil.PushInt(list, 11)
			list = PapyrusUtil.PushInt(list, 15)
			;list = PapyrusUtil.PushInt(list, 16)
			list = PapyrusUtil.PushInt(list, 60)
			list = PapyrusUtil.PushInt(list, 80)
			list = PapyrusUtil.PushInt(list, 85)
			ostim.SoundFormNumberWhitelist = list 
			return 

	endif 

	 ostim.SoundFormNumberWhitelist = PapyrusUtil.removeint(ostim.SoundFormNumberWhitelist, 50)
	 ostim.SoundFormNumberWhitelist = PapyrusUtil.removeint(ostim.SoundFormNumberWhitelist, 16)

EndEvent

Event OStim_PreStart(string eventName, string strArg, float numArg, Form sender)
	Console("OSound starting")

	audioplayer.ActionPoint = GetBlankObject()
	audioplayer.ActionPoint.MoveTo(ostim.GetDomActor())

	lastClass = "" 
	lastScene = ""

	lastWasTransition = false 
	lastWasSex = false 
	active = true 

	audioplayer.startup()

	iterCounter = -1 


EndEvent

Event OStim_Start(string eventName, string strArg, float numArg, Form sender)
	audioplayer.onBed = ostim.IsBed(ostim.GetBed())
	if audioplayer.onbed 
		audioplayer.bed = ostim.GetBed()
	endif 
	if ov_loaded 

		Utility.Wait(1.5)
		ostim.SoundFormNumberWhitelist = PapyrusUtil.removeint(ostim.SoundFormNumberWhitelist, 50)
		ostim.SoundFormNumberWhitelist = PapyrusUtil.removeint(ostim.SoundFormNumberWhitelist, 16)
	endif 
EndEvent

string lastClass
bool lastWasTransition
bool lastWasSex 
string lastScene
Event OStim_SceneChanged(string eventName, string strArg, float numArg, Form sender)
	actorCache = ostim.GetActors()


	int oid = ostim.GetCurrentAnimationOID()
	string name = odatabase.GetFullName(oid)

	string cclass = ostim.GetCurrentAnimationClass()

	string currscene = ostim.GetCurrentAnimationSceneID()

	
	bool transition = odatabase.IsTransitoryAnimation(oid) 

	bool sex = odatabase.IsSexAnimation(oid) 


	if (!lastWasTransition || transition) && (currscene != lastScene) && !StringContains(name, "spank")
		if !(transition && lastWasSex)
			;if ostim.isnaked(actorCache[0]) 
				OSANative.SendEvent(self, "PlayTouch")
			;endif 
		endif 
	endif 


	if transition
		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true  

	elseif cclass == "Sx" || cclass == "An"
		genitalsNode = penis 
		genitalsFemaleNode = penisBase
		ActorA = actorCache[0]
		ActorB = actorCache[1]

		;audioplayer.PussyAtten = 13.0

		audioplayer.MuteThrust = false 
		audioplayer.MutePussy = false 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true
	elseif cclass == "Pf1" || cclass == "Pf2" || cclass == "Cr"
		ActorA = actorCache[0]
		ActorB = actorCache[1]
		genitalsNode = RHand 
		genitalsFemaleNode = penisBase
		


		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = false 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true

	elseif StringContains(name, "kiss")
		audioplayer.kiss.GetDescriptor().SetDecibelAttenuation(0.0)
		audioplayer.kissRate = 2.0 
		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = false
	elseif cclass == "ApPJ" || cclass == "HhPJ"
		ActorA = actorCache[0]
		ActorB = actorCache[1]
		genitalsNode = penis 
		genitalsFemaleNode = head
		


		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = false
		audioplayer.MuteBJ = false
		audioplayer.MuteKiss = true

	elseif OUtils.StringArrayContainsValue(OUtils.BlowjobClasses(), cclass)
		ActorA = actorCache[0]
		ActorB = actorCache[1]
		genitalsNode = penis 
		genitalsFemaleNode = head
		


		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = false
		audioplayer.MuteKiss = true

	elseif OUtils.StringArrayContainsValue(OUtils.CunnilingusClasses(), cclass)
		audioplayer.kiss.GetDescriptor().SetDecibelAttenuation(3.0)
		ActorA = actorCache[0]
		ActorB = actorCache[1]
		genitalsNode = "" 
		genitalsFemaleNode = ""
		

		audioplayer.kissRate = ( ostim.GetCurrentAnimationMaxSpeed() / ostim.GetCurrentAnimationSpeed() )  * 0.75
		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = false 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = false
	elseif OUtils.StringArrayContainsValue(OUtils.HandjobClasses(), cclass)
		ActorA = actorCache[1]
		ActorB = actorCache[0]
		genitalsNode = GetHand(actorb, actora) 
		genitalsFemaleNode = penisBase 
		



		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = false
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true
	elseif cclass == "FJ"
		ActorA = actorCache[1]
		ActorB = actorCache[0]
		genitalsNode = GetFoot(actorb, actora) 
		genitalsFemaleNode = penisBase 
	

		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = false
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true
	elseif (cclass == "Po") || (cclass == "HhPo")
		ActorA = actorCache[0]
		ActorB = actorCache[0]
		genitalsNode = GetHand(actora, actora) 
		genitalsFemaleNode = penisBase
		

		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = false
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true
	elseif cclass == "BoJ" 
		genitalsNode = penis 
		genitalsFemaleNode = head
		ActorA = actorCache[0]
		ActorB = actorCache[1]


		audioplayer.MuteThrust = false 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true
	else 
		audioplayer.MuteThrust = true 
		audioplayer.MutePussy = true 
		audioplayer.MuteFap = true
		audioplayer.MuteBJ = true
		audioplayer.MuteKiss = true
	endif 
 
	;long, sorry.
	;basically, if PULLING OUT
	
	if ((Lastclass == "Sx" || Lastclass == "An") && !(cclass == "Sx" || cclass == "An")) || ((cclass == "Sx" || cclass == "An") && (transition)) ;pulling out
		lastClass = "No Doubles Please"
		audioplayer.PlayPussySound(2.0)
	elseif (!(Lastclass == "Sx" || Lastclass == "An") && (cclass == "Sx" || cclass == "An")) ; inserting
		audioplayer.PlayPussySound(0.0)
		
	elseif OUtils.StringArrayContainsValue(OUtils.BlowjobClasses(), cclass) && (transition)
		audioplayer.BJEndSound()		
	endif 

	lastclass = cclass
	lastwastransition = transition 
	lastScene = currscene
	lastWasSex = sex 
EndEvent

Event OStim_AnimationChanged(string eventName, string strArg, float numArg, Form sender)
	unregisterforupdate()

	idling = (ostim.GetCurrentAnimationSpeed() == 0) && odatabase.hasidlespeed(ostim.GetCurrentAnimationOID())

	
	initial = true 

	min = 9999.0 
	max = 0.0
	times = PapyrusUtil.FloatArray(0)
	audioplayer.ThrustRate = -1.0
	lastDist = 100.0 
	topSpeed = 0.0 
	approaching = false
	lightThrusts = false 
	firstSwitch = true
	Averages = 0 
	GoToState("Sending")
	
	CalcThrustVolume()

	RegisterForSingleUpdate(0.5)

	float[] pen = GetNodeLocation(actorCache[0], penisBase)
	audioplayer.ActionPoint.SetPosition(pen[0], pen[1], pen[2])
EndEvent

Event OStim_End(string eventName, string strArg, float numArg, Form sender)
	active = false 
	audioplayer.MuteThrust = true 
	audioplayer.MutePussy = true 
	audioplayer.MuteFap = true
	audioplayer.MuteBJ = true
	audioplayer.MuteKiss = true 
EndEvent

bool initial
bool idling 

actor[] actorCache 

string genitalsNode
string genitalsFemaleNode


string penis  = "NPC Genitals01 [Gen01]"
string penisMid  = "NPC Genitals03 [Gen03]"
string penisBase = "NPC Belly"
string head = "NPC Head [Head]"
string RHand = "CME R Finger20 [RF20]"
string LHand = "CME L Finger20 [LF20]"
string RFoot = "CME R Toe0 [RToe]"
string LFoot = "CME L Toe0 [LToe]"



string Function GetHand(actor a, actor b )
	float r = outils.ThreeDeeDistance(GetNodeLocation(a, penisMid), GetNodeLocation(b, rhand))
	float l = outils.ThreeDeeDistance(GetNodeLocation(a, penisMid), GetNodeLocation(b, lhand))

	if l < r
		return lhand 
	else 
		return rhand 
	endif 
EndFunction

string Function GetFoot(actor a, actor b )
	float r = outils.ThreeDeeDistance(GetNodeLocation(a, penisMid), GetNodeLocation(b, rfoot))
	float l = outils.ThreeDeeDistance(GetNodeLocation(a, penisMid), GetNodeLocation(b, lfoot))

	if l < r
		return lfoot 
	else 
		return rfoot 
	endif 
EndFunction

float lastDist
bool approaching 

int iterCounter 

float[] times 

bool firstSwitch

int Averages

float min 
float max 

bool lightThrusts

float updateRate = 0.12

float topSpeed
State Sending 
	Event OnUpdate()


		float dist = GetGenitalDistances()

		if dist < min 
			min = dist 
		elseif dist > max 
			max = dist 
		endif 

		if ((max - min) < 4.0) && !lightThrusts ;small thrusts
			lightThrusts = true 
			CalcThrustVolume()
		elseif !((max - min) < 4.0) && lightThrusts
			lightThrusts = false 
			CalcThrustVolume()
		endif 

	;	Console("Dist: " + dist + " min: " + min + " max: " + max + " dif: " + (max-min))

		if (lastDist - dist) > 0.6; getting closer 
			;console("approach")
			approaching = true 

			if lastDist != 100.0
				float speed 
				speed = (lastDist - dist) * (1/updateRate)

				if (speed > topSpeed )
					topSpeed = speed 
					CalcThrustVolume()
				endif 
			;Console("Top Speed = " + speed + " /s " + "      Top: " + topSpeed) 
			endif 
		else ; getting farther
			;Console("Farther")
			if approaching 
				;OSANative.SendEvent(self, "SoundThreadThrust")\

				times = PapyrusUtil.PushFloat(times, Utility.GetCurrentRealTime())
				if audioplayer.ThrustRate == -1.0
					if !audioplayer.MuteThrust
						audioplayer.SoundThreadThrust()
					endif 
					if !audioplayer.MuteFap
						audioplayer.soundthreadfap()
					endif
					if !audioplayer.MuteBJ
						audioplayer.soundthreadBJ()
					endif 
					if audioplayer.MuteThrust && !audioplayer.MutePussy
						audioplayer.SoundThreadPussy()
						audioplayer.PlayFap()
					endif 
					;Console("Event!")
				else 
					if !audioplayer.MuteThrust
						OSANative.SendEvent(self, "DelayedThrust")
						if firstSwitch
							firstSwitch = false 
							audioplayer.SoundThreadThrust()
						endif 
					endif 
					if !audioplayer.MuteBJ
						audioplayer.soundthreadBJ()
					endif 
					if !audioplayer.MuteFap
						audioplayer.soundthreadfap()
					endif 
					if audioplayer.MuteThrust && !audioplayer.MutePussy
						audioplayer.SoundThreadPussy()
					endif 
				endif 

				;console(times as string)

				int l = times.Length
				if  (l > 2) && Averages < 4
					audioplayer.ThrustRate = ((times[ l - 1] - times[ l - 2]) + (times[ l - 2] - times[ l - 3])) / 2 ;rolling average of top2
					;Console(audioplayer.ThrustRate)
					Averages += 1
					
					if (Utility.IsInMenuMode() || UI.IsMenuOpen("console")) ; reset if menu was open, breaks everything otherwise 
						Averages = 0 
					endif 
				endif 


				;Console("HIT EVENT")
			endif 

			approaching = false 
		endif 



		lastDist = dist 
		if active 
			RegisterForSingleUpdate(updateRate)
		endif 
		
		if iterCounter > 30 
			iterCounter = -1 

			;every 30 

			if !audioplayer.MutePussy
				float atten 

				if idling
					atten = 100.0
				elseif ostim.GetTimesOrgasm(actorCache[1]) > 0 
					atten = 5.0
				else 
					atten = ostim.GetActorExcitement(actorCache[1])
					atten /= 100.0 
					atten -= 1.0 
					atten *= -7.0 
					atten += 5.0 

					;Console(atten)


				endif 

				audioplayer.PussyAtten = atten
			endif 

		endif 
		iterCounter += 1
	EndEvent
EndState

Function CalcThrustVolume()
	if idling ;idling
			audioplayer.SetThrustAtten(100.0)
			audioplayer.PussyAtten = 100.0
			return 
	endif 

	int maxs = ostim.GetCurrentAnimationMaxSpeed()



	if (maxs > 1 )
		float quietAmount = 10.0 / (maxs - 1.0)

		float set  = (maxs - ostim.GetCurrentAnimationSpeed()) * quietAmount
		if lightThrusts
			set = PapyrusUtil.ClampFloat(set, 11.9, 100.0)
			;Console("Ligh thrust engaged!")
		endif 
		if (topSpeed < 20.0) && !initial
			;Console("Lightening more!")

			set +=  (20.0 - topSpeed)
		endif 
		audioplayer.SetThrustAtten(set)
		
		if !audioplayer.MuteKiss
			float a = 1 - (ostim.GetCurrentAnimationSpeed() / maxs)
			audioplayer.kiss.GetDescriptor().SetDecibelAttenuation((a * 9.0) + 3.0)
		endif 
		;Console("atten: " + set)
	else ; hubs, etc
		audioplayer.SetThrustAtten(0.0)
		if !audioplayer.MuteKiss
			audioplayer.kiss.GetDescriptor().SetDecibelAttenuation(0.0)
		endif 
	endif 

	initial = false 
EndFunction

Event DelayedThrust()
	Utility.Wait(audioplayer.ThrustRate - 0.3) ;todo improve
	audioplayer.SoundThreadThrust()
EndEvent

actor ActorA 
actor ActorB
float Function GetGenitalDistances()
	return outils.ThreeDeeDistance(GetNodeLocation(actora, genitalsNode), GetNodeLocation(actorb, genitalsFemaleNode))
EndFunction