module state.state;

import derelict.sdl2.sdl;
import std.algorithm;

import player;
import state.sim_state;
import state.render_state;
import types;

class State {
	SimulationState simState = new SimulationState();
	RenderState renderState = new RenderState();
	double fps;
	bool running = true;

	Player[] players;

	void restart() {
		simState = new SimulationState();
		foreach (player; players) {
			player.plane = simState.spawnNewPlane();
		}
	}

	void addPlayer(SDL_ControllerDeviceEvent event) {
		players ~= new Player(
			event.which,
			SDL_GameControllerOpen(event.which),
			simState.spawnNewPlane()
		);
	}

	Player getPlayer(ControllerID cid) {
		auto range = players.find!"a.cid == b"(cid);
		if (range.length == 0) {
			return null;
		} else {
			return range[0];
		}
	}

	void removePlayer(ControllerID cid) {
		auto i = players.countUntil!"a.cid == b"(cid);
		if (i > -1) {
			players = players.remove(i);
		}
	}
}
