module update;

import gfm.math.vector;
import std.math;

import actor.plane;
import misc.utils;
import state.sim_state;
import types;

const double EPSILON = 0.000001;

void update(SimulationState state) {
	foreach (plane; state.planes) {
		plane.pos += plane.vel;

		auto headingVector = plane.headingVector;
		auto thrustForce = plane.thrust * headingVector;
		auto dragForce = -plane.vel * Plane.DRAG_COEFFICIENT;

		plane.vel += (thrustForce + dragForce) / plane.mass;

		// update plane heading
		auto headingDiff = (plane.desiredHeading - plane.heading)
			.mod(2 * PI);
		headingDiff -= (headingDiff > PI) ? 2 * PI : 0;
		if (abs(headingDiff) > EPSILON) {
			if (abs(headingDiff) < plane.headingRotSpeed) {
				plane.heading = plane.desiredHeading;
			} else {
				plane.heading += plane.headingRotSpeed *
					(headingDiff > 0 ? 1 : -1);
			}
		}
	}
}
