import math
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

aumento_tumor = 2
ticks = 20

def logistic(x):
    a = aumento_tumor - 1
    k = 9   # Tasa de crecimiento
    x0 = 0.4  # Valor x del punto medio del sigmoide 

    return 1 + ( a / (1. + math.e ** (-k * (x - x0))) )


def gauss_aux(x):
    y_log = logistic(x)
    y_gauss = np.array([])

    y_gauss = np.append(y_gauss, [1])

    for i in range(len(y_log) - 1):
        y_gauss = np.append(y_gauss, [ y_log[i + 1] / y_log[i] ])

    return y_gauss


def gauss(x):
    a = max(gauss_aux(x)) - 1   # Max value
    b = 0.4         # Valor 'x' donde 'y' es maximo
    c = 0.19                # Desviacion estandar
    print('a', a)
    result = a * math.e ** (-(x-b)**2 / (2*c**2))

    return 1 + result


def logistic_aux(x):
    cells = 100
    result = np.array([])

    g = gauss(x)

    print('g', g)

    for gi in g:
        result = np.append(result, cells)
        cells *= gi

    return result


x = np.linspace(0, 1, ticks)

# print(x, logistic(x))
# plt.plot(x, logistic(x), linewidth=2, color='b')


plt.plot(x, logistic_aux(x), linewidth=2, color='g')

# print(x, gauss_aux(x))
# plt.plot(x, gauss_aux(x), linewidth=2, color='b')
# plt.plot(x, gauss(x), linewidth=2, color='r')

plt.grid(b=True, color='grey', alpha=0.3, linestyle='-.', linewidth=2)
# plt.axis('equal')
plt.show()
