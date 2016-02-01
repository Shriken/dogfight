module render;

import derelict.sdl2.sdl;
import std.math;

import actor.plane;
import state.state;
import state.render_state;
import types;

void render(State state) {
	auto renderState = state.renderState;

	SDL_SetRenderDrawColor(renderState.renderer, 0, 0, 0, 0xff);
	SDL_RenderClear(renderState.renderer);

	SDL_SetRenderDrawColor(renderState.renderer, 0, 0xff, 0, 0xff);
	foreach (plane; state.simState.planes) {
		renderPlane(state, plane);
	}

	SDL_RenderPresent(renderState.renderer);
}

void renderPlane(State state, Plane plane) {
	auto renderState = state.renderState;
	auto heading = plane.heading;

	// draw nose
	auto nosePos = plane.pos + 2 * WorldDim(cos(heading), sin(heading));
	auto targetRect = getRect(nosePos, WorldDim(4, 4), renderState);
	SDL_RenderFillRect(renderState.renderer, &targetRect);

	auto tailPos = plane.pos - 3 * WorldDim(cos(heading), sin(heading));
	targetRect = getRect(tailPos, WorldDim(6, 6), renderState);
	SDL_RenderFillRect(renderState.renderer, &targetRect);
}

SDL_Rect getRect(WorldLoc center, WorldDim dim, RenderState renderState) {
	auto topLeft = (center - dim / 2).toRenderLoc(renderState);
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
