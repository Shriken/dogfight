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
		auto graviticAccel = WorldDim(
			0,
			-state.GRAVITIC_ACCELERATION
		);
		if (plane.engineOn) {
			graviticAccel *= 0.2;
			auto thrustForce = plane.thrust * headingVector;
			plane.vel += thrustForce / plane.mass;
		}
		plane.vel += graviticAccel;

		if (state.useDrag) {
			double dragForceMag = plane.vel.squaredLength() *
				state.DRAG_COEFFICIENT;
			plane.vel -= dragForceMag * plane.vel.normalized()
				/ plane.mass;
		} else {
			if (plane.vel.squaredLength() > Plane.MAX_SPEED ^^ 2) {
				plane.vel *= 0.9;
			}
		}

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
