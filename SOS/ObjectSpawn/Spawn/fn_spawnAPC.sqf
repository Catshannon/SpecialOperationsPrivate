/*
	Use this script to allow specific classes to spawn APCs.

	Created by Lux0r
*/


_caller			= _this select 1;
_arguments		= _this select 3;
_vehicleType	= _arguments select 0;
_spawn			= _arguments select 1;
_whitelisted	= _arguments select 2;
_texture		= _arguments select 3;
_spawnDelay		= 5;


// Check if players class is allowed to spawn an APCs.
if ((typeOf _caller) in OS_allowAPCSpawnWest) then {
	if (OS_spawnDelay > 0) then {
		hintSilent format["Please try again in about %1 seconds.", OS_spawnDelay];
		playSound "warning1";
	} else {
		// Create the vehicle
		_spawnPos = getPos _spawn;
		_veh = _vehicleType createVehicle [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) + 0.5];
		_veh setDir (getDir _spawn);

		// set TFAR vehicle side to callers side if TFAR is running
		if ("task_force_radio_items" in activatedAddons) then {
			_side = side _caller;
			_veh setVariable ["tf_side", _side, true];
		};

		// add event handler to vehicle sets radio freqs for crew when they get in
		if (!isNil "CEN_fnc_vehicleRadioFreqs") then {
			_veh addEventHandler ["GetIn", {
				_this call CEN_fnc_vehicleRadioFreqs; // note: This breaks airbourn radio for some reason.
			}];
		};

		// Remove weapons
		clearWeaponCargoGlobal _veh;

		// Change texture
		if (_texture != "") then {
			switch (_vehicleType) do {
				case "B_APC_Tracked_01_rcws_F": {
					_veh setObjectTextureGlobal [0, format["SOS\Textures\%1.paa", _texture]];
					_veh setObjectTextureGlobal [1, format["SOS\Textures\%1.paa", _texture]];
					_veh setObjectTextureGlobal [2, format["SOS\Textures\%1.paa", _texture]];
				};
				case "I_APC_tracked_03_cannon_F": {
					_veh setObjectTextureGlobal [0, format["SOS\Textures\%1Turret.paa", _texture]];
					_veh setObjectTextureGlobal [1, format["SOS\Textures\%1Hull.paa", _texture]];
				};
			};
		};

		if (OS_disableThermal == 1) then {
			_veh disableTIEquipment true;
		};

		OS_spawnDelay = OS_spawnDelay + _spawnDelay;
		playSound "confirm1";
	};
} else {
	hintSilent "You can't spawn this APC, if you are not in a tank crew!";
	playSound "warning1";
};