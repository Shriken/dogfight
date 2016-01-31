module event;

import derelict.sdl2.sdl;

import player;
import state.state;

void handleEvent(State state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.running = false;
			break;
		case SDL_KEYUP:
			handleKey(state, event.key);
			break;
		case SDL_CONTROLLERDEVICEADDED:
		case SDL_CONTROLLERDEVICEREMOVED:
			handleControllerDeviceEvent(state, event.cdevice);
			break;
		case SDL_CONTROLLERAXISMOTION:
		case SDL_CONTROLLERBUTTONDOWN:
		case SDL_CONTROLLERBUTTONUP:
			handleControllerInput(state, event);
			break;
		default:
			break;
	}
}

void handleKey(State state, SDL_KeyboardEvent event) {
	switch (event.keysym.sym) {
		case SDLK_q:
			state.running = false;
			break;
		case SDLK_RIGHTBRACKET:
			// restart
			state.restart();
			break;
		default:
			break;
	}
}

void handleControllerInput(State state, SDL_Event event) {
	import std.stdio;
	switch (event.type) {
		case SDL_CONTROLLERAXISMOTION:
			writeln("controller axis motion");
			break;
		case SDL_CONTROLLERBUTTONDOWN:
			writeln("controller button pressed");
			break;
		case SDL_CONTROLLERBUTTONUP:
			writeln("controller button released");
			break;
		default:
			break;
	}
}

void handleControllerDeviceEvent(
	State state,
	SDL_ControllerDeviceEvent event
) {
	import std.stdio;
	switch (event.type) {
		case SDL_CONTROLLERDEVICEADDED:
			state.addPlayer(
				event.which,
				SDL_GameControllerOpen(0)
			);
			writeln("player added");
			break;
		case SDL_CONTROLLERDEVICEREMOVED:
			state.removePlayer(event.which);
			writeln("player removed");
			break;
		default:
			break;
	}
}
