function flag = trans_script(infilePath, Unit)
    %infilePath = 'C:\Users\Administrator\Desktop\cst_api\test2.vbs';
    infilePath = 'C:\Users\Administrator\Desktop\cst_api\cst_sample\waveguide\Model\3D\Model.mod'
    addpath('C:/Users/Administrator/Desktop/hfss-api-master'); % add manually the API root directory.
    hfssIncludePaths('C:/Users/Administrator/Desktop/hfss-api-master/src/');
    Unit = 'mm';
    fid1 = fopen([pwd,'\hfssScript.vbs'], 'wt');
    hfssNewProject(fid1);
    hfssInsertDesign(fid1, 'transfertype');
    Axis = {'X', 'Y', 'Z'};
    flag = 0;
    fid = fopen(infilePath, 'r');    
    C = textscan(fid, '%s', 'Delimiter', '');
    fclose(fid);
    C = C{1};
    Bindex = strfind(C,'With Brick');
    Bindex = find(~cellfun(@isempty,Bindex));
    % Lindex = strfind(C,'With Layer');
    % Lindex = find(~cellfun(@isempty,Lindex));
    Cyindex = strfind(C,'With Cylinder');
    Cyindex = find(~cellfun(@isempty,Cyindex));
    Sindex = strfind(C,'With Sphere');
    Sindex = find(~cellfun(@isempty,Sindex));
    Ceindex = strfind(C,'With Cone');
    Ceindex = find(~cellfun(@isempty,Ceindex));
	Lindex = strfind(C,'With Loft');
    Lindex = find(~cellfun(@isempty,Lindex));
    
    Eindex = strfind(C,'End With');
    Eindex = find(~cellfun(@isempty,Eindex));
    
    Pindex = strfind(C,'PickFaceFromId');
    Pindex = find(~cellfun(@isempty,Pindex));
    
	BooAindex = strfind(C,'Solid.Add');
    BooAindex = find(~cellfun(@isempty,BooAindex));
    
    Structindex = sort([Bindex;Cyindex;Ceindex;Sindex;Lindex]);
    
    Finalindex=sort([Structindex;BooAindex;Pindex]);
	name=cell(size(Structindex,1),2);
	name_hfss=name;
    component=cell(size(Structindex,1),1);
    i=0;
    j=0;
    name_index=0;
    Modelindex=0;    
    target_index = 0;    
    target = cell(2,5);    
    while(i<=size(Finalindex,1)-1) 
        i=i+1;  
        Shape = 0;
		axisIndex = 0;                        
        k = Finalindex(i);
        if(find(Structindex == k))
            Modelindex=Modelindex+1;%"End With"
            name_index=name_index+1;
            if(~isempty(strfind(C{k}, 'With Brick')))                
                %Shape = 1; 
                display(C{k});
                while(k < Eindex(Modelindex))                    
                    k=k+1;            
                    display(C{k});   
                    if(~isempty(strfind(C{k}, 'Name')))	
                        name{name_index,1} = regexp(C{k}, '\"(.+?)\"', 'match');  
                        name{name_index,1} = strrep(name{name_index,1},'"','');
                        name{name_index,2} = k;
						name_hfss{Modelindex} = k; 
                        name_hfss{Modelindex,2} = num2str(Modelindex);                        
                    elseif(~isempty(strfind(C{k}, 'Component')))	
                        component{Modelindex} = regexp(C{k}, '\"(.+?)\"', 'match');
                        component{Modelindex} = strrep(component{Modelindex},'"','');
                    elseif(~isempty(strfind(C{k}, '.Xrange')))
                        xPa = regexp(C{k}, '\"(.+?)\"','match');
                        xPa = strrep(xPa,'"','');
                        xPa = [str2double(xPa(1)), str2double(xPa(2))] ;                         
                        
                    elseif(~isempty(strfind(C{k}, '.Yrange')))                        
                        yPa = regexp(C{k}, '\"(.+?)\"','match');
                        yPa = strrep(yPa,'"','');
                        yPa = [str2double(yPa(1)), str2double(yPa(2))] ;                        
                        
                    elseif(~isempty(strfind(C{k}, '.Zrange'))) 
                        zPa = regexp(C{k}, '\"(.+?)\"','match');
                        zPa = strrep(zPa,'"','');
                        zPa = [str2double(zPa(1)), str2double(zPa(2))];                        
                    else 
                    end                    
                end 
                hfssBox(fid1, char(name_hfss{Modelindex,2}), [xPa(1),yPa(1),zPa(1)], [xPa(2)-xPa(1), yPa(2)-yPa(1), zPa(2)-zPa(1)],  Unit); 
		   	elseif(~isempty(strfind(C{k}, 'With Loft')))										
                while(k <= Eindex(Modelindex))
                    display(C{k});
                    k=k+1;
                    if(~isempty(strfind(C{k}, '.Name')))	
                        name{name_index,1} = regexp(C{k}, '\"(.+?)\"', 'match');  
                        name{name_index,1} = strrep(name{name_index,1},'"','');
                        name{name_index,2} = k;
						name_hfss{Modelindex} = k; 
                        name_hfss{Modelindex,2} = num2str(Modelindex); 
                    elseif(~isempty(strfind(C{k}, '.Component')))	
                        component{Modelindex} = regexp(C{k}, '\"(.+?)\"', 'match');
                        component{Modelindex} = strrep(component{Modelindex},'"','');
                    end
                end           
                TxPa_1 = regexp(C{target{1,2}+3}, '\"(.+?)\"','match');
                TxPa_1 = strrep(TxPa_1,'"','');
                TxPa_1 = [str2double(TxPa_1(1)), str2double(TxPa_1(2))] ;                                           
                TyPa_1 = regexp(C{target{1,2}+4}, '\"(.+?)\"','match');
                TyPa_1 = strrep(TyPa_1,'"','');
                TyPa_1 = [str2double(TyPa_1(1)), str2double(TyPa_1(2))] ;                       
                TzPa_1 = regexp(C{target{1,2}+5}, '\"(.+?)\"','match');
                TzPa_1 = strrep(TzPa_1,'"','');                
                TzPa_1 = [str2double(TzPa_1(1)), str2double(TzPa_1(2))]; 
                T_1 = [TxPa_1,TyPa_1,TzPa_1];
                TxPa_2 = regexp(C{target{2,2}+3}, '\"(.+?)\"','match');
                TxPa_2 = strrep(TxPa_2,'"','');
                TxPa_2 = [str2double(TxPa_2(1)), str2double(TxPa_2(2))] ;                                           
                TyPa_2 = regexp(C{target{2,2}+4}, '\"(.+?)\"','match');
                TyPa_2 = strrep(TyPa_2,'"','');
                TyPa_2 = [str2double(TyPa_2(1)), str2double(TyPa_2(2))] ;                       
                TzPa_2 = regexp(C{target{2,2}+5}, '\"(.+?)\"','match');
                TzPa_2 = strrep(TzPa_2,'"','');                
                TzPa_2 = [str2double(TzPa_2(1)), str2double(TzPa_2(2))]; 
                T_2 = [TxPa_2,TyPa_2,TzPa_2];
                if(sum(TxPa_2>TxPa_1) == 2 || sum(TxPa_2>TxPa_1) == 0)
                    display('test~~');
                    if(TxPa_1(2)<TxPa_2(1))
                        hfssRectangle(fid1, char(name_hfss{Modelindex,2}), 'X', [TxPa_1(2), TyPa_1(1), TzPa_1(1)], TyPa_1(2) - TyPa_1(1), TzPa_1(2) - TzPa_1(1), Unit);
                        hfssRectangle(fid1, 'temp2', 'X', [TxPa_2(1), TyPa_2(1), TzPa_2(1)], TyPa_2(2) - TyPa_2(1), TzPa_2(2) - TzPa_2(1), Unit); 
                    else                        
                        hfssRectangle(fid1, char(name_hfss{Modelindex,2})', 'X', [TxPa_1(1), TyPa_1(1), TzPa_1(1)], TyPa_1(2) - TyPa_1(1), TzPa_1(2) - TzPa_1(1), Unit);
                        hfssRectangle(fid1, 'temp2', 'X', [TxPa_2(2), TyPa_2(1), TzPa_2(1)], TyPa_2(2) - TyPa_2(1), TzPa_2(2) - TzPa_2(1), Unit);
                    end
                elseif(sum(TyPa_2>TyPa_1) == 2 || sum(TyPa_2>TyPa_1) == 0)
                    hfssRectangle(fid1, char(name_hfss{Modelindex,2}), 'Y', [TxPa_1(1), TyPa_1(1), TzPa_1(1)], TxPa_1(2) - TxPa_1(1), TzPa_1(2) - TzPa_1(1), Unit);
                    hfssRectangle(fid1, 'temp2', 'Y', [TxPa_2(1), TyPa_2(1), TzPa_2(1)], TzPa_2(2) - TzPa_2(1), Unit);
                elseif((sum(TzPa_2>TzPa_1) == 2 || sum(TzPa_2>TzPa_1) == 0))
                    hfssRectangle(fid1, char(name_hfss{Modelindex,2}), 'Z', [TxPa_1(1), TyPa_1(1), TzPa_1(1)], TyPa_1(2) - TyPa_1(1), TxPa_1(2) - TxPa_1(1), Unit);
                    hfssRectangle(fid1, 'temp2', 'Z', [TxPa_2(1), TyPa_2(1), TzPa_2(1)], TyPa_2(2) - TyPa_2(1), TxPa_2(2) - TxPa_2(1), Unit);
                else
                    Display('Can not convert!');
                end
                hfssConnect(fid1, {char(name_hfss{Modelindex,2}), 'temp2'});
                
                %hfssDelete();
            elseif(~isempty(strfind(C{k}, 'With Cylinder')))
%                 Shape = 2; 
                 while(k <= Eindex(Modelindex))
                    display(C{k});
                    k=k+1;
                    if(~isempty(strfind(C{k}, '.Name')))	
                        name{name_index,1} = regexp(C{k}, '\"(.+?)\"', 'match');  
                        name{name_index,1} = strrep(name{name_index,1},'"','');
                        name{name_index,2} = k;
						name_hfss{Modelindex} = k; 
                        name_hfss{Modelindex,2} = num2str(Modelindex); 
                    elseif(~isempty(strfind(C{k}, '.Component')))	
                        component{Modelindex} = regexp(C{k}, '\"(.+?)\"', 'match');
                        component{Modelindex} = strrep(component{Modelindex},'"','');
                    elseif(~isempty(strfind(C{k}, '.OuterRadius')))	
                        %OuterRadius = regexp(C{k}, '\d+','match');
                        OuterRadius = regexp(C{k}, '\"(.+?)\"', 'match');
                        OuterRadius = strrep(OuterRadius,'"','');
                        OuterRadius = str2double(OuterRadius);
                    elseif(~isempty(strfind(C{k}, '.InnerRadius')))
                        %InnerRadius = regexp(C{k}, '\d+','match');
                        InnerRadius = regexp(C{k}, '\"(.+?)\"', 'match');
                        InnerRadius = strrep( InnerRadius,'"','');
                        InnerRadius = str2double(InnerRadius);
                    elseif(~isempty(strfind(C{k}, '.Axis')))	
                        Taxis = regexp(C{k}, '"\w+"', 'match');                        
                        if(strcmp(Taxis, '"x"'))
                            axisIndex = 1;
                        elseif(strcmp(Taxis, '"y"'))
                            axisIndex = 2;
                        else
                            axisIndex = 3;
                        end
                    elseif(~isempty(strfind(C{k}, 'range')))
                        %Pa = regexp(C{k}, '\d+','match');
                        Pa = regexp(C{k}, '\"(.+?)\"','match');
                        Pa = strrep(Pa,'"','');
                        Pa = [str2double(Pa(1)), str2double(Pa(2))];
                        Height = Pa(2) - Pa(1);
                    elseif(~isempty(strfind(C{k}, '.Xcenter'))) 
                        %Xcenter = regexp(C{k}, '\d+','match');
                        Xcenter = regexp(C{k}, '\"(.+?)\"', 'match');
                        Xcenter = strrep(Xcenter,'"','');                        
                        Xcenter = str2double(Xcenter);
                    elseif(~isempty(strfind(C{k}, '.Ycenter'))) 
                        %Ycenter = regexp(C{k}, '\d+','match');
                        Ycenter = regexp(C{k}, '\"(.+?)\"', 'match');
                        Ycenter = strrep(Ycenter,'"','');   
                        Ycenter = str2double(Ycenter);
					elseif(~isempty(strfind(C{k}, '.Zcenter'))) 
                        %Ycenter = regexp(C{k}, '\d+','match');
                        Zcenter = regexp(C{k}, '\"(.+?)\"', 'match');
                        Zcenter = strrep(Zcenter,'"','');   
                        Zcenter = str2double(Zcenter);
                    else                       
                    end                    
                 end				
                hfssCylinder(fid1, char(name_hfss{Modelindex,2}), Axis{axisIndex}, [Xcenter, Ycenter, Pa(1)] ,OuterRadius, Height, Unit);  
			elseif(~isempty(strfind(C{k}, 'With Cone')))
%                  Shape = 3; 
                 while(k <= Eindex(Modelindex))
                    display(C{k});
                    k=k+1;
                    if(~isempty(strfind(C{k}, '.Name')))	
                        name{name_index,1} = regexp(C{k}, '\"(.+?)\"', 'match');  
                        name{name_index,1} = strrep(name{name_index,1},'"','');
                        name{name_index,2} = k;
						name_hfss{Modelindex} = k; 
                        name_hfss{Modelindex,2} = num2str(Modelindex); 
                    elseif(~isempty(strfind(C{k}, '.Component')))	
                        component{Modelindex} = regexp(C{k}, '\"(.+?)\"', 'match');
                        component{Modelindex} = strrep(component{Modelindex},'"','');
                    elseif(~isempty(strfind(C{k}, '.BottomRadius')))	
                        %OuterRadius = regexp(C{k}, '\d+','match');
                        BottomRadius = regexp(C{k}, '\"(.+?)\"', 'match');
                        BottomRadius = strrep(BottomRadius,'"','');
                        BottomRadius = str2double(BottomRadius);
                    elseif(~isempty(strfind(C{k}, '.TopRadius')))
                        %InnerRadius = regexp(C{k}, '\d+','match');
                        TopRadius = regexp(C{k}, '\"(.+?)\"', 'match');
                        TopRadius = strrep( TopRadius,'"','');
                        TopRadius = str2double(TopRadius);
                    elseif(~isempty(strfind(C{k}, '.Axis')))	
                        Taxis = regexp(C{k}, '"\w+"', 'match'); 						
                        if(strcmp(Taxis, '"x"'))
                            axisIndex = 1;
                        elseif(strcmp(Taxis, '"y"'))
                            axisIndex = 2;
                        else
                            axisIndex = 3;
                        end
                    elseif(~isempty(strfind(C{k}, 'range')))
                        %Pa = regexp(C{k}, '\d+','match');
                        Pa = regexp(C{k}, '\"(.+?)\"','match');
                        Pa = strrep(Pa,'"','');
                        Pa = [str2double(Pa(1)), str2double(Pa(2))];
                        Height = Pa(2) - Pa(1);
                    elseif(~isempty(strfind(C{k}, '.Xcenter')) && (axisIndex ~= 1)) 
                        %Xcenter = regexp(C{k}, '\d+','match');
                        Xcenter = regexp(C{k}, '\"(.+?)\"', 'match');
                        Xcenter = strrep(Xcenter,'"','');                        
                        Xcenter = str2double(Xcenter);
                    elseif(~isempty(strfind(C{k}, '.Ycenter'))  && (axisIndex ~= 2)) 
                        %Ycenter = regexp(C{k}, '\d+','match');
                        Ycenter = regexp(C{k}, '\"(.+?)\"', 'match');
                        Ycenter = strrep(Ycenter,'"','');   
                        Ycenter = str2double(Ycenter);
					elseif(~isempty(strfind(C{k}, '.Zcenter'))  && (axisIndex ~= 3))                     
						Zcenter = regexp(C{k}, '\"(.+?)\"', 'match');
                        Zcenter = strrep(Zcenter,'"','');   
                        Zcenter = str2double(Zcenter);
                    else                       
                    end                     
                 end
                if (axisIndex == 3)
					Cone_Center = [Xcenter, Ycenter, Pa(1)];
				elseif (axisIndex == 2)
					Cone_Center = [Xcenter, Pa(1), Zcenter];
				else
					Cone_Center = [Pa(1), Ycenter, Zcenter];
                end    
                 hfssCone(fid1, char(name_hfss{Modelindex,2}), Cone_Center,  Axis{axisIndex}, Height, BottomRadius, TopRadius, Unit);
			elseif(~isempty(strfind(C{k}, 'With Sphere')))
% 				Shape = 4;
				while(k <= Eindex(Modelindex))
					display(C{k});
					k=k+1;
                    if(~isempty(strfind(C{k}, '.Name')))	
                        name{name_index,1} = regexp(C{k}, '\"(.+?)\"', 'match');  
                        name{name_index,1} = strrep(name{name_index,1},'"','');
						name_hfss{Modelindex} = k;
                        name_hfss{Modelindex,2} = num2str(Modelindex); 
                    elseif(~isempty(strfind(C{k}, '.Component')))	
                        component{Modelindex} = regexp(C{k}, '\"(.+?)\"', 'match');
                        component{Modelindex} = strrep(component{Modelindex},'"','');
					elseif(~isempty(strfind(C{k}, '.CenterRadius')))	
                        Radius = regexp(C{k}, '\"(.+? )\"', 'match');
                        Radius = strrep(Radius,'"','');
                        Radius = str2double(Radius);
					elseif(~isempty(strfind(C{k}, '.Center')))
						CenterLoc = regexp(C{k}, '\"(.+?)\"', 'match');
						CenterLoc = strrep(CenterLoc,'"','');
                        CenterLoc = [str2double(CenterLoc(1)), str2double(CenterLoc(2)), str2double(CenterLoc(3))] ;
					end
                end 
                hfssSphere(fid1, char(name_hfss{Modelindex,2}), CenterLoc, Radius, Unit);
            end
            
%         if(Shape == 1)
%             hfssBox(fid1, char(name_hfss{Modelindex,2}), [0,0,0], [xPa(2)-xPa(1), yPa(2)-yPa(1), zPa(2)-zPa(1)],  Unit); 
%         elseif(Shape == 2)
%             hfssCylinder(fid1, char(name_hfss{Modelindex,2}), Axis{axisIndex}, [Xcenter, Ycenter, Pa(1)], OuterRadius, Height, Unit); 
%         elseif(Shape == 3)
%             %hfssCone(fid1, char(name_hfss{Modelindex,2}), Axis{axisIndex}, [Xcenter, Ycenter, Pa(1)], OuterRadius, Height, Unit); 
% 		elseif(Shape == 4)
% 			hfssSphere(fid1, char(name_hfss{Modelindex,2}), CenterLoc, Radius, Unit)
% 		else
%         end      
    elseif (find(Pindex == k))         
        if(~isempty(strfind(C{k}, 'PickFaceFromId')))
                 target_index = target_index + 1;
			     target{target_index,1} = regexp(C{k}, '\:(.+?)\"', 'match'); 
				 target{target_index,1} = strrep(target{target_index},'"','');
                 target{target_index,1} = strrep(target{target_index},':','');
        end       
        for(t = name_index: -1 : 1)
            if(strcmp(name{t,1}, target{target_index,1}))                
                target{target_index,2} = name{t,2};
            end
        end
        if(target_index == 2)
            target_index = 0;
        end
    else         
        if(~isempty(strfind(C{k}, 'Solid.Add')))
            tool = regexp(C{k}, '\:(.+?)\"', 'match'); 
            tool = strrep(tool,'"','');
            tool = strrep(tool,':','');
            hfssUnite(fid1, {tool{1}, tool{2}});
			name_index = name_index - 1;
     	elseif(~isempty(strfind(C{k}, 'Solid.Intersect ')))
            tool = regexp(C{k}, '\:(.+?)\"', 'match'); 
            tool = strrep(tool,'"','');
            tool = strrep(tool,':','');
            hfssIntersect(fid1, {tool{1}, tool{2}}, 'false');        
        
		elseif(~isempty(strfind(C{k}, 'Solid.Insert ')))
            tool = regexp(C{k}, '\:(.+?)\"', 'match'); 
            tool = strrep(tool,'"','');
            tool = strrep(tool,':','');
            hfssSubract(fid1, {tool{1}, tool{2}}, 'true');
            
		elseif(~isempty(strfind(C{k}, 'Solid.Subtract ')))
            tool = regexp(C{k}, '\:(.+?)\"', 'match'); 
            tool = strrep(tool,'"','');
            tool = strrep(tool,':','');
            hfssSubract(fid1, {tool{1}, tool{2}}, 'false');
        
		else
		end
        end 
    end
    
                 
	fclose(fid1);
	hfssExecuteScript('C:/"Program Files"/AnsysEM/HFSS15.0/Win64/hfss.exe', [pwd,'\hfssScript.vbs'],...
                      true, false);
	hfssRemovePaths('C:/Users/Administrator/Desktop/hfss-api-master/src/');
	rmpath('C:/Users/Administrator/Desktop/hfss-api-master');        
                
                
      
     
