from src.calculator import add, subtract, multiply, divide


def test_add():
    assert add(2, 3) == 5


def test_subtract():
    assert subtract(10, 7) == 3


def test_multiply():
    assert multiply(5, 5) == 25


def test_divide():
    assert divide(8, 2) == 4


def test_divide_by_zero():
    try:
        divide(5, 0)
        assert False
    except ValueError:
        assert True