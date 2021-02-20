import math
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

max = 10

def gauss(x):
    a = 100
    b = max * (2./5.)
    c = 2.7 #2

    result = a * math.e ** (-(x-b)**2 / (2*c**2))

    return result

def normal_dist(x):
    u = 0
    sigma = 1

    exp = - (1.0 / 2.0) * (((x - u) / sigma) ** 2.0)
    return ( 1.0 / (sigma * math.sqrt(2.0 * math.pi)) ) * (math.e ** exp)


def test(x):
    nd = normal_dist(x)
    val = 0

    for xi in nd:
        val += xi

    print(val)

# print(gauss(0))

x = np.linspace(0, 10, 1000000)

# test(x)

plt.plot(x, gauss(x), linewidth=2, color='r')
plt.grid(b=True, color='grey', alpha=0.3, linestyle='-.', linewidth=2)
# plt.axis('equal')
plt.show()