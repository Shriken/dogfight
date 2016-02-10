module actor.bullet;

import std.math;

import types;

class Bullet {
	WorldLoc pos;
	WorldDim vel = WorldDim(0, 0);

	double speed = 8;
	double rad = 5;

	bool dead = false;

	this(WorldLoc pos, double heading) {
		this.pos = pos;
		this.vel = WorldDim(
			cos(heading) * speed,
			sin(heading) * speed
		);
	}

	void updateMovement() {
		pos += vel;
	}

	void die() {
		dead = true;
	}
}
