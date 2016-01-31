module player;

import derelict.sdl2.sdl;

import types;

class Player {
	ControllerID cid;
	SDL_GameController *controller;

	this(ControllerID cid, SDL_GameController *controller) {
		this.cid = cid;
		this.controller = controller;
	}
}
