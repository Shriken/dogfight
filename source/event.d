module event;

import derelict.sdl2.sdl;

import state.state;

void handleEvent(State state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.simState.running = false;
			break;
		default:
			break;
	}
}
