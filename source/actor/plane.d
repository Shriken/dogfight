module actor.plane;

import std.math;

import types;

class Plane {
	WorldLoc pos;
	WorldDim vel;
	double heading;

	this(WorldLoc pos, double heading) {
		this.pos = pos;
		this.heading = heading;

		vel = 3 * WorldDim(cos(heading), sin(heading));
	}
}
