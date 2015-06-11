function flag = inspmd()
    flag = parpool_size()==0;
    flag = flag && ~isempty(com.mathworks.toolbox.distcomp.pmode.SessionFactory.getCurrentSession);
end
