module render;

import derelict.sdl2.sdl;
import std.conv;
import std.math;

import actor.plane;
import misc.utils;
import render_utils;
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

	setRenderDrawColor(renderState.renderer, plane.color);

	// draw nose
	auto nosePos = plane.pos + 2 * plane.headingVector;
	auto targetRect = getRect(nosePos, WorldDim(4, 4), renderState);
	SDL_RenderFillRect(renderState.renderer, &targetRect);

	// draw tail
	auto tailPos = plane.pos - 3 * plane.headingVector;
	targetRect = getRect(tailPos, WorldDim(6, 6), renderState);
	SDL_RenderFillRect(renderState.renderer, &targetRect);

	if (renderState.debugRender) {
		// draw heading indicator
		auto desiredHeadingVector = WorldDim(
			cos(plane.desiredHeading),
			sin(plane.desiredHeading)
		);
		SDL_SetRenderDrawColor(renderState.renderer, 0xff, 0, 0, 0xff);
		targetRect = getRect(
			plane.pos + 100 * desiredHeadingVector,
			WorldDim(10, 10),
			renderState
		);
		SDL_RenderFillRect(renderState.renderer, &targetRect);

		// print debug text for heading, desired heading
		SDL_SetRenderDrawColor(
			renderState.renderer,
			0xff, 0xff, 0xff, 0xff
		);
		drawText(
			renderState,
			to!string(plane.pos),
			renderState.debugTextFont,
			0, 0
		);
		drawText(
			renderState,
			to!string(plane.heading),
			renderState.debugTextFont,
			0, 10
		);
	}
}

SDL_Rect getRect(WorldLoc center, WorldDim dim, RenderState renderState) {
	center.y = -center.y;
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
