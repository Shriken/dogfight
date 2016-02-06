module misc.utils;

const double EPSILON = 0.000001;

T mod(T)(T x, T y) {
	auto val = x % y;
	if (val < 0) {
		val += y;
	}
	return val;
}
