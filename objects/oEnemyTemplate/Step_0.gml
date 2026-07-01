if(instance_exists(oLoadingScreen)) exit //This prevents the object from working during a loading screen
state.runSTEP();
if state != stateDEFEAT { event_inherited(); }