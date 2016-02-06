module state.render_state;

import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import std.format;

import misc.resources;
import types;
import render_utils;

static this() {
	DerelictSDL2.load();
}

class RenderState {
	RenderDim windowDimensions = RenderDim(1200, 800);
	SDL_Window *window = null;
	SDL_Renderer *renderer = null;

	bool debugRender = false;

	double scale = 1;
	TTF_Font *debugTextFont = null;

	void init() {
		// set up sdl
		if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER) < 0) {
			throw new Exception(
				format("SDL_Init failed: %s", SDL_GetError())
			);
		}

		// create game window
		window = SDL_CreateWindow(
			"Petri dish",
			SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED,
			windowDimensions.x,
			windowDimensions.y,
			SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
		);
		if (window is null) {
			throw new Exception(
				format("couldn't create window: %s", SDL_GetError())
			);
		}

		SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN_DESKTOP);
		SDL_GetWindowSize(
			window,
			&windowDimensions.x,
			&windowDimensions.y
		);

		// determine the scale we're working at
		int x, y;
		SDL_GL_GetDrawableSize(window, &x, &y);
		auto xScale = 1. * x / windowDimensions.x;
		auto yScale = 1. * y / windowDimensions.y;
		assert(xScale == yScale);
		scale = xScale;

		// initialize the renderer
		renderer = SDL_CreateRenderer(window, -1, 0);
		SDL_RenderSetScale(renderer, scale, scale);
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);

		// set up sdl_ttf
		DerelictSDL2ttf.load();
		if (TTF_Init() != 0) {
			throw new Exception(
				format("failed to init ttf: %s", TTF_GetError())
			);
		}

		// load fonts
		debugTextFont = TTF_OpenFont(
			getResourcePath("monaco.ttf").dup.ptr,
			10
		);
		if (debugTextFont is null) {
			throw new Exception("debug text font not present");
		}
	}
}
