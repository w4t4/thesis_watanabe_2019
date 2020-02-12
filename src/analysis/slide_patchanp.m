a = zeros(9,7);
for i = 1:7
    a(1,i) = np(1,1,i);
    for j = 1:8
        a(j+1,i) = np(10-j,1,i);
    end
end
ave = normalize(pave(1,:));
pd = fitdist(a(9,:)','normal');
ci = paramci(pd);

c = zeros(8,7);
for i = 1:7
    for j = 1:8
        c(j,i) = nv(9-j,3,i);
    end
end