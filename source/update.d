module update;

import gfm.math.vector;
import std.math;

import actor.plane;
import misc.utils;
import state.sim_state;
import types;

void update(SimulationState state) {
	foreach (plane; state.planes) {
		plane.updateMovement(state);
	}
}
