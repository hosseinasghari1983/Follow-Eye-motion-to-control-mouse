function BAS=patchandmovemouse(row,col,WIDTH,HEIGHT,BAS,DIVrow,DIVcol)

rowB=ceil(row/HEIGHT*DIVrow);
colB=ceil(col/WIDTH*DIVcol);
BAS(rowB,colB)=BAS(rowB,colB)+1;
AX=get(0,'screensize');


if BAS(rowB,colB)>4
    colB=DIVcol-colB;
    
    yP = [(rowB-1)*HEIGHT/DIVrow+1 (rowB)*HEIGHT/DIVrow+1 (rowB)*HEIGHT/DIVrow+1 (rowB-1)*HEIGHT/DIVrow+1 ];%[xLinePos1 (width+1) (width+1) xLinePos1];
    xP = [(colB)*WIDTH/DIVcol+1 (colB)*WIDTH/DIVcol+1 (colB + 1)*WIDTH/DIVcol+1 (colB + 1)*WIDTH/DIVcol+1];
    patch(xP, yP, 'r');
    BAS=BAS*0;        
    
%     keyboard
end
