#define function%0(%1) \
	forward %0(%1); \
	public %0(%1)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))