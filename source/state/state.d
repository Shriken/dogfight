module state.state;

import derelict.sdl2.sdl;
import std.algorithm;

import player.gamepad_player;
import player.keyboard_player;
import player.player;
import state.sim_state;
import state.render_state;
import types;

class State {
	SimulationState simState = new SimulationState();
	RenderState renderState = new RenderState();
	double fps;
	bool running = true;

	Player[] players;

	PlayerID[ControllerID] gamepadPlayerMapping;
	PlayerID getPlayerID(ControllerID cid) {
		return gamepadPlayerMapping[cid];
	}

	PlayerID nextPlayerID = 1;
	PlayerID getNextPlayerID() { return nextPlayerID++; }

	this() {
		players ~= new KeyboardPlayer(
			getNextPlayerID(),
			simState.spawnNewPlane()
		);
	}

	void restart() {
		simState = new SimulationState();
		foreach (player; players) {
			player.plane = simState.spawnNewPlane();
		}
	}

	void addGamepadPlayer(SDL_ControllerDeviceEvent event) {
		if (event.which in gamepadPlayerMapping) {
			import std.stdio;
			writeln("tried to create new player with existing cid");
			return;
		}

		players ~= new GamepadPlayer(
			getNextPlayerID(),
			event.which,
			SDL_GameControllerOpen(event.which),
			simState.spawnNewPlane()
		);
		gamepadPlayerMapping[event.which] = players[$ - 1].id;
	}

	Player keyboardPlayer() { return players[0]; }
	Player getGamepadPlayer(ControllerID cid) {
		auto range = players.find!"a.id == b"(getPlayerID(cid));
		if (range.length == 0) {
			return null;
		} else {
			return range[0];
		}
	}

	void removeGamepadPlayer(ControllerID cid) {
		auto i = players.countUntil!"a.id == b"(getPlayerID(cid));
		if (i > -1) {
			auto player = players[i];
			players = players.remove(i);
			simState.removePlane(player.plane);
		}
	}
}
