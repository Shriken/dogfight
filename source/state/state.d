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
		players ~= new Player(cid, controller);
	}

	void removePlayer(ControllerID cid) {
		foreach (i, player; players) {
			if (player.cid == cid) {
				players = players.remove(i);
				break;
			}
		}
	}
}
