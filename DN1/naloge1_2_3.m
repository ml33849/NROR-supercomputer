format long
clc,clearvars
%1.naloga, branje datoteke naloga1_1.txt z funkcijami po izbiri
cas=importdata('naloga1_1.txt');
t=cas.data(:,1);

%2.naloga, branje datoteke z for zanko
fid=fopen('naloga1_2.txt');
line_1=fgetl(fid);
st_vrstic=sscanf(line_1,'%*[^0-9]%f', 1); %skenira in ignorira kar ni 0-9, nato pa vzame prvo št
P=[];
for i=2:1:st_vrstic+1
    line=str2double(fgetl(fid));
    P=[P;line];
    
end
figure(1);
plot(t,P,'b.');
xlabel('t[s]');
ylabel('P[W]');
title('graf P(t)');

%3.naloga racunanje integrala
%z formulo za ploščino enega intervala
sum1=0;
for a=1:99
    sum1=sum1+(P(a)+P(a+1))*(t(a+1)-t(a))/2;
end
sum1;

%z formulo za trapezno metodo
h=1/length(t);
sum2=P(1)+P(100);
for c=2:1:99
    sum2=sum2+2*P(c);

end
sum2=sum2*h/2;

sum3=trapz(t,P);