folder1='coordinateChange\Modified\';
folder0='coordinateChange\Originals\';
files=ls(folder0);
files=files(3:size(files,1),:);
for i=1:size(files,1)
   %analysePIV([folder0 files(i,:)], i,graph)
   scale(i,:)= changePIVcoordinates([folder0 files(i,:)],[folder1 files(i,:)],[0 70], [50 125],[true true]);
end
