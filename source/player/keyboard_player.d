module player.keyboard_player;

import derelict.sdl2.sdl;

import actor.plane;
import player.player;

class KeyboardPlayer : Player {
	this(PlayerID id, Plane plane) {
		super(id, plane);
	}

	override void handleInput(SDL_Event event) {}
}
