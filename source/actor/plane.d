module actor.plane;

import derelict.sdl2.sdl;
import std.math;

import misc.utils;
import state.sim_state;
import types;

class Plane {
	static const double MAX_SPEED = 4;
	static const double THRUST = 0.1;

	double mass = 1;
	WorldLoc pos;
	WorldDim vel;
	double heading = 0;

	double desiredHeading = 0;
	bool engineOn = true;

	this(WorldLoc pos, double heading) {
		this.pos = pos;
		this.heading = heading;

		vel = WorldDim(cos(heading), sin(heading));
	}

	void updateMovement(SimulationState state) {
		pos += vel;

		auto graviticAccel = WorldDim(0, -state.GRAVITIC_ACCELERATION);
		if (engineOn) {
			graviticAccel *= 0.2;
			auto thrustForce = thrust * this.headingVector;
			vel += thrustForce / mass;
		}
		vel += graviticAccel;

		if (state.useDrag) {
			double dragForceMag = vel.squaredLength() *
				state.DRAG_COEFFICIENT;
			vel -= dragForceMag * vel.normalized()
				/ mass;
		} else {
			if (vel.squaredLength() > Plane.MAX_SPEED ^^ 2) {
				vel *= 0.9;
			}
		}

		// update plane heading
		auto headingDiff = (desiredHeading - heading)
			.mod(2 * PI);
		headingDiff -= (headingDiff > PI) ? 2 * PI : 0;
		if (abs(headingDiff) > EPSILON) {
			if (abs(headingDiff) < headingRotSpeed) {
				heading = desiredHeading;
			} else {
				heading += headingRotSpeed *
					(headingDiff > 0 ? 1 : -1);
			}
		}
	}

	double headingRotSpeed() {
		if (engineOn) {
			return 0.05;
		} else {
			return 0.2;
		}
	}

	double thrust() {
		if (engineOn) {
			return THRUST;
		} else {
			return 0;
		}
	}

	SDL_Color color() {
		if (engineOn) {
			return SDL_Color(0, 0xff, 0, 0xff);
		} else {
			return SDL_Color(0, 0xaf, 0, 0xff);
		}
	}
}

WorldDim headingVector(Plane plane) {
	return WorldDim(cos(plane.heading), sin(plane.heading));
}
