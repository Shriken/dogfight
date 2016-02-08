module player.keyboard_player;

import derelict.sdl2.sdl;
import gfm.math.vector;
import std.math;

import actor.plane;
import player.player;

class KeyboardPlayer : Player {
	vec2d moveDir = vec2d(0, 0);
	bool[SDL_Keycode] keyPressed;
	bool getKeyPressed(SDL_Keycode sym) {
		if (sym in keyPressed) {
			return keyPressed[sym];
		}
		return false;
	}

	this(PlayerID id, Plane plane) {
		super(id, plane, PlayerType.keyboard);
	}

	override void handleInput(SDL_Event event) {
		switch (event.type) {
			case SDL_KEYDOWN:
			case SDL_KEYUP:
				handleKey(event.key, event.type is SDL_KEYDOWN);
				break;
			default:
				throw new Exception(
					"bad event type passed to GamepadPlayer.handleEvent()"
				);
		}
	}

	void handleKey(SDL_KeyboardEvent event, bool keyDown) {
		// if we got a duplicate event, return
		if (getKeyPressed(event.keysym.sym) is keyDown) {
			return;
		}

		keyPressed[event.keysym.sym] = keyDown;

		bool movementUpdated = false;
		switch (event.keysym.sym) {
			case SDLK_w:
				moveDir.y += keyDown ? 1 : -1;
				movementUpdated = true;
				break;
			case SDLK_a:
				moveDir.x += keyDown ? -1 : 1;
				movementUpdated = true;
				break;
			case SDLK_s:
				moveDir.y += keyDown ? -1 : 1;
				movementUpdated = true;
				break;
			case SDLK_d:
				moveDir.x += keyDown ? 1 : -1;
				movementUpdated = true;
				break;

			case SDLK_j:
				plane.engineOn = !keyDown;
				break;

			default:
				break;
		}

		if (movementUpdated) {
			if (moveDir.squaredLength != 0) {
				plane.desiredHeading = atan2(moveDir.y, moveDir.x);
			} else {
				plane.desiredHeading = plane.heading;
			}
		}
	}
}
