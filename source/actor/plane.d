module actor.plane;

import derelict.sdl2.sdl;
import std.math;

import types;

class Plane {
	static const double MAX_SPEED = 4;
	static const double THRUST = 0.4;

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
