import numpy as np

N = 8

nTumor = 91
nTan2 = 12
nTam2 = 18

nNeutrophil = 91
nTan1 = 2
nMacrophage = 8
nTam1 = 13
nNaturalkiller = 73

n = np.array([nTumor, nNeutrophil, nTan1, nTan2,
              nMacrophage, nTam1, nTam2, nNaturalkiller])
c = np.array([-1, 1, 1, -1, 1, 1, -1, 1])
h = np.array([1, 1, 1, 1, 1, 1, 1, 1])

Q = np.array([[0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
              [1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0],
              [1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0],
              [1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0],
              [1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0],
              [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0],
              [1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0],
              [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]])

P = np.array([[     0,  0.8,  0.485,  0.515,  0.89,  0.45,  0.55,  0.81 ],
              [   0.8,    0,    0.5,    0.5,     0,     0,     0,     0 ],
              [ 0.485,  0.5,      0,    0.5,     0,     0,     0,     0 ],
              [ 0.515,  0.5,    0.5,      0,     0,     0,     0,     0 ],
              [  0.89,    0,      0,      0,     0,   0.5,   0.5,     0 ],
              [  0.45,    0,      0,      0,   0.5,     0,   0.5,     0 ],
              [  0.55,    0,      0,      0,   0.5,   0.5,     0,     0 ],
              [  0.81,    0,      0,      0,     0,     0,     0,     0 ]])

x = n * c
W = Q * P

print(W)

sum1 = 0
sum2 = 0

for i in range(N):
    for j in range(N):
        if abs(x[i]) > abs(x[j]):
            sum1 += W[i, j] * x[i] * abs(x[j])
        else:
            sum1 += W[i, j] * abs(x[i]) * x[j]

    sum2 += h[i] * x[i]


H = (-1/2) * sum1 - sum2


if H > 0:
    print('Cancer vence.')
elif H < 0:
    print('Sist. inmune vence')
else:
    print('Empate')


print('H:', H)
print('    sum1: ', sum1, 'sum2', sum2)
