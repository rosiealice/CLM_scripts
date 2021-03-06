
%%%%%%%%%%%%%%%%%%% Plots CLM(FATES) output for grass simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	    

close all
clear all

%command variables. 
npft=2	
ychoose=17 %year
mchoose=6 %month
vchoose=5 %variable
pchoose=[1:4] %iteration
maps=1
mkfigs=1
figdir='fates_grass_figures'
if(0==exist(figdir,'dir'))
  mkdir(figdir)
end


dirnames  = {'clmFATES_4x5_24sep17_c4grass_v4','clmFATES_4x5_24sep17_c4grass_v4_strppa','clmFATES_4x5_24sep17_c4grass_v4_fire','clmFATES_4x5_24sep17_c4grass_v4a',...
'clmFATES_4x5_24sep17_c4grass_v4b','clmFATES_4x5_28sep17_troptrees_v1','clmFATES_4x5_28sep17_troptrees_v2_strppa'}

 
dirnames  = {'clmFATES_4x5_24sep17_c4grass_v5_SLA','clmFATES_4x5_24sep17_c4grass_v5_SLA_RL','clmFATES_4x5_24sep17_c4grass_v5_SLA_RL_RS',...
'clmFATES_4x5_24sep17_c4grass_v5_SLA_RL_RS_SD','clmFATES_4x5_24sep17_c4grass_v5_SLA_RL_RS_SD_fire'}

arc=1
arcc = zeros(1,max(pchoose))+arc;
arcc = [1 1 1 1 ]

%subplot position function.(needs https://github.com/acmyers/chillerDataVisual/blob/master/subplot_pos.m)
plotheight = 10;plotwidth = 35;
subplotsx = npft;subplotsy = 1;
leftedge = 0.2;rightedge = 0.2;
topedge = 0.2;bottomedge = 0.2;
spacex = 0.15;spacey = 0.15;
fontsize = 5;
nploth = 2; nplotv = 1 %plots
sub_pos = subplot_pos(plotwidth, plotheight, leftedge, rightedge, bottomedge, topedge, subplotsx, subplotsy, spacex, spacey);


%output variables. 
u = 3600 * 24 * 365' %g/m2/s to g/m2/year
unit_conversion = [   u      u      1     1            1          u       1   ]
vars            = ({'GPP','TLAI','NPP','BTRAN','PFTleafbiomass','Qle','GCCANOPY'})
namevars        = ({'GPP','TLAI','NPP','BTRAN','PFTleafbiomass','Qle','GCCANOPY'})
dimvar          = [ 1     1      1       1       2               1       1   ]
miny            = [ 0     0      0       0       0               0       0   ]
maxy            = [ 3500  6      1200    1      100              1000      100 ]


for p=pchoose


dirname=char(dirnames(p))
%dirname = 'clmFATES_4x5_24sep17_c4grass_v4'


if (mkfigs == 1)
 % close all
  if (maps == 1)
    for v = vchoose
      maps1(v) = figure;
      set(gcf, 'position', [ 402         571        1321         531])
     
    end
    mkfigs = 1
  end
end
	      
if(arcc(p)==1)
  dir_clm = strcat('/glade/scratch/rfisher/archive/',dirname,'/lnd/hist/')
else
  dir_clm = strcat('/glade/scratch/rfisher/',dirname,'/run/')
end
mcount          = 0
for y = ychoose
   for m = mchoose
	   filen = strcat(dirname, '.clm2.h0.', num2str(y, '%04d'), '-', num2str(m, '%02d'), '.nc')
	   filename = strcat(dir_clm, filen)
	   mcount = mcount + 1

	   for v = vchoose
	     clear('rawvar')
	     rawvar = ncread(filename, char(vars(v)));
	     if(dimvar(v)==1)
	       montharray(v, m, :, :) = rawvar;
	       vm(v, m) = nansum(nansum(rawvar));
	       monthstore(i, v, mcount) = vm(v, m);
	     else
	       for pft=1:npft
	         montharray(v, m,pft, :, :) = rawvar(:,:,pft);
	       end 
	     end
	   end %vchoose
	end %month
end % year


for v = vchoose
  for pft=1:npft
    raw_array( v, pft,:, :) = sum(squeeze(montharray(v, :,pft, :, :)), 1) * unit_conversion(v)/length(mchoose);
  end
end


if (maps == 1)
   count(vchoose) = 1
   for v = vchoose
      figure(maps1(v))
      set(gcf, 'name',strcat(char(namevars(v)),dirname))
      clf(maps1(v));
      set(gcf, 'PaperUnits', 'centimeters');
      set(gcf, 'PaperSize', [plotwidth plotheight]);
      set(gcf, 'PaperPositionMode', 'manual');
      set(gcf, 'PaperPosition', [0 0 plotwidth plotheight]);
      pcount = 0;     
    
      mean_smp = zeros(72,46)
      for pft = 1:npft
         pcount = pcount + 1
         if(pcount>subplotsx)
           pc = pcount-subplotsx
           ic = 2
         else
           pc = pcount
           ic= 1
         end
          
         ax = axes('position', sub_pos{pc, ic}, 'XGrid', 'off', 'XMinorGrid', 'off', 'FontSize', fontsize, 'Box', 'on', 'Layer', 'top');

         count(v) = count(v) + 1
         vmap = squeeze(raw_array( v, pft, :, :))./squeeze(sum(squeeze(raw_array( v, 1:npft, :, :)),1));
         pcolor(vmap');
         set(gca, 'xticklabel', ({''}), 'yticklabel', ({''}), 'fontsize', 9)
         shading flat;
         ylim([8 44])
         set(gca,'Clim',[0 1])
         cb=colorbar('SouthOutside')
         lets = {'(a) ','(b) ','(c) ','(d) ','(e) '}
         t=text(10, 10,strcat(lets(pft),'PFT #',char(num2str(pft))))

      end %pft
      wysiwyg
      fnm = strcat(figdir, '/grass_',dirname,'_y',char(num2str(ychoose)))
      print(gcf, '-depsc2', '-loose', [fnm, '.jpeg']);

   end %v
end %maps


end %pchoose   

	
	
	

