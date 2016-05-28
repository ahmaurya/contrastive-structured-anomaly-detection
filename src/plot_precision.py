#!/usr/bin/env python
# a bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

matplotlib.rcParams.update({'font.size': 15})

N = 2
means = (17.59012047, 22.56129616)
std = (0.04499697327, 0.05630040717)

ind = np.arange(N)  # the x locations for the groups
width = 0.5       # the width of the bars

fig, ax = plt.subplots()
rects1 = ax.bar(ind, means, width, color='r', yerr=std)

# add some text for labels, title and axes ticks
ax.set_ylabel('Precision')
ax.set_title('Precision of Contrastive GGM versus Baseline')
ax.set_xticks(ind+width/2)
ax.set_xticklabels( ('Baseline', 'Contrastive GGM') )


plt.show()