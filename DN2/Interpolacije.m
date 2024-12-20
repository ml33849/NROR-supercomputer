clc, clearvars
data=readmatrix('vozlisca_temperature_dn2.txt','NumHeaderLines',4);
x=data(:,1);
y=data(:,2);
T=data(:,3);
cells=readmatrix("celice_dn2.txt",'NumHeaderLines',2);

x_target=0.403;
y_target=0.503;

%scatteredInterpolant funkcija 
tic
F1=scatteredInterpolant(x,y,T,'linear','none');
T_target1=F1(x_target,y_target);
time1=toc;
fprintf('Temperatura v točki (%.3f, %.3f), z scatteredInterpolant je %.4f.\n čas te metode je %.6f sekund \n ', x_target, y_target, T_target1, time1);

%griddedInterpolant funkcija
nx=371;
ny=241;
x_grid0=unique(x);
y_grid0=unique(y);
[x_grid,y_grid]=ndgrid(x_grid0,y_grid0);
T_grid=reshape(T,nx,ny);
tic
F2=griddedInterpolant(x_grid,y_grid,T_grid,'linear','none');
T_target2=F2(x_target,y_target);
time2=toc;
fprintf('Temperatura v točki (%.3f, %.3f), z griddedInterpolant je %.4f.\n čas te metode je %.6f sekund \n', x_target, y_target, T_target2, time2);

% Lastna bilinearne interpolacije
tic;
cell_found = false;
for i = 1:size(cells, 1)
    vozlisca = cells(i, :);
  
    x1 = x(vozlisca(1)); y1 = y(vozlisca(1)); T11 = T(vozlisca(1));
    x2 = x(vozlisca(2)); y2 = y(vozlisca(2)); T21 = T(vozlisca(2));
    x3 = x(vozlisca(3)); y3 = y(vozlisca(3)); T12 = T(vozlisca(3));
    x4 = x(vozlisca(4)); y4 = y(vozlisca(4)); T22 = T(vozlisca(4));
  
    x_min = min([x1, x2, x3, x4]);
    x_max = max([x1, x2, x3, x4]);
    y_min = min([y1, y2, y3, y4]);
    y_max = max([y1, y2, y3, y4]);
    
    if (x_target >= x_min && x_target <= x_max && y_target >= y_min && y_target <= y_max)
        cell_found = true;
        break;
    end
end

% interpolacija znotraj celice
K1 = ((x_max - x_target) / (x_max - x_min)) * T11 + ...
     ((x_target - x_min) / (x_max - x_min)) * T21;
K2 = ((x_max - x_target) / (x_max - x_min)) * T12 + ...
     ((x_target - x_min) / (x_max - x_min)) * T22;
T_target3 = ((y_max - y_target) / (y_max - y_min)) * K1 + ...
            ((y_target - y_min) / (y_max - y_min)) * K2;

time3 = toc;
fprintf('Temperatura v točki (%.3f, %.3f), z lastno interpolacijo je %.4f.\n čas te metode je %.6f sekund \n', ...
    x_target, y_target, T_target3, time3);

%Max Temperatur in njena pozicija
[max_T, max_pozicija] = max(T_grid(:)); 
[row, col] = ind2sub(size(T_grid), max_pozicija);  
x_max = x_grid(row, col);
y_max = y_grid(row, col);
fprintf('Najvišja temperatura je %.4f in se pojavi v točki (%.3f, %.3f).\n', max_T, x_max, y_max);