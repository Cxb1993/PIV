%function that returns and graphs the behaviour of the desired velocity
%distribution as histogram 3D vs time
%   PARAMETERS:
%   matrix: contains the result of griding the velocity field using
%       getGridfield.
%   time: vector with the time line usualy calculated on the main funtion
%       using the names of the text files
%   vector: text chain asking for the horizontal and/or vertical velocities
%       u and v respectively, 'u' for just horizontal 'v' for just vertical,
%       'uv' or 'vu' for both.
%   n: number of intervals on the histogram [ n1 n2] n1 for the velocity
%       axe, n2 for the time axe
%   coordinates: either a text chain or a vector informing which cells of
%       the grided the user wants to get information on: 'all' for all the
%   cells or a matrix containing the specific subscripts of the grid 
%       ex: [1 2; 5 5; 3 3] returns information on  the cells (1,2), (5,5)
%       and (3,3)
%
function doTemporalHistogram3D(matrix, time, vector, n, coordinates)
figure(3)
figure(4)
clf(figure(3));
clf(figure(4));


if ischar(coordinates)
    k=1;
    if (strcmp(coordinates,'all'))
        coordinates=1*1;
        for i=1:size(matrix,1)
            for j=1:size(matrix,2)
                coordinates(k,1)=i;
                coordinates(k,2)=j;
                k=k+1;
            end
        end
     end
end


for i=1:size(coordinates,1)
     if strcmp(vector,'u') || strcmp(vector,'uv') || strcmp(vector,'vu')

        Umean(:,i)=matrix(coordinates(i,1),coordinates(i,2)).Umean;
        
     end
     if strcmp(vector,'v') || strcmp(vector,'uv') || strcmp(vector,'vu')
          Vmean(:,i)=matrix(coordinates(i,1),coordinates(i,2)).Vmean;
     end

    names{i}=['[ ' num2str(coordinates(i,1)) ' , ' num2str(coordinates(i,2)) ' ]' ];
    
    
    
end 


