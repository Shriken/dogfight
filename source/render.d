module render;

import derelict.sdl2.sdl;

import state.state;
import state.render_state;
import types;

void render(State state) {
	auto renderState = state.renderState;

	SDL_SetRenderDrawColor(renderState.renderer, 0, 0, 0, 0xff);
	SDL_RenderClear(renderState.renderer);

	SDL_SetRenderDrawColor(renderState.renderer, 0, 0xff, 0, 0xff);
	foreach (plane; state.simState.planes) {
		auto targetRect = plane.pos.toRect(WorldDim(10, 5), renderState);
		SDL_RenderFillRect(renderState.renderer, &targetRect);
	}

	SDL_RenderPresent(renderState.renderer);
}

SDL_Rect toRect(WorldLoc pos, WorldDim dim, RenderState renderState) {
	auto topLeft = (pos - dim / 2).toRenderLoc(renderState);
	auto dimensions = dim.toRenderDim(renderState);
	return SDL_Rect(
		topLeft.x,
		topLeft.y,
		dimensions.x,
		dimensions.y
	);
}

RenderLoc toRenderLoc(WorldLoc pos, RenderState renderState) {
	return renderState.windowDimensions / 2 + RenderLoc(
		cast(int)pos.x,
		cast(int)pos.y
	);
}

RenderDim toRenderDim(WorldDim dim, RenderState renderState) {
	return RenderDim(
		cast(int)dim.x,
		cast(int)dim.y
	);
}
