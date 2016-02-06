module actor.plane;

import std.math;

import types;

class Plane {
	static const double DRAG_COEFFICIENT = 0.02;
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
}

WorldDim headingVector(Plane plane) {
	return WorldDim(cos(plane.heading), sin(plane.heading));
}
