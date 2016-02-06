module update;

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

		auto thrustForce = Plane.THRUST * headingVector;
		auto dragForce = -plane.vel * Plane.DRAG_COEFFICIENT;

		double gForceMag = state.GRAVITIC_ACCELERATION * plane.mass;
		auto graviticForce = WorldDim(0, -gForceMag);
		auto liftForce = gForceMag * WorldDim(
			sin(plane.heading),
			cos(plane.heading)
		);

		plane.vel += (
			thrustForce + dragForce + graviticForce + liftForce
		) / plane.mass;

		// update plane heading
		auto headingDiff = (plane.desiredHeading - plane.heading)
			.mod(2 * PI);
		headingDiff -= (headingDiff > PI) ? 2 * PI : 0;
		if (abs(headingDiff) > EPSILON) {
			if (abs(headingDiff) < Plane.HEADING_ROT_SPEED) {
				plane.heading = plane.desiredHeading;
			} else {
				plane.heading += Plane.HEADING_ROT_SPEED *
					(headingDiff > 0 ? 1 : -1);
			}
		}
	}
}
