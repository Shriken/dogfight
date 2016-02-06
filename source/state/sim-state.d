module state.sim_state;

import types;
import actor.plane;

class SimulationState {
	const double GRAVITIC_ACCELERATION = 0.1;
	const double DRAG_COEFFICIENT = 0.002;

	Plane[] planes;
	bool paused = false;
	bool useDrag = true;

	Plane spawnNewPlane() {
		auto l = planes.length;
		auto plane = new Plane(
			WorldLoc(50 * planes.length, 0),
			0
		);
		planes ~= plane;
		return plane;
	}
}
