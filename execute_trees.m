function res_mean =  execute_trees(features, path)
    res_all = [];
%     myFolders = '/home/arslan/Documents/TNSM/p1203-matlab/trees';
    myFolders = path; 
    p=fullfile(myFolders,'*.csv');  
    d=dir(p);% dir struct of all pertinent .csv files
    n=length(d);        % how many there were
%     tree_matrix=cell(1,n);     % preallocate a cell array to hold results
    for i=1:n
      tree_matrix = csvread(d(i).name);  % read each file
      res = execute_tree(features, tree_matrix);
      res_all = [res_all; res];
%       res_all.append(res);
    end
    res_mean = mean(res_all);
  end
