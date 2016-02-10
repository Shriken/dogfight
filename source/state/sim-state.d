module state.sim_state;

import actor.bullet;
import actor.plane;
import types;

class SimulationState {
	const double GRAVITIC_ACCELERATION = 0.1;
	const double DRAG_COEFFICIENT = 0.002;

	Plane[] planes;
	Bullet[] bullets;
	bool paused = false;

	Plane spawnNewPlane() {
		auto plane = new Plane(
			WorldLoc(50 * planes.length, 0),
			0
		);
		planes ~= plane;
		return plane;
	}
}
