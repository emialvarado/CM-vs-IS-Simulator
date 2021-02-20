# Reference: https://towardsdatascience.com/generating-pareto-distribution-in-python-2c2f77f70dbf

import math
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

# frequencies = [149, 213, 17, 42, 54, 36, 19, 22, 40, 247, 11, 218, 230,
#                277, 8, 53, 49, 52, 59, 158, 1, 0, 124, 12, 52, 17, 0, 35, 33, 7]
frequencies_breast_metastasis = [
    {'name': 'Adrenal', 'tumors': 149},
    {'name': 'Bone', 'tumors': 213},
    {'name': 'Bladder', 'tumors': 17},
    {'name': 'Brain', 'tumors': 42},
    {'name': 'Breast', 'tumors': 54},
    {'name': 'Diaphragm', 'tumors': 36},
    {'name': 'Gallblader', 'tumors': 19},
    {'name': 'Heart', 'tumors': 22},
    {'name': 'Kidney', 'tumors': 40},
    {'name': 'Lung', 'tumors': 247},
    {'name': 'Large intestine', 'tumors': 11},
    {'name': 'Liver', 'tumors': 218},
    {'name': 'Lymph nodes (reg)', 'tumors': 230},
    {'name': 'Lymph nodes (dist)', 'tumors': 277},
    {'name': 'Omentum', 'tumors': 8},
    {'name': 'Ovaries', 'tumors': 53},
    {'name': 'Pancreas', 'tumors': 49},
    {'name': 'Pericardium', 'tumors': 52},
    {'name': 'Peritoneum', 'tumors': 59},
    {'name': 'Pleura', 'tumors': 158},
    {'name': 'Prostate', 'tumors': 1},
    {'name': 'Skeletal muscle', 'tumors': 0},
    {'name': 'Skin', 'tumors': 124},
    {'name': 'Small intestine', 'tumors': 12},
    {'name': 'Splean', 'tumors': 52},
    {'name': 'Stomach', 'tumors': 17},
    {'name': 'Testos', 'tumors': 0},
    {'name': 'Thyroid', 'tumors': 35},
    {'name': 'Uterus', 'tumors': 33},
    {'name': 'Vagina', 'tumors': 7},
]
frequencies_breast_metastasis = sorted(
    frequencies_breast_metastasis, key=lambda i: i['tumors'], reverse=True)


def gen_test_samples(x_min, alpha):
    return (np.random.pareto(alpha, 10000) + 1) * x_min


def gen_samples_breast_metastasis():
    X = np.array([])

    for i in range(len(frequencies_breast_metastasis)):
        X = np.append(X, np.repeat(
            i + 1, frequencies_breast_metastasis[i]['tumors']))

    return X


def calc_exponent(X, x_min, x_max):
    n = 0
    sum = 0

    for x_i in X:
        if x_i >= x_min and x_i <= x_max:
            n += 1
            sum += math.log(x_i / x_min)

    print('n:', n, 'sum:', sum)

    return len(X) / sum


def show_graph(X, x_min, x_max, alpha):
    """drawing samples from distribution"""
    count, bins, _ = plt.hist(X, 100, color='gray', label=[
                              'Actual H band', 'Actual IRAC2 band'])

    X = np.array(X)
    X = X[X >= x_min]
    X = X[X <= x_max]
    # print('X:', X)

    for i in range(x_min-1, x_max):
        print('[' + str(i+1) + ']', 'Metastases site: ', frequencies_breast_metastasis[i]
              ['name'], 'tumors:', frequencies_breast_metastasis[i]['tumors'])

    count, bins, _ = plt.hist(X, 50)
    # print('count:', count, 'bins:', bins)

    fit = alpha*x_min**alpha / bins**(alpha+1)
    plt.plot(bins, max(count)*fit/max(fit), linewidth=2, color='r')

    plt.xlabel('Metastic Site', fontsize=15)
    plt.ylabel('Tumors', fontsize=15)
    plt.title('Metastases from breast primaries', fontsize=15)
    plt.grid(b=True, color='grey', alpha=0.3, linestyle='-.', linewidth=2)
    plt.rcParams['figure.figsize'] = [8, 8]
    plt.show()

    return X


x_min = 1
# X = gen_test_samples(x_min, 15.)
X = gen_samples_breast_metastasis()
# print('X:', X)

alpha = calc_exponent(X, x_min, 5)
print('alpha:', alpha)

show_graph(X, 1, 5, 0.000003)

stats.probplot(X, dist=stats.pareto, sparams=(alpha, x_min), plot=plt)
plt.show()
