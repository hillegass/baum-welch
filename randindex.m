function idx = randindex(probarray)
    x = rand();
    idx = 1;
    sum = probarray(idx);
    while sum < x
        idx = idx + 1;
        sum = sum + probarray(idx);
    end
end