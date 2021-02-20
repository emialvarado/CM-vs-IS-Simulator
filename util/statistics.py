#!/usr/bin/python3
import os
import numpy as np
import matplotlib.pyplot as plt
from cycler import cycler
from scipy import stats
import sys

if len(sys.argv) != 2:
    print("Example use: ./statistics.py strong-strong")
    exit()

is_cancer_strength = sys.argv[1]

dirs = ['CM_IS_simulation/log/']
out_dir = 'statistics/' + is_cancer_strength + '/'
# tumors = ['primary_tumor', 'bone', 'liver', 'lung']
tumors = ['primary_tumor']
cols = ['Hamilton Tumor', 'Hamilton IS', 'Hamilton']
ticks = 1 + 30

np.set_printoptions(precision=4)
# plt.rcParams['axes.prop_cycle'] = cycler(
#     'color', ['#1f77b4', '#8c564b', '#ff7f0e', '#196F3D', '#33FF52', '#d62728'])
plt.rcParams['axes.prop_cycle'] = cycler(
    'color', ['blue', 'red', 'orange'])


def calc_ticks():
    global ticks
    levels = is_cancer_strength.split('-')
    is_level = 0
    cancer_level = 0

    if levels[0] == 'weak':
        is_level = 0
    elif levels[0] == 'media':
        is_level = 1
    else:
        is_level = 2

    if levels[1] == 'weak':
        cancer_level = 0
    elif levels[1] == 'media':
        cancer_level = 1
    else:
        cancer_level = 2

    diff_level = abs(is_level - cancer_level)
    if (diff_level == 2):
        ticks += 20
    elif (diff_level == 1):
        ticks += 25
    else:
        ticks += 30


# calc_ticks()


def read_data_from_file(filename):
    # tumor-cells, tan1-cells, tan2-cells, tam1-cells, tam2-cells, natural-killers
    data = np.zeros((len(cols), ticks))
    j = 0

    # print('File:', filename)
    f = open(filename, "r")
    lines = f.readlines()

    startRead = False

    for line in lines:
        if 'time' in line:
            # print(line)
            values = line.split(",")
            for i in range(len(cols)):
                data[i, j] = values[i + 1]
            j += 1

    f.close()
    return data


def read_data_from_directory(dir):
    data = np.array([])
    files = []

    for r, d, f in os.walk(dir):
        for file in f:
            if '.csv' in file and 'Hamilton' in file:
                files.append(os.path.join(r, file))

    for filename in files:
        # data.append()
        if data.size == 0:
            data = np.array([read_data_from_file(filename)])
        else:
            data = np.append(data, [read_data_from_file(filename)], axis=0)
    # print(data)
    print(str(len(files)) + '\tfiles in ' + dir)

    return data


def get_mean_data(data_files):
    # tumor-cells, tan1-cells, tan2-cells, tam1-cells, tam2-cells, natural-killers
    data = np.zeros((len(cols), ticks))

    if len(data_files) != 0:
        for i in range(len(cols)):
            for j in range(ticks):
                data[i, j] = np.mean(data_files[:, i, j])

        return data

    return []


def get_mode_data(data_files):
    # tumor-cells, tan1-cells, tan2-cells, tam1-cells, tam2-cells, natural-killers
    data = np.zeros((len(cols), ticks))

    if len(data_files) != 0:
        for i in range(len(cols)):
            for j in range(ticks):
                data[i, j] = stats.mode(data_files[:, i, j])[0][0]

        return data

    return []


def get_std_data(data_files):
    # tumor-cells, tan1-cells, tan2-cells, tam1-cells, tam2-cells, natural-killers
    data = np.zeros((len(cols), ticks))

    if len(data_files) != 0:
        for i in range(len(cols)):
            for j in range(ticks):
                data[i, j] = np.std(data_files[:, i, j])

        return data

    return []


