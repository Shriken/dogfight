module player.gamepad_player;

import derelict.sdl2.sdl;
import gfm.math.vector;
import std.math;

import actor.plane;
import player.player;
import types;

class GamepadPlayer : Player {
	const int DEADZONE_THRESHOLD = cast(int)(0.1 * 32768);

	ControllerID cid;
	SDL_GameController *controller = null;

	Plane plane = null;
	vec2d leftStick = vec2d(0, 0);
	vec2d rightStick = vec2d(0, 0);

	this(
		PlayerID id,
		ControllerID cid,
		SDL_GameController *controller,
		Plane plane
	) {
		super(id, plane, PlayerType.gamepad);
		this.cid = cid;
		this.controller = controller;
	}

	~this() {
		SDL_GameControllerClose(controller);
	}

	override void handleInput(SDL_Event event) {
		switch (event.type) {
			case SDL_CONTROLLERAXISMOTION:
				handleStickMotion(event.caxis);
				break;
			case SDL_CONTROLLERBUTTONDOWN:
				handleButton(event.cbutton);
				break;
			case SDL_CONTROLLERBUTTONUP:
				break;
			default:
				throw new Exception(
					"bad event type passed to GamepadPlayer.handleEvent()"
				);
		}
	}

	void handleStickMotion(SDL_ControllerAxisEvent event) {
		if (plane is null) {
			return;
		}

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

		if (isLeftStick) {
			if (leftStick.squaredLength() > DEADZONE_THRESHOLD ^^ 2) {
				// adjust plane's desired heading
				plane.desiredHeading = atan2(-leftStick.y, leftStick.x);
			} else {
				plane.desiredHeading = plane.heading;
			}
		}
	}

	void handleButton(SDL_ControllerButtonEvent event) {
		if (plane is null) {
			return;
		}

		bool buttonPressed = event.state is SDL_PRESSED;
		switch (event.button) {
			case SDL_CONTROLLER_BUTTON_RIGHTSHOULDER:
				plane.engineOn = !buttonPressed;
				break;
			default:
				break;
		}
	}
}
