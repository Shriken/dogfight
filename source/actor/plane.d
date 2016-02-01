module actor.plane;

import std.math;

import types;

class Plane {
	static const double HEADING_ROT_SPEED = 0.1;

	WorldLoc pos;
	WorldDim vel;

	double heading = 0;
	double desiredHeading = 0;

	this(WorldLoc pos, double heading) {
		this.pos = pos;
		this.heading = heading;

		vel = 3 * WorldDim(cos(heading), sin(heading));
	}
}
