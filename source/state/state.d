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
	}

	void addPlayer(ControllerID cid, SDL_GameController *controller) {
		players ~= new Player(cid, controller, simState.spawnNewPlayer());
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
