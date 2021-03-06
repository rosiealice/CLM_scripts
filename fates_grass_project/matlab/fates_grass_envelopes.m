
%%%%%%%%%%%%%%%%%%% Plots CLM(FATES) output for grass simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	    

%close all
clear all

%command variables. 
npft=2
ychoose=9 %year
mchoose=1:12 %month
vchoose=[1 2 3 5] %variable
pchoose=[1:7] %iteration
maps=0
mkfigs=1
figdir='fates_grass_figures'
if(0==exist(figdir,'dir'))
  mkdir(figdir)
end
envelopes = 1


dirnames  = {'clmFATES_4x5_24sep17_c4grass_v4','clmFATES_4x5_24sep17_c4grass_v4_strppa','clmFATES_4x5_24sep17_c4grass_v4_fire','clmFATES_4x5_24sep17_c4grass_v4a',...
'clmFATES_4x5_24sep17_c4grass_v4b','clmFATES_4x5_28sep17_troptrees_v1','clmFATES_4x5_28sep17_troptrees_v2_strppa'}


 
%subplot position function.(needs https://github.com/acmyers/chillerDataVisual/blob/master/subplot_pos.m)
plotheight = 10;plotwidth = 35;
subplotsx = npft;subplotsy = 1;
leftedge = 0.2;rightedge = 0.2;
topedge = 0.2;bottomedge = 0.2;
spacex = 0.2;spacey = 0.2;
fontsize = 5;
nploth = 2; nplotv = 1 %plots
sub_pos = subplot_pos(plotwidth, plotheight, leftedge, rightedge, bottomedge, topedge, subplotsx, subplotsy, spacex, spacey);


%output variables. 
u = 3600 * 24 * 365' %g/m2/s to g/m2/year
unit_conversion = [   u      u      1     1            1          u       1   ]
vars            = ({'RAIN','SNOW','TV','BTRAN','PFTbiomass','Qle','GCCANOPY'})
namevars        = ({'RAIN','SNOW','TV','BTRAN','PFTbiomass','Qle','GCCANOPY'})
dimvar          = [ 1     1      1       1       2               1       1   ]
miny            = [ 0     0      0       0       0               0       0   ]
maxy            = [ 3500  6      1200    1      100              1000      100 ]
if (mkfigs == 1)
 % close all
  if (envelopes == 1)  
    env1 = figure;
    %set(gcf, 'position', [ 402         571        1321         531])
    mkfigs = 1
  end
end

for p=pchoose


dirname=char(dirnames(p))
%dirname = 'clmFATES_4x5_24sep17_c4grass_v4'
arc=1


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

arcc = zeros(1,max(pchoose))+arc;
arcc = [ 1 1 1 1 1 0  0 ]	
%montharray(v, m, :, :) = zeros(max(vchoose),max(mchoose), 
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
	       montharray1(v, m, :, :) = rawvar;
	       vm(v, m) = nansum(nansum(rawvar));
	       monthstore(v, mcount) = vm(v, m);
	     else
	       for pft=1:npft
	         montharray2(v, m,pft, :, :) = rawvar(:,:,pft);
	       end 
	     end
	   end %vchoose
	end %month
end % year

for v = vchoose
  if(dimvar(v)==1)	     
    raw_array( v, 1,:, :) = sum(squeeze(montharray1(v, :, :, :)), 1) * unit_conversion(v)/length(mchoose);
  else
    for pft=1:npft
      raw_array( v, pft,:, :) = sum(squeeze(montharray2(v, :,pft, :, :)), 1) * unit_conversion(v)/length(mchoose);
    end
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
col = {'r.','b.'}



if(envelopes==1)
      figure(env1)
      set(gcf, 'name',strcat(char(namevars(v)),dirname))
      %clf(maps1(v));
     
      pcount = 0;     
      for pft = 1 %:npft
         pcount = pcount+1  
         if(pcount>subplotsx)
           pc = pcount-subplotsx
           ic = 1
         else
           pc = pcount
           ic= 1
         end      
           
         %ax = axes('position', sub_pos{pc, ic}, 'XGrid', 'off', 'XMinorGrid', 'off', 'FontSize', fontsize, 'Box', 'on', 'Layer', 'top');
         subplot(2,ceil(length(pchoose)/2),p)
         text(250,4000,(char(dirnames(p))))
         temp = squeeze(raw_array( 3, 1, :, :))
         prec =  squeeze(raw_array( 1, 1, :, :))+ squeeze(raw_array( 3, pft, :, :))
         vmap = squeeze(raw_array( 5, pft, :, :))./squeeze(sum(squeeze(raw_array(5, 1:npft, :, :)),1));
         p1=find(vmap>0.6);pn=find(vmap>0.4);p2=find(vmap<0.4);p3 = find(vmap(pn)<0.6)
         %plot(temp,prec,'bo');hold on
         plot(temp(p1),prec(p1),'r.');hold on
         plot(temp(p2),prec(p2),'b.');hold on
         plot(temp(pn(p3)),prec(pn(p3)),'g.');hold on
         axis tight
      end %pft
   end%pchoose  
  
end %pchoose

if(envelopes==1)
 wysiwyg
   fnm = strcat(figdir, '/grass_envelope_y',char(num2str(ychoose)))
   print(gcf, '-depsc2', '-loose', [fnm, '.jpeg']);
 end
 

	
	
	

