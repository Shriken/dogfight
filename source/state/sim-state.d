module state.sim_state;

import types;
import actor.plane;

class SimulationState {
	const double GRAVITIC_ACCELERATION = 0.2;

	Plane[] planes;
	bool paused = false;

	this() {}

	Plane spawnNewPlane() {
		auto l = planes.length;
		auto plane = new Plane(WorldLoc(50 * planes.length, 0), 0);
		planes ~= plane;
		return plane;
	}
}
