module state.sim_state;

import actor.plane;

class SimulationState {
	Plane planes;
	bool running = true;
	bool paused = false;
}
