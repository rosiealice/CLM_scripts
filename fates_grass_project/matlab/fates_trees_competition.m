% Parameter file modifier for FATES

% where is the default parameter file?

template = '/glade/u/home/rfisher/Matlab/fates_pft_files/fates_params_2troppftclones.c170913.nc'

filename = 'fates_grass_pftfiles/fates_params_2troptrees_strppa.c280913.nc'

copyfile(template,filename)

fates_seed_alloc = [0.107 0.286]
fates_root_long = 1./([50 30.9]/100) %(% per year to year) 
fates_allom_l2fr = 1./[0.91 0.72] %(BNPP:ANPP to leaf:fineroot
fates_slatop = ([19.6 22.9]/1000)  % mm2 /mg to m2/g
fates_leaf_stor_priority = [0.4 0.4]
fates_comp_excln = -1

ncwrite(filename,'fates_seed_alloc',fates_seed_alloc)
ncwrite(filename,'fates_allom_l2fr',fates_allom_l2fr)
ncwrite(filename,'fates_root_long',fates_root_long)
ncwrite(filename,'fates_slatop',fates_slatop)
ncwrite(filename,'fates_leaf_stor_priority',fates_leaf_stor_priority)
ncwrite(filename,'fates_comp_excln',fates_comp_excln)

