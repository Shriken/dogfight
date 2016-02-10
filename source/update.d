module update;

import gfm.math.vector;
import std.algorithm;
import std.math;

import actor.plane;
import misc.utils;
import state.sim_state;
import types;

void update(SimulationState state) {
	foreach (plane; state.planes) {
		plane.updateMovement(state);

		if (plane.engineOn) {
			state.bullets ~= plane.fire();
		}
	}

	foreach (bullet; state.bullets) {
		bullet.pos += bullet.vel;
		foreach (plane; state.planes) {
			if (plane.collidesWith(bullet)) {
				plane.die();
				bullet.die();
				break;
			}
		}
	}

	for (int i = 0; i < state.bullets.length; i++) {
		auto bullet = state.bullets[i];
		if (bullet.dead) {
			state.bullets = state.bullets.remove!(SwapStrategy.unstable)
				(i--);
		}
	}
	for (int i = 0; i < state.planes.length; i++) {
		auto plane = state.planes[i];
		if (plane.dead) {
			state.planes = state.planes.remove!(SwapStrategy.unstable)
				(i--);
		}
	}
}
