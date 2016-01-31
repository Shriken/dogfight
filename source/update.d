module update;

import state.sim_state;

void update(SimulationState state) {
	foreach (plane; state.planes) {
		plane.pos += plane.vel;
	}
}
