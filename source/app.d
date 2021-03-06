import core.thread;
import derelict.sdl2.sdl;
import std.algorithm;
import std.datetime;
import std.path;
import std.stdio;

import event;
import misc.resources;
import render : render;
import update : update;
import state.state;

const int MICROS_PER_SECOND = 1_000_000;
const int TICKS_PER_SECOND = 60;
const int MICROS_PER_TICK = MICROS_PER_SECOND / TICKS_PER_SECOND;
const int SLEEP_THRESHOLD = 1_000;

void main(string[] args) {
	setBasePath(buildNormalizedPath(args[0], ".."));

	auto state = new State();
	state.renderState.init();

	while (state.running) {
		// cap ticks-per-second
		auto mt = measureTime!((TickDuration duration) {
			state.fps = min(
				MICROS_PER_SECOND / (cast(double)duration.usecs),
				TICKS_PER_SECOND
			);

			auto usecsLeft = MICROS_PER_TICK - duration.usecs;
			if (usecsLeft > SLEEP_THRESHOLD) {
				Thread.sleep(dur!"usecs"(usecsLeft));
			}
		});

		// handle event queue
		SDL_Event event;
		while (SDL_PollEvent(&event) != 0) {
			state.handleEvent(event);
		}

		// update and render
		if (!state.simState.paused) {
			state.simState.update();
		}
		state.render();
	}
}
