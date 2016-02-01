module state.sim_state;

import types;
import actor.plane;

class SimulationState {
	Plane[] planes;
	bool paused = false;

	this() {}

	Plane spawnNewPlayer() {
		auto plane = new Plane(WorldLoc(0, 0), 0);
		planes ~= plane;
		return plane;
	}
}
