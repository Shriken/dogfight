module player;

import derelict.sdl2.sdl;
import gfm.math.vector;
import std.math;

import actor.plane;
import types;

class Player {
	const int DEADZONE_THRESHOLD = cast(int)(0.1 * 32768);

	ControllerID cid;
	SDL_GameController *controller = null;

	Plane plane = null;
	vec2d leftStick = vec2d(0, 0);
	vec2d rightStick = vec2d(0, 0);

	this(ControllerID cid, SDL_GameController *controller, Plane plane) {
		this.cid = cid;
		this.controller = controller;
		this.plane = plane;
	}

	~this() {
		SDL_GameControllerClose(controller);
	}

	void handleStickMotion(SDL_ControllerAxisEvent event) {
		auto value = event.value;

		// store stick state
		if (event.axis is SDL_CONTROLLER_AXIS_LEFTX) {
			leftStick.x = value;
		} else if (event.axis is SDL_CONTROLLER_AXIS_LEFTY) {
			leftStick.y = value;
		} else if (event.axis is SDL_CONTROLLER_AXIS_RIGHTX) {
			rightStick.x = value;
		} else if (event.axis is SDL_CONTROLLER_AXIS_RIGHTY) {
			rightStick.y = value;
		}

		bool isLeftStick = event.axis is SDL_CONTROLLER_AXIS_LEFTX ||
			event.axis is SDL_CONTROLLER_AXIS_LEFTY;
		bool isRightStick = event.axis is SDL_CONTROLLER_AXIS_RIGHTX ||
			event.axis is SDL_CONTROLLER_AXIS_RIGHTY;

		if (
			isLeftStick &&
			leftStick.squaredLength() > DEADZONE_THRESHOLD ^^ 2
		) {
			// adjust plane's desired heading
			plane.desiredHeading = atan2(-leftStick.y, leftStick.x);
		}
	}

	void handleButton(SDL_ControllerButtonEvent event) {}
}
