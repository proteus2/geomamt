h_menu = figure('Position',[330,300,250,140],...
            'Name','Plot Options',...
            'NumberTitle','off');

lims_old = lims;
theta_old = theta;

bgc = [.8,.8,.8];

uicontrol(gcf,'Style','frame',...
            'Position',[.02,.02,.96,.96],...
            'Units','normalized');
%
uicontrol(h_menu,'Style','text',...
             'String','Period Range',...
             'Units','normalized',...
             'Position',[0.05 0.85 .38 0.10],...
             'HorizontalAlignment','Center');
         
uicontrol(h_menu,'Style','text',...
             'String','App. Res. Range',...
             'Units','normalized',...
             'Position',[0.55 0.85 .38 0.10],...
             'HorizontalAlignment','Center');

h_lims = uicontrol(h_menu,'Style','edit',...
             'String',num2str(lims(1)),...
             'Units','normalized',...
             'Position',[0.05,.68,.18,.12],...
             'BackGroundColor',bgc,...
             'Callback',...
             'lims(1)=str2num(get(gco,''String''));');

h_lims = uicontrol(h_menu,'Style','edit',...
             'String',num2str(lims(2)),...
             'Units','normalized',...
             'Position',[0.25,.68,.18,.12],...
             'BackGroundColor',bgc,...
             'Callback',...
             'lims(2)=str2num(get(gco,''String''));');

h_lims = uicontrol(h_menu,'Style','edit',...
             'String',num2str(lims(3)),...
             'Units','normalized',...
             'Position',[0.55,.68,.18,.12],...
             'BackGroundColor',bgc,...
             'Callback',...
             'lims(3)=str2num(get(gco,''String''));');

h_lims = uicontrol(h_menu,'Style','edit',...
             'String',num2str(lims(4)),...
             'Units','normalized',...
             'Position',[0.75,.68,.18,.12],...
             'BackGroundColor',bgc,...
             'Callback',...
             'lims(4)=str2num(get(gco,''String''));');
             
uicontrol(h_menu,'Style','text',...
             'String','Rotation Angle',...
             'Units','normalized',...
             'Position',[0.20 0.50 .30 0.12],...
             'HorizontalAlignment','Center');

uicontrol(h_menu,'Style','edit',...
             'String',num2str(theta),...
             'Units','normalized',...
             'Position',[0.60,.50,.20,.12],...
             'BackGroundColor',bgc,...
             'Callback',...
             ['theta=str2num(get(gco,''String''));'...
              'MeasurementCoordinates = ( theta == th_x)']);
             
if DipoleSetup == 'MT   '
   uicontrol(h_menu,'Style','Pushbutton','String','Plot',...
             'Units','normalized',...
             'Position',[0.07 .30 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback','delete(h_menu);rpltmt;');
else
   uicontrol(h_menu,'Style','Pushbutton','String','Plot',...
             'Units','normalized',...
             'Position',[0.07 .30 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback','delete(h_menu);rpltem;');
end

uicontrol(h_menu,'Style','Pushbutton','String','Cancel',...
             'Units','normalized',...
             'Position',[0.37 .30 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback','lims=lims_old;theta=theta_old;delete(h_menu)');
             
if DipoleSetup == 'MT   '             
  uicontrol(h_menu,'Style','Pushbutton','String','Quit',...
             'Units','normalized',...
             'Position',[0.67 .30 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback','delete(h_menu);delete(hfig)');    
else
  uicontrol(h_menu,'Style','Pushbutton','String','Quit',...
             'Units','normalized',...
             'Position',[0.67 .30 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback',...
               'delete(h_menu);delete(hfig_xy);delete(hfig_yx)'); 
end   
  
if DipoleSetup == 'MT   '            
  uicontrol(h_menu,'Style','Pushbutton','String','New Plot',...
             'Units','normalized',...
             'Position',[0.37 .10 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback','delete(h_menu);delete(hfig);z_mtem');
else
  uicontrol(h_menu,'Style','Pushbutton','String','New Plot',...
             'Units','normalized',...
             'Position',[0.37 .10 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback',...
               'delete(h_menu);delete(hfig_xy);delete(hfig_yx),z_mtem');
end   

uicontrol(h_menu,'Style','Pushbutton','String','Add Band',...
             'Units','normalized',...
             'Position',[0.07 .10 0.26 0.12],...
             'BackgroundColor',bgc,...
             'Callback',' delete(h_menu);addband');               
