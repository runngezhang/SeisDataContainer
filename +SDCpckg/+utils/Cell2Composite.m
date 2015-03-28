function co = Cell2Composite(cl)
    L = length(cl);
    assert(parpool_size()==L,'')
    co = Composite();
    for l=1:L
        co{l} = cl{l};
    end
end
