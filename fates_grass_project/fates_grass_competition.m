% Parameter file modifier for FATES

% where is the default parameter file?

template = 'fates_params_2troppftclones.c170913.nc'

filename = 'fates_params_2C4grasses.c200913.nc'

copyfile(template,filename)

fates_seed_alloc = [0.107 0.286]
fates_clone_alloc = 1- fates_seed_alloc;
fates_max_dbh   = [0.15 0.15]
fates_c3psn = [0 0 ]
fates_initd= [5 5]
fates_vcmax25top=[34 34]
fates_leafcn=[29 29]
fates_root_long = 1./([50 30.9]/100) %(% per year to year) 
fates_allom_l2fr = 1./[0.91 0.72] %(BNPP:ANPP to leaf:fineroot
fates_slatop = ([19.6 22.9]/1000)  % mm2 /mg to m2/g
fates_woody =[0 0 ]
fates_allom_agb1 = [0.001 0.001 ]
fates_leaf_stor_priority = [0.4 0.4]

ncwrite(filename,'fates_c3psn',fates_c3psn)
ncwrite(filename,'fates_woody',fates_woody)
ncwrite(filename,'fates_seed_alloc',fates_seed_alloc)
ncwrite(filename,'fates_clone_alloc',fates_clone_alloc)
ncwrite(filename,'fates_max_dbh',fates_max_dbh)
ncwrite(filename,'fates_initd',fates_initd)
ncwrite(filename,'fates_vcmax25top',fates_vcmax25top)
ncwrite(filename,'fates_leafcn',fates_leafcn)
ncwrite(filename,'fates_allom_l2fr',fates_allom_l2fr)
ncwrite(filename,'fates_slatop',fates_slatop)
ncwrite(filename,'fates_allom_agb1',fates_allom_agb1)
ncwrite(filename,'fates_leaf_stor_priority',fates_leaf_stor_priority)


