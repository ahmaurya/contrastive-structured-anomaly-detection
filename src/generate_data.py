from optparse import OptionParser, Option
import numpy as np
from sklearn.datasets import make_sparse_spd_matrix

parser = OptionParser()
parser.add_option("-n", "--nodes", dest="nodes", type="int", default=10, help="Number of nodes")
parser.add_option("-s", "--bkgrnd_sparsity", dest="bkgrnd_sparsity", type="float", default=0.95, help="Sparsity of generated precision matrix")
parser.add_option("-d", "--delta_sparsity", dest="delta_sparsity", type="float", default=0.95, help="Sparsity of generated delta precision matrix")
parser.add_option("-b", "--bkgrnd_datapoints", dest="bkgrnd_datapoints", type="int", default=100000, help="Number of background datapoints")
parser.add_option("-f", "--foregrnd_datapoints", dest="foregrnd_datapoints", type="int", default=100000, help="Number of foreground datapoints")
(options, args) = parser.parse_args()

mean = [0.0 for n in range(options.nodes)]
bkgrnd_prec = make_sparse_spd_matrix(options.nodes, alpha=options.bkgrnd_sparsity, smallest_coef=0.5, largest_coef=0.9, random_state=np.random.RandomState(1), norm_diag=True)
delta_prec = make_sparse_spd_matrix(options.nodes, alpha=options.delta_sparsity, smallest_coef=0.5, largest_coef=0.9, random_state=np.random.RandomState(100), norm_diag=True)
foregrnd_prec = bkgrnd_prec + delta_prec
bkgrnd_cov = np.linalg.inv(bkgrnd_prec)
foregrnd_cov = np.linalg.inv(foregrnd_prec)
bkgrnd_data = np.random.multivariate_normal(mean,bkgrnd_cov,options.bkgrnd_datapoints)
foregrnd_data = np.random.multivariate_normal(mean,foregrnd_cov,options.foregrnd_datapoints)

np.savetxt('mean.csv', mean, delimiter=',')
np.savetxt('bkgrnd_prec.csv', bkgrnd_prec, delimiter=',')
np.savetxt('delta_prec.csv', delta_prec, delimiter=',')
np.savetxt('foregrnd_prec.csv', foregrnd_prec, delimiter=',')
np.savetxt('bkgrnd_data.csv', bkgrnd_data, delimiter=',')
np.savetxt('foregrnd_data.csv', foregrnd_data, delimiter=',')