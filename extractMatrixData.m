%Saves data from matrix structure to xls file
function data=extractMatrixData(matrix,header)
%put relevant data in cell

columns=18;
if(header)
	s=1;
    data=cell(numel(matrix)+1,columns);
    data(1,:)={ ...
        'xlim1 (mm)', ...
        'xlim2 (mm)', ...
        'ylim1 (mm)', ...
        'ylim2 (mm)', ...
        'K', ...
        'K_LB', ... 
        'K_UB', ... 
        'u0(m/s)', ...
        'u0_LB', ... 
        'u0_UB', ...
        'r^2', ... 
        'tau_choked (s)', ...
        'tau_p(s)', ...     
        'phi_p (m/s)', ...
        'v_choked0 (m/s)', ...
        'v_chokedf (m/s)', ...    
        't_sonic (s)', ...
        't_subsonic}'};
else
    s=0;
    data=cell(numel(matrix),columns);
end


for i=1:numel(matrix)
    data(i+s,:)={matrix(i).xlim(1), ...
        matrix(i).xlim(2),...
        matrix(i).ylim(1),...
        matrix(i).ylim(2),...
        matrix(i).fit.V.K,...
        matrix(i).fit.V.K_upper, ...
        matrix(i).fit.V.K_lower, ...
        matrix(i).fit.V.u0, ...
        matrix(i).fit.V.u0_upper, ...
        matrix(i).fit.V.u0_lower, ...
        matrix(i).fit.V.rsquare, ...
        matrix(i).fit.V.tau_choked, ...
        matrix(i).fit.V.tau_p, ...     
        matrix(i).fit.V.phi, ...
        matrix(i).fit.V.v_choked0, ...
        matrix(i).fit.V.v_chokedf, ...    
        matrix(i).fit.V.t_sonic, ...
        matrix(i).fit.V.t_subsonic};
    
        
        
end


    

