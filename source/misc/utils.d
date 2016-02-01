module misc.utils;

T mod(T)(T x, T y) {
	auto val = x % y;
	if (val < 0) {
		val += y;
	}
	return val;
}
