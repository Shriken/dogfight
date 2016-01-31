module state.state;

import state.sim_state;
import state.render_state;

class State {
	SimulationState simState = new SimulationState();
	RenderState renderState = new RenderState();
	double fps;
	bool running = true;
}