def get_median_data(data_files):
    # tumor-cells, tan1-cells, tan2-cells, tam1-cells, tam2-cells, natural-killers
    data = np.zeros((len(cols), ticks))

    if len(data_files) != 0:
        for i in range(len(cols)):
            for j in range(ticks):
                data[i, j] = np.median(data_files[:, i, j])

        return data

    return []


def export_data(data, filename):
    if os.path.exists(filename):
        os.remove(filename)

    if len(data) > 0:
        f = open(filename, "w")

        for col in cols:
            f.write(col + ',')
        f.write('\n')

        for j in range(ticks):
            for i in range(len(cols)):
                f.write('%.4f' % data[i, j])
                if i != 5:
                    f.write(",")
            f.write("\n")

        f.close()


def gen_graph(data, title):
    plt.title(title)
    plt.plot(np.transpose(data))
    plt.legend(cols)
    plt.xlabel('Ticks')
    plt.ylabel('Hamilton')


def gen_bar_graph(data, title):
    labels = ['IS', 'Cancer', 'Draws']

    plt.margins(0, 0.15)
    plt.title(title)
    plt.bar(labels, data, color=['#FF000080', '#0000FF80', 'orange'])

    for index, value in enumerate(data):
        plt.text(index, value + 0.5, str(value))

    plt.xlabel('Winner')
    plt.ylabel('Times won')


def export_graph(filename):
    plt.savefig(filename, dpi=None, facecolor='w', edgecolor='w',
                orientation='portrait', format=None,
                transparent=False, bbox_inches=None, pad_inches=0.1,
                metadata=None)
    plt.close()


def create_dirs():
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)


def get_hamilton(dir):
    files = []
    is_winner = 0
    cancer_winner = 0
    draw = 0

    for r, d, f in os.walk(dir):
        for file in f:
            if '.csv' in file and 'Hamilton' in file:
                files.append(os.path.join(r, file))

    for filename in files:
        f = open(filename, "r")
        lines = f.readlines()
        hamilton = 0.0

        for line in lines:
            if 'time'.lower() in line.lower():
                hamilton = float(line.split(',')[3])

        if hamilton > 0.0:
            cancer_winner += 1
        elif hamilton < 0.0:
            is_winner += 1
        else:
            draw += 1

    return is_winner, cancer_winner, draw


create_dirs()

for dir in dirs:
    for tumor in tumors:
        data = read_data_from_directory(dir + tumor)
        # print(data)

        plt.figure('CM_IS - ' + tumor, figsize=[6.4*1.7, 4.8*1.7])
        plt.title('CM_IS - ' + tumor)
        plt.subplots_adjust(hspace=0.5)

        mean_data = get_mean_data(data)
        export_data(mean_data, out_dir + 'mean_' + tumor + '.csv')
        plt.subplot(321)
        gen_graph(mean_data, tumor +
                  ' (' + is_cancer_strength + ')' + ' - Mean')

        mode_data = get_mode_data(data)
        export_data(mode_data, out_dir + 'mode_' + tumor + '.csv')
        plt.subplot(322)
        gen_graph(mode_data, tumor +
                  ' (' + is_cancer_strength + ')' + ' - Mode')

        median_data = get_median_data(data)
        export_data(median_data, out_dir + 'median_' + tumor + '.csv')
        plt.subplot(323)
        gen_graph(median_data, tumor +
                  ' (' + is_cancer_strength + ')' + ' - Median')

        std_data = get_std_data(data)
        export_data(std_data, out_dir + 'std_' + tumor + '.csv')
        plt.subplot(324)
        gen_graph(std_data, tumor + ' (' + is_cancer_strength + ')' + ' - STD')

        is_winner, cancer_winner, draw = get_hamilton(dir + 'primary_tumor')
        plt.subplot(325)
        gen_bar_graph([is_winner, cancer_winner, draw], tumor +
                      ' (' + is_cancer_strength + ')' + ' - Winners')

        # plt.show()
        export_graph(out_dir + 'CM_IS - ' + tumor + '_' + is_cancer_strength)
