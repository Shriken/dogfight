module render_utils;

import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import std.conv;
import std.stdio;

import state.render_state;

auto WHITE = SDL_Color(0xff, 0xff, 0xff, 0xff);

void setRenderDrawColor(SDL_Renderer *renderer, SDL_Color color) {
	SDL_SetRenderDrawColor(
		renderer,
		color.r,
		color.g,
		color.b,
		color.a
	);
}

void drawText(
	RenderState state,
	string text,
	TTF_Font *font,
	int x,
	int y
) {
	state.drawText(text.dup ~ '\0', font, x, y);
}

void drawText(
	RenderState state,
	char[] text,
	TTF_Font *font,
	int x,
	int y
) {
	auto textTexture = state.getTextTexture(text, font, WHITE);
	if (textTexture is null) {
		writeln(to!string(SDL_GetError()));
		return;
	}

	int w, h;
	SDL_QueryTexture(textTexture, null, null, &w, &h);
	auto targetLoc = SDL_Rect(x, y, w, h);
	SDL_RenderCopy(state.renderer, textTexture, null, &targetLoc);
	SDL_DestroyTexture(textTexture);
}

SDL_Texture *getTextTexture(
	RenderState state,
	char[] text,
	TTF_Font *font,
	SDL_Color color
) {
	auto textSurface = TTF_RenderText_Solid(font, text.ptr, color);
	if (textSurface is null) {
		writeln(to!string(SDL_GetError()));
		return null;
	}
	scope(exit) SDL_FreeSurface(textSurface);

	auto textTexture = SDL_CreateTextureFromSurface(
		state.renderer,
		textSurface
	);
	if (textTexture is null) {
		writeln(to!string(SDL_GetError()));
		return null;
	}

	return textTexture;
}
