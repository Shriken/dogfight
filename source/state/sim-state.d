module state.sim_state;

import types;
import actor.plane;

class SimulationState {
	Plane[] planes;
	bool paused = false;

	this() {
		planes ~= new Plane(WorldLoc(0, 0), 0);
	}
}
