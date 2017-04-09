function BAS=patchandmovemouse(row,col,WIDTH,HEIGHT,BAS,DIVrow,DIVcol)

% clc
% close all
% clear all
%
% test=webcam();
%
% test=snapshot(test);
%
% test=rgb2gray(test);
%
% imshow(test)
%
% row=10;
% col=100;
% WIDTH=size(test,2);
% HEIGHT=size(test,1);
% BAS=zeros(10,20);
% BAS(1,2)=5;


rowB=ceil(row/HEIGHT*DIVrow);
colB=floor(col/WIDTH*DIVcol);
BAS(rowB,colB)=BAS(rowB,colB)+1;
AX=get(0,'screensize');


%         xL1 = get(gca,'XLim');

% for i=1:DIVrow
%     line([0 WIDTH], [(i-1)*HEIGHT/DIVrow+1 (i-1)*HEIGHT/DIVrow+1],'Color','r');
% end
% %         yL1 = get(gca,'YLim');
% for i=1:DIVcol
%     line( [(i-1)*WIDTH/DIVcol+1 (i-1)*WIDTH/DIVcol+1], [0 HEIGHT],'Color','r');
% end

if BAS(rowB,colB)>4
    colB=DIVcol-colB;
    
    yP = [(rowB-1)*HEIGHT/DIVrow+1 (rowB)*HEIGHT/DIVrow+1 (rowB)*HEIGHT/DIVrow+1 (rowB-1)*HEIGHT/DIVrow+1 ];%[xLinePos1 (width+1) (width+1) xLinePos1];
    xP = [(colB-1)*WIDTH/DIVcol+1 (colB-1)*WIDTH/DIVcol+1 (colB)*WIDTH/DIVcol+1 (colB)*WIDTH/DIVcol+1];
    patch(xP, yP, 'r');
    
    %pos = [pos(1)+20,pos(2)-20];
    %robot.mouseMove(rowB/AX(2),colB/AX(1));
    BAS=BAS*0;
    
    
%     keyboard
end
