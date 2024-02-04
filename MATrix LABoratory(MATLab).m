clear;clc;
close all
%%

load data
t1 = clock;

%% 

[dim,~] = size(anchor);     
[anch, node] = size(netsa);  

netss = [netss,netsa'];                                       
netss = [netss;netsa,zeros(anch,anch)];        

% 

step = zeros(anch,node+anch);                  
path = zeros(anch,node+anch);                  

for i = 1:anch
    for j =1:node
        if netsa(i,j) ~= 0
            step(i,j) = 1;                      
        end
    end
end

s=1;         %                              

while(true)
    temp = step;                                                       
    for i = 1:anch                                                     
        for j =1:(node+anch)    
            for k = 1:(node+anch)
                if step(i,j) == s && netss(j,k) ~= 0 && step(i,k) == 0 
                    path(i,k) = j;                                     
                    step(i,k) = s + 1;                                 
                end
            end
        end
    end
    if isequal(temp, step)
        break;                                                         
    end
    s = s + 1;
end

for i = 1:anch
    step(i,node+i)=0;                      
end

%% 
dist = zeros(anch, node + anch);                                    

for i = 1 : anch
    for j = 1 :(node + anch)
        tmp_j = j;
        while(true)
            k = path(i, tmp_j);
            if(k == 0) 
                dist(i,j) = dist(i,j) + netsa(i,tmp_j);
                break;
            end
            dist(i,j) = dist(i, j) + netss(k, tmp_j);
            tmp_j = k;
        end
    end
end

%% 
xy = zeros(node,dim);       

for i = 1:node
    A = zeros(anch-1,dim);
    B = zeros(anch-1,1);
    
    for j = 1 : anch-1
        for k = 1:dim
            A(j,k) = 2 * (anchor(k,j)-anchor(k,anch)); % x y z
            B(j) = B(j) + anchor(k,j)^2 - anchor(k, anch)^2;
        end
        B(j) = B(j) + dist(anch,i)^2-dist(j,i)^2;
    end
    C = A\B;     % 
    xy(i,1) = C(1);
    xy(i,2) = C(2);
    if xy(i,1)>100
        xy(i,1)=100;
    elseif xy(i,1)<0
        xy(i,1)=0;
    end
    if xy(i,2)>100
        xy(i,2)=100;
    elseif xy(i,2)<0
        xy(i,2)=0;
    end
end

accuracy;  %
%% 