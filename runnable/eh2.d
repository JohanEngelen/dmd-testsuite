// PERMUTE_ARGS: -fPIC

extern(C) int printf(const char*, ...);

class Abc : Throwable
{
    this()
    {
        super("");
    }
    static int x;
    int a,b,c;

    synchronized void test()
    {
	printf("test 1\n");
	x |= 1;
	foo();
	printf("test 2\n");
	x |= 2;
    }

    shared void foo()
    {
	printf("foo 1\n");
	x |= 4;
	throw this;
	printf("foo 2\n");
	x |= 8;
    }
}

int main()
{
    printf("hello world\n");
    auto a = new shared(Abc)();
    printf("hello 2\n");
    Abc.x |= 0x10;

    try
    {
	Abc.x |= 0x20;
	a.test();
	Abc.x |= 0x40;
    }
    catch (shared(Abc) b)
    {
	Abc.x |= 0x80;
	printf("Caught %p, x = x%x\n", b, Abc.x);
	assert(a is b);
	assert(Abc.x == 0xB5);
    }
    printf("Success!\n");
    return 0;
}
