module event;

import derelict.sdl2.sdl;

import player.gamepad_player;
import player.keyboard_player;
import player.player;
import state.state;

void handleEvent(State state, SDL_Event event) {
	switch (event.type) {
		case SDL_QUIT:
			state.running = false;
			break;
		case SDL_KEYUP:
		case SDL_KEYDOWN:
			if (!handleKey(state, event.key)) {
				state.keyboardPlayer().handleInput(event);
			}
			break;
		case SDL_CONTROLLERDEVICEADDED:
		case SDL_CONTROLLERDEVICEREMOVED:
			handleControllerDeviceEvent(state, event.cdevice);
			break;
		case SDL_CONTROLLERAXISMOTION:
		case SDL_CONTROLLERBUTTONDOWN:
		case SDL_CONTROLLERBUTTONUP:
			state.getGamepadPlayer(event.caxis.which)
				.handleInput(event);
			break;
		default:
			break;
	}
}

// returns true if key used
bool handleKey(State state, SDL_KeyboardEvent event) {
	if (event.state is SDL_RELEASED) {
		return false;
	}

	switch (event.keysym.sym) {
		case SDLK_ESCAPE:
			state.running = false;
			break;

		case SDLK_o:
			state.renderState.debugRender = !state.renderState.debugRender;
			break;

		case SDLK_RIGHTBRACKET:
			// restart
			state.restart();
			break;

		case SDLK_z:
			// toggle drag vs max speed
			state.simState.useDrag = !state.simState.useDrag;
			break;

		default:
			return false;
	}

	return true;
}

void handleControllerDeviceEvent(
	State state,
	SDL_ControllerDeviceEvent event
) {
	switch (event.type) {
		case SDL_CONTROLLERDEVICEADDED:
			state.addGamepadPlayer(event);
			break;
		case SDL_CONTROLLERDEVICEREMOVED:
			state.removeGamepadPlayer(event.which);
			break;
		default:
			break;
	}
}
