module player.player;

import derelict.sdl2.sdl;
import std.typecons;

import actor.plane;

alias PlayerID = Typedef!int;

enum PlayerType {
	keyboard,
	gamepad
};

abstract class Player {
	PlayerID id;
	Plane plane = null;
	PlayerType type;

	this(PlayerID id, Plane plane) {
		this.id = id;
		this.plane = plane;
	}

	void handleInput(SDL_Event event);
}
