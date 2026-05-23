/*
    GMSCore_fnc_initializeSimulation 

    Purpose: Configure Simulation
        Utlize Arma's dynamic simulation system 

    Parameters: None 

    Returns: None 

*/



enableDynamicSimulationSystem true; 

"IsMoving" setDynamicSimulationDistanceCoef 3;
"Group" setDynamicSimulationDistance 2000;
"Vehicle" setDynamicSimulationDistance 20000; 
"EmptyVehicle" setDynamicSimulationDistance 500; 
"Prop" setDynamicSimulationDistance 50;

//if ( GMSCore_debug > 0) then {[format["Dynamic simulation configured at %1",diag_tickTime]]  call GMSCore_fnc_log};