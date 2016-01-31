module event;

import derelict.sdl2.sdl;

import state.state;

void handleEvent(State state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.running = false;
			break;
		case SDL_KEYUP:
			handleKey(state, event.key);
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
