ScriptName OSoundPlayer Extends Quest

; Soundpack API

; Q: How do I change the thrust sound. How do I change the bj sound?
; First create a new CK sound with the sounds you want. Then, find the below property and edit it either by script or ck to point at your sound

Sound Property PussyWet auto 
Sound Property Suck auto 
sound property bjOut auto 
Sound Property ThrustWide auto
sound property fap auto 
sound property rub auto
sound property moist auto 
sound property kiss auto 
sound property touch auto 
sound property sheets auto 

import outils 

OSoundScript main

ObjectReference property ActionPoint auto 
ObjectReference Property bed Auto

float property ThrustRate auto 

Sound Property ThrustMassive auto 
Sound Property ThrustSound auto 



bool property MutePussy auto 
float property PussyAtten auto 

bool property onBed auto 

bool property MuteThrust auto 

bool property MuteFap auto 

bool property MuteBJ auto 

bool MuteKissVar
bool Property MuteKiss
	bool Function Get()
		return MuteKissVar
	EndFunction

	Function Set(bool Variable)
		MuteKissvar = variable 

		if !Variable
			OSANative.SendEvent(self, "SoundThreadKiss")
		endif 

		
	EndFunction
EndProperty

Event OnInit()
	main = (self as quest) as OSoundScript
EndEvent

function Startup()
	;console("sound player starting")

	MuteBj = true 

	MutePussy = true 
	PussyAtten = 13.0

	MuteThrust = true 

	MuteFap = true 

	kiss.GetDescriptor().SetDecibelAttenuation(0.0)
	touch.GetDescriptor().SetDecibelAttenuation(6.5)
	sheets.GetDescriptor().SetDecibelAttenuation(1.5)
	;OSANative.SendEvent(self, "SoundThreadPussy")
	;OSANative.SendEvent(self, "SoundThreadThrust")
endfunction 

Event SoundThreadPussy()
	if ThrustRate > -1.0
		Utility.Wait(ThrustRate * 0.7)
	else 
		Utility.Wait(0.25)
	endif 
	
	if !MutePussy 
		SoundDescriptor desc = PussyWet.GetDescriptor()
		desc.SetDecibelAttenuation(PussyAtten)
		
		PussyWet.Play(ActionPoint)
	endif 

EndEvent 

float property kissRate = 2.0 auto 

Event SoundThreadKiss()

	while !MuteKissVar
		kiss.Play(ActionPoint)
		if !MutePussy
			OSANative.SendEvent(self, "SoundThreadPussy")
		endif 
		float ratePart = kissRate * 0.4

		Utility.Wait(OSANative.RandomFloat(kissRate - ratePart, kissRate + ratePart))
	endwhile
EndEvent 


Event SoundThreadRub()
	

	if ThrustRate > -1.0
		Utility.Wait(ThrustRate * 0.7)
	else 
		Utility.Wait(0.25)
	endif 
	

	Rub.Play(ActionPoint)
EndEvent 

Event SoundThreadMoist()
	if ThrustRate > -1.0
		Utility.Wait(ThrustRate * 0.7)
	else 
		Utility.Wait(0.25)
	endif 
	

	Moist.Play(ActionPoint)
EndEvent



Event SoundThreadBJ()
	
	suck.Play(ActionPoint)

	OSANative.SendEvent(self, "SoundThreadMoist")
EndEvent

Event SoundThreadFap()
	
	fap.Play(ActionPoint)

	OSANative.SendEvent(self, "SoundThreadRub")
EndEvent

Function PlayFap()	
	fap.Play(ActionPoint)
endfunction 

Event PlayTouch()	

	touch.Play(ActionPoint)

	if onBed
		Utility.Wait(0.5)
		sheets.Play(bed)
	endif 
endevent 

Function PlayPussySound(float att)
	PussyWet.GetDescriptor().SetDecibelAttenuation(att)
		
	PussyWet.Play(ActionPoint)
EndFunction

Function BJEndSound()
	bjOut.play(ActionPoint)
EndFunction

Event SoundThreadThrust()
	
	if !MuteThrust 
			ThrustWide.Play(ActionPoint)
	endif 

	OSANative.SendEvent(self, "SoundThreadPussy")
EndEvent 

Function SetThrustAtten(float to)

	SoundDescriptor desc = ThrustSound.GetDescriptor()
	desc.SetDecibelAttenuation(to)

	desc = suck.GetDescriptor()
	desc.SetDecibelAttenuation(to)

	;Console("TO: " + to)
	float capped = to
	if (capped > 6.0) && (capped < 50.0)
		capped = 6.0
	endif  

	desc = fap.GetDescriptor()
	desc.SetDecibelAttenuation(capped + 8.0)

	desc = rub.GetDescriptor()
	desc.SetDecibelAttenuation(capped + 4.0) ;todo more wet sound?

	desc = moist.GetDescriptor()
	desc.SetDecibelAttenuation(papyrusutil.clampfloat(to - 3.0, 0.0, 500.0))


EndFunction