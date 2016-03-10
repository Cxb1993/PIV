function CO=colorOrder(plotCoord,order,f,colorFunc)
if(iscell(plotCoord))
    plotCoord=mat2cell(unique(cell2mat(plotCoord),'rows'), ...
        ones(size(plotCoord,1),1)');
elseif(isnumeric(plotCoord) && isequal(size(plotCoord),[1 2]))
    m=plotCoord(1);
    n=plotCoord(2);
    r=repmat((1:m),[n,1]);
    r=r(:);
    
    plotCoord=[r repmat((1:n)',[m 1])];
    plotCoord=mat2cell(plotCoord,ones(m*n,1));
    
end
base=unique(cellfun(@(x)x(order),plotCoord));
basicColors=feval(colorFunc,size(base,1));

    freq=sum(cell2mat((cellfun(@(x)x(order)==base,plotCoord,...
            'uniformoutput',false)')),2);
if(order==1)


    s=zeros(size(freq,1),max(freq));
    
    for i=1:size(freq,1)
        if(freq(i)>1), t=1:-(1-f)/(freq(i)-1):f;else t=1; end
        s(i,1:freq(i))=t;
    end
  	CO=basicColors;
    for i=2:max(freq)
        r=basicColors.*repmat(s(:,i),[1 3]);
        r=r(s(:,i)~=0,:);
        CO=[CO;r];
    end
else
    CO=[];
    for i=1:size(freq,1)
        if(freq(i)>1), t=[1:-0.5/(freq(i)-1):0.5]';else t=1; end
        CO=[CO;repmat(basicColors(i,:),size(t)).*repmat(t,[1 3]) ];
    end
end


% colors=zeros([size(matrixUV) 3]);
% col=size(unique(cellfun(@(x)x(2),plotCoord)),1);
% lin=size(unique(cellfun(@(x)x(1),plotCoord)),1);