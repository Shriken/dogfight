module actor.plane;

import derelict.sdl2.sdl;
import std.math;

import actor.bullet;
import misc.utils;
import state.sim_state;
import types;

struct Hitbox {
	WorldDim offset;
	double rad;
}

struct HitboxRange {
	Hitbox[] hitboxes;
	double heading;

	this(Hitbox[] hitboxes, double heading) {
		this.hitboxes = hitboxes;
		this.heading = heading;
	}

	@property bool empty() {
		return hitboxes.length == 0;
	}

	@property Hitbox front() {
		auto hitbox = hitboxes[0];
		auto offset = hitbox.offset;

		hitbox.offset = WorldDim(
			cos(heading) * offset.x - sin(heading) * offset.y,
			sin(heading) * offset.x + cos(heading) * offset.y,
		);
		return hitbox;
	}

	@property void popFront() {
		hitboxes = hitboxes[1 .. $];
	}
}

class Plane {
	static const double THRUST = 0.1;

	double mass = 1;
	WorldLoc pos;
	WorldDim vel;
	double heading = 0;

	double desiredHeading = 0;
	bool engineOn = true;
	bool dead = false;

	double timeBetweenShots = 5;
	double timeToFire = 0;

	private Hitbox[2] planeHitboxes = [
		Hitbox(WorldDim(2, 0), 2), // nose
		Hitbox(WorldDim(-3, 0), 3), // tail
	];
	@property HitboxRange hitboxes() {
		return HitboxRange(planeHitboxes, heading);
	}

	@property double headingRotSpeed() {
		if (engineOn) {
			return 0.05;
		} else {
			return 0.2;
		}
	}

	@property double thrust() {
		if (engineOn) {
			return THRUST;
		} else {
			return 0;
		}
	}

	@property SDL_Color color() {
		if (engineOn) {
			return SDL_Color(0, 0xff, 0, 0xff);
		} else {
			return SDL_Color(0, 0xaf, 0, 0xff);
		}
	}

	@property bool shouldFire() { return timeToFire <= 0; }

	this(WorldLoc pos, double heading) {
		this.pos = pos;
		this.heading = heading;

		vel = WorldDim(cos(heading), sin(heading));
	}

	void updateMovement(SimulationState state) {
		pos += vel;

		// gravity and thrust
		auto graviticAccel = WorldDim(0, -state.GRAVITIC_ACCELERATION);
		if (engineOn) {
			graviticAccel *= 0.2;
			auto thrustForce = thrust * this.headingVector;
			vel += thrustForce / mass;
		}
		vel += graviticAccel;

		// drag force
		double dragForceMag = vel.squaredLength() *
			state.DRAG_COEFFICIENT;
		vel -= dragForceMag * vel.normalized() / mass;

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

	Bullet fire() {
		timeToFire = timeBetweenShots;
		return new Bullet(
			pos + this.headingVector * 15,
			heading
		);
	}

	void die() {
		dead = true;
	}

	bool collidesWith(Bullet bullet) {
		foreach (hitbox; hitboxes) {
			auto hitboxPos = pos + hitbox.offset;
			auto squaredDist = (hitboxPos - bullet.pos).squaredLength();
			if (squaredDist < (bullet.rad + hitbox.rad) ^^ 2) {
				return true;
			}
		}

		return false;
	}
}

WorldDim headingVector(Plane plane) {
	return WorldDim(cos(plane.heading), sin(plane.heading));
}
